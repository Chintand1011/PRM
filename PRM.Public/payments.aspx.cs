using System;
using System.Collections.Generic;
using System.IO;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;
using System.Data;


public partial class payments_statement : BasePage
{
    public string ReceiptMessage { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            cmbPaymentMethods.DataSource = GetPaymentMethods();
            cmbPaymentMethods.DataBind();

            // Hide show the payment methods dropdown if there is no any payment method
            var paymentMethodsCount = Convert.ToInt32(hdnPaymentMethodsCount.Value);
            if (paymentMethodsCount == 0)
                ValidatePaymentMethod();
        }

        // Preventing the popups to open on page load
        popupConfirmationPayment.VisibleOnPageLoad = false;
        popupPaymentReceipt.VisibleOnPageLoad = false;
        popupManageAccounts.VisibleOnPageLoad = false;
        popupPaymentPlan.VisibleOnPageLoad = false;
        popupEditBlueCredit.VisibleOnPageLoad = false;
    }

    protected void Page_LoadComplete(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            var rowCount = grdPendingPayments.Items.Count;
            divPendingPaymentsGrid.Visible = rowCount > 0;
        }
    }

    #region Grid Operations

    private DataTable GetActiveMakePayments()
    {
        var cmdParams = new Dictionary<string, object> { { "@AccountID", ClientSession.AccountID }, { "@flagcurrent", "1" }, { "@flagbalance", "1" } };
        var activeMakePayments = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
        hdnActiveMakePaymentsRows.Value = activeMakePayments.Rows.Count.ToString("");
        ViewState["ActivePaymentsRowCount"] = activeMakePayments.Rows.Count;
        return activeMakePayments;
    }

    private DataTable GetPaymentMethods()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID } };
        var paymentMethods = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        hdnPaymentMethodsCount.Value = paymentMethods.Rows.Count.ToString("");
        return paymentMethods;
    }

    private DataTable GetPendingPayments()
    {
        var cmdParams = new Dictionary<string, object> { { "@AccountID", ClientSession.AccountID }, { "@MaxDays", 93 } };

        return SqlHelper.ExecuteDataTableProcedureParams("svc_pending_payments", cmdParams);
    }

    protected void grdPendingPayments_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdPendingPayments.DataSource = GetPendingPayments();
    }

    private DataTable GetPaymentHistory()
    {
        var cmdParams = new Dictionary<string, object> { { "@FlagOnlyCharges", 1 }, { "@FlagOnlySuccess", 1 }, { "@AccountID", ClientSession.AccountID }, { "@DateMin", DateTime.Now.AddDays(-93) } };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_transaction_get", cmdParams);
    }

    protected void grdPaymentHistory_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdPaymentHistory.DataSource = GetPaymentHistory();
    }

    protected void grdPaymentHistory_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var isFlagReceipt = Convert.ToInt32(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagReceipt"]);
            // enabling the column if its not equals to 0
            item["Receipt"].Enabled = isFlagReceipt != 0;
            (item["Receipt"].Controls[0] as ImageButton).ImageUrl = isFlagReceipt != 0
                                                                        ? "~/Content/Images/icon_view.png"
                                                                        : "~/Content/Images/spacer.gif";

        }
    }

    protected void grdPendingPayments_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            // Displaying the Bluecredit_Edit popup for edit.
            case "EditPayment":

                var blueCreditID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["BlueCreditID"].ToString();

                if (blueCreditID != "")
                {
                    ClientSession.ObjectID = Convert.ToInt32(blueCreditID);
                    ClientSession.ObjectType = ObjectType.BlueCredit;
                    popupEditBlueCredit.VisibleOnPageLoad = true;
                }
                else
                {
                    // Displaying the PaymentPlan popup
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
                popupPaymentReceipt.VisibleOnPageLoad = true;
                break;
        }
    }

    #endregion

    #region Make a Payment



    protected void grdMakePayments_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdMakePayments.DataSource = GetActiveMakePayments();

        // Manage the payment section
        var count = Convert.ToInt32(ViewState["ActivePaymentsRowCount"]);
        hdnGridRowsCount.Value = count.ToString();
        divPaymentMethods.Visible = count > 0;
    }



    protected void grdMakePayments_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var count = Convert.ToInt32(hdnActiveMakePaymentsRows.Value);
            if (count == 1)
            {
                // checking if Grid has only one row
                hdnGridRowsCount.Value = "1";
                var amount = (RadNumericTextBox)item.FindControl("txtAmount");//accessing Label
                amount.AutoPostBack = false;
            }

            var txtAmount = item.FindControl("txtAmount") as RadNumericTextBox;
            var flagAcceptPtPay = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagAcceptPtPay"]);
            if (!flagAcceptPtPay)
            {
                txtAmount.Enabled = false;
            }


            // Displaying Auto Pay Image
            var imgAutoPay = item.FindControl("imgAutoPay") as Image;
            var flagAutoPay = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagAutoPay"]);
            imgAutoPay.ImageUrl = flagAutoPay ? "~/Content/Images/icon_yes.png" : "~/Content/Images/icon_dash.png";

        }
    }


    protected void grdMakePayments_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Download":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString();
                var filePathUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FilePathStatements"].ToString();
                var fileName = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FileName"].ToString();
                ViewState["FilePath"] = Path.Combine(filePathUrl, fileName);
                hdnDownload.Value = "true";
                break;
        }
    }


    protected void btnConfirmPayment_OnClick(object sender, EventArgs e)
    {
        // Displaying the Confirmation popup.
        ClientSession.AmountandDownpayment = txtTotalAmount.Text + "," + cmbPaymentMethods.SelectedItem.Text;
        ClientSession.ObjectType = ObjectType.Payment;
        popupConfirmationPayment.VisibleOnPageLoad = true;
    }

    protected void btnYes_Click(object sender, EventArgs e)
    {
        try
        {
            var isPaymentSucceeded = true;
            var message = "";

            foreach (GridDataItem item in grdMakePayments.MasterTableView.Items)
            {
                var amount = (item.FindControl("txtAmount") as RadNumericTextBox).Text.TryParseDecimal();
                if (amount <= 0)
                    continue;


                var statementID = Convert.ToInt32(item.GetDataKeyValue("StatementID"));
                var balance = item.GetDataKeyValue("Balance").ToString().TryParseDecimal();
                // Double checking the amount should be greater than 0, else showing the error to the user
                if (amount <= balance)
                {
                    ProcessPayment(statementID, amount); //Processing Payment with selected Payment Method.
                    var emailcode = EmailServices.SendPaymentReceiptbyID(Common.ReturnTransID, ClientSession.UserID);
                    if (emailcode != (int)EmailCode.Succcess)
                    {
                        switch (emailcode)
                        {
                            case (int)EmailCode.BouncedMail:
                                message = "We also attempted to send an email receipt but it was returned as undeliverable. Please update your email address for future receipts.";
                                break;
                            case (int)EmailCode.EmptyEmail:
                                message = "Did you know? By adding your email address we will automatically send you a copy of your payment receipt.";
                                break;
                            case (int)EmailCode.InvalidEmailAddress:
                                message = "We also attempted to send an email, but it doesn't appear to be a valid address. Please update your email address for future receipts.";
                                break;
                            default:
                                message = "We also attempted to send an email receipt, but a delivery error occurred. Support has been notified and will correct this for the future.";
                                break;
                        }
                        RadWindowManager.RadAlert(message, 500, 150, "", "closeRefresh");
                        return;
                    }
                }
                else
                {
                    RadWindowManager.RadAlert("Your entered Amount should less than or equals to balance.", 400, 100, "", "closeRefresh", "../Content/Images/warning.png");
                    return;
                }


                if (!Common.Success)
                {
                    isPaymentSucceeded = Common.Success;
                }


            }

            ClientSession.ObjectID = isPaymentSucceeded ? Common.ReturnTransID : 0;
            ClientSession.ObjectType = isPaymentSucceeded ? ObjectType.PaymentReceipt : new ObjectType();
            ClientSession.EnablePrinting = false;


            // Displaying the message according to the results.
            if (isPaymentSucceeded)
            {
                RadWindowManager.RadConfirm("<p>Thank you, your payment has been received. <br>A copy of your receipt was also sent by email.</p>", "showPaymentPopup", 450, 150, null, "", "Content/Images/success.png");
            }
            else
            {
                RadWindowManager.RadAlert("<p>There was a problem with your payment. <br>If you have changed your billing address, or been issued a replacement card, you may need to update your payment method. Thank you.</p>", 450, 150, "", "closeRefresh", "Content/Images/warning.png");
            }

        }
        catch (Exception ex)
        {
            RadWindowManager.RadAlert(string.Format("<p>{0}</p>", ex.Message), 400, 150, "", "closeRefresh");
        }
    }



    protected void btnDownload_Click(object sender, EventArgs e)
    {
        var path = ViewState["FilePath"].ToString();
        var returnmsg = PDFServices.FileDownload(path, "Payment.pdf");
        if (returnmsg != "")
        {
            path = Path.GetDirectoryName(path);
            var url = ClientSession.WebPathRootPatient + "report/estimateview_popup.aspx?StatementID=" + ClientSession.ObjectID;
            PDFServices.PDFCreate("PaymentReceipt.pdf", url, path);
            PDFServices.DownloadandDeleteFile(path, "PaymentReceipt.pdf");

            //PopupSubmitThanks.VisibleOnPageLoad = true;
            //lblSubmitThanks.Text = "File not available at this moment, please try again later.";
        }
    }

    protected void btnAddNewPaymentMethod_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/bankinfo.aspx");
    }

    private void ProcessPayment(Int32 statementID, decimal amount)
    {
        // Getting neccessary values from web_pr_paymentcard_get proc
        var paymentMethods = GetPaymentMethods();
        var selectedPaymentMethod = paymentMethods.Select("PaymentCardID=" + cmbPaymentMethods.SelectedValue);
        var FSPTypeID = Convert.ToInt32(selectedPaymentMethod[0]["FSPTypeID"]);
        var pnRef = selectedPaymentMethod[0]["PNRef"].ToString();

        switch (FSPTypeID)
        {
            case (int)ProcessCheckCreditDebit.ProcessCreditSale:

                var processCreditSale = new ProcessCreditSale(amount.ToString(""), pnRef, ClientSession.PatientID, Convert.ToInt32(cmbPaymentMethods.SelectedValue), statementID, ClientSession.AccountID, ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, null, (int)SourceType.PatientPortalPublic, 0, string.Empty, null, null);
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
                var processCheckSale = new ProcessCheckSale(amount.ToString(""), pnRef, ClientSession.PatientID, Convert.ToInt32(cmbPaymentMethods.SelectedValue), statementID, ClientSession.AccountID, ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, null, (int)SourceType.PatientPortalPublic, 0, string.Empty, null, null);
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
        btnConfirmPayment.ImageUrl = isEnable ? "Content/Images/btn_confirmpay_orange.gif" : "Content/Images/btn_confirmpay_orange_fade.gif";
    }

    #endregion


}