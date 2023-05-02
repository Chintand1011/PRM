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


    protected override void OnInit(EventArgs e)
     {
        if (Request.Url.ToString().Contains("login.aspx")) return;
        if (string.IsNullOrEmpty(ClientSession.LastName))
        {
            ClientSession.Message = "<img src='content/images/icon_error.gif';>&nbsp; I'm sorry, your session has expired. Please log in to continue.";
            Response.Redirect("~/login.aspx");
        }

        // Appending code for each page
        // This approach will also allow to user to define separate page load event on each page
        Page.LoadComplete += Page_LoadComplete;
    }

    void Page_LoadComplete(object sender, EventArgs e)
    {
        if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
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