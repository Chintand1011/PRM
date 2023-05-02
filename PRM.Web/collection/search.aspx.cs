using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

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
                BindStates();
                BindTypes();
                BindStatus();
                dtDateMax.SelectedDate = EndDate;
                ViewState["Collections"] = new DataTable();
                ViewState["IsRebind"] = false;
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    protected void cmbPatients_ItemsRequested(object sender, RadComboBoxItemsRequestedEventArgs e)
    {
        if (string.IsNullOrEmpty(e.Text) || e.Text.Length < 3)
            return;

        var cmdParams = new Dictionary<string, object>
        {
            { "@PracticeID", ClientSession.PracticeID },
            { "@LastName", e.Text },
            { "@StatusTypeID", ClientSession.FlagPtSearchActiveDefault ? 1 : (object)DBNull.Value }
        };
        var patients = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_search", cmdParams);

        //Binding the Combobox
        cmbPatients.DataSource = patients;
        cmbPatients.DataBind();

    }

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

    private void BindStates()
    {
        cmbPublicStatus.Items.Add(new RadComboBoxItem { Text = "All Statuses", Value = null });
        cmbPublicStatus.Items.Add(new RadComboBoxItem { Text = StatusType.Active.ToString(), Value = ((int)StatusType.Active).ToString() });
        cmbPublicStatus.Items.Add(new RadComboBoxItem { Text = StatusType.InActive.ToString(), Value = ((int)StatusType.InActive).ToString() });

        if (ClientSession.FlagPtSearchActiveDefault)
            cmbPublicStatus.SelectedValue = ((int)StatusType.Active).ToString();

    }

    private void BindTypes()
    {
        var types = SqlHelper.ExecuteDataTableProcedureParams("web_pr_CollectionReasonType_list", new Dictionary<string, object>());
        cmbTypes.DataSource = types;
        cmbTypes.DataBind();
    }

    private void BindStatus()
    {
        var statuses = SqlHelper.ExecuteDataTableProcedureParams("web_pr_CollectionStatusType_list", new Dictionary<string, object>());
        cmbStatus.DataSource = statuses;
        cmbStatus.DataBind();
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        AuditLog.CreateExportLog(Request.Url.AbsoluteUri);

        foreach (GridColumn col in grdCollections.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = Unit.Point(100);
        }
        ConfigureExport();
        grdCollections.MasterTableView.ExportToExcel();
    }


    private DataTable GetCollections()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", cmbPatients.SelectedValue},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@PtFlagActive", cmbPublicStatus.SelectedValue},
                                {"@LocationID", cmbLocations.SelectedValue},
                                {"@ProviderID", cmbProviders.SelectedValue},
                                {"@CollectionReasonTypeID", cmbTypes.SelectedValue},
                                {"@CollectionStatusTypeID", cmbStatus.SelectedValue},
                                {"@DateMin", dtDateMin.SelectedDate},
                                {"@DateMax", dtDateMax.SelectedDate},
                                {"@AmountMin", txtAmountMin.Text},
                                {"@AmountMax", txtAmountMax.Text},
                                {"@UserID", ClientSession.UserID}
                                };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_account_get", cmdParams);
    }

    protected void grdCollections_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var collections = ViewState["Collections"] as DataTable;
        var isRebind = (bool)ViewState["IsRebind"];

        if (collections.Rows.Count == 0 || isRebind)
        {
            collections = GetCollections();
            ViewState["Collections"] = collections;
            ViewState["IsRebind"] = false;
        }

        grdCollections.DataSource = collections;
    }
    protected void grdAccount_OnItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var imgPayPlan = item.FindControl("imgPayPlan") as Image;
            var imgBlueCredit = item.FindControl("imgBlueCredit") as Image;
            var payPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagPayPlanAbbr"].ToString();
            var blueCredit = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagBlueCreditAbbr"].ToString();
            imgPayPlan.ImageUrl = payPlan == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";
            imgBlueCredit.ImageUrl = blueCredit == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";

        }
    }
    protected void grdCollections_OnItemCommand(object source, GridCommandEventArgs e)
    {

    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        ViewState["IsRebind"] = true;
        grdCollections.Rebind();
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        cmbPatients.ClearSelection();
        cmbPublicStatus.ResetSelection(ClientSession.FlagPtSearchActiveDefault, (int)StatusType.Active);
        cmbLocations.ResetSelection(ClientSession.FlagPtSearchLocationDefault, ClientSession.DefaultLocationID);
        cmbProviders.ResetSelection(ClientSession.FlagPtSearchProviderDefault, ClientSession.DefaultProviderID);
        cmbTypes.ClearSelection();
        cmbStatus.ClearSelection();
        dtDateMin.Clear();
        dtDateMax.SelectedDate = EndDate;
        txtAmountMin.Text = string.Empty;
        txtAmountMax.Text = string.Empty;

    }

    public void ConfigureExport()
    {
        grdCollections.ExportSettings.FileName = "Collection Search Report";
        grdCollections.ExportSettings.ExportOnlyData = true;
        grdCollections.ExportSettings.IgnorePaging = true;
        grdCollections.MasterTableView.GetColumn("View").Visible = false;
    }
}