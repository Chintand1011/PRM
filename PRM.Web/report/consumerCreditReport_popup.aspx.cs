using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OpenSource;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class consumerCreditReport_popup : System.Web.UI.Page
{
    public string RespPrintImage { get; set; }

    //public EndPointSession ClientSession
    //{
    //    get
    //    {
    //        return HttpContext.Current.Session["ClientSession"] as EndPointSession;
    //    }
    //}

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                AuditLog.CreatePrintLog(Request.UrlReferrer.AbsoluteUri);
                RespPrintImage = Extension.ClientSession.ObjectValue.ToString();
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
    

}