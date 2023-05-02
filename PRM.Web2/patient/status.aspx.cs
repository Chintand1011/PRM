using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;
using Telerik.Web.UI.HtmlChart.PlotArea;

public partial class status : BasePage
{
    #region Welcome Detail's Properties

    public string PracticeName { get; set; }
    public string ProviderName { get; set; }
    public string Addr1 { get; set; }
    public string Addr2 { get; set; }
    public string City { get; set; }
    public string StateAbbr { get; set; }
    public string Zip { get; set; }
    public string Phone { get; set; }
    public string Fax { get; set; }
    public string LogoName { get; set; }
    public string LogoWidth { get; set; }
    public string LogoHeight { get; set; }
    public string BouncedEmailError { get; set; }

    public Int32 StatementCount { get; set; }
    public string Balance { get; set; }
    public string AmountPaid { get; set; }
    public string AmountPastDue { get; set; }
    public Int32 BlueCreditCount { get; set; }
    public Int32 PayPlanCount { get; set; }
    public Int32 PendingRequestCount { get; set; }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (ClientSession.SelectedPatientID == 0) Response.Redirect("search.aspx");

        if (!Page.IsPostBack)
        {
            GetPatientNote();
            GetStatusDetails();
            GetPatientInformation();
            PatientStatusChecks();
        }

    }



    private void GetPatientNote()
    {
        var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.SelectedPatientID },
                                    { "@UserID", ClientSession.UserID}
                                };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_ptnotegen_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            txtNote.Text = row["NoteGeneral"].ToString();
        }
    }


    private void GetStatusDetails()
    {
        var cmdParam = new Dictionary<string, object>
                           {
                               {"@AccountID",ClientSession.SelectedPatientAccountID},
                               { "@UserID", ClientSession.UserID}
                           };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pt_welcome_get", cmdParam);
        foreach (DataRow row in reader.Rows)
        {
            PracticeName = row["PracticeName"].ToString();
            ProviderName = row["ProviderName"].ToString();
            Addr1 = row["Addr1"].ToString();
            Addr2 = row["Addr2"].ToString();
            City = row["City"].ToString();
            StateAbbr = row["StateAbbr"].ToString();
            Zip = row["Zip"].ToString();
            Phone = row["Phone"].ToString();
            Fax = row["Fax"].ToString();
            LogoName = row["LogoName"].ToString();
            LogoWidth = row["LogoWidth"].ToString();
            LogoHeight = row["LogoHeight"].ToString();


            if ((int)row["EmailBounceCnt"] > 0)
            {
                BouncedEmailError = "<img src='../content/images/icon_error.gif'; style='margin-bottom:-3px;'>&nbsp; Last email attempt was unsuccessful, <br/>please verify the email addresses on file.";
            }

            lblLastWebLogin.Text = row["LastLoginWeb"].ToString();
            lblLastMobileLogin.Text = row["LastLoginMobile"].ToString();

        }
    }

    private void GetPatientInformation()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@UserID", ClientSession.UserID } };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            var patient = string.Format("{0} {1}", row["NameFirst"] + " " + row["NameLast"], row["GenderAbbr1"]);
            lblPatient.Text = patient;

            lblDOB.Text = row["DateofBirth"].ToString();
            lblSocial.Text = row["PatientSSN4Abbr"].ToString();

            var flagGuardianExists = Convert.ToBoolean(row["FlagGuardianExists"]);
            if (flagGuardianExists)
            {
                divGuardian.Visible = true;
                var guardian = string.Format("{0} ({1})", row["GuardianFirst"] + " " + row["GuardianLast"], row["GuardianRelTypeAbbr"]);
                lblGuardian.Text = guardian;
            }

            lblInsurer.Text = row["InsName"].ToString();
            lblAccountID.Text = row["AccountID"].ToString();
            lblMRNNumber.Text = row["MRN"].ToString();
            lblProvider.Text = row["ProviderAbbr"].ToString();
            lblLocation.Text = row["LocName"].ToString();


            var appSuite = string.IsNullOrEmpty(row["Addr2Pri"].ToString()) ? string.Empty : row["Addr2Pri"] + "<br />";
            var phone1 = string.IsNullOrEmpty(row["PhonePriAbbr"].ToString()) ? string.Empty : row["PhonePriAbbr"] + "<br />";
            var phone2 = string.IsNullOrEmpty(row["PhoneSecAbbr"].ToString()) ? string.Empty : row["PhoneSecAbbr"] + "<br />";
            var email = string.IsNullOrEmpty(row["Email"].ToString()) ? string.Empty : row["Email"] + "<br />";

            litAddress.Text = string.Format("{0} <br />" +
                                            "{1}" +
                                            "{2} <br>" +
                                            "{3} {4} {5}", row["Addr1Pri"], appSuite, row["AddrCSZPri"], phone1, phone2, email);


            var streetAddress = string.IsNullOrEmpty(row["Addr1Sec"].ToString()) ? string.Empty : row["Addr1Sec"] + "<br />";
            appSuite = string.IsNullOrEmpty(row["Addr2Sec"].ToString()) ? string.Empty : row["Addr2Sec"] + "<br />";
            var cityStateandZip = string.IsNullOrEmpty(row["AddrCSZSec"].ToString()) ? string.Empty : row["AddrCSZSec"] + "<br />";

            litAlternate.Text = streetAddress + appSuite + cityStateandZip;
            lblWebPIN.Text = row["PINCode"].ToString();
        }
    }

    private void PatientStatusChecks()
    {
        var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.SelectedPatientID },
                                    { "@PracticeID", ClientSession.PracticeID },
                                    { "@UserID", ClientSession.UserID}
                                };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patientcheck_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            // Services Count
            StatementCount = Int32.Parse(row["CntStatement"].ToString());
            Balance = ((decimal)row["AmtBalance"]).ToString("c");
            AmountPaid = ((decimal)row["AmtPaid"]).ToString("c");
            AmountPastDue = ((decimal)row["AmtPastDue"]).ToString("c");
            BlueCreditCount = Int32.Parse(row["CntBlueCredit"].ToString());
            PayPlanCount = Int32.Parse(row["CntPayPlan"].ToString());
            PendingRequestCount = Int32.Parse(row["CntPendingReq"].ToString());

            // Flags
            var flagId = Int32.Parse(row["FlagAge"].ToString());
            if (flagId >= 0)
            {
                divAge.Visible = true;
                imgAge.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }


            flagId = Int32.Parse(row["FlagProfile"].ToString());
            if (flagId >= 0)
            {
                divProfile.Visible = true;
                imgProfile.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }


            flagId = Int32.Parse(row["FlagIdent"].ToString());
            if (flagId >= 0)
            {
                divIdent.Visible = true;
                imgIdent.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }


            flagId = Int32.Parse(row["FlagSSN"].ToString());
            if (flagId >= 0)
            {
                divSsn.Visible = true;
                imgSsn.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }


            flagId = Int32.Parse(row["FlagTUPFS"].ToString());
            if (flagId >= 0)
            {
                divTUFS.Visible = true;
                imgTUFS.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }

            flagId = Int32.Parse(row["FlagCheckCard"].ToString());
            if (flagId >= 0)
            {
                divCheckCard.Visible = true;
                imgCheckCard.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }

            flagId = Int32.Parse(row["FlagIns"].ToString());
            if (flagId >= 0)
            {
                divIns.Visible = true;
                imgIns.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }

            flagId = Int32.Parse(row["FlagEligibility"].ToString());
            if (flagId >= 0)
            {
                divEligibilty.Visible = true;
                imgEligibilty.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }

            flagId = Int32.Parse(row["FlagTransactions"].ToString());
            if (flagId >= 0)
            {
                divTransaction.Visible = true;
                imgTransaction.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }

            flagId = Int32.Parse(row["FlagValidEmail"].ToString());
            if (flagId >= 0)
            {
                divValidEmail.Visible = true;
                imgValidEmail.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }

            flagId = Int32.Parse(row["FlagEmailBounce"].ToString());
            if (flagId >= 0)
            {
                divEmailBounce.Visible = true;
                imgEmailBounce.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }

            flagId = Int32.Parse(row["FlagPIN"].ToString());
            if (flagId >= 0)
            {
                divPin.Visible = true;
                imgPin.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }

            flagId = Int32.Parse(row["FlagWebLogin"].ToString());
            if (flagId >= 0)
            {
                divWebLogin.Visible = true;
                imgWebLogin.ImageUrl = GetImageAccordingToTheFlag(flagId);
            }
        }
    }

    private static string GetImageAccordingToTheFlag(Int32 flagId)
    {
        var imagePath = string.Empty;

        switch (flagId)
        {
            case (int)PatientStatusCheck.Unknown:
                imagePath = "../Content/images/msg_icon_unknown.png";
                break;
            case (int)PatientStatusCheck.GoodPass:
                imagePath = "../Content/images/msg_icon_verified.gif";
                break;
            case (int)PatientStatusCheck.Informational:
                imagePath = "../Content/images/msg_icon_nodata.gif";
                break;
            case (int)PatientStatusCheck.Warning:
                imagePath = "../Content/images/msg_icon_low.gif";
                break;
            case (int)PatientStatusCheck.Caution:
                imagePath = "../Content/images/msg_icon_caution.gif";
                break;
            case (int)PatientStatusCheck.FailError:
                imagePath = "../Content/images/msg_icon_error.gif";
                break;
            case (int)PatientStatusCheck.Critical:
                imagePath = "../Content/images/msg_icon_critical.gif";
                break;
        }

        return imagePath;
    }

    protected void btnSavePatientNote_Click(object sender, EventArgs e)
    {

        var cmdParams = new Dictionary<string, object>
                                {
                                    {"@Note", txtNote.Text },
                                    {"@PatientID", ClientSession.SelectedPatientID},
                                    {"UserID", ClientSession.UserID}
                                };
        SqlHelper.ExecuteScalarProcedureParams("web_pr_ptnotegen_add", cmdParams);
        windowManager.RadAlert("Record successfully updated.", 350, 150, "", "", "../Content/Images/success.png");
    }


}