using System;
using System.Collections.Generic;
using PatientPortal.DataLayer;


public partial class dashboard : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack) return;

        ValidateReloadSessionValues();

    }

    private void ValidateReloadSessionValues()
    {
        if (!ClientSession.IsSurveyCompleted)
            return;

        var cmdParams = new Dictionary<string, object>
        {
            {"@SurveyID", ClientSession.UserData["SurveyID"]},
             {"@IPAddress", GetIpAddress},
        };

        ClientSession.UserData = SqlHelper.ExecuteDataTableProcedureParams("web_pr_survey_login", cmdParams).Rows[0];
    }
}