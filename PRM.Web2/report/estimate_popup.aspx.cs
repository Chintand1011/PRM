using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using System.Data;
using Telerik.Web.UI;

public partial class estimate_popup : BasePage
{
    private Int32 maximumRows = 20;

    private Int32 ErrorsCount
    {
        get
        {
            if (ClientSession.ListofObject == null)
            {
                ClientSession.ListofObject = new List<int>();
            }

            return (ClientSession.ListofObject as List<int>).Count;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ClientSession.WasRequestFromPopup = true;

        if (!Page.IsPostBack)
        {
            // Binding the dropdowns
            BindPatient();
            BindEligibilities();
            BindRelations();
            BindProviders();
            BindServiceTypes();
            BindServicePlaceList();

            //Estimate HCPCS Grid
            if (ClientSession.ObjectID == null)
            {
                grdHcpcs.DataSource = GetHcpcsList();
                grdHcpcs.DataBind();

                //Manage the Grid Rows
                ManageGridRows();
            }

            // Initialize for first time
            ClientSession.ListofObject = new List<int>();
            hdnFilledRows.Value = "0";

            //For Edit Case
            FillEstimateInformation();

            // [Self Pay – No Insurance]  have a value of EligibilityID = 0
            // Fee Schedule, [Default / Primary Self Pay], which is ID = 1
            if (cmbEligibility.SelectedValue == "0")
            {
                cmbFeeSchedules.SelectedValue = "1";
                ManageSectionsWhenFeeScheduleChange();
            }

        }
        popupMessage.VisibleOnPageLoad = false;

    }


    private void BindPatient()
    {
        var userName = ClientSession.PatientLastName + ", " + ClientSession.PatientFirstName;
        cmbPatients.Items.Add(new RadComboBoxItem { Text = userName, Value = "0" });
        cmbPatients.SelectedIndex = 0;
    }

    private void BindEligibilities()
    {
        var cmdParams = new Dictionary<string, object>() 
                            { 
                                {"@PatientID", ClientSession.SelectedPatientID } 
                            };

        var eligibilities = SqlHelper.ExecuteDataTableProcedureParams("web_pr_eligibility_list", cmdParams);
        cmbEligibility.DataSource = eligibilities;
        cmbEligibility.DataBind();

        if (eligibilities.Rows.Count != 1) return;
        cmbEligibility.SelectedIndex = 0;
        ManageSectionsWhenEligibilityChange();
    }

    private void BindRelations()
    {
        var cmdParams = new Dictionary<string, object>();
        var relations = SqlHelper.ExecuteDataTableProcedureParams("web_pr_relationtype_list", cmdParams);

        cmbRelations.DataSource = relations;
        cmbRelations.DataBind();
    }

    private void BindProviders()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } };
        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);

        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();
        cmbProviders.SelectedValue = ClientSession.SelectedPatientProviderID.ToString();
        ManageSectionsWhenProviderChange();
    }



    private void BindServiceTypes()
    {
        var cmdParams = new Dictionary<string, object>();
        var serviceTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_serviceclass_list", cmdParams);

        cmbServiceType.DataSource = serviceTypes;
        cmbServiceType.DataBind();
    }

    private void BindServicePlaceList()
    {
        var cmdParams = new Dictionary<string, object>();
        var servicePlace = SqlHelper.ExecuteDataTableProcedureParams("web_pr_serviceplace_list", cmdParams);

        cmbPlaceTypes.DataSource = servicePlace;
        cmbPlaceTypes.DataBind();
    }

    private List<Hcpcs> GetHcpcsList()
    {
        var listHcpcs = new List<Hcpcs>();
        for (var i = 1; i <= 10; i++)
        {
            //listHcpcs.Add(new Hcpcs { SerialNo = i, Quantity = "1", Dated = DateTime.Now });
            listHcpcs.Add(new Hcpcs { SerialNo = i });
        }

        return listHcpcs;
    }


    private Hcpcs GetSelectedHcpcsInformation(string cpt, int? estimateID, int rowNo)
    {
        var cmdParams = new Dictionary<string, object>() { 
                                                         { "@HCPCS", cpt },
                                                         { "@ProviderID", cmbProviders.SelectedValue },
                                                         { "@FeeScheduleID", cmbFeeSchedules.SelectedValue },
                                                         { "@PlaceofServiceID", cmbPlaceTypes.SelectedValue },
                                                         { "@FlagInNetwork", rdbtnInNetwork.Checked },
                                                         { "@EstimateID", estimateID },
                                                         { "@CPTLineID", rowNo },
                                                         { "@UserID", ClientSession.UserID}
                                                         };
        var hcpcs = new Hcpcs();
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_hcpcs_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            hcpcs.FieldS = row["StatusCode"].ToString();
            hcpcs.Description = row["DescMed"].ToString();
            //hcpcs.Charge = row["Charge$"].ToString();
            hcpcs.Charge = row["Charge"].ToString();
        }
        return hcpcs;
    }


    protected void btnCpt_OnClick(object sender, EventArgs e)
    {
        try
        {
            var estimateID = ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.Estimate
                                 ? Convert.ToInt32(ClientSession.ObjectID)
                                 : (int?)null;

            var button = (sender as Button);

            var dataItem = button.NamingContainer as GridDataItem;
            var serialNo = Convert.ToInt32(dataItem.GetDataKeyValue("SerialNo"));

            // For Delete Images and up and down Images
            var tblControls = dataItem["Controls"].FindControl("tblControls") as HtmlTable;

            var textboxCPT = dataItem["CPT"].FindControl("txtCPTNumber") as TextBox;

            // Validate if enterd CPT is greater than 5
            if (textboxCPT.Text.Trim().Length == 5)
            {
                var hcpcs = GetSelectedHcpcsInformation(textboxCPT.Text.Trim(), estimateID, serialNo);
                // If null means there is no any record matched with the entered CPT.
                if (string.IsNullOrEmpty(hcpcs.FieldS))
                {
                    // Showing the error according the row no.
                    var serialNumber = ClientSession.ListofObject as List<int>;
                    serialNumber.Add(serialNo);
                    textboxCPT.Focus();
                    tblControls.Visible = false;
                    // Reseting the values in case of worng CPT
                    ResetFields(sender);
                    ShowValidationError();
                    HidingAllUpDownAndDeleteButtons();
                    return;
                }

                // If entered CPT is valid then showing the records where request was received
                var textboxFieldS = dataItem["FieldS"].FindControl("txtS") as TextBox;
                textboxFieldS.Text = hcpcs.FieldS;

                var textboxDesc = dataItem["Description"].FindControl("txtDescription") as TextBox;
                textboxDesc.Text = hcpcs.Description;
                textboxDesc.Enabled = false;

                var textboxCharge = dataItem["Charge"].FindControl("txtCharge") as RadNumericTextBox;
                textboxCharge.Text = hcpcs.Charge.Replace("$", "");
                textboxCharge.Enabled = false;

                var textboxQuantity = dataItem["Quantity"].FindControl("txtQuantity") as TextBox;
                textboxQuantity.Text = "1";
                textboxQuantity.Focus();
                textboxQuantity.Enabled = true;

                var dtDated = dataItem["Date"].FindControl("dtDate") as RadDatePicker;
                dtDated.SelectedDate = DateTime.Now;
                dtDated.Enabled = true;

                var textboxAdjustment = dataItem["Adjustment"].FindControl("txtAdjustment") as RadNumericTextBox;
                textboxAdjustment.Text = "0";
                textboxAdjustment.Enabled = true;

                // Custom Validations
                ValidateCPTNo(serialNo);
                tblControls.Visible = true;

                if (ErrorsCount > 0)
                    ShowHideUpDownandDeleteButtons(false, serialNo);

                EnableNextRow(serialNo);
                EnableDisableDownButton(serialNo);
                EnableDisableShowMoreRowsButton(true);
                DisplayingAllUpDownandDeleteButtons();

                // Enable the Description and the Charge for the 00000 CPT
                if (textboxCPT.Text.Trim() == "00000")
                    ManageCPTValidations(serialNo);
            }
            else
            {
                // Checking if user completed removed the entered CPT else showing the error image.
                if (textboxCPT.Text.Length == 0)
                {
                    var serialNumbers = ClientSession.ListofObject as List<int>;
                    foreach (var serialNumber in serialNumbers.ToList())
                    {
                        if (serialNumber == serialNo)
                        {
                            serialNumbers.Remove(serialNumber);
                        }
                    }

                    // Disable the Input fields against serial No
                    var quantityTextBox = dataItem["Quantity"].FindControl("txtQuantity") as TextBox;
                    quantityTextBox.Enabled = false;

                    var dtDated = dataItem["Date"].FindControl("dtDate") as RadDatePicker;
                    dtDated.Enabled = false;

                    var textBoxDecription = dataItem["Description"].FindControl("txtDescription") as TextBox;
                    textBoxDecription.Enabled = false;

                    var textboxCharge = dataItem["Charge"].FindControl("txtCharge") as RadNumericTextBox;
                    textboxCharge.Enabled = false;

                    var textboxAdjustment = dataItem["Adjustment"].FindControl("txtAdjustment") as RadNumericTextBox;
                    textboxAdjustment.Enabled = false;

                    // Validations
                    textboxCPT.Focus();
                    ResetFields(sender);
                    tblControls.Visible = false;
                    var cstmValidatorDate = grdHcpcs.MasterTableView.Items[serialNo - 1].FindControl("cstmValidatorDate") as CustomValidator;
                    cstmValidatorDate.Enabled = false;
                    var customValidator = grdHcpcs.MasterTableView.Items[serialNo - 1].FindControl("cstmValidatorDescription") as CustomValidator;
                    customValidator.Enabled = false;
                    var cstmValidatorCharge = grdHcpcs.MasterTableView.Items[serialNo - 1].FindControl("cstmValidatorCharge") as CustomValidator;
                    cstmValidatorCharge.Enabled = false;
                }
                else
                {
                    // if user does not completly removed the CPT from row then show the error message to the user.
                    var serialNumber = ClientSession.ListofObject as List<int>;
                    serialNumber.Add(serialNo);
                    textboxCPT.Focus();
                    ResetFields(sender);
                    tblControls.Visible = false;
                }
            }

            // Showing error if any Serial No exits according to the validation.
            ShowValidationError();
        }
        catch (Exception)
        {

            throw;
        }
    }

    private void ValidateCPTNo(int serialNo)
    {
        // If user enters wrong CPT and then enter the correct then removing the Row no from list in order to enable the submit button

        var serialNumbers = ClientSession.ListofObject as List<int>;
        foreach (var serialNumber in serialNumbers.ToList())
        {
            if (serialNumber == serialNo)
            {
                serialNumbers.Remove(serialNo);

            }
        }

        if (serialNumbers.Count == 0)
        {
            // if Grid's rows count == 0 the disabling the submit button and also if Manage the grid rows accordingly.
            EnableDisableSubmitButton(true);
            ValidationOnShowMoreLessButtons();
        }
    }

    private void HidingAllUpDownAndDeleteButtons()
    {
        foreach (var tableControls in from GridDataItem item in grdHcpcs.Items let descTextbox = item.FindControl("txtDescription") as TextBox where !string.IsNullOrEmpty(descTextbox.Text) select item.FindControl("tblControls") as HtmlTable)
        {
            tableControls.Visible = false;
        }
    }

    private void DisplayingAllUpDownandDeleteButtons()
    {
        var serialNumbers = ClientSession.ListofObject as List<int>;
        if (serialNumbers.Count == 0)
        {
            foreach (var tableControls in from GridDataItem item in grdHcpcs.Items let descTextbox = item.FindControl("txtDescription") as TextBox where !string.IsNullOrEmpty(descTextbox.Text) select item.FindControl("tblControls") as HtmlTable)
            {
                tableControls.Visible = true;
            }
        }
    }

    private void ShowHideUpDownandDeleteButtons(bool isVisible, int serialNo)
    {
        serialNo = serialNo == 0 ? 0 : serialNo - 1;
        var tableControls = grdHcpcs.Items[serialNo].FindControl("tblControls") as HtmlTable;
        tableControls.Visible = isVisible;
    }

    private void ValidationOnShowMoreLessButtons()
    {
        // Getting the row count for validated CPTs
        var rows = GetValidatedCptCount();
        // Adjusting the rows and also Enabling and Disabling the 'ShowMore' and "ShowLess" buttons
        if (rows >= 10)
        {
            lnkShowFewer.ImageUrl = "../Content/Images/btn_showless_fade.gif";
            lnkShowFewer.Enabled = false;

            if (grdHcpcs.Items.Count >= 15 && (rows == 15 || rows == 10))
            {
                lnkShowFewer.ImageUrl = "../Content/Images/btn_showless.gif";
                lnkShowFewer.Enabled = true;
            }

        }
    }

    private void ShowValidationError()
    {
        var count = 0;
        // Getting all serialno which have error 
        var serialNumbers = ClientSession.ListofObject as List<int>;
        // if serial no matched with saved serial no then showing the erros on each row
        foreach (var serialNumber in serialNumbers)
        {
            var validator = grdHcpcs.Items[serialNumber - 1].FindControl("cstmValidator") as CustomValidator;
            validator.IsValid = false;
            count++;
        }

        // Also enabling and disabling the Submit button according to total no of rows.
        var gridRows = GetValidatedCptCount();
        if (count == 0 && gridRows > 0)
            EnableDisableSubmitButton(true);
    }

    protected void btnUp_OnClick(object sender, EventArgs e)
    {
        // Getting the all rows object where request was made from grid
        var imageButton = (sender as ImageButton);
        var dataItem = imageButton.NamingContainer as GridDataItem;
        MovingTheRow(dataItem, true);
    }

    protected void btnDown_OnClick(object sender, EventArgs e)
    {
        // Getting the all rows object where request was made from grid
        var imageButton = (sender as ImageButton);
        var dataItem = imageButton.NamingContainer as GridDataItem;
        MovingTheRow(dataItem, false);
    }

    private void MovingTheRow(GridDataItem dataItem, bool isMoveUp)
    {
        var currentRowNo = 0;
        var currentCPTNo = string.Empty;

        var hcpcs = new Hcpcs();
        var serialNo = Convert.ToInt32(dataItem.GetDataKeyValue("SerialNo"));
        var tblControls = dataItem["Controls"].FindControl("tblControls") as HtmlTable;

        // Getting the all values from the current row
        currentRowNo = serialNo;

        var txtCPTNo = dataItem["CPT"].FindControl("txtCPTNumber") as TextBox;
        currentCPTNo = txtCPTNo.Text;

        var textboxFieldS = dataItem["FieldS"].FindControl("txtS") as TextBox;

        var textboxDesc = dataItem["Description"].FindControl("txtDescription") as TextBox;

        var textboxCharge = dataItem["Charge"].FindControl("txtCharge") as RadNumericTextBox;

        var textboxQuantity = dataItem["Quantity"].FindControl("txtQuantity") as TextBox;

        var dtDated = dataItem["Date"].FindControl("dtDate") as RadDatePicker;

        var textboxAdjustment = dataItem["Adjustment"].FindControl("txtAdjustment") as RadNumericTextBox;


        // Increment or Decrement the count, so that to move the row.
        serialNo = isMoveUp ? serialNo - 1 : serialNo + 1;
        // Saving the current row data in object in order to use later and also assigning the value from object that we created above
        foreach (GridDataItem item in grdHcpcs.Items)
        {
            var serialNumber = Convert.ToInt32(item.GetDataKeyValue("SerialNo"));
            if (serialNumber == serialNo)
            {
                hcpcs.SerialNo = serialNo;

                var txtCPTNumber = (TextBox)item.FindControl("txtCPTNumber");
                hcpcs.CptNo = txtCPTNumber.Text;
                txtCPTNumber.Text = txtCPTNo.Text;
                txtCPTNumber.Enabled = true;

                var txtQuantity = (TextBox)item.FindControl("txtQuantity");
                hcpcs.Quantity = txtQuantity.Text;
                txtQuantity.Text = textboxQuantity.Text;
                txtQuantity.Enabled = true;

                var dtDate = (RadDatePicker)item.FindControl("dtDate");
                hcpcs.Dated = dtDate.SelectedDate;
                dtDate.SelectedDate = dtDated.SelectedDate;
                dtDate.Enabled = true;

                var txtS = (TextBox)item.FindControl("txtS");
                hcpcs.FieldS = txtS.Text;
                txtS.Text = textboxFieldS.Text;

                var txtDescription = (TextBox)item.FindControl("txtDescription");
                hcpcs.Description = txtDescription.Text;
                txtDescription.Text = textboxDesc.Text;

                var txtCharge = (RadNumericTextBox)item.FindControl("txtCharge");
                hcpcs.Charge = txtCharge.Text;
                txtCharge.Text = textboxCharge.Text;

                var txtAdjustment = (RadNumericTextBox)item.FindControl("txtAdjustment");
                hcpcs.AdjustMent = Convert.ToDecimal(txtAdjustment.Text = txtAdjustment.Text == string.Empty ? "0" : txtAdjustment.Text);
                txtAdjustment.Text = textboxAdjustment.Text;
                txtAdjustment.Enabled = true;

                var divControls = item.FindControl("tblControls") as HtmlTable;
                divControls.Visible = true;
            }

        }

        // Resetting the current row
        txtCPTNo.Text = hcpcs.CptNo;

        textboxFieldS.Text = hcpcs.FieldS;

        textboxDesc.Text = hcpcs.Description;

        textboxCharge.Text = hcpcs.Charge;

        textboxQuantity.Text = hcpcs.Quantity;

        dtDated.SelectedDate = hcpcs.Dated;

        textboxAdjustment.Text = hcpcs.AdjustMent.ToString() == "0" && string.IsNullOrEmpty(hcpcs.CptNo) ? string.Empty : hcpcs.AdjustMent.ToString();

        // Validations
        if (string.IsNullOrEmpty(hcpcs.CptNo))
        {
            textboxQuantity.Enabled = false;
            dtDated.Enabled = false;
            textboxAdjustment.Enabled = false;
        }
        tblControls.Visible = !string.IsNullOrEmpty(hcpcs.CptNo) ? true : false;

        // Enable Row for special cprt no 00000
        if (currentCPTNo == "00000" && hcpcs.CptNo == "00000")
        {
            foreach (var rowNo in from GridDataItem item in grdHcpcs.Items let cpt = item.FindControl("txtCPTNumber") as TextBox where cpt.Text == "00000" select Convert.ToInt32(item["SerialNo"].Text))
            {
                EnableDisableDiscriptionandChargeFields(rowNo - 1, true);
            }

            return;
        }

        if (currentCPTNo == "00000")
        {
            var rowNo = isMoveUp ? currentRowNo - 2 : currentRowNo;
            EnableDisableDiscriptionandChargeFields(rowNo, true);

            rowNo = currentRowNo - 1;

            EnableDisableDiscriptionandChargeFields(rowNo, false);
        }
        else
        {
            if (hcpcs.CptNo == "00000")
            {
                var rowNo = hcpcs.SerialNo - 1;

                EnableDisableDiscriptionandChargeFields(rowNo, false);

                rowNo = isMoveUp ? hcpcs.SerialNo : hcpcs.SerialNo - 2;

                EnableDisableDiscriptionandChargeFields(rowNo, true);


            }
        }
    }

    private void ResetFields(object sender)
    {
        var button = (sender as Button);
        var dataItem = button.NamingContainer as GridDataItem;

        var textboxFieldS = dataItem["FieldS"].FindControl("txtS") as TextBox;
        textboxFieldS.Text = string.Empty;

        var textboxDesc = dataItem["Description"].FindControl("txtDescription") as TextBox;
        textboxDesc.Text = string.Empty;

        var textboxCharge = dataItem["Charge"].FindControl("txtCharge") as RadNumericTextBox;
        textboxCharge.Text = string.Empty;

        var textboxQuantity = dataItem["Quantity"].FindControl("txtQuantity") as TextBox;
        textboxQuantity.Text = string.Empty;

        var dtDated = dataItem["Date"].FindControl("dtDate") as RadDatePicker;
        dtDated.Clear();

        var textboxAdjustment = dataItem["Adjustment"].FindControl("txtAdjustment") as RadNumericTextBox;
        textboxAdjustment.Text = string.Empty;

        EnableDisableSubmitButton(false);

    }

    #region Top Section

    protected void cmbPatients_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            BindEligibilities();
            cmbEligibility.Enabled = true;
            ManageTopSection();
        }
        catch (Exception)
        {

            throw;
        }
    }

    protected void cmbEligibility_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            ManageSectionsWhenEligibilityChange();
        }
        catch (Exception)
        {

            throw;
        }
    }


    protected void cmbRelations_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            ManageTopSection();
        }
        catch (Exception)
        {

            throw;
        }
    }

    private void ManageSectionsWhenEligibilityChange()
    {
        ManageTopSection();
        GetSelectedEligibilityInformation();
        ResetMiddleSection();



        if (cmbEligibility.SelectedValue != "0")
        {
            RemoveEligibilityValidations();
            EnableDisableSubmitButton(false);
            return;
        }

        ApplyEligibilityValidations();

    }

    private void ManageTopSection()
    {
        if (ClientSession.SelectedPatientID > 0 && cmbEligibility.SelectedValue != "")
        {
            pnlMiddle.Enabled = true;
        }
    }

    private void GetSelectedEligibilityInformation()
    {
        var cmdParams = new Dictionary<string, object>() { 
                                                         { "@PatientID", ClientSession.SelectedPatientID },
                                                         { "@EligibilityID", cmbEligibility.SelectedValue },
                                                         { "@UserID", ClientSession.UserID}
                                                         };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_eligibility_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            txtCarrierName.Text = row["CarrierName"].ToString();
            dtEligibilityDate.SelectedDate = Convert.ToDateTime(row["SubmitDate"]);
            txtPlanStatus.Text = row["HBP_Status_Gen"].ToString();

            txtCoPayAmount.Text = row["Elig_Prof_CoPay_Ind_IN_Visit$"].ToString();
            txtCoInsurance.Text = row["Elig_Prof_CoIns_Ind_IN_Visit_Abbr"].ToString();

            txtDeduct.Text = row["Elig_HBP_Ded_Ind_IN_CY$"].ToString();
            txtDeductCYTD.Text = row["Elig_HBP_Ded_Ind_IN_YTD$"].ToString();

            txtStopLoss.Text = row["Elig_HBP_OoP_Ind_IN_CY$"].ToString();
            txtStopLossCYT.Text = row["Elig_HBP_OoP_Ind_IN_YTD$"].ToString();

            cmbRelations.SelectedValue = row["RelationTypeID"].ToString();
        }
    }

    #endregion


    #region Middle Section

    protected void cmbProviders_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            ManageSectionsWhenProviderChange();
        }
        catch (Exception)
        {

            throw;
        }
    }

    private void ManageSectionsWhenProviderChange()
    {
        ManageMiddleSection();
        GetSelectedProviderInformation();
        cmbFeeSchedules.Enabled = true;
        BindFeeScheduleList();
        EnableDisableSubmitButton(false);
    }

    private void GetSelectedProviderInformation()
    {
        var cmdParams = new Dictionary<string, object>() { 
                                                         { "@ProviderID", cmbProviders.SelectedValue },
                                                         { "@EligibilityID", cmbEligibility.SelectedValue },
                                                         { "@UserID", ClientSession.UserID}
                                                         };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            txtServiceZip.Text = row["ServiceZip"].ToString();
            cmbServiceType.SelectedValue = row["ServiceClassTypeID"].ToString();
            cmbPlaceTypes.SelectedValue = row["PlaceOfServiceTypeID"].ToString();
            // cmbFeeSchedules.SelectedValue = row["FeeScheduleID"].ToString();
        }
        ManageMiddleSection();
    }

    protected void cmbServiceType_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            ManageMiddleSection();
        }
        catch (Exception)
        {
            throw;
        }
    }

    protected void cmbPlaceTypes_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            ManageMiddleSection();
            var count = GetValidatedCptCount();
            if (count > 0)
            {
                ReEstimateCptCost();
                EnableDisableSubmitButton(true);
            }
        }
        catch (Exception)
        {

            throw;
        }
    }

    protected void cmbFeeSchedules_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            ManageSectionsWhenFeeScheduleChange();
        }
        catch (Exception)
        {

            throw;
        }
    }


    private void ManageSectionsWhenFeeScheduleChange()
    {
        ManageMiddleSection();
        var count = GetValidatedCptCount();
        if (count > 0)
        {
            ReEstimateCptCost();
            EnableDisableSubmitButton(true);
        }

        var feeSchedules = ClientSession.Object;
        var feeSchedule = feeSchedules.Select("FeeScheduleID = '" + cmbFeeSchedules.SelectedValue + "'").Select(res => res.ItemArray).ToList();
        var contractFlag = Convert.ToBoolean(feeSchedule[0][3].ToString());
        if (contractFlag)
        {
            rdbtnInNetwork.Checked = true;
            rdbtnOutNetwork.Checked = false;
        }
        else
        {

            rdbtnInNetwork.Checked = false;
            rdbtnOutNetwork.Checked = true;
        }

        rdbtnInNetwork.Enabled = false;
        rdbtnOutNetwork.Enabled = false;
    }

    private void ManageMiddleSection()
    {
        if (cmbProviders.SelectedValue != "" && cmbServiceType.SelectedValue != "" && cmbPlaceTypes.SelectedValue != "" && cmbFeeSchedules.SelectedValue != "")
        {
            pnlBottomHCPCS.Enabled = true;
        }
    }

    #endregion




    protected void lnkShowMoreRows_Click(object sender, EventArgs e)
    {
        // Showing rows from the grid.
        if (ErrorsCount > 0)
        {
            ShowValidationError();
            return;
        }

        var currentHcpcsList = GetCurrentHcpcsList();
        var totalRows = maximumRows - currentHcpcsList.Count;

        if (currentHcpcsList.Count == 10)
        {
            lnkShowFewer.Enabled = true;
            lnkShowFewer.ImageUrl = "../Content/Images/btn_showless.gif";
            totalRows = 15;
        }
        else
        {
            lnkShowMoreRows.Enabled = false;
            lnkShowMoreRows.ImageUrl = "../Content/Images/btn_showmore_fade.gif";
            lnkShowFewer.Enabled = true;
            lnkShowFewer.ImageUrl = "../Content/Images/btn_showless.gif";
            totalRows = 20;
        }

        for (int i = currentHcpcsList.Count + 1; i <= totalRows; i++)
        {
            currentHcpcsList.Add(new Hcpcs { SerialNo = i });
        }

        grdHcpcs.DataSource = currentHcpcsList;
        grdHcpcs.DataBind();
        ManageGridRows();
    }

    protected void lnkShowFewer_Click(object sender, EventArgs e)
    {
        // Hidding rows from the grid
        if (ErrorsCount > 0)
        {
            ShowValidationError();
            return;
        }

        var currentHcpcsList = GetCurrentHcpcsList();
        var totalRows = maximumRows - currentHcpcsList.Count;

        if (currentHcpcsList.Count == 15)
        {
            lnkShowMoreRows.Enabled = true;
            lnkShowMoreRows.ImageUrl = "../Content/Images/btn_showmore.gif";
            lnkShowFewer.Enabled = false;
            lnkShowFewer.ImageUrl = "../Content/Images/btn_showless_fade.gif";
            totalRows = 10;
        }
        else
        {
            lnkShowMoreRows.Enabled = true;
            lnkShowMoreRows.ImageUrl = "../Content/Images/btn_showmore.gif";
            totalRows = 15;
            var rows = GetValidatedCptCount();
            if (rows > 10)
            {
                lnkShowFewer.Enabled = false;
                lnkShowFewer.ImageUrl = "../Content/Images/btn_showless_fade.gif";
            }
        }

        for (int i = currentHcpcsList.Count; i > totalRows; i--)
        {
            var hcpcs = currentHcpcsList.Single(res => res.SerialNo == i);
            currentHcpcsList.Remove(hcpcs);
        }

        grdHcpcs.DataSource = currentHcpcsList;
        grdHcpcs.DataBind();
        ManageGridRows();
    }

    private List<Hcpcs> GetCurrentHcpcsList()
    {
        var currentHcpcsList = new List<Hcpcs>();

        foreach (GridDataItem item in grdHcpcs.Items)
        {

            var txtCPTNumber = (TextBox)item.FindControl("txtCPTNumber");

            var txtQuantity = (TextBox)item.FindControl("txtQuantity");

            var dtDate = (RadDatePicker)item.FindControl("dtDate");

            var txtS = (TextBox)item.FindControl("txtS");

            var txtDescription = (TextBox)item.FindControl("txtDescription");

            var txtCharge = (RadNumericTextBox)item.FindControl("txtCharge");

            var txtAdjustment = (RadNumericTextBox)item.FindControl("txtAdjustment");

            currentHcpcsList.Add(new Hcpcs { SerialNo = item.ItemIndex + 1, CptNo = txtCPTNumber.Text.Trim(), Quantity = txtQuantity.Text.Trim(), Dated = dtDate.SelectedDate, FieldS = txtS.Text.Trim(), Description = txtDescription.Text.Trim(), Charge = txtCharge.Text.Trim(), AdjustMent = (txtAdjustment.Text.Trim() == string.Empty ? (decimal?)null : Convert.ToDecimal(txtAdjustment.Text.Trim())) });
        }
        return currentHcpcsList;
    }

    protected void btnDeleteRow_OnClick(object sender, EventArgs e)
    {
        var imageButton = (sender as ImageButton);
        var dataItem = imageButton.NamingContainer as GridDataItem;
        DeleteSelectedRow(Convert.ToInt32(dataItem.GetDataKeyValue("SerialNo").ToString()));
        ValidationOnShowMoreLessButtons();
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            if (!Page.IsValid)
            {
                return;
            }

            var currentHcpcsList = GetCurrentHcpcsList();

            var estimateID = 0;
            if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.Estimate)
                estimateID = Convert.ToInt32(ClientSession.ObjectID);

            var cmdParams = new Dictionary<string, object> { 
                                                         { "@EstimateID", estimateID > 0 ? estimateID : (object)DBNull.Value},
                                                         { "@PatientID", ClientSession.SelectedPatientID},
                                                         { "@EligibilityID", cmbEligibility.SelectedValue },
                                                         { "@RelTypeID", cmbRelations.SelectedValue },

                                                         { "@ProviderID", cmbProviders.SelectedValue },
                                                         { "@ServiceClassTypeID", cmbServiceType.SelectedValue },
                                                         { "@PlaceofServiceTypeID", cmbPlaceTypes.SelectedValue },
                                                         { "@FeeScheduleID", cmbFeeSchedules.SelectedValue },
                                                         { "@FlagInNetwork", rdbtnInNetwork.Checked },
                                                         { "@UserID", ClientSession.UserID }
                                                         
                                                         };

            for (int i = 0; i < currentHcpcsList.Count; i++)
            {
                var counter = i + 1;
                var serialNumber = counter >= 10 ? counter.ToString() : ("0" + counter);
                cmdParams.Add("@CPT" + serialNumber, currentHcpcsList[i].CptNo);
                cmdParams.Add("@Qty" + serialNumber, currentHcpcsList[i].Quantity);
                cmdParams.Add("@DoS" + serialNumber, currentHcpcsList[i].Dated);
                cmdParams.Add("@Adj" + serialNumber, currentHcpcsList[i].AdjustMent);
                cmdParams.Add("@Chg" + serialNumber, currentHcpcsList[i].Charge);
                cmdParams.Add("@Dsc" + serialNumber, currentHcpcsList[i].Description);
            }

            SqlHelper.ExecuteScalarProcedureParams("web_pr_estimate_add", cmdParams);
            RadWindow.RadAlert("Estimate has been successfully saved", 400, 100, "", "closeandRefreshPage", "../Content/Images/Success.png");
        }
        catch (Exception)
        {

            throw;
        }
    }

    private void ApplyEligibilityValidations()
    {
        cmbRelations.SelectedValue = ((int)DefaultSelectedTypes.RelationalNameSelf).ToString("");
        cmbRelations.Enabled = false;
        rdbtnInNetwork.Checked = false;
        rdbtnOutNetwork.Checked = true;
        rdbtnInNetwork.Enabled = false;
        rdbtnOutNetwork.Enabled = false;
    }

    private void BindFeeScheduleList()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@practiceID", ClientSession.PracticeID},
                                {"@providerID", cmbProviders.SelectedValue},   
                                {"@EligibilityID", cmbEligibility.SelectedValue},   
                            };
        var feeSchedule = SqlHelper.ExecuteDataTableProcedureParams("web_pr_feeschedule_list", cmdParams);
        ClientSession.Object = feeSchedule;
        cmbFeeSchedules.ClearSelection();
        cmbFeeSchedules.DataSource = feeSchedule;
        cmbFeeSchedules.DataBind();
    }

    private void RemoveEligibilityValidations()
    {
        cmbRelations.Enabled = true;
        rdbtnInNetwork.Enabled = true;
        rdbtnOutNetwork.Enabled = true;
    }

    private void ResetMiddleSection()
    {
        cmbProviders.ClearSelection();
        cmbServiceType.ClearSelection();
        cmbPlaceTypes.ClearSelection();
        cmbFeeSchedules.ClearSelection();
        rdbtnInNetwork.Checked = false;
        rdbtnOutNetwork.Checked = false;
        cmbFeeSchedules.Enabled = false;
    }

    private void FillEstimateInformation()
    {
        var estimateID = 0;
        var hcpcsListCount = 0;
        var grdHcpcsList = new List<Hcpcs>();

        if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.Estimate)
            estimateID = Convert.ToInt32(ClientSession.ObjectID);

        if (estimateID == 0) return;

        var cmdParams = new Dictionary<string, object> { { "@EstimateID", estimateID }, { "@UserID", ClientSession.UserID } };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_estimate_build_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            cmbEligibility.SelectedValue = row["EligibilityID"].ToString();
            cmbRelations.SelectedValue = row["RelTypeID"].ToString();
            cmbProviders.SelectedValue = row["ProviderID"].ToString();
            cmbServiceType.SelectedValue = row["ServiceClassTypeID"].ToString();
            cmbPlaceTypes.SelectedValue = row["PlaceofServiceTypeID"].ToString();

            // Bind FeeSchedule dropdown
            BindFeeScheduleList();

            cmbFeeSchedules.SelectedValue = row["FeeScheduleID"].ToString();
            rdbtnInNetwork.Checked = Convert.ToBoolean(row["FlagInNetwork"].ToString());

            for (var i = 1; i <= 9; i++)
            {
                if (!string.IsNullOrEmpty(row["CPT0" + i].ToString()))
                {
                    FillHcpcsList(grdHcpcsList, row["CPT0" + i].ToString(), row["DoS0" + i].ToString(), row["Qty0" + i].ToString(), row["Adj0" + i].ToString(), i);
                }
            }

            for (var j = 10; j <= 20; j++)
            {
                if (!string.IsNullOrEmpty(row["CPT" + j].ToString()))
                {
                    FillHcpcsList(grdHcpcsList, row["CPT" + j].ToString(), row["DoS" + j].ToString(), row["Qty" + j].ToString(), row["Adj" + j].ToString(), j);
                }
            }

        }

        // Bind the grdHcpcs grid
        hcpcsListCount = grdHcpcsList.Count;
        if (grdHcpcsList.Count < 10)
        {
            for (var i = grdHcpcsList.Count + 1; i <= 10; i++)
            {
                grdHcpcsList.Add(new Hcpcs { SerialNo = i });
            }
        }
        grdHcpcs.DataSource = grdHcpcsList;
        grdHcpcs.DataBind();

        // Manage Rows
        ManageGridRows();

        // Enable Downbutton
        EnableDisableDownButton(hcpcsListCount);

        // Enable the next row
        if (hcpcsListCount == 1)
            EnableNextRow(hcpcsListCount);

        // Validate show less button
        if (hcpcsListCount == 10 || hcpcsListCount == 15)
        {
            lnkShowFewer.ImageUrl = "../Content/Images/btn_showless.gif";
            lnkShowFewer.Enabled = true;
        }

        // Manage Validations

        cmbFeeSchedules.Enabled = true;
        ManageTopSection();
        ManageMiddleSection();
        GetSelectedProviderInformation();
        GetSelectedEligibilityInformation();
        EnableDisableSubmitButton(true);
        EnableDisableShowMoreRowsButton(true);
        if (cmbEligibility.SelectedValue != "0")
        {
            RemoveEligibilityValidations();
            return;
        }

        ApplyEligibilityValidations();

        // Manage the Contract Types
        rdbtnInNetwork.Checked = false;
        rdbtnOutNetwork.Checked = false;

        var feeSchedules = ClientSession.Object;
        var selectedFeeSchedule = feeSchedules.AsEnumerable().Single(feeSchedule => feeSchedule.Field<Int32>("FeeScheduleID") == Int32.Parse(cmbFeeSchedules.SelectedValue));
        var contractFlag = Convert.ToBoolean(selectedFeeSchedule["FlagContract"].ToString());
        if (contractFlag)
        {
            rdbtnInNetwork.Checked = true;
            rdbtnOutNetwork.Checked = false;
        }
        else
        {
            rdbtnInNetwork.Checked = false;
            rdbtnOutNetwork.Checked = true;
        }
    }

    private void FillHcpcsList(List<Hcpcs> grdHCPSList, string cptNo, string dos, string qty, string providerAdj, Int32 count)
    {
        var estimateID = ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.Estimate
                                ? Convert.ToInt32(ClientSession.ObjectID)
                                : (int?)null;
        var hcps = GetSelectedHcpcsInformation(cptNo, estimateID, count);
        grdHCPSList.Add(new Hcpcs { CptNo = cptNo, Quantity = qty, Dated = string.IsNullOrEmpty(dos) ? DateTime.Now : Convert.ToDateTime(dos), FieldS = hcps.FieldS, Description = hcps.Description, Charge = hcps.Charge.Replace("$", ""), AdjustMent = Convert.ToDecimal(providerAdj), SerialNo = count });

    }


    private void ManageGridRows()
    {
        var count = 0;
        var isFirstRowEmpty = false;
        // disbaling the rows on page load
        foreach (GridDataItem item in grdHcpcs.Items)
        {
            var serialNumber = item.GetDataKeyValue("SerialNo").ToString();
            var cptNumberField = item.FindControl("txtCPTNumber") as TextBox;
            if (serialNumber != "1" && string.IsNullOrEmpty(cptNumberField.Text))
            {
                cptNumberField.Enabled = false;

                var quantity = (TextBox)item.FindControl("txtQuantity");
                quantity.Enabled = false;

                var dtDate = (RadDatePicker)item.FindControl("dtDate");
                dtDate.Enabled = false;

                var txtAdjustment = (RadNumericTextBox)item.FindControl("txtAdjustment");
                txtAdjustment.Enabled = false;
            }
            else
            {
                if (string.IsNullOrEmpty(cptNumberField.Text))
                {
                    isFirstRowEmpty = true;
                    continue;
                }
                var tableControls = item.FindControl("tblControls") as HtmlTable;
                tableControls.Visible = true;
                EnableDisableNextRow(count, true);
                count++;
            }
        }

        var btnUp = grdHcpcs.Items[0].FindControl("btnUp") as ImageButton;
        btnUp.Enabled = false;

        if (count == 1 && !isFirstRowEmpty)
        {
            EnableNextRow(count);
        }
        else
        {
            EnableNextRow(count);
        }


        // Enable complete row for 00000 CPT
        EnableRowForSpecialCPT();

    }


    private void EnableDisableNextRow(int serialNo, bool isEnable)
    {
        // Enabling the next row according to the serial no

        var cptNo = grdHcpcs.Items[serialNo].FindControl("txtCPTNumber") as TextBox;
        cptNo.Enabled = isEnable;

        var quantity = grdHcpcs.Items[serialNo].FindControl("txtQuantity") as TextBox;
        quantity.Enabled = isEnable;

        var dtDate = grdHcpcs.Items[serialNo].FindControl("dtDate") as RadDatePicker;
        dtDate.Enabled = isEnable;

        var txtAdjustment = grdHcpcs.Items[serialNo].FindControl("txtAdjustment") as RadNumericTextBox;
        txtAdjustment.Enabled = isEnable;

        if (!string.IsNullOrEmpty(cptNo.Text))
        {
            var tblControls = grdHcpcs.Items[serialNo].FindControl("tblControls") as HtmlTable;
            tblControls.Visible = isEnable;
        }

    }


    private void EnableNextRow(int serialNo)
    {

        var totalRows = grdHcpcs.Items.Count;
        if (serialNo < totalRows)
        {
            var nextRowCPTNo = grdHcpcs.Items[serialNo].FindControl("txtCPTNumber") as TextBox;
            nextRowCPTNo.Enabled = true;
        }

    }

    private void EnableDisableDownButton(int serialNo)
    {
        serialNo = serialNo == 0 ? serialNo : serialNo - 1;
        var enableDownButton = grdHcpcs.MasterTableView.Items[serialNo == 0 ? serialNo : serialNo - 1].FindControl("btnDown") as ImageButton;
        enableDownButton.Enabled = true;
        if (serialNo == 0 && GetValidatedCptCount() > 1) return;
        var btnDown = grdHcpcs.MasterTableView.Items[serialNo].FindControl("btnDown") as ImageButton;
        btnDown.Enabled = false;
    }

    private void DeleteSelectedRow(int serialNo)
    {
        var count = 1;
        var gridRows = grdHcpcs.Items.Count;
        var hcpcsList = new List<Hcpcs>();
        foreach (var hcpcs in GetCurrentHcpcsList())
        {
            if (hcpcs.SerialNo != serialNo)
            {
                hcpcsList.Add(new Hcpcs { SerialNo = count, CptNo = hcpcs.CptNo, Quantity = hcpcs.Quantity, Dated = hcpcs.Dated, FieldS = hcpcs.FieldS, Description = hcpcs.Description, Charge = hcpcs.Charge, AdjustMent = hcpcs.AdjustMent });
                count++;
            }

        }

        // Make the total rows equals to grid before have
        for (var i = hcpcsList.Count + 1; i <= gridRows; i++)
        {
            hcpcsList.Add(new Hcpcs { SerialNo = i });
        }

        grdHcpcs.DataSource = hcpcsList;
        grdHcpcs.DataBind();

        // Reset the value of count
        count = 0;

        ManageGridRows();


        // Disable the Down button
        var countCPTRows = GetValidatedCptCount();
        EnableDisableDownButton(countCPTRows);

        if (countCPTRows == 0)
        {
            EnableDisableShowMoreRowsButton(false);
            EnableDisableSubmitButton(false);
        }


        // Enable the next row
        count++;
        foreach (GridDataItem item in grdHcpcs.Items)
        {
            var serialNumber = Convert.ToInt32(item.GetDataKeyValue("SerialNo"));
            if (serialNumber == count)
            {
                var cptNumber = (TextBox)item.FindControl("txtCPTNumber");
                cptNumber.Enabled = true;

            }
        }

    }

    private int GetValidatedCptCount()
    {
        return (from GridDataItem item in grdHcpcs.Items select item.FindControl("txtCPTNumber") as TextBox).Count(textBoxCpt => !string.IsNullOrEmpty(textBoxCpt.Text));
    }

    private void EnableDisableShowMoreRowsButton(bool isEnable)
    {
        if (isEnable)
        {
            if (ErrorsCount > 0) return;
            lnkShowMoreRows.ImageUrl = "../Content/Images/btn_showmore.gif";
            lnkShowMoreRows.Enabled = true;
        }
        else
        {
            lnkShowMoreRows.ImageUrl = "../Content/Images/btn_showmore_fade.gif";
            lnkShowMoreRows.Enabled = false;
        }
    }

    private void ReEstimateCptCost()
    {
        var estimateID = ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.Estimate
                                ? Convert.ToInt32(ClientSession.ObjectID)
                                : (int?)null;
        foreach (GridDataItem item in grdHcpcs.Items)
        {
            var textBoxCpt = item.FindControl("txtCPTNumber") as TextBox;
            if (!string.IsNullOrEmpty(textBoxCpt.Text))
            {
                var serialNo = item["SerialNo"].Text;

                var hcpcs = GetSelectedHcpcsInformation(textBoxCpt.Text.Trim(), estimateID, Convert.ToInt32(serialNo));
                var textboxFieldS = item.FindControl("txtS") as TextBox;
                textboxFieldS.Text = hcpcs.FieldS;

                var textboxDesc = item.FindControl("txtDescription") as TextBox;
                textboxDesc.Text = hcpcs.Description;

                var textboxCharge = item.FindControl("txtCharge") as RadNumericTextBox;
                textboxCharge.Text = hcpcs.Charge;
            }
        }
    }

    private void EnableDisableSubmitButton(bool isEnable)
    {
        btnSubmit.ImageUrl = isEnable ? "../Content/Images/btn_submit.gif" : "../Content/Images/btn_submit_Fade.gif";
        btnSubmit.Enabled = isEnable;
    }

    private void ManageCPTValidations(int serialNo)
    {
        serialNo = serialNo - 1;
        var description = grdHcpcs.MasterTableView.Items[serialNo].FindControl("txtDescription") as TextBox;
        description.Enabled = true;

        var charge = grdHcpcs.MasterTableView.Items[serialNo].FindControl("txtCharge") as RadNumericTextBox;
        charge.Enabled = true;

        var cstmValidatorDate = grdHcpcs.MasterTableView.Items[serialNo].FindControl("cstmValidatorDate") as CustomValidator;
        cstmValidatorDate.Enabled = true;

        var customValidator = grdHcpcs.MasterTableView.Items[serialNo].FindControl("cstmValidatorDescription") as CustomValidator;
        customValidator.Enabled = true;

        var cstmValidatorCharge = grdHcpcs.MasterTableView.Items[serialNo].FindControl("cstmValidatorCharge") as CustomValidator;
        cstmValidatorCharge.Enabled = true;
    }

    private void EnableRowForSpecialCPT()
    {
        foreach (var serialNo in from GridDataItem item in grdHcpcs.Items let cpt = item.FindControl("txtCPTNumber") as TextBox where cpt.Text == "00000" select Convert.ToInt32(item["SerialNo"].Text))
        {
            var description = grdHcpcs.MasterTableView.Items[serialNo - 1].FindControl("txtDescription") as TextBox;
            description.Enabled = true;

            var charge = grdHcpcs.MasterTableView.Items[serialNo - 1].FindControl("txtCharge") as RadNumericTextBox;
            charge.Enabled = true;
        }
    }

    private void EnableDisableDiscriptionandChargeFields(int rowNo, bool isEnable)
    {
        var description = grdHcpcs.MasterTableView.Items[rowNo].FindControl("txtDescription") as TextBox;
        description.Enabled = isEnable;

        var charge = grdHcpcs.MasterTableView.Items[rowNo].FindControl("txtCharge") as RadNumericTextBox;
        charge.Enabled = isEnable;

        var cstmValidatorDate = grdHcpcs.MasterTableView.Items[rowNo].FindControl("cstmValidatorDate") as CustomValidator;
        cstmValidatorDate.Enabled = isEnable;

        var customValidator = grdHcpcs.MasterTableView.Items[rowNo].FindControl("cstmValidatorDescription") as CustomValidator;
        customValidator.Enabled = isEnable;

        var cstmValidatorCharge = grdHcpcs.MasterTableView.Items[rowNo].FindControl("cstmValidatorCharge") as CustomValidator;
        cstmValidatorCharge.Enabled = isEnable;
    }
}

