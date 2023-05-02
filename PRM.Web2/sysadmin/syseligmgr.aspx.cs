using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using Telerik.Web.UI;
using System.Text.RegularExpressions;

public partial class syseligmgr : BasePage
{

    #region Stack Properties

    public string XmlID { get; set; }
    public string PayerIDCode { get; set; }
    public string Value1Destination { get; set; }
    public string ET1XMLID { get; set; }
    public string ET2XMLID { get; set; }
    public string ET3XMLID { get; set; }
    public string ET4XMLID { get; set; }
    public string ET5XMLID { get; set; }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.ManageEligibility)
            {
                // Initializing the viewstate for later user
                var dataTable = new DataTable();
                ViewState["Stacks"] = dataTable;
                ViewState["StacksWithoutEmptyRecords"] = dataTable;
                ViewState["FlagEmptyStack"] = true;
                ViewState["FlagManageStack"] = true;

            }
            else
            {
                Response.Redirect("~/sysadmin/syseligredir.aspx");
            }
        }

        popupConflicts.VisibleOnPageLoad = false;
    }


    #region Bind Dropdowns

    private DataTable BindValueDescriptionDropdown()
    {
        DataTable descriptions;

        if (ViewState["Descriptions"] == null)
        {
            var valueDescriptions = SqlHelper.ExecuteDataTableProcedureParams("web_pr_eligibilityTYPE_list",
                new Dictionary<string, object>());
            ViewState["Descriptions"] = valueDescriptions;
            descriptions = valueDescriptions;
        }
        else
        {
            descriptions = ViewState["Descriptions"] as DataTable;
        }

        return descriptions;
    }

    #endregion

    #region Grid Operation


    private DataTable GetEligibilityHistory()
    {
        var cmdParams = new Dictionary<string, object> { { "@EligibilityID", ClientSession.ObjectID }, { "@UserID", ClientSession.UserID } };
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_eligibilitystacks_get", cmdParams);
    }

    protected void grdEligibilityStacks_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var stacks = ViewState["Stacks"] as DataTable;
        if (stacks.Rows.Count == 0)
        {
            stacks = GetEligibilityHistory();
            ViewState["Stacks"] = stacks;
        }

        if (Convert.ToBoolean(ViewState["FlagEmptyStack"]))
        {
            var stacksWithoutEmptyRecords = ViewState["StacksWithoutEmptyRecords"] as DataTable;
            if (stacksWithoutEmptyRecords.Rows.Count == 0)
            {
                stacksWithoutEmptyRecords = GetStacksWithoutEmptyRecords(stacks);
                ViewState["StacksWithoutEmptyRecords"] = stacksWithoutEmptyRecords;
            }

            stacks = stacksWithoutEmptyRecords;
        }

        grdEligibilityStacks.DataSource = stacks;

    }

    private static DataTable GetStacksWithoutEmptyRecords(DataTable stacks)
    {
        if (stacks.Rows.Count == 0)
        {
            return new DataTable();
        }

        var emptyStacks =
            stacks.AsEnumerable().Where(stack => !string.IsNullOrEmpty(stack["XMLID"].ToString())).ToList();
        return emptyStacks.CopyToDataTable();
    }

    protected void grdEligibilityStacks_OnItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var xmlID = item.GetDataKeyValue("XMLID").ToString();
            var stacks = ViewState["Stacks"] as DataTable;

            if (Convert.ToBoolean(ViewState["FlagManageStack"]))
            {
                if (!string.IsNullOrEmpty(xmlID))
                {
                    var row = GetSelectedRow(xmlID, stacks);
                    item["Stack"].Text = GetFormattedStackText(row["Stack"].ToString());
                }
            }

            if (string.IsNullOrEmpty(xmlID))
            {
                item.CssClass = "Hidden";
                item["Destination"].Visible = false;
                item.Enabled = false;
                item.Height = 23;

                //item["DeleteCptCode"].CssClass = "Hidden";
                //item["EditCptCode"].CssClass = "Hidden";

                //item["DeleteCptCode"].Enabled = false;
                //item["EditCptCode"].Enabled = false;
            }
        }

        if (e.Item is GridEditableItem && e.Item.IsInEditMode)
        {
            var item = (GridEditableItem)e.Item;
            var value1Destination = item.GetDataKeyValue("Value1Destination").ToString();
            var combobox = item.FindControl("cmbDestinations") as RadComboBox;
            combobox.DataSource = BindValueDescriptionDropdown();
            combobox.DataBind();
            combobox.SelectedValue = value1Destination;

            // Displaying correct image
            var isRule1MatchType = IsRuleMatchType(item.GetDataKeyValue("Rule1MatchType").ToString());
            var isRule2MatchType = IsRuleMatchType(item.GetDataKeyValue("Rule2MatchType").ToString());
            var isRule3MatchType = IsRuleMatchType(item.GetDataKeyValue("Rule3MatchType").ToString());
            var isRule4MatchType = IsRuleMatchType(item.GetDataKeyValue("Rule4MatchType").ToString());
            var isRule5MatchType = IsRuleMatchType(item.GetDataKeyValue("Rule5MatchType").ToString());

            var button1 = item.FindControl("btnRule1XMLID") as ImageButton;
            var button2 = item.FindControl("btnRule2XMLID") as ImageButton;
            var button3 = item.FindControl("btnRule3XMLID") as ImageButton;
            var button4 = item.FindControl("btnRule4XMLID") as ImageButton;
            var button5 = item.FindControl("btnRule5XMLID") as ImageButton;

            const string greenImage = "~/Content/Images/icon_circle_green.png";
            const string redImage = "~/Content/Images/icon_circle_red.png";

            button1.ImageUrl = !isRule1MatchType ? redImage : greenImage;
            button2.ImageUrl = !isRule2MatchType ? redImage : greenImage;
            button3.ImageUrl = !isRule3MatchType ? redImage : greenImage;
            button4.ImageUrl = !isRule4MatchType ? redImage : greenImage;
            button5.ImageUrl = !isRule5MatchType ? redImage : greenImage;

            // for further use
            ViewState["MatchRule"] = new MatchRule
            {
                XmlID = item.GetDataKeyValue("XMLID").ToString(),
                Rule1MatchType = isRule1MatchType,
                Rule2MatchType = isRule2MatchType,
                Rule3MatchType = isRule3MatchType,
                Rule4MatchType = isRule4MatchType,
                Rule5MatchType = isRule5MatchType
            };

        }
    }

    private static string GetFormattedStackText(string stack)
    {
        var stacks = stack.Split(new[] { "<" }, StringSplitOptions.RemoveEmptyEntries);
        if (stacks.Count() == 1)
            return HttpUtility.HtmlEncode(stack);

        var lastStack = stacks.Last().Replace(">", "");
        var formattedStacks = "";

        for (var index = 0; index < stacks.Count() - 1; index++)
        {
            formattedStacks += "<>";
        }

        return HttpUtility.HtmlEncode(string.Format("{0}<{1}>", formattedStacks, lastStack));
    }


    protected void grdEligibilityStacks_OnItemCommand(object sender, GridCommandEventArgs e)
    {
        var item = e.Item as GridDataItem;

        if (e.CommandName == RadGrid.UpdateCommandName)
        {
            // Saving data for further user
            ClientSession.ObjectValue = item;

            DataTable conflicts;
            var isConflicts = IsConflicts(out conflicts);
            if (!isConflicts)
            {

                var message = ValidateStackValue(item);
                if (!string.IsNullOrEmpty(message))
                {
                    e.Canceled = true;
                    RadWindow.RadAlert(string.Format("<p>{0}</p>", message), 350, 150, "", null);
                    return;
                }

                message = ValidateInputFields(item);
                if (!string.IsNullOrEmpty(message))
                {
                    e.Canceled = true;
                    RadWindow.RadAlert(string.Format("<p>{0}</p>", message), 350, 150, "", null);
                    return;
                }

                SavedEligibilityStack();
                btnSaveEligibilityStack.Visible = false;
                btnCancel.ImageUrl = "../Content/Images/btn_close.gif";
                pMessage.Style["Color"] = "green";
                pMessage.InnerText = "Record successfully saved.";

            }
            else
            {
                pMessage.Style["Color"] = "red";
                pMessage.InnerText = "Errors have been identified during validation, confirm the addition of this rule.";
            }

            popupConflicts.VisibleOnPageLoad = true;

        }

        if (e.CommandName == RadGrid.DeleteCommandName)
        {
            ClientSession.ObjectValue = item;
            //AddUpdateandDeleteEligibilityStack(item, true);
            RadWindow.RadConfirm("<p>Are you sure you want to delete the selected record?</p>", "deleteEligibilityStack",
                420, 120, null, "", "/Content/Images/warning.png");
        }

    }


    protected void grdEligibilityStacks_ItemCreated(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridPagerItem)
        {
            var dropDown = (RadComboBox)e.Item.FindControl("PageSizeComboBox");
            var totalCount = ((GridPagerItem)e.Item).Paging.DataSourceCount;
            var sizes = new Dictionary<string, string>
            {
                {"20", "20"},
                {"100", "100"},
                {"1000", "1000"},
                {"All", totalCount.ToString()}
            };

            dropDown.Items.Clear();
            foreach (var size in sizes)
            {
                var cboItem = new RadComboBoxItem { Text = size.Key, Value = size.Value };
                cboItem.Attributes.Add("ownerTableViewId", e.Item.OwnerTableView.ClientID);
                dropDown.Items.Add(cboItem);
            }

            var pageSize = dropDown.FindItemByValue(e.Item.OwnerTableView.PageSize.ToString());
            if (pageSize != null)
            {
                pageSize.Selected = true;
            }

        }
    }


    protected void grdConflicts_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var conflicts = ViewState["Conflicts"] as DataTable;
        if (conflicts != null)
        {
            grdConflicts.DataSource = conflicts;
        }
    }

    private bool IsConflicts(out DataTable conflicts)
    {
        var cmdParams = new Dictionary<string, object> { { "@EligibilityID", ClientSession.ObjectID }, { "@UserID", ClientSession.UserID } };
        conflicts = SqlHelper.ExecuteDataTableProcedureParams("web_pr_eligibilitytranslatorconflicts_get", cmdParams);

        // Saving to further show conflicts on popup
        ViewState["Conflicts"] = conflicts;
        return conflicts.AsEnumerable().Any(res => Convert.ToBoolean(res["FlagError"].ToString() == "1"));
    }

    protected void btnFlagEmptyStack_OnClick(object sender, EventArgs e)
    {
        var flagState = Convert.ToBoolean(ViewState["FlagEmptyStack"]);
        ViewState["FlagEmptyStack"] = !flagState;

        // Updating image and text according to the flag statte
        btnFlagEmptyStack.ImageUrl = !flagState
            ? "../Content/Images/btn_disable.gif"
            : "../Content/Images/btn_enable.gif";
        bEmptyStack.InnerText = !flagState ? "Flag for empty records is ENABLED" : "Flag for empty records is DISABLED";

        grdEligibilityStacks.Rebind();
    }

    protected void btnManageStacksText_Click(object sender, ImageClickEventArgs e)
    {
        var flagState = Convert.ToBoolean(ViewState["FlagManageStack"]);
        ViewState["FlagManageStack"] = !flagState;

        btnManageStacksText.ImageUrl = !flagState
            ? "../Content/Images/btn_disable.gif"
            : "../Content/Images/btn_enable.gif";
        bManageStack.InnerText = !flagState ? "Flag Stack is ENABLED" : "Flag Stack is DISABLED";

        grdEligibilityStacks.Rebind();
    }

    #endregion

    #region Manage Eliligbity Stack Information


    private void SavedEligibilityStack()
    {
        var item = ClientSession.ObjectValue as GridDataItem;
        AddUpdateandDeleteEligibilityStack(item);

        // Also updating in view state
        var isFlagEnabled = Convert.ToBoolean(ViewState["FlagEmptyStack"]);
        if (isFlagEnabled)
        {
            var stacksWithoutEmptyRecords = ViewState["StacksWithoutEmptyRecords"] as DataTable;
            ManageStacksInViewState(XmlID, stacksWithoutEmptyRecords);
        }

        var stacks = ViewState["Stacks"] as DataTable;
        ManageStacksInViewState(XmlID, stacks);

        // Removing any data if exists
        ClientSession.ObjectValue = null;

        // Refreshing grid
        grdEligibilityStacks.Rebind();
    }


    protected void btnSaveEligibilityStack_OnClick(object sender, ImageClickEventArgs e)
    {
        var item = ClientSession.ObjectValue as GridDataItem;
        var message = ValidateStackValue(item);
        if (!string.IsNullOrEmpty(message))
        {
            RadWindow.RadAlert(string.Format("<p>{0}</p>", message), 350, 150, "", null);
            return;
        }

        message = ValidateInputFields(item);
        if (!string.IsNullOrEmpty(message))
        {
            RadWindow.RadAlert(string.Format("<p>{0}</p>", message), 350, 150, "", null);
            return;
        }

        SavedEligibilityStack();
    }

    protected void btnDeleteEligibilityStack_OnClick(object sender, EventArgs e)
    {
        var item = ClientSession.ObjectValue as GridDataItem;
        AddUpdateandDeleteEligibilityStack(item, true);

        var flag = Convert.ToBoolean(ViewState["FlagEmptyStack"]);
        if (flag)
        {
            var stacksWithoutEmptyRecords = ViewState["StacksWithoutEmptyRecords"] as DataTable;
            var row = GetSelectedRow(XmlID, stacksWithoutEmptyRecords);
            stacksWithoutEmptyRecords.Rows.Remove(row);
        }

        var stacks = ViewState["Stacks"] as DataTable;
        var dataRow = GetSelectedRow(XmlID, stacks);
        stacks.Rows.Remove(dataRow);

        ClientSession.ObjectValue = null;
        grdEligibilityStacks.Rebind();
    }

    private void AddUpdateandDeleteEligibilityStack(GridEditableItem item, bool isDelete = false)
    {
        var ruleId = item.GetDataKeyValue("RuleID").ToString();
        XmlID = item.GetDataKeyValue("XMLID").ToString();


        if (!isDelete)
        {
            var checkBox = item.FindControl("chkPayerIDCode") as CheckBox;
            PayerIDCode = checkBox.Checked ? ClientSession.ObjectID2.ToString() : "0";
        }
        else
        {
            var stacks = (DataTable)ViewState["Stacks"];
            var row = GetSelectedRow(XmlID, stacks);
            PayerIDCode = row["PayerIDCode"].ToString();
        }


        var cmdParams = new Dictionary<string, object>
        {
            {"@RuleID", ruleId},
            {"@PayerIDCode", PayerIDCode},
            {"@ValueXMLID", XmlID},
            {"@FlagActive", !isDelete},
            {"@UserID", ClientSession.UserID}
        };

        if (!isDelete)
        {
            var combobox = item.FindControl("cmbDestinations") as RadComboBox;
            ET1XMLID = (item.FindControl("txtET1XMLID") as RadTextBox).Text.Trim();
            ET2XMLID = (item.FindControl("txtET2XMLID") as RadTextBox).Text.Trim();
            ET3XMLID = (item.FindControl("txtET3XMLID") as RadTextBox).Text.Trim();
            ET4XMLID = (item.FindControl("txtET4XMLID") as RadTextBox).Text.Trim();
            ET5XMLID = (item.FindControl("txtET5XMLID") as RadTextBox).Text.Trim();
            Value1Destination = combobox.SelectedValue;

            // Getting value for MatchRule
            var matchRule = (MatchRule)ViewState["MatchRule"];

            cmdParams.Add("@ET1XMLID", ET1XMLID);
            cmdParams.Add("@ET2XMLID", ET2XMLID);
            cmdParams.Add("@ET3XMLID", ET3XMLID);
            cmdParams.Add("@ET4XMLID", ET4XMLID);
            cmdParams.Add("@ET5XMLID", ET5XMLID);
            cmdParams.Add("@Rule1MatchType", matchRule.Rule1MatchType);
            cmdParams.Add("@Rule2MatchType", matchRule.Rule2MatchType);
            cmdParams.Add("@Rule3MatchType", matchRule.Rule3MatchType);
            cmdParams.Add("@Rule4MatchType", matchRule.Rule4MatchType);
            cmdParams.Add("@Rule5MatchType", matchRule.Rule5MatchType);
            cmdParams.Add("@Value1Destination", Value1Destination);
        }

        SqlHelper.ExecuteScalarProcedureParams("web_pr_eligibilitytranslator_add", cmdParams);

    }


    private void ManageStacksInViewState(string xmlID, DataTable stacks)
    {
        var dataRow = GetSelectedRow(xmlID, stacks);
        dataRow["PayerIDCode"] = PayerIDCode;
        dataRow["Value1Destination"] = Value1Destination;

        if (ParseInt(ET1XMLID) > 0)
        {
            dataRow["ET1XMLID"] = ET1XMLID;
        }

        if (ParseInt(ET2XMLID) > 0)
        {
            dataRow["ET2XMLID"] = ET2XMLID;
        }

        if (ParseInt(ET3XMLID) > 0)
        {
            dataRow["ET3XMLID"] = ET3XMLID;
        }

        if (ParseInt(ET4XMLID) > 0)
        {
            dataRow["ET4XMLID"] = ET4XMLID;
        }

        if (ParseInt(ET5XMLID) > 0)
        {
            dataRow["ET5XMLID"] = ET5XMLID;
        }

        // updating rules if any
        var matchRule = (MatchRule)ViewState["MatchRule"];
        dataRow["Rule1MatchType"] = matchRule.Rule1MatchType;
        dataRow["Rule2MatchType"] = matchRule.Rule2MatchType;
        dataRow["Rule3MatchType"] = matchRule.Rule3MatchType;
        dataRow["Rule4MatchType"] = matchRule.Rule4MatchType;
        dataRow["Rule5MatchType"] = matchRule.Rule5MatchType;

    }

    private static Int32 ParseInt(string requestedValue)
    {
        Int32 value;
        Int32.TryParse(requestedValue ?? "", out value);
        return value;
    }

    private static DataRow GetSelectedRow(string xmlID, DataTable stacks)
    {
        var dataRow = stacks.AsEnumerable().Single(feeSchedule => feeSchedule.Field<string>("XMLID") == xmlID);
        return dataRow;
    }

    protected void SaveRuleOfSelectedRow(object sender, EventArgs e)
    {
        var button = sender as ImageButton;
        var active = false;
        var item = button.NamingContainer as GridEditableItem;
        var xmlID = item.GetDataKeyValue("XMLID").ToString();
        var stacks = ViewState["Stacks"] as DataTable;
        var dataRow = GetSelectedRow(xmlID, stacks);

        // Getting saved data 
        var matchRule = (MatchRule)ViewState["MatchRule"];

        if (matchRule.XmlID != xmlID)
        {
            matchRule = new MatchRule
            {
                XmlID = xmlID,
                Rule1MatchType = IsRuleMatchType(dataRow["Rule1MatchType"].ToString()),
                Rule2MatchType = IsRuleMatchType(dataRow["Rule2MatchType"].ToString()),
                Rule3MatchType = IsRuleMatchType(dataRow["Rule3MatchType"].ToString()),
                Rule4MatchType = IsRuleMatchType(dataRow["Rule4MatchType"].ToString()),
                Rule5MatchType = IsRuleMatchType(dataRow["Rule5MatchType"].ToString())
            };
        }

        //Displaying stacks again, otherwise it will disapper because system will not be call ondatabound event
        foreach (GridDataItem gridItem in grdEligibilityStacks.MasterTableView.Items)
        {
            if (!Convert.ToBoolean(ViewState["FlagManageStack"])) continue;
            var currentXmlId = gridItem.GetDataKeyValue("XMLID").ToString();
            if (string.IsNullOrEmpty(currentXmlId)) continue;
            var row = GetSelectedRow(currentXmlId, stacks);
            gridItem["Stack"].Text = GetFormattedStackText(row["Stack"].ToString());
        }

        // Assigning Values
        switch (button.ID)
        {
            case "btnRule1XMLID":
                active = matchRule.Rule1MatchType;
                matchRule.Rule1MatchType = !active;
                break;
            case "btnRule2XMLID":
                active = matchRule.Rule2MatchType;
                matchRule.Rule2MatchType = !active;
                break;
            case "btnRule3XMLID":
                active = matchRule.Rule3MatchType;
                matchRule.Rule3MatchType = !active;
                break;
            case "btnRule4XMLID":
                active = matchRule.Rule4MatchType;
                matchRule.Rule4MatchType = !active;
                break;
            case "btnRule5XMLID":
                active = matchRule.Rule5MatchType;
                matchRule.Rule5MatchType = !active;
                break;
        }

        //validating rules
        var imageButton2 = item.FindControl("btnRule2XMLID") as ImageButton;
        imageButton2.Visible = !matchRule.Rule1MatchType;

        // Reversing for displaying correct image
        button.ImageUrl = active ? "~/Content/Images/icon_circle_red.png" : "~/Content/Images/icon_circle_green.png";
        ViewState["MatchRule"] = matchRule;


    }

    private static bool IsRuleMatchType(string rule)
    {
        if (string.IsNullOrEmpty(rule))
            return true;

        return Convert.ToBoolean(rule);
    }

    private static string ValidateStackValue(GridEditableItem item)
    {
        var value = item.GetDataKeyValue("Value").ToString();
        var destinationValue = (item.FindControl("cmbDestinations") as RadComboBox).SelectedValue;
        const string message = "Value is not in correct format, ";

        var eligibilityDateTimes = Enum.GetValues(typeof(EligibilityDestDateTime)).Cast<EligibilityDestDateTime>().Select(x => x.GetDescription());
        var isValueExists = eligibilityDateTimes.Any(x => x == destinationValue);
        if (isValueExists)
        {
            DateTime date;
            var isDateValidated = DateTime.TryParse(value, out date);
            return isDateValidated ? null : message + "it should be date";
        }

        var eligibilityIntegers = Enum.GetValues(typeof(EligibilityDestInteger)).Cast<EligibilityDestInteger>().Select(x => x.GetDescription());
        isValueExists = eligibilityIntegers.Any(x => x == destinationValue);
        if (isValueExists)
        {
            Int32 integer;
            var isIntValidated = Int32.TryParse(value, out integer);
            return isIntValidated ? null : message + "it should be numeric";
        }

        var eligibilityAlphaNumeric = Enum.GetValues(typeof(EligibilityDestAlphaNumeric)).Cast<EligibilityDestAlphaNumeric>().Select(x => x.GetDescription());
        isValueExists = eligibilityAlphaNumeric.Any(x => x == destinationValue);
        if (isValueExists)
        {
            var regex = new Regex("^[a-zA-Z0-9]*$");
            var match = regex.Match(value);
            return match.Success ? null : message + "it should be alphanumeric";
        }

        decimal decimlaValue;
        var isValidated = decimal.TryParse(value, out decimlaValue);
        return isValidated ? null : message + "it should be numeric";
    }

    private string ValidateInputFields(GridEditableItem item)
    {
        var errorList = new List<string>();
        var stacks = ViewState["Stacks"] as DataTable;
        var minXmlID = stacks.AsEnumerable().Where(x => !string.IsNullOrEmpty(x["XMLID"].ToString())).Min(x => x["XMLID"].ToString());
        var maxXmlID = stacks.AsEnumerable().Where(x => !string.IsNullOrEmpty(x["XMLID"].ToString())).Max(x => x["XMLID"].ToString());
        var destinationValue = (item.FindControl("cmbDestinations") as RadComboBox).SelectedValue;

        if (string.IsNullOrEmpty(destinationValue))
            errorList.Add("Destination is required.");

        for (var index = 1; index <= 5; index++)
        {
            var value = (item.FindControl("txtET" + index + "XMLID") as RadTextBox).Text;
            if (index == 1)
            {
                if (string.IsNullOrEmpty(value))
                    errorList.Add("R1ID is required");
            }

            if (!string.IsNullOrEmpty(value))
            {
                var regex = new Regex("^[0-9]*$");
                var match = regex.Match(value);
                if (!match.Success)
                    errorList.Add("R" + index + "ID should be numeric");


                if (match.Success)
                {
                    var numericValue = decimal.Parse(value);
                    if (numericValue < Int32.Parse(minXmlID))
                        errorList.Add(string.Format("R{0}ID should be greater than or equals to {1}", index, minXmlID));

                    if (numericValue > Int32.Parse(maxXmlID))
                        errorList.Add(string.Format("R{0}ID should be smaller than or equals to {1}", index, maxXmlID));
                }
            }
        }


        var error = string.Empty;
        var count = 1;
        foreach (var selectedError in errorList)
        {
            error += string.Format("{0}. {1} <br />", count, selectedError);
            count++;
        }

        return error;

    }
    #endregion




}

[Serializable]
class MatchRule
{
    public string XmlID { get; set; }
    public bool Rule1MatchType { get; set; }
    public bool Rule2MatchType { get; set; }
    public bool Rule3MatchType { get; set; }
    public bool Rule4MatchType { get; set; }
    public bool Rule5MatchType { get; set; }
}

