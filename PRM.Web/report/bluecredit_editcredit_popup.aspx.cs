using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using Telerik.Web.UI;


public partial class bluecredit_editcredit_popup : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ClientSession.AssignBackUpIdTo("ObjectID");

        if (!Page.IsPostBack)
        {
            try
            {
                // Closing the popup in case of any error
                ClientSession.WasRequestFromPopup = true;
                pMessage.InnerText = string.Empty;
                BindBillSchedule();
                BindFundingSource();
                BindBackUpFundingSource();
                BindStates();
                // displaying the record for a selected Bluecredit
                GetBlueCreditInformation();

            }
            catch (Exception)
            {
                throw;
            }
        }

        popupInvoice.VisibleOnPageLoad = false;
        popupPaymentMethods.VisibleOnPageLoad = false;
        popupTruthInLending.VisibleOnPageLoad = false;
        popupBlueCreditApplication.VisibleOnPageLoad = false;
        popupTransactionHistory.VisibleOnPageLoad = false;
    }


    private void BindBillSchedule()
    {
        var billSchedule = SqlHelper.ExecuteDataTableProcedureParams("web_pr_payfreq_list", new Dictionary<string, object>());
        cmbBillSchedule.DataSource = billSchedule;
        cmbBillSchedule.DataBind();
    }

    private void BindFundingSource()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@UserID", ClientSession.UserID } };
        var linkedBankAccounts = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        cmbFundingSource.DataSource = linkedBankAccounts;
        cmbFundingSource.DataBind();
    }

    private void BindBackUpFundingSource()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@FlagBankOnly", 1 }, { "@UserID", ClientSession.UserID } };
        var linkedBankAccounts = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        cmbBackupFundingSource.DataSource = linkedBankAccounts;
        cmbBackupFundingSource.DataBind();
    }

    private void BindStates()
    {
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", new Dictionary<string, object>());

        cmbStateType.DataSource = states;
        cmbStateType.DataBind();
    }

    // For Extend Max Term
    private void CalculateExtentMaxTerm(int maxExtensionUndo, int maxExtension)
    {
        var listOfMaxTerm = new ArrayList();

        for (var i = maxExtensionUndo; i <= maxExtension; i++)
        {
            listOfMaxTerm.Add(new { Text = i, Value = i });
        }

        cmbExtentMaxTerm.DataSource = listOfMaxTerm;
        cmbExtentMaxTerm.DataBind();

        // For showing default to 0
        cmbExtentMaxTerm.SelectedValue = "0";
    }


    private void GetBlueCreditInformation()
    {
        if (ClientSession.ObjectID == null && ClientSession.ObjectType != ObjectType.BlueCreditDetail) return;

        var cmdParams = new Dictionary<string, object>
                            {
                                { "@BlueCreditID", ClientSession.ObjectID}, { "@PracticeID", ClientSession.PracticeID },{ "@UserID", ClientSession.UserID}
                            };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            // Binding Top Section
            lblAccountHolder.Text = row["AccountHolder"].ToString();
            lblAccountholderType.Text = row["AccountholderType"].ToString();
            lblBlueCreditID.Text = row["BlueCreditID"].ToString();
            //lblEmail.Text = row["Email"].ToString();

            // Binding Credit Plan Details Grid

            var blueCredit = new ArrayList { new { 
                   PlanName = row["PlanName"].ToString(), 
                   CreditStatusTypeAbbr = row["CreditStatusTypeAbbr"].ToString(), 
                   OpenDate = row["OpenDate"].ToString(), 
                   LastCycle = row["LastCycleAbbr"].ToString(), 
                   CreditLimit = row["CreditLimit$"].ToString(), 
                   Balance = row["Balance$"].ToString(), 
                   PromoRemainAbbr = row["PromoRemainAbbr"].ToString(), 
                   TermRemainAbbr = row["TermRemainAbbr"].ToString(), 
                   MinPayAmount = row["MinPayAmount$"].ToString(), 
                   NextDueDate = Convert.ToDateTime(row["NextDueDate"]).ToString("MM/dd/yyyy") } };
            grdBlueCredit.DataSource = blueCredit;
            grdBlueCredit.DataBind();

            // Binding Bottom Section
            var balance = decimal.Parse(row["Balance"].ToString());
            var minPayAmount = Convert.ToDecimal(row["MinPayAmount"]);
            var recurringMin = decimal.Parse(row["PtSetRecurringMin"].ToString());
            var selectedValue = Math.Min(recurringMin, balance);
            ViewState["RecurringBalance"] = selectedValue;

            sldRecurringPayment.SmallChange = 5;
            sldRecurringPayment.LargeChange = 25;
            sldRecurringPayment.MinimumValue = minPayAmount;
            sldRecurringPayment.MaximumValue = balance;
            sldRecurringPayment.Value = selectedValue;
            rngRecurringPayment.MinimumValue = minPayAmount.ToString();
            rngRecurringPayment.MaximumValue = balance.ToString();
            txtRecurringPayment.Text = selectedValue.ToString();
            lblRecurringPayment.Text = "This plan will be paid off in " + CalcRemainingPayments(reader) + " payments.";
            rngRecurringPayment.ToolTip = "Invalid Payment";
            rngRecurringPayment.ErrorMessage = "Invalid Payment";

            var creditLimit = row["CreditLimit"].ToString();
            txtCreditLimit.Text = creditLimit;
            ViewState["CreditLimit"] = creditLimit;

            sldBalance.Value = Convert.ToDecimal(creditLimit);
            sldBalance.MinimumValue = balance;
            sldBalance.MaximumValue = Convert.ToDecimal(row["CreditLimitMax"].ToString());
            sldBalance.SmallChange = 100m;
            cmbFundingSource.SelectedValue = row["PaymentCardID"].ToString();
            cmbBillSchedule.SelectedValue = row["PaymentFreqTypeID"].ToString();
            cmbBackupFundingSource.SelectedValue = row["PaymentCardIDSec"].ToString();
            if (!string.IsNullOrEmpty(row["NextPayDate"].ToString()))
                dtNextPayment.SelectedDate = Convert.ToDateTime(row["NextPayDate"].ToString());
            txtEmailAddress.Text = row["Email"].ToString();
            chkEmailBills.Checked = Convert.ToBoolean(row["FlagEmailBills"]);
            txtBillingAddress1.Text = row["Addr1"].ToString();
            lblBorrower.Text = row["AccountHolder"].ToString();
            txtAddress2.Text = row["Addr2"].ToString();
            txtCity.Text = row["City"].ToString();
            cmbStateType.SelectedValue = row["StateTypeID"].ToString();
            txtZip.Text = row["Zip"].ToString();
            txtZip4.Text = row["Zip4"].ToString();
            txtNotes.Text = row["Notes"].ToString();
            txtPhone.Text = row["PhonePri"].ToString();
            txtAltPhone.Text = row["PhoneSec"].ToString();

            // Validating and Binding the Extent Max Terms
            if (ClientSession.RoleTypeID < (int)RoleType.Billing)
            {
                cmbExtentMaxTerm.DataSource = new List<string>();
                cmbExtentMaxTerm.DataBind();
                cmbExtentMaxTerm.Enabled = false;
            }
            else
            {
                CalculateExtentMaxTerm(Convert.ToInt32(row["MaxExtensionUndo"]), Convert.ToInt32(row["MaxExtension"]));
            }


            // Assigning the values for javascript usage
            hdnValues.Value = string.Format("{0},{1},{2},{3},{4},{5}", balance, Convert.ToInt32(row["LastCycle"]), Convert.ToDecimal(row["RatePromo"]), Convert.ToDecimal(row["TermPromo"]), Convert.ToDecimal(row["RateStd"]), Convert.ToDecimal(row["TermMax"]));

            // Applying Validation
            rngCrediLimit.MinimumValue = Convert.ToDecimal(row["Balance"]).ToString("0.00");
            rngCrediLimit.MaximumValue = Convert.ToDecimal(row["CreditLimitMax"]).ToString("0.00");
            rngCrediLimit.ToolTip = "Credit Limit must be between" + String.Format("{0:c}", balance) + " - " + String.Format("{0:c}", Convert.ToDecimal(row["CreditLimitMax"].ToString()));
            rngCrediLimit.ErrorMessage = "Credit Limit must be between " + String.Format("{0:c}", balance) + " - " + String.Format("{0:c}", Convert.ToDecimal(row["CreditLimitMax"].ToString()));
            dtNextPayment.MinDate = DateTime.Now;
            dtNextPayment.MaxDate = Convert.ToDateTime(row["NextDueDate"]);

            if (balance == 0 && BluecreditValidator.HasAccessToSeeTerminatedAccounts())
            {
                EnableDisableTerminateButton(true);
            }
            else if (balance > 0 && ClientSession.RoleTypeID >= (int)RoleType.Billing)
            {
                pMessage.InnerText = "Only credit accounts with a zero balance can be terminated. Please remove or pay the statements in full before closing the patient’s credit account.";
            }

            if (ClientSession.RoleTypeID < (int)RoleType.Billing)
                pMessage.InnerText = "Only BlueCredit Manager roles are able to remove statements and terminate credit plans.";

            if (chkEmailBills.Checked)
                hdnIsFlagEmails.Value = "True";


            if (cmbFundingSource.SelectedIndex == -1 && cmbBackupFundingSource.SelectedIndex == -1)
            {
                DisableAutopayButton();
            }

            if (balance <= 0)
            {
                btnUpdateTruthInLending.Enabled = false;
                btnUpdateTruthInLending.ImageUrl = "../Content/Images/btn_recalculate_small_fade.gif";


                // disabling extern dropdown
                cmbExtentMaxTerm.SelectedValue = "0";
                cmbExtentMaxTerm.Enabled = false;

            }

            // Allowing user to Re-sign  according to the values
            if (Convert.ToBoolean(row["FlagLASigResign"]))
                btnLendingAgreement.Visible = true;

            if (Convert.ToBoolean(row["FlagPNSigResign"]))
                btnPromissoryNoteResign.Visible = true;

            if (Convert.ToBoolean(row["FlagTILSigResign"]))
                btnTruthInLendingResign.Visible = true;

            var isActive = row["FlagActive"].ParseBool();
            if (!isActive)
            {
                btnAddNew.Enabled = false;
                btnAddNew.ImageUrl = "../Content/Images/btn_addnew_small_fade.gif";

                EnableDisableTerminateButton(false);
                DisableSubmitButton();
            }

            var flagLenderFunded = row["FlagLenderFunded"].ParseBool();
            if (flagLenderFunded)
            {
                divCardMessage.Visible = true;
            }

            //DisableFieldsIfFlagLocked
            var isFlagLocked = row["FlagLocked"].ParseBool();
            if (!isFlagLocked || ClientSession.FlagSysAdmin) return; //added by mvs on 5/7/16

            EnableDisableTerminateButton(false);
            DisableAutopayButton();
            DisableSubmitButton();

            ViewState["FlagLocked"] = true;
        }
    }

    private static decimal CalcRemainingPayments(DataTable reader)
    {
        foreach (DataRow row in reader.Rows)
        { 
            var financedAmount = Convert.ToDecimal(row["Balance"]);
            var cycle = Convert.ToInt32(row["LastCycle"]);
            var ratePromo = Convert.ToDecimal(row["RatePromo"]);
            var termPromo = Convert.ToDecimal(row["TermPromo"]);
            var rateStd = Convert.ToDecimal(row["RateStd"]);
            var termMax = Convert.ToDecimal(row["TermMax"]);
            var minPayment = Math.Min(Convert.ToDecimal(row["PtSetRecurringMin"]), Convert.ToDecimal(row["Balance"]));

            decimal totalPayments = 0; // This not being used
            var diffDays = 31;
            while (cycle <= termPromo && financedAmount > 0)
            {
                diffDays = Convert.ToInt32((DateTime.Now.AddMonths(cycle) - DateTime.Now.AddMonths(cycle - 1)).TotalDays);
                financedAmount = Math.Ceiling(financedAmount * Convert.ToDecimal(Math.Pow(1 + Convert.ToDouble(ratePromo) / 36500, diffDays)) * 100) / 100; //Add interest for period
                if (financedAmount < minPayment + 1) { minPayment = financedAmount; } //the last payment may be different by a few pennies, so it checks to see if it's within a dollar
                financedAmount -= minPayment; //Subtract from financedAmount
                totalPayments += minPayment; //Keep adding Total Actual Payments
                cycle++;
            }
            while (cycle <= termMax && financedAmount > 0)
            {
                diffDays = Convert.ToInt32((DateTime.Now.AddMonths(cycle) - DateTime.Now.AddMonths(cycle - 1)).TotalDays);
                financedAmount = Math.Ceiling(financedAmount * Convert.ToDecimal(Math.Pow(1 + Convert.ToDouble(rateStd) / 36500, diffDays)) * 100) / 100; //Add interest for period
                if (financedAmount < minPayment + 1) { minPayment = financedAmount; } //the last payment may be different by a few pennies, so it checks to see if it's within a dollar
                financedAmount -= minPayment; //Subtract from financedAmount
                totalPayments += minPayment; //Keep adding Total Actual Payments
                cycle++;
            }
            return cycle;
        }
        return -1; //Should never need this, but c# needed it incase there were no rows in the table
    }


    private DataTable GetActiveStatements()
    {
        var cmdParams = new Dictionary<string, object> { { "@BlueCreditID", ClientSession.ObjectID }, { "@UserID", ClientSession.UserID } };
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
    }

    protected void grdActiveStatements_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdActiveStatements.DataSource = GetActiveStatements();
    }

    protected void grdActiveStatements_ItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "ViewActiveStatement":
                // for displaying Statement in the popup
                ClientSession.BackUpID = Int32.Parse(ClientSession.ObjectID.ToString());
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectType = ObjectType.Statement;
                hdnShowInvoice.Value = "True";
                break;
        }
    }



    protected void grdActiveStatements_OnPreRender(object sender, EventArgs e)
    {
        // For auto deleted without confirmation, if top grid has single row.

        var count = grdActiveStatements.MasterTableView.Items.Count;
        if (count == 1)
        {
            var statementID = grdActiveStatements.MasterTableView.Items[0].GetDataKeyValue("StatementID");
            hdnStatementID.Value = statementID.ToString();
            hdnIsGridHasOneRow.Value = "1";
        }


    }

    // Removing the delete button from grid if roletype is less than 3, 3 is Biling. 
    // Check enum for all roletypes
    protected void grdActiveStatements_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;

            var hasAccess = BluecreditValidator.HasAccessToSeeTerminatedAccounts();
            if (!hasAccess)
            {
                MakeRemoveButtonHide(item);
            }

            if (IsFlagBlocked())
            {
                MakeRemoveButtonHide(item);
            }
        }
    }

    private void MakeRemoveButtonHide(Control item)
    {
        var imageButton = item.FindControl("btnSelectedRemoveStatement") as ImageButton;
        imageButton.ImageUrl = string.Empty;
        imageButton.Enabled = false;
        imageButton.AlternateText = "-";
    }


    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            return;
        }

        var havePermission = BluecreditValidator.HasModifyPermission(windowManager, IsFlagBlocked());
        if (!havePermission)
            return;

        var cmdParams = new Dictionary<string, object>
                            {
                                 { "@PatientID", ClientSession.SelectedPatientID },
                                 { "@BlueCreditID", ClientSession.ObjectID },
                                 { "@PhonePri", txtPhone.Text },
                                 { "@PhoneSec", txtAltPhone.Text },
                                 { "@PaymentCardID", cmbFundingSource.SelectedValue },
                                 { "@PaymentFreqTypeID", cmbBillSchedule.SelectedValue },
                                 { "@PaymentCardIDSec", cmbBackupFundingSource.SelectedValue},
                                 { "@PayDay", Convert.ToDateTime(dtNextPayment.SelectedDate).Day},
                                 { "@NextPayDate", dtNextPayment.SelectedDate },
                                 { "@Email",  txtEmailAddress.Text},
                                 { "@FlagEmailBills", chkEmailBills.Checked },
                                 { "@Addr1", txtBillingAddress1.Text},
                                 { "@Addr2",  txtAddress2.Text },
                                 { "@City",  txtCity.Text  },
                                 { "@StateTypeID", cmbStateType.SelectedValue  },
                                 { "@Zip", txtZip.Text  },
                                 { "@Zip4", txtZip4.Text  },
                                 { "@Notes", txtNotes.Text },
                                 { "@PtSetRecurringMin", txtRecurringPayment.Text },
                                 { "@CreditLimit", txtCreditLimit.Text },
                                 { "@CyclesExtend", cmbExtentMaxTerm.SelectedValue},
                                 { "@UserID", ClientSession.UserID}
                             };

        if (hdnIsTerminate.Value == "true")
            cmdParams.Add("FlagTerminate", 1);


        SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecredit_add", cmdParams);
        windowManager.RadAlert(hdnIsTerminate.Value == "true" ? "Record successfully terminated." : "Record successfully updated.", 350, 150, "", "closePopup", "../Content/Images/success.png");
        hdnIsTerminate.Value = null;
    }

    protected void btnShowLendingAgreement_OnClick(object sender, EventArgs e)
    {

    }

    protected void btnRemoveStatement_Click(object sender, EventArgs e)
    {
        if (IsFlagBlocked()) return;

        var havePermission = BluecreditValidator.HasCreatePermission(windowManager);
        if (!havePermission)
            return;

        var cmdParams = new Dictionary<string, object>
                            {
                                {"@StatementID", hdnStatementID.Value},
                                {"@FlagActive", 0},
                                {"@UserID", ClientSession.UserID},
                            };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecredit_assign", cmdParams);
        grdActiveStatements.Rebind();
        RebindValues();
        ValidateTerminateButton();
        hdnIsGridHasOneRow.Value = "0";

    }

    private void RebindValues()
    {
        // Recalculating the values after statements are completly deleted
        var cmdParams = new Dictionary<string, object>
                            {
                                { "@BlueCreditID", ClientSession.ObjectID}, { "@PracticeID", ClientSession.PracticeID },{ "@UserID", ClientSession.UserID}
                            };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            var blueCredit = new ArrayList { new { 
                   PlanName = row["PlanName"].ToString(), 
                   CreditStatusTypeAbbr = row["CreditStatusTypeAbbr"].ToString(), 
                   OpenDate = row["OpenDate"].ToString(), 
                   LastCycle = row["LastCycleAbbr"].ToString(), 
                   CreditLimit = row["CreditLimit$"].ToString(), 
                   Balance = row["Balance$"].ToString(), 
                   PromoRemainAbbr = row["PromoRemainAbbr"].ToString(), 
                   TermRemainAbbr = row["TermRemainAbbr"].ToString(), 
                   MinPayAmount = row["MinPayAmount$"].ToString(), 
                   NextDueDate = Convert.ToDateTime(row["NextDueDate"]).ToString("MM/dd/yyyy") } };
            grdBlueCredit.DataSource = blueCredit;
            grdBlueCredit.DataBind();


            lblRecurringPayment.Text = "This plan will be paid off in " + CalcRemainingPayments(reader) + " payments.";

            sldRecurringPayment.MinimumValue = Convert.ToDecimal(row["MinPayAmount"]);
            sldRecurringPayment.MaximumValue = Convert.ToDecimal(row["Balance"]);
            sldRecurringPayment.Value = Math.Min(Convert.ToDecimal(row["PtSetRecurringMin"]), Convert.ToDecimal(row["Balance"]));
            rngRecurringPayment.MinimumValue = Convert.ToDecimal(row["MinPayAmount"]).ToString("0.00");
            rngRecurringPayment.MaximumValue = Convert.ToDecimal(row["Balance"]).ToString("0.00");
            txtRecurringPayment.Text = Math.Min(Convert.ToDecimal(row["PtSetRecurringMin"]), Convert.ToDecimal(row["Balance"])).ToString();
        }
    }

    protected void EnableAutoPayButton(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        btnDisableAutoPay.Enabled = true;
        btnDisableAutoPay.ImageUrl = "../Content/Images/btn_disableautopay.gif";
    }

    protected void cmbExtentMaxTerm_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        var cmdParam = new Dictionary<string, object> { { "@BlueCreditID", ClientSession.ObjectID }, { "@CyclesExtend", cmbExtentMaxTerm.SelectedValue } };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_cycle_extend", cmdParam);
        foreach (DataRow row in reader.Rows)
        {
            var minPayAmount = Convert.ToDecimal(row["MinPayAmount"]);
            sldRecurringPayment.MinimumValue = minPayAmount;
            rngRecurringPayment.MinimumValue = minPayAmount.ToString();
        }
    }

    private void ValidateTerminateButton()
    {
        var rows = grdActiveStatements.Items.Count;
        if (rows == 0 && ClientSession.RoleTypeID >= (int)RoleType.Billing)
        {
            btnTerminate.Enabled = true;
            btnTerminate.ImageUrl = "../Content/Images/btn_terminate.gif";
            pMessage.InnerText = string.Empty;

        }

        if (rows == 0)
        {
            // disabling extern dropdown
            cmbExtentMaxTerm.SelectedValue = "0";
            cmbExtentMaxTerm.Enabled = false;
        }

    }


    protected void btnLendingAgreement_OnClick(object sender, EventArgs e)
    {
        var havePermission = BluecreditValidator.HasCreatePermission(windowManager);
        if (!havePermission)
            return;

        hdnIsShowLendingAgreement.Value = "1";
    }

    protected void btnUpdatePromissoryNote_OnClick(object sender, EventArgs e)
    {
        var havePermission = BluecreditValidator.HasCreatePermission(windowManager);
        if (!havePermission)
            return;

        //ClientSession.ObjectType = ObjectType.BlueCreditEdit;
        hdnIsUpdatePromissoryNote.Value = "1";
    }

    protected void btnUpdateTruthInLending_OnClick(object sender, EventArgs e)
    {
        var havePermission = BluecreditValidator.HasCreatePermission(windowManager);
        if (!havePermission)
            return;

        //ClientSession.ObjectType = ObjectType.BlueCreditEdit;
        hdnIsUpdateTruthInLending.Value = "1";
    }

    protected void btnUpdateValues_OnClick(object sender, EventArgs e)
    {
        // For displaying the PDF in Pdfviewer popup

        ClientSession.FilePath = hdnFileName.Value;

        // FieName, PageTitle and IsRequest from Bluecredit
        ClientSession.ObjectValue = new Dictionary<string, string> { { "FileName", hdnFileName.Value }, { "PageTitle", hdnFileName.Value == "til" ? "Truth In Lending" : "Lending Agreement" }, { "IsRequestFromBlueCredit", "True" } };
        hdnIsShowPdfViewer.Value = "1";
    }

    // For disable Auto Pay
    protected void btnDisableAutoPay_OnClick(object sender, EventArgs e)
    {
        var havePermission = BluecreditValidator.HasModifyPermission(windowManager, IsFlagBlocked());
        if (!havePermission)
            return;

        cmbFundingSource.ClearSelection();
        cmbBackupFundingSource.ClearSelection();
        btnDisableAutoPay.Enabled = false;
        btnDisableAutoPay.ImageUrl = "../Content/Images/btn_disableautopay_fade.gif";
    }

    protected void btnRebindFundingSource_OnClick(object sender, EventArgs e)
    {
        BindFundingSource();
    }



    #region common functions

    private void EnableDisableTerminateButton(bool isEnable)
    {
        btnTerminate.Enabled = isEnable;
        btnTerminate.ImageUrl = isEnable ? "../Content/Images/btn_terminate.gif" : "../Content/Images/btn_terminate_fade.gif";
    }

    private void DisableAutopayButton()
    {
        btnDisableAutoPay.Enabled = false;
        btnDisableAutoPay.ImageUrl = "../Content/Images/btn_disableautopay_fade.gif";
    }

    private void DisableSubmitButton()
    {
        btnSubmit.Enabled = false;
        btnSubmit.ImageUrl = "../Content/Images/btn_update_fade.gif";
    }

    private bool IsFlagBlocked()
    {
        return ViewState["FlagLocked"].ParseBool();
    }

    #endregion

}
