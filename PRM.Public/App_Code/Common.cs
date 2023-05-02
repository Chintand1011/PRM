using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

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

    public static Int32 ReturnTransID { get; set; } 
    #endregion
}