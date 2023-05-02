using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Windows.Forms;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using Telerik.Web.UI;
using System.Text.RegularExpressions;
using Control = System.Web.UI.Control;

public partial class feeSchedule_popup : BasePage
{
    private static Int32? FeeScheduleId
    {
        get
        {
            return Extension.ClientSession.ObjectType == ObjectType.FeeSchedule ? Convert.ToInt32(Extension.ClientSession.ObjectID) : 0;
        }
    }

    #region Form Properties

    public bool IsShowTextbox { get; set; }

    private string CptCode { get; set; }

    private string Category { get; set; }

    private string CptName { get; set; }

    private decimal ProviderCharge { get; set; }

    private decimal Allowable { get; set; }

    private string InvoiceName { get; set; }
    private string CptType { get; set; }
    private string Description { get; set; }
    private string ServiceTypeID { get; set; }
    private string ServiceType { get; set; }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // Closing the popup in case of any error
                Extension.ClientSession.WasRequestFromPopup = true;
                ShowScheduleDetail();
                ViewState["FeeSchedules"] = new DataTable();
                ViewState["IsSearch"] = false;

            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    private void ShowScheduleDetail()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@FeeScheduleID", FeeScheduleId},
                                {"@UserID", ClientSession.UserID}
                            };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_feeschedule_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            lblFeeScheduleID.Text = row["FeeScheduleID"].ToString();
            lblScheduleName.Text = row["ScheduleName"].ToString();
            lblCarrierName.Text = row["CarrierName"].ToString();
            lblReferenceID.Text = row["ReferenceID"].ToString();
            lblServiceClass.Text = row["ServiceClassAbbr"].ToString();
            lblProvider.Text = row["ProviderName"].ToString();
            lblNPI.Text = row["ProviderNPI"].ToString();
            lblContractStatus.Text = row["FlagContractAbbr"].ToString();
            lblScheduleStatus.Text = row["FlagActiveAbbr"].ToString();
            lblRequestDate.Text = row["RequestDateTime"].ToString();
            lblExpiration.Text = row["DateExpiration"].ToString();
            lblReimBursement.Text = row["FlagPtReimbAbbr"].ToString();
            lblNotes.Text = row["Notes"].ToString();
        }
    }

    private DataTable BindServiesTypesDropdown()
    {
        DataTable types;

        if (ViewState["ServicesTypes"] == null)
        {
            var servicesTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_servicetype_list", new Dictionary<string, object>());
            ViewState["ServicesTypes"] = servicesTypes;
            types = servicesTypes;
        }
        else
        {
            types = ViewState["ServicesTypes"] as DataTable;
        }

        return types;
    }

    #region Grid Operation

    protected void btnReport_Click(object sender, EventArgs e)
    {
        foreach (GridColumn col in grdSchedules.MasterTableView.Columns)
        {
            col.HeaderStyle.Width = Unit.Point(150);
        }

        ConfigureExport();
        grdSchedules.MasterTableView.ExportToExcel();
    }

    protected DataTable GetSchedules()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@FeeScheduleID", FeeScheduleId},
                                {"@FlagActive", 1},
                                {"@UserID", ClientSession.UserID}
                            };
        var schedules = SqlHelper.ExecuteDataTableProcedureParams("web_pr_feeschedulecpt_get", cmdParams);
        return schedules;
    }

    protected void grdSchedules_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var isSeachActivated = (bool)ViewState["IsSearch"];

        var datatable = isSeachActivated ? ViewState["SearchResults"] : ViewState["FeeSchedules"];
        var feeSchedules = datatable as DataTable;

        if (!Page.IsPostBack)
        {
            feeSchedules = GetSchedules();
            ViewState["FeeSchedules"] = feeSchedules;
        }

        grdSchedules.DataSource = feeSchedules;
    }

    protected void grdSchedules_OnItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridNestedViewItem)
        {
            var item = e.Item as GridNestedViewItem;
            var combobox = item.FindControl("cmbServiceTypes") as RadComboBox;
            var literal = item.FindControl("litCollapseButton") as Literal;
            var serviceTypeID = item.ParentItem.GetDataKeyValue("ServiceTypeID");

            // Assigning string to literal
            literal.Text = GetCollapseButton(item.ParentItem.ItemIndex);

            // Assigning selected value
            combobox.DataSource = BindServiesTypesDropdown();
            combobox.DataBind();
            combobox.SelectedValue = serviceTypeID.ToString();
        }
    }

    private static string GetCollapseButton(int index)
    {
        return string.Format("<img src='../Content/Images/icon_cancel.png' title='Cancel' onclick='collapseRow({0})' alt='Cancel' style='cursor: pointer;' />", index);
    }

    protected void grdSchedules_OnItemCommand(object sender, GridCommandEventArgs e)
    {
        var editedItem = e.Item as GridDataItem;
        var feeSchedules = ViewState["FeeSchedules"] as DataTable;
        

        IsShowTextbox = false;

        if (e.CommandName == RadGrid.UpdateCommandName)
        {
            AssigningValues(editedItem);

            // Validating inputs
            var isValidated = ValidateInputs();
            if (!isValidated)
            {
                e.Canceled = true;
                return;
            }

            var cptCode = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CPTCode"];
            UpdateFeeSchedule(cptCode.ToString(), feeSchedules);
            SaveUpdateCptInSearchResult(false, cptCode.ToString());
            SaveDeleteCptInformation();
            grdSchedules.Rebind();
            return;
        }

        if (e.CommandName == RadGrid.PerformInsertCommandName)
        {
            AssigningValues(editedItem);

            var isValidated = ValidateInputs(feeSchedules);
            if (!isValidated)
            {
                e.Canceled = true;
                return;
            }

            InsertNewFeeSchedule(feeSchedules);
            SaveUpdateCptInSearchResult(true);
            SaveDeleteCptInformation();
            grdSchedules.Rebind();
            return;

        }

        if (e.CommandName == RadGrid.DeleteCommandName)
        {
            var cptCode = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CPTCode"];
            ViewState["CptCode"] = cptCode;
            radWindow.RadConfirm("<p>Are you sure you want to delete the selected record?</p>", "deleteCptCode", 420, 120, null, "", "/Content/Images/warning.png");
            return;
        }

        if (e.CommandName == RadGrid.InitInsertCommandName)
        {
            grdSchedules.MasterTableView.ClearEditItems();
            IsShowTextbox = true;
            hdnIndex.Value = string.Empty;
            return;
        }

        if (e.CommandName == RadGrid.EditCommandName)
        {
            hdnIndex.Value = e.Item.ItemIndex.ToString();
            e.Item.OwnerTableView.IsItemInserted = false;
        }

        if (e.CommandName == RadGrid.ExpandCollapseCommandName && !string.IsNullOrEmpty(e.CommandArgument.ToString()))
        {
            var cptCode = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CPTCode"];
            var item = editedItem.ChildItem;
            AssignOldValue(cptCode.ToString(), item, feeSchedules);
        }
        
    }

    public void ConfigureExport()
    {
        grdSchedules.ExportSettings.FileName = "CPTInformation";
        grdSchedules.ExportSettings.HideStructureColumns = true;
        grdSchedules.ExportSettings.ExportOnlyData = true;
        grdSchedules.ExportSettings.IgnorePaging = true;

        // Displaying more fields
        grdSchedules.MasterTableView.GetColumn("CPTAbbr").Display = true;
        grdSchedules.MasterTableView.GetColumn("ServiceTypeAbbr").Display = true;
        grdSchedules.MasterTableView.GetColumn("CPTType").Display = true;
        grdSchedules.MasterTableView.GetColumn("CPTDesc").Display = true;

        // Hiding buttons
        grdSchedules.MasterTableView.GetColumn("EditCptCode").Visible = false;
        grdSchedules.MasterTableView.GetColumn("DeleteCptCode").Visible = false;

    }

    protected void btnSearch_OnClick(object sender, EventArgs e)
    {
        var requestedText = txtSearch.Text.Trim().ToLower();
        var feeSchedules = ViewState["FeeSchedules"] as DataTable;

        if (!string.IsNullOrEmpty(requestedText))
        {
            ViewState["IsSearch"] = true;
            var dataRows = feeSchedules.AsEnumerable().Where(feeSchedule =>
                           feeSchedule.Field<string>("CPTCode").ToLower().Contains(requestedText) ||
                           feeSchedule.Field<string>("CPTName").ToLower().Contains(requestedText)).OrderByDescending(feeSchedule => feeSchedule["CPTCode"]).ToList();

            ViewState["SearchResults"] = GetSearchResults(dataRows);
            grdSchedules.MasterTableView.IsItemInserted = false;
        }

        grdSchedules.Rebind();

    }

    private DataTable GetSearchResults(IEnumerable<DataRow> dataRows)
    {
        var result = new DataTable();
        result.Columns.Add("CPTCode", typeof(string));
        result.Columns.Add("CPTName", typeof(string));
        result.Columns.Add("CPTCategory", typeof(string));
        result.Columns.Add("ProviderCharge$", typeof(string));
        result.Columns.Add("Allowable$", typeof(string));
        result.Columns.Add("ProviderCharge", typeof(decimal));
        result.Columns.Add("Allowable", typeof(decimal));
        result.Columns.Add("CPTAbbr", typeof(string));
        result.Columns.Add("ServiceTypeAbbr", typeof(string));
        result.Columns.Add("ServiceTypeID", typeof(Int32));
        result.Columns.Add("CPTType", typeof(string));
        result.Columns.Add("CPTDesc", typeof(string));

        foreach (var dataRow in dataRows)
        {
            // Creating new row
            var newRow = result.NewRow();

            CptCode = dataRow["CPTCode"].ToString();
            CptName = dataRow["CPTName"].ToString();
            Category = dataRow["CPTCategory"].ToString();
            ProviderCharge = decimal.Parse(dataRow["ProviderCharge"].ToString());
            Allowable = decimal.Parse(dataRow["Allowable"].ToString());
            InvoiceName = dataRow["CPTAbbr"].ToString();
            ServiceType = dataRow["ServiceTypeAbbr"].ToString();
            ServiceTypeID = dataRow["ServiceTypeID"].ToString();
            CptType = dataRow["CPTType"].ToString();
            Description = dataRow["CPTDesc"].ToString();

            // Assinging Values
            newRow["CPTCode"] = CptCode;
            newRow["CPTName"] = CptName;
            newRow["CPTCategory"] = Category;
            newRow["ProviderCharge$"] = ProviderCharge.ToString("c");
            newRow["Allowable$"] = Allowable.ToString("c");
            newRow["ProviderCharge"] = ProviderCharge;
            newRow["Allowable"] = Allowable;
            newRow["CPTAbbr"] = InvoiceName;
            newRow["ServiceTypeAbbr"] = ServiceType;
            newRow["ServiceTypeID"] = ServiceTypeID;
            newRow["CPTType"] = CptType;
            newRow["CPTDesc"] = Description;
            result.Rows.InsertAt(newRow, 0);
        }

        return result;
    }

    protected void btnClearResult_OnClick(object sender, EventArgs e)
    {
        ViewState["IsSearch"] = false;
        ViewState["SearchResults"] = null;
        txtSearch.Text = string.Empty;
        grdSchedules.MasterTableView.IsItemInserted = false;
        grdSchedules.MasterTableView.ClearEditItems();
        grdSchedules.Rebind();
    }

    private void AssignOldValue(string cptCode, GridNestedViewItem item, DataTable feeSchedule)
    {
        var row = GetSelectedRow(cptCode, feeSchedule);
        var radCombobox = item.FindControl("cmbServiceTypes") as RadComboBox;
        var serviceTypeID = row["ServiceTypeID"].ToString();

        if (!string.IsNullOrEmpty(serviceTypeID))
        {
            radCombobox.SelectedValue = serviceTypeID;
        }
        else
        {
            radCombobox.ClearSelection();
        }

        (item.FindControl("txtInvoiceName") as System.Web.UI.WebControls.TextBox).Text = row["CPTAbbr"].ToString();
        (item.FindControl("txtCPTType") as System.Web.UI.WebControls.TextBox).Text = row["CPTType"].ToString();
        (item.FindControl("txtDescription") as System.Web.UI.WebControls.TextBox).Text = row["CPTDesc"].ToString();
    }

    #endregion

    #region CPT Operations

    protected void btnDeleteCPTCode_OnDelete(object sender, EventArgs e)
    {
        var isSeachActivated = (bool)ViewState["IsSearch"];
        var cptCode = ViewState["CptCode"].ToString();
        var feeSchedules = ViewState["FeeSchedules"] as DataTable;

        if (isSeachActivated)
        {
            var searchResults = ViewState["SearchResults"] as DataTable;
            var row = GetSelectedRow(cptCode, searchResults);
            searchResults.Rows.Remove(row);
        }

        var dataRow = GetSelectedRow(cptCode, feeSchedules);
        feeSchedules.Rows.Remove(dataRow);
        grdSchedules.Rebind();

        // Removing from databse
        CptCode = cptCode;
        SaveDeleteCptInformation(true);
    }

    protected void btnUpdateOptionalFields_OnClick(object sender, EventArgs e)
    {
        var button = sender as ImageButton;
        var item = button.NamingContainer as GridNestedViewItem;
        UpdateAdditionalInformation(item);
        grdSchedules.MasterTableView.Items[item.ParentItem.ItemIndex].Expanded = false;
    }

    private void AssigningValues(Control item)
    {
        // Getting Values
        var cptCodeTextbox = item.FindControl("txtCptCode") as RadTextBox;
        var categoryTextbox = item.FindControl("txtCategory") as RadTextBox;
        var cptNameTextbox = item.FindControl("txtCptName") as RadTextBox;
        var providerTextbox = item.FindControl("txtProviderCharge") as RadNumericTextBox;
        var allowableTextbox = item.FindControl("txtAllowable") as RadNumericTextBox;

        // Assigning Values
        CptCode = cptCodeTextbox.Text;
        Category = categoryTextbox.Text;
        CptName = cptNameTextbox.Text;

        decimal providerCharge, allowable;
        decimal.TryParse(providerTextbox.Text, out providerCharge);
        decimal.TryParse(allowableTextbox.Text, out allowable);

        ProviderCharge = providerCharge;
        Allowable = allowable;
    }

    private void SaveUpdateCptInSearchResult(bool isAdd, string cptCode = null)
    {
        var isSeachActivated = (bool)ViewState["IsSearch"];
        if (!isSeachActivated)
            return;

        var searchResults = ViewState["SearchResults"] as DataTable;

        if (isAdd)
        {
            InsertNewFeeSchedule(searchResults);
        }
        else
        {
            UpdateFeeSchedule(cptCode, searchResults);
        }
    }

    private void UpdateFeeSchedule(string cptCode, DataTable feeSchedules)
    {
        var dataRow = GetSelectedRow(cptCode, feeSchedules);
        dataRow["CPTCategory"] = Category;
        dataRow["CPTName"] = CptName;
        dataRow["ProviderCharge$"] = ProviderCharge.ToString("c");
        dataRow["Allowable$"] = Allowable.ToString("c");
        dataRow["ProviderCharge"] = ProviderCharge;
        dataRow["Allowable"] = Allowable;
    }

    private void InsertNewFeeSchedule(DataTable feeSchedules)
    {
        var newRow = feeSchedules.NewRow();
        newRow["CPTCode"] = CptCode;
        newRow["CPTName"] = CptName;
        newRow["CPTCategory"] = Category;
        newRow["ProviderCharge$"] = ProviderCharge.ToString("c");
        newRow["Allowable$"] = Allowable.ToString("c");
        newRow["ProviderCharge"] = ProviderCharge;
        newRow["Allowable"] = Allowable;
        feeSchedules.Rows.InsertAt(newRow, 0);
    }

    private static bool IsCptCodeExists(string cptCode, DataTable feeSchedules)
    {
        var cptCodes = Enumerable.Select(feeSchedules.AsEnumerable(), feeSchedule => feeSchedule["CPTCode"].ToString()).ToList();
        return cptCodes.Any(code => String.Equals(code, cptCode, StringComparison.CurrentCultureIgnoreCase));
    }

    private static DataRow GetSelectedRow(string cptCode, DataTable feeSchedules)
    {
        var dataRow = feeSchedules.AsEnumerable().Single(feeSchedule => feeSchedule.Field<string>("CPTCode") == cptCode);
        return dataRow;
    }

    private bool ValidateInputs(DataTable feeSchedules = null)
    {
        var errorMessage = string.Empty;
        var count = 0;

        // Checking CPTCode length
        if (CptCode.Length < 3)
        {
            count += 1;
            errorMessage = string.Format("{0}. CPTCode must be 3 chars long. <br />", count);
        }

        // Checking cptcode for alphanumeric number
        var regex = new Regex("^[a-zA-Z0-9]*$");
        var match = regex.Match(CptCode);
        if (!match.Success)
        {
            count += 1;
            errorMessage += string.Format("{0}. CPT Code must be Alpha-Numeric. <br />", count);
        }

        // CPTName should not be blank
        if (string.IsNullOrEmpty(CptName) && string.IsNullOrWhiteSpace(CptName))
        {
            count += 1;
            errorMessage += string.Format("{0}. CPT Name is required. <br />", count);
        }

        // Allowable should be required
        if (Allowable <= 0)
        {
            count += 1;
            errorMessage += string.Format("{0}. Allowable is required. <br />", count);
        }

        // Provider should be required
        if (ProviderCharge <= 0)
        {
            count += 1;
            errorMessage += string.Format("{0}. Provider Charge is required. <br />", count);
        }

        // validating Alowable
        if (Allowable > ProviderCharge)
        {
            count += 1;
            errorMessage += string.Format("{0}. Allowable must be less than or equal to Provider Charge. <br />", count);
        }

        if (feeSchedules != null)
        {
            if (IsCptCodeExists(CptCode, feeSchedules))
            {
                count += 1;
                errorMessage += string.Format("{0}. CptCode already exists. <br />", count);
            }
        }


        if (!string.IsNullOrEmpty(errorMessage))
        {
            radWindow.RadAlert(errorMessage, 350, 150, "", null);
        }

        return string.IsNullOrEmpty(errorMessage);
    }

    private void UpdateAdditionalInformation(GridNestedViewItem item)
    {
        var cptCode = item.ParentItem.GetDataKeyValue("CPTCode").ToString();
        var invoiceNameTextbox = item.FindControl("txtInvoiceName") as System.Web.UI.WebControls.TextBox;
        var cptTypeTextbox = item.FindControl("txtCPTType") as System.Web.UI.WebControls.TextBox;
        var descriptionTextbox = item.FindControl("txtDescription") as System.Web.UI.WebControls.TextBox;
        var serviceTypeCombobox = item.FindControl("cmbServiceTypes") as RadComboBox;

        if (!string.IsNullOrEmpty(serviceTypeCombobox.SelectedValue))
        {
            ServiceType = serviceTypeCombobox.SelectedItem.Text;
        }

        CptCode = cptCode;
        Description = descriptionTextbox.Text;
        InvoiceName = invoiceNameTextbox.Text;
        CptType = cptTypeTextbox.Text;
        ServiceTypeID = serviceTypeCombobox.SelectedValue;

        var isSeachActivated = (bool)ViewState["IsSearch"];
        if (isSeachActivated)
        {
            var searchResults = ViewState["SearchResults"] as DataTable;
            UpdateOptionalFieldsInViewState(cptCode, searchResults);
        }

        var feeSchedules = ViewState["FeeSchedules"] as DataTable;
        UpdateOptionalFieldsInViewState(cptCode, feeSchedules);

        // Saving changes in database
        SaveDeleteCptInformation(false, true);

    }

    private void UpdateOptionalFieldsInViewState(string cptCode, DataTable feeSchedule)
    {
        var dataRow = GetSelectedRow(cptCode, feeSchedule);
        dataRow["CPTAbbr"] = InvoiceName;
        dataRow["CPTType"] = CptType;
        dataRow["CPTDesc"] = Description;
        dataRow["ServiceTypeID"] = string.IsNullOrEmpty(ServiceTypeID) ? "0" : ServiceTypeID;
        dataRow["ServiceTypeAbbr"] = ServiceType;
    }

    private void SaveDeleteCptInformation(bool isDelete = false, bool isUpdateAdditionalFields = false)
    {
        var cmdParm = new Dictionary<string, object>
        {
            {"@FeeScheduleID", FeeScheduleId},
            {"@CPTCode", CptCode},
            {"@UserID", Extension.ClientSession.UserID}
        };

        if (isDelete)
        {
            cmdParm.Add("@FlagActive", 0);
        }
        else if (!isUpdateAdditionalFields)
        {
            cmdParm.Add("@CPTName", CptName);
            cmdParm.Add("@CPTCategory", Category);
            cmdParm.Add("@ProviderCharge", ProviderCharge);
            cmdParm.Add("@Allowable", Allowable);
        }

        if (isUpdateAdditionalFields)
        {
            cmdParm.Add("@CPTAbbr", InvoiceName);
            cmdParm.Add("@CPTType", CptType);
            cmdParm.Add("@CPTDesc", Description);
            cmdParm.Add("@ServiceTypeID", ServiceTypeID);
        }

        SqlHelper.ExecuteScalarProcedureParams("web_pr_feeschedulecpt_add", cmdParm);

    }

    #endregion

}
