using System.Collections.Generic;
using PatientPortal.DataLayer;

public static class AuditLog
{
    public static void CreateExportLog(string page)
    {
        SaveLog(page, 12);
    }

    public static void CreatePrintLog(string page)
    {
        SaveLog(page, 11);
    }
    
    private static void SaveLog(string page, int auditTypeId)
    {
        var cmdParams = new Dictionary<string, object>
        {
            {"@PracticeID", Extension.ClientSession.PracticeID},
            {"@ProcName", page},
            {"@AuditTypeID", auditTypeId},
            {"@UserId", Extension.ClientSession.UserID}
        };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_audituseraction_add", cmdParams);
    }

}