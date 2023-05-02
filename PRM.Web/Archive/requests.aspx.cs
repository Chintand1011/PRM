using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;
using eis = Telerik.Web.UI.ExportInfrastructure;

public partial class search : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                BindPatients();
                BindLocations();
                BindProviders();
                BindPublicStatus();
                BindTypes();
                BindStatus();
            }
            catch (Exception)
            {

                throw;
            }

        }

        popupTransactionHistory.VisibleOnPageLoad = false;
        popupCreditReport.VisibleOnPageLoad = false;
        popupEditBlueCredit.VisibleOnPageLoad = false;
    }

    #region Bind Dropdowns

    private void BindPatients()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID", ClientSession.PracticeID}
                                };

        var patients = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_list", cmdParams);
        cmbPatients.DataSource = patients;
        cmbPatients.DataBind();
    }

    private void BindLocations()
    {
        var cmdParams = new Dictionary<string, object> {
        {"@PracticeID", ClientSession.PracticeID}, };
        var locations = SqlHelper.ExecuteDataTableProcedureParams("web_pr_location_list", cmdParams);
        cmbLocations.DataSource = locations;
        cmbLocations.DataBind();
    }

    private void BindProviders()
    {
        var cmdParams = new Dictionary<string, object> { {"@PracticeID", ClientSession.PracticeID} };
        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);
        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();
    }

    private void BindPublicStatus()
    {
        var cmdParams = new Dictionary<string, object>();
        var statusTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statustype_list", cmdParams);
        cmbPublicStatus.DataSource = statusTypes;
        cmbPublicStatus.DataBind();
    }

    private void BindTypes()
    {
        var types = SqlHelper.ExecuteDataTableProcedureParams("web_pr_credittype_list", new Dictionary<string, object>());
        cmbTypes.DataSource = types;
        cmbTypes.DataBind();
    }

    private void BindStatus()
    {
        var statuses = SqlHelper.ExecuteDataTableProcedureParams("web_pr_creditstatustype_list", new Dictionary<string, object>());
        cmbStatus.DataSource = statuses;
        cmbStatus.DataBind();
    }

    #endregion

    #region Grid Operations

    protected void btnReport_Click(object sender, EventArgs e)
    {
        foreach (GridColumn col in grdBlueCreditHistory.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = Unit.Point(100);
        }
        ConfigureExport();
        grdBlueCreditHistory.MasterTableView.ExportToExcel();
    }

    private DataTable GetBlueCreditHistory()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", cmbPatients.SelectedValue},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@PatientStatusTypeID", cmbPublicStatus.SelectedValue},
                                {"@LocationID", cmbLocations.SelectedValue},
                                {"@ProviderID", cmbProviders.SelectedValue},
                                {"@CreditTypeID", cmbTypes.SelectedValue},
                                {"@CreditStatusTypeID", cmbStatus.SelectedValue},
                                {"@DateMin", dtDateMin.SelectedDate},
                                {"@DateMax", dtDateMax.SelectedDate},
                                {"@BalanceMin", txtAmountMin.Text},
                                {"@BalanceMax", txtAmountMax.Text},
                                {"@UserID", ClientSession.UserID}
                                };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_get", cmdParams);
    }

    protected void grdBlueCreditHistory_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdBlueCreditHistory.DataSource = GetBlueCreditHistory();
    }

    protected void grdBlueCreditHistory_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "ViewCreditAccountHistory":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["BlueCreditID"];
                ClientSession.ObjectID2 = ClientSession.SelectedPatientID;
                ClientSession.ObjectType = ObjectType.PFSReportDetail;
                popupCreditReport.VisibleOnPageLoad = true;
                break;

            case "ViewTransactionHistory":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["BlueCreditID"];
                popupTransactionHistory.VisibleOnPageLoad = true;
                break;

            case "EditCreditAccountHistory":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["BlueCreditID"];
                ClientSession.ObjectType = ObjectType.BlueCreditDetail;
                popupEditBlueCredit.VisibleOnPageLoad = true;
                break;
        }
    }

    protected void grdBlueCreditHistory_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var tupfsID = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["TUPFSID"].ToString();
            item["FICO"].Enabled = !string.IsNullOrEmpty(tupfsID);
            (item["FICO"].Controls[0] as ImageButton).ImageUrl = !string.IsNullOrEmpty(tupfsID) ? "~/Content/Images/icon_view.png" : "~/Content/Images/icon_cancelx_fade.gif";

        }
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        grdBlueCreditHistory.Rebind();
    }

    public void ConfigureExport()
    {
        grdBlueCreditHistory.ExportSettings.FileName = "BlueCredit Search Report";
        grdBlueCreditHistory.ExportSettings.ExportOnlyData = true;
        grdBlueCreditHistory.ExportSettings.IgnorePaging = true;

        grdBlueCreditHistory.MasterTableView.GetColumn("View").Visible = false;
    }

    #endregion

    protected void btnClear_Click(object sender, EventArgs e)
    {
        cmbPatients.ClearSelection();
        cmbPublicStatus.ClearSelection();
        cmbLocations.ClearSelection();
        cmbProviders.ClearSelection();
        cmbTypes.ClearSelection();
        cmbStatus.ClearSelection();
        dtDateMin.Clear();
        dtDateMax.Clear();
        txtAmountMin.Text = string.Empty;
        txtAmountMax.Text = string.Empty;

        foreach (var column in from GridColumn column in grdBlueCreditHistory.MasterTableView.Columns select column)
        {
            column.CurrentFilterFunction = GridKnownFunction.NoFilter;
            column.CurrentFilterValue = string.Empty;
        }
        grdBlueCreditHistory.MasterTableView.FilterExpression = string.Empty;
        grdBlueCreditHistory.MasterTableView.Rebind();
    }
}