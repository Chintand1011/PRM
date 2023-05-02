using System;
using System.Activities.Statements;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class bluecredit_applycredit_popup : BasePage
{
    public decimal DownPayment { get; set; }

    private Dictionary<string, object> PatientInformation
    {
        get
        {
            return ClientSession.SelectedPatientInformation;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // Closing the popup in case of any error
                ClientSession.WasRequestFromPopup = true;

                // Saving data to viewstate
                ViewState["ObjectValue"] = ClientSession.ObjectValue;

                // Binding the dropdowns
                BindFinancialResponsibility();
                BindBillingAddress();
                BindBillSchedule();
                BindFundingSource();
                BindRegularACHPayments();
                BindApplyPaymentTo();

                // Showing the remaing payments
                ShowRemainingPayments();
                // Showing the Bluecredit Information
                GetBlueCreditInformation();
                ShowBillingAddressInfo();

                ApplyValidations();

            }
            catch (Exception)
            {
                throw;
            }
        }

        hdnShowTruthInLending.Value = "0";
        popupMessage.VisibleOnPageLoad = false;
        popupManageAccounts.VisibleOnPageLoad = false;
        popupConfirmationPayment.VisibleOnPageLoad = false;
        hdnClosePopup.Value = "0";

        // For javascript use
        DownPayment = Convert.ToDecimal(ViewState["DownPayment"]);
    }

    private void BindFinancialResponsibility()
    {
        if (!ClientSession.IsFlagGuardianExists)
        {
            cmbResponsibleParty.Items.Add(new RadComboBoxItem { Text = FinancialResponsibility.Patient.ToString(), Value = ((int)FinancialResponsibility.Patient).ToString() });
        }
        else
        {
            cmbResponsibleParty.Items.Add(new RadComboBoxItem { Text = FinancialResponsibility.Patient.ToString(), Value = ((int)FinancialResponsibility.Patient).ToString() });
            cmbResponsibleParty.Items.Add(new RadComboBoxItem { Text = FinancialResponsibility.Guardian.ToString(), Value = ((int)FinancialResponsibility.Guardian).ToString() });
        }


        // Disabling the Responsibility Party Dropdown if Bluecredit not equal to zero
        var values = ClientSession.ObjectValue as Dictionary<string, object>;
        var BlueCreditID = values["BlueCreditID"].ToString();

        if (Convert.ToString(BlueCreditID) != "0") cmbResponsibleParty.Enabled = false;
    }

    private void BindBillingAddress()
    {

        //Adding Primary Address option if flagSecondaryOption is true
        cmbBillingAddress.Items.Add(new RadComboBoxItem { Text = "Primary Address", Value = ((int)AddressType.Primary).ToString() });

        var flagSecondaryOption = PatientInformation["FlagAddrSecValid"].ParseBool();
        if (flagSecondaryOption)
        {
            cmbBillingAddress.Items.Add(new RadComboBoxItem { Text = "Alternate Address", Value = ((int)AddressType.Secondary).ToString() });
        }

        // Disabling the Billing Address Dropdown if Bluecredit not equal to zero
        var values = ClientSession.ObjectValue as Dictionary<string, object>;
        var BlueCreditID = values["BlueCreditID"].ToString();
        if (Convert.ToString(BlueCreditID) != "0") cmbBillingAddress.Enabled = false;
    }

    private void BindBillSchedule()
    {
        var billSchedule = SqlHelper.ExecuteDataTableProcedureParams("web_pr_payfreq_list", new Dictionary<string, object>());
        cmbBillSchedule.DataSource = billSchedule;
        cmbBillSchedule.DataBind();
        cmbBillSchedule.SelectedIndex = 0; // for selecting the first row.
    }

    private void BindApplyPaymentTo()
    {
        var downPayment = ClientSession.ObjectValue as Dictionary<string, object>;
        object value;
        downPayment.TryGetValue("DownPayment", out value);

        foreach (var item in ClientSession.StatementIDandBalance)
        {
            var values = item.Split('-');
            if (Convert.ToDecimal(value) <= Convert.ToDecimal(values[1]))
            {
                var balance = string.Format("{0:c}", Convert.ToDecimal(values[1]));
                cmbApplyPaymentTo.Items.Add(new RadComboBoxItem { Text = "#" + values[0] + " - " + balance, Value = values[0] });
            }
        }

        cmbApplyPaymentTo.SelectedIndex = 0; // for selecting the first row.
    }


    private void BindFundingSource()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@UserID", ClientSession.UserID } };
        var paymentMethods = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);

        ViewState["PaymentMethod"] = paymentMethods;
        cmbFundingSource.DataSource = paymentMethods;
        cmbFundingSource.DataBind();
        // for selecting the first row.
        cmbFundingSource.SelectedIndex = 0;
        // Bind Down Payment Combobox
        cmbDownPayment.DataSource = paymentMethods;
        cmbDownPayment.DataBind();
        // for selecting the first row.
        cmbDownPayment.SelectedIndex = 0;

        // Displaying message in case of credit card
        ShowCreditCardMessage();
    }

    protected void cmbFundingSource_OnChanged(object sender, EventArgs e)
    {
        ShowCreditCardMessage();
    }

    private void ShowCreditCardMessage()
    {
        var paymentMethods = ViewState["PaymentMethod"] as DataTable;
        var row = paymentMethods.AsEnumerable().Single(x => x["PaymentCardID"].ToString() == cmbFundingSource.SelectedValue);

        if (row["FlagShowCreditSurcharge"].ParseBool())
        {
            var savedData = GetSavedData();
            if (savedData.ContainsKey("LenderID"))
            {
                var lenderID = int.Parse(savedData["LenderID"].ToString());
                divCardMessage.Visible = lenderID > 0;
            }
        }
        else
        {
            divCardMessage.Visible = false;
        }
    }


    private void BindRegularACHPayments()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@PatientID", ClientSession.SelectedPatientID },
            { "@FlagBankOnly", 1 },
            { "@UserID", ClientSession.UserID}
        };
        var linkedBankAccounts = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        cmbRegularACHPayments.DataSource = linkedBankAccounts;
        cmbRegularACHPayments.DataBind();
        // for selecting the first row.
        cmbRegularACHPayments.SelectedIndex = 0;
    }

    private void GetBlueCreditInformation()
    {
        var values = ClientSession.ObjectValue as Dictionary<string, object>;

        object minPayment, PlanType;
        values.TryGetValue("MinimumPayment", out minPayment);
        values.TryGetValue("PlanType", out PlanType);
        lblPlanType.Text = Convert.ToString(PlanType);
        lblMinPayment.Text = string.Format("{0:c}", Convert.ToDecimal(minPayment));
        txtRegularPayment.Text = Convert.ToString(minPayment);

        var isNewBlueCreditPlan = ViewState["IsNewBluecreditPlan"].ParseBool();
        if (!isNewBlueCreditPlan)
        {
            divCurrentBalance.Visible = true;
            lblCurrentBalanace.Text = values["CurrentBalance"].ToString();
            lblFinancedAmountLabel.Text = "Additional Financing";
        }

    }

    protected void ShowRemainingPayments()
    {
        var values = GetSavedData();
        object downPayment;
        object minPayment;
        object financedAmount;
        object existingStatementBalance;
        object cycle;
        object ratePromo;
        object termPromo;
        object rateStd;
        object termMax;
        object isNewBluecreditPlan;


        //values.TryGetValue("StatementBalance", out value);
        //lblBalance.Text = value.ToString();

        values.TryGetValue("DownPayment", out downPayment);
        lblDownpay.Text = string.Format("{0:c}", Convert.ToDecimal(downPayment));
        ViewState["DownPayment"] = downPayment;
        
        values.TryGetValue("MinimumPayment", out minPayment);

        values.TryGetValue("FinancedAmount", out financedAmount);
        values.TryGetValue("ExistingBCStatementBal", out existingStatementBalance);
        lblFinancedAmount.Text = string.Format("{0:c}", Convert.ToDecimal(financedAmount));

        // Binding the minimum and the maximum values for the Slider
        sldRegularPayment.Value = Convert.ToDecimal(minPayment);
        sldRegularPayment.SmallChange = 5;
        sldRegularPayment.LargeChange = 25;
        sldRegularPayment.MinimumValue = Convert.ToDecimal(minPayment);
        sldRegularPayment.MaximumValue = Convert.ToDecimal(financedAmount) + Convert.ToDecimal(existingStatementBalance);

        values.TryGetValue("Cycle", out cycle);
        values.TryGetValue("RatePromo", out ratePromo);
        values.TryGetValue("TermPromo", out termPromo);
        values.TryGetValue("RateStd", out rateStd);
        values.TryGetValue("TermMax", out termMax);

        // Saving for further use
        values.TryGetValue("IsNewBluecreditPlan", out isNewBluecreditPlan);
        ViewState["IsNewBluecreditPlan"] = isNewBluecreditPlan;

        lblOrignalAmount.Text = string.Format("{0:c}", decimal.Parse(financedAmount.ToString()) + decimal.Parse(downPayment.ToString()));

        // For javascript use
        hdnValues.Value = string.Format("{0},{1},{2},{3},{4},{5}", financedAmount, cycle, ratePromo, termPromo, rateStd, termMax);

        lblRecurringPayment.Text = "This plan will be paid off in " + CalcRemainingPayments(Convert.ToDecimal(financedAmount), Convert.ToInt32(cycle),
                                                Convert.ToDecimal(ratePromo), Convert.ToDecimal(termPromo),
                                                Convert.ToDecimal(rateStd), Convert.ToDecimal(termMax),
                                                Convert.ToDecimal(minPayment)).ToString("") + " payments";


        // Validating the downpayment
        ValidateDownPayment(Convert.ToDecimal(downPayment));

    }

    private void ShowBillingAddressInfo()
    {

        string financialResponsibility;
        if (!Page.IsPostBack)
        {
            financialResponsibility = PatientInformation["FlagGuardianPay"].ToString();
            cmbResponsibleParty.SelectedValue = financialResponsibility;

            chkEmailBills.Checked = PatientInformation["FlagEmailBills"].ParseBool();
        }
        else
        {
            financialResponsibility = cmbResponsibleParty.SelectedValue;
        }


        string borrowerName, phone, email;
        if (financialResponsibility == ((int)FinancialResponsibility.Patient).ToString())
        {
            borrowerName = string.Format("{0} {1}", ClientSession.PatientFirstName, ClientSession.PatientLastName);
            phone = PatientInformation["PhonePri"].ToString();
            email = PatientInformation["Email"].ToString();
        }
        else
        {
            borrowerName = PatientInformation["GuardianName"].ToString();
            phone = PatientInformation["GuardianPhone"].ToString();
            email = PatientInformation["GuardianEmail"].ToString();
        }


        lblBorrowerName.Text = borrowerName;
        txtPhone.Text = phone;

        txtEmail.Text = email;
        hdnEmail.Value = email;

        ShowPatientAddress();

    }

    private decimal CalcRemainingPayments(decimal financedAmount, Int32 cycle, decimal ratePromo, decimal termPromo, decimal rateStd, decimal termMax, decimal minPayment)
    {
        decimal totalPayments = 0;
        int diffDays = 31;

        while (cycle < termPromo && financedAmount > 0)
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

    protected void cmbResponsibleParty_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        ShowBillingAddressInfo();
    }

    protected void cmbBillingAddress_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        ShowPatientAddress(false);
    }

    private void ShowPatientAddress(bool addrBasesUponResponsibleParty = true)
    {

        if (addrBasesUponResponsibleParty)
        {
            var financialResponsibility = !Page.IsPostBack ? PatientInformation["FlagGuardianPay"].ToString() : cmbResponsibleParty.SelectedValue;

            cmbBillingAddress.SelectedValue = financialResponsibility == ((int)FinancialResponsibility.Patient).ToString()
                                                  ? PatientInformation["AddrPrimaryID"].ToString()
                                                  : PatientInformation["GuardianAddrID"].ToString();
        }


        if (cmbBillingAddress.SelectedValue == ((int)AddressType.Primary).ToString())
        {
            lblPatientAddress.Text = PatientInformation["AddrPri"].ToString();
        }
        else
        {
            lblPatientAddress.Text = PatientInformation["AddrSec"].ToString();
        }

    }

    protected void btnActivate_OnClick(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        if (!ValidateIfGuardianIsValid())
            return;

        if (!IsRegularPaymentValid())
            return;

        try
        {
            object downPayment;

            var values = GetSavedData();
            values.TryGetValue("DownPayment", out downPayment);


            var cmdParams = new Dictionary<string, object>();
            int? DPTransactionID = null;
            if (Convert.ToDecimal(downPayment) > 0)
            {
                cmdParams = new Dictionary<string, object>
                {
                    { "@PatientID", ClientSession.SelectedPatientID },
                    { "@PaymentCardID", cmbDownPayment.SelectedValue },
                    { "@UserID", ClientSession.UserID}
                };
                Int32 FSPTypeID = -1;
                string PNRef = "";
                var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
                foreach (DataRow row in reader.Rows)
                {
                    FSPTypeID = Convert.ToInt32(row["FSPTypeID"]);
                    PNRef = row["PNRef"].ToString();
                }

                //FSPTypeID is returned as TransactionTypeID from SQL which matches the enum here to associate the FSP method
                switch (FSPTypeID)
                {
                    case (int)ProcessCheckCreditDebit.ProcessCreditSale:
                        var processCreditSale = new ProcessCreditSale(Convert.ToDecimal(downPayment).ToString(""), PNRef, ClientSession.SelectedPatientID, Convert.ToInt32(cmbDownPayment.SelectedValue), Convert.ToInt32(cmbApplyPaymentTo.SelectedValue), ClientSession.SelectedPatientAccountID, ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, null, (int)SourceType.PatientPortalWeb, 0, string.Empty, null, null);
                        Common.Success = processCreditSale.Success;
                        Common.ReturnTransID = processCreditSale.ReturnTransID;
                        DPTransactionID = processCreditSale.ReturnTransID;
                        break;
                    case (int)ProcessCheckCreditDebit.ProcessDebitSale:

                        break;
                    case (int)ProcessCheckCreditDebit.ProcessCheckSale:
                        var processCheckSale = new ProcessCheckSale(Convert.ToDecimal(downPayment).ToString(""), PNRef, ClientSession.SelectedPatientID, Convert.ToInt32(cmbDownPayment.SelectedValue), Convert.ToInt32(cmbApplyPaymentTo.SelectedValue), ClientSession.SelectedPatientAccountID, ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, null, (int)SourceType.PatientPortalWeb, 0, string.Empty, null, null);
                        Common.Success = processCheckSale.Success;
                        Common.ReturnTransID = processCheckSale.ReturnTransID;
                        DPTransactionID = processCheckSale.ReturnTransID;
                        break;
                }

                if (!Common.Success)
                {
                    RadWindow.RadAlert("Please update the payment method for down payment and try again. <br>Reason:" + Common.FSPMessage, 400, 100, "", "");
                    return;
                }
            }

            object creditTypeID, financedAmount, termMax, BlueCreditID, minPayments;
            values.TryGetValue("CreditTypeID", out creditTypeID);
            values.TryGetValue("FinancedAmount", out financedAmount);
            values.TryGetValue("TermMax", out termMax);
            values.TryGetValue("BlueCreditID", out BlueCreditID);
            values.TryGetValue("MinimumPayment", out minPayments);

            cmdParams = new Dictionary<string, object>
                            {
                                //UPDATE Fields
                                { "@PatientID", ClientSession.SelectedPatientID},
                                { "@BlueCreditID", Convert.ToString(BlueCreditID) == "0" ? "" : Convert.ToString(BlueCreditID)},
                                { "@CreditTypeID", Convert.ToDecimal(creditTypeID) },
                                { "@CreditStatusTypeID", 2 },
                                { "@FinancedAmount", Convert.ToDecimal(financedAmount)  }, //1-31-2016 JHV Changed @CreditLimit to @FinancedAmount. SQL Logic will determine if the value needs to be used.
                                { "@FlagGuardian", cmbResponsibleParty.SelectedValue },
                                { "@MaxCycles", Convert.ToInt32(termMax) }, 
                                { "@PhonePri", txtPhone.Text }, 
                                { "@FlagEmailBills", chkEmailBills.Checked },
                                { "@PaymentFreqTypeID", cmbBillSchedule.SelectedValue },
                                { "@PtSetRecurringMin", txtRegularPayment.Text },
                                { "@FirstBillDate", dtFirstBillDate.SelectedDate },
                                { "@DPPaymentCardID", cmbDownPayment.SelectedValue },
                                { "@DPTransactionID", DPTransactionID },
                                { "@PaymentCardID", cmbFundingSource.SelectedValue },
                                { "@PaymentCardIDSec", cmbRegularACHPayments.SelectedValue },
                                { "@Email", txtEmail.Text.Trim() },
                                { "@Notes", txtNote.Text.Trim() },
                                { "@MinPayAmount", minPayments},
                                { "@PayDay", Convert.ToDateTime(dtFirstBillDate.SelectedDate).Day },
                                { "@NextPayDate", dtFirstBillDate.SelectedDate },
                                { "@UserID", ClientSession.UserID },
                                { "@TUPFSID", values["TUPFSID"]}
                            };


            var lenderID = int.Parse(values["LenderID"].ToString());
            if (lenderID > 0)
            {
                cmdParams.Add("@LenderID", lenderID);
            }

            var blueCreditID = SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecredit_add", cmdParams);

            // For displaying the Popup to view TruthinLending and LandingAgreement
            hdnShowTruthInLending.Value = "1";
            popupMessage.VisibleOnPageLoad = true;

            // Initializing the bluecreditId and FlagGuardian in order to use later
            ClientSession.ObjectID = blueCreditID;
            ClientSession.ObjectID2 = cmbResponsibleParty.SelectedValue;
            ViewState["BluecreditID"] = blueCreditID;
            ViewState["TransactionID"] = Common.ReturnTransID;

            foreach (var statementID in ClientSession.SelectedBlueCreditStatements)
            {
                cmdParams = new Dictionary<string, object>
                            {
                                { "@BlueCreditID", blueCreditID},
                                { "@StatementID", statementID },
                                { "@DPTransactionID", Convert.ToDecimal(downPayment) > 0 && statementID == Convert.ToInt32(cmbApplyPaymentTo.SelectedValue)? Common.ReturnTransID : 0},
                                { "@DPAmount", Convert.ToDecimal(downPayment) > 0 && statementID == Convert.ToInt32(cmbApplyPaymentTo.SelectedValue)? Convert.ToDecimal(downPayment) : 0},
                                { "@UserID", ClientSession.UserID }
                                };

                SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecredit_assign", cmdParams);
            }

            // For creating the PDF of Lending Agreements and Truth In Lending
            var isNewBluecreditPlan = ViewState["IsNewBluecreditPlan"].ParseBool();
            if (isNewBluecreditPlan)
            {
                CreateTruthInLendingandLendingAgreementsPdf(Convert.ToInt32(blueCreditID), values);
            }

            popupMessage.Height = isNewBluecreditPlan ? 360 : 230;
            popupMessage.Width = isNewBluecreditPlan ? 500 : 420;
            popupMessage.Title = isNewBluecreditPlan ? "" : ""; //"BlueCredit Success" : "Assignment Success";
        }
        catch (Exception)
        {
            throw;
        }

    }

    protected void btnAssignValues_Click(object sender, EventArgs e)
    {
        ClientSession.AmountandDownpayment = decimal.Parse(ViewState["DownPayment"].ToString()) + "," + cmbDownPayment.SelectedItem.Text;
        ClientSession.ObjectType = ObjectType.Payment;
        hdnShowPopupConfirmation.Value = "1";
    }


    private void CreateTruthInLendingandLendingAgreementsPdf(Int32 bluecreditID, Dictionary<string, object> values)
    {
        var source = Path.Combine(ClientSession.FilePathBlueCredit, ClientSession.PracticeID.ToString(), ClientSession.SelectedPatientID + "\\");
        var filesNeedToBeMerge = new List<string>();

        // Checking if the source exits or not, if not then create a new directory
        if (!Directory.Exists(source)) { Directory.CreateDirectory(source); }

        // Checking if already exist or not, if not then create a new PDF
        //if (!File.Exists(source + "la_" + bluecreditID + ".pdf"))
        //{
        //    var pdfList = new[] { "bluecredit_title", "bluecredit_application", "bluecreditSummary_popup", "bluecredit_payments", "bluecredit_StandardProvisions", "bluecredit_StandardProvisions1", "bluecredit_Section4", "bluecredit_privacy", "bluecredit_privacy1", "bluecredit_approval" };

        //    foreach (var pdf in pdfList)
        //    {
        //        PDFServices.PDFCreate(pdf + ".pdf", ClientSession.WebPathRootProvider + "Terms/" + pdf + ".aspx?HideButtons=1", source);
        //    }

        //    string[] pdfpathList = { source + pdfList[0] + ".pdf", source + pdfList[1] + ".pdf", source + pdfList[2] + ".pdf", source + pdfList[3] + ".pdf", source + pdfList[4] + ".pdf", source + pdfList[5] + ".pdf", source + pdfList[6] + ".pdf", source + pdfList[7] + ".pdf", source + pdfList[8] + ".pdf", source + pdfList[9] + ".pdf" };

        //    // Merging all the created PDF files and after merging, deleting all the files which we merged
        // PDFServices.PDFMerge(pdfpathList, source, "la_" + bluecreditID + ".pdf");
        //}

        var queryStrings = string.Format("?CreatePdfWithoutSign=1&BlueCreditID={0}&PracticeID={1}", bluecreditID, ClientSession.PracticeID);

        var tempFileName = Guid.NewGuid() + ".pdf";

        var fileNameLa = "la_" + bluecreditID + ".pdf";
        if (!File.Exists(source + fileNameLa))
        {
            filesNeedToBeMerge.Add(source + tempFileName);

            var addtionalParams = string.Format("&PatientId={0}&FlagGuardian={1}", ClientSession.SelectedPatientID, ClientSession.ObjectID2);
            PDFServices.PDFCreate(tempFileName, ClientSession.WebPathRootProvider + "report/bluecreditApplication_popup.aspx" + queryStrings + addtionalParams, source);

            // Copying PDF
            tempFileName = Guid.NewGuid() + ".pdf";
            filesNeedToBeMerge.Add(source + tempFileName);

            var extraFileName = values["AgreementPDFFile"].ToString();
            extraFileName = Server.MapPath("~/Terms/BlueCredit/" + extraFileName);
            File.Copy(extraFileName, source + tempFileName);

            // Adding sign
            tempFileName = Guid.NewGuid() + ".pdf";
            filesNeedToBeMerge.Add(source + tempFileName);
            PDFServices.PDFCreate(tempFileName, ClientSession.WebPathRootProvider + "report/client_sign_popup.aspx" + queryStrings, source);

            // Adding privacy
            tempFileName = Guid.NewGuid() + ".pdf";
            filesNeedToBeMerge.Add(source + tempFileName);

            extraFileName = values["PrivacyPDFFile"].ToString();
            extraFileName = Server.MapPath("~/Terms/BlueCredit/" + extraFileName);
            File.Copy(extraFileName, source + tempFileName);

            // Merging PDF
            PDFServices.PDFMerge(filesNeedToBeMerge, source, fileNameLa);
        }

        filesNeedToBeMerge.Clear();

        // Checking if file exist or not, if not then create a new File
        var fileNamePn = "pn_" + bluecreditID + ".pdf";
        if (!File.Exists(source + fileNamePn))
        {
            tempFileName = Guid.NewGuid() + ".pdf";
            filesNeedToBeMerge.Add(source + tempFileName);
            PDFServices.PDFCreate(tempFileName, ClientSession.WebPathRootProvider + "report/promissoryNote_popup.aspx" + queryStrings, source);

            tempFileName = Guid.NewGuid() + ".pdf";
            filesNeedToBeMerge.Add(source + tempFileName);
            PDFServices.PDFCreate(tempFileName, ClientSession.WebPathRootProvider + "report/client_sign_popup.aspx" + queryStrings, source);

            // Merging PDF
            PDFServices.PDFMerge(filesNeedToBeMerge, source, fileNamePn);
        }

        var fileNameTil = "til_" + bluecreditID + ".pdf";
        if (!File.Exists(source + fileNameTil))
        {
            PDFServices.PDFCreate(fileNameTil, ClientSession.WebPathRootProvider + "report/truthInLending_popup.aspx" + queryStrings, source);
        }

        var cmdParams = new Dictionary<string, object>
        {
            {"@BlueCreditID", bluecreditID},
            {"@FilenameLA", fileNameLa},
            {"@FilenamePN", fileNamePn},
            {"@FilenameTIL", fileNameTil},
            {"@UserID",ClientSession.UserID},
        };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecreditsig_add", cmdParams);

    }


    protected void btnClose_OnClick(object sender, EventArgs e)
    {
        // Afer creating the TruthinLending and LendingAgreements
        hdnClosePopup.Value = "1";
    }

    protected void OnClick_AddPaymentMethod(object sender, EventArgs e)
    {
        popupManageAccounts.VisibleOnPageLoad = true;
    }

    protected void RebindFundingSource(object sender, EventArgs e)
    {
        BindFundingSource();
        BindRegularACHPayments();
    }

    private void ApplyValidations()
    {
        dtFirstBillDate.MaxDate = DateTime.Now.AddMonths(2);
        dtFirstBillDate.MinDate = DateTime.Now.AddDays(1);
        dtFirstBillDate.SelectedDate = DateTime.Now.AddMonths(1);
    }

    protected void btnUpdateValues_OnClick(object sender, EventArgs e)
    {
        // Adding necessary value into the clientsession in order to view PDF files.
        var requestedPopup = hdnRequestedPopup.Value;
        ClientSession.FilePath = requestedPopup;
        ClientSession.ObjectID = ViewState["BluecreditID"];

        var selectedHtmlImage = GetHtmlImage(requestedPopup);
        selectedHtmlImage.Src = "../Content/Images/icon_checkbox_filled.gif";
        selectedHtmlImage.Alt = "Read";

        if (requestedPopup == "sign")
        {
            ClientSession.ObjectID = ViewState["TransactionID"];
            ClientSession.ObjectType = ObjectType.PaymentReceipt;
            ClientSession.EnablePrinting = false;
            ClientSession.EnableClientSign = true;
        }

        // Enabling close button
        ValidateOpenedPopups(requestedPopup);

        popupMessage.VisibleOnPageLoad = true;
        hdnShowRequestedPopup.Value = "1";
    }

    protected void btnUpdateValuesShowPrintPopup_OnClick(object sender, EventArgs e)
    {
        ClientSession.FilePath = hdnFileName.Value;

        // FieName, PageTitle and IsRequest from Bluecredit
        ClientSession.ObjectValue = new Dictionary<string, string> { { "FileName", hdnFileName.Value }, { "PageTitle", hdnFileName.Value == "til" ? "Truth In Lending" : "Lending Agreement" }, { "IsRequestFromBlueCredit", "True" } };
        popupMessage.VisibleOnPageLoad = true;
        hdnIsShowPdfViewer.Value = "1";
    }

    protected void btnPrintReceipt_OnClick(object sender, EventArgs e)
    {
        ClientSession.ObjectID = ViewState["TransactionID"];
        ClientSession.ObjectType = ObjectType.PaymentReceipt;
        ClientSession.EnablePrinting = true;
        ClientSession.EnableClientSign = false;

        ScriptManager.RegisterStartupScript(Page, typeof(Page), "showPaymentReceipt", "showPaymentReceiptPopup()", true);
        popupMessage.VisibleOnPageLoad = true;
    }

    private System.Web.UI.HtmlControls.HtmlImage GetHtmlImage(string requestedPopup)
    {
        System.Web.UI.HtmlControls.HtmlImage htmlImage;

        switch (requestedPopup)
        {
            case "la":
                htmlImage = imgla;
                break;
            case "pn":
                htmlImage = imgpn;
                break;
            case "til":
                htmlImage = imgtil;
                break;
            case "ps":
                htmlImage = imgps;
                break;
            default:
                htmlImage = imgSign;
                break;
        }

        return htmlImage;
    }

    private void ValidateOpenedPopups(string requestedPopup)
    {
        if (ViewState["OpenedPopup"] == null)
        {
            ViewState["OpenedPopup"] = new List<string>();
        }

        var allOpenedPopups = ViewState["OpenedPopup"] as List<string>;
        allOpenedPopups.Add(requestedPopup);

        var openedPopupsCount = allOpenedPopups.Distinct().Count();

        var isNewBluecreditAccount = Convert.ToBoolean(ViewState["IsNewBluecreditPlan"]);
        var totalCount = isNewBluecreditAccount ? 3 : 1; // These are the button count placed according to the New and existing bluecredit account

        if (DownPayment > 0)
            totalCount += 1;

        if (openedPopupsCount == totalCount)
        {
            hdnEnableCloseButton.Value = "1";
        }

    }


    private void ValidateDownPayment(decimal downpayment)
    {
        if (downpayment <= 0)
        {
            cmbDownPayment.ClearSelection();
            cmbApplyPaymentTo.ClearSelection();
            cmbDownPayment.Enabled = false;
            cmbApplyPaymentTo.Enabled = false;
            rqdDownPayment.Enabled = false;
            rqdApplyPayment.Enabled = false;
        }
    }

    private bool IsRegularPaymentValid()
    {
        var regularPayment = Convert.ToDecimal(txtRegularPayment.Text);
        var values = GetSavedData();

        var minpayment = Convert.ToDecimal(values["MinimumPayment"]);
        var financedAmount = Convert.ToDecimal(values["FinancedAmount"]);
        var balance = decimal.Parse(values["CurrentBalance"].ToString(), NumberStyles.Currency);
        financedAmount += balance;

        var isValid = regularPayment >= minpayment && regularPayment <= financedAmount;
        cstmValidateRegularPayment.IsValid = isValid;

        return isValid;
    }

    private bool ValidateIfGuardianIsValid()
    {
        var isNewBluecreditPlan = ViewState["IsNewBluecreditPlan"].ParseBool();
        if (!isNewBluecreditPlan) return true;

        if (cmbResponsibleParty.SelectedValue == ((int)FinancialResponsibility.Guardian).ToString())
        {
            var cmdParams = new Dictionary<string, object>()
            {
                {"@PracticeID", ClientSession.PracticeID},
                {"@PatientID", ClientSession.SelectedPatientID},
                {"@FlagGuardian", 1},
                {"@UserID", ClientSession.UserID}
            };

            var info = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecreditcheck_get", cmdParams);

            var hasError = info.Rows[0]["FlagMustFix"].ParseBool();
            if (!hasError) return true;

            RadWindow.RadAlert("BlueCredit may not be assigned to a guardian without a valid social security number, positive identification, and credit check on file. <br><br>Please assign the credit account to the patient or correct this information for the guardian before continuing.", 400, 100, "", "", "../Content/Images/warning.png");
            return false;
        }

        return true;
    }

    private Dictionary<string, object> GetSavedData()
    {
        return ViewState["ObjectValue"] as Dictionary<string, object>;
    }

}