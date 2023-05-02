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
public partial class estimates : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
        }
        popupEstimateUtility.VisibleOnPageLoad = false;
        popupEstimateView.VisibleOnPageLoad = false;
    }

    #region Grid Operations

    private DataTable GetCurrentEstimates()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@FlagStatement", 0 }, { "@UserID", ClientSession.UserID } };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_estimate_get", cmdParams);
    }

    protected void grdCurrentEstimates_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdCurrentEstimates.DataSource = GetCurrentEstimates();
    }

    protected void grdCurrentEstimates_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "ViewEstimates":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["EstimateID"];
                ClientSession.ObjectType = ObjectType.Estimate;
                popupEstimateView.VisibleOnPageLoad = true;
                break;

            case "EditEstimate":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["EstimateID"];
                ClientSession.ObjectType = ObjectType.Estimate;
                popupEstimateUtility.VisibleOnPageLoad = true;
                break;

            case "DeleteEstimate":
                ViewState["EstimateId"] = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["EstimateID"];
                windowManager.RadConfirm("This will delete the selected estimate from the patient account and cannot be undone. Are you sure you want to continue?",
                                        "isDelete", 450, 100, null, "", "../Content/Images/warning.png");
                break;

            case "ConvertEstimate":
                hdnEstimateID.Value = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["EstimateID"].ToString();
                windowManager.RadConfirm("This will convert the selected estimate to an active statement. The patient will billed any associated charges and an invoice will be processed tomorrow. Are you sure you want to continue?",
                                        "isConvert", 500, 100, null, "", "../Content/Images/warning.png");
                break;


        }

    }
    
    protected void grdCurrentEstimates_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var flagFeeScheduleActive = Convert.ToBoolean(item.GetDataKeyValue("FlagFeeScheduleActive"));

            if (!flagFeeScheduleActive)
            {
                var imageControl = ((ImageButton)item["Edit"].Controls[0]);
                imageControl.ImageUrl = "~/Content/Images/icon_dash.png";
                imageControl.Enabled = false;
                imageControl.ToolTip = "This estimate is not able to be edited since the attached Fee Schedule is no longer active.";
                imageControl.CssClass = "cursor-default";
            }
        }
    }

    private DataTable GetEstimatesConvertedStatements()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@FlagStatement", 1 }, { "@UserID", ClientSession.UserID } };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
    }

    protected void gridEstimatesConvertedStatements_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        gridEstimatesConvertedStatements.DataSource = GetEstimatesConvertedStatements();
    }

    protected void gridEstimatesConvertedStatements_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "ViewEstimates":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectType = ObjectType.Statement;
                popupEstimateView.VisibleOnPageLoad = true;
                break;

            case "Cancel":
                hdnEstimateID.Value = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["EstimateID"]).ToString("");
                windowManager.RadConfirm("This will delete the selected statement and convert it back to an estimate, which may then be edited. This is only possible for statements with no associated payments. Are you sure you want to continue?",
                                       "removeStatement", 600, 100, null, "", "../Content/Images/warning.png");
                break;
        }

    }

    protected void gridEstimatesConvertedStatements_OnItemDataBound(object source, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var flagLocked = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagLocked"]);
            item["Cancel"].Enabled = !flagLocked;
            if (flagLocked)
                (item["Cancel"].Controls[0] as ImageButton).ImageUrl = "~/Content/Images/icon_cancelx_fade.gif";
        }
    }

    #endregion


    protected void btnConvert_OnClick(object sender, EventArgs e)
    {
        var cmdParams = new Dictionary<string, object> { { "@EstimateID", hdnEstimateID.Value }, { "@UserID", ClientSession.UserID } };
        SqlHelper.ExecuteScalarProcedureParams("web_pr_statement_add", cmdParams);
        ShowSuccessMessage("Statement Conversion Successful.");
    }


    protected void btnDeleteEstimate_OnClick(object sender, EventArgs e)
    {
        var estimateId = ViewState["EstimateId"];

        var cmdParams = new Dictionary<string, object>
        {
            { "@PatientID", ClientSession.SelectedPatientID },
            { "@EstimateID", estimateId },
            { "@UserID", ClientSession.UserID },
            { "@FlagActive", 0 }
        };
        SqlHelper.ExecuteScalarProcedureParams("web_pr_estimate_add", cmdParams);
        
        grdCurrentEstimates.Rebind();
    }

    protected void btnDeleteStatement_OnClick(object sender, EventArgs e)
    {
        var cmdParams = new Dictionary<string, object> { { "@EstimateID", hdnEstimateID.Value }, { "@UserID", ClientSession.UserID }, { "@FlagActive", 0 } };
        SqlHelper.ExecuteScalarProcedureParams("web_pr_statement_add", cmdParams);
        ShowSuccessMessage("Statement Deletion Successful.");
    }

    protected void btnCreateNew_Click(object sender, EventArgs e)
    {
        ClientSession.ObjectID = null;
        ClientSession.ObjectType = ObjectType.Estimate;
        popupEstimateUtility.VisibleOnPageLoad = true;
    }

    private void ShowSuccessMessage(string message)
    {
        windowManager.RadAlert(message, 350, 150, "", "reloadPage", "../Content/Images/success.png");
    }

    protected void btnCreatePDF_OnClick(object sender, EventArgs e)
    {
        Common.CreateandViewPDF();
        hdnIsShowPDFViewer.Value = "1";
    }
}