using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class config : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            ValidateUserAndApplyValidations();
            LoadBasicInitialInformation();
        }

        litMessage.Text = string.Empty;
    }


    private void ValidateUserAndApplyValidations()
    {
        if (ClientSession.RoleTypeID == (int) RoleType.SystemAdministrator) return;

        txtLoginID.Enabled = false;
        txtPracticeName.Enabled = false;
        txtNameAbbreviation.Enabled = false;
        txtPracticeEIN.Enabled = false;
        txtCheckPayableTo.Enabled = false;
        txtAddress1.Enabled = false;
        txtAddress2.Enabled = false;
        txtCity.Enabled = false;
        cmbStates.Enabled = false;
        txtZipCode1.Enabled = false;
        txtZipCode2.Enabled = false;
        txtMainPhone.Enabled = false;
        txtBillingPhone.Enabled = false;
        txtFaxNumber.Enabled = false;
        cmbOfferCreditCheck.Enabled = false;
        cmbOfferLenderFunded.Enabled = false;
    }
    
    private void LoadBasicInitialInformation()
    {
        BindStates();
        BindAcceptPaymentPlansandBlueCredit();
        ShowConfiguration();
    }

    private void BindAcceptPaymentPlansandBlueCredit()
    {
        // Bind Offer Blue Credit
        cmbOfferCMSSurvey.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbOfferCMSSurvey.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });

        // Bind Bind Accept Payment Plans
        cmbAcceptPaymentPlans.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbAcceptPaymentPlans.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });

        // Bind Offer Blue Credit
        cmbOfferBlueCredit.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbOfferBlueCredit.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });

        // Bind Payment Plan Web Access
        cmbPaymentPlanWebAccess.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbPaymentPlanWebAccess.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });

        // Bind BlueCredit Web Access
        cmbBlueCreditWebAccess.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbBlueCreditWebAccess.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });

        // Bind BlueCredit Credit Checks
        cmbOfferCreditCheck.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbOfferCreditCheck.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });

        // Bind BlueCredit Lender Funded
        cmbOfferLenderFunded.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbOfferLenderFunded.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });
    }

    private void BindStates()
    {
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", new Dictionary<string, object>());
        cmbStates.DataSource = states;
        cmbStates.DataBind();
    }


    private void ShowConfiguration()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@PracticeID", ClientSession.PracticeID },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_config_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            txtLoginID.Text = row["LoginID"].ToString();
            txtPracticeName.Text = row["PracticeName"].ToString();
            txtNameAbbreviation.Text = row["PracticeAbbr"].ToString();
            txtPracticeEIN.Text = row["PracticeEIN"].ToString();
            txtCheckPayableTo.Text = row["PaymentCheckName"].ToString();
            txtAddress1.Text = row["Addr1"].ToString();
            txtAddress2.Text = row["Addr2"].ToString();
            txtCity.Text = row["City"].ToString();
            cmbStates.SelectedValue = row["StateTypeID"].ToString();
            txtZipCode1.Text = row["Zip"].ToString();
            txtZipCode2.Text = row["Zip4"].ToString();
            txtMainPhone.Text = row["PhoneMain"].ToString();
            txtBillingPhone.Text = row["PhoneBilling"].ToString();
            txtFaxNumber.Text = row["Fax"].ToString();
            txtNSFCheckFee.Text = row["NSFCheckFee"].ToString();
            txtLatePayStatement.Text = row["LatePayStatement"].ToString();
            txtLatePayBlueCredit.Text = row["LatePayBlueCredit"].ToString();
            txtCMSMultiplier.Text = row["CMSMultiplier"].ToString();
            txtUCRMultiplier.Text = row["UCRMultiplier"].ToString();
            cmbOfferCMSSurvey.SelectedValue = row["FlagCMSSurveys"].ToString() == "True" ? "1" : "0";
            cmbAcceptPaymentPlans.SelectedValue = row["FlagPayPlan"].ToString() == "True" ? "1" : "0";
            cmbPaymentPlanWebAccess.SelectedValue = row["FlagPatientWebPP"].ToString() == "True" ? "1" : "0";
            txtMinimumToQualify.Text = row["PayPlanQualMin"].ToString();
            txtMaximumToQualify.Text = row["PayPlanQualMax"].ToString();
            txtMinimumDPDollar.Text = row["PayPlanMinDPDollar"].ToString();
            txtMinimumDPRate.Text = row["PayPlanMinDPRate"].ToString();
            txtMinimumPPPFSRecord.Text = row["PayPlanMinPFS"].ToString();
            txtPPFee.Text = row["PayPlanFee"].ToString();
            txtMinimumPayment.Text = row["PayPlanMinAmt"].ToString();
            txtMaximumPlanPeriods.Text = row["PayPlanMaxTerm"].ToString();
            cmbOfferBlueCredit.SelectedValue = row["FlagBlueCredit"].ToString() == "True" ? "1" : "0";
            cmbBlueCreditWebAccess.SelectedValue = row["FlagPatientWebBC"].ToString() == "True" ? "1" : "0";
            cmbOfferCreditCheck.SelectedValue = row["FlagTUPFSLive"].ToString() == "True" ? "1" : "0";
            cmbOfferLenderFunded.SelectedValue = row["FlagBCLenderLive"].ToString() == "True" ? "1" : "0";
            txtCreditMinimum.Text = row["BlueCreditQualMin"].ToString();
            txtCreditMaximum.Text = row["BlueCreditQualMax"].ToString();
            txtMinimumDownPayment.Text = row["BlueCreditMinDPPercent"].ToString();
            txtMinimumPFSRecord.Text = row["BlueCreditMinPFS"].ToString();
            chkActiveSearch.Checked = (bool)row["FlagPtSearchActiveDefault"];
            chkLocationSearch.Checked = (bool)row["FlagPtSearchLocationDefault"];
            chkProviderSearch.Checked = (bool)row["FlagPtSearchProviderDefault"];
            txtNotes.Text = row["Notes"].ToString();
        }
        ValidateAcceptPaymentSubOption();
        ValidateOfferBlueCredit();
    }

    protected void cmbAcceptPaymentPlans_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        // validating the AcceptPaymentSubOption
        ValidateAcceptPaymentSubOption();
    }

    protected void cmbOfferBlueCredit_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        // validating the offer bluecredit
        ValidateOfferBlueCredit();
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            var cmdParams = new Dictionary<string, object>()
                                {
                                    { "@LoginID", txtLoginID.Text.Trim() }, 
                                    { "@PracticeName", txtPracticeName.Text.Trim() }, 
                                    { "@PracticeAbbr", txtNameAbbreviation.Text.Trim() }, 
                                    { "@PracticeEIN", txtPracticeEIN.Text.Trim() }, 
                                    { "@PaymentCheckName", txtCheckPayableTo.Text.Trim() }, 
                                    { "@Addr1", txtAddress1.Text.Trim() },
                                    { "@Addr2", txtAddress2.Text.Trim() },
                                    { "@City", txtCity.Text.Trim() },
                                    { "@StateTypeID", cmbStates.SelectedValue },
                                    { "@Zip", txtZipCode1.Text.Trim() },
                                    { "@Zip4", txtZipCode2.Text.Trim() },
                                    { "@PhoneMain", txtMainPhone.Text },
                                    { "@PhoneBilling", txtBillingPhone.Text.Trim() },
                                    { "@Fax", txtFaxNumber.Text.Trim() },
                                    { "@NSFCheckFee", txtNSFCheckFee.Text },
                                    { "@LatePayStatement", txtLatePayStatement.Text },
                                    { "@LatePayBlueCredit", txtLatePayBlueCredit.Text },
                                    { "@CMSMultiplier", txtCMSMultiplier.Text },
                                    { "@UCRMultiplier", txtUCRMultiplier.Text },
                                    { "@FlagCMSSurveys", cmbOfferCMSSurvey.SelectedValue == "1" ? "True" : "False" },
                                    { "@FlagPayPlan", cmbAcceptPaymentPlans.SelectedValue == "1" ? "True" : "False" },
                                    { "@FlagPatientWebPP", cmbPaymentPlanWebAccess.SelectedValue == "1" ? "True" : "False" },
                                    { "@PayPlanQualMin",  txtMinimumToQualify.Text },
                                    { "@PayPlanQualMax",  txtMaximumToQualify.Text },
                                    { "@PayPlanMinAmt", txtMinimumPayment.Text },
                                    { "@PayPlanMinDPDollar", txtMinimumDPDollar.Text },
                                    { "@PayPlanMinDPRate", txtMinimumDPRate.Text },
                                    { "@PayPlanMinPFS", txtMinimumPPPFSRecord.Text },
                                    { "@PayPlanFee", txtPPFee.Text },
                                    { "@PayPlanMaxTerm", txtMaximumPlanPeriods.Text },
                                    { "@FlagBlueCredit", cmbOfferBlueCredit.SelectedValue == "1" ? "True" : "False" },
                                    { "@FlagPatientWebBC", cmbBlueCreditWebAccess.SelectedValue == "1" ? "True" : "False" },
                                    { "@FlagTUPFSLive", cmbOfferCreditCheck.SelectedValue == "1" ? "True" : "False" },
                                    { "@FlagBCLenderLive", cmbOfferLenderFunded.SelectedValue == "1" ? "True" : "False" },
                                    { "@BlueCreditQualMin",  txtCreditMinimum.Text },
                                    { "@BlueCreditQualMax", txtCreditMaximum.Text },
                                    { "@BlueCreditMinDP", txtMinimumDownPayment.Text },
                                    { "@BlueCreditMinPFS", txtMinimumPFSRecord.Text },
                                    { "@Notes", txtNotes.Text.Trim() },
                                    { "@FlagPtSearchActiveDefault", chkActiveSearch.Checked},
                                    { "@FlagPtSearchLocationDefault", chkLocationSearch.Checked},
                                    { "@FlagPtSearchProviderDefault", chkProviderSearch.Checked},
                                    { "@UserID", ClientSession.UserID },
                                    { "@PracticeID", ClientSession.PracticeID}
                                };

            SqlHelper.ExecuteScalarProcedureParams("web_pr_config_add", cmdParams);
            (new UserLogin()).ReloadSessionValues(ClientSession.UserID);

            RadWindow.RadAlert("Record successfully updated.", 350, 150, "", "refreshPage", "../Content/Images/success.png");
        }
        catch (Exception)
        {

            throw;
        }
    }

    private void ValidateAcceptPaymentSubOption()
    {
        if (cmbAcceptPaymentPlans.SelectedValue == Convert.ToString((int)YesNo.Yes))
        {
            rqdPPFee.Enabled = true;
            rqdMinimumToQualify.Enabled = true;
            rqdMaximumToQualify.Enabled = true;
            rqdMinimumDPDollar.Enabled = true;
            rqdMinimumDPRate.Enabled = true;
            rqdMinimumPayment.Enabled = true;
            rqdMaximumPlanPeriods.Enabled = true;
            rqdMinimumPPPFSRecord.Enabled = true;
        }
        else
        {
            rqdPPFee.Enabled = false;
            rqdMinimumToQualify.Enabled = false;
            rqdMaximumToQualify.Enabled = false;
            rqdMinimumDPDollar.Enabled = false;
            rqdMinimumDPRate.Enabled = false;
            rqdMinimumPayment.Enabled = false;
            rqdMaximumPlanPeriods.Enabled = false;
            rqdMinimumPPPFSRecord.Enabled = false;
        }
    }

    private void ValidateOfferBlueCredit()
    {
        if (cmbOfferBlueCredit.SelectedValue == Convert.ToString((int)YesNo.Yes))
        {
            rqdLenderFunded.Enabled = true;
            rqdCreditMinimum.Enabled = true;
            rqdCreditMaximum.Enabled = true;
            rqdMinimumDownPayment.Enabled = true;
            rqdMinimumPFSRecord.Enabled = true;
        }
        else
        {
            rqdLenderFunded.Enabled = false;
            rqdCreditMinimum.Enabled = false;
            rqdCreditMaximum.Enabled = false;
            rqdMinimumDownPayment.Enabled = false;
            rqdMinimumPFSRecord.Enabled = false;
        }
    }
}
