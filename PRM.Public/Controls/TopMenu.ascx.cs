using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

public partial class Controls_TopMenu : System.Web.UI.UserControl
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
        if (!Page.IsPostBack)
        {
            try
            {
                FillMenu();
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    private void FillMenu()
    {
        var menuItemWelcome = new RadMenuItem { Text = "Welcome", NavigateUrl = "~/welcome.aspx" };
        var menuItemMyInfo = new RadMenuItem { Text = "My Profile", NavigateUrl = "~/myinfo.aspx" };
        var menuItemMyStatements = new RadMenuItem { Text = "Statements", NavigateUrl = "~/statements.aspx" };
        var menuItemPayments = new RadMenuItem { Text = "Payments", NavigateUrl = "~/payments.aspx" };
        var menuItemPaymentPlans = new RadMenuItem { Text = "Payment Plans", NavigateUrl = "~/paymentplans.aspx" };
        var blueCredit = new RadMenuItem { Text = "BlueCredit", NavigateUrl = "~/blueCredit.aspx" };
        var menuItemBankInfo = new RadMenuItem { Text = "Bank Info", NavigateUrl = "~/bankinfo.aspx" };

        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(menuItemWelcome);
        radTopMenu.Items.Add(menuItemMyInfo);
        radTopMenu.Items.Add(menuItemMyStatements);
        radTopMenu.Items.Add(menuItemPayments);
        if (ClientSession.IsAllowPaymentPlans) radTopMenu.Items.Add(menuItemPaymentPlans);
        if (ClientSession.IsAllowBlueCredit) radTopMenu.Items.Add(blueCredit);
        radTopMenu.Items.Add(menuItemBankInfo);
        
    }
}