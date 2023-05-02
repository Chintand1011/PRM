using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class myinfo : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                GetPatientInformation();
            }
            catch (Exception)
            {

                throw;
            }
        }

        // Preventing the popups from open on page load.
        popupInputMyProfile.VisibleOnPageLoad = false;
        PopupShowInputInformation.VisibleOnPageLoad = false;
    }

    private void GetPatientInformation()
    {
        var cmdParams = new Dictionary<string, object> { { "PatientID", ClientSession.PatientID } };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
        // Checking if field is null or not, if null then passing the "-"
        foreach (DataRow row in reader.Rows)
        {
            lblFirstName.Text = string.IsNullOrEmpty(row["NameFirst"].ToString()) ? "-" : row["NameFirst"].ToString();
            lblLastName.Text = string.IsNullOrEmpty(row["NameLast"].ToString()) ? "-" : row["NameLast"].ToString();
            lblDateofBirth.Text = string.IsNullOrEmpty(row["DateofBirth"].ToString()) ? "-" : row["DateofBirth"].ToString();

            lblHomePhone.Text = string.IsNullOrEmpty(row["PhonePriAbbr"].ToString()) ? "-" : row["PhonePriAbbr"].ToString();
            lblAltPhone.Text = string.IsNullOrEmpty(row["PhoneSecAbbr"].ToString()) ? "-" : row["PhoneSecAbbr"].ToString();
            lblEmail.Text = string.IsNullOrEmpty(row["Email"].ToString()) ? "-" : row["Email"].ToString();

            lblStreet.Text = string.IsNullOrEmpty(row["Addr1Pri"].ToString()) ? "-" : row["Addr1Pri"].ToString();
            lblAptSuite.Text = string.IsNullOrEmpty(row["Addr2Pri"].ToString()) ? "-" : row["Addr2Pri"].ToString();

            lblAltStreet.Text = string.IsNullOrEmpty(row["Addr1Sec"].ToString()) ? "-" : row["Addr1Sec"].ToString();
            lblAltAptSuite.Text = string.IsNullOrEmpty(row["Addr2Sec"].ToString()) ? "-" : row["Addr2Sec"].ToString();

            lblCity.Text = string.IsNullOrEmpty(row["CityPri"].ToString()) ? "-" : row["CityPri"].ToString();
            lblAltCity.Text = string.IsNullOrEmpty(row["CitySec"].ToString()) ? "-" : row["CitySec"].ToString();

            lblState.Text = string.IsNullOrEmpty(row["StatePriAbbr"].ToString()) ? "-" : row["StatePriAbbr"].ToString();
            lblAltState.Text = string.IsNullOrEmpty(row["StateSecAbbr"].ToString()) ? "-" : row["StateSecAbbr"].ToString();

            lblZipCode.Text = string.Format("{0}-{1}", row["ZipPri"], row["Zip4Pri"]);
            lblAltZipCode.Text = string.Format("{0}-{1}", row["ZipSec"], row["Zip4Sec"]);

            lblStatements.Text = string.IsNullOrEmpty(row["AddrPrimaryAbbr"].ToString()) ? "-" : row["AddrPrimaryAbbr"].ToString();
            lblEmailStatements.Text = string.IsNullOrEmpty(row["FlagEmailBillsAbbr"].ToString()) ? "-" : row["FlagEmailBillsAbbr"].ToString();
            lblEmailStatements.Text = string.IsNullOrEmpty(row["FlagEmailBillsAbbr"].ToString()) ? "-" : row["FlagEmailBillsAbbr"].ToString();
            lblPINCode.Text = string.IsNullOrEmpty(row["PINCode"].ToString()) ? "-" : row["PINCode"].ToString();

            lblPracticeName.Text = string.IsNullOrEmpty(row["PracticeName"].ToString()) ? "-" : row["PracticeName"].ToString();
            lblProviderName.Text = string.IsNullOrEmpty(row["ProviderName"].ToString()) ? "-" : row["ProviderName"].ToString();
            lblLocName.Text = string.IsNullOrEmpty(row["LocName"].ToString()) ? "-" : row["LocName"].ToString();
            lblLocAddr1.Text = string.IsNullOrEmpty(row["LocAddr1"].ToString()) ? "-" : row["LocAddr1"].ToString();
            lblLocAddr2.Text = string.IsNullOrEmpty(row["LocAddr2"].ToString()) ? "-" : row["LocAddr2"].ToString();
            lblLocCity.Text = string.IsNullOrEmpty(row["LocCity"].ToString()) ? "-" : row["LocCity"].ToString();
            lblLocState.Text = string.IsNullOrEmpty(row["LocStateAbbr"].ToString()) ? "-" : row["LocStateAbbr"].ToString();
            lblLocZip.Text = string.IsNullOrEmpty(row["LocZip"].ToString()) ? "-" : row["LocZip"].ToString();
            lblLocPhone.Text = string.IsNullOrEmpty(row["LocPhonePriAbbr"].ToString()) ? "-" : row["LocPhonePriAbbr"].ToString();
            lblLocFax.Text = string.IsNullOrEmpty(row["LocFax"].ToString()) ? "-" : row["LocFax"].ToString();

            // Displaying the error message if last attempt for sending email was not successfull
            if ((int)row["EmailBounceCnt"] > 0)
            {
                litSystemMessage.Text = "<p align='justify'> <img src='content/images/icon_error.gif'; style='margin-bottom:-3px;'>&nbsp; Last email attempt was unsuccessful, <br>please update email address.<p>";
                divSystemMessages.Visible = true;
            }
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        BindStates();
        BindStatements();
        GetPatientInformationForInput();
        popupInputMyProfile.VisibleOnPageLoad = true;

    }

    #region Input Popup

    protected void btnNext_Click(object sender, EventArgs e)
    {
        try
        {
            // Showing the entered information for confirmation
            ShowInputInformation();
            popupInputMyProfile.VisibleOnPageLoad = false;
            PopupShowInputInformation.VisibleOnPageLoad = true;

        }
        catch (Exception)
        {

            throw;
        }

    }

    private void GetPatientInformationForInput()
    {
        var cmdParams = new Dictionary<string, object> { { "PatientID", ClientSession.PatientID } };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            lblPatientName.Text = string.Format("{0} {1}", row["NameFirst"], row["NameLast"]);
            lblAddress1.Text = string.Format("{0} {1}", row["Addr1Pri"], row["Addr2Pri"]);
            lblAddress2.Text = string.Format("{0}, {1} {2}", row["CityPri"], row["StatePriAbbr"], row["ZipPri"]);
            lblPhone.Text = row["PhonePriAbbr"].ToString();
            txtAltPhone.Text = row["PhoneSec"].ToString();
            txtEmail.Text = row["Email"].ToString();
            hdnEmail.Value = row["Email"].ToString();
            
            lblStreet.Text = row["Addr1Pri"].ToString();
            lblAptSuite.Text = row["Addr2Pri"].ToString();
            txtAltStreet.Text = row["Addr1Sec"].ToString();
            txtAltAptSuite.Text = row["Addr2Sec"].ToString();
            lblCity.Text = row["CityPri"].ToString();
            txtAltCity.Text = row["CitySec"].ToString();
            cmbAltStates.SelectedValue = row["StateTypeIDSec"].ToString();
            txtAltZipCode1.Text = row["ZipSec"].ToString();
            txtAltZipCode2.Text = row["Zip4Sec"].ToString();
            cmbStatements.SelectedValue = row["AddrPrimaryID"].ToString();
            chkEmailMyStatements.Checked = Convert.ToBoolean(row["FlagEmailBills"]);
            txtPincode.Text = row["PinCode"].ToString();
        }

        ScriptManager.RegisterStartupScript(Page, typeof(Page), "checkemailstatement", "checkEmailStatements();", true);
    }

    private void BindStatements()
    {
        cmbStatements.Items.Add(new RadComboBoxItem { Text = Statements.Primary.ToString(), Value = ((int)Statements.Primary).ToString() });
        cmbStatements.Items.Add(new RadComboBoxItem { Text = Statements.Secondary.ToString(), Value = ((int)Statements.Secondary).ToString() });
    }

    private void BindStates()
    {
        var cmdParams = new Dictionary<string, object>();
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", cmdParams);

        cmbAltStates.DataSource = states;
        cmbAltStates.DataBind();
    }

    #endregion

    #region Input Data Show Popup

    private void ShowInputInformation()
    {
        lblShowPatientName.Text = lblPatientName.Text;
        lblShowAddress1.Text = lblAddress1.Text;
        lblShowAddress2.Text = lblAddress2.Text;
        lblShowPhone.Text = lblPhone.Text;

        lblShowStatements.Text = cmbStatements.SelectedItem.Text;
        lblShowEmailMyStatements.Text = chkEmailMyStatements.Checked ? "Yes" : "No";
        lblShowEmailAddress.Text = txtEmail.Text;

        if (!string.IsNullOrEmpty(txtAltStreet.Text))
        {
            divPatientInformation.Visible = true;
            lblShowSecPatientName.Text = lblPatientName.Text;
            lblShowSecAddress1.Text = string.Format("{0} {1}", txtAltStreet.Text.Trim(), txtAltAptSuite.Text.Trim());
            lblShowSecAddress2.Text = string.Format("{0}, {1} {2}{3}", txtAltCity.Text.Trim(), cmbAltStates.SelectedItem != null ? cmbAltStates.SelectedItem.Text : "-", txtAltZipCode1.Text, txtAltZipCode2.Text);
        }

        lblShowSecPhone.Text = GetFormattedPhoneNumber(txtAltPhone.Text);
        lblShowPincode.Text = txtPincode.Text;

        lblEmailMessage.Visible = string.IsNullOrEmpty(txtEmail.Text) || !chkEmailMyStatements.Checked;


    }

    private static string GetFormattedPhoneNumber(string value)
    {
        return string.Format("({0}) {1}-{2}", value.Substring(0, 3), value.Substring(3, 3), value.Substring(6, 4));
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                var cmdParams = new Dictionary<string, object>
                            {
                            {"@PatientID",ClientSession.PatientID},
                            {"@PracticeID",ClientSession.PracticeID},
                            {"@PhoneSec",txtAltPhone.Text.Trim()},
                            {"@Email",txtEmail.Text.Trim()},
                            {"@Addr1Sec",txtAltStreet.Text.Trim()},
                            {"@Addr2Sec",txtAltAptSuite.Text.Trim()},
                            {"@CitySec",txtAltCity.Text.Trim()},
                            {"@StateTypeIDSec", cmbAltStates.SelectedItem != null ?cmbAltStates.SelectedValue : (object)DBNull.Value},
                            {"@ZipSec",txtAltZipCode1.Text.Trim()},
                            {"@Zip4Sec",txtAltZipCode2.Text.Trim()},
                            {"@FlagEmailBills",chkEmailMyStatements.Checked?"1":"0"},
                            {"@AddrPrimaryID",cmbStatements.SelectedValue},
                            {"PinCode", txtPincode.Text}
                            };

                SqlHelper.ExecuteScalarProcedureParams("web_pr_patient_add", cmdParams);
                RadWindowDialog.RadAlert("<p>Information has been saved successfully.</p>", 400, 150, "", "reloadPage", "Content/Images/success.png");
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
    #endregion



}