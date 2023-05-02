using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using PatientPortal.Utility;
using PatientPortal.DataLayer;

public partial class qualify_apply : Page
{
    private string PracticeID { get { return ViewState["PracticeID"].ToString(); } }
    private string PracticeRef { get { return Request.Params["i"]; } }
    private string SiteRef { get { return Request.Params["r"]; } }

    private string ReferrerUrl
    {
        get
        {
            if (ViewState["UrlReferrer"] == null)
            {
                ViewState["UrlReferrer"] = Request.UrlReferrer != null ? Request.UrlReferrer.AbsoluteUri : string.Empty;
            }

            return ViewState["UrlReferrer"].ToString();
        }
    }

    private string IpAddress
    {
        get
        {
            var ip = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ??
                     HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];

            return ip;
        }
    }

    public string HTMLBackgroundColor { get { return ViewState["BGColor"].ToString(); } }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack) return;

        try
        {
            GetCreditPracticeDetails();
            BindStates();
            BindCreditClass();
            BindServiceType();
        }
        catch (Exception)
        {
            Response.Redirect("error.html");
        }
    }


    private void GetCreditPracticeDetails()
    {
        string practiceID = null;

        var cmdParams = new Dictionary<string, object>
        {
            {"@PracticeRef", PracticeRef},
            {"@SiteRef", SiteRef},
            {"@Referrer", ReferrerUrl}
        };


        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_creditpractice_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            practiceID = row["PracticeID"].ToString();
            lblPractice.Text = row["Name"].ToString();
            lblPhoneMain.Text = row["PhoneMain"].ToString();
            lblHTMLWelcome.Text = row["HTMLWelcome"].ToString();
            imgLogo.ImageUrl = "~/Content/Images/Providers/" + row["InvLogoName"];
            imgLogo.Width = int.Parse(row["InvLogoWidth"].ToString());
            imgLogo.Height = int.Parse(row["InvLogoHeight"].ToString());
            ViewState["BGColor"] = row["HTMLBackgroundColor"].ToString();
            ViewState["NotificationEmail"] = row["NotificationEmail"].ToString();
        }
        ViewState["PracticeID"] = practiceID;

        // for fast forward year difference
        dtDateofBirth.Calendar.FastNavigationStep = 12;
    }

    private void BindServiceType()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", PracticeID } };
        var serviceTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_creditservicepractice_list", cmdParams);

        cmbServiceType.DataSource = serviceTypes;
        cmbServiceType.DataBind();
    }

    private void BindStates()
    {
        var cmdParams = new Dictionary<string, object>();
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", cmdParams);

        cmbStates.DataSource = states;
        cmbStates.DataBind();
    }

    private void BindCreditClass()
    {
        var cmdParams = new Dictionary<string, object>();
        var credit = SqlHelper.ExecuteDataTableProcedureParams("web_pr_creditclasstype_list", cmdParams);

        cmbCreditType.DataSource = credit;
        cmbCreditType.DataBind();
    }


    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        try
        {
            var cmdParam = new Dictionary<string, object>
        {
            {"@PracticeID", PracticeID},
            {"@CreditServiceTypeID", cmbServiceType.SelectedValue},
            {"@CreditClassTypeID", cmbCreditType.SelectedValue},
            {"@SiteRef", SiteRef},
            {"@Referrer", ReferrerUrl},
            {"@IPAddress", IpAddress},
            {"@FirstName", txtFirstName.Text},
            {"@LastName", txtLastName.Text},
            {"@DateofBirth", dtDateofBirth.SelectedDate ?? (object)DBNull.Value},
            {"@Address1", txtStreet.Text},
            {"@Address2", txtAptSuite.Text},
            {"@City", txtCity.Text},
            {"@StateTypeID", cmbStates.SelectedValue},
            {"@ZipCode", txtZipCode.Text},
            {"@Phone", txtPhone.Text},
            {"@Email", txtEmailAddress.Text},
            {"@PatientComment", txtComments.Text},
            {"@FlagCurrentPatient", IsPatient.SelectedValue}
        };

            var htmlResponse = SqlHelper.ExecuteScalarProcedureParams("web_pr_creditapplication_add", cmdParam);
            htmlResponse = htmlResponse ?? "<p>Thank you for your interest. A member from our team is normally able to review your details and contact you the same day. If you need to reach the office before then, please contact us at the number above. </p>";
            
            divFields.InnerHtml = htmlResponse.ToString();
            imgClose.Visible = true;

            // Sending email
            var fields = new Dictionary<string, string>
            {
                {"FirstName", txtFirstName.Text},
                {"LastName", txtLastName.Text},
                {"City", txtCity.Text},
                {"State", cmbStates.SelectedItem.Text},
                {"ServiceType", cmbServiceType.SelectedItem.Text},
                {"NotificationEmail", ViewState["NotificationEmail"].ToString()},
                {"PhoneNumber", txtPhone.TextWithLiterals},
                {"PatientEmail", txtEmailAddress.Text},
                {"Comments", txtComments.Text},
                {"IsCurrentPatient", IsPatient.SelectedValue == "1" ? "Yes" : "No"}
            };

            EmailServices.SendCreditPracticeNotificationEmail(fields);
        }
        catch (Exception)
        {
            Response.Redirect("error.html");
        }
    }

}