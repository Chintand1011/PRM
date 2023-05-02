using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class feeSchedulePrint_popup : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // Closing the popup in case of any error
                ClientSession.WasRequestFromPopup = true;
                ShowScheduleDetail();
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    private void ShowScheduleDetail()
    {
        var feeScheduleID = 0;
        if (ClientSession.ObjectType == ObjectType.FeeSchedule) feeScheduleID = Convert.ToInt32(ClientSession.ObjectID);
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@FeeScheduleID", feeScheduleID},
                                {"@UserID", ClientSession.UserID}
                            };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_feeschedule_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            lblFeeScheduleID.Text = row["FeeScheduleID"].ToString();
            lblScheduleName.Text = row["ScheduleName"].ToString();
            lblCarrierName.Text = row["CarrierName"].ToString();
            lblReferenceID.Text = row["ReferenceID"].ToString();
            lblServiceClass.Text = row["ServiceClassAbbr"].ToString();
            lblProvider.Text = row["ProviderName"].ToString();
            lblNPI.Text = row["ProviderNPI"].ToString();
            lblContractStatus.Text = row["FlagContractAbbr"].ToString();
            lblScheduleStatus.Text = row["FlagActiveAbbr"].ToString();
            lblRequestDate.Text = row["RequestDateTime"].ToString();
            lblExpiration.Text = row["DateExpiration"].ToString();
            lblReimBursement.Text = row["FlagPtReimbAbbr"].ToString();
            lblNotes.Text = row["Notes"].ToString();
        }
    }


    protected DataTable GetSchedules()
    {
        var feeScheduleID = 0;
        if (ClientSession.ObjectType == ObjectType.FeeSchedule) feeScheduleID = Convert.ToInt32(ClientSession.ObjectID);
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@FeeScheduleID",feeScheduleID},
                                {"@UserID", ClientSession.UserID}
                            };
        var schedules = SqlHelper.ExecuteDataTableProcedureParams("web_pr_feeschedulecpt_get", cmdParams);
        return schedules;
    }

    protected void grdSchedules_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var schedules = GetSchedules();
        grdSchedules.DataSource = schedules;

        var rowCount = schedules.Rows.Count;
        if (rowCount > 0)
        {
            grdSchedules.PageSize = rowCount;
        }
        
    }

}
