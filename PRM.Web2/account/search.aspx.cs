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

    /* *************************************************
     *   Need to check Maximum Content length, currently its working with 50MB for 10k records 
     *   In case of error we only need to increase the content length in web.config file
     *   
     * *************************************************/

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // Binding the dropdowns
                BindLocations();
                BindProviders();
                BindStates();
                BindTypes();
                BindStatus();
                ViewState["Accounts"] = new DataTable();
                ViewState["IsRebind"] = false;
                txtAmountMin.Text = "0.01";
            }
            catch (Exception)
            {

                throw;
            }
        }
    }


    #region Bind Dropdown

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

    private void BindTypes()
    {
        var types = SqlHelper.ExecuteDataTableProcedureParams("web_pr_accounttype_list", new Dictionary<string, object>());
        cmbTypes.DataSource = types;
        cmbTypes.DataBind();
    }

    private void BindStatus()
    {
        var statuses = SqlHelper.ExecuteDataTableProcedureParams("web_pr_accountstatustype_list", new Dictionary<string, object>());
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

    #region Grid Events

    protected void grdAccount_OnItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            // getting the object of the images from the grid.
            var imgPayPlan = item.FindControl("imgPayPlan") as Image;
            var imgBlueCredit = item.FindControl("imgBlueCredit") as Image;
            // getting the values in order to compare
            var payPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagPayPlanAbbr"].ToString();
            var blueCredit = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagBlueCreditAbbr"].ToString();
            // if Payplan or Bluecredit is yes then displaying the Icon Yes else No
            imgPayPlan.ImageUrl = payPlan == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";
            imgBlueCredit.ImageUrl = blueCredit == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";

        }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        AuditLog.CreateExportLog(Request.Url.AbsoluteUri);

        // Adding the width in the cloumns in the Excel file
        foreach (GridColumn col in grdAccount.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = col.UniqueName == "ProviderName" || col.UniqueName == "PatientName" ? Unit.Point(130) : Unit.Point(100);
        }
        // Managing export options
        ConfigureExport();
        // Converting Grid's lists into the Excel file
        grdAccount.MasterTableView.ExportToExcel();

    }

    private DataTable GetBlueCreditHistory()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", cmbPatients.SelectedValue},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@PtFlagActive", cmbPublicStatus.SelectedValue},
                                {"@LocationID", cmbLocations.SelectedValue},
                                {"@ProviderID", cmbProviders.SelectedValue},
                                {"@AccountTypeID", cmbTypes.SelectedValue},
                                {"@AccountStatusTypeID", cmbStatus.SelectedValue},
                                {"@DateMin", dtDateMin.SelectedDate},
                                {"@DateMax", dtDateMax.SelectedDate},
                                {"@AmountMin", txtAmountMin.Text},
                                {"@AmountMax", txtAmountMax.Text},
                                {"@UserID", ClientSession.UserID}
                                };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_account_get", cmdParams);
    }


    protected void grdAccount_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var accounts = ViewState["Accounts"] as DataTable;
        var isRebind = (bool)ViewState["IsRebind"];

        if (accounts.Rows.Count == 0 || isRebind)
        {
            accounts = GetBlueCreditHistory();
            ViewState["Accounts"] = accounts;
            ViewState["IsRebind"] = false;
        }

        grdAccount.DataSource = accounts;
    }

    protected void grdAccount_OnItemCommand(object source, GridCommandEventArgs e)
    {

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        ViewState["IsRebind"] = true;
        grdAccount.Rebind();
    }

    public void ConfigureExport()
    {
        grdAccount.ExportSettings.FileName = "Account Search Report";
        grdAccount.ExportSettings.ExportOnlyData = true;
        grdAccount.ExportSettings.IgnorePaging = true;

        grdAccount.MasterTableView.GetColumn("Bluecredit").Visible = false;
        grdAccount.MasterTableView.GetColumn("PlayPlan").Visible = false;
        grdAccount.MasterTableView.GetColumn("View").Visible = false;
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
        cmbTypes.ClearSelection();
        cmbStatus.ClearSelection();
        dtDateMin.Clear();
        dtDateMax.Clear();
        txtAmountMin.Text = string.Empty;
        txtAmountMax.Text = string.Empty;
        grdAccount.DataSource = new List<string>();
        grdAccount.DataBind();
    }




    #endregion

}