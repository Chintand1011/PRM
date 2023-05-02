using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class search : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // Binding the dropdowns
                BindPractices();
                BindLocations();
                BindAuditTypes();
                BindSysUsers();

                // Default values
                dtDateMin.SelectedDate = DateTime.Now.AddDays(-30);
                dtDateMax.SelectedDate = DateTime.Now;

                // Initializing the new viewtate of User Actions and InRebind
                // UserActions would be use for holding the data from proc and IsRebind is a flag which is let us know that wheather we need to call the proc again or not
                ViewState["UserActions"] = new DataTable();
                ViewState["IsRebind"] = false;
            }
            catch (Exception)
            {
                throw;
            }
        }

        popupProgress.VisibleOnPageLoad = false;
    }

    #region Bind Dropdown

    private void BindPractices()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } }; // This will insert two columns in datatable at mentioned index
        var practices = SqlHelper.ExecuteDataTableProcedureParams("web_pr_practice_list", cmdParams);
        practices.InsertValueIntoDataTable(0, "PracticeID", "Abbr", null, "All Practices"); 
        cmbPractices.DataSource = practices;
        cmbPractices.DataBind();

        cmbPractices.SelectedValue = ClientSession.PracticeID.ToString();
    }

    private void BindLocations()
    {
        var cmdParams = new Dictionary<string, object> { {"@PracticeID", cmbPractices.SelectedValue}, }; 
        var locations = SqlHelper.ExecuteDataTableProcedureParams("web_pr_location_list", cmdParams);
        locations.InsertValueIntoDataTable(0, "LocationID", "Abbr", null, "All Locations");
        cmbLocations.DataSource = locations;
        cmbLocations.DataBind();

        if (ClientSession.FlagPtSearchLocationDefault)
            cmbLocations.SelectedValue = ClientSession.DefaultLocationID.ToString();
    }

    private void BindAuditTypes()
    {
        var audittypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_audittype_list", new Dictionary<string, object>());
        audittypes.InsertValueIntoDataTable(0, "AuditTypeID", "Abbr", null, "All Statuses");
        cmbAuditTypes.DataSource = audittypes;
        cmbAuditTypes.DataBind();
    }

    private void BindSysUsers()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", cmbPractices.SelectedValue }, }; 
        var sysusers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_user_get", cmdParams);
        sysusers.InsertValueIntoDataTable(0, "SysUserID", "NameAbbr", null, "All Users");
        cmbSysUsers.DataSource = sysusers;
        cmbSysUsers.DataBind();

    }

    #endregion

    #region Dropdown Events

    protected void cmbPatients_ItemsRequested(object sender, RadComboBoxItemsRequestedEventArgs e)
    {
        if (string.IsNullOrEmpty(e.Text) || e.Text.Length < 3)
            return;

        var cmdParams = new Dictionary<string, object>
        {
            { "@PracticeID", cmbPractices.SelectedValue },
            { "@LastName", e.Text },
            { "@StatusTypeID", ClientSession.FlagPtSearchActiveDefault ? 1 : (object)DBNull.Value }
        };
        var patients = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_search", cmdParams);

        //Binding the Combobox
        cmbPatients.DataSource = patients;
        cmbPatients.DataBind();

    }

    protected void cmbPractice_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        BindSysUsers();
        BindLocations();
    }

    #endregion

    #region Grid Events

    protected void btnReport_Click(object sender, EventArgs e)
    {
        // Increasing the width of the columns for excel
        foreach (GridColumn col in grdUserActions.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = col.UniqueName == "ProviderName" || col.UniqueName == "PatientName" ? Unit.Point(130) : Unit.Point(100);
        }
        // Managing the Options for the Excel
        ConfigureExport();
        // Converting the Grid list into excel
        grdUserActions.MasterTableView.ExportToExcel();

    }

    private DataTable GetUserActions()
    {

        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID", cmbPractices.SelectedValue},
                                {"@AuditTypeID", cmbAuditTypes.SelectedValue},
                                {"@DateMin", dtDateMin.SelectedDate},
                                {"@DateMax", dtDateMax.SelectedDate},
                                {"@SysUserID", ClientSession.UserID},
                                {"@UserID", ClientSession.UserID}
                                };

        ClientSession.ObjectValue = cmdParams;

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_audituseraction_get", cmdParams);
    }

    protected void grdUserActions_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var useractions = ViewState["UserActions"] as DataTable;
        var isRebind = (bool)ViewState["IsRebind"];

        if (useractions.Rows.Count == 0 || isRebind)
        {
            useractions = GetUserActions();
            ViewState["UserActionss"] = useractions;
            ViewState["IsRebind"] = false;
        }
        grdUserActions.DataSource = useractions;
    }
    

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        // enabling flag to allow system for recall the proc
        ViewState["IsRebind"] = true;
        grdUserActions.Rebind();
    }

    public void ConfigureExport()
    {
        grdUserActions.ExportSettings.FileName = "User Action Report";
        grdUserActions.ExportSettings.ExportOnlyData = true;
        grdUserActions.ExportSettings.IgnorePaging = true;
    }

    #endregion

    #region Validation

    protected void btnClear_Click(object sender, EventArgs e)
    {
        // clearing all 
        cmbPatients.ClearSelection();
        cmbPatients.Text = string.Empty;
        cmbPractices.ClearSelection();
        cmbLocations.ClearSelection();
        cmbSysUsers.ClearSelection();
        cmbAuditTypes.ClearSelection();
        dtDateMin.Clear();
        dtDateMax.Clear();
        grdUserActions.DataSource = new List<string>();
        grdUserActions.DataBind();
    }

    #endregion


}