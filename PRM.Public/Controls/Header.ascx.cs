using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controls_Header : System.Web.UI.UserControl
{
    

    protected void Page_Load(object sender, EventArgs e)
    {
        FillImageProperties();
    }

    private void FillImageProperties()
    {
        imgLogo.ImageUrl = "~/Content/Images/Providers/" + Extension.ClientSession.LogoName;
        imgLogo.Width = Extension.ClientSession.LogoWidth;
        imgLogo.Height = Extension.ClientSession.LogoHeight;
    }
}