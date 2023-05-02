using System;
using System.Activities.Expressions;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.Utility;
using PatientPortal.DataLayer;

public partial class login : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        popupConfirmPassword.VisibleOnPageLoad = false;
        popupPractices.VisibleOnPageLoad = false;

        litResetPassword.Text = string.Empty;
        pShowError.InnerText = string.Empty;

        if (!Page.IsPostBack)
        {
            litMessage.Text = ClientSession.Message;
            //Clear Session
            ClientSession = new EndPointSession();
            ValidateQueryString();
            // For root path
            var information = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", new Dictionary<string, object>());
            foreach (DataRow row in information.Rows)
            {
                ClientSession.WebPathRootProvider = row["WebPathRootProvider"].ToString();
            }
        }



    }


    #region User Login

    private void BindPracticeDropdown()
    {
        cmbPractices.ClearSelection();
        cmbPractices.DataSource = SqlHelper.ExecuteDataTableProcedureParams("web_pr_practice_list", new Dictionary<string, object>());
        cmbPractices.DataBind();
    }

    protected void LoginButton_Click(object sender, EventArgs e)
    {
        try
        {
            if (!Page.IsValid)
            {
                litMessage.Text = "Incorrect Username or Password";
            }
            else
            {

                var userLogin = new UserLogin();
                userLogin.Login(txtPracticeID.Text.Trim(), txtUserName.Text.Trim(), txtPassword.Text.Trim());

                if (!userLogin.FlagPrWebActive)
                {
                    Response.Redirect("~/maintenance.aspx");
                }

                if (userLogin.ReturnCode == 2 || userLogin.ReturnCode == 3)
                {
                    lblSecurityQuestion.Text = userLogin.SecurityQuestion;
                    ViewState["UserNameandPracticeID"] = txtUserName.Text + "," + txtPracticeID.Text;
                    litResetPassword.Text = "<p style='margin-left: 1px;'><img src='content/images/help.png' alt='Help' style='position:absolute; margin-top:4px;'/>&nbsp; &nbsp; &nbsp; <a href='javascript:;' onclick='resetPassword()'><u style='text-decoration: none;'>Having trouble signing in? </u></a></p>";
                }

                if (userLogin.ReturnCode != 0)
                {
                    litMessage.Text = "<p style='color: red;'><img src='content/images/icon_error.gif' alt='Error' style='position:absolute; margin-top:3px;'>&nbsp; &nbsp; &nbsp; " + userLogin.ReturnMessage + "</p>";
                    return;
                }

                if (userLogin.FlagSysAdmin)
                {
                    BindPracticeDropdown();
                    ViewState["LoginDetails"] = new Dictionary<string, string> { { "UserName", txtUserName.Text.Trim() }, { "PracticeID", txtPracticeID.Text }, { "Password", txtPassword.Text } };
                    popupPractices.VisibleOnPageLoad = true;
                    return;
                }

                CreateAuthenticationTicket(txtUserName.Text.Trim());
                Response.Redirect(userLogin.LandingPage);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    private void CreateAuthenticationTicket(String userName)
    {
        var ticket = new FormsAuthenticationTicket(1, userName, DateTime.Now, DateTime.Now.AddDays(7), true, string.Empty);
        var cookiestr = FormsAuthentication.Encrypt(ticket);
        var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, cookiestr) { Path = FormsAuthentication.FormsCookiePath };
        Response.Cookies.Add(cookie);
    }

    protected void btnPractice_OnClick(object sender, EventArgs e)
    {
        string practiceID, username, password;
        var values = ViewState["LoginDetails"] as Dictionary<string, string>;
        values.TryGetValue("UserName", out username);
        values.TryGetValue("Password", out password);
        values.TryGetValue("PracticeID", out practiceID);

        var userLogin = new UserLogin();
        userLogin.Login(practiceID, username, password, Int32.Parse(cmbPractices.SelectedValue));

        Response.Redirect("~/patient/search.aspx");
    }

    #endregion

    #region Reset Password

    protected void btnResetPassword_OnClick(object sender, EventArgs e)
    {
        var userNameandPracticeID = ViewState["UserNameandPracticeID"].ToString();
        var values = userNameandPracticeID.Split(',');
        var cmdParams = new Dictionary<string, object>
                            {
                                {"UserName", values[0]},
                                {"PracticeloginID", values[1]},
                                {"SecurityAnswer",txtSecurityAnswer.Text},
                                {"FlagReset",1},
                                {"@IPAddress", ClientSession.IPAddress}
                            };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_login", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            var returnCode = (int)row["ReturnCode"];
            if (returnCode == 11)
            {
                var email = row["Email"].ToString();
                var nameFirst = row["NameFirst"].ToString();
                var resetLinkUserID = row["ResetLinkUserID"].ToString();
                var resetLinkURLSuffix = row["ResetLinkURLSuffix"].ToString();
                var expiration = row["ResetLinkURLExpireAbbr"].ToString();
                EmailServices.SendResetPasswordLink(email, resetLinkURLSuffix, expiration, nameFirst, Request.Url.ToString(), resetLinkUserID);
                RadWindow.RadAlert(row["ReturnMsg"].ToString(), 500, 120, "", "redirectPage", "Content/Images/success.png");
                hdnHideResetPopup.Value = "true";
            }
            else if (returnCode == 13)
            {
                pShowError.InnerText = row["ReturnMsg"].ToString();
            }
            else
            {
                hdnResetMessage.Value = row["ReturnMsg"].ToString();
                hdnHideResetPopup.Value = "1";
            }
        }
    }

    protected void btnConfirmPassword_OnClick(object sender, EventArgs e)
    {
        var queryStrings = ViewState["QueryStrings"].ToString();
        var values = queryStrings.Split(',');

        var cmdParams = new Dictionary<string, object>
                            {
                                {"@ResetLinkUserID", values[0]},
                                {"@ResetLinkURLSuffix", values[1]},
                                {"@SecurityAnswer",txtConfirmAnswer.Text},
                                {"@FlagReset",1},
                                {"@IPAddress", ClientSession.IPAddress}
                            };

        var userLogin = new UserLogin();
        userLogin.ResetPassword(cmdParams);

        if (userLogin.ReturnCode == 10)
        {
            CreateAuthenticationTicket(txtUserName.Text.Trim());

            // For auto select the user on the users.aspx
            ClientSession.ObjectType = ObjectType.Reset;
            ClientSession.ObjectID = ClientSession.UserID;
            hdnIsClosePopup.Value = "1";
            RadWindow.RadAlert(userLogin.ReturnMessage, 500, 120, "", "redirectToUsers", "Content/Images/success.png");
        }
        else if (userLogin.ReturnCode == 15)
        {
            pshowConfirmPopupError.InnerText = userLogin.ReturnMessage;
        }
        else
        {
            hdnConfirmMessage.Value = userLogin.ReturnMessage;
            hdnHideConfirmPopup.Value = "1";
        }
    }

    private void ValidateQueryString()
    {
        // Below are the variables which using in the QueryString
        var u = Request.QueryString["u"];
        var v = Request.QueryString["v"];
        var k = Request.QueryString["k"];

        if (v != null && Convert.ToInt32(v) == 0)
        {
            const string message = "Thank you for notifying us. The security team has been notified. If you received several of these emails or believe your account has been compromised please contact your practice administrator and call CareBlue support at (866) 220-2500.";
            RadWindow.RadAlert(message, 500, 120, "", "redirectPage", "Content/Images/success.png");

            var cmdParams = new Dictionary<string, object> { { "@LogTypeID", 1 }, { "@LogTypeName", "PWReset" }, { "ResetLinkUserID", u }, { "@IPAddress", ClientSession.IPAddress } };
            SqlHelper.ExecuteScalarProcedureParams("sys_sysuserlog_add", cmdParams);

        }
        else if (!string.IsNullOrEmpty(u) && !string.IsNullOrEmpty(u))
        {
            var cmdParams = new Dictionary<string, object> { { "@FlagReset", 1 }, { "@ResetLinkUserID", u }, { "ResetLinkURLSuffix", k }, { "@IPAddress", ClientSession.IPAddress } };
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_login", cmdParams);
            foreach (DataRow row in reader.Rows)
            {
                if ((int)row["ReturnCode"] != 14)
                {
                    RadWindow.RadAlert(row["ReturnMsg"].ToString(), 500, 120, "", "redirectPage", "Content/Images/warning.png");
                    return;
                }

                ViewState["QueryStrings"] = u + "," + k;
                lblConfirmQuestion.Text = row["SecurityQuestionAbbr"].ToString();
                popupConfirmPassword.VisibleOnPageLoad = true;
            }
        }
    }
    #endregion
}
