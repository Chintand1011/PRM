using System;
using System.Data;
using System.Collections.Generic;
using System.Globalization;
using System.Net.Configuration;
using PatientPortal.DataLayer;

public partial class Controls_Bluecredit_BCCreditScore : System.Web.UI.UserControl
{

    public string PFSID { get; set; }
    public string RespScoreBCRisk { get; set; }
    public string RespScoreBCRiskNumber { get; set; }
    public string RespScoreBCAmount { get; set; }
    public string BCRecAmountAdj { get; set; }
    public string ResultTypeAbbr { get; set; }
    public string ServiceDate { get; set; }
    public string rptName { get; set; }
    public string respScoreBCResult { get; set; }
    public string respStatusAccuracyTxt { get; set; }
    public string BCLimitSum { get; set; }
    public string BCUsedPercentage { get; set; }
    public bool FlagPFSExpired { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            LoadInformation();    
        }
    }


    private void LoadInformation()
    {
        var cmdParams = new Dictionary<string, object>
                                {
                                    {"@PFSID",-1},
                                    {"@PatientID", Extension.ClientSession.SelectedPatientID },
                                    {"@PracticeID",Extension.ClientSession.PracticeID},
                                    {"@UserID", Extension.ClientSession.UserID}
                                    };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_tupfs_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            PFSID = row["PFSID"].ToString();
            RespScoreBCRisk = Common.GetRiskProfile(row["RespScoreBCRisk"].ToString());
            RespScoreBCRiskNumber = row["RespScoreBCRisk"].ToString();
            RespScoreBCAmount = row["RespScoreBCAmount"].ToString();
            BCRecAmountAdj = row["BCRecAmountAdj"].ToString();
            ResultTypeAbbr = row["ResultTypeAbbr"].ToString();
            ServiceDate = row["ServiceDate"].ToString();
            rptName = row["rptName"].ToString();
            respScoreBCResult = row["respScoreBCResult"].ToString();
            respStatusAccuracyTxt = row["respStatusAccuracyTxt"].ToString();
            BCLimitSum = row["BCLimitSum$"].ToString();
            FlagPFSExpired = row["FlagPFSExpired"].ParseBool();

            var bcUsedSum = decimal.Parse(row["BCUsedSum"].ToString());
            var bcLimitSum = decimal.Parse(row["BCLimitSum"].ToString());

            BCUsedPercentage = bcLimitSum > 0 ? (bcUsedSum / bcLimitSum).ToString("#%") : "0.00%";
        }
    }

    protected void btnShowCreditHistory_Click(object sender, EventArgs e)
    {
        int id;
        Int32.TryParse(PFSID, out id);

        if (id > 0)
        {
            
        }
    }

}