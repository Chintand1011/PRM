using System;
using System.Collections.Generic;
using PatientPortal.DataLayer;
using Telerik.Web.UI;
using System.Data;


public partial class impersonate : BasePage
{


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
        }
    }

    #region Grid Operations



    protected void grdUsers_ItemCommand(object source, GridCommandEventArgs e)
    {
        try
        {
            switch (e.CommandName)
            {
                case "RowClick":
                    {
                        var userId = (int)e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["SysUserID"];
                        (new UserLogin()).ReloadSessionValues(userId);
                        Response.Redirect("~/patient/search.aspx");
                        break;
                    }
            }
        }
        catch (Exception)
        {
            throw;
        }
    }

    protected void grdUsers_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdUsers.DataSource = GetUsers();
    }

    protected DataTable GetUsers()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID",ClientSession.PracticeID},
                                { "@UserID", ClientSession.UserID}
                            };
        var users = SqlHelper.ExecuteDataTableProcedureParams("web_pr_user_get", cmdParams);
        return users;
    }

    #endregion

}