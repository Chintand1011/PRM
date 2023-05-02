using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class modifyTransaction_popup : BasePage
{


    #region Iplexus Properties

    public string InvoiceID { get; set; }
    public string PNRef { get; set; }
    public int PatientID { get; set; }
    public int PaymentCardID { get; set; }
    public int StatementID { get; set; }
    public int AccountID { get; set; }

    public string Style { get; set; }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // for closing the popup in case of any error
            ClientSession.WasRequestFromPopup = true;

            try
            {
                // Creating an object for furthur use.
                ClientSession.ListofObject = new ArrayList();

                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.Transaction)
                {
                    BindReasonDropDown();
                    GetSelectedTransactionInformation();
                }

            }
            catch (Exception)
            {

                throw;
            }
        }
        
    }

    private void BindReasonDropDown()
    {
        var reasons = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transreasontype_list",
                                                                new Dictionary<string, object>());
        cmbReasonType.DataSource = reasons;
        cmbReasonType.DataBind();
    }

    private void GetSelectedTransactionInformation()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@TransactionID", ClientSession.ObjectID},
                                {"@UserID", ClientSession.UserID}
                            };

        var dataTable = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transaction_get", cmdParams);
        lblTransactionID.Text = dataTable.Rows[0]["TransactionID"].ToString();
        lblbTitlePatient.Text = dataTable.Rows[0]["PatientName"].ToString();
        lblTitleDOB.Text = dataTable.Rows[0]["DateofBirth"].ToString();
        lblTitleProvider.Text = dataTable.Rows[0]["ProviderName"].ToString();
        lblStatementID.Text = dataTable.Rows[0]["StatementID"].ToString();
        lblStatementType.Text = dataTable.Rows[0]["CreditStatusTypeAbbr"].ToString();
        lblTransactionDate.Text = dataTable.Rows[0]["TransactionDate"].ToString();
        lblTransactionType.Text = dataTable.Rows[0]["TransactionTypeAbbr"].ToString();
        lblTransactionStatus.Text = dataTable.Rows[0]["TransStateTypeAbbr"].ToString();
        lblPaymentCardType.Text = dataTable.Rows[0]["PaymentCardTypeAbbr"].ToString();
        lblCardLast4.Text = dataTable.Rows[0]["CardLast4"].ToString();
        lblAmount.Text = dataTable.Rows[0]["Amount$"].ToString();
        lblBalance.Text = dataTable.Rows[0]["Balance$"].ToString();
        lblMessage.Text = dataTable.Rows[0]["FSPMessage"].ToString();
        txtUpdateNotes.Text = dataTable.Rows[0]["Notes"].ToString();
        lblTroubleShooting.Text = dataTable.Rows[0]["ModifyTypeAbbr"].ToString();
        hdnTransactionTypeID.Value = dataTable.Rows[0]["TransactionTypeID"].ToString();
        hdnModifyTransTypeID.Value = dataTable.Rows[0]["ModifyTransTypeID"].ToString();
        hdnAmount.Value = dataTable.Rows[0]["Amount"].ToString();
        spanFormatedAmount.InnerText = dataTable.Rows[0]["MaxRefundAmountAbbr"].ToString();
        hdnMaxRefundAmount.Value = dataTable.Rows[0]["MaxRefundAmount"].ToString();
        hdnPaymentPlanID.Value = dataTable.Rows[0]["PaymentPlanID"].ToString();
        hdnBlueCreditID.Value = dataTable.Rows[0]["BlueCreditID"].ToString();

        var modifyTransTypeID = Convert.ToInt32(hdnModifyTransTypeID.Value);

        // Validations
        txtAmount.MinValue = 0.01;
        txtAmount.MaxValue = double.Parse(hdnMaxRefundAmount.Value);

        // if modifyTransTypeID is equal to ProcessCreditVoid or ProcessCheckVoid then initializing the RefundAmount with "Amount" Field being returned by web_pr_transaction_get proc
        if (modifyTransTypeID == (int)ModifyTransType.ProcessCreditVoid || modifyTransTypeID == (int)ModifyTransType.ProcessCheckVoid)
        {
            txtAmount.Text = hdnAmount.Value;
            txtAmount.Enabled = false;
        }

        // If modifyTransTypeID greater than 100 then showing the Delete Button and initializing the RefundAmount with "Amount" Field being returned by web_pr_transaction_get proc
        if (modifyTransTypeID > 100)
        {
            lblUpdatedAmount.Text = "Amount:";
            txtAmount.Text = dataTable.Rows[0]["Amount"].ToString();
            ViewState["FlagCancelTransaction"] = true;

            spanAmountContainer.Visible = false;
            pTransactionMessage.Visible = true;
        }

        // if modifyTransTypeID is not equal to ProcessCheckCharge and also not equal to ProcessDebitCharge and also not equal to ProcessCreditCharge 
        //then initializing the RefundAmount with "Amount" Field and disabling the amount textbox
        if (modifyTransTypeID != (int)ModifyTransType.ProcessCheckCharge && modifyTransTypeID != (int)ModifyTransType.ProcessDebitCharge && modifyTransTypeID != (int)ModifyTransType.ProcessCreditCharge)
        {
            txtAmount.Text = hdnAmount.Value;
            txtAmount.Enabled = false;
        }

        //Allowing user ModifyTransTypeID of 13, 17 and 23 to modify the Refund Amount
        if (modifyTransTypeID == (int)ModifyTransType.ProcessCreditReturn || modifyTransTypeID == (int)ModifyTransType.ProcessDebitReturn || modifyTransTypeID == (int)ModifyTransType.ProcessCheckReturn)
        {
            txtAmount.Text = hdnMaxRefundAmount.Value;
            txtAmount.Enabled = true;
        }


        //if modifyTransTypeID is equal to the ProcessCreditReturn then enabling the RefundAmount textbox
        if (modifyTransTypeID == (int)ModifyTransType.ProcessCreditReturn)
            txtAmount.Enabled = true;

        // Getting Information for the Iplexus Call

        hdnInvoiceID.Value = dataTable.Rows[0]["StatementID"].ToString();
        hdnPNRef.Value = dataTable.Rows[0]["FSPPNRef"].ToString();
        hdnPatientID.Value = Convert.ToString(dataTable.Rows[0]["PatientID"]);
        hdnPaymentCardID.Value = Convert.ToString(dataTable.Rows[0]["PaymentCardID"]);
        hdnStatementID.Value = Convert.ToString(dataTable.Rows[0]["StatementID"]);
        hdnAccountID.Value = Convert.ToString(dataTable.Rows[0]["AccountID"]);
    }


    protected void btnSubmit_OnClick(object sender, EventArgs e)
    {
        var modifyTransTypeID = Convert.ToInt32(hdnModifyTransTypeID.Value);
        var transactionTypeID = Convert.ToInt32(hdnTransactionTypeID.Value);
        var isCancelTransaction = ViewState["FlagCancelTransaction"].ParseBool();

        // Check if transaction is Banking or not
        if (modifyTransTypeID > 100)
        {
            var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@PatientID", ClientSession.SelectedPatientID},
                                {"@TransactionID", ClientSession.ObjectID},
                                {"@StatementID", Convert.ToInt32(hdnStatementID.Value)},
                                {"@TransactionTypeID", transactionTypeID},
                                {"@ReasonTypeID", cmbReasonType.SelectedValue},
                                {"@Amount", txtAmount.Text},
                                {"@Notes", txtUpdateNotes.Text.Trim()},
                                {"@UserID", ClientSession.UserID},
                                {"@IPAddress ", ClientSession.IPAddress},
                                {"@FlagActive ", isCancelTransaction ? 0 : 1}
                            };

            SqlHelper.ExecuteScalarProcedureParams("web_pr_transaction_add", cmdParams);
            radWindowDialog.RadAlert(!isCancelTransaction ? "Record successfully updated." : "Record successfully cancelled.", 350, 150, "", "refreshGrid", "../Content/Images/success.png");
            SetMargin(51);
            return;
        }

        // Calling the FSP methods according to the modifyTransTypeID
        switch (modifyTransTypeID)
        {

            case (int)ModifyTransType.ProcessCreditVoid:
                var processCreditVoid = new ProcessCreditVoid(txtAmount.Text, hdnPNRef.Value,
                                                                Convert.ToInt32(hdnPatientID.Value), Convert.ToInt32(hdnPaymentCardID.Value),
                                                                Convert.ToInt32(hdnStatementID.Value), Convert.ToInt32(hdnAccountID.Value),
                                                                Convert.ToInt32(ClientSession.PracticeID), ClientSession.IPAddress,
                                                                Convert.ToInt32(ClientSession.UserID), Convert.ToInt32(ClientSession.ObjectID),
                                                                (int)SourceType.PatientPortalWeb, Convert.ToInt32(cmbReasonType.SelectedValue),
                                                                txtUpdateNotes.Text, null, null);

                Common.ReturnTransID = processCreditVoid.ReturnTransID;
                ShowMessage(processCreditVoid.FSPMessage, processCreditVoid.Success);
                break;

            case (int)ModifyTransType.ProcessDebitVoid:
                
                break;

            case (int)ModifyTransType.ProcessCreditReturn:
                var processCreditReturn = new ProcessCreditReturn(txtAmount.Text, hdnPNRef.Value,
                                                                    Convert.ToInt32(hdnPatientID.Value), Convert.ToInt32(hdnPaymentCardID.Value),
                                                                    Convert.ToInt32(hdnStatementID.Value), Convert.ToInt32(hdnAccountID.Value),
                                                                    Convert.ToInt32(ClientSession.PracticeID), ClientSession.IPAddress,
                                                                    Convert.ToInt32(ClientSession.UserID), Convert.ToInt32(ClientSession.ObjectID),
                                                                    (int)SourceType.PatientPortalWeb, Convert.ToInt32(cmbReasonType.SelectedValue),
                                                                    txtUpdateNotes.Text, null, null);

                Common.ReturnTransID = processCreditReturn.ReturnTransID;
                ShowMessage(processCreditReturn.FSPMessage, processCreditReturn.Success);
                break;

            case (int)ModifyTransType.ProcessCreditCharge:
                var processCreditSale = new ProcessCreditSale(txtAmount.Text, hdnPNRef.Value,
                                                                  Convert.ToInt32(hdnPatientID.Value), Convert.ToInt32(hdnPaymentCardID.Value),
                                                                  Convert.ToInt32(hdnStatementID.Value), Convert.ToInt32(hdnAccountID.Value),
                                                                  Convert.ToInt32(ClientSession.PracticeID), ClientSession.IPAddress,
                                                                  Convert.ToInt32(ClientSession.UserID), null,
                                                                  (int)SourceType.PatientPortalWeb, Convert.ToInt32(cmbReasonType.SelectedValue),
                                                                  txtUpdateNotes.Text, null, null);

                Common.ReturnTransID = processCreditSale.ReturnTransID;
                ShowMessage(processCreditSale.FSPMessage, processCreditSale.Success);
                break;


            case (int)ModifyTransType.ProcessCheckVoid:
                var processCheckVoid = new ProcessCheckVoid(txtAmount.Text, hdnPNRef.Value,
                                                                Convert.ToInt32(hdnPatientID.Value), Convert.ToInt32(hdnPaymentCardID.Value),
                                                                Convert.ToInt32(hdnStatementID.Value), Convert.ToInt32(hdnAccountID.Value),
                                                                Convert.ToInt32(ClientSession.PracticeID), ClientSession.IPAddress,
                                                                Convert.ToInt32(ClientSession.UserID), Convert.ToInt32(ClientSession.ObjectID),
                                                                (int)SourceType.PatientPortalWeb, Convert.ToInt32(cmbReasonType.SelectedValue),
                                                                txtUpdateNotes.Text, null, null);

                Common.ReturnTransID = processCheckVoid.ReturnTransID;
                ShowMessage(processCheckVoid.FSPMessage, processCheckVoid.Success);
                break;

            case (int)ModifyTransType.ProcessCheckReturn:
                var processCheckReturn = new ProcessCheckReturn(txtAmount.Text, hdnPNRef.Value,
                                                                    Convert.ToInt32(hdnPatientID.Value), Convert.ToInt32(hdnPaymentCardID.Value),
                                                                    Convert.ToInt32(hdnStatementID.Value), Convert.ToInt32(hdnAccountID.Value),
                                                                    Convert.ToInt32(ClientSession.PracticeID), ClientSession.IPAddress,
                                                                    Convert.ToInt32(ClientSession.UserID), Convert.ToInt32(ClientSession.ObjectID),
                                                                    (int)SourceType.PatientPortalWeb, Convert.ToInt32(cmbReasonType.SelectedValue),
                                                                    txtUpdateNotes.Text, null, null);

                Common.ReturnTransID = processCheckReturn.ReturnTransID;
                ShowMessage(processCheckReturn.FSPMessage, processCheckReturn.Success);

                break;


            case (int)ModifyTransType.ProcessCheckCharge:
                var processCheckSale = new ProcessCheckSale(txtAmount.Text, hdnPNRef.Value,
                                                               Convert.ToInt32(hdnPatientID.Value), Convert.ToInt32(hdnPaymentCardID.Value),
                                                               Convert.ToInt32(hdnStatementID.Value), Convert.ToInt32(hdnAccountID.Value),
                                                               Convert.ToInt32(ClientSession.PracticeID), ClientSession.IPAddress,
                                                               Convert.ToInt32(ClientSession.UserID), null,
                                                               (int)SourceType.PatientPortalWeb, Convert.ToInt32(cmbReasonType.SelectedValue),
                                                               txtUpdateNotes.Text, null, null);

                Common.ReturnTransID = processCheckSale.ReturnTransID;
                ShowMessage(processCheckSale.FSPMessage, processCheckSale.Success);
                break;


            default:
                radWindowDialog.RadAlert("The selected transaction changes cannot be applied at this time. Please contact support for assistance. Transaction ID = " +
                                       transactionTypeID, 450, 100, "", "refreshGrid", "../Content/Images/warning.png");
                SetMargin(110);

                break;
        }


        // If modifyTransTypeID is equal to ProcessCreditCharge or ProcessCreditReturn or ProcessCheckCharge or ProcessCheckReturn and FSP call should be successfull, then we're sending email to user
        if ((modifyTransTypeID == (int)ModifyTransType.ProcessCreditCharge || modifyTransTypeID == (int)ModifyTransType.ProcessCreditVoid
                                                                           || modifyTransTypeID == (int)ModifyTransType.ProcessCheckVoid
                                                                           || modifyTransTypeID == (int)ModifyTransType.ProcessCreditReturn
                                                                           || modifyTransTypeID == (int)ModifyTransType.ProcessCheckCharge
                                                                           || modifyTransTypeID == (int)ModifyTransType.ProcessCheckReturn))
        {

            EmailServices.SendRefundReceiptbyID(Common.ReturnTransID, ClientSession.UserID);

        }
        
    }

    private void ShowMessage(string message, bool success)
    {
        var imageUrl = success ? "../Content/Images/success.png" : "../Content/Images/warning.png";
        message = success ? "Record successfully processed." : message.ToApostropheStringIfAny();
        radWindowDialog.RadAlert(message, 350, 150, "", "refreshGrid", imageUrl);
        SetMargin(51);
        // To know about wheather the FSP call was successfull or not
        Common.Success = success;
    }

    private void SetMargin(int margin)
    {
        Style = string.Format("margin-left: {0}px;", margin);
    }

}

