using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class pfs_view_popup : BasePage
{

    #region Table Properties

    public int PFSID { get; set; }
    public string ResultTypeAbbr;
    public string ReasonTypeAbbr;
    public string ServiceDate;
    public string ServiceTime;
    public string SubmitDate;
    public string PatientName;
    public string ProviderName;
    public string BCCount { get; set; }
    public string SysUserName { get; set; }
    public string InputNameFirst { get; set; }
    public string InputNameMiddle { get; set; }
    public string InputNameLast { get; set; }
    public string InputAddrStreet { get; set; }
    public string InputAddrCityAbbr { get; set; }
    public string InputAddrState { get; set; }
    public string InputAddrZip { get; set; }
    public string InputSSNenc { get; set; }
    public string InputSSN4 { get; set; }
    public string InputDOB { get; set; }
    public string InputStatedIncome { get; set; }
    public string InputHousingType { get; set; }
    public string RespNameFirst { get; set; }
    public string RespNameMiddle { get; set; }
    public string RespNameLast { get; set; }
    public string RespAddrunParsed { get; set; }
    public string RespAddrCityAbbr { get; set; }
    public string RespAddrState { get; set; }
    public string RespAddrZip { get; set; }
    public string RespAddr2unParsed { get; set; }
    public string RespAddr2City { get; set; }
    public string RespAddr2State { get; set; }
    public string RespAddr2Zip { get; set; }
    public string RespPhone { get; set; }
    public string RespSSNenc { get; set; }
    public string RespSSN4 { get; set; }
    public string RespDOB { get; set; }
    public string RespFlagName { get; set; }
    public string RespFlagSSN { get; set; }
    public string RespFlagDoB { get; set; }
    public string RespFlagAddr { get; set; }
    public string RespCalcDTI { get; set; }
    public string RespCalcRI { get; set; }
    public string RespCalcFPL { get; set; }
    public string RespCalcAC { get; set; }
    public string RespRevAvail { get; set; }
    public string RespMortgageMoPay { get; set; }
    public string RespTotalsPastDue { get; set; }
    public string RespCollectionsDue { get; set; }
    public string RespScoreBCResult { get; set; }
    public string RespScoreBCAmount { get; set; }
    public string BCRecAmountAdj { get; set; }
    public string LoanTypeAbbr { get; set; }
    public string RateLabel { get; set; }
    public string RateAPRAbbr { get; set; }
    public string RespScoreBCRisk { get; set; }
    public string RespScoreBCPRiskNumber { get; set; }
    public string RespScoreNAResult { get; set; }
    public string RespScoreNAFactor1 { get; set; }
    public string RespScoreNAFactor2 { get; set; }
    public string RespScoreNAFactor3 { get; set; }
    public string RespScoreNAFactor4 { get; set; }
    public string RespScoreNAFactor5 { get; set; }
    public string RespScoreNAFactor1Abbr { get; set; }
    public string RespScoreNAFactor2Abbr { get; set; }
    public string RespScoreNAFactor3Abbr { get; set; }
    public string RespScoreNAFactor4Abbr { get; set; }
    public string RespScoreNAFactor5Abbr { get; set; }
    public string RespScoreNACard { get; set; }
    public string RespScoreNAFlagAlert { get; set; }
    public string RespScoreNAFlagImpact { get; set; }
    public string RespScoreRResult { get; set; }
    public string RespScoreRFactor1 { get; set; }
    public string RespScoreRFactor2 { get; set; }
    public string RespScoreRFactor3 { get; set; }
    public string RespScoreRFactor4 { get; set; }
    public string RespScoreRFactor5 { get; set; }
    public string RespScoreRFactor1Abbr { get; set; }
    public string RespScoreRFactor2Abbr { get; set; }
    public string RespScoreRFactor3Abbr { get; set; }
    public string RespScoreRFactor4Abbr { get; set; }
    public string RespScoreRFactor5Abbr { get; set; }
    public string RespScoreRCard { get; set; }
    public string RespScoreRFlagAlert { get; set; }
    public string RespScoreRFlagImpact { get; set; }
    public string RespStatusAccuracyID { get; set; }
    public string RespStatusFinAidID { get; set; }
    public string RespStatusCollectID { get; set; }
    public string RespStatusRiskID { get; set; }
    public string RespStatusRedFlagID { get; set; }
    public string RespStatusAccuracyTxt { get; set; }
    public string RespStatusFinAidTxt { get; set; }
    public string RespStatusCollectTxt { get; set; }
    public string RespStatusRiskTxt { get; set; }
    public string RespStatusRedFlagTxt { get; set; }
    public string RespWarning1 { get; set; }
    public string RespWarning2 { get; set; }
    public string RespWarning3 { get; set; }
    public string RespWarning4 { get; set; }
    public string RespWarning5 { get; set; }
    public string RespReptPullDate { get; set; }
    public string RespOpened1 { get; set; }
    public string RespPlaced1 { get; set; }
    public string RespCreditor1 { get; set; }
    public string RespBalance1 { get; set; }
    public string RespOpened2 { get; set; }
    public string RespPlaced2 { get; set; }
    public string RespCreditor2 { get; set; }
    public string RespBalance2 { get; set; }
    public string RespOpened3 { get; set; }
    public string RespPlaced3 { get; set; }
    public string RespCreditor3 { get; set; }
    public string RespBalance3 { get; set; }
    public string RespOpened4 { get; set; }
    public string RespPlaced4 { get; set; }
    public string RespCreditor4 { get; set; }
    public string RespBalance4 { get; set; }
    public string RespOpened5 { get; set; }
    public string RespPlaced5 { get; set; }
    public string RespCreditor5 { get; set; }
    public string RespBalance5 { get; set; }
    public string RespRevCreditLimit { get; set; }
    public string RespRevHighCredit { get; set; }
    public string RespRevBalance { get; set; }
    public string RespRevPastDue { get; set; }
    public string RespRevMonthlyPay { get; set; }
    public string RespRevAvailable { get; set; }
    public string RespInstCreditLimit { get; set; }
    public string RespInstHighCredit { get; set; }
    public string RespInstBalance { get; set; }
    public string RespInstPastDue { get; set; }
    public string RespInstMonthlyPay { get; set; }
    public string RespInstAvailable { get; set; }
    public string RespMortCreditLimit { get; set; }
    public string RespMortHighCredit { get; set; }
    public string RespMortBalance { get; set; }
    public string RespMortPastDue { get; set; }
    public string RespMortMonthlyPay { get; set; }
    public string RespMortAvailable { get; set; }
    public string RespOpenCreditLimit { get; set; }
    public string RespOpenHighCredit { get; set; }
    public string RespOpenBalance { get; set; }
    public string RespOpenPastDue { get; set; }
    public string RespOpenMonthlyPay { get; set; }
    public string RespOpenAvailable { get; set; }
    public Int32 PatientID { get; set; }

    protected bool FlagFullReport { get; set; }
    protected bool FlagPFSExpired { get; set; }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            ClientSession.WasRequestFromPopup = true;

            try
            {
                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.PFSReportDetail)
                {
                    GetSelectedReportInformation();
                }


            }
            catch (Exception)
            {
                throw;
            }

            popup_Rates.VisibleOnPageLoad = false;
        }

        if (Request.Form["__EVENTTARGET"] == "ShowFullReport")
        {
            GetSelectedReportInformation(true);
        }
    }

    private void GetSelectedReportInformation(bool fullReport = false)
    {
        var cmdParams = new Dictionary<string, object>
                                {
                                    {"@PFSID",ClientSession.ObjectID},
                                    {"@PatientID",ClientSession.ObjectID2},
                                    {"@PracticeID", ClientSession.PracticeID},
                                    {"@UserID", ClientSession.UserID}
                                    };

        if (fullReport)
        {
            cmdParams.Add("@FlagFullReport", "1");
        }

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_tupfs_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            PatientID = (int)row["PatientID"];
            ViewState["PatientID"] = PatientID;
            PFSID = (int)row["PFSID"];
            ResultTypeAbbr = row["ResultTypeAbbr"].ToString();
            ServiceDate = row["ServiceDate"].ToString();
            ServiceTime = row["ServiceTime"].ToString();
            SubmitDate = row["SubmitDate"].ToString();
            BCCount = row["BCCount"].ToString();
            SysUserName = row["SysUserName"].ToString();
            InputNameFirst = row["InputNameFirst"].ToString();
            InputNameMiddle = row["InputNameMiddle"].ToString();
            InputNameLast = row["InputNameLast"].ToString();
            InputAddrStreet = row["InputAddrStreet"].ToString();
            InputAddrCityAbbr = row["InputAddrCityAbbr"].ToString();
            InputAddrState = row["InputAddrState"].ToString();
            InputAddrZip = row["InputAddrZip"].ToString();
            InputSSNenc = row["InputSSNenc"].ToString().Decrypt().ToSSNFormat();
            InputSSN4 = row["InputSSN4"].ToString();
            InputDOB = row["InputDOB"].ToString();
            InputStatedIncome = row["StatedIncome$"].ToString();
            InputHousingType = row["HousingTypeAbbr"].ToString();
            RespNameFirst = row["RespNameFirst"].ToString();
            RespNameMiddle = row["RespNameMiddle"].ToString();
            RespNameLast = row["RespNameLast"].ToString();
            RespAddrunParsed = row["RespAddrunParsed"].ToString();
            RespAddrCityAbbr = row["RespAddrCityAbbr"].ToString();
            RespAddrState = row["RespAddrState"].ToString();
            RespAddrZip = row["RespAddrZip"].ToString();
            RespAddr2unParsed = row["RespAddr2unParsed"].ToString();
            RespAddr2City = row["RespAddr2City"].ToString();
            RespAddr2State = row["RespAddr2State"].ToString();
            RespAddr2Zip = row["RespAddr2Zip"].ToString();
            RespPhone = row["RespPhone"].ToString();
            RespSSNenc = row["RespSSNenc"].ToString().Decrypt().ToSSNFormat();
            RespSSN4 = row["RespSSN4"].ToString();
            RespDOB = row["RespDOB"].ToString();

            var flagName = Convert.ToInt32(row["RespFlagName"]);
            var flagDob = Convert.ToInt32(row["respFlagDOB"]);
            var flagSsn = Convert.ToInt32(row["respFlagSSN"]);
            var flagAddr = Convert.ToInt32(row["respFlagAddr"]);

            RespFlagName = ManageText(flagName);
            RespFlagDoB = ManageText(flagDob);
            RespFlagSSN = ManageText(flagSsn);
            RespFlagAddr = ManageText(flagAddr);


            //if (row["RespFlagName"].ToString() != "" && (int)row["RespFlagName"] == (int)TUColorCodes.Green) { RespFlagName = "<span class=\"Match\">Match</span>"; }
            ////else if (Convert.ToInt32(RespFlagName) == (Int32)Enums.TUColorCodes.Yellow) return "<span class=\"Match\">Match</span>";
            //else if (row["RespFlagName"].ToString() != "" && Convert.ToInt32(row["RespFlagName"].ToString()) == (int)TUColorCodes.Red) { RespFlagName = "<span class=\"Does Not Match\">Match</span>"; }
            //else RespFlagName = "<span class=\"Match\">Match</span>"; ;

            //if (row["RespFlagAddr"].ToString() != "" && Convert.ToInt32(row["RespFlagAddr"].ToString()) == (int)TUColorCodes.Green) { RespFlagAddr = "<span class=\"Match\">Match</span>"; }
            ////else if (Convert.ToInt32(RespFlagNameLast) == (Int32)Enums.TUColorCodes.Yellow) return "<span class=\"Match\">Match</span>";
            //else if (row["RespFlagAddr"].ToString() != "" && Convert.ToInt32(row["RespFlagAddr"].ToString()) == (int)TUColorCodes.Red) { RespFlagAddr = "<span class=\"Does Not Match\">Match</span>"; }
            //else RespFlagAddr = "<span class=\"Match\">Match</span>"; ;

            //if (row["RespFlagSSN"].ToString() != "" && Convert.ToInt32(row["RespFlagSSN"].ToString()) == (int)TUColorCodes.Green) { RespFlagSSN = "<span class=\"Match\">Match</span>"; }
            ////else if (Convert.ToInt32(RespFlagNameLast) == (Int32)Enums.TUColorCodes.Yellow) return "<span class=\"Match\">Match</span>";
            //else if (row["RespFlagSSN"].ToString() != "" && Convert.ToInt32(row["RespFlagSSN"].ToString()) == (int)TUColorCodes.Red) { RespFlagSSN = "<span class=\"Does Not Match\">Match</span>"; }
            //else RespFlagSSN = "<span class=\"Match\">Match</span>"; ;

            //if (row["RespFlagDoB"].ToString() != "" && Convert.ToInt32(row["RespFlagDoB"].ToString()) == (int)TUColorCodes.Green) { RespFlagDoB = "<span class=\"Match\">Match</span>"; }
            ////else if (Convert.ToInt32(RespFlagNameLast) == (Int32)Enums.TUColorCodes.Yellow) return "<span class=\"Match\">Match</span>";
            //else if (row["RespFlagDoB"].ToString() != "" && Convert.ToInt32(row["RespFlagDoB"].ToString()) == (int)TUColorCodes.Red) { RespFlagDoB = "<span class=\"Does Not Match\">Match</span>"; }
            //else RespFlagDoB = "<span class=\"Match\">Match</span>"; ;

            RespCalcDTI = row["RespCalcDTI"].ToString();
            RespCalcRI = row["RespCalcRI"].ToString();
            RespCalcFPL = row["RespCalcFPL"].ToString();
            RespCalcAC = row["RespCalcAC"].ToString();
            RespRevAvail = row["RespRevolvingAvailable"].ToString();
            RespMortgageMoPay = row["RespMortgageMonthlyPay"].ToString();
            RespTotalsPastDue = row["RespTotalsPastDue"].ToString();
            RespCollectionsDue = row["RespCollectionsDue"].ToString();
            RespScoreBCResult = row["RespScoreBCResult"].ToString();
            RespScoreBCAmount = row["RespScoreBCAmount"].ToString();
            BCRecAmountAdj = row["BCRecAmountAdj"].ToString();
            LoanTypeAbbr = row["LoanTypeAbbr"].ToString();

            var flagLenderFunded = row["FlagLenderFunded"].ParseBool();
            if (flagLenderFunded)
            {
                RateAPRAbbr = row["RateAPRAbbr"].ToString();
                RateLabel = "BASE APR:";
            }

            RespScoreBCRisk = Common.GetRiskProfile(row["RespScoreBCRisk"].ToString());
            RespScoreBCPRiskNumber = row["RespScoreBCRisk"].ToString();
            RespScoreNAResult = row["RespScoreNAResult"].ToString();
            RespScoreNAFactor1 = row["RespScoreNAFactor1"].ToString();
            RespScoreNAFactor2 = row["RespScoreNAFactor2"].ToString();
            RespScoreNAFactor3 = row["RespScoreNAFactor3"].ToString();
            RespScoreNAFactor4 = row["RespScoreNAFactor4"].ToString();
            RespScoreNAFactor5 = row["RespScoreNAFactor5"].ToString();
            RespScoreNAFactor1Abbr = row["RespScoreNAFactor1Abbr"].ToString();
            RespScoreNAFactor2Abbr = row["RespScoreNAFactor2Abbr"].ToString();
            RespScoreNAFactor3Abbr = row["RespScoreNAFactor3Abbr"].ToString();
            RespScoreNAFactor4Abbr = row["RespScoreNAFactor4Abbr"].ToString();
            RespScoreNAFactor5Abbr = row["RespScoreNAFactor5Abbr"].ToString();
            RespScoreNACard = row["RespScoreNACard"].ToString();
            RespScoreNAFlagAlert = row["RespScoreNAFlagAlert"].ToString();
            RespScoreNAFlagImpact = row["RespScoreNAFlagImpact"].ToString();
            RespScoreRResult = row["RespScoreRResult"].ToString();
            RespScoreRFactor1 = row["RespScoreRFactor1"].ToString();
            RespScoreRFactor2 = row["RespScoreRFactor2"].ToString();
            RespScoreRFactor3 = row["RespScoreRFactor3"].ToString();
            RespScoreRFactor4 = row["RespScoreRFactor4"].ToString();
            RespScoreRFactor5 = row["RespScoreRFactor5"].ToString();
            RespScoreRFactor1Abbr = row["RespScoreRFactor1Abbr"].ToString();
            RespScoreRFactor2Abbr = row["RespScoreRFactor2Abbr"].ToString();
            RespScoreRFactor3Abbr = row["RespScoreRFactor3Abbr"].ToString();
            RespScoreRFactor4Abbr = row["RespScoreRFactor4Abbr"].ToString();
            RespScoreRFactor5Abbr = row["RespScoreRFactor5Abbr"].ToString();
            RespScoreRCard = row["RespScoreRCard"].ToString();
            RespScoreRFlagAlert = row["RespScoreRFlagAlert"].ToString();
            RespScoreRFlagImpact = row["RespScoreRFlagImpact"].ToString();
            RespStatusAccuracyTxt = row["RespStatusAccuracyTxt"].ToString();
            RespStatusFinAidTxt = row["RespStatusFinAidTxt"].ToString();
            RespStatusCollectTxt = row["RespStatusCollectTxt"].ToString();
            RespStatusRiskTxt = row["RespStatusRiskTxt"].ToString();
            RespStatusRedFlagTxt = row["RespStatusRedFlagTxt"].ToString();
            RespWarning1 = row["RespWarning1"].ToString();
            RespWarning2 = row["RespWarning2"].ToString();
            RespWarning3 = row["RespWarning3"].ToString();
            RespWarning4 = row["RespWarning4"].ToString();
            RespWarning5 = row["RespWarning5"].ToString();
            RespReptPullDate = row["RespReptPullDate"].ToString();
            RespOpened1 = row["RespOpened1"].ToString();
            RespPlaced1 = row["RespPlaced1"].ToString();
            RespCreditor1 = row["RespCreditor1"].ToString();
            RespBalance1 = row["RespBalance1"].ToString();
            RespOpened2 = row["RespOpened2"].ToString();
            RespPlaced2 = row["RespPlaced2"].ToString();
            RespCreditor2 = row["RespCreditor2"].ToString();
            RespBalance2 = row["RespBalance2"].ToString();
            RespOpened3 = row["RespOpened3"].ToString();
            RespPlaced3 = row["RespPlaced3"].ToString();
            RespCreditor3 = row["RespCreditor3"].ToString();
            RespBalance3 = row["RespBalance3"].ToString();
            RespOpened4 = row["RespOpened4"].ToString();
            RespPlaced4 = row["RespPlaced4"].ToString();
            RespCreditor4 = row["RespCreditor4"].ToString();
            RespBalance4 = row["RespBalance4"].ToString();
            RespOpened5 = row["RespOpened5"].ToString();
            RespPlaced5 = row["RespPlaced5"].ToString();
            RespCreditor5 = row["RespCreditor5"].ToString();
            RespBalance5 = row["RespBalance5"].ToString();
            RespRevCreditLimit = row["RespRevCreditLimitAbbr"].ToString();
            RespRevHighCredit = row["RespRevHighCreditAbbr"].ToString();
            RespRevBalance = row["RespRevBalanceAbbr"].ToString();
            RespRevPastDue = row["RespRevPastDueAbbr"].ToString();
            RespRevMonthlyPay = row["RespRevMonthlyPayAbbr"].ToString();
            RespRevAvailable = row["RespRevAvailableAbbr"].ToString();
            RespMortCreditLimit = row["RespMortCreditLimitAbbr"].ToString();
            RespMortHighCredit = row["RespMortHighCreditAbbr"].ToString();
            RespMortBalance = row["RespMortBalanceAbbr"].ToString();
            RespMortPastDue = row["RespMortPastDueAbbr"].ToString();
            RespMortMonthlyPay = row["RespMortMonthlyPayAbbr"].ToString();
            RespMortAvailable = row["RespMortAvailableAbbr"].ToString();
            RespInstCreditLimit = row["RespInstCreditLimitAbbr"].ToString();
            RespInstHighCredit = row["RespInstHighCreditAbbr"].ToString();
            RespInstBalance = row["RespInstBalanceAbbr"].ToString();
            RespInstPastDue = row["RespInstPastDueAbbr"].ToString();
            RespInstMonthlyPay = row["RespInstMonthlyPayAbbr"].ToString();
            RespInstAvailable = row["RespInstAvailableAbbr"].ToString();
            RespOpenCreditLimit = row["RespOpenCreditLimitAbbr"].ToString();
            RespOpenHighCredit = row["RespOpenHighCreditAbbr"].ToString();
            RespOpenBalance = row["RespOpenBalanceAbbr"].ToString();
            RespOpenPastDue = row["RespOpenPastDueAbbr"].ToString();
            RespOpenMonthlyPay = row["RespOpenMonthlyPayAbbr"].ToString();
            RespOpenAvailable = row["RespOpenAvailableAbbr"].ToString();
            FlagFullReport = row["FlagFullReport"].ParseBool();
            FlagPFSExpired = row["FlagPFSExpired"].ParseBool();
            //// Leaving commenting for Jose
            //string PrintImage = row["RespPrintImage"].ToString();
            //string cachereturn = "<br>";
            //int lineindex = 0;
            //int TUcharspan = 94;
            //while (lineindex < PrintImage.Length)
            //{
            //    if (lineindex + TUcharspan > PrintImage.Length) { TUcharspan = PrintImage.Length - lineindex; }
            //    if (PrintImage.Substring(lineindex, TUcharspan).Contains("----------------------------------------------------------------------------"))
            //    {
            //        PrintImage = PrintImage.Insert(PrintImage.Substring(lineindex, TUcharspan).IndexOf("----------------------------------------------------------------------------") + lineindex, cachereturn);
            //        lineindex += TUcharspan + cachereturn.Length;
            //    }
            //    else
            //    {
            //        PrintImage = PrintImage.Insert(lineindex + TUcharspan, cachereturn);
            //        lineindex += TUcharspan + cachereturn.Length;
            //    }
            //}
            //RespPrintImage = PrintImage;

            //if (PrintImage.Length > 0 && PrintImage.Contains("printImageText") && PrintImage.Contains("END OF TRANSUNION REPORT"))
            //{
            //    ClientSession.ObjectValue = PrintImage.Substring(PrintImage.IndexOf("printImageText") + 16, PrintImage.IndexOf("END OF TRANSUNION REPORT") - PrintImage.IndexOf("printImageText") + 8);
            //}

            ClientSession.ObjectValue = GetReport(row["RespHTMLBody"].ToString());
        }
    }

    private static string GetReport(string report)
    {
        if (report.Length < 100)
            return "No file found.";

        var startingIndex = report.IndexOf("printImageText");
        int endIndex;

        if (startingIndex > 0)
        {
            startingIndex += 16;
            endIndex = 8;
        }
        else
        {
            startingIndex = 0;
            endIndex = 23;
        }

        report = report.Substring(startingIndex, report.IndexOf("END OF TRANSUNION REPORT") - report.IndexOf("printImageText") + endIndex);
        
        var startIndex = report.IndexOf("<br>");
        return report.Substring(startIndex);
    }

    private static string ManageText(int code)
    {
        string imageUrl;
        string message;
        string color;

        switch (code)
        {
            case (int)TUColorCodes.Unknown:
                imageUrl = "../Content/Images/msg_icon_unknown.png";
                //message = TUColorCodes.Unknown.ToString();
                message = " Unknown";
                color = "darkblue";
                break;

            case (int)TUColorCodes.Default:
                imageUrl = "../Content/Images/msg_icon_nodata.gif";
                message = " No Data";
                color = "darkblue";
                break;

            case (int)TUColorCodes.Green:
                imageUrl = "../Content/Images/msg_icon_verified.gif";
                message = " Verified";
                color = "green";
                break;

            case (int)TUColorCodes.Yellow:
                imageUrl = "../Content/Images/msg_icon_caution.gif";
                message = " Unconfirmed";
                color = "#CC9900";
                break;

            default:
                imageUrl = "../Content/Images/msg_icon_error.gif";
                message = " Not Matched";
                color = "darkred";
                break;

        }

        return string.Format("<span class='identificationResult'> <span class='messageStatusIcon'><span class='resultImage'><img src='{0}' alt='{1}'/></span></span></span><span class='statusMessage' style='color:{2};'>{1}</span>", imageUrl, message, color);

    }

    #region Get All Rates

    protected void btnGetRates_OnClick(object sender, EventArgs e)
    {

        GetSelectedReportInformation();

        var cmdParams = new Dictionary<string, object>
        {
            {"@PracticeID", ClientSession.PracticeID},
            {"@PatientID", int.Parse(ViewState["PatientID"].ToString())},
            {"@FlagSuspendBalanceCheck", 1}
        };

        var rates = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecreditlender_list", cmdParams);
        divRates.InnerHtml = GetRatesTable(rates);

        // Display statment if no row available
        if (rates.Rows.Count == 0)
        {
            divMessage.InnerText = "While this patient meets the minimum standards for credit, there are no lenders currently participating which could initiate a loan. In this case, only practiced funded bluecredit may be applied.";
            divMessage.Attributes.CssStyle.Add(HtmlTextWriterStyle.MarginTop, "100px");
        }

        popup_Rates.VisibleOnPageLoad = true;
    }

    protected void btnGoToBluecredit_OnClick(object sender, EventArgs e)
    {
        var patientID = int.Parse(ViewState["PatientID"].ToString());
        if (patientID != ClientSession.SelectedPatientID)
        {
            ClientSession.SelectedPatientID = patientID;
            (new UserLogin()).LoadPatientIntoSession();
        }

        ScriptManager.RegisterStartupScript(Page, typeof(Page), "goToBluecreditPage", "goToBluecreditPage();", true);
    }

    private static string GetRatesTable(DataTable rates)
    {
        var rateTable = "<table width='100%'><tr><td>&nbsp; &nbsp;</td>";
        rateTable += "<th align='left'>ID &nbsp; &nbsp; &nbsp;</th>";
        rateTable += "<th align='left'>Plan Type</th>";
        rateTable += "<th align='left'>Available Funding</th>";
        rateTable += "<th align='left'>Payment*</th>";
        rateTable += "<th align='left'>Fee &nbsp; &nbsp;</th>";
        rateTable += "<th align='left'>Settlement</th></tr>";

        foreach (var row in rates.AsEnumerable())
        {

            var rate = decimal.Parse(row["RateStd"].ToString());
            var term = decimal.Parse(row["TermStd"].ToString());
            var financedAmount = decimal.Parse(row["QualMinBal"].ToString());
            var paymentValue = MathFunctions.CalcPMT(rate, term, financedAmount);

            rateTable += "<tr><td>&nbsp;</td>";
            rateTable += "<td>" + row["CreditTypeID"] + "</td>";
            rateTable += "<td>" + row["PlanDescAbbr"] + "</td>";
            rateTable += "<td>" + row["QualMinMaxAbbr"] + "</td>";
            rateTable += "<td>$" + paymentValue + "/mo</td>";
            rateTable += "<td>" + row["OriginationFeeAbbr"] + "</td>";
            rateTable += "<td>" + row["AvgDaysToFund"] + "</td>";
            rateTable += "</tr>";
        }

        rateTable += "</table>";

        return rateTable;
    }

    #endregion


}