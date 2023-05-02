using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Data;
using PatientPortal.DataLayer;
using PatientPortal.Utility;

public partial class patient_paymentplans : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            ClientSession.ListofObject = null;
            // validating if user have permission to access the page or note
            ValidateUser();
            
        }

        // Preventing the popups to open on page load
        popupPaymentPlan.VisibleOnPageLoad = false;
        popupAddPaymentCard.VisibleOnPageLoad = false;
        popupPayPanTransactionHistory.VisibleOnPageLoad = false;
    }

    private void ValidateUser()
    {
        if (!ClientSession.IsAllowPaymentPlans) Response.Redirect("error.aspx");
    }

    #region Grid Operations

    private DataTable GetActiveMakePayments()
    {
        var cmdParams = new Dictionary<string, object> { { "@AccountID", ClientSession.AccountID }, { "@FlagBalance", 1 }, { "@FlagCurrent", 1 } };

        var activePayments = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);

        var view = activePayments.DefaultView;
        view.RowFilter = string.Format("FlagPayPlan={0}", 0);
        activePayments = view.ToTable();

        return activePayments;

    }

    protected void grdMakePayments_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdMakePayments.DataSource = GetActiveMakePayments();
    }

    protected void grdMakePayments_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "AddPlan":
                // Displaying the Payment Plan popup for add new payment plan
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectID2 = null;
                ClientSession.ObjectValue = (decimal)e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["Balance"];
                ClientSession.ObjectType = ObjectType.AddPaymentPlan;
                popupPaymentPlan.VisibleOnPageLoad = true;
                break;

            case "Download":
                // Downloading the statements
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString();
                var filePathUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FilePathStatements"].ToString();
                var fileName = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FileName"].ToString();
                var filePath = Path.Combine(filePathUrl, fileName);
                ViewState["FilePath"] = filePath;
                hdnDownload.Value = "true";
                break;

        }
    }

    protected void grdPaymentPlanHistory_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "DeletePlan":
                var cmdParams = new Dictionary<string, object>
                                    {

                                        { "@PaymentPlanID ", e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentPlanID"] },
                                        { "@FlagActive ", 0 }
                                        
                                    };

                SqlHelper.ExecuteScalarProcedureParams("web_pt_payplan_add", cmdParams);
                Response.Redirect("~/paymentplan.aspx");
                break;

            case "ViewPayPlanTransactionHistory":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentPlanID"];
                popupPayPanTransactionHistory.VisibleOnPageLoad = true;
                break;


            case "EditPlan":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectID2 = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentPlanID"];
                ClientSession.ObjectValue = (decimal)e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["Balance"];
                ClientSession.ObjectType = ObjectType.EditPaymentPlan;
                popupPaymentPlan.VisibleOnPageLoad = true;
                break;

            case "Download":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString();
                var filePathUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FilePathStatements"].ToString();
                var fileName = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FileName"].ToString();
                var filePath = Path.Combine(filePathUrl, fileName);
                ViewState["FilePath"] = filePath;
                hdnDownload.Value = "true";
                break;

        }
    }

    protected void grdPaymentPlanHistory_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var balance = Convert.ToDecimal(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["Balance"]);

            var editPlan = item["EditPlan"].Controls[0] as ImageButton;
            editPlan.Enabled = balance > 0;
            editPlan.ImageUrl = balance > 0 ? "~/Content/Images/icon_edit.png" : "~/Content/Images/spacer.gif";
            
        }
    }

    protected void grdMakePayments_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var flagCreditPlan = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagCreditPlan"]);
            var flagPayPlanEligible = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagPayPlanEligible"]);

            // enabling if flagCreditPlan == false and flagPayPlanEligible == true
            item["AddPlan"].Enabled = (!flagCreditPlan && flagPayPlanEligible);
            (item["AddPlan"].Controls[0] as ImageButton).ImageUrl = (!flagCreditPlan && flagPayPlanEligible) ? "~/Content/Images/icon_expand.gif" : "~/Content/Images/spacer.gif";

            // For Yes No Images
            //var imgPayPlan = item.FindControl("imgPayPlan") as Image;
            //var imgCreditPlan = item.FindControl("imgCreditPlan") as Image;
            var imgPlanEligible = item.FindControl("imgPlanEligible") as Image;
            //var payPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditPayAbbr"].ToString();
            //var creditPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditPlanAbbr"].ToString();
            var payPlanEligibleAbbr = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PayPlanEligibleAbbr"].ToString();
            //imgPayPlan.ImageUrl = payPlan == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";
            //imgCreditPlan.ImageUrl = creditPlan == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";
            imgPlanEligible.ImageUrl = payPlanEligibleAbbr == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";
        
        
        }
    }

    private DataTable GetPaymentPlanHistory()
    {
        var cmdParams = new Dictionary<string, object> { { "@AccountID", ClientSession.AccountID } };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentplan_get", cmdParams);
    }

    protected void grdPaymentPlanHistory_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdPaymentPlanHistory.DataSource = GetPaymentPlanHistory();
    }

    #endregion

    #region Downd File

    protected void btnDownload_Click(object sender, EventArgs e)
    {
        var path = ViewState["FilePath"].ToString();
        var returnmsg = PDFServices.FileDownload(path, "Statement.pdf");
        if (returnmsg != "")
        {
            path = Path.GetDirectoryName(path);
            var url = ClientSession.WebPathRootPatient + "report/estimateview_popup.aspx?StatementID=" + ClientSession.ObjectID;
            PDFServices.PDFCreate("Statement.pdf", url, path);
            PDFServices.DownloadandDeleteFile(path, "Statement.pdf");
        }

    }


    #endregion

}