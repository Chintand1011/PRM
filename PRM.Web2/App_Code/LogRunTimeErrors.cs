using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using PatientPortal.Utility;
using PatientPortal.DataLayer;

/// <summary>
/// Summary description for LogRunTimeErrors
/// </summary>
public static class LogRunTimeErrors
{
    public static void LogErrors(HttpException lastErrorWrapper)
    {

        Exception lastError = lastErrorWrapper;
        if (lastErrorWrapper != null && lastErrorWrapper.InnerException != null)
            lastError = lastErrorWrapper.InnerException;
        else
            return;

        var errorType = lastError.GetType().ToString();
        var errorMessage = lastError.Message;
        var errorStackTrace = lastError.StackTrace;
        var sqlData = SqlHelper.GetSqlData(lastError.Data);


        // Get Message type of HTML
        var clientSession = Extension.ClientSession;
        var htmlErrorMessage = lastErrorWrapper.GetHtmlErrorMessage();

        EmailServices.SendRunTimeErrorEmail(HttpContext.Current.Request.RawUrl, errorType, errorMessage, errorStackTrace, htmlErrorMessage, clientSession.UserName, clientSession.PatientLastName + ", " + clientSession.PatientFirstName, clientSession.DateOfBirth, clientSession.PracticeName, clientSession.UserID, clientSession.SelectedPatientID, clientSession.PracticeID, clientSession.IPAddress, sqlData);
    }
}