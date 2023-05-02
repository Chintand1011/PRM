using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class managePaymentPlan_popup : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // Validating the request, if request comming as EditPayplan and AddPayPlan only
                if (ClientSession.ObjectType == ObjectType.EditPaymentPlan || ClientSession.ObjectType == ObjectType.AddPaymentPlan)
                {
                    var balance = Convert.ToDecimal(ClientSession.ObjectValue);
                    var paymentPlanID = (Int32?)ClientSession.ObjectID2;
                    // For furthur use
                    ViewState["paymentPlanID"] = paymentPlanID;
                    // For all calculations
                    InitializePaymentPlanPopup(balance, paymentPlanID);
                    ShowSavedValueIfNotEmpty();
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
    #region Payment Plan

    #region ShowPaymentPlanPopup

    private void ShowSavedValueIfNotEmpty()
    {
        try
        {
            var values = ClientSession.ListofObject as Dictionary<string, object>;
            if (values == null) return;

            object value;
            values.TryGetValue("Date", out value);
            dtStartDate.SelectedDate = Convert.ToDateTime(value);

            values.TryGetValue("InitialPayment", out value);
            txtInitialPayment.Text = value.ToString();
            ManageInitialAndRecurringPayment();

            values.TryGetValue("RecurringPayment", out value);
            txtRecurringPayment.Text = value.ToString();
            UpdatePaymentCycle();

            values.TryGetValue("PaymentMethod", out value);
            cmbPaymentMethods.SelectedValue = value.ToString();

            values.TryGetValue("PayFrequency", out value);
            cmbPayFrequency.SelectedValue = value.ToString();

            values.TryGetValue("hdnPayFrequency", out value);
            hdnPayFrequency.Value = value.ToString();

            ClientSession.ListofObject = null;
        }
        catch (Exception)
        {

        }

    }

    private void InitializePaymentPlanPopup(Decimal statementBalance, Nullable<int> paymentPlanID)
    {
        //Bind payment methods
        BindPaymentMethods();

        //Bind payment Frequency
        BindPaymentFrequency();
        Decimal MinDeposit = 0, MaxDeposit = 0, MinPayment = 0, MaxPayment = 0;
        int defaultPeriods = 3; //Default number of periods to place the default deposit value. 

        if (paymentPlanID == null) //New Payment Plan
        {
            var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID }, { "@StatementID", ClientSession.ObjectID } }; //, { "@StatementBalance", statementBalance }
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentplan_list", cmdParams);
            foreach (DataRow row in reader.Rows)
            {
                lblStatementFullName.Text = row["StatementNameLong"].ToString();

                dtStartDate.MinDate = Convert.ToDateTime(row["DateStartMin"]);
                dtStartDate.SelectedDate = Convert.ToDateTime(row["DateStart"]);
                dtStartDate.MaxDate = Convert.ToDateTime(row["DateStartMax"]);

                // Adding check to avoid unexpected error
                if (dtStartDate.SelectedDate < dtStartDate.MinDate)
                    dtStartDate.SelectedDate = dtStartDate.MinDate;


                lblDateStartMax.Text = "Enter a date before " + Convert.ToDateTime(row["DateStartMax"]).ToString("MM/dd/yyyy");
                hdnPayFrequency.Value = cmbPayFrequency.SelectedValue;
                lblOutstandingBalance.Text = "$" + statementBalance.ToString("0.00");
                MinDeposit = Math.Max(Convert.ToDecimal(row["PayPlanMinDPDollar"]), Math.Ceiling(statementBalance * Convert.ToDecimal(row["PayPlanMinDPRate"]) * 100) / 100);
                MaxDeposit = statementBalance;

                lblInitialPaymentInterval.Text = "Enter between $" + MinDeposit.ToString("0.00") + " and $" + MaxDeposit.ToString("0.00");
                rngInititalPayment.MinimumValue = MinDeposit.ToString();
                rngInititalPayment.MaximumValue = MaxDeposit.ToString();
                txtInitialPayment.MinValue = Convert.ToDouble(MinDeposit);
                txtInitialPayment.MaxValue = Convert.ToDouble(MaxDeposit);

                txtInitialPayment.Value = Convert.ToDouble(Math.Max(Convert.ToDecimal(row["PayPlanMinDPDollar"]), Convert.ToDecimal(Math.Ceiling(statementBalance * Convert.ToDecimal(.33) / 10) * 10)));

                MinPayment = Math.Min(Math.Max(Convert.ToDecimal(row["PayPlanMinAmt"]), Math.Ceiling((statementBalance - Convert.ToDecimal(txtInitialPayment.Value)) / (Convert.ToDecimal(row["PayPlanMaxTerm"]) - 1) * 100) / 100) + Convert.ToDecimal(row["PayPlanFee"]), statementBalance - Convert.ToDecimal(txtInitialPayment.Value) + Convert.ToDecimal(row["PayPlanFee"]));
                MaxPayment = statementBalance - Convert.ToDecimal(txtInitialPayment.Value) + Convert.ToDecimal(row["PayPlanFee"]);
                lblRecurringPaymentInterval.Text = "Enter between $" + MinPayment.ToString("0.00") + " and $" + MaxPayment.ToString("0.00");
                rngRecurringPayment.MinimumValue = MinPayment.ToString();
                rngRecurringPayment.MaximumValue = MaxPayment.ToString();

                lblRecurringPaymentInterval.Text = "Enter between $" + MinPayment.ToString("0.00") + " and $" + MaxPayment.ToString("0.00");

                txtRecurringPayment.MinValue = Convert.ToDouble(MinPayment);
                txtRecurringPayment.MaxValue = Convert.ToDouble(MaxPayment);

                txtRecurringPayment.Value = Convert.ToDouble(Math.Max(Math.Floor((Convert.ToDecimal((Convert.ToDecimal(statementBalance) - Convert.ToDecimal(txtInitialPayment.Value)) / (defaultPeriods - 1)) + Convert.ToDecimal(row["PayPlanFee"])) * 100 + .5m) / 100, Convert.ToDecimal(MinPayment)));
                litDisclaimer.Text = row["DisclaimerText"].ToString();
                hdnPayPlanMinAmt.Value = row["PayPlanMinAmt"].ToString();
                hdnPayPlanMaxTerm.Value = row["PayPlanMaxTerm"].ToString();
                hdnPayPlanFee.Value = row["PayPlanFee"].ToString();
                hdnStatementBalance.Value = statementBalance.ToString();

                int numberPayments = 0; //number of payments in addition to downpayment.
                decimal Balance = Convert.ToDecimal(hdnStatementBalance.Value) - Convert.ToDecimal(txtInitialPayment.Enabled) * Convert.ToDecimal(txtInitialPayment.Value);
                while (Balance - (Convert.ToDecimal(txtRecurringPayment.Value)) * numberPayments > 0) // Excluding Convert.ToDecimal(row["PayPlanFee"]) from Calculations
                {
                    numberPayments++;
                }
                numberPayments += Convert.ToInt32(txtInitialPayment.Enabled);

                lblNumberofPayments.Text = numberPayments.ToString();
                var startDate = Convert.ToDateTime(dtStartDate.SelectedDate);
                lblEndDate.Text = startDate.AddMonths(Convert.ToInt32(numberPayments - Convert.ToInt32(txtInitialPayment.Enabled))).ToString("MM/dd/yyyy");
            }
        }
        else //Pre Existing Payment Plan
        {
            var cmdParams = new Dictionary<string, object>
            {
                { "@PaymentPlanID", paymentPlanID },
                { "@UserID", ClientSession.UserID}
            };
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentplan_get", cmdParams);

            if (reader.Rows.Count == 0) return;
            foreach (DataRow row in reader.Rows)
            {
                lblStatementFullName.Text = row["StatementNameLong"].ToString();

                // For displaying the delete button on Payment Plan
                btnDeletePaymentPlan.Visible = true;

                var flagDPLocked = row["FlagDPLocked"].ParseBool();
                if (flagDPLocked)
                {
                    lblStartDate.Text = "Payment Date:";
                    txtInitialPayment.Enabled = false;
                    // hiding the Intitial Payment and text from the right
                    divInitialPayment.Visible = true;

                }

                dtStartDate.MinDate = Convert.ToDateTime(row["DateStartMin"]);
                dtStartDate.SelectedDate = Convert.ToDateTime(row["NextPayDate"]);
                dtStartDate.MaxDate = Convert.ToDateTime(row["DateStartMax"]);

                // Adding check to avoid unexpected error
                if (dtStartDate.SelectedDate < dtStartDate.MinDate)
                    dtStartDate.SelectedDate = dtStartDate.MinDate;


                lblDateStartMax.Text = "Enter a date before " + Convert.ToDateTime(row["DateStartMax"]).ToString("MM/dd/yyyy");
                hdnPayFrequency.Value = cmbPayFrequency.SelectedValue = row["PaymentFreqTypeID"].ToString();
                lblOutstandingBalance.Text = row["Balance$"].ToString();
                MinDeposit = Math.Min(Math.Max(Convert.ToDecimal(row["PayPlanMinDPDollar"]), Math.Ceiling(Convert.ToDecimal(row["Balance"]) * Convert.ToDecimal(row["PayPlanMinDPRate"]) * 100) / 100), Convert.ToDecimal(row["Balance"]));
                MaxDeposit = Convert.ToDecimal(row["Balance"]);

                lblInitialPaymentInterval.Text = flagDPLocked ? "This amount has already been charged." : "Enter between $" + MinDeposit.ToString("0.00") + " and $" + MaxDeposit.ToString("0.00");
                rngInititalPayment.MinimumValue = MinDeposit.ToString();
                rngInititalPayment.MaximumValue = MaxDeposit.ToString();
                txtInitialPayment.MinValue = Convert.ToDouble(MinDeposit);
                txtInitialPayment.MaxValue = Convert.ToDouble(MaxDeposit);

                txtInitialPayment.Value = Convert.ToDouble(Math.Min(Convert.ToDecimal(row["DPAmount"]), Convert.ToDecimal(MaxDeposit)));

                MinPayment = Math.Min(Math.Max(Convert.ToDecimal(row["PayPlanMinAmt"]), Math.Ceiling((Convert.ToDecimal(row["Balance"]) - Convert.ToDecimal(txtInitialPayment.Value) * Convert.ToDecimal(txtInitialPayment.Enabled)) / (Convert.ToDecimal(row["PayPlanMaxTerm"]) - Convert.ToDecimal(txtInitialPayment.Enabled) - Convert.ToDecimal(row["LastCycle"])) * 100) / 100), Convert.ToDecimal(row["Balance"]) - Convert.ToDecimal(txtInitialPayment.Value) * Convert.ToDecimal(txtInitialPayment.Enabled));
                MaxPayment = Convert.ToDecimal(row["Balance"]) - Convert.ToDecimal(txtInitialPayment.Value) * Convert.ToDecimal(txtInitialPayment.Enabled);

                lblRecurringPaymentInterval.Text = "Enter between $" + MinPayment.ToString("0.00") + " and $" + MaxPayment.ToString("0.00");
                rngRecurringPayment.MinimumValue = MinPayment.ToString();
                rngRecurringPayment.MaximumValue = MaxPayment.ToString();

                txtRecurringPayment.MinValue = Convert.ToDouble(MinPayment);
                txtRecurringPayment.MaxValue = Convert.ToDouble(MaxPayment);

                txtRecurringPayment.Text = Math.Min(Math.Max(Convert.ToDecimal(row["MinPayAmount"]), Convert.ToDecimal(row["PtSetRecurringMin"])), Convert.ToDecimal(row["Balance"]) - Convert.ToDecimal(txtInitialPayment.Value) * Convert.ToDecimal(txtInitialPayment.Enabled)).ToString();
                litDisclaimer.Text = row["DisclaimerText"].ToString();
                hdnPayPlanMinAmt.Value = row["PayPlanMinAmt"].ToString();
                hdnPayPlanMaxTerm.Value = row["PayPlanMaxTerm"].ToString();
                hdnPayPlanFee.Value = row["PayPlanFee"].ToString();
                hdnStatementBalance.Value = row["Balance"].ToString();

                if (txtRecurringPayment.Value > 0)
                {
                    rngRecurringPayment.MinimumValue = (MinPayment + Convert.ToDecimal(row["PayPlanFee"])).ToString();
                    rngRecurringPayment.MaximumValue = (MaxPayment + Convert.ToDecimal(row["PayPlanFee"])).ToString();
                    txtRecurringPayment.Text = Convert.ToDecimal(txtRecurringPayment.Value).ToString();
                    lblRecurringPaymentInterval.Text = "Enter between $" + (MinPayment + Convert.ToDecimal(row["PayPlanFee"])).ToString("0.00") + " and $" + (MaxPayment + Convert.ToDecimal(row["PayPlanFee"])).ToString("0.00");

                    txtRecurringPayment.MinValue = Convert.ToDouble((MinPayment + Convert.ToDecimal(row["PayPlanFee"])).ToString());
                    txtRecurringPayment.MaxValue = Convert.ToDouble((MaxPayment + Convert.ToDecimal(row["PayPlanFee"])).ToString());
                }
                cmbPaymentMethods.SelectedValue = row["PaymentCardID"].ToString();

                int numberPayments = 0; //number of payments in addition to downpayment.
                decimal Balance = Convert.ToDecimal(hdnStatementBalance.Value) - Convert.ToDecimal(txtInitialPayment.Enabled) * Convert.ToDecimal(txtInitialPayment.Value);
                while (Balance - Convert.ToDecimal(txtRecurringPayment.Value) * numberPayments > 0)
                {
                    numberPayments++;
                }
                numberPayments += Convert.ToInt32(txtInitialPayment.Enabled);

                lblNumberofPayments.Text = numberPayments.ToString();
                var startDate = Convert.ToDateTime(dtStartDate.SelectedDate);
                lblEndDate.Text = startDate.AddMonths(Convert.ToInt32(numberPayments - Convert.ToInt32(txtInitialPayment.Enabled))).ToString("MM/dd/yyyy");
            }
        }
    }

    private void BindPaymentMethods()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@PatientID", ClientSession.SelectedPatientID },
            { "@UserID", ClientSession.UserID}
        };

        var paymentMethods = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        cmbPaymentMethods.DataSource = paymentMethods;
        cmbPaymentMethods.DataBind();
    }
    private void BindPaymentFrequency()
    {
        var payFrequency = SqlHelper.ExecuteDataTableProcedureParams("web_pr_payfreq_list", new Dictionary<string, object>());

        cmbPayFrequency.DataSource = payFrequency;
        cmbPayFrequency.DataBind();
        cmbPayFrequency.SelectedIndex = 0; // Selects the first value.
    }

    protected void dtStartDate_OnChanged(object sender, EventArgs e)
    {
        UpdatePaymentCycle();
    }

    //Leaving for jose commenting 
    protected void txtInitialPayment_OnTextChanged(object sender, EventArgs e)
    {
        ManageInitialAndRecurringPayment();
    }

    private void ManageInitialAndRecurringPayment()
    {
        var minAmount = Math.Min(Math.Max(Convert.ToDecimal(hdnPayPlanMinAmt.Value), Math.Ceiling((Convert.ToDecimal(hdnStatementBalance.Value) - Convert.ToDecimal(txtInitialPayment.Value)) / (Convert.ToDecimal(hdnPayPlanMaxTerm.Value) - 1) * 100) / 100) + Convert.ToDecimal(hdnPayPlanFee.Value), Convert.ToDecimal(hdnStatementBalance.Value) - Convert.ToDecimal(txtInitialPayment.Value));
        var maxAmount = Convert.ToDecimal(hdnStatementBalance.Value) - Convert.ToDecimal(txtInitialPayment.Value);
        if (minAmount > 0) { minAmount += Convert.ToDecimal(hdnPayPlanFee.Value); }
        if (maxAmount > 0) { maxAmount += Convert.ToDecimal(hdnPayPlanFee.Value); }
        rngRecurringPayment.MinimumValue = minAmount.ToString("");
        rngRecurringPayment.MaximumValue = maxAmount.ToString("");
        lblRecurringPaymentInterval.Text = "Enter between $" + minAmount.ToString("0.00") + " and $" + maxAmount.ToString("0.00");

        txtRecurringPayment.MinValue = Convert.ToDouble(minAmount);
        txtRecurringPayment.MaxValue = Convert.ToDouble(maxAmount);

        if (Convert.ToDecimal(txtRecurringPayment.Value) > Convert.ToDecimal(maxAmount)) { txtRecurringPayment.Value = Convert.ToDouble(maxAmount); }
        if (Convert.ToDecimal(txtRecurringPayment.Value) < Convert.ToDecimal(minAmount)) { txtRecurringPayment.Value = Convert.ToDouble(minAmount); }
        int numberPayments = 0; //number of payments in addition to downpayment.

        //If txtInitialPayment.Enabled is true, then we want to subtract Initial Payment from Balance because DP has not been paid. If it's false, DP has been paid, and Balance has already been reduced.
        Decimal Balance = Convert.ToDecimal(hdnStatementBalance.Value) - 1 * Convert.ToDecimal(txtInitialPayment.Enabled) * Convert.ToDecimal(txtInitialPayment.Value);
        while (Balance - Convert.ToDecimal(txtRecurringPayment.Value) * numberPayments > 0)
        {
            numberPayments++;
        }
        numberPayments += Convert.ToInt32(txtInitialPayment.Enabled);
        lblNumberofPayments.Text = numberPayments.ToString();

        var startDate = Convert.ToDateTime(dtStartDate.SelectedDate);
        lblEndDate.Text = startDate.AddMonths(Convert.ToInt32(numberPayments)).ToString("MM/dd/yyyy");
    }

    protected void txtRecurringPayment_OnTextChanged(object sender, EventArgs e)
    {
        UpdatePaymentCycle();
    }

    private void UpdatePaymentCycle()
    {
        int numberPayments = 0; //number of payments in addition to downpayment.

        //If txtInitialPayment.Enabled is true, then we want to subtract Initial Payment from Balance because DP has not been paid. If it's false, DP has been paid, and Balance has already been reduced.
        Decimal Balance = Convert.ToDecimal(hdnStatementBalance.Value) - 1 * Convert.ToDecimal(txtInitialPayment.Enabled) * Convert.ToDecimal(txtInitialPayment.Value);
        while (Balance - Convert.ToDecimal(txtRecurringPayment.Value) * numberPayments > 0)
        {
            numberPayments++;
        }
        numberPayments += Convert.ToInt32(txtInitialPayment.Enabled);
        lblNumberofPayments.Text = numberPayments.ToString();

        var startDate = Convert.ToDateTime(dtStartDate.SelectedDate);
        lblEndDate.Text = startDate.AddMonths(Convert.ToInt32(numberPayments)).ToString("MM/dd/yyyy");
    }


    #endregion

    #region Payment Plan Input Data Popup

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                var cmdParams = new Dictionary<string, object>
                                    { 
                                        {"@PaymentPlanID", ClientSession.ObjectID2}, //null for new?
                                        {"@StatementID", ClientSession.ObjectID},
                                        {"@PatientID", ClientSession.SelectedPatientID},
                                        {"@MaxCycles", hdnPayPlanMaxTerm.Value},
                                        {"@PaymentFreqTypeID ", cmbPayFrequency.SelectedValue},
                                        {"@FirstBillDate", dtStartDate.SelectedDate},
                                        {"@DPPaymentCardID", cmbPaymentMethods.SelectedValue},
                                        {"@DPAmount", txtInitialPayment.Text.Trim()},
                                        {"@PaymentCardID", cmbPaymentMethods.SelectedValue},
                                        {"@MinPayAmount", hdnPayPlanMinAmt.Value},
                                        {"@PtSetRecurringMin", txtRecurringPayment.Text.Trim()},
                                        {"@NextPayDate", dtStartDate.SelectedDate},
                                        {"@UserID", ClientSession.UserID},                                      
                                        {"@FlagActive ", 1},
                                       
                                    };

                if (hdnIsDeletePaymentPlan.Value == "1")
                    cmdParams.Add("@FlagTerminate", 1);

                SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentplan_add", cmdParams);

                // Displaying the Confirmation Radwindow in case of Deleting the payment plan
                if (hdnIsDeletePaymentPlan.Value == "1")
                {
                    RadWindow.RadAlert("Record successfully deleted.", 350, 150, "", "reloadPage", "../Content/Images/success.png");
                    return;
                }

                // Displaying the Confirmation Radwindow in case of Add or update the payment plan
                RadWindow.RadAlert(ViewState["paymentPlanID"] == null ? "Record successfully created." : "Record successfully updated.", 350, 150, "", "reloadPage", "../Content/Images/success.png");
            }
            catch (Exception)
            {
                throw;
            }
        }
    }

    protected void btnAddPaymentCard_OnClick(object sender, EventArgs e)
    {
        var values = new Dictionary<string, object> {
                        {"Date", dtStartDate.SelectedDate},
                        {"InitialPayment", txtInitialPayment.Text},
                        {"RecurringPayment", txtRecurringPayment.Text},
                        {"PaymentMethod", cmbPaymentMethods.SelectedValue},
                        {"PayFrequency", cmbPayFrequency.SelectedValue},
                        {"hdnPayFrequency", hdnPayFrequency.Value}
                    };

        ClientSession.ListofObject = values;
        hdnShowAddPaymentCardPopup.Value = "1";
    }

    #endregion


    #endregion
}

