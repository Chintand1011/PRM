using System;
using System.Data;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using PatientPortal.DataLayer;

namespace PatientPortal.Utility
{
    public static class LogErrors
    {
        public static int SaveErrors(string url, string errorType, string errorMessage, string stackTrace, string htmlErrorMessage, string SQLQuery, Int32 userID, Int32 practiceID, Int32 patientID, string ipAddress)
        {
            var cmdParams = new Dictionary<string, object>
                                {
                                {"@URL", url},
                                {"@Exception", errorType},
                                {"@Message", errorMessage},
                                {"@Stack", stackTrace},
                                {"@HTMLErrorMessage", htmlErrorMessage},
                                {"@SQLQuery", SQLQuery},
                                {"@UserID", userID},
                                {"@PracticeID", practiceID},
                                {"@PatientID", patientID},
                                {"@IPaddress", ipAddress},
                            };

            try
            {
                var reader = SqlHelper.ExecuteDataTableProcedureParams("sys_errorlog_add", cmdParams);
                int ErrorLogID = 0;
                foreach (DataRow row in reader.Rows)
                {
                    ErrorLogID = (int)row["ErrorLogID"];
                }

                return ErrorLogID;
            }
            catch (Exception)
            {
                var streamWriter = new StreamWriter("D:\\CBErrorLog.txt", true);
                streamWriter.WriteLine("<------------------------------------------" + DateTime.Now + "------------------------------------------------>" + htmlErrorMessage);
                streamWriter.Flush();
                streamWriter.Close();
                return -1;
            }
        }
    }
}
