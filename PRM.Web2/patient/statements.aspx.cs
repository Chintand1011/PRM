using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;
using System.Data;
public partial class patient_statements : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {

        }
        popupPayStatement.VisibleOnPageLoad = false;
        popupAddTransactions.VisibleOnPageLoad = false;
        popupEstimateView.VisibleOnPageLoad = false;
        popupPaymentReceipt.VisibleOnPageLoad = false;
        popupPaymentPlan.VisibleOnPageLoad = false;
    }

    #region Grid Operations

    private DataTable GetPatientStatements(int flagCurrent)
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@PatientID", ClientSession.SelectedPatientID },
            { "@flagcurrent", flagCurrent },
            { "@UserID", ClientSession.UserID }
        };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
    }

    protected void grdPatientStatements_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var patientStatements = GetPatientStatements(1);
        grdPatientStatements.DataSource = patientStatements;
    }

    protected void grdPatientStatements_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Pay":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString();
                popupPayStatement.NavigateUrl = "~/report/pc_add_popup_lite.aspx?q=" + e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["Balance"];
                popupPayStatement.VisibleOnPageLoad = true;
                break;

            case "View":
                var statementId = int.Parse(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString());
                ShowStatementEstimate(statementId, GetStatementDate(e));
                break;

            case "Adjust":
                ClientSession.ObjectID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"]);
                var flag = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagAllowClose"];

                popupAddTransactions.NavigateUrl = popupAddTransactions.NavigateUrl.AppendQueryString(new { FlagAllowClose = flag }, true);
                popupAddTransactions.VisibleOnPageLoad = true;
                break;

            case "CloseStatement":
                ForceCloseStatement(e);
                break;

            case "Download":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectType = ObjectType.Statement;
                var filePathUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FilePathStatements"].ToString();
                var fileName = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FileName"].ToString();
                ViewState["FilePath"] = GetFilePath(filePathUrl, fileName);
                ViewState["StatementDate"] = GetStatementDate(e);
                hdnDownload.Value = "true";
                break;

        }

    }

    private void ForceCloseStatement(GridCommandEventArgs e)
    {
        var statementId = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString();
        var cmdParams = new Dictionary<string, object>
        {
            {"@StatementID", statementId},
            {"@FlagCloseStatement", 1},
            {"@UserID", ClientSession.UserID},
        };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_statementinv_add", cmdParams);
        RadWidowManager.RadAlert("This statement has been closed and no further invoices will be sent.", 350, 150, "", "refreshPage", "../Content/Images/success.png");
    }


    protected void grdPatientStatements_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var summaryHistory = e.Item.NamingContainer as GridTableView;
            if (summaryHistory != null)
            {
                if (summaryHistory.Name == "SummaryDetails")
                {
                    return;
                }
            }


            var balance = (decimal)item.GetDataKeyValue("Balance");

            var btnPayPlan = item.FindControl("imgPayPlan") as ImageButton;
            var btnCreditPlan = item.FindControl("imgCreditPlan") as ImageButton;

            var flagPayPlan = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagPayPlan"]);
            var flagPayPlanEligible = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagPayPlanEligible"]);

            var flagCreditPlan = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagCreditPlan"]);
            var flagCreditEligible = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagCreditEligible"]);

            // Managing the image for the PayPlan
            if (!flagPayPlan && !flagPayPlanEligible)
            {
                btnPayPlan.ImageUrl = "../Content/Images/icon_dash.png";
                btnPayPlan.Enabled = false;
            }
            else if (!flagPayPlan && flagPayPlanEligible)
            {
                btnPayPlan.ImageUrl = "../Content/Images/icon_add_green.png";
            }
            else if (flagPayPlan)
            {
                btnPayPlan.ImageUrl = "../Content/Images/icon_edit.png";
            }

            // Managing the image for the CreditPlan
            if (!flagCreditPlan && !flagCreditEligible)
            {
                btnCreditPlan.ImageUrl = "../Content/Images/icon_dash.png";
                btnCreditPlan.Enabled = false;
            }
            else if (!flagCreditPlan && flagCreditEligible)
            {
                btnCreditPlan.ImageUrl = "../Content/Images/icon_add_green.png";
            }
            else if (flagCreditPlan)
            {
                btnCreditPlan.ImageUrl = "../Content/Images/icon_edit.png";
            }

            // For close button
            var gridCloseButtonColumn = item["CloseStatement"].Controls[0] as ImageButton;
            var flagAllowClose = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagAllowClose"].ParseBool();
            if (!flagAllowClose)
            {
                gridCloseButtonColumn.ImageUrl = "../Content/Images/icon_dash.png";
                gridCloseButtonColumn.Enabled = false;
                gridCloseButtonColumn.CssClass = "cursor-default";
            }

            if (balance > 0) return;
            var imageControl = ((ImageButton)item["Pay"].Controls[0]);
            imageControl.ImageUrl = "~/Content/Images/spacer.gif";
            imageControl.Enabled = false;
        }
    }

    protected void gridPatientClosedStatements_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var patientStatements = GetPatientStatements(0);
        gridPatientClosedStatements.DataSource = patientStatements;

    }

    protected void gridPatientClosedStatements_ItemDataBound(object source, GridItemEventArgs e)
    {
        if (!(e.Item is GridDataItem)) return;

        var item = (GridDataItem)e.Item;

        var gridTableView = item.NamingContainer as GridTableView;
        if (gridTableView != null && gridTableView.Name == "ClosedStatementDetails") return;
        
        var gridRestrictButtonColumn = item["RestrictView"].Controls[0] as ImageButton;
        var flagRestrictView = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagRestrictView"].ParseBool();
        if (flagRestrictView)
        {
            gridRestrictButtonColumn.ImageUrl = "../Content/Images/icon_hide.png";
        }

    }

    protected void gridPatientClosedStatements_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {

            case "RestrictView":
                RestrictView(e);
                break;
            case "View":
                var statementId = int.Parse(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString());
                ShowStatementEstimate(statementId, GetStatementDate(e));
                break;

            case "Download":
                ClientSession.ObjectID = int.Parse(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString());
                var filePathUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FilePathStatements"].ToString();
                var fileName = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FileName"].ToString();
                ViewState["FilePath"] = GetFilePath(filePathUrl, fileName);
                ViewState["StatementDate"] = GetStatementDate(e);
                hdnDownload.Value = "true";
                break;

        }

    }

    private void RestrictView(GridCommandEventArgs e)
    {
        var statementId = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString();
        var flagRestrictView = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagRestrictView"].ParseBool();

        var cmdParams = new Dictionary<string, object>
        {
            {"@StatementID", statementId},
            {"@FlagRestrictView", flagRestrictView ? 0 : 1},
            {"@UserID", ClientSession.UserID},
        };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_statementinv_add", cmdParams);

        var message = !flagRestrictView
                                        ? "This statement is now hidden from view by the patient."
                                        : "This statement is now visible on the Patient Portal.";

        RadWidowManager.RadAlert(message, 350, 140, "Success", "refreshPage", "../Content/Images/success.png");
    }


    protected void grd_OnDetailTableDataBind(object sender, GridDetailTableDataBindEventArgs e)
    {
        var dataItem = e.DetailTableView.ParentItem;

        var cmdParams = new Dictionary<string, object>
                            {
                                {"@StatementID", dataItem.GetDataKeyValue("StatementID")},
                                {"@UserID", ClientSession.UserID},
                            };

        e.DetailTableView.DataSource = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_history_get", cmdParams);
    }


    #endregion

    #region Manage Add/Edit PaymentPlans and Bluecredit

    protected void btnPayPlan_OnClick(object sender, EventArgs e)
    {
        var imageButton = (ImageButton)sender;
        var dataItem = imageButton.NamingContainer as GridDataItem;
        var flagPayPlan = Convert.ToBoolean(dataItem.GetDataKeyValue("FlagPayPlan"));
        var statementID = Convert.ToInt32(dataItem.GetDataKeyValue("StatementID"));
        var balance = Convert.ToDecimal(dataItem.GetDataKeyValue("Balance"));

        if (flagPayPlan)
        {
            ClientSession.ObjectType = ObjectType.EditPaymentPlan;
            ClientSession.ObjectValue = 0m;
            ClientSession.ObjectID2 = Convert.ToInt32(dataItem.GetDataKeyValue("paymentPlanID"));
            ClientSession.IsBlueCreditAddRequest = false;
        }
        else
        {
            ClientSession.ObjectID = statementID;
            ClientSession.ObjectID2 = null;
            ClientSession.ObjectValue = balance;
            ClientSession.ObjectType = ObjectType.AddPaymentPlan;
            ClientSession.IsBlueCreditAddRequest = true;
        }

        hdnIsRedirect.Value = "2";
    }

    protected void btnCreditPlan_OnClick(object sender, EventArgs e)
    {
        var imageButton = (ImageButton)sender;
        var dataItem = imageButton.NamingContainer as GridDataItem;
        var flagCreditPlan = Convert.ToBoolean(dataItem.GetDataKeyValue("FlagCreditPlan"));
        var statementID = Convert.ToInt32(dataItem.GetDataKeyValue("StatementID"));
        var balance = Convert.ToDecimal(dataItem.GetDataKeyValue("Balance"));

        if (flagCreditPlan)
        {
            ClientSession.ObjectID = Convert.ToInt32(dataItem.GetDataKeyValue("BlueCreditID"));
            ClientSession.ObjectType = ObjectType.BlueCreditDetail;
            ClientSession.IsBlueCreditAddRequest = false;
        }
        else
        {
            ClientSession.SelectedBlueCreditStatements = new List<int> { statementID };
            ClientSession.StatementIDandBalance = new List<string> { string.Format("{0}-{1}", statementID, balance) };
            ClientSession.SelectedStatementBalance = balance;
            ClientSession.HighestSelectedBalance = balance;
            ClientSession.IsBlueCreditAddRequest = true;
        }


        hdnIsRedirect.Value = "1";
    }

    #endregion

    #region Common

    private string GetStatementDate(GridCommandEventArgs e)
    {
        var item = ((GridDataItem)e.Item);
        var invoiceDate = string.Empty;

        if (item.OwnerTableView.DataKeyNames.Contains("InvoiceDateRaw"))
        {
            invoiceDate = item.GetDataKeyValue("InvoiceDateRaw").ToString();
        }

        return invoiceDate;
    }

    protected void btnDownload_Click(object sender, EventArgs e)
    {
        var defaultPath = ViewState["FilePath"].ToString();

        var returnmsg = PDFServices.FileDownload(defaultPath, "Statement.pdf");
        if (returnmsg != "")
        {
            defaultPath = Path.GetDirectoryName(defaultPath);
            var statementDate = ViewState["StatementDate"].ToString();

            var url = ClientSession.WebPathRootProvider + "report/estimateview_popup.aspx".AppendQueryString(new
            {
                StatementID = ClientSession.ObjectID,
                InvoiceDate = statementDate
            });

            PDFServices.PDFCreate("Statement.pdf", url, defaultPath);
            PDFServices.DownloadandDeleteFile(defaultPath, "Statement.pdf");
        }
    }

    private string GetFilePath(string fileUrl, string fileName)
    {
        return Path.Combine(fileUrl, fileName);
    }


    private void ShowStatementEstimate(int statementId, string date)
    {
        var navigateUrl = popupEstimateView.NavigateUrl.AppendQueryString(new { InvoiceDate = date }, true);

        ClientSession.ObjectID = statementId;
        ClientSession.ObjectType = ObjectType.Statement;
        popupEstimateView.NavigateUrl = navigateUrl;
        popupEstimateView.VisibleOnPageLoad = true;
    }

    #endregion



    protected void btnCreatePDF_OnClick(object sender, EventArgs e)
    {
        Common.CreateandViewPDF();
        popupProgress.VisibleOnPageLoad = false;
        hdnIsShowPDFViewer.Value = "1";
    }




}