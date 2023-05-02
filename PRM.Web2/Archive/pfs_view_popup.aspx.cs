using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
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
    public string InputSSN4 { get; set; }
    public string InputDOB { get; set; }
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
    public string RespPrintImage { get; set; }

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
        }
    }

    private void GetSelectedReportInformation()
    {
        var cmdParams = new Dictionary<string, object>
                                {
                                    {"@PFSID",ClientSession.ObjectID},
                                    {"@PatientID",ClientSession.ObjectID2},
                                    {"@PracticeID",ClientSession.PracticeID},
                                    {"@UserID", ClientSession.UserID}
                                    };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_tupfs_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
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
            InputSSN4 = row["InputSSN4"].ToString();
            InputDOB = row["InputDOB"].ToString();
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
            RespSSN4 = row["RespSSN4"].ToString();
            RespDOB = row["RespDOB"].ToString();
            
            var flagName = Convert.ToInt32(row["RespFlagName"]);
            var flagDob = Convert.ToInt32(row["respFlagDOB"]);
            var flagSsn = Convert.ToInt32(row["respFlagSSN"]);
            var flagAddr = Convert.ToInt32(row["respFlagAddr"]);

            if (flagName == (int)TUColorCodes.Default || flagName == (int)TUColorCodes.Unknown)
                Page.ClientScript.RegisterStartupScript(GetType(), "Close", "hideShowMoreButtons();", true);  

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
            string PrintImage = row["RespHTMLBody"].ToString();
            //if (PrintImage.Length > 0 && PrintImage.Contains("printImageText") && PrintImage.Contains("END OF TRANSUNION REPORT"))
            //{
            //    RespPrintImage = PrintImage.Substring(PrintImage.IndexOf("printImageText") + 16, PrintImage.IndexOf("END OF TRANSUNION REPORT") - PrintImage.IndexOf("printImageText") + 8);
            //}
        }
    }


    private static string ManageText(int code)
    {
        string imageUrl;
        string message;
        string color;

        switch (code)
        {
            case (int)TUColorCodes.Unknown:
                imageUrl = "../Content/Images/msg_icon_unknown.gif";
                message = TUColorCodes.Unknown.ToString();
                color = "black";
                break;

            case (int)TUColorCodes.Default:
                imageUrl = "../Content/Images/msg_icon_nodata.gif";
                message = "No Data";
                color = "black";
                break;

            case (int)TUColorCodes.Green:
                imageUrl = "../Content/Images/msg_icon_verified.gif";
                message = "Verified";
                color = "green";
                break;

            case (int)TUColorCodes.Yellow:
                imageUrl = "../Content/Images/msg_icon_caution.gif";
                message = "Unconfirmed";
                color = "gold";
                break;

            default:
                imageUrl = "../Content/Images/msg_icon_error.gif"; 
                message = "Not Matched";
                color = "red";
                break;

        }

        return string.Format("<span class='identificationResult'> <span class='messageStatusIcon'><span class='resultImage'><img src='{0}' alt='{1}'/></span></span></span><span class='statusMessage' style='color:{2};'>{1}</span>", imageUrl, message,color);

    }

}