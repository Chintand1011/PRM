using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using PatientPortal.DataLayer;
using PatientPortal.Utility;

/// <summary>
/// Summary description for Extension
/// </summary>
public static class Common
{
    public static EndPointSession ClientSession
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

    public static void ClearObject()
    {
        ClientSession.ObjectID = null;
        ClientSession.Object = null;
    }

    #region Process Payments

    public static bool Success { get; set; }

    public static Int32 FSPTypeID { get; set; }

    public static Int32 FSPStatusID { get; set; }

    public static string FSPMessage { get; set; }

    public static string FSPPNRef { get; set; }

    public static string FSPAuthRef { get; set; }

    public static int ReturnTransID { get; set; }
    #endregion

    public static void CreateandViewPDF()
    {
        string fileName, webPath, id, filePath, password, requestFrom;

        var values = ClientSession.ObjectValue as Dictionary<string, string>;
        values.TryGetValue("FileName", out fileName);
        values.TryGetValue("WebPath", out webPath);
        values.TryGetValue("ID", out id);
        values.TryGetValue("FilePath", out filePath);
        values.TryGetValue("Password", out password);
        values.TryGetValue("RequestFrom", out requestFrom);

        ClientSession.FilePath = Path.Combine(filePath, fileName);
        if (!string.IsNullOrEmpty(PDFServices.ValidateFileLocation(ClientSession.FilePath)))
        {
            PDFServices.PDFCreate(fileName, webPath + id, filePath, password);
        }
        ClientSession.ObjectValue = new Dictionary<string, string> { { "FIleName", string.Empty }, { "PageTitle", requestFrom }, { "IsRequestFromBlueCredit", "False" } };
    }
  

    public static string GetRiskProfile(string riskScore)
    {
        riskScore = riskScore ?? "0";

        var value = float.Parse(riskScore);
        var riskProfile = string.Empty;

        if (value < 0)
        {
            riskProfile = "<span style='color: black;'>Unknown</span>";
        }
        else if (value > 0 && value < 2)
        {
            riskProfile = "<span style='color: green;'>Very Low</span>";
        }
        else if (value >= 2 && value < 3)
        {
            riskProfile = "<span style='color: green;'>Low</span>";
        }
        else if (value >= 3 && value < 4)
        {
            riskProfile = "<span style='color: darkyellow;'>Moderate</span>";
        }
        else if (value >= 4 && value < 5)
        {
            riskProfile = "<span style='color: orange;'>High</span>";
        }
        else if (value >= 5 && value < 6)
        {
            riskProfile = "<span style='color: red;'>Very High</span>";
        }
        else if (value >= 6 && value < 7)
        {
            riskProfile = "<span style='color: darkred;'>Severe</span>";
        }
        else 
        {
            riskProfile = "<span style='color: darkred;'>Not Recommended</span>";
        }

        return riskProfile;
    }

}