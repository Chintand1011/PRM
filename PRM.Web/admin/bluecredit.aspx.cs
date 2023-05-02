using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;
using System.Data;

public partial class bluecredit : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {

        }
    }

    private DataTable GetBlueCreditList()
    {
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredittype_list", new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID }, {"@FlagLenderFunded", 0} });
    }

    protected void grdBlueCredit_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        // Getting data when need
        grdBlueCredit.DataSource = GetBlueCreditList();
    }

    protected void grdBlueCredit_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            // Getting value from the grid in order to compare
            var flagActive = (int)e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagActive"];
            // Getting object of the telerik's RadButton
            var button = (RadButton)e.Item.FindControl("btnFlagActive");
            // Selecting the toogle button according to the FlagActive, if its 0 then showing Add else Remove
            button.SelectedToggleState.Selected = flagActive == 0;
        }
    }

    protected void btnFlagActive_OnClick(object sender, EventArgs e)
    {
        // Parsing the sender as RadButton
        var radButton = (sender as RadButton);
        // parsing its NamingContainer as GridDataItem
        var dataItem = radButton.NamingContainer as GridDataItem;
        // Getting the value in order to passing to proc
        var flagActive = (int)dataItem.GetDataKeyValue("FlagActive");
        var creditTypeID = (int)dataItem.GetDataKeyValue("CreditTypeID");

        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@CreditTypeID", creditTypeID},
                                {"@FlagActive", flagActive == 0 ? 1 : 0},
                                {"@UserID", ClientSession.UserID}
                            };

        SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredittype_add", cmdParams);
        // Rebinding to grid in order to show the updated results
        grdBlueCredit.Rebind();

        // Reloading session values
        (new UserLogin()).ReloadSessionValues(ClientSession.UserID);

        // Displaying message on each call
        RadWindow.RadAlert("Record successfully updated.", 350, 150, "", "", "../Content/Images/success.png");
        
    }

}
