using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class pfsreport : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                var shouldEnableButton = ClientSession.RoleTypeID != (int)RoleType.ReadOnly;
                if (!shouldEnableButton)
                {
                    btnRunNew.Enabled = false;
                    btnRunNew.CssClass = "disable-button";
                }
                
            }
            catch (Exception)
            {
                throw;
            }
        }

        popupCreditReport.VisibleOnPageLoad = false;
        popupRunNew.VisibleOnPageLoad = false;

        ValidateAndOpenRunNewPopup();

    }

    private void ValidateAndOpenRunNewPopup()
    {
        if (!btnRunNew.Enabled)
            return;

        var param = Request.Params["rn"];
        if (param != null && param.Equals("1"))
        {
            var isValidated = Validator.ValidateCreditCheck(radWindowManagerDialog);
            if (!isValidated)
                return;
            
            popupRunNew.VisibleOnPageLoad = true;
        }
    }


    private DataTable GetPastCreditReports()
    {
        var cmdParams = new Dictionary<string, object>()
                            {
                                {"@PatientID",ClientSession.SelectedPatientID},
                                {"@FlagAdHoc", 0},
                                { "@UserID", ClientSession.UserID}
                            };
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_tupfssummary_get", cmdParams);

    }

    protected void grdPastCreditReports_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var pastCreditReports = GetPastCreditReports();
        grdPastCreditReports.DataSource = pastCreditReports;

#if(!DEBUG)
        if (pastCreditReports.Rows.Count > 0) ViewState["FlagAllowPFS"] = pastCreditReports.Rows[0]["FlagAllowPFS"].ToString();
        else ViewState["FlagAllowPFS"] = "1";
#else    
            ViewState["FlagAllowPFS"] = "1";
#endif
    }


    protected void grdPastCreditReports_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "ViewHistory":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PFSID"];
                ClientSession.ObjectID2 = ClientSession.SelectedPatientID;
                ClientSession.ObjectType = ObjectType.PFSReportDetail;
                popupCreditReport.VisibleOnPageLoad = true;
                break;
        }
    }


    protected void grdPastCreditReports_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var tuResultTypeID = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["TUResultTypeID"]);
            if (tuResultTypeID) return;

            var imageButton = (item["ViewHistory"].Controls[0] as ImageButton);
            imageButton.ImageUrl = "~/content/Images/icon_dash.png";
            imageButton.CssClass = "cursor-default";
            imageButton.Enabled = false;
        }
    }

    protected void BtnRunNew_Click(object sender, EventArgs e)
    {
        var isValidated = Validator.ValidateCreditCheck(radWindowManagerDialog);
        if (!isValidated)
            return;

        isValidated = Validator.ValidateFlagCreditCheck(radWindowManagerDialog, "submitPfs");
        if (!isValidated && ViewState["FlagCreditCheck"] == null)
        {
            ViewState["FlagCreditCheck"] = "1";
            return;
        }
        
        ShowPFSSubmitPopup();
    }

    private void ShowPFSSubmitPopup()
    {
        var isAllowFps = ViewState["FlagAllowPFS"].ToString() == "1";
        if (!isAllowFps)
        {
            radWindowManagerDialog.RadAlert("A successful credit was processed in the last 30 days. Please use this report to determine credit worthiness.", 450, 150, string.Empty, string.Empty, "../Content/Images/warning.png");
            return;
        }
        popupRunNew.VisibleOnPageLoad = true;
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("credit.aspx");
    }




}