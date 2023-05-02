using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var pageToBeRedirect = string.Empty;
        pageToBeRedirect = !string.IsNullOrEmpty(Extension.ClientSession.LastName) ? "~/patient/search.aspx" : "login.aspx";
        Response.Redirect(pageToBeRedirect, false);
        Context.ApplicationInstance.CompleteRequest();
    }
}
