using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;


public partial class bluecredit_editcredit_popup : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // Binding dropdowns
                BindBillSchedule();
                BindFundingSource();
                BindBackUpFundingSource();
                BindStates();

                // Getting bluecredit Information
                GetBlueCreditInformation();
            }
            catch (Exception)
            {

                throw;
            }
        }
        popupAddPaymentCard.VisibleOnPageLoad = false;
        //hdnShowInvoice.Value = "False";
    }

    #region Bind Dropdowns

    private void BindBillSchedule()
    {
        var billSchedule = SqlHelper.ExecuteDataTableProcedureParams("web_pr_payfreq_list", new Dictionary<string, object>());
        cmbBillSchedule.DataSource = billSchedule;
        cmbBillSchedule.DataBind();
    }

    private void BindFundingSource()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID } };
        var linkedBankAccounts = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        cmbFundingSource.DataSource = linkedBankAccounts;
        cmbFundingSource.DataBind();
    }

    private void BindBackUpFundingSource()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID }, { "@FlagBankOnly", 1 } };
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

    protected void btnRebindFundingSource_Click(object sender, EventArgs e)
    {
        BindFundingSource();
    }

    #endregion

    private void GetBlueCreditInformation()
    {
        // Validating the request
        if (ClientSession.ObjectID == null && ClientSession.ObjectType != ObjectType.BlueCredit) return;

        var cmdParams = new Dictionary<string, object>
                            {
                                { "@BlueCreditID", ClientSession.ObjectID}, { "@PracticeID", ClientSession.PracticeID }
                            };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            // Binding Top Section
            lblAccountHolder.Text = row["AccountHolder"].ToString();
            lblBlueCreditID.Text = row["BlueCreditID"].ToString();
            lblPhonePri.Text = row["PhonePri"].ToString();
            lblEmail.Text = row["Email"].ToString();

            // Binding Credit Plan Details Grid
            var blueCredit = new ArrayList { new { PlanName = row["PlanName"].ToString(), OpenDate = row["OpenDate"].ToString(), CreditLimit = row["CreditLimit$"].ToString(), Balance = row["Balance$"].ToString(), PromoRemainAbbr = row["PromoRemainAbbr"].ToString(), TermRemainAbbr = row["TermRemainAbbr"].ToString(), MinPayAmount = row["MinPayAmount$"].ToString(), NextPayDate = row["NextPayDate"].ToString() } };
            grdBlueCredit.DataSource = blueCredit;
            grdBlueCredit.DataBind();

            // Binding Bottom Section
            sldRecurringPayment.SmallChange = 25;
            sldRecurringPayment.MinimumValue = Convert.ToDecimal(row["MinPayAmount"]);
            sldRecurringPayment.MaximumValue = Convert.ToDecimal(row["Balance"]);
            sldRecurringPayment.Value = Convert.ToDecimal(row["PtSetRecurringMin"]);
            rngRecurringPayment.MinimumValue = Convert.ToDecimal(row["MinPayAmount"]).ToString("0.00");
            rngRecurringPayment.MaximumValue = Convert.ToDecimal(row["Balance"]).ToString("0.00");
            txtRecurringPayment.Text = row["PtSetRecurringMin"].ToString();
            rngRecurringPayment.ToolTip = "Invalid Payment";
            rngRecurringPayment.ErrorMessage = "Invalid Payment";
            lblPendingPayments.Text = "This plan will be paid off in " + CalcRemainingPayments(Convert.ToDecimal(row["Balance"]), Convert.ToInt32(row["LastCycle"]), Convert.ToDecimal(row["RatePromo"]), Convert.ToDecimal(row["TermPromo"]), Convert.ToDecimal(row["RateStd"]), Convert.ToDecimal(row["TermMax"]), Math.Min(Convert.ToDecimal(row["PtSetRecurringMin"]), Convert.ToDecimal(row["Balance"]))).ToString() + " payments.";
            cmbFundingSource.SelectedValue = row["PaymentCardID"].ToString();
            cmbBillSchedule.SelectedValue = row["PaymentFreqTypeID"].ToString();

            var paymentCardIDSec = row["PaymentCardIDSec"].ToString();
            if (string.IsNullOrEmpty(paymentCardIDSec))
                cmbBackupFundingSource.SelectedIndex = 0;
            else
                cmbBackupFundingSource.SelectedValue = paymentCardIDSec;


            if (!string.IsNullOrEmpty(row["NextPayDate"].ToString()))
                dtNextPayment.SelectedDate = Convert.ToDateTime(row["NextPayDate"].ToString());
            lblBorrower.Text = row["AccountHolder"].ToString();
            txtEmailAddress.Text = row["Email"].ToString();
            chkEmailBills.Checked = Convert.ToBoolean(row["FlagEmailBills"]);
            txtBillingAddress1.Text = row["Addr1"].ToString();
            txtAddress2.Text = row["Addr2"].ToString();
            txtCity.Text = row["City"].ToString();
            cmbStateType.SelectedValue = row["StateTypeID"].ToString();
            txtZip.Text = row["Zip"].ToString();
            txtZip4.Text = row["Zip4"].ToString();
            txtPhone.Text = row["PhonePri"].ToString();


            // Assigning the values for javascript usage

            hdnValues.Value = string.Format("{0},{1},{2},{3},{4},{5}", Convert.ToDecimal(row["Balance"]), Convert.ToInt32(row["LastCycle"]), Convert.ToDecimal(row["RatePromo"]), Convert.ToDecimal(row["TermPromo"]), Convert.ToDecimal(row["RateStd"]), Convert.ToDecimal(row["TermMax"]));

            // Applying Validation

            dtNextPayment.MinDate = DateTime.Now;
            dtNextPayment.MaxDate = DateTime.Now.AddMonths(1);


            if (chkEmailBills.Checked)
                hdnIsFlagEmails.Value = "True";
        }
    }

    private decimal CalcRemainingPayments(decimal financedAmount, Int32 cycle, decimal ratePromo, decimal termPromo, decimal rateStd, decimal termMax, decimal minPayment)
    {
        decimal totalPayments = 0;
        Int32 remainingCycles = 0;
        while (cycle <= termPromo && financedAmount > 0)
        {
            financedAmount += Math.Ceiling(financedAmount * ratePromo / 1200 * 100) / 100; //Add interest for period
            if (financedAmount < minPayment + 1) { minPayment = financedAmount; } //the last payment may be different by a few pennies, so it checks to see if it's within a dollar
            financedAmount -= minPayment; //Subtract from financedAmount
            totalPayments += minPayment; //Keep adding Total Actual Payments
            cycle++;
            remainingCycles++;
        }
        while (cycle <= termMax && financedAmount > 0)
        {
            financedAmount += Math.Ceiling(financedAmount * rateStd / 1200 * 100) / 100; //Add interest for period
            if (financedAmount < minPayment + 1) { minPayment = financedAmount; } //the last payment may be different by a few pennies, so it checks to see if it's within a dollar
            financedAmount -= minPayment; //Subtract from financedAmount
            totalPayments += minPayment; //Keep adding Total Actual Payments
            cycle++;
            remainingCycles++;
        }
        return cycle;
    }


    #region Grip Operations

    private DataTable GetActiveStatements()
    {
        var cmdParams = new Dictionary<string, object> { { "@BlueCreditID", ClientSession.ObjectID } };
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
    }

    protected void grdActiveStatements_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdActiveStatements.DataSource = GetActiveStatements();
    }

    protected void grdActiveStatements_OnPreRender(object sender, EventArgs e)
    {
        var count = grdActiveStatements.MasterTableView.Items.Count;
        if (count == 1)
        {
            var statementID = grdActiveStatements.MasterTableView.Items[0].GetDataKeyValue("StatementID");
            hdnStatementID.Value = statementID.ToString();
            hdnIsGridHasOneRow.Value = "1";
        }


    }

    #endregion

    #region Manage Statements

    protected void btnShowTruthInLendingPopup_Click(object sender, EventArgs e)
    {
        hdnIstruthInLending.Value = "1";
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            return;
        }
        var cmdParams = new Dictionary<string, object>
                            {
                                 { "@PatientID", ClientSession.PatientID },
                                 { "@BlueCreditID", ClientSession.ObjectID },
                                 { "@PhonePri", txtPhone.Text },
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
                                 { "@PtSetRecurringMin", txtRecurringPayment.Text }
                             };

        if (hdnIsTerminate.Value == "true")
            cmdParams.Add("FlagTerminate", 1);


        SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecredit_add", cmdParams);
        windowManager.RadAlert(hdnIsTerminate.Value == "true" ? "BlueCredit has been successfully terminated" : "BlueCredit has been successfully updated", 350, 100, "", "closePopup", "~/Content/Images/success.png");
        hdnIsTerminate.Value = null;
    }

    protected void btnTerminate_Click(object sender, EventArgs e)
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                 { "@FlagTerminate", 1 }
                             
                             };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecredit_add", cmdParams);
    }

    protected void rdb_OnChanged(object sender, EventArgs e)
    {
        foreach (GridDataItem item in grdActiveStatements.Items)
        {
            var activeStatementSelection = (RadioButton)item.FindControl("rdbSelect");
            if (activeStatementSelection.Checked)
            {
                hdnStatementID.Value = item.GetDataKeyValue("StatementID").ToString();
            }
            activeStatementSelection.Checked = false;
        }

        var rdbCheck = (sender as RadioButton);
        rdbCheck.Checked = true;

    }

    protected void btnRemoveStatement_Click(object sender, EventArgs e)
    {
        var isChecked = false;
        foreach (GridDataItem item in grdActiveStatements.Items)
        {
            var activeStatementSelection = (RadioButton)item.FindControl("rdbSelect");
            if (activeStatementSelection.Checked && !string.IsNullOrEmpty(hdnStatementID.Value))
            {
                isChecked = true;
            }

        }
        if (!isChecked && hdnIsGridHasOneRow.Value != "1")
        {
            windowManager.RadAlert("Please Select <strong>Active Assigned Statement</strong> first", 350, 100, "", "", "~/Content/Images/warning.png");
            return;
        }

        var cmdParams = new Dictionary<string, object>
                            {
                                {"@StatementID", hdnStatementID.Value},
                                {"@FlagActive", 0},
                                {"@UserID", ClientSession.UserID},
                            };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecredit_assign", cmdParams);
        grdActiveStatements.Rebind();
        hdnIsGridHasOneRow.Value = "0";
    }

    #endregion

    protected void btnAddCard_OnClick(object sender, EventArgs e)
    {
        // Setting the client session in order to show Bank panel.
        ClientSession.ObjectID = null;
        ClientSession.ObjectType = ObjectType.ManageBankAccount;
        popupAddPaymentCard.VisibleOnPageLoad = true;
    }

}
