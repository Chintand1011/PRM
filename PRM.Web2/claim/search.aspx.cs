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
                ViewState["Claims"] = new DataTable();
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
        var types = SqlHelper.ExecuteDataTableProcedureParams("web_pr_claimtype_list", new Dictionary<string, object>());
        cmbTypes.DataSource = types;
        cmbTypes.DataBind();
    }

    private void BindStatus()
    {
        var statuses = SqlHelper.ExecuteDataTableProcedureParams("web_pr_claimstatustype_list", new Dictionary<string, object>());
        cmbStatus.DataSource = statuses;
        cmbStatus.DataBind();
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        AuditLog.CreateExportLog(Request.Url.AbsoluteUri);

        foreach (GridColumn col in grdClaims.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = Unit.Point(100);
        }
        ConfigureExport();
        grdClaims.MasterTableView.ExportToExcel();
    }

    private DataTable GetClaims()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", cmbPatients.SelectedValue},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@PtFlagActive", cmbPublicStatus.SelectedValue},
                                {"@LocationID", cmbLocations.SelectedValue},
                                {"@ProviderID", cmbProviders.SelectedValue},
                                {"@ClaimTypeID", cmbTypes.SelectedValue},
                                {"@ClaimStatusTypeID", cmbStatus.SelectedValue},
                                {"@DateMin", dtDateMin.SelectedDate},
                                {"@DateMax", dtDateMax.SelectedDate},
                                {"@AmountMin", txtAmountMin.Text},
                                {"@AmountMax", txtAmountMax.Text},
                                {"@UserID", ClientSession.UserID}
                                };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_claim_get", cmdParams);
    }

    protected void grdClaims_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {

        var claims = ViewState["Claims"] as DataTable;
        var isRebind = (bool)ViewState["IsRebind"];

        if (claims.Rows.Count == 0 || isRebind)
        {
            claims = GetClaims();
            ViewState["Claims"] = claims;
            ViewState["IsRebind"] = false;
        }

        grdClaims.DataSource = claims;
    }

    protected void grdClaims_OnItemCommand(object source, GridCommandEventArgs e)
    {

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        ViewState["IsRebind"] = true;
        grdClaims.Rebind();
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
        dtDateMax.Clear();
        txtAmountMin.Text = string.Empty;
        txtAmountMax.Text = string.Empty;

    }


    public void ConfigureExport()
    {
        grdClaims.ExportSettings.FileName = "Claim Search Report";
        grdClaims.ExportSettings.ExportOnlyData = true;
        grdClaims.ExportSettings.IgnorePaging = true;
        grdClaims.MasterTableView.GetColumn("View").Visible = false;
    }
}