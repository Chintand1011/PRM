using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class claims : BasePage
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

    private DataTable GetClaims()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", ClientSession.SelectedPatientID},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@UserID", ClientSession.UserID}
                            };
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_claim_get", cmdParams);
    }

    protected void grdClaims_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {

        grdClaims.DataSource = GetClaims();
    }

    protected void grdClaims_OnItemCommand(object source, GridCommandEventArgs e)
    {

    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        grdClaims.Rebind();
    }


}