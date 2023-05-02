using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;
using System.Data;
public partial class patient_bankinfo : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {

        }

        // Preventing the popups to opening on page load
        popupManageAccounts.VisibleOnPageLoad = false;
    }

    #region Bank Account

    private DataTable GetLinkedBankAccounts()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID }, { "FlagBankOnly", 1 } };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get  ", cmdParams);
    }

    protected void grdLinkedBankAccounts_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var linkedBankAccounts = GetLinkedBankAccounts();
        grdLinkedBankAccounts.DataSource = linkedBankAccounts;
    }

    protected void grdLinkedBankAccounts_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            // For updating the bank account
            case "EditBankAccount":
                ClientSession.ObjectID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentCardID"]);
                ClientSession.ObjectType = ObjectType.ManageBankAccount;
                ManageAccountPopupSize(true);
                popupManageAccounts.VisibleOnPageLoad = true;

                break;

            // For remvoing the bank account
            case "RemoveBankAccount":
                var isFlagActivePP =
                    e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagActivePP"].ToString() == "1";

                var isFlagActiveBC =
                    e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagActiveBC"].ToString() == "1";

                // if FlagActivePP or FlagActiveBC is true then displaying the message.
                if (isFlagActivePP || isFlagActiveBC)
                {
                    radWindowDialog.RadAlert("<p>Credit cards and Bank accounts may not be deleted if they are actively assigned to a payment plan or credit account. Please first remove or replace the card or account before attempting to delete.</p>", 620, 100, "Unable to delete Card", string.Empty);
                    hdnIsLongMessage.Value = "1";
                    break;
                }

                // Else Continue to deleting the Bank account.
                var paymentID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentCardID"]);
                hdnSelectedBankAccountID.Value = paymentID.ToString();
                radWindowDialog.RadConfirm("<p>Do you want to remove selected bank account ?<br/>This action is permanent and can not be undone. </p>", "validateBankAccountRemoveRequest", 450, 150, null, string.Empty);
                break;
        }

    }

    protected void grdLinkedBankAccounts_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var imgPaymentPlan = item.FindControl("imgPaymentPlan") as Image;
            var imgBlueCredit = item.FindControl("imgBlueCredit") as Image;
            var paymentPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ActivePPAbbr"].ToString();
            var blueCredit = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ActiveBCAbbr"].ToString();
            // if payment plan is yes then changing the image on the grid
            imgPaymentPlan.ImageUrl = paymentPlan == YesNo.Yes.ToString() ? "Content/Images/icon_yes.png" : "Content/Images/icon_dash.png";
            // if blueCredit is yes then changing the image on the grid
            imgBlueCredit.ImageUrl = blueCredit == YesNo.Yes.ToString() ? "Content/Images/icon_yes.png" : "Content/Images/icon_dash.png";

        }
    }

    protected void btnRemoveBankAccount_Click(object sender, EventArgs e)
    {
        // if remove bank is confirmed then removing the bank account
        var paymentID = Convert.ToInt32(hdnSelectedBankAccountID.Value);
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID }, { "@PaymentCardID", paymentID }, { "@FlagActive", 0 } };
        SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
        radWindowDialog.RadAlert("<p>Your bank account has been removed successfully. </p>", 400, 150, string.Empty, string.Empty, "Content/Images/success.png");
        RebindGrids(false);
    }

    protected void btnAddNewBank_Click(object sender, EventArgs e)
    {
        // Setting the client session in order to show Bank panel.
        ClientSession.ObjectID = null;
        ClientSession.ObjectType = ObjectType.ManageBankAccount;
        ManageAccountPopupSize(true);
        popupManageAccounts.VisibleOnPageLoad = true;
    }



    #endregion

    #region Credit Card

    private DataTable GetLinkedCreditCards()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID }, { "FlagCreditOnly", 1 } };

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get  ", cmdParams);
    }

    protected void gridLinkedCreditCards_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var linkedCreditCards = GetLinkedCreditCards();
        gridLinkedCreditCards.DataSource = linkedCreditCards;

    }

    protected void gridLinkedCreditCards_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            // Updating the credit card
            case "EditCreditCard":

                ClientSession.ObjectID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentCardID"]);
                ClientSession.ObjectType = ObjectType.ManageCreditCard;
                ManageAccountPopupSize(false);
                popupManageAccounts.VisibleOnPageLoad = true;

                break;

            // removing the credit card
            case "RemoveCreditCard":

                var isFlagActivePP =
                    e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagActivePP"].ToString() == "1";

                var isFlagActiveBC =
                    e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagActiveBC"].ToString() == "1";

                // if isFlagActivePP or isFlagActiveBC is true displaying the message to the user.
                if (isFlagActivePP || isFlagActiveBC)
                {
                    radWindowDialog.RadAlert("<p>Credit cards and Bank accounts may not be deleted if they are actively assigned to a payment plan or credit account. Please first remove or replace the card or account before attempting to delete. </p>", 620, 100, "Unable to delete Card", string.Empty);
                    hdnIsLongMessage.Value = "1";
                    break;
                }

                // Else continue to deleting the Credit Card.
                var paymentID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentCardID"]);
                hdnSelectedCreditCardID.Value = paymentID.ToString("");
                radWindowDialog.RadConfirm("Do you want to remove selected Credit Card ?<br/>This action is permanent and can not be undone.", "validateCreditCardRemoveRequest", 450, 150, null, string.Empty);
                break;
        }
    }

    protected void gridLinkedCreditCards_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var imgPaymentPlan = item.FindControl("imgPaymentPlan") as Image;
            var imgBlueCredit = item.FindControl("imgBlueCredit") as Image;
            var paymentPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ActivePPAbbr"].ToString();
            var blueCredit = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ActiveBCAbbr"].ToString();
            // if Payment plan is yes then changing the Image on the grid
            imgPaymentPlan.ImageUrl = paymentPlan == YesNo.Yes.ToString() ? "Content/Images/icon_yes.png" : "Content/Images/icon_dash.png";
            // if blueCredit is yes then changing the Image on the grid
            imgBlueCredit.ImageUrl = blueCredit == YesNo.Yes.ToString() ? "Content/Images/icon_yes.png" : "Content/Images/icon_dash.png";

        }
    }

    protected void btnRemoveCreditCard_Click(object sender, EventArgs e)
    {
        // If delete request is confirmed then credit being removed.
        var paymentID = Convert.ToInt32(hdnSelectedCreditCardID.Value);
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID }, { "@PaymentCardID", paymentID }, { "@FlagActive", 0 } };
        SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
        radWindowDialog.RadAlert("<p>Your credit card has been removed successfully. </p>", 400, 150, string.Empty, string.Empty, "Content/Images/success.png");
        RebindGrids(true);
    }


    protected void btnAddNewCreditCard_Click(object sender, EventArgs e)
    {
        // Setting up the client session in order to show the Credit Card panel
        popupManageAccounts.VisibleOnPageLoad = true;
        ClientSession.ObjectID = null;
        ClientSession.ObjectType = ObjectType.ManageCreditCard;
        ManageAccountPopupSize(false);
    }


    #endregion


    private void ManageAccountPopupSize(bool isBankRequest)
    {
        popupManageAccounts.Height = new Unit(isBankRequest ? 430 : 530, UnitType.Pixel);
    }

    private void RebindGrids(bool isCreditCard)
    {
        // Rebinding the grids according to the request
        if (isCreditCard)
        {
            gridLinkedCreditCards.Rebind();
        }
        else
        {
            grdLinkedBankAccounts.Rebind();
        }
    }


}