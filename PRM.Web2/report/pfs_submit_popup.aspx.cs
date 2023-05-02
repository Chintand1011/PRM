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

public partial class pfs_submit_popup : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // Closing the popup in case of any error
                ClientSession.WasRequestFromPopup = true;
                BindIndividual();
                BindHousingType();
                ShowPatientDetails();
                ShowDefualtValues();

            }
            catch (Exception)
            {

                throw;
            }
        }

        hdnIsError.Value = "";
    }

    private void BindIndividual()
    {
        if (!ClientSession.IsFlagGuardianExists)
        {
            cmbIndividuals.Items.Add(new RadComboBoxItem { Text = FinancialResponsibility.Patient.ToString(), Value = ((int)FinancialResponsibility.Patient).ToString() });
        }
        else
        {
            cmbIndividuals.Items.Add(new RadComboBoxItem { Text = FinancialResponsibility.Patient.ToString(), Value = ((int)FinancialResponsibility.Patient).ToString() });
            cmbIndividuals.Items.Add(new RadComboBoxItem { Text = FinancialResponsibility.Guardian.ToString(), Value = ((int)FinancialResponsibility.Guardian).ToString() });
        }
    }

    public void BindHousingType()
    {
        var hostingValues = Enum.GetValues(typeof(HousingType))
            .Cast<HousingType>()
            .OrderBy(x => (Int32)x)
            .Select(x => new { Text = x.GetDescription(), Value = (Int32)x });


        cmbHousingType.DataSource = hostingValues;
        cmbHousingType.DataBind();
    }

    private void ShowDefualtValues()
    {
        cmbHousingType.SelectedIndex = 0;
    }

    protected void cmbIndividuals_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        // Displaying the records according to the patient or guardian
        ShowPatientDetailsDetail(cmbIndividuals.SelectedValue);
    }

    private void ShowPatientDetails()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", ClientSession.SelectedPatientID},
                                { "@UserID", ClientSession.UserID}
                            };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            cmbIndividuals.SelectedValue = Convert.ToBoolean(row["FlagGuardianPay"].ToString()) == false
                                               ? Convert.ToString((int)FinancialResponsibility.Patient)
                                               : Convert.ToString((int)FinancialResponsibility.Guardian);
        }
        var individualType = cmbIndividuals.SelectedValue == Convert.ToString((int)FinancialResponsibility.Patient)
                                 ? Convert.ToString((int)FinancialResponsibility.Patient)
                                 : Convert.ToString((int)FinancialResponsibility.Guardian);

        ShowPatientDetailsDetail(individualType);
    }


    private void ShowPatientDetailsDetail(string individualType)
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", ClientSession.SelectedPatientID},
                                { "@UserID", ClientSession.UserID}
                            };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {

            if (individualType == Convert.ToString((int)FinancialResponsibility.Patient))
            {
                cmbIndividuals.SelectedValue = Convert.ToString((int)FinancialResponsibility.Patient);
                lblFirstName.Text = row["NameFirst"].ToString();
                lblMiddleName.Text = row["NameMiddle"].ToString();
                lblLastName.Text = row["NameLast"].ToString();
                lblDOB.Text = row["DateOfBirth"].ToString();
                var patientSSNEnc = row["PatientSSNenc"].ToString().Decrypt();
                ViewState["SocialSecurity"] = patientSSNEnc;
                if (!string.IsNullOrEmpty(patientSSNEnc)) { lblSocialSecurity.Text = patientSSNEnc.ToSSNFormat(); }
            }
            else
            {
                cmbIndividuals.SelectedValue = Convert.ToString((int)FinancialResponsibility.Guardian);
                lblFirstName.Text = row["GuardianFirst"].ToString();
                lblMiddleName.Text = row["GuardianMiddle"].ToString();
                lblLastName.Text = row["GuardianLast"].ToString();
                lblDOB.Text = row["GuardianDateOfBirth"].ToString();
                var guardianSSNEnc = row["GuardianSSNenc"].ToString().Decrypt();
                ViewState["SocialSecurity"] = guardianSSNEnc;
                if (!string.IsNullOrEmpty(guardianSSNEnc)) { lblSocialSecurity.Text = guardianSSNEnc.ToSSNFormat(); }
            }

            if (individualType == Convert.ToString((int)FinancialResponsibility.Patient) && row["AddrPrimaryID"].ToString() == Convert.ToString((int)AddressType.Primary))
            {
                lblAddress.Text = row["Addr1pri"].ToString();
                lblAppSuit.Text = row["Addr2pri"].ToString();
                lblCity.Text = row["CityPri"].ToString();
                lblState.Text = row["StatePriAbbr"].ToString();
                lblZipCode.Text = row["ZipPriAbbr"].ToString();
            }
            else if (individualType == Convert.ToString((int)FinancialResponsibility.Patient) && row["AddrPrimaryID"].ToString() == Convert.ToString((int)AddressType.Secondary))
            {
                lblAddress.Text = row["Addr1Sec"].ToString();
                lblAppSuit.Text = row["Addr2Sec"].ToString();
                lblCity.Text = row["CitySec"].ToString();
                lblState.Text = row["StateSecAbbr"].ToString();
                lblZipCode.Text = row["ZipSecAbbr"].ToString();
            }
            else if (individualType == Convert.ToString((int)FinancialResponsibility.Guardian) && row["GuardianAddrID"].ToString() == Convert.ToString((int)AddressType.Primary))
            {
                lblAddress.Text = row["Addr1pri"].ToString();
                lblAppSuit.Text = row["Addr2pri"].ToString();
                lblCity.Text = row["CityPri"].ToString();
                lblState.Text = row["StatePriAbbr"].ToString();
                lblZipCode.Text = row["ZipPriAbbr"].ToString();
            }
            else if (individualType == Convert.ToString((int)FinancialResponsibility.Guardian) && row["GuardianAddrID"].ToString() == Convert.ToString((int)AddressType.Secondary))
            {
                lblAddress.Text = row["Addr1Sec"].ToString();
                lblAppSuit.Text = row["Addr2Sec"].ToString();
                lblCity.Text = row["CitySec"].ToString();
                lblState.Text = row["StateSecAbbr"].ToString();
                lblZipCode.Text = row["ZipSecAbbr"].ToString();
            }
        }
    }


    protected DataTable GetSchedules()
    {
        var feeScheduleID = 0;
        if (ClientSession.ObjectType == ObjectType.FeeSchedule) feeScheduleID = Convert.ToInt32(ClientSession.ObjectID);
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@FeeScheduleID",feeScheduleID},
                                {"@UserID", ClientSession.UserID}
                            };
        var schedules = SqlHelper.ExecuteDataTableProcedureParams("web_pr_feeschedulecpt_get", cmdParams);
        return schedules;
    }

    protected void btnEditDetails_Click(object sender, EventArgs e)
    {
        // If user clicked on the Edit tnen redirecting to the Patient/Manage.aspx
        hdnIsEditProcess.Value = "True";
    }

    protected void btnProcess_click(object sender, EventArgs e)
    {
        try
        {

            var isValidated = Validator.ValidateCreditCheck(windowManager);
            if (!isValidated)
                return;

            // Transunion process going to start
            var transUnionPFSRequest = new TransUnionPFSRequest(ClientSession.SelectedPatientID, lblFirstName.Text.Trim(), lblMiddleName.Text.Trim(), lblLastName.Text.Trim(), lblAddress.Text.Trim(),
                                                                  lblCity.Text.Trim(), lblState.Text.Trim(), lblZipCode.Text.Trim(), lblSocialSecurity.Text == string.Empty ? 0 : Convert.ToInt32(ViewState["SocialSecurity"].ToString()), lblDOB.Text == string.Empty ? new DateTime() : Convert.ToDateTime(lblDOB.Text), ClientSession.PracticeID, Convert.ToInt32(cmbIndividuals.SelectedValue), 0, ClientSession.IPAddress, decimal.Parse(txtIncone.Text), cmbHousingType.SelectedValue, ClientSession.UserID, 0);


            if (!transUnionPFSRequest.Success)
            {
                hdnIsError.Value = "1";
                windowManager.RadAlert(transUnionPFSRequest.Message.ToApostropheStringIfAny(), 350, 150, "", "refreshPage", "../Content/Images/warning.png");
            }
            else
            {
                if (transUnionPFSRequest.FlagShowTUFSReport)
                {
                    ClientSession.ObjectID = transUnionPFSRequest.TUPFSID;
                    ClientSession.ObjectID2 = null;
                    ClientSession.ObjectType = ObjectType.PFSReportDetail;
                    hdnIsShowCreditReportPopup.Value = "True";
                }
                else
                {
                    windowManager.RadAlert("A credit profile match could not be found based on the supplied data. Please verify the information or include additional fields before resubmitting. <BR><BR>PLEASE NOTE THAT EACH CREDIT REQUEST IS CHARGEABLE FROM THE REPORTING AGENCY, REGARDLESS OF A CREDIT MATCH.", 450, 200, string.Empty, string.Empty, "../Content/Images/warning.png");
                }
            }
        }
        catch (Exception ex)
        {
            hdnIsError.Value = "1";
            windowManager.RadAlert(ex.Message.ToApostropheStringIfAny(), 350, 150, "", "refreshPage", "../Content/Images/warning.png");
        }
    }

}
