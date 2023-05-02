using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class info_popup : BasePage
{
    public String Message { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        ClientSession.WasRequestFromPopup = true;
        if (!Page.IsPostBack)
        {
            try
            {
                Message = ClientSession.PopupMessage;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }

    
}
