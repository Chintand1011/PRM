using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Charting;
using Telerik.Web.UI;

public partial class transaction_dashboard : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindPproviders();
            DisplayGraph();
        }

    }

    private void BindPproviders()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID", ClientSession.PracticeID}
                                };

        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);
        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();
    }

    protected void cmbprovider_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        DisplayGraph();
    }

    private void DisplayGraph()
    {
        var cmdParams = new Dictionary<string, object> {
                                                           {"@PracticeID", ClientSession.PracticeID},
                                                            {"@ProviderID", string.IsNullOrEmpty(cmbProviders.SelectedValue) ? (object)DBNull.Value :cmbProviders.SelectedValue},
                                                            { "@UserID", ClientSession.UserID}
                                                       };
        var transactions = SqlHelper.ExecuteDataTableProcedureParams("web_transdash_c1_get", cmdParams);
        transactionChart.DataSource = transactions;
        transactionChart.DataBind();
        transactionChart.ChartTitle.TextBlock.Text = "Billed, Paid, BC/PP and Others";
    }
}