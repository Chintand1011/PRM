using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class webinquiry : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                BindLocations();
                BindReasonType();
                BindReadTypes();
                BindArchiveTypes();
            }
            catch (Exception)
            {
                throw;
            }

        }

        if (Request.Form["__EVENTTARGET"] == "ArchiveLead")
        {
            ArchiveLead();
            ViewState["ArchivePopup"] = "1";
        }

        popupCreditReport.VisibleOnPageLoad = false;
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

    private void BindReasonType()
    {
        var cmdParams = new Dictionary<string, object> {
        {"@PracticeID", ClientSession.PracticeID}, };
        var reasonTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_creditservicepractice_list", cmdParams);
        cmbReasonType.DataSource = reasonTypes;
        cmbReasonType.DataBind();
    }

    private void BindArchiveTypes()
    {
        cmbArchiveTypes.Items.Add(new RadComboBoxItem { Text = "Current Inquiries", Value = "0" });
        cmbArchiveTypes.Items.Add(new RadComboBoxItem { Text = "Archived Inquiries", Value = "1" });
        cmbArchiveTypes.Items.Add(new RadComboBoxItem { Text = "Both Current and Archived", Value = "-1" });

        cmbArchiveTypes.SelectedIndex = 0;
    }

    private void BindReadTypes()
    {
        cmbReadTypes.Items.Add(new RadComboBoxItem { Text = "Unread", Value = "0" });
        cmbReadTypes.Items.Add(new RadComboBoxItem { Text = "Read", Value = "1" });
        cmbReadTypes.Items.Add(new RadComboBoxItem { Text = "Both Unread and Read", Value = "-1" });
    }

    #endregion

    private DataTable GetPastInquiries(int creditApplicationID = 0)
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@LocationID", cmbLocations.SelectedValue},
                                {"@CreditServiceTypeID", cmbReasonType.SelectedValue},
                                {"@FlagNew", cmbReadTypes.SelectedValue},
                                {"@FlagArchive", cmbArchiveTypes.SelectedValue},
                                {"@LastName", txtName.Text},
                                {"@DateMin", dtDateMin.SelectedDate},
                                {"@DateMax", dtDateMax.SelectedDate},
                                {"@UserID", ClientSession.UserID}
                            };

        if (creditApplicationID > 0)
        {
            cmdParams.Add("@creditApplicationID", creditApplicationID);
        }

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_creditapplication_get", cmdParams);
    }

    protected void grdPastInquiries_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var rebindReason = e.RebindReason.ToString();
        if (rebindReason.Contains(GridRebindReason.DetailTableBinding.ToString()))
        {
            return;
        }

        grdPastInquiries.DataSource = GetPastInquiries();
    }

    private object GetInquiryDetailHtml(GridDetailTableDataBindEventArgs e)
    {
        var dataItem = e.DetailTableView.ParentItem;
        var creditApplicationID = dataItem.GetDataKeyValue("CreditApplicationID");
        var record = GetPastInquiries(int.Parse(creditApplicationID.ToString())).Rows[0];

        var html = string.Format("<table width='100%' cellpadding=0 cellspacing=0>" +
                                    "<tr>" +
                                        "<td width='160' valign='top'><div style='margin-bottom:5px; font-weight:600;'>Inquiry From:</div>{2}<br>{4} {5}<br>{6} {7}</td>" +
                                        "<td width='160' valign='top'><div style='margin-bottom:5px; font-weight:600;'>Contact:</div>{8} Phone<br>{9}<br>{3} DOB</td>" +
                                        "<td width='160' valign='top'><div style='margin-bottom:5px; font-weight:600;'>Interest:</div>{0}<br>Credit: {1}<br>Current Patient: {10}</td>" +
                                        "<td width='250' valign='top'><div style='margin-bottom:5px; font-weight:600;'>Patient Comments:</div>{11}</td>" +
                                        "<td valign='top'><div style='margin-bottom:5px; font-weight:600;'>Internal Notes: </div>" +
                                            "<textarea id='txtArea_{13}' style='font-family:calibri; font-size:1.1em; width: 100%; height: 52px; margin-bottom:10px;'>{12}</textarea></td>" +
                                     "</tr><tr>" +
                                        "<td colspan='4'>First Read:</b> {14} [{17}]  &nbsp | &nbsp  Last Updated: {15} [{16}] </td><td align='left'><img id='btn_{13}' src='../Content/Images/btn_update.gif' onclick='saveNotes({13})' style='margin-top:-10px;'/>" +
                                        "&nbsp; &nbsp; <span id='spnMessage_{13}' style='color:darkblue;'>&nbsp;</span></td>" +
                                     "</tr>" +
                                 "</table>",
                        record["CreditServiceAbbr"],
                        record["CreditClassAbbr"],
                        record["FullName"],
                        record["DateofBirth"],
                        record["Address1"],
                        record["Address2"],
                        record["CityStateAbbr"],
                        record["ZipCode"],
                        record["PhoneAbbr"],
                        record["Email"],
                        record["FlagCurrentPatientAbbr"],
                        record["PatientComment"],
                        record["Notes"],
                        creditApplicationID,
                        record["DateRead"],
                        record["DateModified"],
                        record["username"],
                        record["username"]
                    );

        return new ArrayList { new { Html = html } };

    }

    protected void grd_OnDetailTableDataBind(object sender, GridDetailTableDataBindEventArgs e)
    {
        e.DetailTableView.DataSource = GetInquiryDetailHtml(e);
    }


    protected void grdPastInquiries_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Archive":
                ViewState["CreditApplicationID"] = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditApplicationID"];
                var flagArchive = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagArchive"].ParseBool();
                ViewState["FlagArchive"] = flagArchive;

                if (ViewState["ArchivePopup"] == null && !flagArchive)
                {
                    radWindowDialog.RadConfirm("You are about to close this Lead, which will remove it from the current window. To see the message again, change the search filters above to include closed messages. No additional notifications will be made for this session.",
                                        "validateandArchiveLead", 500, 150, null, "", "../Content/Images/warning.png");
                }
                else
                {
                    ArchiveLead();
                }

                break;


            case "ExpandCollapse":
                var gridDataItem = (GridDataItem)e.Item;
                var status = gridDataItem["FlagNew"].Controls[0] as ImageButton;

                var functionName = string.Format("removeReadImage('{0}')", status.ClientID);
                ScriptManager.RegisterStartupScript(Page, typeof(Page), "removeImage", functionName, true);
                break;

            case "FlagMessage":
                var creditApplicationID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditApplicationID"];
                var flagMessage = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagMessage"].ParseBool();

                SqlHelper.ExecuteScalarProcedureParams("web_pr_creditapplication_add", new Dictionary<string, object>
                {
                    {"@CreditApplicationID", creditApplicationID},
                    {"@FlagMessage", !flagMessage},
                    {"@PracticeID", ClientSession.PracticeID},
                    {"@UserID", ClientSession.UserID}
                });

                grdPastInquiries.Rebind();
                KeepRowExpanded(creditApplicationID.ToString());
                break; 

        }
    }

    private void ArchiveLead()
    {
        var creditApplicationID = ViewState["CreditApplicationID"];
        var flagArchive = ViewState["FlagArchive"].ParseBool();

        var cmdParams = new Dictionary<string, object>
        {
            {"@CreditApplicationID", creditApplicationID},
            {"@FlagArchive", flagArchive ? 0 : 1},
            {"@UserID", ClientSession.UserID},
            {"@PracticeID", ClientSession.PracticeID}
        };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_creditapplication_add", cmdParams);

        
         var message = !flagArchive
                                        ? "This web inquiry is now archived."
                                        : "The record status has been reset. <br>Select the icon again to re-archive.";

        radWindowDialog.RadAlert(message, 400, 150, "", "", "../Content/Images/success.png");

        grdPastInquiries.Rebind();
    }


    protected void grdPastInquiries_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var detailView = e.Item.NamingContainer as GridTableView;
            if (detailView != null)
            {
                if (detailView.Name == "InquiryDetails")
                {
                    return;
                }
            }


            int TUPFSID;
            Int32.TryParse((item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["TUPFSID"]).ToString(), out TUPFSID);
            var imageButton = (ImageButton)item.FindControl("btnCreateTUPFS");

            if (TUPFSID > 0)
            {
                imageButton.ImageUrl = "~/Content/Images/view.png";
                imageButton.Attributes["FlagShowReport"] = "1";
            }
            else
            {
                imageButton.ImageUrl = "~/Content/Images/icon_add.png";
            }


            var flagNew = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagNew"].ParseBool();
            if (flagNew)
            {
                imageButton = (item["FlagNew"].Controls[0] as ImageButton);
                imageButton.ImageUrl = "~/content/Images/icon_new.png";
                imageButton.CssClass = "cursor-default";
            }


            var flagMessage = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagMessage"].ParseBool();
            var buttonFlag = item["FlagMessage"].Controls[0] as ImageButton;
            buttonFlag.ImageUrl = flagMessage ? "../Content/Images/icon_flagred.gif" : "../Content/Images/icon_flag_fade.gif";


            var gridArchiveButtonColumn = item["ArchiveView"].Controls[0] as ImageButton;
            var flagArchive = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagArchive"].ParseBool();
            if (flagArchive)
            {
                gridArchiveButtonColumn.ImageUrl = "../Content/Images/icon_unarchive.png";
            }



        }
    }



    protected void btnCreateTUPFS_OnClick(object sender, EventArgs e)
    {
        var button = (ImageButton)sender;
        var item = button.NamingContainer as GridDataItem;

        var flagShowReport = button.Attributes["FlagShowReport"].ParseBool();
        if (flagShowReport)
        {
            ClientSession.ObjectID = item.GetDataKeyValue("TUPFSID");
            ClientSession.ObjectID2 = null;
            ClientSession.ObjectType = ObjectType.PFSReportDetail;
            popupCreditReport.VisibleOnPageLoad = true;

            return;
        }

        ClientSession.ObjectType = ObjectType.PFSReportAddPatient;

        var firstName = item.GetDataKeyValue("NameFirst");
        var lastName = item.GetDataKeyValue("NameLast");
        var dob = item.GetDataKeyValue("DateOfBirth");
        var addr1 = item.GetDataKeyValue("Address1");
        var addr2 = item.GetDataKeyValue("Address2");
        var city = item.GetDataKeyValue("City");
        var state = item.GetDataKeyValue("StateAbbr");
        var zip = item.GetDataKeyValue("ZipCode");
        var phone = item.GetDataKeyValue("Phone");

        ClientSession.ObjectValue = new Dictionary<string, string>
                    {
                        {"CreditApplicationID", item.GetDataKeyValue("CreditApplicationID").ToString()},
                        {"TUPFSID",item.GetDataKeyValue("TUPFSID").ToString()},
                        {"FirstName", firstName.ToString()},
                        {"LastName", lastName.ToString()},
                        {"DOB", dob.ToString()},
                        {"Address1", addr1.ToString()},
                        {"Address2", addr2.ToString()},
                        {"City", city.ToString()},
                        {"StateAbbr", state.ToString()},
                        {"ZipCode", zip.ToString()},
                        {"Phone", phone.ToString()}
                    };


        Response.Redirect("~/credit/pfsutility.aspx");

    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        cmbLocations.ClearSelection();
        cmbReasonType.ClearSelection();
        cmbReadTypes.ClearSelection();
        cmbArchiveTypes.ClearSelection();
        grdPastInquiries.DataSource = new List<string>();
        grdPastInquiries.DataBind();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        grdPastInquiries.Rebind();
    }

    protected void btnReport_OnClick(object sender, EventArgs e)
    {
        grdPastInquiries.ExportSettings.FileName = "Web Inquiry Search Report";
        grdPastInquiries.ExportSettings.ExportOnlyData = true;
        grdPastInquiries.ExportSettings.IgnorePaging = true;

        grdPastInquiries.MasterTableView.GetColumn("View").Visible = false;

        foreach (GridColumn col in grdPastInquiries.MasterTableView.Columns)
            col.HeaderStyle.Width = Unit.Point(100);

        grdPastInquiries.MasterTableView.ExportToExcel();
    }


    protected void btnSaveNotes_OnClick(object sender, EventArgs e)
    {
        var cmdParams = new Dictionary<string, object>
        {
            {"@CreditApplicationID", hdnCreditApplicationID.Value},
            {"@Notes", hdnNotes.Value},
            {"@UserID", ClientSession.UserID},
            {"@PracticeID", ClientSession.PracticeID},
        };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_creditapplication_add", cmdParams);
        ScriptManager.RegisterStartupScript(Page, typeof(Page), "updatedMessageAndShowSuccessMessage", string.Format("updatedMessageAndShowSuccessMessage({0});", hdnCreditApplicationID.Value), true);

        hdnCreditApplicationID.Value = null;

    }

    private void KeepRowExpanded(string leadId)
    {
        var dataGridItem = grdPastInquiries.Items.Cast<GridDataItem>().Single(x => x.GetDataKeyValue("CreditApplicationID").ToString() == leadId);
        dataGridItem.Expanded = true;
    }

}