using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class managePatient_popup : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            ClientSession.WasRequestFromPopup = true;
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
                if (ClientSession.SelectedPatientID > 0)
                    GetPatientInformation();
                else
                {
                    litPatientManagement.Text = "Add New Patient";
                    btnUpdate.ImageUrl = "../Content/Images/btn_submit.gif";
                }


            }
            catch (Exception)
            {

                throw;
            }
        }
    }

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
    }

    private void BindProviders()
    {
        var cmdParams = new Dictionary<string, object> { {"@PracticeID", ClientSession.PracticeID} };
        var locations = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);
        cmbProviders.DataSource = locations;
        cmbProviders.DataBind();
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
        var cmdParams = new Dictionary<string, object>
        {
            { "@PatientID", ClientSession.SelectedPatientID },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            txtMRN.Text = row["MRN"].ToString();
            txtFirstName.Text = row["NameFirst"].ToString();
            txtLastName.Text = row["NameLast"].ToString();
            dtDateofBirth.SelectedDate = Convert.ToDateTime(row["DateofBirth"]);
            //txtSocialSecurity.Text = CryptorEngine.Decrypt(row["PatientSSNenc"].ToString());
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
            cmbFinancialResponsibility.SelectedValue = row["FlagGuardianPay"].ToString();
            chkEmailMyStatements.Checked = Convert.ToBoolean(row["FlagEmailBills"]);
            txtPincode.Text = row["PINCode"].ToString();

            //Guardian Information
            txtGuardianFirstName.Text = row["GuardianFirst"].ToString();
            txtGuardianLastName.Text = row["GuardianLast"].ToString();
            cmbRelationship.SelectedValue = row["GuardianRelTypeID"].ToString();
            dtGuardianDateofBirth.SelectedDate = row["GuardianDateofBirth"] != DBNull.Value ? Convert.ToDateTime(row["GuardianDateofBirth"]) : (DateTime?)null;
            //txtGuardianSSN.Text = CryptorEngine.Decrypt(row["GuardianSSNenc"].ToString());
            cmbGuardianGender.SelectedValue = row["GuardianGenderID"].ToString();
            txtGuardianPhone.Text = row["GuardianPhone"].ToString();
            txtGuardianEmail.Text = row["GuardianEmail"].ToString();
            cmbGuardianAddress.SelectedValue = row["GuardianAddrID"].ToString();
        }
    }

    protected void cmbFinancialResponsibility_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            if (cmbFinancialResponsibility.SelectedValue == ((int)FinancialResponsibility.Guardian).ToString())
            {
                rfvGuardianFirstName.Enabled = true;
                rfvGuardianLastName.Enabled = true;
                rfvGuardianDateofBirth.Enabled = true;
                rfvGuardianGender.Enabled = true;
                rfvGuardianPhone.Enabled = true;
            }
            else
            {
                rfvGuardianFirstName.Enabled = false;
                rfvGuardianLastName.Enabled = false;
                rfvGuardianDateofBirth.Enabled = false;
                rfvGuardianGender.Enabled = false;
                rfvGuardianPhone.Enabled = false;
            }
        }
        catch (Exception)
        {

            throw;
        }
    }

    protected void cmbStatements_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        EnableAlternateAddressRequiredValidations();
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
            var patientID = ClientSession.SelectedPatientID == 0 ? (int?)null : ClientSession.SelectedPatientID;
            var cmdParams = new Dictionary<string, object>
                                {
                                    {"@PatientID",patientID },
                                    {"@PracticeID", ClientSession.PracticeID},
                                    {"@MRN", txtMRN.Text.Trim()},
                                    {"@NameFirst", txtFirstName.Text.Trim()},
                                    {"@NameLast", txtLastName.Text.Trim()},
                                    {"@DateofBirth", dtDateofBirth.SelectedDate},
                                    //{"@PatientSSNenc", CryptorEngine.Encrypt(txtSocialSecurity.Text.Trim()) },
                                    {"@PatientSSN4", txtSocialSecurity.Text.Trim().Substring(txtSocialSecurity.Text.Trim().Length - 4, 4)},
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
                                    {"@FlagEmailBills", chkEmailMyStatements.Checked},
                                    {"@PINCode", txtPincode.Text.Trim()},

                                    {"@GuardianFirst", txtGuardianFirstName.Text.Trim()},
                                    {"@GuardianLast", txtGuardianLastName.Text.Trim()},
                                    {"@GuardianRelTypeID", cmbRelationship.SelectedValue},
                                    {"@GuardianDateofBirth", dtGuardianDateofBirth.SelectedDate},
                                    //{"@GuardianSSNenc", CryptorEngine.Encrypt(txtGuardianSSN.Text.Trim())},
                                    {"@GuardianSSN4", txtGuardianSSN.Text.Trim().Substring(txtGuardianSSN.Text.Trim().Length - 4,4)},
                                    {"@GuardianGenderID", cmbGuardianGender.SelectedValue},
                                    {"@GuardianPhone", txtGuardianPhone.Text.Trim()},
                                    {"@GuardianEmail", txtGuardianEmail.Text.Trim()},
                                    {"@GuardianAddrID", cmbGuardianAddress.SelectedValue},
                                    
                                    {"@UserID", ClientSession.UserID},
                                    {"@FlagActive", true}
                                    };
            var activePatientID = SqlHelper.ExecuteScalarProcedureParams("web_pr_patient_add", cmdParams);

            if (patientID == null)
            {
                ClientSession.SelectedPatientID = (int)activePatientID;
                ClientSession.PatientFirstName = txtFirstName.Text.Trim();
                ClientSession.PatientLastName = txtLastName.Text.Trim();
                windowManager.RadAlert("Patient has been created successfully", 320, 120, "", "redirectPage", "../Content/Images/success.png");
            }
            else
            {
                ReloadPatientInformation();
                windowManager.RadAlert("Patient record has been updated successfully", 320, 120, "", "", "../Content/Images/success.png");
            }


        }
        catch (Exception)
        {

            throw;
        }
    }

    private void ReloadPatientInformation()
    {
        var cmdParams = new Dictionary<string, object> {
                        {"@PatientID", ClientSession.SelectedPatientID},
                        {"@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            ClientSession.PatientFirstName = row["NameFirst"].ToString();
            ClientSession.PatientLastName = row["NameLast"].ToString();
            ClientSession.DateOfBirth = row["DateofBirth"].ToString();

            var selectedPatientInformation = new Dictionary<string, object>
                                                 {
                                                     {"AddrPrimaryID", row["AddrPrimaryID"].ToString()},
                                                     {"AddrPri", row["AddrPri"].ToString()},
                                                     {"AddrSec", row["AddrSec"].ToString()},
                                                     {"PhonePri", row["PhonePri"].ToString()},
                                                     {"Email", row["Email"].ToString()},
                                                     {"FlagEmailBills", row["FlagEmailBills"].ToString()},
                                                     {
                                                         "FlagGuardianPay",
                                                         Convert.ToBoolean(row["FlagGuardianPay"]) == false
                                                             ? 0
                                                             : 1
                                                     },
                                                     {
                                                         "GuardianName",
                                                         string.Format("{0} {1}", row["GuardianFirst"],
                                                                       row["GuardianLast"])
                                                     },
                                                     {"GuardianPhone", row["GuardianPhone"]}
                                                 };
            ClientSession.SelectedPatientInformation = selectedPatientInformation;
            ClientSession.IsFlagGuardianExists = Convert.ToBoolean(row["FlagGuardianExists"].ToString());
        }
    }


}
