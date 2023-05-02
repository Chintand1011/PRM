using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class LogoutTimer : System.Web.UI.UserControl
{

    //private static int SessionDurationInSeconds = 1080;  // <-- change this for testing

    private string _logoutUrl = "../login.aspx";

    public string LogoutUrl
    {
        get { return _logoutUrl; }
        set { _logoutUrl = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        var timeoutStartScript = string.Format("sm_timer({0},\"{1}\");", Extension.ClientSession.SessionTimeout, LogoutUrl);
        Page.ClientScript.RegisterStartupScript(typeof(LogoutTimer), "TimeoutStartScript", timeoutStartScript, true);
    }

    public void btnLogout_Click(object sender, EventArgs e)
    {
        Extension.ClientSession.Message = "You have been successfully logged out.";
        Response.Redirect("~/login.aspx");
    }
}