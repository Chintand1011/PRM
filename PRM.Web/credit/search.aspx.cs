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
                BindLocations();
                BindProviders();
                BindPublicStatus();
                BindTypes();
                BindStatus();

                // Default values
                dtDateMin.SelectedDate = DateTime.Now.AddDays(-120);
                dtDateMax.SelectedDate = DateTime.Now;
                txtAmountMin.Text = "0.01";
                
                ViewState["Bluecredits"] = new DataTable();
                ViewState["IsRebind"] = false;
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


    private void BindLocations()
    {
        var cmdParams = new Dictionary<string, object> {
        {"@PracticeID", ClientSession.PracticeID}, };
        var locations = SqlHelper.ExecuteDataTableProcedureParams("web_pr_location_list", cmdParams);
        locations.InsertValueIntoDataTable(0, "LocationID", "Abbr", null, "All Locations");
        cmbLocations.DataSource = locations;
        cmbLocations.DataBind();

        if (ClientSession.FlagPtSearchLocationDefault)
            cmbLocations.SelectedValue = ClientSession.DefaultLocationID.ToString();
    }

    private void BindProviders()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } };
        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);
        providers.InsertValueIntoDataTable(0, "ProviderID", "ProviderAbbr", null, "All Providers");
        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();

        if (ClientSession.FlagPtSearchProviderDefault)
            cmbProviders.SelectedValue = ClientSession.DefaultProviderID.ToString();
    }

    private void BindPublicStatus()
    {
        var cmdParams = new Dictionary<string, object>();
        var statusTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statustype_list", cmdParams);
        statusTypes.InsertValueIntoDataTable(0, "StatusTypeID", "Abbr", null, "All Statuses");
        cmbPublicStatus.DataSource = statusTypes;
        cmbPublicStatus.DataBind();

        if (ClientSession.FlagPtSearchActiveDefault)
            cmbPublicStatus.SelectedValue = ((int)StatusType.Active).ToString();

    }

    private void BindTypes()
    {
        var types = SqlHelper.ExecuteDataTableProcedureParams("web_pr_credittype_list", new Dictionary<string, object>());
        types.InsertValueIntoDataTable(0, "CreditTypeID", "PlanName", null, "All Types");
        cmbTypes.DataSource = types;
        cmbTypes.DataBind();
    }

    private void BindStatus()
    {
        var statuses = SqlHelper.ExecuteDataTableProcedureParams("web_pr_creditstatustype_list", new Dictionary<string, object>());
        statuses.InsertValueIntoDataTable(0, "CreditStatusTypeID", "Abbr", null, "All Statuses");
        cmbStatus.DataSource = statuses;
        cmbStatus.DataBind();
    }

    #endregion

    #region Dropdown Events

    protected void cmbPatients_ItemsRequested(object sender, RadComboBoxItemsRequestedEventArgs e)
    {
        if (string.IsNullOrEmpty(e.Text) || e.Text.Length < 3)
            return;

        var cmdParams = new Dictionary<string, object>
        {
            { "@PracticeID", ClientSession.PracticeID },
            { "@LastName", e.Text },
            { "@StatusTypeID", ClientSession.FlagPtSearchActiveDefault ? 1 : (object)DBNull.Value },
        };
        var patients = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_search", cmdParams);

        //Binding the Combobox
        cmbPatients.DataSource = patients;
        cmbPatients.DataBind();

    }

    #endregion

    #region Grid Operations

    protected void btnReport_Click(object sender, EventArgs e)
    {
        AuditLog.CreateExportLog(Request.Url.AbsoluteUri);

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
        var bluecredits = ViewState["Bluecredits"] as DataTable;
        var isRebind = (bool)ViewState["IsRebind"];

        if (bluecredits.Rows.Count == 0 || isRebind)
        {
            bluecredits = GetBlueCreditHistory();
            ViewState["Bluecredits"] = bluecredits;
            ViewState["IsRebind"] = false;
        }

        grdBlueCreditHistory.DataSource = bluecredits;
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
                ClientSession.SelectedPatientID = Int32.Parse(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientID"].ToString()); 
                ClientSession.SelectedPatientAccountID = Int32.Parse(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["AccountID"].ToString());
                (new UserLogin()).LoadPatientIntoSession();
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
        ViewState["IsRebind"] = true;
        grdBlueCreditHistory.Rebind();
    }

    public void ConfigureExport()
    {
        grdBlueCreditHistory.ExportSettings.FileName = "BlueCredit Search Report";
        grdBlueCreditHistory.ExportSettings.ExportOnlyData = true;
        grdBlueCreditHistory.ExportSettings.IgnorePaging = true;
        
        grdBlueCreditHistory.MasterTableView.GetColumn("View").Visible = false;
        grdBlueCreditHistory.MasterTableView.GetColumn("Edit").Visible = false;
    }

    #endregion

    protected void btnClear_Click(object sender, EventArgs e)
    {
        cmbPatients.ClearSelection();
        cmbPatients.Text = string.Empty;
        cmbPublicStatus.ResetSelection(ClientSession.FlagPtSearchActiveDefault, (int)StatusType.Active);
        cmbLocations.ResetSelection(ClientSession.FlagPtSearchLocationDefault, ClientSession.DefaultLocationID);
        cmbProviders.ResetSelection(ClientSession.FlagPtSearchProviderDefault, ClientSession.DefaultProviderID);
        cmbTypes.ClearSelection();
        cmbStatus.ClearSelection();
        dtDateMin.Clear();
        dtDateMax.Clear();
        txtAmountMin.Text = string.Empty;
        txtAmountMax.Text = string.Empty;

        grdBlueCreditHistory.DataSource = new List<string>();
        grdBlueCreditHistory.DataBind();


        foreach (var column in from GridColumn column in grdBlueCreditHistory.MasterTableView.Columns select column)
        {
            column.CurrentFilterFunction = GridKnownFunction.NoFilter;
            column.CurrentFilterValue = string.Empty;
        }
        grdBlueCreditHistory.MasterTableView.FilterExpression = string.Empty;
        grdBlueCreditHistory.MasterTableView.Rebind();
    }
}