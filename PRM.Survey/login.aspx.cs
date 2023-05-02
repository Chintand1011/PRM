using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using PatientPortal.DataLayer;

public partial class Login : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack) return;


        ClearSession();
        AutoPopulateValuesFromUrl();
        ValidateAndAutoLogin();
    }

    private void AutoPopulateValuesFromUrl()
    {
        var surveyCode = Request.Params["s"];
        var authCode = Request.Params["a"];

        if (!string.IsNullOrEmpty(surveyCode))
        {
            txtSurveyCode.Text = surveyCode;
        }

        if (!string.IsNullOrEmpty(authCode))
        {
            txtPassword.Attributes.Add("Value", authCode);
            txtPassword.Text = authCode;
        }

    }


    protected void btnProcessLogin_OnClick(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txtSurveyCode.Text) || string.IsNullOrEmpty(txtPassword.Text))
        {
            ShowNotificationMessage(NotificationType.Danger, "Login credentials are required");
            return;
        }

        var cmdParams = new Dictionary<string, object>
        {
            {"@SurveyCode", txtSurveyCode.Text},
            {"@PINCode", txtPassword.Text},
            {"@IPAddress", GetIpAddress},
        };

        var results = SqlHelper.ExecuteDataTableProcedureParams("web_pr_survey_login", cmdParams).Rows[0];
        if (results["ReturnCode"].ToInteger() != 0)
        {
            ShowNotificationMessage(NotificationType.Danger, results["ReturnMsg"].ToString());
            return;
        }

        // Login success - 
        InitializeSession();
        ClientSession.UserData = results;

        // Now take the user to the survey page
        Response.Redirect("~/dashboard.aspx");

    }

    private void ValidateAndAutoLogin()
    {
        if (!(string.IsNullOrEmpty(txtSurveyCode.Text) || string.IsNullOrEmpty(txtPassword.Text)))
        {
            btnProcessLogin_OnClick(new object(), new EventArgs());
        }
    }

}
