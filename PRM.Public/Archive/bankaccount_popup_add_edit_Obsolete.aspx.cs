using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using System.Data;
using Telerik.Web.UI;
using PatientPortal.Utility;
public partial class bankaccount_popup_add_edit : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                var existingBanks = GetExistingBanks();
                cmbExistingBanks.DataSource = existingBanks;
                cmbExistingBanks.DataBind();

                //Get AccountType
                BindAccountType();

                //Get States
                BindStates();

                // Edit Case from BankInfo Page
                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.Bank)
                {
                    GetBankInformation((int)ClientSession.ObjectID);
                    cmbExistingBanks.SelectedValue = ClientSession.ObjectID.ToString();
                    btnUpdate.Visible = true;
                    cmbExistingBanks.Enabled = false;
                    return;
                }
                divExistingBank.Visible = false;
                btnSubmit.Visible = true;

            }
            catch (Exception)
            {

                throw;
            }

        }
        popupShowInputInformation.VisibleOnPageLoad = false;
        popupMessage.VisibleOnPageLoad = false;
    }

    private void BindAccountType()
    {
        cmbAccountType.Items.Add(new RadComboBoxItem { Text = AccountType.Checking.ToString(), Value = ((int)AccountType.Checking).ToString() });
        cmbAccountType.Items.Add(new RadComboBoxItem { Text = AccountType.Savings.ToString(), Value = ((int)AccountType.Savings).ToString() });
    }

    private DataTable GetExistingBanks()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID } };

        var existingBanks = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        ClientSession.Object = existingBanks;
        return existingBanks;
    }

    private void BindStates()
    {
        var cmdParams = new Dictionary<string, object>();
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", cmdParams);

        cmbStates.DataSource = states;
        cmbStates.DataBind();
    }

    private void GetBankInformation(Int32 paymentID)
    {
        if (ClientSession.Object != null)
        {
            var bankInformation = ClientSession.Object.Select("PaymentCardID=" + paymentID + "");
            txtLastName.Text = bankInformation[0]["NameLast"].ToString();
            txtFirstName.Text = bankInformation[0]["NameFirst"].ToString();
            txtBankName.Text = bankInformation[0]["BankName"].ToString();
            txtBranchCity.Text = bankInformation[0]["City"].ToString();
            cmbStates.SelectedValue = bankInformation[0]["StateTypeID"].ToString();
            cmbAccountType.SelectedValue = bankInformation[0]["AccountTypeID"].ToString();
            txtRoutingNumber.Text = bankInformation[0]["RoutingNumber"].ToString();
            txtAccountNumber.Text = bankInformation[0]["AccountNumberAbbr"].ToString();
            chkPrimarySeconday.Checked = Convert.ToBoolean(bankInformation[0]["FlagPrimary"]);
        }
    }

    protected void cmbExistingBanks_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            var selectedBankID = Convert.ToInt32(cmbExistingBanks.SelectedValue);

            if (selectedBankID > 0)
            {
                GetBankInformation(selectedBankID);
                btnUpdate.Visible = true;
                btnSubmit.Visible = false;
            }
            else
            {
                btnUpdate.Visible = false;
                btnSubmit.Visible = true;
            }
        }
        catch (Exception)
        {

            throw;
        }
    }


    protected void btnNext_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                var ipAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ?? Request.ServerVariables["REMOTE_ADDR"];
                var validCheck = new ValidCheck(txtRoutingNumber.Text.Trim(), txtAccountNumber.Text.Trim(), txtFirstName.Text.Trim() + " " + txtLastName.Text.Trim(), cmbAccountType.Text, ClientSession.PatientID, 0, ClientSession.AccountID, ClientSession.PracticeID, ipAddress, ClientSession.UserID);
                if (validCheck.Success)
                {
                    ShowInputInformation();
                    popupShowInputInformation.VisibleOnPageLoad = true;
                }
                else
                {
                    lblPopupMessage.Text = validCheck.FSPMessage;  //in case error message should be displayed
                    popupMessage.VisibleOnPageLoad = true;
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    private void ShowInputInformation()
    {
        lblLastName.Text = txtLastName.Text.Trim();
        lblFirstName.Text = txtFirstName.Text.Trim();
        lblBankName.Text = txtBankName.Text.Trim();
        lblBranchCity.Text = txtBranchCity.Text.Trim();
        lblBranchState.Text = cmbStates.SelectedItem.Text;
        lblAccountType.Text = cmbAccountType.SelectedItem.Text;
        lblRoutingNumber.Text = txtRoutingNumber.Text.Trim();
        lblAccountNumber.Text = txtAccountNumber.Text.Trim();
        if (!string.IsNullOrEmpty(cmbExistingBanks.SelectedValue))
        {
            btnUpdate.Visible = true;
            btnSubmit.Visible = false;
        }
        else
        {
            btnUpdate.Visible = false;
            btnSubmit.Visible = true;
        }
    }

    #region Input Data Show Popup

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                var ipAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ?? Request.ServerVariables["REMOTE_ADDR"];
                var validCheck = new ValidCheck(txtRoutingNumber.Text.Trim(), txtAccountNumber.Text.Trim(), txtFirstName.Text.Trim() + " " + txtLastName.Text.Trim(), cmbAccountType.Text, ClientSession.PatientID, 10000, ClientSession.AccountID, ClientSession.PracticeID, ipAddress, ClientSession.UserID);
                if (validCheck.Success)
                {
                    var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.PatientID },
                                    { "@NameLast", txtLastName.Text.Trim() },
                                    { "@NameFirst", txtFirstName.Text.Trim() },
                                    { "@BankName", txtBankName.Text.Trim() },
                                    { "@City", txtBranchCity.Text.Trim() },
                                    { "@StateTypeID", cmbStates.SelectedValue },
                                    { "@AccountTypeID", cmbAccountType.SelectedValue },
                                    { "@CardLast4", txtAccountNumber.Text.Trim().Substring(txtAccountNumber.Text.Trim().Length-4) },
                                    { "@FlagPrimary", chkPrimarySeconday.Checked }
                                };

                    SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
                    ClientScript.RegisterStartupScript(Page.GetType(), "mykey", "CloseAndRebind();", true);
                    litMessage.Text = "Bank Account has been added successfully.";
                }
                else
                {
                    lblPopupMessage.Text = validCheck.FSPMessage;  //in case error message should be displayed
                    popupMessage.VisibleOnPageLoad = true;
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                var ipAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ?? Request.ServerVariables["REMOTE_ADDR"];
                var validCheck = new ValidCheck(txtRoutingNumber.Text.Trim(), txtAccountNumber.Text.Trim(), txtFirstName.Text.Trim() + " " + txtLastName.Text.Trim(), cmbAccountType.Text, ClientSession.PatientID, 10000, ClientSession.AccountID, ClientSession.PracticeID, ipAddress, ClientSession.UserID);
                if (validCheck.Success)
                {
                    var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.PatientID },
                                    { "@PaymentCardID", cmbExistingBanks.SelectedValue },                                    
                                    { "@NameLast", txtLastName.Text.Trim() },
                                    { "@NameFirst", txtFirstName.Text.Trim() },
                                    { "@BankName", txtBankName.Text.Trim() },
                                    { "@City", txtBranchCity.Text.Trim() },
                                    { "@StateTypeID", cmbStates.SelectedValue },
                                    { "@AccountTypeID", cmbAccountType.SelectedValue },
                                    { "@CardLast4", txtAccountNumber.Text.Trim().Substring(txtAccountNumber.Text.Trim().Length-4) },
                                    { "@FlagPrimary", chkPrimarySeconday.Checked }
                                };

                    SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
                    ClientScript.RegisterStartupScript(Page.GetType(), "mykey", "CloseAndRebind();", true);
                    litMessage.Text = "Bank Account Information has been updated successfully.";
                }
                else
                {
                    lblPopupMessage.Text = validCheck.FSPMessage;  //in case error message should be displayed
                    popupMessage.VisibleOnPageLoad = true;
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }


    #endregion

}