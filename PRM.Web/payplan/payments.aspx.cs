using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
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
        }
        
        popupPaymentPlan.VisibleOnPageLoad = false;
        popupEditBlueCredit.VisibleOnPageLoad = false;
        popupTransactionDetails.VisibleOnPageLoad = false;
        popupEstimateView.VisibleOnPageLoad = false;
        popupManageAccounts.VisibleOnPageLoad = false;
    }

    #region Grid Operations

    private DataTable GetPendingPayments()
    {
        var cmdParams = new Dictionary<string, object> { { "@flagbc", 0 }, { "@MaxDays", 31 } };

        return SqlHelper.ExecuteDataTableProcedureParams("svc_pending_payments", cmdParams);
    }

    protected void grdPendingPayments_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdPendingPayments.DataSource = GetPendingPayments();
    }


    private DataTable GetPaymentHistory()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID }, { "@FlagPP", 1 }, { "@DateMin", DateTime.Now.AddMonths(-1) }, { "@UserID", ClientSession.UserID } };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_transaction_get", cmdParams);
    }

    protected void grdPaymentHistory_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdPaymentHistory.DataSource = GetPaymentHistory();
    }

    protected void grdPaymentHistory_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Receipt":
                var transactionID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["TransactionID"];
                var cmdParams = new Dictionary<string, object> { { "@TransactionID", transactionID } };
                ReceiptMessage = SqlHelper.ExecuteScalarProcedureParams("web_pt_payment_receipt", cmdParams).ToString();
                ClientSession.ObjectID = transactionID;
                ClientSession.ObjectType = ObjectType.Transaction;
                popupTransactionDetails.VisibleOnPageLoad = true;
                break;

            case "ViewStatement":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectType = ObjectType.Statement;
                popupEstimateView.VisibleOnPageLoad = true;
                break;
        }
    }

    protected void btnPaymentHistoryReport_Click(object sender, EventArgs e)
    {
        foreach (GridColumn col in grdPaymentHistory.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = Unit.Point(100);
        }

        ConfigureExport(grdPaymentHistory, new[] { "Receipt", "ViewStatement" });
        grdPaymentHistory.ExportSettings.FileName = "Payment History";
        grdPaymentHistory.MasterTableView.ExportToExcel();

    }

    protected void grdPendingPayments_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "EditPayment":

                var blueCreditID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["BlueCreditID"].ToString();
                ClientSession.SelectedPatientID = Int32.Parse(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientID"].ToString());
                ClientSession.SelectedPatientAccountID = Int32.Parse(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["AccountID"].ToString());
                (new UserLogin()).LoadPatientIntoSession();

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

            case "ViewStatement":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectType = ObjectType.Statement;
                popupEstimateView.VisibleOnPageLoad = true;
                break;
        }
    }


    protected void grdMakePayments_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Download":
                break;
        }
    }
    
    protected void grdMakePayments_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var chkCredit = item.FindControl("chkStatement") as CheckBox;
            var txtAmount = item.FindControl("txtAmount") as RadNumericTextBox;
            var flagAcceptPtPay = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagAcceptPtPay"]);
            if (!flagAcceptPtPay)
            {
                chkCredit.Enabled = false;
                txtAmount.Enabled = false;
            }
        }
    }

    protected void btnPendingPaymentsReport_Click(object sender, EventArgs e)
    {
        foreach (GridColumn col in grdPendingPayments.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = Unit.Point(100);
        }

        ConfigureExport(grdPendingPayments, new[] { "EditPayment", "ViewStatement" });
        grdPendingPayments.ExportSettings.FileName = "Payment Report";
        grdPendingPayments.MasterTableView.ExportToExcel();
    }
    

    public void ConfigureExport(RadGrid grid, string[] columnsToBeExclued)
    {
        grid.ExportSettings.ExportOnlyData = true;
        grid.ExportSettings.IgnorePaging = true;

        foreach (var column in columnsToBeExclued)
        {
            grid.MasterTableView.GetColumn(column).Visible = false;
        }
    }

    #endregion
    #region Create a PDF

    protected void btnCreatePDF_OnClick(object sender, EventArgs e)
    {
        Common.CreateandViewPDF();
        hdnIsShowPDFViewer.Value = "1";
    }
    #endregion
}