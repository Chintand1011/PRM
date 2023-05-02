using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Controls_Header : System.Web.UI.UserControl
{
    public EndPointSession ClientSession
    {
        get
        {
            if (HttpContext.Current.Session["ClientSession"] == null)
                HttpContext.Current.Session["ClientSession"] = new EndPointSession();
            return (EndPointSession)HttpContext.Current.Session["ClientSession"];
        }
        set
        {
            HttpContext.Current.Session["ClientSession"] = value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        FillImageProperties();
       
        pNoteProviderSite.InnerText = ClientSession.NoteProviderSite;
    }



    private void FillImageProperties()
    {
        /* imgLogo.ImageUrl = "~/Content/Images/Providers/" + basePage.ClientSession.DefaultDirectory + "/" + basePage.ClientSession.LogoName; */
        imgLogo.ImageUrl = "~/Content/Images/Providers/" + ClientSession.LogoName;
        imgLogo.Width = ClientSession.LogoWidth;
        imgLogo.Height = ClientSession.LogoHeight;
    }
}