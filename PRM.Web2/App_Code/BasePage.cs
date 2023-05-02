using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using Telerik.Web.UI;

/// <summary>
/// Summary description for EndPointSession
/// </summary>
public class BasePage : System.Web.UI.Page
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

    public DateTime EndDate
    {
        get
        {
            return DateTime.Now.AddDays(-31);
        }
    }


    protected override void OnInit(EventArgs e)
    {
        if (Request.Url.ToString().Contains("login")) return;
        if (string.IsNullOrEmpty(ClientSession.LastName))
        {
            Response.Redirect("~/login.aspx");
        }

        var pagePath = HttpContext.Current.Request.Url.AbsolutePath;
        var oFileInfo = new System.IO.FileInfo(pagePath);
        var pageName = oFileInfo.Name.Split('.').ToList();
        if (pageName[0].ToLower().Contains("popup")) return;


        var splitPath = pagePath.Split('/').ToList();
        var indexCount = splitPath.Count;
        var absolutePath = (splitPath[indexCount - 2] + "/" + splitPath[indexCount - 1].Replace(".aspx", "")).Trim();

        //var isAuthorized = ClientSession.UserMenus.Any(res => res.PageName.ToLower().Contains(pageName[0].ToLower()));
        var isAuthorized = ClientSession.UserMenus.Any(res => res.IsAllow && res.FullPath.Contains(absolutePath.ToLower()));
        if (!isAuthorized)
        {
            Response.Redirect("~/error.aspx");
        }

        // Appending code for each page
        // This approach will also allow to user to define separate page load event on each page
        Page.LoadComplete += Page_LoadComplete;
    }


    void Page_LoadComplete(object sender, EventArgs e)
    {
        if (Request.IsAjaxRequest())
            return;

        if (Master == null) return;

        var radDatePickers = new List<RadDatePicker>();
        FindRadDatePickerControls(radDatePickers, Master.FindControl("MainContent")); // This is the ID of content place holder 

        foreach (var datePicker in radDatePickers)
        {
            datePicker.Calendar.FastNavigationStep = 12;
        }

    }

    private void FindRadDatePickerControls(ICollection<RadDatePicker> radDatePickers, Control control)
    {
        foreach (var innerControl in control.Controls)
        {
            if (innerControl is RadDatePicker)
            {
                radDatePickers.Add((RadDatePicker)innerControl);
            }
            else if (((Control)innerControl).Controls.Count > 0)
            {
                FindRadDatePickerControls(radDatePickers, (Control)innerControl);
            }
        }
    }

}