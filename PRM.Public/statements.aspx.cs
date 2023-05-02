using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
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
    }

    #region Grid Operations

    private DataTable GetPatientStatements(int flagCurrent)
    {
        var cmdParams = new Dictionary<string, object> { { "@AccountID", ClientSession.AccountID }, { "@flagcurrent", flagCurrent } };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
    }

    protected void grdPatientStatements_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdPatientStatements.DataSource = GetPatientStatements(1);
    }

    protected void grdPatientStatements_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Pay":
                Response.Redirect("~/Payments.aspx");
                break;

            case "Download":
                DownloadFile(e);
                break;
        }

    }


    protected void grdPatientStatements_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var balance = Convert.ToDecimal(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["Balance"]);

            // Displaying Pay image if balance is greater than 0
            var payImage = item["Pay"].Controls[0] as ImageButton;
            payImage.Enabled = balance > 0;
            payImage.ImageUrl = balance > 0 ? "~/Content/Images/icon_paynow.png" : "~/Content/Images/spacer.gif";

            // Displaying images for payplan and creditplan
            var imgPayPlan = item.FindControl("imgPayPlan") as Image;
            var imgCreditPlan = item.FindControl("imgCreditPlan") as Image;
            var payPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditPayAbbr"].ToString();
            var creditPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditPlanAbbr"].ToString();
            imgPayPlan.ImageUrl = payPlan == YesNo.Yes.ToString() ? "~/Content/Images/icon_yes.png" : "~/Content/Images/icon_dash.png";
            imgCreditPlan.ImageUrl = creditPlan == YesNo.Yes.ToString() ? "~/Content/Images/icon_yes.png" : "~/Content/Images/icon_dash.png";


        }
    }


    protected void gridPatientPreviousHistory_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Download":
                DownloadFile(e);
                break;
        }

    }

    protected void gridPatientPreviousHistory_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        gridPatientPreviousHistory.DataSource = GetPatientStatements(0);
    }



    #endregion

    private void DownloadFile(GridCommandEventArgs e)
    {
        var statementId = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString();
        var filePathUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FilePathStatements"].ToString();
        var fileName = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FileName"].ToString();
        var filePath = GetFilePath(filePathUrl, fileName);

        var returnmsg = PDFServices.FileDownload(filePath, "Statement.pdf");
        if (returnmsg != "")
        {
            filePath = Path.GetDirectoryName(filePath);
            var url = ClientSession.WebPathRootPatient + "report/estimateview_popup.aspx?StatementID=" + statementId;
            PDFServices.PDFCreate("Statement.pdf", url, filePath);
            PDFServices.DownloadandDeleteFile(filePath, "Statement.pdf");

        }

    }

    private string GetFilePath(string fileUrl, string fileName)
    {
        return Path.Combine(fileUrl, fileName);
    }

}