using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class carriers : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // Binding the dropdown
            BindExistingCarriers();

            // Checking if its update case of add case by checking the ObjectID and also adjusting the values for update
            if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.CarriesSearch)
            {
                cmbExistingCarriers.SelectedValue = ClientSession.ObjectID.ToString();
                LoadBasicInitialInformation();
                pnlCarrierInfo.Visible = true;
                pnlExistingCarrier.Enabled = false;
                btnSubmit.ImageUrl = "../Content/Images/btn_update.gif";
                ClientSession.ObjectID = null;
                ClientSession.ObjectType = null;
                DisableExistingPanel();
            }

        }
        popupCreditSearch.VisibleOnPageLoad = false;
    }


    private void BindExistingCarriers()
    {
        var cmdParams = new Dictionary<string, object>() { { "PracticeID", ClientSession.PracticeID }, { "@FlagActive", 0 } };
        var carriers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_carrier_list", cmdParams);
        cmbExistingCarriers.DataSource = carriers;
        cmbExistingCarriers.DataBind();
    }

    protected void cmbExistingCarriers_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        // If Existing Carriers is selected then its case of Update.
        LoadBasicInitialInformation();
        pnlCarrierInfo.Visible = true;
        pnlExistingCarrier.Enabled = false;
        btnSubmit.ImageUrl = "../Content/Images/btn_update.gif";
        DisableExistingPanel();
    }

    private void BindPolicyTypes()
    {
        var policyTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_carriertype_list", new Dictionary<string, object>());
        cmbPolicyTypes.DataSource = policyTypes;
        cmbPolicyTypes.DataBind();
    }

    private void BindStates()
    {
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", new Dictionary<string, object>());
        cmbPrimaryStates.DataSource = states;
        cmbPrimaryStates.DataBind();

        cmbStates.DataSource = states;
        cmbStates.DataBind();
    }

    private void BindCarrierStatus()
    {
        cmbCarrierStatus.Items.Add(new RadComboBoxItem { Text = StatusType.Active.ToString(), Value = ((int)StatusType.Active).ToString() });
        cmbCarrierStatus.Items.Add(new RadComboBoxItem { Text = StatusType.InActive.ToString(), Value = ((int)StatusType.InActive).ToString() });
    }

    private void ShowCarrierInformation()
    {
        var isGlobalCarrier = false;
        var cmdParams = new Dictionary<string, object>()
        {
            { "@CarrierID", cmbExistingCarriers.SelectedValue },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_carrier_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            txtCarrierName.Text = row["CarrierName"].ToString();
            cmbPolicyTypes.SelectedValue = row["CarrierTypeID"].ToString();
            cmbPrimaryStates.SelectedValue = row["CarrierStateTypeID"].ToString();
            txtDisplayName.Text = row["CarrierAbbr"].ToString();
            txtPayerID.Text = row["PayerIDCode"].ToString();
            txtClaimOfficeID.Text = row["ClaimOfficeID"].ToString();
            txtNaicsCode.Text = row["NAICSID"].ToString();
            txtTaxPayerID.Text = row["FederalTIN"].ToString();
            txtNotes.Text = row["Notes"].ToString();
            cmbCarrierStatus.SelectedValue = row["FlagActive"].ToString() == "True" ? "1" : "0";
            txtAuthPhone.Text = row["PhoneAuth"].ToString();
            txtEligPhone.Text = row["PhoneElig"].ToString();
            txtFaxNumber.Text = row["Fax"].ToString();
            txtStreet1.Text = row["Addr1"].ToString();
            txtStreet2.Text = row["Addr2"].ToString();
            txtCity.Text = row["City"].ToString();
            cmbStates.SelectedValue = row["StateTypeID"].ToString();
            txtPrimaryZipCode1.Text = row["Zip"].ToString();
            txtPrimaryZipCode2.Text = row["Zip4"].ToString();
            isGlobalCarrier = Convert.ToInt32(row["PracticeID"].ToString()) == 0;
        }
        divUpdateCancelbuttons.Visible = !isGlobalCarrier;
        divIndividualPractice.Visible = isGlobalCarrier;
    }

    private void LoadBasicInitialInformation()
    {
        BindPolicyTypes();
        BindStates();
        BindCarrierStatus();
        if (!string.IsNullOrEmpty(cmbExistingCarriers.SelectedValue)) ShowCarrierInformation();
    }

    protected void btnNew_Click(object sender, EventArgs e)
    {
        // This is case of Add New Carrier and adjusting accordingly
        LoadBasicInitialInformation();
        pnlCarrierInfo.Visible = true;
        pnlExistingCarrier.Visible = false;
        hTitle.Visible = true;
        DisableExistingPanel();
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            var cmdParams = new Dictionary<string, object>()
                                {
                                    //{ "@CarrierID", cmbExistingCarriers.SelectedValue},
                                    { "@CarrierID", cmbExistingCarriers.SelectedValue==string.Empty?null:cmbExistingCarriers.SelectedValue},
                                    { "@CarrierName", txtCarrierName.Text.Trim() },
                                    { "@CarrierTypeID", cmbPolicyTypes.SelectedValue },
                                    { "@CarrierStateTypeID", cmbPrimaryStates.SelectedValue },
                                    { "@CarrierAbbr", txtDisplayName.Text.Trim() },
                                    { "@PayerIDCode", txtPayerID.Text.Trim() },
                                    { "@ClaimOfficeID", txtClaimOfficeID.Text.Trim() },
                                    { "@NAICSID", txtNaicsCode.Text.Trim() },
                                    { "@FederalTIN", txtTaxPayerID.Text.Trim() },
                                    { "@Notes", txtNotes.Text.Trim() },
                                    { "@FlagActive", cmbCarrierStatus.SelectedValue },
                                    { "@PhoneAuth", txtAuthPhone.Text.Trim() },
                                    { "@PhoneElig", txtEligPhone.Text.Trim() },
                                    { "@Fax", txtFaxNumber.Text.Trim() },
                                    { "@Addr1", txtStreet1.Text.Trim() },
                                    { "@Addr2", txtStreet2.Text.Trim() },
                                    { "@City", txtCity.Text.Trim() },
                                    { "@StateTypeID", cmbStates.SelectedValue },
                                    { "@Zip", txtPrimaryZipCode1.Text.Trim() },
                                    { "@Zip4", txtPrimaryZipCode2.Text.Trim() },
                                    { "@UserID", ClientSession.UserID },
                                    { "@PracticeID", ClientSession.PracticeID}
                                    };
            if (ClientSession.PracticeID != 0)
            {
                var message = string.IsNullOrEmpty(cmbExistingCarriers.SelectedValue) ? "Record successfully created." : "Record successfully updated.";
                SqlHelper.ExecuteScalarProcedureParams("web_pr_carrier_add", cmdParams);
                RadWindow.RadAlert(message, 350, 150, "", "refreshPage", "../Content/Images/success.png");
            }

        }
        catch (Exception)
        {

            throw;
        }
    }

    protected void btnSearch_OnClick(object sender, EventArgs e)
    {
        popupCreditSearch.VisibleOnPageLoad = true;
    }

    private void DisableExistingPanel()
    {
        btnNew.ImageUrl = "../Content/Images/btn_new_fade.gif";
        divTopButtons.Visible = false;
    }

}
