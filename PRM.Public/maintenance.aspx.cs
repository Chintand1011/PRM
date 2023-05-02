using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mime;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;

public partial class maintenance : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // h5MaintenanceMessage.InnerText = Extension.ClientSession.MaintPtWebNote ?? "The portal site is currently undergoing maintenance and will be available shortly. Please try again soon or call CareBlue support at (866) 220-2500. Thank you for your patience.";
            // add the following to the aspx page within the <h5> tag: id="h5MaintenanceMessage" runat="server" 
        }
    }

}
