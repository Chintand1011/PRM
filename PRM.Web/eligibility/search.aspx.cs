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
    #region Properties
    public bool FlagManageEligibility { get; set; }
    #endregion


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.EligibilityDetail)
                {
                    popupEligibility.VisibleOnPageLoad = true;
                    popupRequestBenefit.VisibleOnPageLoad = false;
                }

                BindCarriers();
                BindLocations();
                BindProviders();
                BindStates();
                BindStatus();
                BindCoverageTypes();
                ApplyValidations();
                dtDateMin.SelectedDate = EndDate;
                FlagManageEligibility = ClientSession.FlagManageElibility;

                ViewState["Eligibilities"] = new DataTable();
                ViewState["IsRebind"] = false;

            }
            catch (Exception)
            {
                throw;
            }
        }
        else
        {
            popupEligibility.VisibleOnPageLoad = false;
            popupRequestBenefit.VisibleOnPageLoad = false;
        }
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

    private void BindStates()
    {
        cmbPublicStatus.Items.Add(new RadComboBoxItem { Text = "All Statuses", Value = null });
        cmbPublicStatus.Items.Add(new RadComboBoxItem { Text = StatusType.Active.ToString(), Value = ((int)StatusType.Active).ToString("") });
        cmbPublicStatus.Items.Add(new RadComboBoxItem { Text = StatusType.InActive.ToString(), Value = ((int)StatusType.InActive).ToString("") });

        if (ClientSession.FlagPtSearchActiveDefault)
            cmbPublicStatus.SelectedValue = ((int)StatusType.Active).ToString();

    }
    private void BindCarriers()
    {
        var carriers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_carrier_list", new Dictionary<string, object>());
        carriers.InsertValueIntoDataTable(0, "CarrierID", "CarrierName", null, "All Carriers");
        cmbCarrier.DataSource = carriers;
        cmbCarrier.DataBind();
    }

    private void BindStatus()
    {
        var statuses = SqlHelper.ExecuteDataTableProcedureParams("web_pr_eligibilitystatustype_list", new Dictionary<string, object>());
        statuses.InsertValueIntoDataTable(0, "EligibilityStatusTypeID", "Abbr", null, "All Statuses");
        cmbStatus.DataSource = statuses;
        cmbStatus.DataBind();
    }

    private void BindCoverageTypes()
    {
        cmbCoverageType.Items.Add(new RadComboBoxItem { Text = "All Types", Value = null });
        cmbCoverageType.Items.Add(new RadComboBoxItem { Text = StatusType.Active.ToString(), Value = ((int)StatusType.Active).ToString("") });
        cmbCoverageType.Items.Add(new RadComboBoxItem { Text = StatusType.InActive.ToString(), Value = ((int)StatusType.InActive).ToString("") });
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

        foreach (GridColumn col in grdEligibilityHistory.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = Unit.Point(100);
        }
        ConfigureExport();
        grdEligibilityHistory.MasterTableView.ExportToExcel();
    }
    private DataTable GetEligibilityHistory()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", cmbPatients.SelectedValue},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@PtFlagActive", cmbPublicStatus.SelectedValue},
                                {"@LocationID", cmbLocations.SelectedValue},
                                {"@ProviderID", cmbProviders.SelectedValue},
                                {"@CarrierID", cmbCarrier.SelectedValue},
                                {"@EligibilityStatusTypeID", cmbStatus.SelectedValue},
                                {"@DateMin", dtDateMin.SelectedDate},
                                {"@DateMax", dtDateMax.SelectedDate},
                                {"@HBPFlagActive", cmbCoverageType.SelectedValue},
                                {"@UserID", ClientSession.UserID}
                                };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_eligibility_get", cmdParams);
    }

    protected void grdEligibilityHistory_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var eligibilities = ViewState["Eligibilities"] as DataTable;
        var isRebind = (bool)ViewState["IsRebind"];

        if (eligibilities.Rows.Count == 0 || isRebind)
        {
            eligibilities = GetEligibilityHistory();
            ViewState["Eligibilities"] = eligibilities;
            ViewState["IsRebind"] = false;
        }

        grdEligibilityHistory.DataSource = eligibilities;
    }
    protected void grdEligibilityHistory_PreRender(object sender, EventArgs e)
    {
        if (ClientSession.FlagManageElibility)
        {
            ClientSession.FlagManageElibility = false;
            grdEligibilityHistory.MasterTableView.GetColumn("Manage").Visible = true;
            grdEligibilityHistory.Rebind();
        }

    }
    protected void grdEligibilityHistory_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "ViewEligilityInfo":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["EligibilityID"];
                ClientSession.ObjectType = ObjectType.EligibilityDetail;
                popupEligibility.VisibleOnPageLoad = true;
                break;

            case "ManageEligibility":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["EligibilityID"];
                ClientSession.ObjectID2 = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PayerIDCode"];
                ClientSession.ObjectType = ObjectType.ManageEligibility;
                Response.Redirect("~/sysadmin/syseligmgr.aspx");
                break;

        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        ViewState["IsRebind"] = true;
        grdEligibilityHistory.Rebind();
    }
    protected void btnClear_Click(object sender, EventArgs e)
    {
        cmbPatients.ClearSelection();
        cmbPublicStatus.ResetSelection(ClientSession.FlagPtSearchActiveDefault, (int)StatusType.Active);
        cmbLocations.ResetSelection(ClientSession.FlagPtSearchLocationDefault, ClientSession.DefaultLocationID);
        cmbProviders.ResetSelection(ClientSession.FlagPtSearchProviderDefault, ClientSession.DefaultProviderID);
        cmbCarrier.ClearSelection();
        cmbStatus.ClearSelection();
        cmbCoverageType.ClearSelection();
        dtDateMin.Clear();
        dtDateMax.Clear();
    }
    public void ConfigureExport()
    {
        grdEligibilityHistory.ExportSettings.FileName = "Eligibility Search Report";
        grdEligibilityHistory.ExportSettings.ExportOnlyData = true;
        grdEligibilityHistory.ExportSettings.IgnorePaging = true;

        grdEligibilityHistory.MasterTableView.GetColumn("View").Visible = false;
    }

    #endregion

    private void ApplyValidations()
    {
        dtDateMin.MaxDate = DateTime.Now;
        dtDateMin.MinDate = DateTime.Now.AddMonths(-12);
        dtDateMax.MaxDate = DateTime.Now;

    }
}