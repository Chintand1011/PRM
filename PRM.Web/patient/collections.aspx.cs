using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class collections : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
             
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

  

    protected void grdCollections_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", ClientSession.SelectedPatientID},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@FlagCollection", 1},
                                {"@UserID", ClientSession.UserID}
                                };

        var collections = SqlHelper.ExecuteDataTableProcedureParams("web_pr_account_get", cmdParams);
        grdCollections.DataSource = collections;
    }

    protected void grdCollections_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "View":
                //ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["BlueCreditID"];
                //ClientSession.ObjectType = ObjectType.EligibilityDetail;
                //popupBlueCredit.VisibleOnPageLoad = true;
                //popupRequestBenefit.VisibleOnPageLoad = false;
                break;

        }
    }

    protected void cmbPatients_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            grdCollections.Rebind();
        }
        catch (Exception)
        {

            throw;
        }
    }

    protected void btnRunNew_Click(object sender, EventArgs e)
    {

    }
}