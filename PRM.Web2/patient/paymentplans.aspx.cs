using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Data;
using PatientPortal.DataLayer;
using System.Web.Mail;

public partial class patient_paymentplans : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {

        }
        popupPaymentPlan.VisibleOnPageLoad = false;
        popupPayPanTransactionHistory.VisibleOnPageLoad = false;
        popupManageAccounts.VisibleOnPageLoad = false;
        popupEstimateView.VisibleOnPageLoad = false;
        ValidateandShowPaymentPlanPopup();
    }

    protected void Page_LoadComplete(object sender, EventArgs e)
    {
        var rowCount = grdCreateNewPlan.Items.Count;
        addStatementMessage.Visible = rowCount == 0;
    }

    private void ValidateandShowPaymentPlanPopup()
    {
        if (ClientSession.IsBlueCreditAddRequest == null) return;
        ClientSession.IsBlueCreditAddRequest = null;
        popupPaymentPlan.VisibleOnPageLoad = true;
    }

    #region Grid Operations

    private DataTable GetActiveStatements()
    {
        var activeStatements = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", new Dictionary<string, object> { { "@PatientId", ClientSession.SelectedPatientID }, { "@FlagBalance", 1 }, { "@FlagCurrent", 1 }, { "@UserID", ClientSession.UserID } });

        var view = activeStatements.DefaultView;
        view.RowFilter = string.Format("FlagCurrent={0}", 1);
        activeStatements = view.ToTable();
        return activeStatements;
    }

    protected void grdCreateNewPlan_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdCreateNewPlan.DataSource = GetActiveStatements();
    }

    protected void grdCreateNewPlan_ItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "AddPlan":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectValue = (decimal)e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["Balance"];
                ClientSession.ObjectID2 = null;
                ClientSession.ObjectType = ObjectType.AddPaymentPlan;
                popupPaymentPlan.VisibleOnPageLoad = true;
                break;

            case "View":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectType = ObjectType.Statement;
                popupEstimateView.VisibleOnPageLoad = true;
                break;
        }
    }

    protected void grdCreateNewPlan_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var flagCreditPlan = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagCreditPlan"]);
            var flagPayPlanEligible = Convert.ToBoolean(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagPayPlanEligible"]);

            // enabling if flagCreditPlan == false and flagPayPlanEligible == true
            item["AddPlan"].Enabled = (!flagCreditPlan && flagPayPlanEligible);
            (item["AddPlan"].Controls[0] as ImageButton).ImageUrl = (!flagCreditPlan && flagPayPlanEligible) ? "../Content/Images/icon_expand.gif" : "~/Content/Images/spacer.gif";

            // For Yes No Images
            var imgPayPlan = item.FindControl("imgPayPlan") as Image;
            var imgCreditPlan = item.FindControl("imgCreditPlan") as Image;
            var imgPlanEligible = item.FindControl("imgPlanEligible") as Image;
            var payPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditPayAbbr"].ToString();
            var creditPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["CreditPlanAbbr"].ToString();
            var payPlanEligibleAbbr = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PayPlanEligibleAbbr"].ToString();
            imgPayPlan.ImageUrl = payPlan == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";
            imgCreditPlan.ImageUrl = creditPlan == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";
            imgPlanEligible.ImageUrl = payPlanEligibleAbbr == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";

        }
    }

    protected void grdPaymentPlanHistory_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "DeletePlan":
                var cmdParams = new Dictionary<string, object>
                                    {

                                        { "@PaymentPlanID ", e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentPlanID"] },
                                        { "@FlagActive ", 0 },
                                        {"@UserID",ClientSession.UserID},
                                    };

                SqlHelper.ExecuteScalarProcedureParams("web_pt_payplan_add", cmdParams);
                Response.Redirect("~/paymentplan.aspx");
                break;

            case "ViewPaymentPlan":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentPlanID"];
                popupPayPanTransactionHistory.VisibleOnPageLoad = true;
                break;

            case "EditPlan":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["StatementID"];
                ClientSession.ObjectID2 = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentPlanID"];
                ClientSession.ObjectValue = (decimal)e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["Balance"];
                ClientSession.ObjectType = ObjectType.EditPaymentPlan;
                // InitializePaymentPlanPopup(statementBalance, (Int32)(ClientSession.ObjectID2));
                popupPaymentPlan.VisibleOnPageLoad = true;
                break;
        }
    }


    private DataTable GetPaymentPlanHistory()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@AccountID", ClientSession.SelectedPatientAccountID },
            { "@UserID", ClientSession.UserID}
        };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentplan_get", cmdParams);
    }

    protected void grdPaymentPlanHistory_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdPaymentPlanHistory.DataSource = GetPaymentPlanHistory();
    }

    #endregion

    protected void btnAddStatement_OnClick(object sender, EventArgs e)
    {
        popupAddStatement.VisibleOnPageLoad = true;
    }

}