using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.UI.HtmlControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using Telerik.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.Utility;
using GridItem = Telerik.Web.UI.GridItem;

public partial class messagectr : BasePage
{

    #region Properties

    protected string ReplyMessage { get; set; }

    #endregion


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                BindLocations();
                BindProviders();
                BindTypes();
                BindStates();
                BindUsers();
                BindPriorities();
                ViewState["IsRebind"] = false;
                ViewState["Messages"] = new DataTable();
            }
            catch (Exception)
            {
                throw;
            }
        }

        if (Request.Form["__EVENTTARGET"] == "ArchiveMessage")
        {
            ArchiveMessage();
            ViewState["ArchivePopup"] = "1";
        }

        popupSendMessage.VisibleOnPageLoad = false;
        popupEditBlueCredit.VisibleOnPageLoad = false;
        popupPaymentPlan.VisibleOnPageLoad = false;
        popupManageAccounts.VisibleOnPageLoad = false;
        popupEstimateView.VisibleOnPageLoad = false;
        popupCreditReport.VisibleOnPageLoad = false;
        popupPaymentReceipt.VisibleOnPageLoad = false;
    }

    #region Bind Dropdowns and Manage Events

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

    private void BindTypes()
    {
        var types = SqlHelper.ExecuteDataTableProcedureParams("web_pr_messagetype_list", new Dictionary<string, object>());
        types.InsertValueIntoDataTable(0, "MessageTypeID", "Abbr", null, "All Types");
        cmbTypes.DataSource = types;
        cmbTypes.DataBind();
    }

    private void BindStates()
    {
        // States: 0 for Active, 1 for Closed and 3 for Both

        cmbStates.Items.Add(new RadComboBoxItem { Text = "Active", Value = "0" });
        cmbStates.Items.Add(new RadComboBoxItem { Text = "Closed", Value = "1" });
        cmbStates.Items.Add(new RadComboBoxItem { Text = "Both", Value = "3" });
        cmbStates.SelectedIndex = 0;
    }

    private void BindPriorities()
    {
        var priorities = SqlHelper.ExecuteDataTableProcedureParams("web_pr_messageprioritytype_list", new Dictionary<string, object>());
        priorities.InsertValueIntoDataTable(0, "MessagePriorityTypeID", "Abbr", null, "All Priorities");
        cmbPriority.DataSource = priorities;
        cmbPriority.DataBind();
    }


    private DataTable GetUsers()
    {
        var users = SqlHelper.ExecuteDataTableProcedureParams("web_pr_user_get", new Dictionary<string, object>
        {
            {"@PracticeID", ClientSession.PracticeID},
            {"@FlagAssign", 1},
            {"@FlagInactive", 0},
            {"@UserID", ClientSession.UserID}
        });

        return users;
    }

    private void BindUsers()
    {
        var users = GetUsers();

        // binding dropdown
        users.InsertValueIntoDataTable(0, "SysUserID", "NameAbbr", "-2", "[All Unassigned and Mine]"); // -2 Id for All unassigned and Mine
        users.InsertValueIntoDataTable(0, "SysUserID", "NameAbbr", null, "[All Users]");

        cmbUsers.DataSource = users;
        cmbUsers.DataBind();
        cmbUsers.SelectedIndex = 1; // would be default for All Unassigned and Mine

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


    protected void grdMessages_ItemDataBound(object sender, GridItemEventArgs e)
    {

        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var detailView = e.Item.NamingContainer as GridTableView;
            if (detailView != null)
            {
                if (detailView.Name == "MessageDetails")
                {
                    ShowMessageAndControls(item);
                    return;
                }
            }

            var flagRead = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagRead"]);
            var flagArchive = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagArchive"]);
            var flagMessage = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagMessage"]);

            // Adding bold style
            if (!flagRead)
            {
                var imageButton = (item["FlagRead"].Controls[0] as ImageButton);
                imageButton.ImageUrl = "~/content/Images/icon_new.png";
                imageButton.CssClass = "cursor-default";
            }

            // Displaying images
            var buttonFlag = item["Flag"].Controls[0] as ImageButton;
            buttonFlag.ImageUrl = flagMessage ? "../Content/Images/icon_flagred.gif" : "../Content/Images/icon_flag_fade.gif";


            var buttonArchive = item["ArchiveView"].Controls[0] as ImageButton;
            buttonArchive.ImageUrl = flagArchive ? "../Content/Images/icon_unarchive.png" : "../Content/Images/icon_archive.png";

            // Displaying priority Images
            var imageName = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ImageFilename"];
            var image = item.FindControl("imgPriority") as Image;
            image.ImageUrl = "../Content/Images/" + imageName;

            // Removing seconds from Date
            item["DateCreated"].Text = RemoveSecondsFromDate(item["DateCreated"].Text);

        }
    }



    protected DataTable GetMessages()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@FlagArchive", cmbStates.SelectedValue},
                                {"@PatientID", cmbPatients.SelectedValue},
                                {"@LocationID", cmbLocations.SelectedValue},
                                {"@ProviderID", cmbProviders.SelectedValue},
                                {"@DateMin", dtDateMin.SelectedDate},
                                {"@DateMax", dtDateMax.SelectedDate},
                                {"@MessageTypeID", cmbTypes.SelectedValue},
                                {"@MessageAssignUserID", cmbUsers.SelectedValue},
                                {"@MessagePriorityTypeID", cmbPriority.SelectedValue},
                                {"@UserId", ClientSession.UserID}
                             };
        var messages = SqlHelper.ExecuteDataTableProcedureParams("web_pr_message_get", cmdParams);
        return messages;
    }

    protected void grdMessages_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var messages = ViewState["Messages"] as DataTable;
        var isRebind = (bool)ViewState["IsRebind"];

        if (messages.Rows.Count == 0 || isRebind)
        {
            messages = GetMessages();
            ViewState["Messages"] = messages;
            ViewState["IsRebind"] = false;
        }

        grdMessages.DataSource = messages;
    }


    protected void grdMessages_OnDetailTableDataBind(object sender, GridDetailTableDataBindEventArgs e)
    {
        e.DetailTableView.DataSource = new ArrayList { new { Html = "This needs to be filled out" } };
    }

    protected void grdMessages_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Archive":

                ViewState["MessageID"] = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["MessageID"];
                var flagArchive = GetRow()["FlagArchive"].ParseBool();

                if (ViewState["ArchivePopup"] == null && !flagArchive)
                {
                    radConfirm.RadConfirm("You are about to close this message, which will remove it from the current window. To see the message again, change the search filters above to include closed messages. No additional notifications will be made for this session.",
                                        "validateandArchiveMessage", 500, 150, null, "", "../Content/Images/warning.png");
                }
                else
                {
                    ArchiveMessage();
                }
                break;


            case "Flag":
                var messageID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["MessageID"];
                ViewState["MessageID"] = messageID;
                var flagMessage = GetRow()["FlagMessage"].ParseBool();
                ManageFlagMessage(flagMessage);
                grdMessages.Rebind();
                KeepRowExpanded(messageID.ToString());
                break;

        }
    }



    protected void btnSearch_Click(object sender, EventArgs e)
    {
        ViewState["IsRebind"] = true;
        grdMessages.Rebind();
    }


    #endregion

    #region Message Body

    private void ShowMessageAndControls(GridItem item)
    {
        var parentDataItem = item.OwnerTableView.ParentItem;
        var messageAssignUserID = parentDataItem.GetDataKeyValue("MessageAssignUserID").ToString();

        var cmdParam = new Dictionary<string, object>
        {
            {"@MessageID", GetDataKeyValueFromParentItem(item, "MessageID")},
            {"@UserID", ClientSession.UserID}
        };

        if (messageAssignUserID == "-5") // -5 Id being used for un assigned user
        {
            cmdParam.Add("@FlagAutoAssign", 1);
            parentDataItem["MessageAssignUserName"].Text = string.Format("{0}, {1}", ClientSession.LastName, ClientSession.FirstName);
        }

        var dataTable = SqlHelper.ExecuteDataTableProcedureParams("web_pr_message_get", cmdParam);

        var row = dataTable.Rows[0];
        PopulateMessageInformation(item, row);
    }

    private void PopulateMessageInformation(GridItem item, DataRow row)
    {
        var subject = row["MessageSubject"].ToString();
        var literal = item.GetControl<Literal>("ltSubject");
        literal.Text = "<span style='font-size:1.3em; font-weight:600; line-height:2.0em;'>" + subject + "</span>";

        literal = item.GetControl<Literal>("ltDateTime");
        literal.Text = "<span style='font-size:1.0em; line-height:1.6em;';'> Sent: " + RemoveSecondsFromDate(row["DateCreated"].ToString()) + "</span>";

        var msgStatus = row["MessageStatusTypeHTML"].ToString();
        literal = item.GetControl<Literal>("ltMsgStatus");
        literal.Text = "<span style='font-size:1.0em; line-height:1.6em;';'> Status: " + msgStatus + "</span>";


        // Saving information in view state
        var patientID = row["PatientID"] == DBNull.Value ? 0 : Int32.Parse(row["PatientID"].ToString());
        var accountID = row["AccountID"].ToString();
        var statementID = row["StatementID"].ToString();
        var transactionID = row["TransactionId"].ToString();
        var pfsID = row["TUPFSID"].ToString();
        var bluecreditID = row["BlueCreditID"].ToString();
        var paymentPlanID = row["PaymentPlanID"].ToString();

        ViewState["MessageID"] = GetDataKeyValueFromParentItem(item, "MessageID");
        ViewState["PatientID"] = patientID;
        ViewState["AccountID"] = row["AccountID"];
        ViewState["BluecrditID"] = bluecreditID;
        ViewState["PaymentPlanID"] = paymentPlanID;
        ViewState["StatementID"] = statementID;
        ViewState["TransactionID"] = transactionID;
        ViewState["Subject"] = subject;
        ViewState["PFSID"] = pfsID;

        // Populate Information 

        var label = item.GetControl<Label>("lblContactNameAbbr");
        label.Text = row["ContactNameAbbr"].ToString();

        label = item.GetControl<Label>("lblPatient");
        label.Text = row["PatientName"].ToString();

        label = item.GetControl<Label>("lblContactAddr");
        label.Text = row["ContactAddr"].ToString();

        label = item.GetControl<Label>("lblContactCSZ");
        label.Text = row["ContactCSZ"].ToString();

        label = item.GetControl<Label>("lblContactPhone");
        label.Text = row["ContactPhone"].ToString();

        label = item.GetControl<Label>("lblContactEmail");
        label.Text = row["ContactEmail"].ToString();

        // label = item.GetControl<Label>("lblDoctor");
        // label.Text = row["ProviderName"].ToString();

        label = item.GetControl<Label>("lblType");
        label.Text = row["MessageTypeAbbr"].ToString();

        // label = item.GetControl<Label>("lblShowType");
        // label.Text = row["TransactionID"].ToString();

        label = item.GetControl<Label>("lblPriority");
        label.Text = row["MessagePriorityTypeAbbr"].ToString();

        label = item.GetControl<Label>("lblDueDate");
        label.Text = row["MessageDueDate"].ToString();

        label = item.GetControl<Label>("lblRestricted");
        label.Text = row["MessageRoleTypeAbbr"].ToString();

        // label = item.GetControl<Label>("lblTotalDue");
        // label.Text = row["PatientBalSum$"].ToString();

        // label = item.GetControl<Label>("lblTotalPaid");
        // label.Text = row["PatientPaySum$"].ToString();

        // label = item.GetControl<Label>("lblShowStatement");
        // label.Text = row["StatementID"].ToString();

        // label = item.GetControl<Label>("lblShowProfile");
        // label.Text = row["PatientID"].ToString();

        // label = item.GetControl<Label>("lblBlueCredit");
        // label.Text = row["CreditPlanAbbr"].ToString();

        label = item.GetControl<Label>("lblDateRead");
        label.Text = RemoveSecondsFromDate(row["MessageReadDate"].ToString());

        label = item.GetControl<Label>("lblReadUserName");
        var username = row["MessageReadUserName"].ToString();
        if (!string.IsNullOrEmpty(username))
        {
            label.Text = string.Format("[{0}]", username);    
        }
        
        label = item.GetControl<Label>("lblDateArchived");
        label.Text = RemoveSecondsFromDate(row["MessageArchiveDate"].ToString());

        label = item.GetControl<Label>("lblArchiveUserName");
        username = row["MessageArchiveUserName"].ToString();
        if (!string.IsNullOrEmpty(username))
        {
            label.Text = string.Format("[{0}]", username);
        }
        
        // Textarea notes

        var flagReply = row["FlagReply"].ParseBool();
        var boldControl = item.GetControl<HtmlGenericControl>("bReplyLabel");
        boldControl.InnerText = flagReply ? "Edit:" : "Reply:";

        ReplyMessage = row["MessageReply"].ToString();

        var textboxNotes = item.GetControl<TextBox>("txtNotes");
        textboxNotes.Text = row["MessageNotes"].ToString();

        // Message Body
        var div = item.GetControl<HtmlGenericControl>("divMessageBody");
        div.InnerHtml = row["MessageBody"].ToString();

        // Managing buttons 
        var button = item.GetControl<RadButton>("btnPatient");
        button.Enabled = patientID > 0;
        button.Visible = button.Enabled;

        button = item.GetControl<RadButton>("btnStatement");
        button.Enabled = !string.IsNullOrEmpty(statementID) && patientID > 0;
        button.Visible = button.Enabled;

        button = item.GetControl<RadButton>("btnTransaction");
        button.Enabled = !string.IsNullOrEmpty(transactionID) && patientID > 0;
        button.Visible = button.Enabled;

        button = item.GetControl<RadButton>("btnPayPlan");
        button.Enabled = !string.IsNullOrEmpty(paymentPlanID) && patientID > 0;
        button.Visible = button.Enabled;

        button = item.GetControl<RadButton>("btnBluecredit");
        button.Enabled = !string.IsNullOrEmpty(bluecreditID) && patientID > 0;
        button.Visible = button.Enabled;

        button = item.GetControl<RadButton>("btnPfs");
        button.Enabled = !string.IsNullOrEmpty(pfsID) && patientID > 0;
        button.Visible = button.Enabled;

        // Binding user dropdown
        var dropdown = item.GetControl<RadComboBox>("cmbAllUsers");
        dropdown.DataSource = GetUsers();
        dropdown.DataBind();

        dropdown.SelectedValue = row["MessageAssignUserID"].ToString();


        // Managing labels

        if (patientID > 0)
        {
            var divPatient = item.GetControl<HtmlControl>("divPatientID");
            divPatient.Visible = true;

            //var lblPatient = item.GetControl<Label>("lblPatientID");
            //lblPatient.Text = patientID.ToString();
        }

        if (!string.IsNullOrEmpty(accountID))
        {
            var divAccountID = item.GetControl<HtmlControl>("divAccountID");
            // divAccountID.Visible = true;
            divAccountID.Visible = false;

            var lblAccountID = item.GetControl<Label>("lblAccountID");
            lblAccountID.Text = accountID;
        }

        if (!string.IsNullOrEmpty(bluecreditID))
        {
            var divBluecreditId = item.GetControl<HtmlControl>("divBluecreditId");
            divBluecreditId.Visible = true;

            var requestedLabel = item.GetControl<Label>("lblBluecreditID");
            requestedLabel.Text = bluecreditID;

            // requestedLabel = item.GetControl<Label>("lblCreditPlanAbbr");
            // requestedLabel.Text = row["CreditPlanAbbr"].ToString();
        }

        if (!string.IsNullOrEmpty(paymentPlanID))
        {
            var divPaymentPlanID = item.GetControl<HtmlControl>("divPaymentPlanID");
            divPaymentPlanID.Visible = true;

            var requestedLabel = item.GetControl<Label>("lblPaymentPlanID");
            requestedLabel.Text = paymentPlanID;

        }

        if (!string.IsNullOrEmpty(statementID))
        {
            var divStatementID = item.GetControl<HtmlControl>("divStatementID");
            divStatementID.Visible = true;

            var requestedLabel = item.GetControl<Label>("lblStatementID");
            requestedLabel.Text = statementID;

            requestedLabel = item.GetControl<Label>("lblPatientBal");
            requestedLabel.Text = row["PatientBalSum$"].ToString();

            requestedLabel = item.GetControl<Label>("lblPatientPay");
            requestedLabel.Text = row["PatientPaySum$"].ToString();
        }

        if (!string.IsNullOrEmpty(transactionID))
        {
            var divTransactionID = item.GetControl<HtmlControl>("divTransactionID");
            divTransactionID.Visible = true;

            var lblTransactionID = item.GetControl<Label>("lblTransactionID");
            lblTransactionID.Text = transactionID;
        }

        if (!string.IsNullOrEmpty(pfsID))
        {
            var divPFSID = item.GetControl<HtmlControl>("divPFSID");
            divPFSID.Visible = true;

            var lblPFSID = item.GetControl<Label>("lblPFSID");
            lblPFSID.Text = pfsID;
        }

        // Managing flags

        // Flag
        var flagMessage = GetDataKeyValueFromParentItem(item, "FlagMessage").ParseBool();
        button = item.GetControl<RadButton>("btnFlag");
        button.Text = flagMessage ? "Un Flag" : "Flag";

        // Archive
        var flagArchived = GetDataKeyValueFromParentItem(item, "FlagArchive").ParseBool();
        button = item.GetControl<RadButton>("btnClose");
        button.Text = flagArchived ? "Re open" : "Close";

        //button = item.GetControl<RadButton>("btnArchive");
        //button.Attributes["FlagState"] = flagArchived ? "1" : "0";

        // Read
        if (flagArchived)
        {
            button = item.GetControl<RadButton>("btnUnRead");
            button.Enabled = false;
        }

        var flagRead = row["FlagRead"].ParseBool();
        if (!flagRead)
        {
            ManageReadFunctionality(item, false);
        }
        else
        {
            ManageMessageFlagState(item, false);
        }
    }


    protected void ProcessCommands(object sender, EventArgs e)
    {
        var button = sender as RadButton;
        var dropDown = sender as RadComboBox;

        var commandName = button != null ? button.Attributes["Command"] : dropDown.Attributes["Command"];
        var messageID = ViewState["MessageID"];

        GridDataItem item;

        switch (commandName)
        {
            case "Patient":
                SavePatientInformationIntoSession();
                hdnIsRedirectToStatus.Value = "1";
                break;

            case "Statement":
                SavePatientInformationIntoSession();

                ClientSession.ObjectID = Int32.Parse(ViewState["StatementID"].ToString());
                ClientSession.ObjectType = ObjectType.Statement;

                popupEstimateView.VisibleOnPageLoad = true;
                break;
            case "Transaction":
                ClientSession.ObjectID = ViewState["TransactionID"];
                ClientSession.ObjectType = ObjectType.PaymentReceipt;
                ClientSession.EnablePrinting = false;
                ClientSession.EnableClientSign = false;
                popupPaymentReceipt.VisibleOnPageLoad = true;
                break;
            case "PayPlan":
                SavePatientInformationIntoSession();
                var paymentPlanID = ViewState["PaymentPlanID"];
                ClientSession.ObjectType = ObjectType.EditPaymentPlan;
                ClientSession.ObjectValue = 0m;
                ClientSession.ObjectID2 = Convert.ToInt32(paymentPlanID);
                popupPaymentPlan.VisibleOnPageLoad = true;
                break;
            case "Bluecredit":
                SavePatientInformationIntoSession();
                var blueCreditID = ViewState["BluecrditID"].ToString();
                ClientSession.ObjectID = Int32.Parse(blueCreditID);
                ClientSession.ObjectType = ObjectType.BlueCreditDetail;
                popupEditBlueCredit.VisibleOnPageLoad = true;
                break;
            case "PFS":
                ClientSession.ObjectID = Int32.Parse(ViewState["PFSID"].ToString());
                ClientSession.ObjectID2 = Int32.Parse(ViewState["PatientID"].ToString());
                ClientSession.ObjectType = ObjectType.PFSReportDetail;
                popupCreditReport.VisibleOnPageLoad = true;
                break;
            case "AssignUser":

                var userName = dropDown.SelectedItem.Text;
                item = (dropDown.NamingContainer as GridDataItem).OwnerTableView.ParentItem;
                item["MessageAssignUserName"].Text = userName;

                GetRow()["MessageAssignUserName"] = userName;

                var cmbParams = new Dictionary<string, object>
                {
                    {"@MessageID", messageID},
                    {"@MessageAssignUserID", dropDown.SelectedValue},
                    {"@UserID", ClientSession.UserID}
                };

                SqlHelper.ExecuteScalarProcedureParams("web_pr_message_add", cmbParams);
                radConfirm.RadAlert("User successfully Updated.", 350, 150, "", "", "../Content/Images/success.png");



                break;
            case "FlagMessage":

                var flagMessage = GetRow()["FlagMessage"].ParseBool();

                // Updating image for the parent record
                item = (button.NamingContainer as GridDataItem).OwnerTableView.ParentItem;
                var buttonFlag = item["Flag"].Controls[0] as ImageButton;
                buttonFlag.ImageUrl = flagMessage ? "../Content/Images/icon_flag_fade.gif" : "../Content/Images/icon_flagred.gif";

                ManageFlagMessage(flagMessage);

                button.Text = !flagMessage ? "Un Flag" : "Flag";
                button.Attributes["FlagState"] = flagMessage ? "0" : "1";

                break;

            case "UnRead":
                item = button.NamingContainer as GridDataItem;
                var flagRead = button.Attributes["FlagState"].ParseBool();
                ManageReadFunctionality(item, flagRead);
                break;

            case "Forward":
                popupSendMessage.VisibleOnPageLoad = true;
                break;


        }

    }

    #endregion

    #region Manage Rad Toolbar Stuff and Flags functionality


    private void SavePatientInformationIntoSession()
    {
        var patientID = Int32.Parse(ViewState["PatientID"].ToString());
        var accountID = Int32.Parse(ViewState["AccountID"].ToString());

        ClientSession.SelectedPatientID = patientID;
        ClientSession.SelectedPatientAccountID = accountID;
        (new UserLogin()).LoadPatientIntoSession();
    }



    private void ManageReadFunctionality(GridItem item, bool flagRead)
    {
        SqlHelper.ExecuteScalarProcedureParams("web_pr_message_add", new Dictionary<string, object>
                            {
                                {"@MessageID", GetDataKeyValueFromParentItem(item, "MessageID")},
                                {"@FlagRead", !flagRead},
                                {"@UserID", ClientSession.UserID}
                            });



        ManageMessageFlagState(item, flagRead);
    }

    private void ManageMessageFlagState(GridItem item, bool flagRead)
    {
        var button = item.GetControl<RadButton>("btnUnRead");
        var parentItem = item.OwnerTableView.ParentItem;
        var imageButton = (parentItem["FlagRead"].Controls[0] as ImageButton);

        button.Text = !flagRead ? "Unread" : "Read";
        button.Attributes["FlagState"] = flagRead ? "0" : "1";
        imageButton.ImageUrl = !flagRead ? "~/Content/images/spacer_transparent.gif" : "../content/Images/icon_new.png";

        // Uupdate the view data
        GetRow()["FlagRead"] = !flagRead;
    }

    protected void MakeMessageArchive(object sender, EventArgs e)
    {
        var radButton = sender as RadButton;

        var flagArchive = GetRow()["FlagArchive"].ParseBool();

        RequestMessageArchive(flagArchive);
        ShowArchiveMessage(flagArchive);

        // Updating text and image in Toolbar button
        radButton.Text = !flagArchive ? "Re Open" : "Close";
        radButton.Attributes["FlagState"] = flagArchive ? "0" : "1";

        grdMessages.Rebind();

    }


    private void RequestMessageArchive(bool flagArchive)
    {
        var messageID = (Int32)ViewState["MessageID"];

        SqlHelper.ExecuteScalarProcedureParams("web_pr_message_add", new Dictionary<string, object>
                            {
                                {"@MessageID", messageID},
                                {"@FlagArchive", !flagArchive},
                                {"@UserID", ClientSession.UserID}
                            });

        GetRow()["FlagArchive"] = !flagArchive;


    }

    private void ManageFlagMessage(bool flagMessage)
    {
        var messageID = (Int32)ViewState["MessageID"];

        SqlHelper.ExecuteScalarProcedureParams("web_pr_message_add", new Dictionary<string, object>
                {
                    {"@MessageID", messageID},
                    {"@FlagMessage", !flagMessage},
                    {"@UserID", ClientSession.UserID}
                });

        GetRow()["FlagMessage"] = !flagMessage;
    }

    private void ShowArchiveMessage(bool flagArchive)
    {
        radConfirm.RadAlert(!flagArchive
                                    ? "This message is now archived."
                                    : "The record status has been reset. <br>Select the icon again to re-archive.",
                                    350, 150, "", "", "../Content/Images/success.png");
    }

    #endregion

    #region Send Email

    protected void btnSendMessage_OnClick(object sender, EventArgs e)
    {
        try
        {
            var messageID = (Int32)ViewState["MessageID"];
            var code = 0;

            // Getting message body according to the messageId
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_message_get", new Dictionary<string, object> { { "@MessageID", messageID }, { "@UserID", ClientSession.UserID } });
            foreach (DataRow row in reader.Rows)
            {
                var practiceID = (int)row["PracticeID"];
                var userName = row["UserName"].ToString();
                var messageSubject = row["MessageSubject"].ToString();
                var messageDate = row["DateCreated"].ToString();
                var messageBody = row["MessageBody"].ToString();
                var type = row["MessageTypeAbbr"].ToString();
                var priorityType = row["MessagePriorityTypeAbbr"].ToString();
                var patientName = row["PatientName"].ToString();
                var providerName = row["ProviderName"].ToString();
                var practiceName = row["PracticeName"].ToString();
                var userEmail = row["UserEmail"].ToString();
                var forwardEmailSubject = row["FwdEmailSubject"].ToString();

                code = EmailServices.SendMessageFwd(messageID, practiceID, userName, ClientSession.UserID, messageSubject,
                       messageDate, txtNote.Text, messageBody, type, priorityType, patientName, providerName, practiceName,
                       Request.Url.AbsolutePath, txtEmail.Text, userEmail, forwardEmailSubject, ClientSession.IPAddress);
            }

            var isFailure = code != (int)EmailCode.Succcess;
            radConfirm.RadAlert(isFailure ? "An unknown error was encountered." : "Email successfully sent.", 350, 150, "", isFailure ? "showMessagePopup" : "", isFailure ? "../Content/Images/warning.png" : "../Content/Images/success.png");
        }
        catch (Exception ex)
        {
            radConfirm.RadAlert(ex.Message.Replace("'", string.Empty), 400, 100, "", "showMessagePopup");
        }

    }

    #endregion

    #region Utilities

    protected void btnClear_OnClick(object sender, EventArgs e)
    {
        cmbPatients.ClearSelection();
        cmbPatients.Text = string.Empty;
        cmbLocations.ResetSelection(ClientSession.FlagPtSearchLocationDefault, ClientSession.DefaultLocationID);
        cmbProviders.ResetSelection(ClientSession.FlagPtSearchProviderDefault, ClientSession.DefaultProviderID);
        cmbStates.ClearSelection();
        cmbStates.SelectedIndex = 0;
        cmbTypes.ClearSelection();
        dtDateMin.Clear();
        dtDateMax.Clear();
        cmbUsers.ClearSelection();
        cmbPriority.ClearSelection();
        grdMessages.DataSource = new List<string>();
        grdMessages.DataBind();
    }

    protected void btnCreatePDF_OnClick(object sender, EventArgs e)
    {
        Common.CreateandViewPDF();
        hdnIsShowPDFViewer.Value = "1";
    }

    #endregion

    #region Save Message Reply or Notes

    protected void SaveMessageNotesOrReply(object sender, EventArgs e)
    {
        var button = (sender as ImageButton);
        var dataItem = button.NamingContainer as GridDataItem;

        var requestedMessageID = GetDataKeyValueFromParentItem(dataItem, "MessageID").ToString();
        var cmdParams = new Dictionary<string, object> { { "@MessageID", requestedMessageID }, { "@UserID", ClientSession.UserID } };

        string message;
        TextBox textBox;

        if (button.Attributes["Command"] == "SaveReply")
        {
            textBox = dataItem.GetControl<TextBox>("txtReply");
            cmdParams.Add("@MessageReply", textBox.Text);
            GetRow()["FlagReply"] = true;
            message = "Message reply sent.";
        }
        else
        {
            textBox = dataItem.GetControl<TextBox>("txtNotes");
            cmdParams.Add("@MessageNotes", textBox.Text);
            message = "Record successfully saved.";
        }

        SqlHelper.ExecuteScalarProcedureParams("web_pr_message_add", cmdParams);
        radConfirm.RadAlert(message, 350, 150, "", "", "../Content/Images/success.png");

        grdMessages.Rebind();
        KeepRowExpanded(requestedMessageID);

    }

    #endregion

    #region Redirect To PaymentPlan or Bluecredit

    protected void btnAssignValues_OnClick(object sender, EventArgs e)
    {
        var paymentPlanID = ViewState["PaymentPlanID"];
        var blueCreditID = ViewState["BluecrditID"];
        var isBlueCredit = hdnIsRedirectToBluecredit.Value == "1";

        if (isBlueCredit)
        {
            ClientSession.ObjectID = Convert.ToInt32(blueCreditID);
            ClientSession.ObjectType = ObjectType.BlueCreditDetail;
            ClientSession.IsBlueCreditAddRequest = false;
        }
        else
        {
            ClientSession.ObjectType = ObjectType.EditPaymentPlan;
            ClientSession.ObjectValue = 0m;
            ClientSession.ObjectID2 = Convert.ToInt32(paymentPlanID);
            ClientSession.IsBlueCreditAddRequest = false;
        }
    }

    #endregion

    #region Common functions

    private void ArchiveMessage()
    {
        var flagArchive = GetRow()["FlagArchive"].ParseBool();
        RequestMessageArchive(flagArchive);
        ShowArchiveMessage(flagArchive);
        grdMessages.Rebind();
    }

    private object GetDataKeyValueFromParentItem(GridItem item, string dataKey)
    {
        var parentContainer = item.OwnerTableView.ParentItem;
        return parentContainer.GetDataKeyValue(dataKey);
    }

    private DataRow GetRow()
    {
        var messageID = (Int32)ViewState["MessageID"];
        var messages = ViewState["Messages"] as DataTable;
        var message = messages.Select("MessageID = " + messageID);

        return message.Single();
    }

    private void KeepRowExpanded(string messageID)
    {
        var dataGridItem = grdMessages.Items.Cast<GridDataItem>().Single(x => x.GetDataKeyValue("MessageID").ToString() == messageID);
        dataGridItem.Expanded = true;
    }

    private static string RemoveSecondsFromDate(string date)
    {
        try
        {
            DateTime requestedDate;
            DateTime.TryParse(date, out requestedDate);
            var lol = string.Format("{0:MM/dd/yyyy h:mm tt}", requestedDate);
            return lol;
        }
        catch (Exception)
        {
            return "N/A";
        }
    }

    #endregion

}