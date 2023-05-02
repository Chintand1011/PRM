using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;
using System.Data;
public partial class cardonfile : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // Checking if request came from bluecredit page then assigning value to auto open bluecredit Add popup
            ClientSession.IsBlueCreditAddRequest = ClientSession.IsRedirectToBluecredit;

        }

        popupManageAccounts.VisibleOnPageLoad = false;
    }

    #region Bank Account

    private DataTable GetLinkedBankAccounts()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@PatientID", ClientSession.SelectedPatientID }, 
            { "@FlagBankOnly", 1 },
            { "@UserID", ClientSession.UserID}
        };

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
            case "EditBankAccount":
                ClientSession.ObjectID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentCardID"]);
                ClientSession.ObjectType = ObjectType.ManageBankAccount;
                popupManageAccounts.VisibleOnPageLoad = true;
                break;
            case "RemoveBankAccount":
                var paymentID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentCardID"]);
                hdnSelectedBankAccountID.Value = paymentID.ToString("");
                var flagActivePP = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagActivePP"]) == 1;
                var flagActiveBC = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagActiveBC"]) == 1;

                if (!flagActivePP && !flagActiveBC)
                {
                    RadWindowManager.RadConfirm("Do you want to remove selected bank account?<br/>This action is permanent and cannot be undone.", "confirmDeletionOfBankAccountOrCreditCard", 470, 140, null, "");
                }
                else
                {
                    const string message = "We are unable to perform this action. <br>Payment forms on file may not be deleted if they are in use by a BlueCredit or payment plan. First replace the bank account associated with any credit account and try again.";
                    RadWindowManager.RadAlert(message, 470, 100, "", "", "../Content/Images/warning.png");
                }

                ViewState["isRemoveCreditCard"] = false;

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
            imgPaymentPlan.ImageUrl = paymentPlan == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";
            imgBlueCredit.ImageUrl = blueCredit == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";

        }
    }


    protected void btnAddNewBank_Click(object sender, EventArgs e)
    {
        ClientSession.ObjectID = null;
        ClientSession.ObjectType = ObjectType.ManageBankAccount;
        popupManageAccounts.VisibleOnPageLoad = true;
    }



    #endregion

    #region Credit Card

    private DataTable GetLinkedCreditCards()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@PatientID", ClientSession.SelectedPatientID },
            { "@FlagCreditOnly", 1 },
            { "@UserID", ClientSession.UserID}
        };

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
            case "EditCreditCard":
                ClientSession.ObjectID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentCardID"]);
                ClientSession.ObjectType = ObjectType.ManageCreditCard;
                popupManageAccounts.VisibleOnPageLoad = true;
                //popupManageCreditCard.VisibleOnPageLoad = true;
                break;

            case "RemoveCreditCard":
                var paymentID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PaymentCardID"]);
                hdnSelectedCreditCardID.Value = paymentID.ToString();

                var flagActivePP = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagActivePP"]) == 1;
                var flagActiveBC = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagActiveBC"]) == 1;

                if (!flagActiveBC && !flagActivePP)
                {
                    RadWindowManager.RadConfirm("Do you want to remove selected credit card?<br/>This action is permanent and cannot be undone.", "confirmDeletionOfBankAccountOrCreditCard", 470, 140, null, "");
                }
                else
                {
                    const string message = "We are unable to perform this action. <br>Payment forms on file may not be deleted if they are in use by a BlueCredit or payment plan. First replace the payment form associated with any credit account and try again.";
                    RadWindowManager.RadAlert(message, 470, 100, "", "", "../Content/Images/warning.png");
                }

                ViewState["isRemoveCreditCard"] = true;

                break;
        }
    }

    protected void gridLinkedCreditCards_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (!(e.Item is GridDataItem)) return;


        var item = (GridDataItem)e.Item;
        var imgPaymentPlan = item.FindControl("imgPaymentPlan") as Image;
        var imgBlueCredit = item.FindControl("imgBlueCredit") as Image;
        var paymentPlan = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ActivePPAbbr"].ToString();
        var blueCredit = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ActiveBCAbbr"].ToString();
        imgPaymentPlan.ImageUrl = paymentPlan == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";
        imgBlueCredit.ImageUrl = blueCredit == YesNo.Yes.ToString() ? "../Content/Images/icon_yes.png" : "../Content/Images/icon_dash.png";


        var flagExpired = item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FlagExpired"].ParseBool();
        if (flagExpired)
        {
            var imageButton = (item["EditCard"].Controls[0] as ImageButton);
            imageButton.Enabled = false;
            imageButton.ImageUrl = "~/Content/Images/icon_dash.png";
        }
    }


    protected void btnAddNewCreditCard_Click(object sender, EventArgs e)
    {
        //popupManageCreditCard.VisibleOnPageLoad = true;
        popupManageAccounts.VisibleOnPageLoad = true;
        ClientSession.ObjectID = null;
        ClientSession.ObjectType = ObjectType.ManageCreditCard;
    }


    #endregion

    #region Common Functions

    protected void btn_RemoveBankAccountOrCreditCard(object sender, EventArgs e)
    {
        try
        {
            var isRemoveCreditCard = (bool)ViewState["isRemoveCreditCard"];
            var paymentCardID = Convert.ToInt32(isRemoveCreditCard ? hdnSelectedCreditCardID.Value : hdnSelectedBankAccountID.Value);
            RemoveBankAccountOrCreditCard(paymentCardID);

            if (isRemoveCreditCard)
            {
                gridLinkedCreditCards.Rebind();
            }
            else
            {
                grdLinkedBankAccounts.Rebind();
            }

            //PopupSubmitThanks.Visible = true;
            //lblThanksInfo.Text = isRemoveCreditCard
            //    ? "Your credit card has been removed successfully."
            //    : "Your bank account has been removed successfully.";

        }
        catch (Exception)
        {
            throw;
        }

    }

    private void RemoveBankAccountOrCreditCard(Int32 paymentID)
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@PaymentCardID", paymentID }, { "@FlagActive", 0 }, { "@UserID", ClientSession.UserID } };
        SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
    }

    #endregion

}