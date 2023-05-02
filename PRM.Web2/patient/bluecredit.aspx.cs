using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.IO;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using Telerik.Web.UI;
using PatientPortal.Utility;

public partial class bluecredit : BasePage
{
    protected bool FlagGuardianPay
    {
        get
        {
            return ClientSession.SelectedPatientInformation["FlagGuardianPay"].ParseBool();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetNotesOnPatientAccount();
            ValidateAndDeleteOrphanStatements();
        }

        popupApplyCredit.VisibleOnPageLoad = false;
        popupActiveStatements.VisibleOnPageLoad = false;
        popupCreditReport.VisibleOnPageLoad = false;
        popupEditBlueCredit.VisibleOnPageLoad = false;
        popupTruthInLending.VisibleOnPageLoad = false;
        popupEstimateView.VisibleOnPageLoad = false;
        popupTransactionHistory.VisibleOnPageLoad = false;
        popupPaymentReceipt.VisibleOnPageLoad = false;
        popupBCLoan.VisibleOnPageLoad = false;

        CreateUpdateBluecreditAccount();

        if (IsPostBack)
        {
            GetSelectedReportInformation();
        }


        if (Request.Form["__EVENTTARGET"] == "BCApplyCredit")
        {
            btnAssign_Click(this, new EventArgs());
        }

        if (Request.Form["__EVENTTARGET"] == "DeleteOrphanStatements")
        {
            DeleteOrphanStatement();
        }

    }

    protected void Page_LoadComplete(object sender, EventArgs e)
    {
        var rowCount = grdActiveStatements.Items.Count;
        addStatementMessage.Visible = rowCount == 0;

        OpenBcLoanPopup();
    }

    private void ValidateAndDeleteOrphanStatements()
    {
        var objectValues = ClientSession.ObjectValue as Dictionary<string, object>;
        if (objectValues != null && objectValues.ContainsKey("FlagBCLoan"))
        {
            ClientSession.ObjectValue = null;
            DeleteOrphanStatement();
        }
    }

    private void DeleteOrphanStatement()
    {
        var cmdParams = new Dictionary<string, object>
            {
                {"PatientID", ClientSession.SelectedPatientID},
            };

        SqlHelper.ExecuteScalarProcedureParams("svc_statements_cleanup", cmdParams);
    }

    #region Bluecredit Loan

    private void OpenBcLoanPopup()
    {
        if (Page.IsPostBack) return;
        
        popupBCLoan.VisibleOnPageLoad = Request.Params["BCLoan"].ParseBool(); ;
    }

    #endregion


    #region Credit Account

    private DataTable GetCreditAccounts()
    {
        var cmdParams = new Dictionary<string, object>
        {
            {"@PatientId", ClientSession.SelectedPatientID},
            {"@PracticeID", ClientSession.PracticeID},
            {"@FlagInactive", 1},
            {"@UserID", ClientSession.UserID}
        };
        var creditAccounts = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_get", cmdParams);
        return creditAccounts;
    }

    protected void grdCreditAccounts_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdCreditAccounts.DataSource = GetCreditAccounts();
    }

    protected void grdCreditAccounts_ItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {

            case "ViewTransactionHistory":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["BlueCreditID"];
                popupTransactionHistory.VisibleOnPageLoad = true;
                break;

            case "EditCreditAccountHistory":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["BlueCreditID"];
                ClientSession.ObjectType = ObjectType.BlueCreditDetail;
                popupEditBlueCredit.VisibleOnPageLoad = true;
                break;
        }
    }

    protected void grdCreditAccounts_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;

            var flagActive = item.GetDataKeyValue("FlagActive").ParseBool();
            if (!flagActive)
            {
                if (ClientSession.RoleTypeID < (int)RoleType.Billing)
                {
                    var editImageButton = (item["EditCreditAccountHistory"].Controls[0] as ImageButton);
                    editImageButton.ImageUrl = "~/content/Images/icon_dash.png";
                    editImageButton.CssClass = "cursor-default";
                    editImageButton.Enabled = false;
                }
            }

        }
    }

    #endregion

    #region Notes on Account

    public string PFSID { get; set; }
    public string RespScoreBCRisk { get; set; }
    public string RespScoreBCRiskNumber { get; set; }
    public string RespScoreBCAmount { get; set; }
    public string BCRecAmountAdj { get; set; }
    public string BCRecAmountAdjRaw { get; set; }
    public string ResultTypeAbbr { get; set; }
    public string ServiceDate { get; set; }
    public string rptName { get; set; }
    public string respScoreBCResult { get; set; }
    public string respStatusAccuracyTxt { get; set; }
    public string BCLimitSum { get; set; }
    public string BCUsedPercentage { get; set; }
    protected bool FlagPFSExpired { get; set; }

    private void GetNotesOnPatientAccount()
    {
        var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.SelectedPatientID },
                                    { "@UserID", ClientSession.UserID}
                                };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_ptnotecredit_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            txtNote.Text = row["NoteCredit"].ToString();

            var flagPFSSuccess = row["FlagPFSSuccess"].ToString().Equals("1");
            ViewState["FlagPFSSuccess"] = flagPFSSuccess;

            if (!flagPFSSuccess)
            {
                divPatientCreditCheck2.Visible = true;
            }
            else
            {
                divPatientCreditCheck1.Visible = true;
                GetSelectedReportInformation();
            }
        }
    }

    private void GetSelectedReportInformation()
    {

        var flagPFSSuccess = ViewState["FlagPFSSuccess"].ParseBool();
        if (!flagPFSSuccess)
            return;

        DataTable information;

        if (ViewState["Tupfs"] != null)
        {
            information = ViewState["Tupfs"] as DataTable;
        }
        else
        {
            var cmdParams = new Dictionary<string, object>
                                {
                                    {"@PFSID",-1},
                                    {"@PatientID",ClientSession.SelectedPatientID },
                                    {"@PracticeID",ClientSession.PracticeID},
                                    {"@UserID", ClientSession.UserID},
                                    {"@FlagGuardian", FlagGuardianPay ? 1 : 0}
                                };

            information = SqlHelper.ExecuteDataTableProcedureParams("web_pr_tupfs_get", cmdParams);
            ViewState["Tupfs"] = information;
        }


        if (information.Rows.Count > 0)
        {
            PFSID = information.Rows[0]["PFSID"].ToString();
            RespScoreBCRisk = Common.GetRiskProfile(information.Rows[0]["RespScoreBCRisk"].ToString());
            RespScoreBCRiskNumber = information.Rows[0]["RespScoreBCRisk"].ToString();
            RespScoreBCAmount = information.Rows[0]["RespScoreBCAmount"].ToString();
            BCRecAmountAdj = information.Rows[0]["BCRecAmountAdj"].ToString();
            BCRecAmountAdjRaw = information.Rows[0]["BCRecAmountAdjRaw"].ToString();
            ResultTypeAbbr = information.Rows[0]["ResultTypeAbbr"].ToString();
            ServiceDate = information.Rows[0]["ServiceDate"].ToString();
            rptName = information.Rows[0]["rptName"].ToString();
            respScoreBCResult = information.Rows[0]["respScoreBCResult"].ToString();
            respStatusAccuracyTxt = information.Rows[0]["respStatusAccuracyTxt"].ToString();
            BCLimitSum = information.Rows[0]["BCLimitSum$"].ToString();
            FlagPFSExpired = information.Rows[0]["FlagPFSExpired"].ParseBool();

            var bcUsedSum = decimal.Parse(information.Rows[0]["BCUsedSum"].ToString());
            var bcLimitSum = decimal.Parse(information.Rows[0]["BCLimitSum"].ToString());

            BCUsedPercentage = bcLimitSum > 0 ? (bcUsedSum / bcLimitSum).ToString("#%") : "0.00%";

            ViewState["BCRecAmountAdjRaw"] = BCRecAmountAdjRaw;
            ViewState["BCUsedSum"] = bcUsedSum;


        }

    }


    protected void btnSavePatientNote_Click(object sender, EventArgs e)
    {
        var havePermission = BluecreditValidator.HasCreatePermission(windowManager);
        if (!havePermission)
            return;

        var cmdParams = new Dictionary<string, object>
                                {
                                    {"@PatientID", ClientSession.SelectedPatientID},
                                    {"UserID", ClientSession.UserID},
                                    {"@Note", txtNote.Text }
                                };
        SqlHelper.ExecuteScalarProcedureParams("web_pr_ptnotecredit_add", cmdParams);
        windowManager.RadAlert("Record successfully updated.", 350, 150, "", "refreshPage", "../Content/Images/success.png");
    }

    protected void btnShowCreditHistory_Click(object sender, EventArgs e)
    {
        int id;
        Int32.TryParse(PFSID, out id);

        if (id > 0)
        {
            ViewCreditHistory(id);
        }

    }

    #endregion

    #region Active Statements

    private DataTable GetActiveStatements()
    {
        var activeStatements = SqlHelper.ExecuteDataTableProcedureParams("[web_pr_statement_get]", new Dictionary<string, object>
        {
            { "@PatientId", ClientSession.SelectedPatientID },
            { "@flagcurrent", "1" },
            { "@flagbalance", "1" },
            { "@UserID", ClientSession.UserID}
        });

        var view = activeStatements.DefaultView;
        view.RowFilter = string.Format("FlagCurrent={0}", 1);
        activeStatements = view.ToTable();
        return activeStatements;
    }

    protected void grdActiveStatements_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdActiveStatements.DataSource = GetActiveStatements();
    }

    protected void grdActiveStatements_ItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "ViewActiveStatement":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                popupEstimateView.VisibleOnPageLoad = true;
                ClientSession.ObjectType = ObjectType.Statement; //ObjectType.BlueCredit;
                break;
        }
    }

    protected void btnAddStatement_OnClick(object sender, EventArgs e)
    {
        var hasPermission = BluecreditValidator.HasCreatePermission(windowManager);
        popupBCLoan.VisibleOnPageLoad = hasPermission;
    }

    protected void btnAssign_Click(object sender, EventArgs e)
    {

        var havePermission = BluecreditValidator.HasCreatePermission(windowManager);
        if (!havePermission)
            return;

        var hasConfirmed = ValidateBcScore();
        if (!hasConfirmed)
            return;

        AssignValues();
        popupActiveStatements.VisibleOnPageLoad = true;
    }

    private void AssignValues()
    {
        ClientSession.SelectedBlueCreditStatements = new List<int>();

        var statementIDandBalance = new List<string>();
        var highestSelectedBalance = 0m;
        decimal totalStatementBalance = 0;

        var objectValues = ClientSession.ObjectValue as Dictionary<string, object>;
        if (objectValues != null && objectValues.ContainsKey("FlagBCLoan"))
        {
            var statementID = objectValues["StatementID"].ToString();
            var balance = decimal.Parse(objectValues["Balance"].ToString());

            ClientSession.SelectedBlueCreditStatements.Add(int.Parse(statementID));
            statementIDandBalance.Add(statementID + "-" + balance);
            highestSelectedBalance = balance;
            totalStatementBalance = balance;

        }
        else
        {
            foreach (GridDataItem item in grdActiveStatements.Items)
            {
                var chkSelect = (CheckBox)item.FindControl("chkSelect");
                if (chkSelect.Checked)
                {
                    var balance = Convert.ToDecimal(item.GetDataKeyValue("Balance").ToString());
                    var statementID = Convert.ToInt32(item.GetDataKeyValue("StatementID").ToString());

                    ClientSession.SelectedBlueCreditStatements.Add(statementID); //saving selected statementID to session for further use.
                    statementIDandBalance.Add(statementID.ToString("") + "-" + balance);
                    totalStatementBalance += balance;

                    if (balance >= highestSelectedBalance)
                        highestSelectedBalance = balance;

                }
            }


        }

        ClientSession.SelectedStatementBalance = totalStatementBalance;
        ClientSession.HighestSelectedBalance = highestSelectedBalance;
        ClientSession.StatementIDandBalance = statementIDandBalance;

    }


    public bool ValidateBcScore()
    {

        var flagPFSSuccess = (bool)ViewState["FlagPFSSuccess"];
        if (!flagPFSSuccess)
            return true;

        var hdnIsConfirmed = hdnHasConfirmed.Value.ParseBool();
        if (hdnIsConfirmed)
            return true;

        var BCRecAmountAdj = ViewState["BCRecAmountAdjRaw"].ToString();
        var bCUsedSum = ViewState["BCUsedSum"].ToString();

        var parsedBCRecAmountAdj = decimal.Parse(BCRecAmountAdj);
        var parsedBcUsedSum = decimal.Parse(bCUsedSum);

        if (parsedBcUsedSum > parsedBCRecAmountAdj)
        {
            const string message = "Actual credit in use is already over the recommended amount. Are you sure you want to continue?";
            windowManager.RadConfirm(message, "isConfirmed", 450, 100, null, "", "../Content/Images/warning.png");
            return false;
        }

        return true;
    }

    protected void chk_OnChanged(object sender, EventArgs e)
    {
        var ischecked = false;
        foreach (GridDataItem item in grdActiveStatements.Items)
        {
            var chkSelect = (CheckBox)item.FindControl("chkSelect");

            if (chkSelect.Checked)
            {
                ischecked = true;
            }
        }
        btnAssign.ImageUrl = ischecked ? "../Content/Images/btn_assign.gif" : "../Content/Images/btn_assign_fade.gif";
        btnAssign.Enabled = ischecked;
    }
    #endregion

    #region Create PDF


    protected void btnDownloadPdf_OnClick(object sender, EventArgs e)
    {
        var source = GetSource();
        var fileStream = File.Open(source, FileMode.Open);
        var bytes = new byte[fileStream.Length];
        fileStream.Read(bytes, 0, Convert.ToInt32(fileStream.Length));
        fileStream.Close();
        Response.AddHeader("Content-disposition", "attachment; filename=LendingAgreements.pdf");
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytes);
        Response.End();
    }

    private string GetSource()
    {
        var path = string.Empty;
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_get", new Dictionary<string, object>
        {
            { "@BluecreditID", ClientSession.ObjectID },
            { "@PracticeID", ClientSession.PracticeID },
            { "@UserID", ClientSession.UserID}
        });
        foreach (DataRow row in reader.Rows)
        {
            path = row["FilePathBlueCredit"].ToString();
        }
        return path;
    }

    protected void btnCreatePDF_OnClick(object sender, EventArgs e)
    {
        Common.CreateandViewPDF();
        hdnIsShowPDFViewer.Value = "1";
    }

    #endregion

    protected void grdActiveStatements_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var chkCredit = item.FindControl("chkSelect") as CheckBox;
            var flagCreditPlan = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagCreditPlan"]);
            var flagCreditEligible = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagCreditEligible"]);
            chkCredit.Enabled = (!flagCreditPlan && flagCreditEligible);


            // For Yes No Images
            var imgPayPlan = item.FindControl("imgPayPlan") as Image;
            var imgCreditPlan = item.FindControl("imgCreditPlan") as Image;
            var imgCreditEligible = item.FindControl("imgCreditEligible") as Image;
            var payPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditPayAbbr"].ToString();
            var creditPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditPlanAbbr"].ToString();
            var creditEligible = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditEligibleAbbr"].ToString();
            imgPayPlan.ImageUrl = payPlan == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";
            imgCreditPlan.ImageUrl = creditPlan == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";
            imgCreditEligible.ImageUrl = creditEligible == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";

        }
    }

    //private bool ValidatePatientandGuardianIdentification()
    //{
    //    var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@flagguardian", cmbResponsibleParty.SelectedValue }, { "@flagprimary", 1 } };
    //    var information = SqlHelper.ExecuteDataTableProcedureParams("web_pr_identification_get", cmdParams);
    //    var responsibleParty = cmbResponsibleParty.SelectedItem.Text;
    //    if (information.Rows.Count == 0)
    //    {
    //        RadWindow.RadAlert("We can not create your BlueCredit Account at this time because of following: <br/> <p>" + responsibleParty + " do not have a valid Identification on file</p><p>" + responsibleParty +
    //                           " birthday should be 18 years old or greater" + responsibleParty +
    //                           " on must have a valid PFS report", 400, 100, "", "");
    //        return false;
    //    }
    //    else
    //    {
    //        var flagValid = Convert.ToBoolean(information.Rows[0]["FlagValid"]);
    //        var dateOfBirth = (DateTime)information.Rows[0]["DOB"];
    //        var flagPfs = Convert.ToBoolean(information.Rows[0]["FlagPFS"]);
    //        var age = DateTime.Now.Year - dateOfBirth.Year;
    //        var message = "We cannot create your BlueCredit Account at this time because of following:";

    //        if (!flagValid)
    //        {
    //            message += "<p>" + responsibleParty + " do not have a valid Identification on file</p>";
    //        }

    //        if (age < 18)
    //        {
    //            message += "<p>" + responsibleParty + " birthday should be 18 years old or greater</p>";
    //        }

    //        if (!flagPfs)
    //        {
    //            message += "<p>" + responsibleParty + " on must have a valid PFS report</p>";
    //        }

    //        if (!flagPfs || age < 18 || !flagValid)
    //            RadWindow.RadAlert(message, 400, 100, "", "");

    //        return flagValid && age >= 18 && flagPfs;
    //    }
    //}

    private void CreateUpdateBluecreditAccount()
    {
        ClientSession.IsRedirectToBluecredit = null;
        if (ClientSession.IsBlueCreditAddRequest == null) return;

        if (ClientSession.IsBlueCreditAddRequest == false)
        {
            popupEditBlueCredit.VisibleOnPageLoad = true;
        }
        else
        {
            popupActiveStatements.VisibleOnPageLoad = true;
        }

        ClientSession.IsBlueCreditAddRequest = null;

    }

    #region Common Functions

    private void ViewCreditHistory(int tupfsID)
    {
        ClientSession.ObjectID = tupfsID;
        ClientSession.ObjectID2 = ClientSession.SelectedPatientID;
        ClientSession.ObjectType = ObjectType.PFSReportDetail;
        popupCreditReport.VisibleOnPageLoad = true;
    }
    #endregion

}