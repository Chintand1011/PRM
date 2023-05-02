using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using Telerik.Web.UI;
using PatientPortal.Utility;

public partial class bluecredit_addcredit_popup : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {

        popupBlueCreditAccountValidation.VisibleOnPageLoad = false;

        if (!Page.IsPostBack)
        {
            try
            {
                // Closing the popup in case of any Error
                ClientSession.WasRequestFromPopup = true;
                lblStatementBalance.Text = string.Format("{0:c}", ClientSession.SelectedStatementBalance);

                //Displaying the checkbox if flag is true
                trOverideMimimumDownPayment.Visible = ClientSession.FlagBCModify;

                //Validate and show bluecredit account validation popup
                ValidateandShowBlueCreditValidationPopup();

            }
            catch (Exception)
            {
                throw;
            }
        }


    }


    protected void Page_LoadComplete(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            AutoSelectFirstOption();
            PopulateDownPaymentDisableOptionsGrid();
        }
        else
        {
            var shouldRecalculate = ViewState["FlagReCalculate"].ParseBool();
            if (shouldRecalculate)
            {
                ViewState["FlagReCalculate"] = null;
                CalculatePayments();
            }
        }
    }

    private void PopulateDownPaymentDisableOptionsGrid()
    {
        var shouldDisable = true;

        var objectValues = ClientSession.ObjectValue as Dictionary<string, object>;
        if (objectValues != null && objectValues.ContainsKey("FlagBCLoan"))
        {
            var downPayment = double.Parse(objectValues["DownPayment"].ToString());
            if (downPayment > 0)
            {
                txtDownPayment.Text = downPayment.ToString();
                chkOverideMinimumDownpayment_OnCheckChanged(this, new EventArgs());
                shouldDisable = false;
            }
        }

        if (shouldDisable)
        {
            DisableOptionsForExistingPlanGrid();
        }

    }

    private void ValidateandShowBlueCreditValidationPopup()
    {
        var flagGuardianPay = ClientSession.SelectedPatientInformation["FlagGuardianPay"].ParseBool();

        var cmdParam = new Dictionary<string, object>
        {
            { "@PracticeID", ClientSession.PracticeID },
            { "@PatientID", ClientSession.SelectedPatientID },
            { "@UserID", ClientSession.UserID},
            { "@FlagGuardian", flagGuardianPay ? 1 : 0}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecreditcheck_get", cmdParam);

        foreach (DataRow row in reader.Rows)
        {
            ViewState["TUPFSID"] = row["TUPFSID"];
            var flagError = Convert.ToBoolean(row["FlagError"]);

            if (flagError)
            {
                popupBlueCreditAccountValidation.VisibleOnPageLoad = true;
            }
        }
    }

    //Traditional Calculation
    private decimal CalcCreditPay(double amount, double apr, int term)
    {
        double monthlyPayment;
        if (term == 0)
        {
            monthlyPayment = amount;
        }
        else
        {
            if (apr == 0) { monthlyPayment = amount / term; }
            else
            {
                monthlyPayment = amount / (1 - 1 / Math.Pow(1 + apr / (365 * 100), term * 30)) * apr / 1200;
            }
        }
        return (decimal)Math.Ceiling(monthlyPayment * 100) / 100;
    }


    #region Grid Events

    private DataTable GetBlueCreditList()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@PracticeID", ClientSession.PracticeID },
            { "@StatementBalance", ClientSession.SelectedStatementBalance },
            { "@HighStatementBalance", ClientSession.HighestSelectedBalance },
            { "@PatientID", ClientSession.SelectedPatientID },
        };

        if (chkRecalculateLoan.Checked)
        {
            cmdParams.Add("@AmountFinanced", GetParsedFinancedAmount());
        }

        var blueCreditList = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_list", cmdParams);
        return blueCreditList;
    }

    private DataTable GetBlueCreditLenderList()
    {
        ViewState["FlagReCalculate"] = Page.IsPostBack;

        var cmdParams = new Dictionary<string, object>
        {
            { "@PracticeID", ClientSession.PracticeID },
            { "@StatementBalance", ClientSession.SelectedStatementBalance },
            { "@HighStatementBalance", ClientSession.HighestSelectedBalance },
            { "@PatientID", ClientSession.SelectedPatientID },
            { "@TUPFSID", ViewState["TUPFSID"]}
        };

        if (chkRecalculateLoan.Checked)
        {
            cmdParams.Add("@AmountFinanced", GetParsedFinancedAmount());
        }

        var blueCreditLenderList = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecreditlender_list", cmdParams);
        return blueCreditLenderList;
    }

    private decimal GetParsedFinancedAmount()
    {
        var financedAmount = string.IsNullOrEmpty(txtFinancedAmount.Text) ? 0 : decimal.Parse(txtFinancedAmount.Text);
        return financedAmount;
    }

    private DataTable GetExistingBlueCreditList()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@PatientID", ClientSession.SelectedPatientID },
            { "@PracticeID", ClientSession.PracticeID },
            { "@StatementBalance", ClientSession.SelectedStatementBalance },
            { "@HighStatementBalance", ClientSession.HighestSelectedBalance },
            { "@UserID", ClientSession.UserID}
        };
        var exisitngBlueCreditList = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_get", cmdParams);
        return exisitngBlueCreditList;
    }


    protected void grdExistingCreditPlan_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdExistingCreditPlan.DataSource = GetExistingBlueCreditList();
    }


    protected void grdBlueCreditLenderFunded_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var records = GetBlueCreditLenderList();
        grdBlueCreditLenderFunded.DataSource = records;

        divLenderFundingWarning.Visible = !records.AsEnumerable().Any();
    }

    protected void grdBlueCredit_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdBlueCredit.DataSource = GetBlueCreditList();
    }

    private void AutoSelectFirstOption()
    {

        if (ClientSession.BCLenderFlagLive)
        {
            // Auto selecting first row
            var lenderFundedPlan = grdBlueCreditLenderFunded.Items.Cast<GridDataItem>().FirstOrDefault();
            if (lenderFundedPlan != null)
            {
                var radioButton = (RadioButton)lenderFundedPlan.FindControl("rdbChoose");
                radioButton.Checked = true;

                SetMinValidations(lenderFundedPlan, true);

                return;
            }
        }



        // If there is no any record on Top Grid(Add to Existing Credit Plan) then Auto Select the radio button in bottom grid(Credit Plan Options)
        var newPlan = grdBlueCredit.Items.Cast<GridDataItem>().FirstOrDefault();
        if (newPlan != null)
        {
            var radioButton = (RadioButton)newPlan.FindControl("rdbChoose");
            radioButton.Checked = true;

            SetMinValidations(newPlan, true);

            return;
        }


        // Auto selecting the first radio button and also checking that the radiobutton not disabled in "Add to Existing Credit Plan" Grid
        var existingPlan = grdExistingCreditPlan.Items.Cast<GridDataItem>().FirstOrDefault();
        if (existingPlan != null)
        {
            var radioButton = (RadioButton)existingPlan.FindControl("rdbChooseExistingCreditPlan");
            radioButton.Checked = true;

            SetMinValidations(existingPlan, false);

        }


    }

    private void AutoSelectFirstOptionFromCurrentSelectedGrid()
    {
        if (ClientSession.BCLenderFlagLive)
        {
            var lenderFundedItems = grdBlueCreditLenderFunded.Items.Cast<GridDataItem>().ToList();
            var lenderFundedPlan = lenderFundedItems.SingleOrDefault(x => ((RadioButton)x.FindControl("rdbChoose")).Checked);
            if (lenderFundedPlan != null)
            {
                // un checking old plan
                var radioButton = lenderFundedPlan.GetControl<RadioButton>("rdbChoose");
                radioButton.Checked = false;

                // checking new plan
                var lenderFirstPlan = lenderFundedItems.First();
                radioButton = lenderFirstPlan.GetControl<RadioButton>("rdbChoose");
                radioButton.Checked = true;

                SetMinValidations(lenderFirstPlan, true);
            }
        }

        var newPlanItems = grdBlueCredit.Items.Cast<GridDataItem>().ToList();
        var newPlan = newPlanItems.SingleOrDefault(x => ((RadioButton)x.FindControl("rdbChoose")).Checked);
        if (newPlan != null)
        {
            var radioButton = newPlan.GetControl<RadioButton>("rdbChoose");
            radioButton.Checked = false;

            var bcFirstPlan = newPlanItems.First();
            radioButton = bcFirstPlan.GetControl<RadioButton>("rdbChoose");
            radioButton.Checked = true;

            SetMinValidations(bcFirstPlan, true);
        }


        var existingPlanItems = grdExistingCreditPlan.Items.Cast<GridDataItem>().ToList();
        var existingPlan = existingPlanItems.SingleOrDefault(x => ((RadioButton)x.FindControl("rdbChooseExistingCreditPlan")).Checked);
        if (existingPlan != null)
        {
            var radioButton = existingPlan.GetControl<RadioButton>("rdbChooseExistingCreditPlan");
            radioButton.Checked = false;

            var existingFirstPlan = existingPlanItems.First();
            radioButton = existingFirstPlan.GetControl<RadioButton>("rdbChooseExistingCreditPlan");
            radioButton.Checked = true;

            SetMinValidations(existingFirstPlan, false);
        }

    }

    private void SetMinValidations(GridDataItem item, bool isNewBCPlan)
    {
        hdnID.Value = item.GetDataKeyValue(isNewBCPlan ? "CreditTypeID" : "BlueCreditID").ToString();
        GetInformationAndApplyValidations(item, isNewBCPlan);
        hdnIsExistingCreditplan.Value = isNewBCPlan ? "false" : "true";
        ViewState["IsNewBluecreditPlan"] = isNewBCPlan;
    }

    protected void grdExistingCreditPlan_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            //// Enabling and Disabling the Radio button accroding to the FlagCreditEligible field.
            //var item = (GridDataItem)e.Item;
            //var chkCredit = item.FindControl("rdbChooseExistingCreditPlan") as CheckBox;
            //var flagCreditEligible = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagCreditEligible"]);
            //chkCredit.Enabled = flagCreditEligible;

            //if (!chkCredit.Enabled)
            //{
            //    e.Item.AltRowStyle();
            //}
            //else
            //{
            //    e.Item.RgRowStyle();
            //}

        }
    }

    protected void rdb_OnCheckedChanged(object sender, EventArgs e)
    {
        // Getting BluecreditID if request received from top grid and getting CreditTypeID if Bottom grid
        var id = hdnID.Value;

        if (ClientSession.BCLenderFlagLive)
        {
            foreach (GridDataItem item in grdBlueCreditLenderFunded.Items)
            {
                var creditPlanSelection = (RadioButton)item.FindControl("rdbChoose");
                var creditTypeID = item.GetDataKeyValue("CreditTypeID").ToString();
                if (creditTypeID == id)
                {
                    GetInformationAndApplyValidations(item, true);
                }

                // Removing the previous selected option because user clicked on new one
                creditPlanSelection.Checked = false;
            }
        }


        // Initializing the values based upon the Selected row for bottom grid
        foreach (GridDataItem item in grdBlueCredit.Items)
        {
            var creditPlanSelection = (RadioButton)item.FindControl("rdbChoose");
            var creditTypeID = item.GetDataKeyValue("CreditTypeID").ToString();
            if (creditTypeID == id)
            {
                GetInformationAndApplyValidations(item, true);
            }

            // Removing the previous selected option because user clicked on new one
            creditPlanSelection.Checked = false;
        }

        // Initializing the values based upon the Selected row for top grid
        foreach (GridDataItem item in grdExistingCreditPlan.Items)
        {
            var creditPlanSelection = (RadioButton)item.FindControl("rdbChooseExistingCreditPlan");
            var blueCreditID = item.GetDataKeyValue("BlueCreditID").ToString();
            if (blueCreditID == id)
            {
                GetInformationAndApplyValidations(item, false);
            }

            // Removing the previous selected option because user clicked on new one
            creditPlanSelection.Checked = false;
        }

        var rdbCheck = (sender as RadioButton);
        rdbCheck.Checked = true;


        DisableOptionsForExistingPlanGrid();

        if (chkOverideMinimumDownpayment.Checked) // we need this check this will ensure that we're not re assinging all min max validations
            ManageDownPaymentValidations();

        ValidateDownPayment();
    }

    protected void chkRecalculateLoan_OnCheckChanged(object sender, EventArgs e)
    {
        if (!chkRecalculateLoan.Checked) return;

        grdBlueCreditLenderFunded.Rebind();
        grdBlueCredit.Rebind();
        grdExistingCreditPlan.Rebind();

        AutoSelectFirstOption();

        if (chkOverideMinimumDownpayment.Checked)
        {
            DoOverrideStuff();
        }
    }

    protected void chkOverideMinimumDownpayment_OnCheckChanged(object sender, EventArgs e)
    {
        DoOverrideStuff(true);
    }

    private void DoOverrideStuff(bool isCalledFromOnChange = false)
    {
        ManageDownPaymentValidations(isCalledFromOnChange);
        DisableOptionsForExistingPlanGrid();
        ValidateDownPayment();
        CalculatePayments(isCalledFromOnChange);
    }

    #endregion


    protected void txtDownPayment_OnChange(object sender, EventArgs e)
    {
        var isDownPaymentValid = ValidateDownPayment();
        if (!isDownPaymentValid)
            return;

        CalculateFinancedAmount();

        if (chkRecalculateLoan.Checked)
        {
            AutoSelectFirstOptionFromCurrentSelectedGrid();
            DisableOptionsForExistingPlanGrid();
            DoOverrideStuff();
        }
        else
        {
            DisableOptionsForExistingPlanGrid();
            CheckDownPaymentValidation();
            CalculatePayments(true);
        }

    }

    protected void btnActivateCredit_Click(object sender, EventArgs e)
    {
        CalculatePayments();
        var data = ViewState["CreditTypeDetails"] as Dictionary<string, object>;
        var values = new Dictionary<string, object>
                         {
                             {"IsNewBluecreditPlan", Convert.ToBoolean(ViewState["IsNewBluecreditPlan"])},
                             {"CreditTypeID", Convert.ToDecimal(hdnCreditTypeID.Value)},
                             {"CreditLimit", Convert.ToDecimal( ClientSession.SelectedStatementBalance.ToString())},
                             {"StatementBalance", Convert.ToDecimal(ClientSession.SelectedStatementBalance.ToString())},
                             {"ExistingBCStatementBal", ViewState["ExistingBCStatementBal"] ?? 0},
                             {"DownPayment", txtDownPayment.Text},
                             {"FinancedAmount", Convert.ToDecimal(txtFinancedAmount.Text)},
                             {"MinimumPayment", Convert.ToDecimal(data["MinPay"])},
                             {"BlueCreditID", hdnBlueCreditID.Value},
                             {"PlanType", hdnPlanType.Value},
                             {"Cycle", data["LastCycle"]},
                             {"RatePromo", data["RatePromo"]},
                             {"TermPromo", data["TermPromo"]},
                             {"RateStd", data["RateStd"]},
                             {"TermMax", data["TermMax"]},
                             {"AgreementPDFFile", data["AgreementPDFFile"]},
                             {"PrivacyPDFFile", data["PrivacyPDFFile"]},
                             {"CurrentBalance", data["CurrentBalance"]},
                             {"LenderID", data["LenderID"]},
                             {"TUPFSID", ViewState["TUPFSID"]}
                         };



        // saving flag so if cancel the process in between so I know this orphan statement need to be removed
        var objectValues = ClientSession.ObjectValue as Dictionary<string, object>;
        if (objectValues != null && objectValues.ContainsKey("FlagBCLoan"))
        {
            values.Add("FlagBCLoan", 1);
        }

        ClientSession.ObjectValue = values;

        ScriptManager.RegisterStartupScript(Page, typeof(Page), "showApplyCredit", "showApplyCreditPopup();", true);

    }


    #region Common Functions

    private void ManageDownPaymentValidations(bool isOverrideDownpayment = false)
    {

        double downPayment;
        string message;
        var maximumPayment = double.Parse(rngDownPayment.MaximumValue);

        if (chkOverideMinimumDownpayment.Checked)
        {
            downPayment = 0;

            //txtDownPayment.MinValue = downPayment;

            message = string.Format("Plan down Payment should be between {0:c} to {1:c}", downPayment, maximumPayment);
            rngDownPayment.MinimumValue = downPayment.ToString();
            rngDownPayment.ErrorMessage = message;
            rngDownPayment.ToolTip = message;


            if (isOverrideDownpayment)
            {
                txtDownPayment.Text = downPayment.ToString();
            }

            //sldDownPayment.MinimumValue = 0;
            //sldDownPayment.Value = 0;

        }
        else
        {
            downPayment = double.Parse(ViewState["DownPaymentMinimumValue"].ToString());

            //txtDownPayment.MinValue = downPayment;

            message = string.Format("Down Payment should be between {0:c} to {1:c}", downPayment, maximumPayment);
            rngDownPayment.MinimumValue = ViewState["DownPaymentMinimumValue"].ToString();
            rngDownPayment.ErrorMessage = message;
            rngDownPayment.ToolTip = message;

            // This is the case when request comes after changing the downpayment
            if (!chkRecalculateLoan.Checked)
            {
                txtDownPayment.Text = downPayment.ToString();
            }

            //sldDownPayment.MinimumValue = Convert.ToDecimal(downPayment);
            //sldDownPayment.Value = sldDownPayment.MinimumValue;
            CheckDownPaymentValidation();
        }

        CalculateFinancedAmount();

    }

    private void GetInformationAndApplyValidations(GridDataItem item, bool isNewBlueCredit)
    {
        // Saving in order to pass into session
        hdnPlanType.Value = item.GetDataKeyValue("PlanName").ToString();
        var minDownPay = Convert.ToDecimal(item.GetDataKeyValue("MinDownPay").ToString());
        var maxDownPay = Convert.ToDecimal(item.GetDataKeyValue("MaxDownPay").ToString());

        hdnCreditTypeID.Value = item.GetDataKeyValue("CreditTypeID").ToString();
        hdnBlueCreditID.Value = !isNewBlueCredit ? item.GetDataKeyValue("BlueCreditID").ToString() : "0";

        //sldDownPayment.MinimumValue = minDownPay;
        //sldDownPayment.MaximumValue = maxDownPay;
        //sldDownPayment.Value = minDownPay;

        //txtDownPayment.MinValue = Convert.ToDouble(minDownPay);
        //txtDownPayment.MaxValue = Convert.ToDouble(maxDownPay);

        rngDownPayment.MinimumValue = minDownPay.ToString();
        rngDownPayment.MaximumValue = maxDownPay.ToString();

        ViewState["DownPaymentMinimumValue"] = minDownPay.ToString();

        var downPayment = minDownPay.ToString();
        SetDownPayment(downPayment);

        var message = string.Format("Plan down payment must be between {0:C} and {1:C}.  Please modify or have an administrator override.", minDownPay, maxDownPay);
        rngDownPayment.ToolTip = message;
        rngDownPayment.ErrorMessage = message;

        // Validations
        //sldDownPayment.SmallChange = 5;
        //sldDownPayment.LargeChange = 25;
        //sldDownPayment.Enabled = true;

        txtDownPayment.Enabled = true;

        btnActivateCredit.Enabled = false;
        btnActivateCredit.ImageUrl = "../Content/Images/btn_next_fade.gif";

        var statementBalance = ClientSession.SelectedStatementBalance;
        if (!isNewBlueCredit)
        {
            var balance = Convert.ToDecimal(item.GetDataKeyValue("Balance"));

            lblStatementBalance.Text = string.Format("{0:c}", statementBalance);//+ balance
            ViewState["ExistingBCStatementBal"] = balance;
        }


        ViewState["IsNewBluecreditPlan"] = isNewBlueCredit;

        // Enable the activate button
        btnActivateCredit.Enabled = true;
        btnActivateCredit.ImageUrl = "../Content/Images/btn_next.gif";

        // Calculate Payments
        CalculateFinancedAmount();
        CalculatePayments();

    }

    private void SetDownPayment(string downPayment)
    {
        if (chkOverideMinimumDownpayment.Checked)
            return;

        var enteredDownPayment = GetDownPayment();
        if (enteredDownPayment <= decimal.Parse(downPayment))
        {
            txtDownPayment.Text = downPayment;
        }
    }

    // CALC MIN PAYMENTS (NEW)
    private decimal CalculateMinPayments(decimal financedamount, decimal minPayrate, decimal minPayDollar)
    {
        var calculatedAmount = Math.Ceiling(Convert.ToDecimal(financedamount) * minPayrate * 100) / 100;
        return calculatedAmount > minPayDollar ? calculatedAmount : minPayDollar;
    }

    private double CalculateEffectiveAPR(double financedamount, double totalpayments, double minPayDollar)
    {
        double term = Math.Ceiling(totalpayments / minPayDollar);
        return Math.Ceiling((Math.Pow(totalpayments / financedamount, 1 / term) - 1) * 12 * 100) / 10;
    }

    private void CalculatePayments(bool isOnlyCalculateNewPlanGrid = false)
    {
        if (ClientSession.BCLenderFlagLive)
        {
            foreach (GridDataItem item in grdBlueCreditLenderFunded.Items)
            {
                CalculateAmountForBluecredit(item);
            }
        }

        foreach (GridDataItem item in grdBlueCredit.Items)
        {
            CalculateAmountForBluecredit(item);
        }

        if (isOnlyCalculateNewPlanGrid)
            return;

        foreach (GridDataItem item in grdExistingCreditPlan.Items)
        {
            var lbltotalInterest = (Label)item.FindControl("lbltotalInterest");
            var minPayments = (Label)item.FindControl("lblMinPayments");
            var TotalPayments = (Label)item.FindControl("lblTotalPayments");
            var EffectiveAPR = (Label)item.FindControl("lblEffectiveAPR");

            var ratePromo = item.GetDataKeyValue("RatePromo");
            var termPromo = item.GetDataKeyValue("TermPromo");
            var rateStd = item.GetDataKeyValue("RateStd");
            var termMax = item.GetDataKeyValue("TermMax");
            var minPayRate = item.GetDataKeyValue("MinPayRate");
            var minPayDollar = item.GetDataKeyValue("MinPayDollar");
            var Balance = item.GetDataKeyValue("Balance");
            var LastCycle = item.GetDataKeyValue("LastCycle");


            double minPay;
            if (Convert.ToDecimal(txtFinancedAmount.Text) + Convert.ToDecimal(Balance) > Convert.ToDecimal(minPayDollar))
            { minPay = Convert.ToDouble(CalculateMinPayments(Convert.ToDecimal(txtFinancedAmount.Text) + Convert.ToDecimal(Balance), Convert.ToDecimal(minPayRate), Convert.ToDecimal(minPayDollar))); }
            else
            { minPay = Convert.ToDouble(txtFinancedAmount.Text) + Convert.ToDouble(Balance); }
            minPayments.Text = minPay.ToString("C");
            decimal TotalPaymentsAmount = 0;
            TotalPaymentsAmount = MathFunctions.CalcTotalPay(
                                   Convert.ToDecimal(txtFinancedAmount.Text) + Convert.ToDecimal(Balance),
                                   Convert.ToDecimal(ratePromo),
                                   Convert.ToDecimal(termPromo) - Convert.ToDecimal(LastCycle),
                                   Convert.ToDecimal(rateStd),
                                   Convert.ToDecimal(termMax) - Convert.ToDecimal(LastCycle),
                                   Convert.ToDecimal(minPay));
            TotalPayments.Text = TotalPaymentsAmount.ToString("C");
            //1-31-2016 JHV Old EffectiveAPR calculation, determines APR over the course of the entire loan.
            //EffectiveAPR.Text = CalculateEffectiveAPR(Convert.ToDouble(txtFinancedAmount.Text) + Convert.ToDouble(Balance), Convert.ToDouble(TotalPayments.Text), minPay).ToString("0.00") + "%";
            decimal FirstYearInterest = 0;
            FirstYearInterest = MathFunctions.CalcY1Value(
                                   Convert.ToDecimal(txtFinancedAmount.Text) + Convert.ToDecimal(Balance),
                                   Convert.ToDecimal(ratePromo),
                                   Convert.ToDecimal(termPromo) - Convert.ToDecimal(LastCycle),
                                   Convert.ToDecimal(rateStd),
                                   Convert.ToDecimal(termMax) - Convert.ToDecimal(LastCycle),
                                   Convert.ToDecimal(minPay));
            EffectiveAPR.Text = (FirstYearInterest / (Convert.ToDecimal(txtFinancedAmount.Text) + Convert.ToDecimal(Balance)) * 100).ToString("0.00") + "%";

            lbltotalInterest.Text = (TotalPaymentsAmount - Convert.ToDecimal(txtFinancedAmount.Text) - Convert.ToDecimal(Balance)).ToString("C");

            var blueCreditID = item.GetDataKeyValue("BlueCreditID").ToString();
            if (blueCreditID == hdnID.Value)
            {
                SaveCreditTypeDetails(LastCycle, ratePromo, termPromo, rateStd, termMax, minPay, item);
            }

        }

    }


    private void CalculateAmountForBluecredit(GridEditableItem item)
    {
        var id = hdnID.Value;

        // get all column which need to be update

        // var lblPromoOnlyPay = (Label)item.FindControl("lblPromoOnlyPay"); //re-enable if promo payments is added back to the user grid in the UI (also uncomment the calc of this field below)
        var lbltotalInterest = (Label)item.FindControl("lbltotalInterest");
        var minPayments = (Label)item.FindControl("lblminPayments");
        var TotalPayments = (Label)item.FindControl("lblTotalPayments");
        var EffectiveAPR = (Label)item.FindControl("lblEffectiveAPR");

        // get all the necessary column

        var ratePromo = item.GetDataKeyValue("RatePromo");
        var termPromo = item.GetDataKeyValue("TermPromo");
        var rateStd = item.GetDataKeyValue("RateStd");
        var termMax = item.GetDataKeyValue("TermMax");
        var minPayRate = item.GetDataKeyValue("MinPayRate");
        var minPayDollar = item.GetDataKeyValue("MinPayDollar");

        // lblPromoOnlyPay.Text = "$" + Math.Max(CalcCreditPay(Convert.ToDouble(txtFinancedAmount.Text), (double)ratePromo, (int)termPromo), Convert.ToDecimal(minPayDollar)).ToString("0.00");
        double minPay;
        if (minPayRate == (object)DBNull.Value || Convert.ToDouble(termPromo) == 0)
        {
            minPayRate = Convert.ToDouble(MathFunctions.CalcMinPayRate(Convert.ToDecimal(rateStd), Convert.ToDecimal(termMax)));
            minPay = Convert.ToDouble(MathFunctions.CalcPMT(Convert.ToDecimal(rateStd), Convert.ToDecimal(termMax), Convert.ToDecimal(txtFinancedAmount.Text)));
        }
        else
        {
            minPay = Convert.ToDouble(CalculateMinPayments(Convert.ToDecimal(txtFinancedAmount.Text), Convert.ToDecimal(minPayRate), Convert.ToDecimal(minPayDollar)));
        }
        minPayments.Text = minPay.ToString("C");
        decimal TotalPaymentsAmount = 0;
        TotalPaymentsAmount = MathFunctions.CalcTotalPay(
                                         Convert.ToDecimal(txtFinancedAmount.Text),
                                         Convert.ToDecimal(ratePromo),
                                         Convert.ToDecimal(termPromo),
                                         Convert.ToDecimal(rateStd),
                                         Convert.ToDecimal(termMax),
                                         Convert.ToDecimal(minPay));
        TotalPayments.Text = TotalPaymentsAmount.ToString("C");
        //1-31-2016 JHV Old EffectiveAPR calculation, determines APR over the course of the entire loan.
        //EffectiveAPR.Text = CalculateEffectiveAPR(Convert.ToDouble(txtFinancedAmount.Text) + Convert.ToDouble(Balance), Convert.ToDouble(TotalPayments.Text), minPay).ToString("0.00") + "%";
        decimal FirstYearInterest = 0;
        FirstYearInterest = MathFunctions.CalcY1Value(
                               Convert.ToDecimal(txtFinancedAmount.Text),
                               Convert.ToDecimal(ratePromo),
                               Convert.ToDecimal(termPromo),
                               Convert.ToDecimal(rateStd),
                               Convert.ToDecimal(termMax),
                               Convert.ToDecimal(minPay));
        EffectiveAPR.Text = (FirstYearInterest / Convert.ToDecimal(txtFinancedAmount.Text) * 100).ToString("0.00") + "%";

        lbltotalInterest.Text = (TotalPaymentsAmount - Convert.ToDecimal(txtFinancedAmount.Text)).ToString("C");

        var creditTypeID = item.GetDataKeyValue("CreditTypeID").ToString();
        if (creditTypeID == id)
        {
            SaveCreditTypeDetails(0, ratePromo, termPromo, rateStd, termMax, minPay, item);
        }
    }


    private void SaveCreditTypeDetails(object lastCycle, object ratePromo, object termPromo, object rateStd, object termMax, object minPay, GridEditableItem item)
    {
        if (ViewState["CreditTypeDetails"] == null)
        {
            ViewState["CreditTypeDetails"] = new Dictionary<string, object>();
        }

        var values = ViewState["CreditTypeDetails"] as Dictionary<string, object>;

        var tableView = item.OwnerTableView;

        var existingBalance = "0";
        if (tableView.Columns.FindByUniqueNameSafe("ExistingBalance") != null)
        {
            existingBalance = item["ExistingBalance"].Text;
        }

        var lenderID = "0";
        if (tableView.DataKeyNames.Any(x => x == "LenderID"))
        {
            lenderID = item.GetDataKeyValue("LenderID").ToString();
        }

        values["LastCycle"] = lastCycle;
        values["RatePromo"] = ratePromo;
        values["TermPromo"] = termPromo;
        values["RateStd"] = rateStd;
        values["TermMax"] = termMax;
        values["MinPay"] = minPay;
        values["AgreementPDFFile"] = item.GetDataKeyValue("AgreementPDFFile");
        values["PrivacyPDFFile"] = item.GetDataKeyValue("PrivacyPDFFile");
        values["CurrentBalance"] = existingBalance;
        values["LenderID"] = lenderID;
    }

    private void DisableOptionsForExistingPlanGrid()
    {
        var statementBalance = ClientSession.SelectedStatementBalance;
        var downPayment = GetDownPayment();

        var financedAmount = statementBalance - downPayment;


        foreach (GridDataItem dataItem in grdExistingCreditPlan.Items)
        {
            var radioButton = (RadioButton)dataItem.FindControl("rdbChooseExistingCreditPlan");
            radioButton.Enabled = true;
            dataItem.RgRowStyle();
        }

        foreach (GridDataItem dataItem in grdExistingCreditPlan.Items)
        {
            var creditAvailable = decimal.Parse(dataItem.GetDataKeyValue("CreditAvail").ToString());
            if (financedAmount > creditAvailable)
            {
                var radioButton = (RadioButton)dataItem.FindControl("rdbChooseExistingCreditPlan");
                radioButton.Enabled = false;

                dataItem.AltRowStyle();
            }
        }

        CheckIfSelectedRowOptionDisabledAndShowMessage();

    }

    private void CheckIfSelectedRowOptionDisabledAndShowMessage()
    {
        // Getting BluecreditID if request received from top grid and getting CreditTypeID if Bottom grid
        var id = hdnID.Value;

        var dataItem = grdExistingCreditPlan.Items.Cast<GridDataItem>().SingleOrDefault(x => x.GetDataKeyValue("BlueCreditID").ToString() == id);
        if (dataItem == null) return;

        var creditPlanSelection = (RadioButton)dataItem.FindControl("rdbChooseExistingCreditPlan");
        if (!creditPlanSelection.Enabled && creditPlanSelection.Checked)
        {
            creditPlanSelection.Checked = false;
            ShowCreditPlanNoLongerAvailErrorMessage();
            ViewState["HasMessageDisplayed"] = true;
        }

    }

    private void CheckDownPaymentValidation()
    {
        var downPayment = GetDownPayment();
        var minDownPayment = decimal.Parse(rngDownPayment.MinimumValue);

        if (downPayment < minDownPayment)
        {
            foreach (var radioButton in from GridDataItem dataItem in grdBlueCredit.Items select (RadioButton)dataItem.FindControl("rdbChoose"))
            {
                radioButton.Checked = false;
            }

            txtDownPayment.Text = "0";
            CalculateFinancedAmount();

            var hasMessageDisplayed = ViewState["HasMessageDisplayed"].ParseBool();
            if (!hasMessageDisplayed)
            {
                ShowCreditPlanNoLongerAvailErrorMessage();
                ViewState["HasMessageDisplayed"] = false;
            }

        }
    }

    private void ShowCreditPlanNoLongerAvailErrorMessage()
    {
        RadAlertManager.RadAlert("Due to a change in the down payment amount, the selected credit plan is no longer available. Please select a new plan.", 400, 150, "", "", "../Content/Images/warning.png");
    }

    #endregion

    #region Helper Functions

    private decimal GetDownPayment()
    {
        decimal downPayment;
        decimal.TryParse(txtDownPayment.Text ?? "0", out downPayment);

        return downPayment;
    }



    /// <summary>
    /// This function return correct financed amount
    /// and txtDownPayment.Text being updated before calling this function
    /// </summary>
    private void CalculateFinancedAmount()
    {
        var financedAmount = ClientSession.SelectedStatementBalance - GetDownPayment();
        txtFinancedAmount.Text = financedAmount.ToString();
    }

    private bool ValidateDownPayment()
    {
        var minValue = decimal.Parse(rngDownPayment.MinimumValue);
        var maxValue = decimal.Parse(rngDownPayment.MaximumValue);
        var downPayment = GetDownPayment();

        if (downPayment < minValue || downPayment > maxValue)
        {
            rngDownPayment.IsValid = false;
            spanFailureNotification.InnerText = rngDownPayment.ErrorMessage;
        }

        else
        {
            spanFailureNotification.InnerText = string.Empty;
        }

        return rngDownPayment.IsValid;

    }

    #endregion


    #region Common Functions

   

    #endregion
}