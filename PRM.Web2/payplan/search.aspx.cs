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
                BindStatus();

                // Default values
                dtDateMin.SelectedDate = DateTime.Now.AddDays(-120);
                dtDateMax.SelectedDate = DateTime.Now;
                txtAmountMin.Text = "0.01";
                
                ViewState["PayPlans"] = new DataTable();
                ViewState["IsRebind"] = false;

            }
            catch (Exception)
            {

                throw;
            }
        }

        popupCreditReport.VisibleOnPageLoad = false;
        popupPaymentPlan.VisibleOnPageLoad = false;
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
        var cmdParams = new Dictionary<string, object> { {"@PracticeID", ClientSession.PracticeID} };
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
            { "@StatusTypeID", ClientSession.FlagPtSearchActiveDefault ? 1 : (object)DBNull.Value }
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

        foreach (GridColumn col in grdViewPlanHistory.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = Unit.Point(100);
        }
        ConfigureExport();
        grdViewPlanHistory.MasterTableView.ExportToExcel();
    }

    private DataTable GetPaymentPlanHistory()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", cmbPatients.SelectedValue},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@PatientStatusTypeID", cmbPublicStatus.SelectedValue},
                                {"@LocationID", cmbLocations.SelectedValue},
                                {"@ProviderID", cmbProviders.SelectedValue},
                                {"@CreditStatusTypeID", cmbStatus.SelectedValue},
                                {"@DateMin", dtDateMin.SelectedDate},
                                {"@DateMax", dtDateMax.SelectedDate},
                                {"@BalanceMin", txtAmountMin.Text},
                                {"@BalanceMax", txtAmountMax.Text},
                                {"@UserID", ClientSession.UserID}
                                };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentplan_get", cmdParams);
    }

    protected void grdViewPlanHistory_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var payPlans = ViewState["PayPlans"] as DataTable;
        var isRebind = (bool)ViewState["IsRebind"];

        if (payPlans.Rows.Count == 0 || isRebind)
        {
            payPlans = GetPaymentPlanHistory();
            ViewState["PayPlans"] = payPlans;
            ViewState["IsRebind"] = false;
        }

        grdViewPlanHistory.DataSource = payPlans;
    }

    protected void grdBlueCreditHistory_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {

            case "EditPlan":
                 ClientSession.SelectedPatientID = Int32.Parse(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientID"].ToString()); 
                ClientSession.SelectedPatientAccountID = Int32.Parse(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["AccountID"].ToString());
                
                (new UserLogin()).LoadPatientIntoSession();

                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectID2 = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentPlanID"];
                ClientSession.ObjectValue = (decimal)e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["Balance"];
                ClientSession.ObjectType = ObjectType.EditPaymentPlan;
                // InitializePaymentPlanPopup(statementBalance, (Int32)(ClientSession.ObjectID2));
                popupPaymentPlan.VisibleOnPageLoad = true;
                break;
        }
    }

    public void ConfigureExport()
    {
        grdViewPlanHistory.ExportSettings.FileName = "PaymentPlan Search Report";
        grdViewPlanHistory.ExportSettings.ExportOnlyData = true;
        grdViewPlanHistory.ExportSettings.IgnorePaging = true;
        grdViewPlanHistory.MasterTableView.GetColumn("Edit").Visible = false;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        ViewState["IsRebind"] = true;
        grdViewPlanHistory.Rebind();
    }

    #endregion

    #region Validations

    protected void btnClear_Click(object sender, EventArgs e)
    {
        cmbPatients.ClearSelection();
        cmbPatients.Text = string.Empty;
        cmbPublicStatus.ResetSelection(ClientSession.FlagPtSearchActiveDefault, (int)StatusType.Active);
        cmbLocations.ResetSelection(ClientSession.FlagPtSearchLocationDefault, ClientSession.DefaultLocationID);
        cmbProviders.ResetSelection(ClientSession.FlagPtSearchProviderDefault, ClientSession.DefaultProviderID);
        cmbStatus.ClearSelection();
        dtDateMin.Clear();
        dtDateMax.Clear();
        txtAmountMin.Text = string.Empty;
        txtAmountMax.Text = string.Empty;

        grdViewPlanHistory.DataSource = new List<string>();
        grdViewPlanHistory.DataBind();

        foreach (GridColumn column in grdViewPlanHistory.MasterTableView.Columns)
        {
            column.CurrentFilterFunction = GridKnownFunction.NoFilter;
            column.CurrentFilterValue = string.Empty;
        }
        grdViewPlanHistory.MasterTableView.FilterExpression = string.Empty;
        grdViewPlanHistory.MasterTableView.Rebind();
    }


    #endregion

}