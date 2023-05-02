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
using PatientPortal.Utility;

public partial class manage : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            try
            {
                BindStates();
                BindStatements();
                BindLocations();
                BindProviders();
                BindAccountStatus();
                BindGender();
                BindRelation();
                BindFinancialResponsibility();

                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.PFSReportAddPatient)
                {
                    // for pre populate the values
                    PopulatePfsReportData();
                    // For Add case
                    ManageFieldsForAddCase();

                }
                else
                {

                    if (ClientSession.SelectedPatientID > 0)
                    {
                        GetPatientInformation();
                        txtPincode.Enabled = true;
                        CustomValidatorPincode.Enabled = true;
                        hdnIsAdd.Value = "0";
                    }
                    else
                    {
                        ManageFieldsForAddCase();
                    }


                }

            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    private void ManageFieldsForAddCase()
    {
        txtPincode.Enabled = false;
        CustomValidatorPincode.Enabled = false;
        litPatientManagement.Text = "Add New Patient";
        btnUpdate.ImageUrl = "../Content/Images/btn_submit.gif";
        hdnIsAdd.Value = "1";
    }

    #region Populate PFS Report Data

    private void PopulatePfsReportData()
    {
        string value;
        ViewState["PFSID"] = Convert.ToInt32(ClientSession.ObjectID);
        var values = ClientSession.ObjectValue as Dictionary<string, string>;

        values.TryGetValue("FirstName", out value);
        txtFirstName.Text = value;

        values.TryGetValue("LastName", out value);
        txtLastName.Text = value;

        values.TryGetValue("DOB", out value);
        if (!string.IsNullOrEmpty(value))
            dtDateofBirth.SelectedDate = Convert.ToDateTime(value);

        values.TryGetValue("SSNenc", out value);
        txtSocialSecurity.Text = value;

        values.TryGetValue("StreetAddress", out value);
        txtPrimaryStreet.Text = value;

        values.TryGetValue("CityAddress", out value);
        txtPrimaryCity.Text = value;

        values.TryGetValue("StateAddress", out value);
        var stateType = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_get", new Dictionary<string, object>
        {
            { "StateAbbr", value },
            { "@UserID", ClientSession.UserID}
        });
        cmbPrimaryStates.SelectedValue = stateType.Rows.Count > 0 ? stateType.Rows[0]["StateTypeID"].ToString() : "-1";

        values.TryGetValue("ZipAddress", out value);
        txtPrimaryZipCode1.Text = value;


        ClientSession.ObjectID = null;
        ClientSession.ObjectValue = null;

    }

    #endregion

    #region Bind Dropdowns

    private void BindFinancialResponsibility()
    {
        cmbFinancialResponsibility.Items.Add(new RadComboBoxItem { Text = FinancialResponsibility.Patient.ToString(), Value = ((int)FinancialResponsibility.Patient).ToString() });
        cmbFinancialResponsibility.Items.Add(new RadComboBoxItem { Text = FinancialResponsibility.Guardian.ToString(), Value = ((int)FinancialResponsibility.Guardian).ToString() });
    }

    private void BindStates()
    {
        var cmdParams = new Dictionary<string, object>();
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", cmdParams);

        cmbPrimaryStates.DataSource = states;
        cmbPrimaryStates.DataBind();

        cmbSecondaryStates.DataSource = states;
        cmbSecondaryStates.DataBind();
    }

    private void BindStatements()
    {
        // old text = cmbStatements.Items.Add(new RadComboBoxItem { Text = AddressType.Primary.ToString(), Value = ((int)AddressType.Primary).ToString() });

        cmbStatements.Items.Add(new RadComboBoxItem { Text = "Primary Address", Value = ((int)AddressType.Primary).ToString() });
        cmbStatements.Items.Add(new RadComboBoxItem { Text = "Alternate Address", Value = ((int)AddressType.Secondary).ToString() });

        cmbGuardianAddress.Items.Add(new RadComboBoxItem { Text = "Primary Address", Value = ((int)AddressType.Primary).ToString() });
        cmbGuardianAddress.Items.Add(new RadComboBoxItem { Text = "Alternate Address", Value = ((int)AddressType.Secondary).ToString() });
    }

    private void BindLocations()
    {
        var cmdParams = new Dictionary<string, object> {
        {"@PracticeID", ClientSession.PracticeID}, };
        var locations = SqlHelper.ExecuteDataTableProcedureParams("web_pr_location_list", cmdParams);
        cmbLocations.DataSource = locations;
        cmbLocations.DataBind();

        if (locations.Rows.Count == 1)
            cmbLocations.SelectedIndex = 0;
        else
            cmbLocations.SelectedValue = ClientSession.DefaultLocationID.ToString();

    }

    private void BindProviders()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } };
        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);
        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();

        if (providers.Rows.Count == 1)
            cmbProviders.SelectedIndex = 0;
        else
            cmbProviders.SelectedValue = ClientSession.DefaultProviderID.ToString();

    }

    private void BindAccountStatus()
    {
        var cmdParams = new Dictionary<string, object>();
        var locations = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statustype_list", cmdParams);
        cmbAccountStatus.DataSource = locations;
        cmbAccountStatus.DataBind();
    }

    private void BindGender()
    {
        cmbGender.Items.Add(new RadComboBoxItem { Text = Gender.Male.ToString(), Value = ((int)Gender.Male).ToString() });
        cmbGender.Items.Add(new RadComboBoxItem { Text = Gender.Female.ToString(), Value = ((int)Gender.Female).ToString() });

        cmbGuardianGender.Items.Add(new RadComboBoxItem { Text = Gender.Male.ToString(), Value = ((int)Gender.Male).ToString() });
        cmbGuardianGender.Items.Add(new RadComboBoxItem { Text = Gender.Female.ToString(), Value = ((int)Gender.Female).ToString() });
    }

    private void BindRelation()
    {
        var cmdParams = new Dictionary<string, object> { { "@FlagGuardian", 1 } };
        var relationship = SqlHelper.ExecuteDataTableProcedureParams("web_pr_relationtype_list", cmdParams);
        cmbRelationship.DataSource = relationship;
        cmbRelationship.DataBind();
    }

    #endregion

    private void GetPatientInformation()
    {
        var cmdParams = new Dictionary<string, object> { { "PatientID", ClientSession.SelectedPatientID }, { "@UserID", ClientSession.UserID } };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            txtMRN.Text = row["MRN"].ToString();
            txtFirstName.Text = row["NameFirst"].ToString();
            txtLastName.Text = row["NameLast"].ToString();
            dtDateofBirth.SelectedDate = row["DateofBirth"] != DBNull.Value ? Convert.ToDateTime(row["DateofBirth"]) : (DateTime?)null;
            txtSocialSecurity.Text = CryptorEngine.Decrypt(row["PatientSSNenc"].ToString());
            // txtSSNLast4.Text = row["PatientSSN4"].ToString(); 
            txtHomePhone.Text = row["Phonepri"].ToString();

            cmbLocations.SelectedValue = row["LocationID"].ToString();
            cmbProviders.SelectedValue = row["ProviderID"].ToString();
            cmbAccountStatus.SelectedValue = row["StatusTypeID"].ToString();
            cmbGender.SelectedValue = row["GenderID"].ToString();
            txtEmail.Text = row["Email"].ToString();
            txtAltPhone.Text = row["PhoneSec"].ToString();

            txtPrimaryStreet.Text = row["Addr1Pri"].ToString();
            txtPrimaryAptSuite.Text = row["Addr2Pri"].ToString();
            txtPrimaryCity.Text = row["CityPri"].ToString();
            cmbPrimaryStates.SelectedValue = row["StateTypeIDPri"].ToString();
            txtPrimaryZipCode1.Text = row["ZipPri"].ToString();
            txtPrimaryZipCode2.Text = row["Zip4Pri"].ToString();

            txtSecondaryStreet.Text = row["Addr1Sec"].ToString();
            txtSecondaryAptSuite.Text = row["Addr2Sec"].ToString();

            txtSecondaryCity.Text = row["CitySec"].ToString();
            cmbSecondaryStates.SelectedValue = row["StateTypeIDSec"].ToString();
            txtAltZipCode1.Text = row["ZipSec"].ToString();
            txtAltZipCode2.Text = row["Zip4Sec"].ToString();
            cmbStatements.SelectedValue = row["AddrPrimaryID"].ToString();

            var isGuardian = row["FlagGuardianPay"].ParseBool();
            if (isGuardian)
            {
                cmbFinancialResponsibility.SelectedValue = ((int)FinancialResponsibility.Guardian).ToString();
            }
            else
            {
                cmbFinancialResponsibility.SelectedValue = ((int)FinancialResponsibility.Patient).ToString();

            }


            chkEmailMyStatements.Checked = Convert.ToBoolean(row["FlagEmailBills"]);
            txtPincode.Text = row["PINCode"].ToString();

            //Guardian Information
            txtGuardianFirstName.Text = row["GuardianFirst"].ToString();
            txtGuardianLastName.Text = row["GuardianLast"].ToString();
            cmbRelationship.SelectedValue = row["GuardianRelTypeID"].ToString();
            dtGuardianDateofBirth.SelectedDate = row["GuardianDateofBirth"] != DBNull.Value ? Convert.ToDateTime(row["GuardianDateofBirth"]) : (DateTime?)null;
            txtGuardianSSN.Text = CryptorEngine.Decrypt(row["GuardianSSNenc"].ToString());
            cmbGuardianGender.SelectedValue = row["GuardianGenderID"].ToString();
            txtGuardianPhone.Text = row["GuardianPhone"].ToString();
            txtGuardianEmail.Text = row["GuardianEmail"].ToString();
            cmbGuardianAddress.SelectedValue = row["GuardianAddrID"].ToString();

            // Displaying Account ID
            lblAccountID.Text = row["AccountID"].ToString();

        }

        // Managing validations
        if (dtDateofBirth.SelectedDate != null)
        {
            var isPatientUnder18 = IsUnder18((DateTime)dtDateofBirth.SelectedDate);
            if (isPatientUnder18)
            {
                DisableFinancialResponsibilityandManageValidations();
                spanGuardianInfo.Visible = true;
            }
        }

        if (cmbStatements.SelectedValue == ((int)AddressType.Secondary).ToString())
        {
            EnableAlternateAddressRequiredValidations();
        }

        if (cmbFinancialResponsibility.SelectedValue == ((int)FinancialResponsibility.Guardian).ToString())
        {
            EnableDisableGuardianRequireValidations();
        }

        if (cmbGuardianAddress.SelectedValue == ((int)AddressType.Secondary).ToString())
        {
            EnableAlternateAddressRequiredValidations();
        }



    }

    protected void cmbFinancialResponsibility_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        EnableDisableGuardianRequireValidations();
    }


    protected void cmbStatements_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        EnableAlternateAddressRequiredValidations();
    }

    protected void cmbRelationship_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        if (cmbFinancialResponsibility.SelectedValue == ((int)FinancialResponsibility.Patient).ToString())
        {
            //selected value of Relationship -2 is for blank 

            if (cmbRelationship.SelectedValue == "-2")
                ClearGuardianInformation();
        }
    }

    protected void cmbGuardianAddress_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        EnableAlternateAddressRequiredValidations();

    }


    private void EnableAlternateAddressRequiredValidations()
    {
        if (cmbStatements.SelectedValue == ((int)AddressType.Secondary).ToString() || cmbGuardianAddress.SelectedValue == ((int)AddressType.Secondary).ToString())
        {
            rfvAltStreet.Enabled = true;
            rfvAltCity.Enabled = true;
            rfvdAltState.Enabled = true;
            rfvAltZipCode1.Enabled = true;
        }
        else
        {
            rfvAltStreet.Enabled = false;
            rfvAltCity.Enabled = false;
            rfvdAltState.Enabled = false;
            rfvAltZipCode1.Enabled = false;
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {

            var canContinue = ValidateMrn();
            if (!canContinue)
                return;

            string PatientSSNenc = "", PatientSSN4 = "", GuardianSSNenc = "", GuardianSSN4 = "";
            if (txtSocialSecurity.Text.Trim().Length == 9)
            {
                PatientSSNenc = txtSocialSecurity.Text.Trim().Encrypt();
                PatientSSN4 = txtSocialSecurity.Text.Trim().Substring(txtSocialSecurity.Text.Trim().Length - 4, 4);
            }
            if (txtGuardianSSN.Text.Trim().Length == 9)
            {
                GuardianSSNenc = txtGuardianSSN.Text.Trim().Encrypt();
                GuardianSSN4 = txtGuardianSSN.Text.Trim().Substring(txtGuardianSSN.Text.Trim().Length - 4, 4);
            }
            var patientID = ClientSession.SelectedPatientID == 0 ? (int?)null : ClientSession.SelectedPatientID;
            var cmdParams = new Dictionary<string, object>
                                {
                                    {"@PatientID",patientID },
                                    {"@PracticeID", ClientSession.PracticeID},
                                    {"@MRN", txtMRN.Text.Trim()},
                                    {"@NameFirst", txtFirstName.Text.Trim()},
                                    {"@NameLast", txtLastName.Text.Trim()},
                                    {"@DateofBirth", dtDateofBirth.SelectedDate},
                                    {"@PatientSSNenc", PatientSSNenc },
                                    {"@PatientSSN4", PatientSSN4},
                                    {"@PhonePri", txtHomePhone.Text.Trim()},
                                    {"@LocationID", cmbLocations.SelectedValue.Trim()},
                                    {"@ProviderID", cmbProviders.SelectedValue.Trim()},
                                    {"@StatusTypeID", cmbAccountStatus.SelectedValue.Trim()},
                                    {"@GenderID", cmbGender.SelectedValue.Trim()},
                                    {"@Email", txtEmail.Text.Trim()},
                                    {"@PhoneSec", txtAltPhone.Text.Trim()},
                                    {"@Addr1Pri", txtPrimaryStreet.Text.Trim()},
                                    {"@Addr2Pri", txtPrimaryAptSuite.Text.Trim()},
                                    {"@CityPri", txtPrimaryCity.Text.Trim()},
                                    {"@StateTypeIDPri", cmbPrimaryStates.SelectedValue.Trim()},
                                    {"@ZipPri", txtPrimaryZipCode1.Text.Trim()},
                                    {"@Zip4Pri", txtPrimaryZipCode2.Text.Trim()},
                                    {"@Addr1Sec", txtSecondaryStreet.Text.Trim()},
                                    {"@Addr2Sec", txtSecondaryAptSuite.Text.Trim()},
                                    {"@CitySec", txtSecondaryCity.Text.Trim()},
                                    {"@StateTypeIDSec", cmbSecondaryStates.SelectedValue.Trim()},
                                    {"@ZipSec",   txtAltZipCode1.Text.Trim()},
                                    {"@Zip4Sec", txtAltZipCode2.Text.Trim()},
                                    {"@AddrPrimaryID", cmbStatements.SelectedValue},
                                    {"@FlagGuardianPay", cmbFinancialResponsibility.SelectedValue},
                                    {"@FlagEmailBills", chkEmailMyStatements.Checked},
                                    {"@PINCode", txtPincode.Text.Trim()},

                                    {"@GuardianFirst", txtGuardianFirstName.Text.Trim()},
                                    {"@GuardianLast", txtGuardianLastName.Text.Trim()},
                                    {"@GuardianRelTypeID", cmbRelationship.SelectedValue},
                                    {"@GuardianDateofBirth", dtGuardianDateofBirth.SelectedDate},
                                    {"@GuardianSSNenc", GuardianSSNenc},
                                    {"@GuardianSSN4", GuardianSSN4},
                                    {"@GuardianGenderID", cmbGuardianGender.SelectedValue},
                                    {"@GuardianPhone", txtGuardianPhone.Text.Trim()},
                                    {"@GuardianEmail", txtGuardianEmail.Text.Trim()},
                                    {"@GuardianAddrID", cmbGuardianAddress.SelectedValue},
                                    
                                    {"@UserID", ClientSession.UserID},
                                    {"@FlagActive", true}
                                    };

            if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.PFSReportAddPatient)
                cmdParams.Add("@TUPFSID", Convert.ToInt32(ViewState["PFSID"].ToString()));

            var activePatientID = SqlHelper.ExecuteScalarProcedureParams("web_pr_patient_add", cmdParams);
            var callBackFn = ClientSession.IsRedirectToBluecredit.ParseBool() ? "redirectPage" : "redirectToPatientDashboard";

            if (patientID == null)
            {
                var isRequestFromPfsReport = ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.PFSReportAddPatient;
                ClientSession.SelectedPatientID = (int)activePatientID;
                (new UserLogin()).LoadPatientIntoSession();
                windowManager.RadAlert("Record successfully created.", 350, 150, "", isRequestFromPfsReport ? "redirectToPFSReports" : callBackFn, "../Content/Images/success.png");

                if (!isRequestFromPfsReport) return;
                ClientSession.ObjectID = null;
                ClientSession.ObjectValue = null;
                ClientSession.ObjectType = null;
            }
            else
            {
                (new UserLogin()).LoadPatientIntoSession();
                windowManager.RadAlert("Record successfully updated.", 350, 150, "", callBackFn, "../Content/Images/success.png");
            }

            // Checking if request came from bluecredit page then assigning value to auto open bluecredit Add popup
            ClientSession.IsBlueCreditAddRequest = ClientSession.IsRedirectToBluecredit;

        }
        catch (Exception)
        {
            throw;
        }
    }

    static bool IsUnder18(DateTime dateOfBirth)
    {
        var age = Convert.ToInt32(Math.Truncate(DateTime.Now.Subtract(dateOfBirth).TotalDays * (1 / 365.242199)));
        return age < 18;
    }

    public void dtDateofBirth_OnSelectedDateChanged(object sender, EventArgs e)
    {
        if (dtDateofBirth.SelectedDate == null)
            return;

        var isPatientUnder18 = IsUnder18((DateTime)dtDateofBirth.SelectedDate);
        if (isPatientUnder18)
        {
            DisableFinancialResponsibilityandManageValidations();
            spanGuardianInfo.Visible = true;
        }
        else
        {
            cmbFinancialResponsibility.Enabled = true;
            spanGuardianInfo.Visible = false;
        }
    }

    void DisableFinancialResponsibilityandManageValidations()
    {
        cmbFinancialResponsibility.SelectedValue = ((int)FinancialResponsibility.Guardian).ToString();
        cmbFinancialResponsibility.Enabled = false;
        EnableDisableGuardianRequireValidations();
    }

    private void EnableDisableGuardianRequireValidations()
    {
        if (cmbFinancialResponsibility.SelectedValue == ((int)FinancialResponsibility.Guardian).ToString())
        {
            rfRelationShip.Enabled = true;
            rfvGuardianFirstName.Enabled = true;
            rfvGuardianLastName.Enabled = true;
            rfvGuardianDateofBirth.Enabled = true;
            rfvGuardianGender.Enabled = true;
            rfvGuardianPhone.Enabled = true;
        }
        else
        {
            rfRelationShip.Enabled = false;
            rfvGuardianFirstName.Enabled = false;
            rfvGuardianLastName.Enabled = false;
            rfvGuardianDateofBirth.Enabled = false;
            rfvGuardianGender.Enabled = false;
            rfvGuardianPhone.Enabled = false;
        }
    }

    private void ClearGuardianInformation()
    {
        txtGuardianFirstName.Text = string.Empty;
        txtGuardianLastName.Text = string.Empty;
        dtGuardianDateofBirth.SelectedDate = null;
        txtGuardianSSN.Text = string.Empty;
        cmbGuardianGender.SelectedValue = string.Empty;
        txtGuardianPhone.Text = string.Empty;
        txtGuardianEmail.Text = string.Empty;
    }

    private bool ValidateMrn()
    {
        var isContinue = hdnIsContinue.Value.ParseBool();
        if (isContinue)
        {
            hdnIsContinue.Value = "0";
            return true;
        }

        if (!string.IsNullOrEmpty(txtMRN.Text))
        {
            var cmdParams = new Dictionary<string, object>
            {
                {"@PracticeID", ClientSession.PracticeID},
                {"@PatientID", ClientSession.SelectedPatientID},
                {"@MRN", txtMRN.Text}
            };


            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patientmrn_check", cmdParams);
            foreach (DataRow row in reader.Rows)
            {
                var isPatientExists = row["FlagExists"].ParseBool();
                if (isPatientExists)
                {
                    const string message = "A patient with the same MRN already exists. It is recommended that you cancel this entry and use the existing patient. You may also continue with the risk of duplicate entries.";
                    windowManager.RadConfirm(message, "validateMrnConfirmPopup", 500, 100, null, "", "../Content/Images/warning.png");
                    return false;
                }
            }
        }
        else
        {
            const string message = "Although MRN is not required, it is highly recommended to Include the undue number associated with this patient from your Practice Management System.";
            windowManager.RadConfirm(message, "validateMrnConfirmPopup", 500, 100, null, "", "../Content/Images/warning.png");
            return false;
        }


        return true;
    }

}