using System;
using System.Collections.Generic;
using System.IO;
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
            return Extension.ClientSession;
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
        var activeMenus = ClientSession.UserMenus.Where(res => res.HideShow).ToList();

        //Adding Menu Item
        var subscriberMenuItems = activeMenus.Where(res => res.MenuName.Contains("Patient"));
        var menuItemSubscriber = new RadMenuItem { Text = "Patients", NavigateUrl = "~/patient/search.aspx" };
        if (ClientSession.SelectedPatientID > 0)
        {
            foreach (var subscriberMenuItem in subscriberMenuItems)
            {
                menuItemSubscriber.Items.Add(new RadMenuItem { Text = subscriberMenuItem.PageName, NavigateUrl = subscriberMenuItem.NavigateURL });
            }
        }
        else
        {
            menuItemSubscriber.Items.Add(new RadMenuItem { Text = "Search", NavigateUrl = "~/patient/search.aspx" });
            menuItemSubscriber.Items.Add(new RadMenuItem { Text = "Add Patient", NavigateUrl = "~/patient/manage.aspx" });
        }

        //Adding Menu Item
        var menuItemAccounts = new RadMenuItem { Text = "Accounts" };
        var accountsMenuItems = activeMenus.Where(res => res.MenuName.Contains("Account"));
        foreach (var accountMenuItem in accountsMenuItems)
        {
            menuItemAccounts.Items.Add(new RadMenuItem { Text = accountMenuItem.PageName, NavigateUrl = accountMenuItem.NavigateURL });
        }


        //Adding Menu Item
        var menuItemStatement = new RadMenuItem { Text = "Statement" };
        var statementMenuItems = activeMenus.Where(res => res.MenuName.Contains("Statement"));
        foreach (var statementMenuItem in statementMenuItems)
        {
            menuItemStatement.Items.Add(new RadMenuItem { Text = statementMenuItem.PageName, NavigateUrl = statementMenuItem.NavigateURL });
        }

        //Adding Menu Item
        var menuItemEligibility = new RadMenuItem { Text = "Eligibility" };
        var eligibilityMenuItems = activeMenus.Where(res => res.MenuName.Contains("Eligibility"));
        foreach (var eligibilityMenuItem in eligibilityMenuItems)
        {
            menuItemEligibility.Items.Add(new RadMenuItem { Text = eligibilityMenuItem.PageName, NavigateUrl = eligibilityMenuItem.NavigateURL });
        }

        //Adding Menu Item
        var menuItemCredit = new RadMenuItem { Text = "BlueCredit" };
        var creditMenuItems = activeMenus.Where(res => res.MenuName.Contains("Credit"));
        foreach (var creditMenuItem in creditMenuItems)
        {
            menuItemCredit.Items.Add(new RadMenuItem { Text = creditMenuItem.PageName, NavigateUrl = creditMenuItem.NavigateURL });
        }

        //Adding Menu Item
        var menuItemPayplan = new RadMenuItem { Text = "Payment Plans" };
        var payplanMenuItems = activeMenus.Where(res => res.MenuName.Contains("Payplan"));
        foreach (var payplanMenuItem in payplanMenuItems)
        {
            menuItemPayplan.Items.Add(new RadMenuItem { Text = payplanMenuItem.PageName, NavigateUrl = payplanMenuItem.NavigateURL });
        }

        //Adding Menu Item
        var menuItemTransactions = new RadMenuItem { Text = "Transactions" };
        var transactionsMenuItems = activeMenus.Where(res => res.MenuName.Contains("Transaction"));
        foreach (var transactionMenuItem in transactionsMenuItems)
        {
            menuItemTransactions.Items.Add(new RadMenuItem { Text = transactionMenuItem.PageName, NavigateUrl = transactionMenuItem.NavigateURL });
        }

        //Adding Menu Item
        var menuItemClaims = new RadMenuItem { Text = "Claims" };
        var claimMenuItems = activeMenus.Where(res => res.MenuName.Contains("Claim"));
        foreach (var claimMenuItem in claimMenuItems)
        {
            menuItemClaims.Items.Add(new RadMenuItem { Text = claimMenuItem.PageName, NavigateUrl = claimMenuItem.NavigateURL });
        }

        //Adding Menu Item
        var menuItemCollections = new RadMenuItem { Text = "Collections" };
        var collectionMenuItems = activeMenus.Where(res => res.MenuName.Contains("Collection"));
        foreach (var collectionMenuItem in collectionMenuItems)
        {
            menuItemCollections.Items.Add(new RadMenuItem { Text = collectionMenuItem.PageName, NavigateUrl = collectionMenuItem.NavigateURL });
        }

        //Adding Menu Item
        var menuItemReports = new RadMenuItem { Text = "Reporting" };
        var reportMenuItems = activeMenus.Where(res => res.MenuName.Contains("Report"));
        foreach (var reportMenuItem in reportMenuItems)
        {
            menuItemReports.Items.Add(new RadMenuItem { Text = reportMenuItem.PageName, NavigateUrl = reportMenuItem.NavigateURL });
        }

        //Adding Menu Item
        var menuItemAdmin = new RadMenuItem { Text = "Admin" };
        var adminMenuItems = activeMenus.Where(res => res.MenuName.Contains("Admin"));
        foreach (var adminMenuItem in adminMenuItems)
        {
            menuItemAdmin.Items.Add(new RadMenuItem { Text = adminMenuItem.PageName, NavigateUrl = adminMenuItem.NavigateURL });
        }

        //Adding Menu Item
        var menuItemSysAdmin = new RadMenuItem { Text = "Sys Admin" };
        var sysAdminMenuItems = activeMenus.Where(res => res.MenuName.Contains("Sysadmin"));
        foreach (var sysAdminMenuItem in sysAdminMenuItems)
        {
            menuItemSysAdmin.Items.Add(new RadMenuItem { Text = sysAdminMenuItem.PageName, NavigateUrl = sysAdminMenuItem.NavigateURL });
        }

        //Adding all Menu Items-Sub Items checkin
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(ValidateAndGetQuickPayButton());
        radTopMenu.Items.Add(new RadMenuItem());
        radTopMenu.Items.Add(new RadMenuItem());

        if (subscriberMenuItems.Any())
            radTopMenu.Items.Add(menuItemSubscriber);


        if (accountsMenuItems.Any())
            radTopMenu.Items.Add(menuItemAccounts);


        if (statementMenuItems.Any())
            radTopMenu.Items.Add(menuItemStatement);


        if (eligibilityMenuItems.Any())
            radTopMenu.Items.Add(menuItemEligibility);


        if (creditMenuItems.Any())
            radTopMenu.Items.Add(menuItemCredit);


        if (payplanMenuItems.Any())
            radTopMenu.Items.Add(menuItemPayplan);


        if (transactionsMenuItems.Any())
            radTopMenu.Items.Add(menuItemTransactions);


        if (claimMenuItems.Any())
            radTopMenu.Items.Add(menuItemClaims);


        if (collectionMenuItems.Any())
            radTopMenu.Items.Add(menuItemCollections);


        if (reportMenuItems.Any())
            radTopMenu.Items.Add(menuItemReports);


        if (adminMenuItems.Any())
            radTopMenu.Items.Add(menuItemAdmin);

        if (sysAdminMenuItems.Any())
            radTopMenu.Items.Add(menuItemSysAdmin);

    }

    private RadMenuItem ValidateAndGetQuickPayButton()
    {
        var url = Request.RawUrl.AppendQueryString(new { qp = 1 }, true);
        var shouldEnable = ClientSession.RoleTypeID != (int)RoleType.ReadOnly;


        return new RadMenuItem
        {
            ImageUrl = "~/Content/Images/btn_quickpay_blue.gif",
            NavigateUrl = url,
            CssClass = "quick-pay-align",
            Enabled = shouldEnable,
            DisabledCssClass = "disable-button"
        };
    }
}