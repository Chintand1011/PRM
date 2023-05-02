using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mime;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;

public partial class Patient_Login : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Page.IsPostBack) return;

        // Validate and redirect to mobile site
        ValidateMobileRequestandPopulateFields();

        litMessage.Text = ClientSession.Message;
        //Clear Session
        ClientSession = new EndPointSession();
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", new Dictionary<string, object>());
        foreach (DataRow row in reader.Rows)
        {
            ClientSession.WebPathRootPatient = row["WebPathRootPatient"].ToString();
        }
    }

    private void ValidateMobileRequestandPopulateFields()
    {
        var isMobileDevice = Request.Browser.IsMobileDevice;
        var lastName = Request.Params["ln"];
        var accountID = Request.Params["aid"];
        var site = Request.Params["site"] ?? "0";

        if (isMobileDevice && !site.Equals("1"))
        {
            var firstName = Request.Params["fn"];
            var statementID = Request.Params["sid"];
            var practiceName = Request.Params["pn"];

            Response.Redirect(string.Format("https://prm.careblue.com/patient/m?aid={0}&sid={1}&fn={2}&ln={3}&pn={4}", accountID, statementID, firstName, lastName, practiceName));
        }
        else
        {
            txtLastName.Text = lastName;
            txtAccountID.Text = CryptorEngine.Decrypt(accountID);
        }

    }

    protected void LoginButton_Click(object sender, EventArgs e)
    {
        try
        {
            // Validating the SSNCode and Pincode
            if ((txtSSNCode.Text == string.Empty && txtPINCode.Text == string.Empty) || (txtSSNCode.Text != string.Empty && txtPINCode.Text != string.Empty))
            {
                RadWindow.RadAlert("Please enter SSN or PIN", 380, 100, "", "", "content/images/warning.png");
                ClearSSNandPincode();
                return;
            }


            if (!Page.IsValid)
            {
                litMessage.Text = "<img src='content/images/icon_error.gif'; style='margin-bottom:-3px;'>&nbsp; We can not find any matching records, please correct the information and resubmit.";
                // resting the pincode and ssn
                ClearSSNandPincode();
            }
            else
            {
                // validating the age
                var age = DateTime.Today.Year - Convert.ToDateTime(dtDateofBirth.SelectedDate).Year;
                if (age < 18)
                {
                    litMessage.Text = "<img src='content/images/icon_error.gif'; style='margin-bottom:-3px;'>&nbsp; You must be 18 years or older to login.";
                    ClearSSNandPincode();
                    return;
                }

                // Initializing the clientsession values if any error occurred during this process then being redirected to the maintenance.aspx
                var isRedirectToMaintenace = ValidateandAssignValuesIntoClientSession();
                if (isRedirectToMaintenace)
                    Response.Redirect("~/maintenance.aspx");

                // FlagPtWebActive == 1/true then being redirected to the maintenance.aspx
                if (!Convert.ToBoolean(ViewState["FlagPtWebActive"]))
                    Response.Redirect("~/maintenance.aspx");

                // validating the Login credentials.
                var dataTable = ValidateUser(txtAccountID.Text.Trim(), txtLastName.Text.Trim(), dtDateofBirth.SelectedDate, txtPINCode.Text.Trim(), txtSSNCode.Text.Trim());
                if (dataTable.Rows.Count > 0)
                {
                    var ptID = (int)dataTable.Rows[0]["PatientID"];
                    var flagLocked = (int)dataTable.Rows[0]["FlagLocked"];
                    if (ptID == 0)
                    {
                        if (flagLocked == 1)
                        {
                            litMessage.Text = "<img src='content/images/icon_error.gif'; style='margin-bottom:-3px;'>&nbsp; Too many failed attempts have been recorded from this computer. Please try your request again in 10 minutes.";
                            ClearSSNandPincode();
                            return;
                        }
                        else
                        {
                            litMessage.Text = "<img src='content/images/icon_error.gif'; style='margin-bottom:-3px;'>&nbsp; The information submitted does not match any active records. Please check and resubmit.";
                            ClearSSNandPincode();
                            return;
                        }
                    }
                    else
                    {
                        if (flagLocked == 1)
                        {
                            litMessage.Text = "<img src='content/images/icon_error.gif'; style='margin-bottom:-3px;'>&nbsp; Too many failed attempts have been recorded from this computer. Please try your request again in 10 minutes.";
                            ClearSSNandPincode();
                            return;
                        }

                        CreateAuthenticationTicket(txtAccountID.Text.Trim());
                        ClientSession.AccountID = Convert.ToInt32(txtAccountID.Text.Trim());
                        ClientSession.PatientID = (int)dataTable.Rows[0]["PatientID"];
                        ClientSession.ProviderID = (int)dataTable.Rows[0]["ProviderID"];
                        ClientSession.PracticeID = (int)dataTable.Rows[0]["PracticeID"];
                        //  ClientSession.UserID = (int)dataTable.Rows[0]["UserID"];
                        ClientSession.FirstName = dataTable.Rows[0]["NameFirst"].ToString();
                        ClientSession.LastName = dataTable.Rows[0]["NameLast"].ToString();
                        ClientSession.DateOfBirth = dataTable.Rows[0]["DateOfBirth"].ToString();
                        //ClientSession.UserName = dataTable.Rows[0]["UserName"].ToString();
                        //ClientSession.PracticeName = dataTable.Rows[0]["PracticeName"].ToString();
                        ClientSession.IsAllowBlueCredit = dataTable.Rows[0]["FlagMenuBC"].ToString() == "True";
                        ClientSession.IsAllowPaymentPlans = dataTable.Rows[0]["FlagMenuPP"].ToString() == "True";
                        ClientSession.SessionTimeout = (int)dataTable.Rows[0]["SessionTimeout"];
                        ClientSession.LogoName = dataTable.Rows[0]["LogoName"].ToString();
                        ClientSession.LogoWidth = (int)dataTable.Rows[0]["LogoWidth"];
                        ClientSession.LogoHeight = (int)dataTable.Rows[0]["LogoHeight"];
                        ClientSession.BlueCreditQualMin = decimal.Parse(dataTable.Rows[0]["BlueCreditQualMin"].ToString());
                        ClientSession.BlueCreditQualMax = decimal.Parse(dataTable.Rows[0]["BlueCreditQualMax"].ToString());
                        Response.Redirect("~/welcome.aspx");
                    }
                }
                litMessage.Text = "<img src='content/images/icon_error.gif'; style='margin-bottom:-3px;'>&nbsp; The information submitted does not match any active records. Please check and resubmit.";
                ClearSSNandPincode();
            }
        }
        catch (Exception)
        {
            throw;
        }
    }

    

    private void ClearSSNandPincode()
    {
        txtSSNCode.Text = string.Empty;
        txtPINCode.Text = string.Empty;
    }

    private void CreateAuthenticationTicket(String userName)
    {
        // Creating the cookie
        var ticket = new FormsAuthenticationTicket(1, userName, DateTime.Now, DateTime.Now.AddDays(7), true, UserType.Patient.ToString());
        var cookiestr = FormsAuthentication.Encrypt(ticket);
        var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, cookiestr) { Path = FormsAuthentication.FormsCookiePath };
        Response.Cookies.Add(cookie);
    }

    private DataTable ValidateUser(string accountID, string nameLast, DateTime? dateofBirth, string pinCode, string ssnCode)
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@AccountID", accountID},
                                {"@NameLast", nameLast},
                                {"@DOB", dateofBirth},
                                {"@PINCode", pinCode},
                                {"@SSNCode", ssnCode},
                                {"@IPAddress", ClientSession.IPAddress}
                            };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pt_login", cmdParams);
    }


    private bool ValidateandAssignValuesIntoClientSession()
    {
        try
        {
            var cmdParams = new Dictionary<string, object>();
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", cmdParams);
            foreach (DataRow row in reader.Rows)
            {
                ClientSession.NotePatientSite = row["NotePatientSite"].ToString();
                ClientSession.MaintPtWebNote = row["MaintPtWebNote"].ToString();
                ClientSession.WebPathRootPatient = row["WebPathRootPatient"].ToString();
                ViewState["FlagPtWebActive"] = row["FlagPtWebActive"].ToString();
            }
            return false;
        }
        catch (Exception)
        {
            var lastErrorWrapper = Server.GetLastError() as HttpException;
            Exception lastError = lastErrorWrapper;
            if (lastErrorWrapper != null && lastErrorWrapper.InnerException != null)
                lastError = lastErrorWrapper.InnerException;
            else
                return true;

            var errorType = lastError.GetType().ToString();
            var errorMessage = lastError.Message;
            var errorStackTrace = lastError.StackTrace;

            // Get Message type of HTML
            var clientSession = Extension.ClientSession;
            var htmlErrorMessage = lastErrorWrapper.GetHtmlErrorMessage();
            var sqlData = SqlHelper.GetSqlData(lastError.Data);
            EmailServices.SendRunTimeErrorEmail(HttpContext.Current.Request.RawUrl, errorType, errorMessage, errorStackTrace, htmlErrorMessage, clientSession.UserName, clientSession.LastName + ", " + clientSession.FirstName, clientSession.DateOfBirth, clientSession.PracticeName, clientSession.UserID, clientSession.PatientID, clientSession.PracticeID, clientSession.IPAddress, sqlData);
            return true;
        }

    }


}
