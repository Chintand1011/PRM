using System;
using System.Collections.Generic;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;
using System.Data;


public partial class payments_statement : BasePage
{
    public string ReceiptMessage { get; set; }
    public string Margin { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            cmbPaymentMethods.DataSource = GetPaymentMethods();
            cmbPaymentMethods.DataBind();

            // Hide show the payment methods dropdown
            var paymentMethodsCount = Convert.ToInt32(hdnPaymentMethodsCount.Value);
            if (paymentMethodsCount == 0)
                ValidatePaymentMethod();
        }

        popupPaymentReceipt.VisibleOnPageLoad = false;
        popupPaymentPlan.VisibleOnPageLoad = false;
        popupEditBlueCredit.VisibleOnPageLoad = false;
        popupConfirmationPayment.VisibleOnPageLoad = false;
        popupEstimateView.VisibleOnPageLoad = false;
        Margin = "135px;";
    }

    #region Grid Operations

    private DataTable GetActiveMakePayments()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@flagcurrent", "1" }, { "@flagbalance", "1" }, { "@UserID", ClientSession.UserID } };
        var statements = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
        ViewState["StatementsCount"] = statements.Rows.Count;
        return statements;
    }

    private DataTable GetPaymentMethods()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@UserID", ClientSession.UserID } };
        var paymentMethods = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        hdnPaymentMethodsCount.Value = paymentMethods.Rows.Count.ToString("");
        return paymentMethods;
    }

    private DataTable GetPendingPayments()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@MaxDays", 93 } };

        return SqlHelper.ExecuteDataTableProcedureParams("svc_pending_payments", cmdParams);
    }

    protected void grdPendingPayments_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdPendingPayments.DataSource = GetPendingPayments();
    }

    private DataTable GetPaymentHistory()
    {
        var cmdParams = new Dictionary<string, object> { { "@FlagOnlyCharges", 1 }, { "@FlagOnlySuccess", 1 }, { "@PatientID", ClientSession.SelectedPatientID }, { "@DateMin", DateTime.Now.AddDays(-93) }, { "@UserID", ClientSession.UserID } };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_transaction_get", cmdParams);
    }

    protected void grdPaymentHistory_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdPaymentHistory.DataSource = GetPaymentHistory();
    }


    protected void grdPendingPayments_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "EditPayment":

                var blueCreditID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["BlueCreditID"].ToString();

                if (blueCreditID != "")
                {
                    ClientSession.ObjectID = Convert.ToInt32(blueCreditID);
                    ClientSession.ObjectType = ObjectType.BlueCreditDetail;
                    popupEditBlueCredit.VisibleOnPageLoad = true;
                }
                else
                {
                    ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                    ClientSession.ObjectID2 = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentPlanID"];
                    ClientSession.ObjectValue = (decimal)e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["Balance"];
                    ClientSession.ObjectType = ObjectType.EditPaymentPlan;
                    popupPaymentPlan.VisibleOnPageLoad = true;
                }

                break;
        }
    }

    protected void grdPaymentHistory_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Receipt":
                var transactionID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["TransactionID"];
                ClientSession.ObjectID = transactionID;
                ClientSession.ObjectType = ObjectType.PaymentReceipt;
                ClientSession.EnablePrinting = false;
                ClientSession.EnableClientSign = false;
                popupPaymentReceipt.VisibleOnPageLoad = true;
                break;
        }
    }

    #endregion

    #region Make a Payment

    protected void grdMakePayments_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdMakePayments.DataSource = GetActiveMakePayments();

        var count = Convert.ToInt32(ViewState["StatementsCount"]);
        if (count > 0)
            divPaymentMethods.Visible = true;

    }

    protected void grdMakePayments_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Download":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString();
                var filePathUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FilePathStatements"].ToString();
                var fileName = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FileName"].ToString();
                var filePath = Path.Combine(filePathUrl, fileName);
                ViewState["FilePath"] = filePath;
                hdnDownload.Value = "true";
                break;

            case "View":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectType = ObjectType.Statement;
                popupEstimateView.VisibleOnPageLoad = true;
                break;
        }
    }

    protected void grdMakePayments_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var txtAmount = item.FindControl("txtAmount") as RadNumericTextBox;
            var flagAcceptPtPay = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagAcceptPtPay"]);
            if (!flagAcceptPtPay)
            {
                txtAmount.Enabled = false;
            }


            // Displaying Auto Pay Image
            var imgAutoPay = item.FindControl("imgAutoPay") as Image;
            var flagAutoPay = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagAutoPay"]);
            imgAutoPay.ImageUrl = flagAutoPay ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";


        }
    }

    protected void cmbPaymentMethods_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        ValidatePaymentMethod(true);
    }


    protected void btnConfirmPayment_OnClick(object sender, EventArgs e)
    {
        ClientSession.AmountandDownpayment = txtTotalAmount.Text + "," + cmbPaymentMethods.SelectedItem.Text;
        ClientSession.ObjectType = ObjectType.Payment;
        popupConfirmationPayment.VisibleOnPageLoad = true;
    }


    protected void btnYes_Click(object sender, EventArgs e)
    {
        try
        {
            var emailMessage = "";
            foreach (GridDataItem item in grdMakePayments.MasterTableView.Items)
            {
                var amount = (item.FindControl("txtAmount") as RadNumericTextBox).Text.ParseDecimal();
                if (amount <= 0)
                    continue;

                var statementID = Convert.ToInt32(item.GetDataKeyValue("StatementID"));
                var balance = item.GetDataKeyValue("Balance").ToString().ParseDecimal();

                if (amount <= balance)
                {
                    ProcessPayment(statementID, amount); //Processing Payment with selected Payment Method.
                    if (Common.Success)
                    {
                        ClientSession.ObjectID = Common.ReturnTransID;
                        ClientSession.ObjectType = ObjectType.PaymentReceipt;

                        var emailcode = EmailServices.SendPaymentReceiptbyID(Common.ReturnTransID, ClientSession.UserID);
                        if (emailcode != (int)EmailCode.Succcess)
                        {
                            switch (emailcode)
                            {
                                case (int)EmailCode.BouncedMail:
                                    emailMessage = "Please Note: An email receipt was attempted but the address was returned as undeliverable. Update the patient email on file.";
                                    break;
                                case (int)EmailCode.EmptyEmail:
                                    emailMessage = "Please Note: There is no email address on file for this patient. Add an email to enable electronic receipt copies.";
                                    break;
                                case (int)EmailCode.InvalidEmailAddress:
                                    emailMessage = "Please Note: An email receipt was attempted but the address does not appear to be valid. Update the patient email on file.";
                                    break;
                                default:
                                    emailMessage = "Please Note: An email receipt was attempted but a delivery error occurred. Support has been notified. Do not re-attempt this transaction.";
                                    break;
                            }

                            break;
                        }

                    }

                }
                else
                {
                    Margin = "80px;";
                    RadWindow.RadAlert("Your entered Amount should less than or equals to balance.", 400, 150, "", "refreshPage", "../Content/Images/warning.png");
                    return;
                }

            }
            if (Common.Success)
            {
                Margin = "75px;";
                ManageReceiptPopup(emailMessage);
            }
            else
            {
                var message = string.Format("Payment attempt was unsuccessful.<br/>Reason: {0}<br/><br/>Verify details or try a different card.", Common.FSPMessage);
                RadWindow.RadAlert(message, 500, 150, "", "refreshPage", "../Content/Images/warning.png");
                ClientSession.EnablePrinting = false;
            }

        }
        catch (Exception)
        {

            throw;
        }
    }

    protected void btnDownload_Click(object sender, EventArgs e)
    {
        var path = ViewState["FilePath"].ToString();
        var returnmsg = PDFServices.FileDownload(path, "Payment.pdf");
        if (returnmsg != "")
        {
            path = Path.GetDirectoryName(path);
            var url = ClientSession.WebPathRootProvider + "report/estimateview_popup.aspx?StatementID=" + ClientSession.ObjectID;
            PDFServices.PDFCreate("PaymentReceipt.pdf", url, path);
            PDFServices.DownloadandDeleteFile(path, "PaymentReceipt.pdf");
        }
    }




    private void ProcessPayment(Int32 statementID, decimal amount)
    {
        var paymentMethods = GetPaymentMethods();
        var selectedPaymentMethod = paymentMethods.Select("PaymentCardID=" + cmbPaymentMethods.SelectedValue);
        var FSPTypeID = Convert.ToInt32(selectedPaymentMethod[0]["FSPTypeID"]);
        var pnRef = selectedPaymentMethod[0]["PNRef"].ToString();

        //FSPTypeID is returned as TransactionTypeID from SQL which matches the enum here to associate the FSP method
        switch (FSPTypeID)
        {
            case (int)ProcessCheckCreditDebit.ProcessCreditSale:
                //hardeep update 0 with statementid, update ipAddress
                var processCreditSale = new ProcessCreditSale(amount.ToString(), pnRef, ClientSession.SelectedPatientID, Convert.ToInt32(cmbPaymentMethods.SelectedValue), statementID, ClientSession.SelectedPatientAccountID, ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, null, (int)SourceType.PatientPortalWeb, 0, string.Empty, null, null);
                Common.FSPTypeID = (int)ProcessCheckCreditDebit.ProcessCreditSale;
                Common.Success = processCreditSale.Success;
                Common.FSPStatusID = processCreditSale.FSPStatusID;
                Common.FSPMessage = processCreditSale.FSPMessage;
                Common.FSPPNRef = processCreditSale.FS_PNRef;
                Common.FSPAuthRef = processCreditSale.FSPAuthRef;
                Common.ReturnTransID = processCreditSale.ReturnTransID;
                break;
            case (int)ProcessCheckCreditDebit.ProcessDebitSale:

                break;
            case (int)ProcessCheckCreditDebit.ProcessCheckSale:
                //hardeep update 0 with statementid, update ipAddress
                var processCheckSale = new ProcessCheckSale(amount.ToString(), pnRef, ClientSession.SelectedPatientID, Convert.ToInt32(cmbPaymentMethods.SelectedValue), statementID, ClientSession.SelectedPatientAccountID, ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, null, (int)SourceType.PatientPortalWeb, 0, string.Empty, null, null);
                Common.FSPTypeID = (int)ProcessCheckCreditDebit.ProcessCheckSale;
                Common.Success = processCheckSale.Success;
                Common.FSPStatusID = processCheckSale.FSPStatusID;
                Common.FSPMessage = processCheckSale.FSPMessage;
                Common.FSPPNRef = processCheckSale.FS_PNRef;
                Common.FSPAuthRef = null;
                Common.ReturnTransID = processCheckSale.ReturnTransID;
                break;
        }

    }

    private void ValidatePaymentMethod(bool isEnable = false)
    {
        cmbPaymentMethods.Visible = isEnable;
        btnConfirmPayment.Enabled = isEnable;
        btnConfirmPayment.ImageUrl = isEnable ? "../Content/Images/btn_confirmpay_orange.gif" : "../Content/Images/btn_confirmpay_orange_fade.gif";
    }

    protected void btnSignature_Click(object sender, EventArgs e)
    {
        ClientSession.EnablePrinting = false;
        ClientSession.EnableClientSign = true;
        hdnIsReceipt.Value = "0";
        ScriptManager.RegisterStartupScript(Page, typeof(Page), "showPaymentReceiptByOption", "showPaymentReceiptByOption()", true);
    }

    private void ManageReceiptPopup(string emailMessage)
    {
        var isPrintReceipt = ClientSession.FlagPrintPayReceipts;
        var isSignCapture = ClientSession.FlagSigCaptureReceipts;

        var bothOptionsUnSelected = !isPrintReceipt && !isSignCapture;
        if (bothOptionsUnSelected)
        {
            hdnIsReceipt.Value = "1";
            ClientSession.EnablePrinting = true;

            if (string.IsNullOrEmpty(emailMessage))
            {
                RadWindow.RadConfirm(GetSuccessMessage(null), "reloadPage", 450, 150, null, "", "../Content/Images/Success.png");
            }
            else
            {
                RadWindow.RadConfirm(GetSuccessMessage(emailMessage), "reloadPage", 500, 150, null, "", "../Content/Images/Success.png");
            }
            
        }
        else if (isSignCapture)
        {
            hdnIsReceipt.Value = "0";
            ClientSession.EnablePrinting = false;
            ClientSession.EnableClientSign = true;
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "showPaymentReceiptByOption", "showPaymentReceiptByOption()", true);
        }
        else
        {
            hdnIsReceipt.Value = "2";
            ClientSession.EnablePrinting = true;
            ClientSession.EnableClientSign = false;
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "showPaymentReceiptByOption", "showPaymentReceiptByOption()", true);
        }

        if (!string.IsNullOrEmpty(emailMessage) && !bothOptionsUnSelected)
        {
            RadWindow.RadAlert(GetSuccessMessage(emailMessage), 500, 150, "", "showPaymentReceiptByOption", "../Content/Images/Success.png");
        }

    }

    private static string GetSuccessMessage(string emailMessage)
    {
        var message = string.Format("<p>Payment is confirmed. <br /> Response: {0} ({1})</p>", Common.FSPMessage, Common.FSPAuthRef);
        if (!string.IsNullOrEmpty(emailMessage))
        {
            message += "<p>" + emailMessage + "</p>";
        }
        
        return message;
    }

    #endregion

}