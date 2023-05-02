using System;
using System.Activities.Expressions;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class payPlanTransHistory_popup : BasePage
{
    #region Labels

    public string PatientName { get; set; }
    public string StatementID { get; set; }
    public string PracticeName { get; set; }
    public string OpenDate { get; set; }

    #endregion

    public bool IsShowPayplanInfo { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                ClientSession.WasRequestFromPopup = true;
                GetPayplanDetails();
            }
            catch (Exception)
            {
                throw;
            }
        }
    }

    private void GetPayplanDetails()
    {
        var cmdParams = new Dictionary<string, object>()
        {
            { "@PaymentPlanID", ClientSession.ObjectID },
            { "@UserID", ClientSession.UserID}
        };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentplan_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            PatientName = row["PatientName"].ToString();
            StatementID = row["StatementID"].ToString();
            PracticeName = row["PracticeName"].ToString();
            OpenDate = row["OpenDate"].ToString();
        }
    }

    private DataTable GetPayPlanTransactionHistory()
    {
        var cmdParams = new Dictionary<string, object> { { "@PaymentPlanID", ClientSession.ObjectID } };
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentplan_amortsched", cmdParams);
    }

    protected void grdPayPlanTransactionHistory_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdPayplanTransactionHistory.DataSource = GetPayPlanTransactionHistory();
    }

    protected void btnPrint_OnClick(object sender, EventArgs e)
    {
        IsShowPayplanInfo = true;
        GetPayplanDetails();
        grdPayplanTransactionHistory.AllowPaging = false;
        grdPayplanTransactionHistory.Rebind();
        Page.ClientScript.RegisterStartupScript(GetType(), "Print", "printPopup();", true);
    }

}