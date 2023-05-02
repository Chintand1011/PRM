using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Windows.Forms;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using Telerik.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI.ExportInfrastructure;
using GridItemType = Telerik.Web.UI.GridItemType;

public partial class search : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                BindPatientStatus();
                BindLocations();
                BindProviders();
                BindCategoryTypes();
                BindTypes();
                BindStates();
                BindStatus();
                ViewState["IsExpandCollapse"] = false;
                ViewState["Transactions"] = new DataTable();
                ViewState["IsRebind"] = false;

                ApplyFilterValues();

                // For Grouping
                ViewState["GroupingState"] = true;
                EnableDisableGrouping(false);

            }
            catch (Exception)
            {
                throw;
            }
        }

        popupModifyTransaction.VisibleOnPageLoad = false;
        popupPaymentReceipt.VisibleOnPageLoad = false;
        popupEstimateView.VisibleOnPageLoad = false;
    }

    #region Populate Filter stuff On Page Load

    private void ApplyFilterValues()
    {
        var searchFilters = ClientSession.ObjectValue as Dictionary<string, object>;
        if (searchFilters != null && searchFilters.ContainsKey("AutoBindFilters"))
        {
            cmbPatients.SelectedValue = searchFilters["@PatientID"].ToString();
            cmbPublicStatus.SelectedValue = searchFilters["@PtFlagActive"].ToString();
            cmbLocations.SelectedValue = searchFilters["@LocationID"].ToString();
            cmbProviders.SelectedValue = searchFilters["@ProviderID"].ToString();
            cmbStates.SelectedValue = searchFilters["@TransactionStateTypeID"].ToString();
            cmbCategoryTypes.SelectedValue = searchFilters["@TransCategoryTypeID"].ToString();
            cmbTypes.SelectedValue = searchFilters["@TransactionTypeID"].ToString();
            cmbStatus.SelectedValue = searchFilters["@FSPFlagSuccess"].ToString();
            txtStatementID.Text = searchFilters["@StatementID"].ToString();

            if (searchFilters["@DateMin"] != null)
            {
                dtDateMin.SelectedDate = Convert.ToDateTime(searchFilters["@DateMin"]);    
            }

            if (searchFilters["@DateMax"] != null)
            {
                dtDateMax.SelectedDate = Convert.ToDateTime(searchFilters["@DateMax"]);
            }
            
            txtAmountMin.Text = searchFilters["@AmountMin"].ToString();
            txtAmountMax.Text = searchFilters["@AmountMax"].ToString();

            // Setting up page index
            grdTransactions.CurrentPageIndex = int.Parse(searchFilters["GridPageIndex"].ToString());

            // Expanding Search fields
            RadPanelBar1.Items[0].Expanded = true;

            searchFilters.Remove("AutoBindFilters");
            searchFilters.Remove("GridPageIndex");
        }
        else
        {
            dtDateMax.SelectedDate = DateTime.Now;
            // txtAmountMin.Text = "0.01";

            DateTime date;
            var dateParam = Request.Params["Date"];
            var isDateParsed = DateTime.TryParse(dateParam, out date);
            dtDateMin.SelectedDate = isDateParsed ? date : EndDate;

            if (isDateParsed)
            {
                RadPanelBar1.Items[0].Expanded = true;
                dtDateMax.SelectedDate = date;
            }
        }
    }

    #endregion

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
        var cmdParams = new Dictionary<string, object> {
        {"@PracticeID", ClientSession.PracticeID}};
        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);
        providers.InsertValueIntoDataTable(0, "ProviderID", "ProviderAbbr", null, "All Providers");
        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();

        if (ClientSession.FlagPtSearchProviderDefault)
            cmbProviders.SelectedValue = ClientSession.DefaultProviderID.ToString();
    }

    private void BindPatientStatus()
    {
        cmbPublicStatus.Items.Add(new RadComboBoxItem { Text = "All Statuses", Value = null });
        cmbPublicStatus.Items.Add(new RadComboBoxItem { Text = StatusType.Active.ToString(), Value = ((int)StatusType.Active).ToString("") });
        cmbPublicStatus.Items.Add(new RadComboBoxItem { Text = StatusType.InActive.ToString(), Value = ((int)StatusType.InActive).ToString("") });

        if (ClientSession.FlagPtSearchActiveDefault)
            cmbPublicStatus.SelectedIndex = 1;
    }

    private void BindCategoryTypes()
    {
        var cattypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transcategorytype_list", new Dictionary<string, object>());
        cattypes.InsertValueIntoDataTable(0, "TransCategoryTypeID", "Abbr", null, "All Categories");
        cmbCategoryTypes.DataSource = cattypes;
        cmbCategoryTypes.DataBind();
    }

    private void BindTypes(string transCategoryTypeID = "")
    {
        var types = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transtype_list", new Dictionary<string, object> { { "TransCategoryTypeID", transCategoryTypeID } });
        types.InsertValueIntoDataTable(0, "TransactionTypeID", "ServiceAbbr", null, "All Types");

        cmbTypes.ClearSelection();
        cmbTypes.DataSource = types;
        cmbTypes.DataBind();

        if (ViewState["Types"] == null)
        {
            ViewState["Types"] = types;
        }

    }

    private void BindStates()
    {
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transstatetype_list", new Dictionary<string, object>());
        states.InsertValueIntoDataTable(0, "TransactionStateTypeID", "StateAbbr", null, "All States");
        cmbStates.DataSource = states;
        cmbStates.DataBind();
    }

    private void BindStatus()
    {
        cmbStatus.Items.Add(new RadComboBoxItem { Text = "All Statuses", Value = null });
        cmbStatus.Items.Add(new RadComboBoxItem { Text = Status.Success.ToString(), Value = ((int)Status.Success).ToString("") });
        cmbStatus.Items.Add(new RadComboBoxItem { Text = Status.Failure.ToString(), Value = ((int)Status.Failure).ToString("") });
    }

    #endregion

    #region Dropdown Events

    protected void cmbCategoryTypes_OnClientSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        BindTypes(cmbCategoryTypes.SelectedValue);
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

    #endregion

    #region Grid Operations

    private DataTable GetTransactions(bool isGrouping = false)
    {
        var flagActive = string.IsNullOrEmpty(cmbPublicStatus.SelectedValue) ? "-1" : cmbPublicStatus.SelectedValue;
        var status = string.IsNullOrEmpty(cmbStatus.SelectedValue) ? "-1" : cmbStatus.SelectedValue;

        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", cmbPatients.SelectedValue},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@PtFlagActive", flagActive},
                                {"@LocationID", cmbLocations.SelectedValue},
                                {"@ProviderID", cmbProviders.SelectedValue},
                                {"@TransactionStateTypeID", cmbStates.SelectedValue},
                                {"@TransCategoryTypeID", cmbCategoryTypes.SelectedValue},
                                {"@TransactionTypeID", cmbTypes.SelectedValue},
                                {"@FSPFlagSuccess", status},
                                {"@StatementID", txtStatementID.Text},
                                {"@DateMin", dtDateMin.SelectedDate},
                                {"@DateMax", dtDateMax.SelectedDate},
                                {"@AmountMin", txtAmountMin.Text},
                                {"@AmountMax", txtAmountMax.Text},
                                {"@UserID", ClientSession.UserID}
                                };

        ClientSession.ObjectValue = cmdParams;

        var procedureName = !isGrouping ? "web_pr_transaction_get" : "web_pr_transaction_get_group";
        return SqlHelper.ExecuteDataTableProcedureParams(procedureName, cmdParams);
    }

    protected void grdTransactions_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var transactions = ViewState["Transactions"] as DataTable;
        var isRebind = (bool)ViewState["IsRebind"];

        if (transactions.Rows.Count == 0 || isRebind)
        {
            transactions = GetTransactions();
            ViewState["Transactions"] = transactions;
            ViewState["IsRebind"] = false;
            ViewState["IsGroupRecordsEmpty"] = null; // this will force to re-call the grouping proc
        }

        grdTransactions.DataSource = transactions;

    }

    protected void grdTransactions_OnPreRender(object sender, EventArgs e)
    {
        foreach (GridGroupHeaderItem groupheader in grdTransactions.MasterTableView.GetItems(GridItemType.GroupHeader))
        {
            var item = groupheader.GetChildItems();
            var dItem = item[item.Count() - 1] as GridDataItem;
            var patientName = dItem["PatientName"];
            //var doctorName = dItem["ProviderNameAbbr"];
            //var chargeAmount = dItem["Amount$"];
            var statementID = dItem["StatementID"];
            // groupheader.DataCell.Text = string.Format("Patient: {0}   ||   Doctor: {1}   ||   Charge Amount: {2}", patientName.Text, doctorName.Text, chargeAmount.Text);
            groupheader.DataCell.Text = string.Format("Patient: {0} / Statement: {1}", patientName.Text, statementID.Text);
        }

    }

    protected void btnShowHideGrouping_OnClick(object sender, EventArgs e)
    {
        var isShow = Convert.ToBoolean(ViewState["GroupingState"]);

        if (ViewState["IsGroupRecordsEmpty"] == null)
        {
            ViewState["Transactions"] = GetTransactions(true);
            ViewState["IsGroupRecordsEmpty"] = false;
        }

        if (isShow)
        {
            EnableDisableGrouping(true);
            ViewState["GroupingState"] = false;
        }
        else
        {
            EnableDisableGrouping(false);
            ViewState["GroupingState"] = true;
        }

    }

    protected void grdTransactions_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Modify":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["TransactionID"];
                ClientSession.ObjectType = ObjectType.Transaction;

                var searchParams = ClientSession.ObjectValue as Dictionary<string, object>;
                if (!searchParams.ContainsKey("AutoBindFilters"))
                {
                    searchParams.Add("AutoBindFilters", 1);
                    searchParams.Add("GridPageIndex", grdTransactions.CurrentPageIndex);
                }
                
                popupModifyTransaction.VisibleOnPageLoad = true;
                break;

            case "ViewTransaction":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectType = ObjectType.Statement;
                popupEstimateView.VisibleOnPageLoad = true;
                break;

            case "ViewReceipt":
                var transactionID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["TransactionID"];
                ClientSession.ObjectID = transactionID;
                ClientSession.ObjectType = ObjectType.PaymentReceipt;
                ClientSession.EnablePrinting = false;
                ClientSession.EnableClientSign = false;
                popupPaymentReceipt.VisibleOnPageLoad = true;
                break;
            case "ExpandCollapse":
                ViewState["IsExpandCollapse"] = true;
                break;

        }

    }

    protected void grdTransactions_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var isFlagLocked = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagLocked"]);
            var flagPending = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagPending"]);
            var isFlagVeryOld = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagVeryOld"]);
            var flagModify = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagModify"]);

            var imageButton = item["Modify"].Controls[0] as ImageButton;

            if (isFlagLocked)
            {
                item["Modify"].Enabled = false;
                imageButton.ImageUrl = "~/Content/Images/icon_lock.gif";
                return;
            }

            if (flagPending)
            {
                var message = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PendingTypeAbbr"].ToString();

                item["Modify"].Enabled = false;
                imageButton.ImageUrl = "~/Content/Images/icon_clock.gif";
                imageButton.ToolTip = message;
                return;
            }


            if (isFlagVeryOld)
            {
                item["Modify"].Enabled = false;
                imageButton.ImageUrl = "~/Content/Images/icon_waiting.png";
                imageButton.ToolTip = "The transaction can no longer be modified due to age.";
                return;
            }

            item["Modify"].Enabled = flagModify;
            imageButton.ImageUrl = flagModify ? "~/Content/Images/edit.png" : "~/Content/Images/icon_unavail.gif";

        }

    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        ViewState["IsRebind"] = true;
        grdTransactions.CurrentPageIndex = 0;
        grdTransactions.Rebind();
        ValidateandDisplayButton();
    }

    private void EnableDisableGrouping(bool isEnable)
    {
        btnSwitch.Visible = true;

        if (isEnable)
        {
            lblShowGridState.Text = "Group Related Transactions is ENABLED";
            var expression = GridGroupByExpression.Parse("GroupID Group By GroupID");
            grdTransactions.MasterTableView.GroupByExpressions.Add(expression);
            grdTransactions.MasterTableView.AllowNaturalSort = false;
            grdTransactions.Rebind();

            if (grdTransactions.MasterTableView.GroupByExpressions.Count <= 0) return;
            grdTransactions.MasterTableView.GroupByExpressions[0].GroupByFields[0].SortOrder = GridSortOrder.Descending;
            grdTransactions.Rebind();

            btnSwitch.ImageUrl = "../content/images/btn_disable.gif";
        }
        else
        {
            grdTransactions.MasterTableView.GroupByExpressions.Clear();
            grdTransactions.Rebind();
            btnSwitch.ImageUrl = "../content/images/btn_enable.gif";
            lblShowGridState.Text = "Group Related Transactions is DISABLED";
        }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        AuditLog.CreateExportLog(Request.Url.AbsoluteUri);

        foreach (GridColumn col in grdTransactions.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = col.UniqueName == "TransactionTypeAbbr" ? Unit.Point(130) : Unit.Point(100);
        }

        ConfigureExport();
        grdTransactions.MasterTableView.ExportToExcel();
    }

    public void ConfigureExport()
    {
        grdTransactions.ExportSettings.FileName = "Transaction Search Report";
        grdTransactions.ExportSettings.ExportOnlyData = false;
        grdTransactions.ExportSettings.IgnorePaging = true;

        grdTransactions.MasterTableView.GetColumn("View").Visible = false;
        grdTransactions.MasterTableView.GetColumn("Modify").Visible = false;
        grdTransactions.MasterTableView.GetColumn("Receipt").Visible = false;
    }

    private void ValidateandDisplayButton()
    {
        if (grdTransactions.Items.Count == 0)
        {
            lblShowGridState.Text = string.Empty;
            btnSwitch.Visible = false;
        }
        else
        {
            EnableDisableGrouping(false);
        }
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
        hdnRedirectToTransactions.Value = "1";
    }
    
    #endregion

    #region Save Transaction Notes

    public void btnUpdate_OnClick(object sender, EventArgs e)
    {
        var cmdParams = new Dictionary<string, object>
                        {
                            {"UserID", ClientSession.UserID},
                            {"TransactionID", hdnTransactionID.Value},
                            {"Notes", hdnNotes.Value}
                        };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_transnotes_add", cmdParams);

        var transactions = ViewState["Transactions"] as DataTable;
        var transaction = transactions.Select("TransactionID = " + hdnTransactionID.Value);
        transaction[0]["Notes"] = hdnNotes.Value;

        grdTransactions.Rebind();
        RadWindowManager1.RadAlert("Record successfully updated.", 350, 150, "", "", "../Content/Images/success.png");
    }

    #endregion

    #region Clear Data

    protected void btnClear_OnClick(object sender, EventArgs e)
    {
        cmbPatients.ClearSelection();
        cmbPatients.Text = string.Empty;
        cmbPublicStatus.ResetSelection(ClientSession.FlagPtSearchActiveDefault, (int)StatusType.Active);
        cmbLocations.ResetSelection(ClientSession.FlagPtSearchLocationDefault, ClientSession.DefaultLocationID);
        cmbProviders.ResetSelection(ClientSession.FlagPtSearchProviderDefault, ClientSession.DefaultProviderID);
        cmbStates.ClearSelection();
        cmbCategoryTypes.ClearSelection();
        cmbTypes.ClearSelection();
        cmbStatus.ClearSelection();
        dtDateMin.Clear();
        dtDateMax.Clear();
        txtAmountMin.Text = string.Empty;
        txtAmountMax.Text = string.Empty;
        lblShowGridState.Text = string.Empty;
        btnSwitch.Visible = false;

        grdTransactions.DataSource = new List<string>();
        grdTransactions.DataBind();


        // Binding Types 
        var types = ViewState["Types"] as DataTable;
        cmbTypes.DataSource = types;
        cmbTypes.DataBind();

        // For Grouping
        EnableDisableGrouping(false);
        ViewState["GroupingState"] = true;

    }

    #endregion


}