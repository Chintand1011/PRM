using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal;

public partial class LogoutTimer : System.Web.UI.UserControl
{
    private string _logoutUrl = "./login.aspx";

    public string LogoutUrl
    {
        get { return _logoutUrl; }
        set { _logoutUrl = value; }
    }

    protected void Page_Load(object sender, System.EventArgs e)
    {
        // calling the Javascript function "sm_timer()"
        var timeoutStartScript = string.Format("sm_timer({0},\"{1}\");", Extension.ClientSession.SessionTimeout, LogoutUrl);
        Page.ClientScript.RegisterStartupScript(typeof(LogoutTimer), "TimeoutStartScript", timeoutStartScript, true);
    }

    public void btnLogout_Click(object sender, EventArgs e)
    {
        // If logout confirmed then logout the user.
        Extension.ClientSession.Message = "You have been successfully logged out";
        Response.Redirect("~/login.aspx");
    }

}