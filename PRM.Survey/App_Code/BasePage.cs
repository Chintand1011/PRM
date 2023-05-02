using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;


/// <summary>
/// Summary description for EndPointSession
/// </summary>
public class BasePage : System.Web.UI.Page
{
    #region Global Properties

    protected string GetIpAddress
    {
        get
        {
            return HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ?? HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
        }
    }

    protected EndPointSession ClientSession
    {
        get
        {
            return (EndPointSession)Session["ClientSession"];
        }

        set
        {
            Session["ClientSession"] = value;
        }
    }

    #endregion
    
    #region Client Session

    protected void InitializeSession()
    {
        Session["ClientSession"] = new EndPointSession();
    }

    protected void ClearSession()
    {
        Session.Remove("ClientSession");
    }

    protected bool IsSessionNull()
    {
        return Session["ClientSession"] == null;
    }
    
    #endregion

    protected override void OnInit(EventArgs e)
    {
        
        var pageName = System.IO.Path.GetFileNameWithoutExtension(Request.Url.AbsolutePath);
        if (pageName != "login" && IsSessionNull())
        {
            Response.Redirect("~/login.aspx");
        }
    }


    protected void ShowNotificationMessage(NotificationType type, string message)
    {
        var function = string.Format("showNotification('{0}', '{1}');", type.GetDescription(), message);
        ScriptManager.RegisterStartupScript(Page, typeof(Page), "showNotification", function, true);
    }
}