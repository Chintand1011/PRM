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
                BindLocations();
                BindProviders();
                BindStates();
                BindStatus();

                // Default values
                dtDateMin.SelectedDate = DateTime.Now.AddDays(-120);
                dtDateMax.SelectedDate = DateTime.Now;
                txtAmountMin.Text = "0.01";

                // Initializing the new viewtate of statements and InRebind
                // Statements would be use for holding the data from proc and IsRebind is a flag which is let us know that wheather we need to call the proc again or not
                ViewState["Statements"] = new DataTable();
                ViewState["IsRebind"] = false;
            }
            catch (Exception)
            {
                throw;
            }
        }

        popupEstimateView.VisibleOnPageLoad = false;
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
        providers.InsertValueIntoDataTable(0, "ProviderID", "ProviderAbbr", null, "All Providers"); // This will insert two columns in datatable at mentioned index
        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();

        if (ClientSession.FlagPtSearchProviderDefault)
            cmbProviders.SelectedValue = ClientSession.DefaultProviderID.ToString();
    }

    private void BindStates()
    {
        cmbPatientStatus.Items.Add(new RadComboBoxItem { Text = "All Statuses", Value = null });
        cmbPatientStatus.Items.Add(new RadComboBoxItem { Text = StatusType.Active.ToString(), Value = ((int)StatusType.Active).ToString("") });
        cmbPatientStatus.Items.Add(new RadComboBoxItem { Text = StatusType.InActive.ToString(), Value = ((int)StatusType.InActive).ToString("") });

        if (ClientSession.FlagPtSearchActiveDefault)
            cmbPatientStatus.SelectedValue = ((int)StatusType.Active).ToString();

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

    #region Grid Events

    protected void grdStatements_OnItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            // Displaying Auto Pay Image
            var item = (GridDataItem)e.Item;
            var imgAutoPay = item.FindControl("imgAutoPay") as Image;
            var flagAutoPay = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagAutoPay"]);
            imgAutoPay.ImageUrl = flagAutoPay ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";
        }
    }

    protected void grdStatements_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {

            case "View":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectType = ObjectType.Statement;
                popupEstimateView.VisibleOnPageLoad = true;
                break;


            case "Download":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectType = ObjectType.Statement;
                var filePathUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FilePathStatements"].ToString();
                var fileName = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FileName"].ToString();
                ViewState["FilePath"] = GetFilePath(filePathUrl, fileName);
                hdnDownload.Value = "1";
                break;
        }

    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        AuditLog.CreateExportLog(Request.Url.AbsoluteUri);

        // Increasing the width of the columns for excel
        foreach (GridColumn col in grdStatements.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = col.UniqueName == "ProviderName" || col.UniqueName == "PatientName" ? Unit.Point(130) : Unit.Point(100);
        }
        // Managing the Options for the Excel
        ConfigureExport();
        // Converting the Grid list into excel
        grdStatements.MasterTableView.ExportToExcel();

    }

    private DataTable GetStatements()
    {
        var ptFlagActive = string.IsNullOrEmpty(cmbPatientStatus.SelectedValue) ? "-1" : cmbPatientStatus.SelectedValue;

        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", cmbPatients.SelectedValue},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@PtFlagActive", ptFlagActive},
                                {"@LocationID", cmbLocations.SelectedValue},
                                {"@ProviderID", cmbProviders.SelectedValue},
                                {"@CreditStatusTypeID", cmbStatus.SelectedValue},
                                {"@StatementID", txtStatementID.Text},
                                {"@DateMin", dtDateMin.SelectedDate},
                                {"@DateMax", dtDateMax.SelectedDate},
                                {"@BalanceMin", txtAmountMin.Text},
                                {"@BalanceMax", txtAmountMax.Text},
                                { "@UserID", ClientSession.UserID}
                                };

        ClientSession.ObjectValue = cmdParams;

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
    }

    protected void grdStatements_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var statements = ViewState["Statements"] as DataTable;
        var isRebind = (bool)ViewState["IsRebind"];

        if (statements.Rows.Count == 0 || isRebind)
        {
            statements = GetStatements();
            ViewState["Statements"] = statements;
            ViewState["IsRebind"] = false;
        }
        grdStatements.DataSource = statements;
    }
    

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        // enabling flag to allow system for recall the proc
        ViewState["IsRebind"] = true;
        grdStatements.Rebind();
    }

    public void ConfigureExport()
    {
        grdStatements.ExportSettings.FileName = "Statement Search Report";
        grdStatements.ExportSettings.ExportOnlyData = true;
        grdStatements.ExportSettings.IgnorePaging = true;

        grdStatements.MasterTableView.GetColumn("View").Visible = false;
        grdStatements.MasterTableView.GetColumn("DownloadPdf").Visible = false;
    }

    protected void lnkLoadPatientIntoSession_OnClick(object sender, EventArgs e)
    {
        var linkButton = (sender as LinkButton);
        var dataItem = linkButton.NamingContainer as GridDataItem;

        var patientID = Int32.Parse(dataItem.GetDataKeyValue("PatientID").ToString());
        var accountID = Int32.Parse(dataItem.GetDataKeyValue("AccountID").ToString());

        ClientSession.SelectedPatientID = patientID;
        ClientSession.SelectedPatientAccountID = accountID;

        (new UserLogin()).LoadPatientIntoSession();
        hdnRedirectToStatement.Value = "1";
    }

    #endregion

    #region Validation

    protected void btnClear_Click(object sender, EventArgs e)
    {
        // clearing all 
        cmbPatients.ClearSelection();
        cmbPatients.Text = string.Empty;
        cmbPatientStatus.ResetSelection(ClientSession.FlagPtSearchActiveDefault, (int)StatusType.Active);
        cmbLocations.ResetSelection(ClientSession.FlagPtSearchLocationDefault, ClientSession.DefaultLocationID);
        cmbProviders.ResetSelection(ClientSession.FlagPtSearchProviderDefault, ClientSession.DefaultProviderID);
        cmbStatus.ClearSelection();
        txtStatementID.Text = string.Empty;
        dtDateMin.Clear();
        dtDateMax.Clear();
        txtAmountMin.Text = string.Empty;
        txtAmountMax.Text = string.Empty;
        grdStatements.DataSource = new List<string>();
        grdStatements.DataBind();
    }

    #endregion

    #region Download

    protected void btnDownload_Click(object sender, EventArgs e)
    {
        var defaultPath = ViewState["FilePath"].ToString();
        var returnmsg = PDFServices.FileDownload(defaultPath, "Statement.pdf");
        if (returnmsg != "")
        {
            defaultPath = Path.GetDirectoryName(defaultPath);
            var url = ClientSession.WebPathRootProvider + "report/estimateview_popup.aspx?StatementID=" + ClientSession.ObjectID;
            PDFServices.PDFCreate("Statement.pdf", url, defaultPath);
            PDFServices.DownloadandDeleteFile(defaultPath, "Statement.pdf");
        }
    }

    private string GetFilePath(string fileUrl, string fileName)
    {
        return Path.Combine(fileUrl, fileName);
    }

    #endregion

}