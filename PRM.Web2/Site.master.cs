using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;

public partial class SiteMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Request.IsLocal && !Request.IsSecureConnection)
        {
            string redirectUrl = Request.Url.ToString().Replace("http:", "https:");
            Response.Redirect(redirectUrl);
        }

    }
}
