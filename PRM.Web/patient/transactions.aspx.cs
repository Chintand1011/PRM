using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class transactions : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {

                BindLocations();
                BindProviders();
                BindCategoryTypes();
                BindTypes();
                BindStates();
                BindStatus();

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
        popupEstimateView.VisibleOnPageLoad = false;
        popupModifyTransaction.VisibleOnPageLoad = false;
        popupPaymentReceipt.VisibleOnPageLoad = false;
    }


    private void ApplyFilterValues()
    {
        var searchFilters = ClientSession.ObjectValue as Dictionary<string, object>;
        if (searchFilters != null && searchFilters.ContainsKey("AutoBindFilters"))
        {
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
            // Applying value for Status
            var status = Request.Params["Status"];
            if (!string.IsNullOrEmpty(status) && status.Equals("0"))
            {
                cmbStatus.SelectedValue = ((int)Status.Failure).ToString();
            }

            var statementID = Request.Params["StatementID"];
            if (!string.IsNullOrEmpty(statementID))
            {
                txtStatementID.Text = statementID;
            }
        }
    }

    #region Bind Dropdowns

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
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } };
        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);
        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();
    }

    private void BindCategoryTypes()
    {
        var cattypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transcategorytype_list", new Dictionary<string, object>());
        cmbCategoryTypes.DataSource = cattypes;
        cmbCategoryTypes.DataBind();
    }

    private void BindTypes(string transCategoryTypeID = "")
    {
        var types = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transtype_list", new Dictionary<string, object> { { "TransCategoryTypeID", transCategoryTypeID } });
        cmbTypes.ClearSelection();
        cmbTypes.DataSource = types;
        cmbTypes.DataBind();
    }

    private void BindStates()
    {
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transstatetype_list", new Dictionary<string, object>());
        cmbStates.DataSource = states;
        cmbStates.DataBind();
    }

    private void BindStatus()
    {
        cmbStatus.Items.Add(new RadComboBoxItem { Text = Status.Success.ToString(), Value = ((int)Status.Success).ToString("") });
        cmbStatus.Items.Add(new RadComboBoxItem { Text = Status.Failure.ToString(), Value = ((int)Status.Failure).ToString("") });
    }

    #endregion

    #region Grip Operations

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        grdTransactions.CurrentPageIndex = 0;
        grdTransactions.Rebind();
        ValidateandDisplayButton();
    }

    private DataTable GetTransactions()
    {
        var status = string.IsNullOrEmpty(cmbStatus.SelectedValue) ? "-1" : cmbStatus.SelectedValue;

        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", ClientSession.SelectedPatientID},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@PtFlagActive", (int)StatusType.Active},
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

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_transaction_get", cmdParams);
    }


    protected void grdTransactions_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdTransactions.DataSource = GetTransactions();
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

        }
    }

    protected void grdTransactions_OnDataBound(object sender, EventArgs e)
    {
        if (grdTransactions.MasterTableView.Items.Count != 0) return;
        lblShowGridState.Text = string.Empty;
        btnSwitch.Visible = false;
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

    private void EnableSort()
    {
        lblShowGridState.Text = "Group Related Transactions is ENABLED";
        btnSwitch.Visible = true;
        var expression = GridGroupByExpression.Parse("GroupID Group By GroupID");
        grdTransactions.MasterTableView.GroupByExpressions.Add(expression);
        grdTransactions.Rebind();

        if (grdTransactions.MasterTableView.GroupByExpressions.Count <= 0) return;
        grdTransactions.MasterTableView.GroupByExpressions[0].GroupByFields[0].SortOrder = GridSortOrder.Descending;
        grdTransactions.Rebind();
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        foreach (GridColumn col in grdTransactions.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = col.UniqueName == "TransactionTypeAbbr" ? Unit.Point(130) : Unit.Point(100);
        }
        ConfigureExport();
        grdTransactions.MasterTableView.ExportToExcel();
    }

    public void ConfigureExport()
    {
        grdTransactions.ExportSettings.FileName = "Patient Transactions Report";
        grdTransactions.ExportSettings.ExportOnlyData = false;
        grdTransactions.ExportSettings.IgnorePaging = true;

        grdTransactions.MasterTableView.GetColumn("View").Visible = false;
        grdTransactions.MasterTableView.GetColumn("Modify").Visible = false;
        grdTransactions.MasterTableView.GetColumn("Receipt").Visible = false;
    }

    protected void btnShowHideGrouping_OnClick(object sender, EventArgs e)
    {
        var isShow = Convert.ToBoolean(ViewState["GroupingState"]);

        if (isShow)
        {
            EnableSort();
            ViewState["GroupingState"] = false;
            btnSwitch.ImageUrl = "../content/images/btn_disable.gif";
        }
        else
        {
            grdTransactions.MasterTableView.GroupByExpressions.Clear();
            grdTransactions.Rebind();
            lblShowGridState.Text = "Group Related Transactions is DISABLED";
            ViewState["GroupingState"] = true;
            btnSwitch.ImageUrl = "../content/images/btn_enable.gif";
        }

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

    private void EnableDisableGrouping(bool isEnable)
    {
        btnSwitch.Visible = true;

        if (isEnable)
        {
            lblShowGridState.Text = "Group sort is currently ENABLED";
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
            lblShowGridState.Text = "Group sort is currently DISABLED";
            btnSwitch.ImageUrl = "../content/images/btn_enable.gif";
        }
    }

    #endregion

    #region On Index Changed Methods

    protected void cmbCategoryTypes_OnClientSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        BindTypes(cmbCategoryTypes.SelectedValue);
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
        grdTransactions.Rebind();
        RadWindowManager1.RadAlert("Your update to notes has been saved.", 350, 100, "", "", "");
    }

    #endregion

    #region Clear Data

    protected void btnClear_OnClick(object sender, EventArgs e)
    {
        cmbLocations.ClearSelection();
        cmbProviders.ClearSelection();
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
        BindTypes();
    }

    #endregion
}