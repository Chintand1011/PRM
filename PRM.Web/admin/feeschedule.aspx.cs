using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class feeschedule : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // Binding the dropdowns
            BindExistingFeeSchedules();
          //  BindServiesTypesDropdown();
        }

        popupFeeSchedule.VisibleOnPageLoad = false;
        popupImportFeeSchedule.VisibleOnPageLoad = false;
    }
    private void BindExistingFeeSchedules()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID",ClientSession.PracticeID},
                                {"@FlagActive", 0}
                            };
        var feeSchedules = SqlHelper.ExecuteDataTableProcedureParams("web_pr_feeschedule_list", cmdParams);
        cmbFeeSchedules.DataSource = feeSchedules;
        cmbFeeSchedules.DataBind();
    }


    #region Fee Schedule Section

    protected void cmbFeeSchedules_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        // Preparing the page for update the FeeSchedule
        if (!string.IsNullOrEmpty(cmbFeeSchedules.SelectedValue))
        {
            btnSubmit.ImageUrl = "../Content/Images/btn_update.gif";
            btnNewFeeSchedule.ImageUrl = "../Content/Images/btn_new_fade.gif";
            LoadFeeScheduleSection();
            ShowSelectedFeeScheduleInformation();
            pnlFeeScheduleDetail.Visible = true;
            pnlExistingFeeSchedule.Enabled = false;
            ClientSession.ObjectID = cmbFeeSchedules.SelectedValue;
            ClientSession.ObjectType = ObjectType.FeeSchedule;
           //  pnlManageServiceCharge.Visible = true; Todo: This being used for service code

            // Hide the New Button, because we cannot allow user to add new Feeschedule in between update
            divRunNew.Visible = false;
        }
    }

    private void LoadFeeScheduleSection()
    {
        // Binding all the dropdownas
        BindCarriers();
        BindStatusTypes();
        BindServiceTypes();
        BindProviders();
        BindContractTypes();
        BindReimbursement();
      //  BindServiceCodes();
        BindGlobalSchedule();
    }

    private void BindCarriers()
    {
        var activeCarriers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_carrier_list", new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } });
        cmbCarriers.DataSource = activeCarriers;
        cmbCarriers.DataBind();
    }

    private void BindGlobalSchedule()
    {
        cmbGlobalSchedule.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString("") });
        cmbGlobalSchedule.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString("") });
    }

    private void BindStatusTypes()
    {
        cmbStatusTypes.Items.Add(new RadComboBoxItem { Text = StatusType.Active.ToString(), Value = ((int)StatusType.Active).ToString() });
        cmbStatusTypes.Items.Add(new RadComboBoxItem { Text = StatusType.InActive.ToString(), Value = ((int)StatusType.InActive).ToString() });
    }

    private void BindServiceTypes()
    {
        var cmdParams = new Dictionary<string, object>();
        var serviceTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_serviceclass_list", cmdParams);

        cmbServiceTypes.DataSource = serviceTypes;
        cmbServiceTypes.DataBind();
    }

    private void BindProviders()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"PracticeID",ClientSession.PracticeID}
                            };
        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);

        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();
    }

    private void BindContractTypes()
    {
        cmbContractTypes.Items.Add(new RadComboBoxItem { Text = ContractType.InNetwork.GetDescription(), Value = ((int)ContractType.InNetwork).ToString() });
        cmbContractTypes.Items.Add(new RadComboBoxItem { Text = ContractType.OutOfNetwork.GetDescription(), Value = ((int)ContractType.OutOfNetwork).ToString() });
    }

    private void BindReimbursement()
    {
        cmbReimbursement.Items.Add(new RadComboBoxItem { Text = Reimbursement.PatientEndorsedCheck.GetDescription(), Value = ((int)Reimbursement.PatientEndorsedCheck).ToString() });
        cmbReimbursement.Items.Add(new RadComboBoxItem { Text = Reimbursement.DirecttoPractice.GetDescription(), Value = ((int)Reimbursement.DirecttoPractice).ToString() });
    }

    //private void BindServiceCodes()
    //{
    //    var cmdParams = new Dictionary<string, object>
    //                        {
    //                            {"FeeScheduleID",cmbFeeSchedules.SelectedValue}
    //                        };
    //    var serviceCodes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_feeschedulecpt_list", cmdParams);
    //    cmbServiceCodes.DataSource = serviceCodes;
    //    cmbServiceCodes.DataBind();
    //}

    //private void BindServiesTypesDropdown()
    //{
    //    var servicesTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_servicetype_list", new Dictionary<string, object>());
    //    cmbServiceChargeServiceTypes.DataSource = servicesTypes;
    //    cmbServiceChargeServiceTypes.DataBind();
    //}

    private void ShowSelectedFeeScheduleInformation()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"FeeScheduleID",cmbFeeSchedules.SelectedValue},
                                {"@UserID", ClientSession.UserID}
                            };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_feeschedule_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            cmbCarriers.SelectedValue = row["CarrierID"].ToString();
            txtDescriptiveName.Text = row["ScheduleName"].ToString();
            txtDisplayName.Text = row["ScheduleAbbr"].ToString();
            txtReferenceID.Text = row["ReferenceID"].ToString();
            txtNotes.Text = row["Notes"].ToString();

            cmbStatusTypes.SelectedValue = Convert.ToBoolean(row["FlagActive"]) ? "1" : "0";
            cmbServiceTypes.SelectedValue = row["ServiceClassID"].ToString();
            cmbProviders.SelectedValue = row["ProviderID"].ToString();
            cmbContractTypes.SelectedValue = Convert.ToBoolean(row["FlagContract"]) ? "1" : "0";
            cmbReimbursement.SelectedValue = Convert.ToBoolean(row["FlagPtReimb"]) ? "1" : "0";
            dtExpiration.SelectedDate = Convert.ToDateTime(row["DateExpiration"].ToString());
            cmbGlobalSchedule.SelectedValue = Convert.ToBoolean(row["FlagGlobal"]) ? "1" : "0";
            ValidateGlobalSchedule();

            divManageFeeSchdule.Visible = true;

            if (Convert.ToBoolean(row["FlagLocked"]))
            {
               // divNewServiceCode.Visible = false;
                cmbProviders.Enabled = false;
                rqdProivders.Enabled = false;
                cmbProviders.ClearSelection();

                btnSubmit.Enabled = false;
                btnSubmit.ImageUrl = "../Content/Images/btn_update_fade.gif";
              //  btnNewServiceCode.Enabled = false;
              //  btnNewServiceCode.ImageUrl = "../Content/Images/btn_new_fade.gif";
             //   btnServiceChargeSubmit.Enabled = false;
             //   btnServiceChargeSubmit.Visible = false;
                divIndividualPractices.Visible = true;
                divManageFeeSchdule.Visible = false;
            }
        }
    }

    protected void btnNewFeeSchedule_Click(object sender, EventArgs e)
    {
        // Preparing the page for adding the FeeSchedule
        pnlExistingFeeSchedule.Enabled = false;
        pnlFeeScheduleDetail.Visible = true;
        ClientSession.ObjectID = 0;
        LoadFeeScheduleSection();
        pnlExistingFeeSchedule.Visible = false;
        ShowDefaultValue();
        hFeeScheduleTitle.Visible = true;
    }

    protected void cmbGlobalSchedule_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        ValidateGlobalSchedule();
        cmbProviders.ClearSelection();
    }

    private void ValidateGlobalSchedule()
    {
        cmbProviders.Enabled = (!Convert.ToBoolean(cmbGlobalSchedule.SelectedValue == ((int)YesNo.Yes).ToString()));
        rqdProivders.Enabled = (!Convert.ToBoolean(cmbGlobalSchedule.SelectedValue == ((int)YesNo.Yes).ToString()));
    }

    protected void cmbCarriers_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        if (cmbCarriers.SelectedValue != "0")
        {
            cmbContractTypes.Enabled = true;
            cmbReimbursement.Enabled = true;
            cmbContractTypes.ClearSelection();
            cmbReimbursement.ClearSelection();
            return;
        }
        cmbContractTypes.SelectedValue = ((int)ContractType.InNetwork).ToString();
        cmbReimbursement.SelectedValue = ((int)Reimbursement.DirecttoPractice).ToString();
        cmbContractTypes.Enabled = false;
        cmbReimbursement.Enabled = false;
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {

            var cmdParams = new Dictionary<string, object>() { 
                                                        { "@FeeScheduleID", string.IsNullOrEmpty(cmbFeeSchedules.SelectedValue) ? (object)DBNull.Value : cmbFeeSchedules.SelectedValue},
                                                        { "@ScheduleName", txtDescriptiveName.Text.Trim()},
                                                        { "@ScheduleAbbr", txtDisplayName.Text.Trim()},   
                                                        { "@ProviderID", cmbGlobalSchedule.SelectedValue == ((int)YesNo.Yes).ToString("") ? "0" : cmbProviders.SelectedValue },
                                                        { "@CarrierID", cmbCarriers.SelectedValue },
                                                        { "@FlagGlobal", cmbGlobalSchedule.SelectedValue },
                                                        { "@ServiceClassID", cmbServiceTypes.SelectedValue },
                                                        { "@FlagContract", cmbContractTypes.SelectedValue },
                                                        { "@ReferenceID", txtReferenceID.Text.Trim() },
                                                        { "@DateExpiration",  dtExpiration.SelectedDate },
                                                        { "@FlagPtReimb", cmbReimbursement.SelectedValue },
                                                        { "@Notes", txtNotes.Text.Trim()},
                                                        { "@FlagActive", cmbStatusTypes.SelectedValue},
                                                        { "@UserID", ClientSession.UserID},
                                                        { "@PracticeID ", ClientSession.PracticeID}
                                                            };


            var isFeeScheduleAlreadyExist = SqlHelper.ExecuteScalarProcedureParams("web_pr_feeschedule_add", cmdParams);
            string message;
            if (!string.IsNullOrEmpty(cmbFeeSchedules.SelectedValue))
            {
                message = "Record successfully updated.";
            }
            else
            {
                message = (int?)isFeeScheduleAlreadyExist != null ? "Record successfully updated." : "Record already exists.";
            }

            RadWindow.RadAlert(message, 350, 150, "", "reloadPage", "../Content/Images/success.png");

        }
        catch (Exception)
        {

            throw;
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        // CancelFeeScheduleSection();
    }

    // This code not related with Service Charge

    //private void CancelFeeScheduleSection()
    //{
    //    pnlExistingFeeSchedule.Enabled = true;
    //    cmbCarriers.SelectedValue = null;
    //    txtDescriptiveName.Text = string.Empty;
    //    txtDisplayName.Text = string.Empty;
    //    txtReferenceID.Text = string.Empty;
    //    txtNotes.Text = string.Empty;

    //    cmbStatusTypes.SelectedValue = null;
    //    cmbServiceTypes.SelectedValue = null;
    //    cmbProviders.SelectedValue = null;
    //    cmbContractTypes.SelectedValue = null;
    //    cmbReimbursement.SelectedValue = null;
    //    dtExpiration.SelectedDate = null;
    //}

    private void ShowDefaultValue()
    {
        cmbStatusTypes.SelectedValue = ((int)StatusType.Active).ToString();
        cmbServiceTypes.SelectedValue = ((int)DefaultSelectedTypes.ProfessionalOfficeVisit).ToString();
        dtExpiration.SelectedDate = new DateTime(2020, 12, 31);
    }


    #endregion

    #region Manage Service Charges

    protected void cmbServiceCodes_SelectedIndexChanged(object sender, EventArgs e)
    {
       // btnServiceChargeSubmit.ImageUrl = "../Content/Images/btn_update.gif";
     //   pnlServiceCharge.Visible = true;
      //  ShowSelectedServiceChargesInformation();
     //   cmbServiceCodes.Enabled = false;

        // Hide the new service button
       // divNewServiceCode.Visible = false;
    }

    //private void ShowSelectedServiceChargesInformation()
    //{
    //    var cmdParams = new Dictionary<string, object>
    //                        {
    //                            {"FeeScheduleID",cmbFeeSchedules.SelectedValue},
    //                            {"CPTCode",cmbServiceCodes.SelectedValue}
    //                        };
    //    var feeScheduleCpt = SqlHelper.ExecuteDataTableProcedureParams("web_pr_feeschedulecpt_get", cmdParams);
    //    if (feeScheduleCpt.Read())
    //    {
    //        txtServiceCode.Text = feeScheduleCpt["CPTCode"].ToString();
    //        txtShortName.Text = feeScheduleCpt["CPTAbbr"].ToString();
    //        txtInvoiceName.Text = feeScheduleCpt["CPTName"].ToString();
    //        txtDescription.Text = feeScheduleCpt["CPTDesc"].ToString();
    //        cmbServiceChargeServiceTypes.SelectedValue = feeScheduleCpt["ServiceTypeID"].ToString();
    //        txtCategory.Text = feeScheduleCpt["CPTCategory"].ToString();
    //        txtProviderCharge.Text = feeScheduleCpt["ProviderCharge"].ToString();
    //        txtAllowable.Text = feeScheduleCpt["Allowable"].ToString();
    //    }
    //    feeScheduleCpt.Close();
    //}

    //protected void btnNewServiceCode_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        BindServiesTypesDropdown();
    //        divTopServicePanel.Visible = false;
    //        hServiceTitle.Visible = true;
    //        pnlServiceCharge.Visible = true;
    //        ClearAllFields();
    //    }
    //    catch (Exception)
    //    {

    //        throw;
    //    }
    //}


    //protected void btnServiceChargeSubmit_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        var cmdParams = new Dictionary<string, object>() { 
    //                                                    { "@FeeScheduleID", cmbFeeSchedules.SelectedValue},
    //                                                    { "@CPTCode", txtServiceCode.Text},
    //                                                    { "@CPTAbbr", txtShortName.Text.Trim()},   
    //                                                    { "@CPTName", txtInvoiceName.Text.Trim()},
    //                                                    { "@CPTDesc", txtDescription.Text.Trim()},

    //                                                    { "@ServiceTypeID", cmbServiceChargeServiceTypes.SelectedValue },
    //                                                    { "@CPTCategory", txtCategory.Text.Trim()},
    //                                                    { "@ProviderCharge", txtProviderCharge.Text.Trim() },
    //                                                    { "@Allowable",  txtAllowable.Text.Trim()},
    //                                                    { "@UserID", ClientSession.UserID}
    //                                                        };

    //        SqlHelper.ExecuteScalarProcedureParams("web_pr_feeschedulecpt_add", cmdParams);
    //        var message = string.IsNullOrEmpty(cmbServiceCodes.SelectedValue) ? "Record successfully created." : "Record successfully updated.";
    //        RadWindow.RadAlert(message, 350, 150, "", "reloadPage", "../Content/Images/success.png");
    //        hdnIsRebind.Value = "1";
    //    }
    //    catch (Exception)
    //    {

    //        throw;
    //    }
    //}

    //protected void btnServiceChargeCancel_Click(object sender, EventArgs e)
    //{
    //    divTopServicePanel.Visible = true;
    //    pnlServiceCharge.Visible = false;

    //    hServiceTitle.Visible = false;
    //    cmbServiceCodes.ClearSelection();
    //    cmbServiceCodes.Enabled = true;
    //    divNewServiceCode.Visible = true;
    //}

    //private void ClearAllFields()
    //{
    //    cmbServiceCodes.ClearSelection();
    //    txtShortName.Text = string.Empty;
    //    txtServiceCode.Text = string.Empty;
    //    txtInvoiceName.Text = string.Empty;
    //    txtDescription.Text = string.Empty;
    //    txtCategory.Text = string.Empty;
    //    cmbServiceChargeServiceTypes.ClearSelection();
    //    txtProviderCharge.Text = string.Empty;
    //    txtAllowable.Text = string.Empty;
    //}

    protected void ShowPopup(object sender, EventArgs e)
    {

        if (sender is ImageButton)
        {
            var button = sender as ImageButton;
            if (button.ID == "btnViewFullSchedule")
                popupFeeSchedule.VisibleOnPageLoad = true;
            else
                popupImportFeeSchedule.VisibleOnPageLoad = true;    
        }
        else
        {
            var button = sender as LinkButton;
            if (button.ID == "lnkManageFeeScheduleCodes")
                popupFeeSchedule.VisibleOnPageLoad = true;
            else
                popupImportFeeSchedule.VisibleOnPageLoad = true;    
        }

        

    }

    //protected void btnReset_OnClick(object sender, EventArgs e)
    //{
    //    ClearAllFields();
    //    divTopServicePanel.Visible = true;
    //    cmbServiceCodes.Enabled = true;
    //    divNewServiceCode.Visible = true;
    //    hServiceTitle.Visible = false;
    //    pnlServiceCharge.Visible = false;
    //    BindServiceCodes();
    //    hdnIsRebind.Value = "0";
    //}

    #endregion

    #region Download Sample CPT File

    protected void lnkDownloadSampleFile_OnClick(object sender, EventArgs e)
    {
        var path = Request.MapPath("~/App_Data/CPTImport/SampleImportFile.xlsx");
        var returnmsg = PDFServices.FileDownload(path, "SampleImportFile.xlsx");
        if (returnmsg != "")
        {
            RadWindow.RadAlert("File does not exist.", 350, 150, "", "", "../Content/Images/warning.png");
        }
    }

    #endregion
}