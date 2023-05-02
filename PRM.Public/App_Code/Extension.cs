using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Extension
/// </summary>
public static class Extension
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
}