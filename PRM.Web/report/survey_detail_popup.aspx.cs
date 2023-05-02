using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OpenSource;
using System.Data;
using PatientPortal.DataLayer;

public partial class survey_detail_popup : System.Web.UI.Page
{
    #region Survey Properties
    public string DoctorName { get; set; }
    public string PatientName { get; set; }
    public string PatientDoB { get; set; }
    public string SurveyID { get; set; }
    public string SurveyDate { get; set; }
    public string PatientID { get; set; }

    public string SurveyScore { get; set; }
    public string SurveyScoreRating { get; set; }
    public string SurveyScoreDescription { get; set; }
    public string SurveyAction { get; set; }
    public string SurveyQuestionGroupID { get; set; }
    public string Question { get; set; }
    public int AnswerCount { get; set; } //Maximum number of selections in QuestionGroup
    public string Answer1 { get; set; }
    public string Answer2 { get; set; }
    public string Answer3 { get; set; }
    public string Answer4 { get; set; }
    public string Answer5 { get; set; }
    
    #endregion

    public EndPointSession ClientSession
    {
        get
        {
            if (HttpContext.Current.Session["ClientSession"] == null)
                HttpContext.Current.Session["ClientSession"] = new EndPointSession();
            return (EndPointSession)HttpContext.Current.Session["ClientSession"];
        }
        set
        {
            HttpContext.Current.Session["ClientSession"] = value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ClientSession.WasRequestFromPopup = true;

        if (!Page.IsPostBack)
        {
            SurveyID = Request.QueryString["SurveyID"];
            // Validating the IPAddress request
            var serviceIPAddress = string.Empty;
            var ipAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ?? HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];

            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", new Dictionary<string, object>());
            foreach (DataRow row in reader.Rows)
            {
                serviceIPAddress = row["ServiceIPAddress"].ToString();
            }
#if(!DEBUG)
            if (serviceIPAddress != ipAddress) return;
#endif
            var cmdParams = new Dictionary<string, object>
            {
                { "@SurveyID", SurveyID}
            };

            AssignSpValuesToProperties(cmdParams);
        }
    }

    private void AssignSpValuesToProperties(object cmdParams)
    {
        try
        {
            var allParams = cmdParams as Dictionary<string, object>;

            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_survey_get", allParams);

            foreach (DataRow row in reader.Rows)
            {
                #region Assigning SP values to properties

                if (ClientSession.PracticeID != 0)
                {
                    if (ClientSession.PracticeID != Convert.ToInt32(row["PracticeID"].ToString()))
                    {
                        radWindowDialog.RadAlert("An error occurred when trying to retrieve the statement; please contact support.", 350, 150, string.Empty, "closeRadWindow");
                        return;
                    }
                }

                //Patient Information
                DoctorName = row["DoctorName"].ToString();
                PatientName = row["PatientName"].ToString();
                PatientDoB = row["PatientDoB"].ToString();
                SurveyID = row["SurveyID"].ToString();
                SurveyDate = row["SurveyDate"].ToString();
                PatientID = row["PatientID"].ToString();

                //Assessment Information
                SurveyScore = row["SurveyScore"].ToString();
                SurveyScoreRating = row["SurveyScoreRating"].ToString();
                SurveyScoreDescription = row["SurveyScoreDescription"].ToString();
                SurveyAction = row["SurveyAction"].ToString();                
                #endregion
            }
        }
        catch (Exception)
        {
            throw;
        }
    }

    public void ShowSurveyDetails()
    {
        var statements = SqlHelper.ExecuteDataTableProcedureParams("web_pr_survey_detail_get", new Dictionary<string, object> { { "@SurveyID", SurveyID } });
        int CurrentSurveyQuestionGroup = 0;         
        string htmlStatementDetails = "";
               
        for (var i = 0; i < statements.Rows.Count; i++)
        {
            if (CurrentSurveyQuestionGroup != Convert.ToInt32(statements.Rows[i][0])) //if CurrentSurveyQuestionGroup is not the SurveyQuestionGroup of the row, we are starting a new one
            {
                CurrentSurveyQuestionGroup = Convert.ToInt32(statements.Rows[i][0]); // Make it the current one in the cycle and set all the appropriate variables.
                var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_surveyquestiongroup_get", new Dictionary<string, object> { { "@SurveyQuestionGroupID", CurrentSurveyQuestionGroup} });
                foreach (DataRow row in reader.Rows)
                {
                    Question = row["Question"].ToString();
                    AnswerCount = Convert.ToInt32(row["AnswerCount"]);
                    Answer1 = row["Answer1"].ToString();
                    Answer2 = row["Answer2"].ToString();
                    Answer3 = row["Answer3"].ToString();
                    Answer4 = row["Answer4"].ToString();
                    Answer5 = row["Answer5"].ToString();
                }

                htmlStatementDetails += @"<tr><td colspan=""2"">" + Question + "</td></tr>";
                htmlStatementDetails += @"<tr><td colspan=""2""><table id=""tbl-desc"" table-layout: fixed;>";
                htmlStatementDetails += @"<tr class=""tr-hdr"" style=""height: 0.1in; text-align: center; font-weight: bold; background-color: #d4e0f2;"">";
                htmlStatementDetails += @"<td class=""td-hdr"" width=""25"">ID</td>";
                htmlStatementDetails += @"<td class=""td-hdr"" width=""125"">Question</td>";
                htmlStatementDetails += @"<td class=""td-hdr"" width=""50"">" + Answer1 + "</td>";
                htmlStatementDetails += @"<td class=""td-hdr"" width=""50"">" + Answer2 + "</td>";
                if (AnswerCount >= 3) { htmlStatementDetails += @"<td class=""td-hdr"" width=""50"">" + Answer3 + "</td>";}
                if (AnswerCount >= 4) { htmlStatementDetails += @"<td class=""td-hdr"" width=""50"">" + Answer4 + "</td>"; }
                if (AnswerCount >= 5) { htmlStatementDetails += @"<td class=""td-hdr"" width=""50"">" + Answer5 + "</td>"; }
                htmlStatementDetails += "</tr>";
            }

            htmlStatementDetails += "<tr>";

            for (var j = 1; j < statements.Columns.Count; j++) //skip j=0, it's being used for SurveyQuestionGroup
            {
                htmlStatementDetails += "<td class='t" + j + "' word-wrap:break-word>";
                htmlStatementDetails += statements.Rows[i][j].ToString();
                htmlStatementDetails += "</td>";
            }
            htmlStatementDetails += "</tr>";
        }
        htmlStatementDetails += @"</table></td></tr>";
        Response.Write(htmlStatementDetails);
    }
}