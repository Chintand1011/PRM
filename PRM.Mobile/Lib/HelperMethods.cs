using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace PatientPortal.Mobile
{
    public static class HelperMethods
    {
        public static EndPointSession ClientSession(this HtmlHelper html)
        {
            if (html.ViewContext.HttpContext.Session["ClientSession"] == null)
                html.ViewContext.HttpContext.Session["ClientSession"] = new EndPointSession();
            return (EndPointSession)html.ViewContext.HttpContext.Session["ClientSession"];
        }

    }
}