using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.DynamicData;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using System.Data;
using Telerik.Web.UI;

public partial class patient_bluecredit : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // Validating if user has permission to access the Bluecredit page or not, if not then being redirected to the error page.
            ValidateUser();
            try
            {
                // checking if "web_pr_bluecredit_get" proc have records > 0, if yes then else case will run
                if (!HasActiveCreditAccount())
                {
                    pnlAccountStatus.Visible = true;
                    var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_status", new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID } });
                    foreach (DataRow row in reader.Rows)
                    {
                        // if user recently requested for the bluecredit then showing the message that 
                        pStatus.InnerText = row["StatusNote"].ToString();
                        pStatus.Visible = true;
                    }
                    if (reader.Rows.Count == 0)
                    {
                        divNoCreditAccount.Visible = true;

                        var cmdParams = new Dictionary<string, object>()
                        {
                            {"@PatientID", ClientSession.PatientID},
                            {"@PracticeID", ClientSession.PracticeID}
                        };

                        var showApplyNowButton = SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecredit_pt_status", cmdParams);
                        divApplyNow.Visible = Convert.ToBoolean(showApplyNowButton);

                    }
                }
                else
                {
                    pnlActiveAccounts.Visible = true;
                    // lnkIncreaseCredit.Visible = false;

                    //GetActiveCreditAccount();
                    grdActiveAccounts.Rebind();
                    //GetAppliedCreditHistory();
                    grdHistoryAppliedCredits.Rebind();
                    // hide the panel of Outstanding Statement sUnassigned if there is atleast one active Blue Credit
                    pnlOutstandingStatementsUnassigned.Visible = false;
                }
            }
            catch (Exception)
            {
                throw;
            }

        }

        // preventing the popup to load on the page load
        popupEditBlueCredit.VisibleOnPageLoad = false;
        popupTransactionHistory.VisibleOnPageLoad = false;
    }

    protected void Page_LoadComplete(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            var rowCount = grdActiveAccounts.Items.Count;
            divHistoryAppliedCreditsGrid.Visible = rowCount > 0;
        }
    }

    private void ValidateUser()
    {
        if (!ClientSession.IsAllowBlueCredit) Response.Redirect("error.aspx");
    }

    #region Apply Credit Account

    private bool HasActiveCreditAccount()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID }, { "@PracticeID", ClientSession.PracticeID }, { "@FlagExists", 1 } };
        var value = SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecredit_get", cmdParams);
        return Convert.ToBoolean(value); //Returns true, if there is already active credit account
    }


    private DataTable GetCreditsAppliedAmounts()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@AccountID", ClientSession.AccountID }, 
            { "@Flagcurrent", 1 },
            { "@Flagbalance", 1 }
        };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
    }

    protected void grdCreditsApplied_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdCreditsApplied.DataSource = GetCreditsAppliedAmounts();
    }

    protected void grdCreditsApplied_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Download":
                // Downloading the file
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString();
                var filePathUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FilePathStatements"].ToString();
                var fileName = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FileName"].ToString();
                ViewState["FilePath"] = GetSource(filePathUrl, fileName);
                hdnDownload.Value = "true";
                break;
        }
    }

    protected void grdCreditsApplied_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;

            // Displaying images for payplan and creditplan
            var imgPayPlan = item.FindControl("imgPayPlan") as Image;
            var imgCreditPlan = item.FindControl("imgCreditPlan") as Image;
            var payPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditPayAbbr"].ToString();
            var creditPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditPlanAbbr"].ToString();
            imgPayPlan.ImageUrl = payPlan == YesNo.Yes.ToString() ? "~/Content/Images/icon_yes.png" : "~/Content/Images/icon_dash.png";
            imgCreditPlan.ImageUrl = creditPlan == YesNo.Yes.ToString() ? "~/Content/Images/icon_yes.png" : "~/Content/Images/icon_dash.png";


        }
    }


    protected void gridOutstandingStatementsUnassigned_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientId", ClientSession.PatientID }, { "@FlagCreditPlan", 0 }, { "@FlagCurrent", 1 }, { "@FlagBalance", 1 } };
        var statements = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);

        //Hidding the Test & Calculate button in case of Outstanding grid is empty
        if (statements.Rows.Count == 0)
            btnRequestAssignment.Visible = false;

        gridOutstandingStatementsUnassigned.DataSource = statements;
    }


    protected void gridOutstandingStatementsUnassigned_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "View":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString();
                var filePathUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FilePathStatements"].ToString();
                var fileName = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FileName"].ToString();
                ViewState["FilePath"] = GetSource(filePathUrl, fileName);
                hdnDownload.Value = "true";
                break;
        }
    }

    protected void btnApplynow_Click(object sender, EventArgs e)
    {
        pnlAccountStatus.Visible = false;
        grdActiveAccounts.Rebind();
        grdCreditsApplied.Rebind();
        grdHistoryAppliedCredits.Rebind();
        const int addMessageTypeID = (Int32)AddMessageTypes.BCNewAccount;
        AddMessage(addMessageTypeID, 0, 0);
        radWindowDialog.RadAlert("Your request for BlueCredit financing has been submitted to your provider. If you are not contacted within two business days, we recommend following up with the billing department for details.", 520, 150, string.Empty, "reloadPage", "Content/Images/Success.png");
    }


    #endregion

    #region Credit Active Account

    private DataTable GetActiveCreditAccount()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID }, { "@PracticeID", ClientSession.PracticeID }, { "@FlagBalance", 1 } };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_get", cmdParams);
    }

    protected void grdActiveAccounts_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdActiveAccounts.DataSource = GetActiveCreditAccount();
    }

    protected void grdActiveAccounts_ItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "ViewTransactionHistory":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["BlueCreditID"];
                popupTransactionHistory.VisibleOnPageLoad = true;
                break;

            case "EditAccountStatus":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["BlueCreditID"];
                popupEditBlueCredit.VisibleOnPageLoad = true;
                ClientSession.ObjectType = ObjectType.BlueCredit; //ObjectType.BlueCredit;
                break;
        }
    }

    private DataTable GetAppliedCreditHistory()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientId", ClientSession.PatientID }, { "@FlagCreditPlan", 1 }, { "@FlagBalance", 1 } };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
    }

    protected void grdHistoryAppliedCredits_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdHistoryAppliedCredits.DataSource = GetAppliedCreditHistory();
    }
    

    protected void grdHistoryAppliedCredits_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "Download":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"].ToString();
                var filePathUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FilePathStatements"].ToString();
                var fileName = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FileName"].ToString();
                ViewState["FilePath"] = GetSource(filePathUrl, fileName);
                hdnDownload.Value = "true";
                break;
        }
    }

    protected void btnDownload_Click(object sender, EventArgs e)
    {
        var path = ViewState["FilePath"].ToString();
        var returnmsg = PDFServices.FileDownload(path, "Statement.pdf");
        if (returnmsg != "")
        {
            path = Path.GetDirectoryName(path);
            var url = ClientSession.WebPathRootPatient + "report/estimateview_popup.aspx?StatementID=" + ClientSession.ObjectID;
            PDFServices.PDFCreate("Statement.pdf", url, path);
            PDFServices.DownloadandDeleteFile(path, "Statement.pdf");

        }

    }

    private string GetSource(string filePathUrl, string fileName)
    {
        return Path.Combine(filePathUrl, fileName);
    }

    #endregion

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("bluecredit.aspx");

    }

    protected void btnClose_Click(object sender, EventArgs e)
    {
        grdActiveAccounts.Rebind();
        grdCreditsApplied.Rebind();
        grdHistoryAppliedCredits.Rebind();
        Response.Redirect("bluecredit.aspx");
    }

    protected void btnRequestAssignment_OnClick(object sender, EventArgs e)
    {
        try
        {
            // Getting Highest bluecredit ID
            var bluecreditID = (from GridDataItem item in grdActiveAccounts.Items select Int32.Parse(item.GetDataKeyValue("BlueCreditID").ToString())).Concat(new[] { 0 }).Max();

            var allCheckedReocrds = from GridDataItem item in gridOutstandingStatementsUnassigned.Items
                                    let checkbox = item.FindControl("chkStatement") as CheckBox
                                    where checkbox.Checked
                                    select item;

            foreach (var item in allCheckedReocrds)
            {
                var statementID = Convert.ToInt32(item.GetDataKeyValue("StatementID"));
                var cmdParams = new Dictionary<string, object>
                                 {
                                     { "@BlueCreditRequestTypeID", 0 },
                                     { "@PatientID", ClientSession.PatientID },
                                     { "@BlueCreditID", bluecreditID },
                                     { "@StatementID", statementID },
                                     { "@IPAddress", ClientSession.IPAddress},
                                     { "@UserID", ClientSession.UserID }
                                     };

                SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecreditrequest_add", cmdParams);

                const int addMessageTypeID = (Int32)AddMessageTypes.BCAssignment;
                AddMessage(addMessageTypeID, bluecreditID, statementID);

            }

            radWindowDialog.RadAlert("A request to add the selected statements to your account has been submitted. If your account status permits this addition, your provider will discuss the impact to your minimum payment before making any changes.", 500, 150, string.Empty, "reloadPage", "Content/Images/Success.png");

        }
        catch (Exception ex)
        {
            var errorMessage = ex.Message.Replace("'", string.Empty).Replace("\r\n", string.Empty);
            radWindowDialog.RadAlert(string.Format("<p>{0}</p>", errorMessage), 400, 150, string.Empty, "reloadPage", "Content/Images/warning.png");
        }

    }

    private void AddMessage(Int32 addMessageTypeID, Int32 bluecreditID, Int32 statementID)
    {
        var cmdParams = new Dictionary<string, object>
                {
                     { "@PracticeID", ClientSession.PracticeID },
                     { "@PatientID", ClientSession.PatientID },
                     { "@AccountID", ClientSession.AccountID },
                     { "@BlueCreditID", bluecreditID },
                     { "@StatementID", statementID },
                     { "@MessageEnumID", addMessageTypeID },
                     };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_message_add", cmdParams);
    }


    protected void chk_OnChanged(object sender, EventArgs e)
    {
        var ischecked = false;
        foreach (var chkSelect in gridOutstandingStatementsUnassigned.Items.Cast<GridDataItem>().Select(item => (CheckBox)item.FindControl("chkStatement")).Where(chkSelect => chkSelect.Checked))
        {
            ischecked = true;
        }
        btnRequestAssignment.ImageUrl = ischecked ? "Content/Images/btn_submit.gif" : "Content/Images/btn_submit_fade.gif";
        btnRequestAssignment.Enabled = ischecked;
    }
}