using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class pc_add_popup : BasePage
{
    public string PopupTitle;
    public string PopupDescription;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // checking from query string if we need to show Payment Methods dropdown or not
                var allowPaymentMethods = Request.QueryString["ShowPaymentMethods"];
                if (allowPaymentMethods == "1")
                {
                    divPaymentMethods.Visible = true;
                    hdnIsRebind.Value = "1";
                    ManageCreditCardAccount();
                    return;
                }

                ValidateAccounts();
            }
            catch (Exception)
            {

                throw;
            }
        }

    }

    protected void rdCreditCard_CheckedChanged(object sender, EventArgs e)
    {
        ManageCreditCardAccount();
    }

    protected void rdBankAccount_CheckedChanged(object sender, EventArgs e)
    {
        ManageLinkedBankAccount();
    }


    #region Manage Bank Account

    #region Show BankAccount Information

    private void BindAccountType()
    {
        cmbAccountType.Items.Add(new RadComboBoxItem { Text = AccountType.Checking.ToString(), Value = ((int)AccountType.Checking).ToString() });
        cmbAccountType.Items.Add(new RadComboBoxItem { Text = AccountType.Savings.ToString(), Value = ((int)AccountType.Savings).ToString() });
    }
    private void BindStates()
    {
        var cmdParams = new Dictionary<string, object>();
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", cmdParams);

        cmbStates.DataSource = states;
        cmbStates.DataBind();
    }

    private DataTable GetExistingBanks()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID }, { "@FlagBankOnly", 1 } };

        var existingBanks = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        ClientSession.Object = existingBanks;
        return existingBanks;
    }

    private void InitializeBankAccountPopup(Int32 paymentID = 0)
    {
        cmbExistingBanks.DataSource = GetExistingBanks();
        cmbExistingBanks.DataBind();

        GetBankInformation(paymentID);

        // Edit Case from BankInfo Page
        if (paymentID > 0)
        {
            cmbExistingBanks.SelectedValue = paymentID.ToString();
            btnUpdate.Visible = true;
            cmbExistingBanks.Enabled = false;
            return;
        }


        divExistingBank.Visible = false;
        btnSubmit.Visible = true;
    }

    private void GetBankInformation(Int32 paymentID)
    {

        if (paymentID > 0)
        {
            var bankInformation = ClientSession.Object.Select("PaymentCardID=" + paymentID);
            txtLastName.Text = bankInformation[0]["NameLast"].ToString();
            txtFirstName.Text = bankInformation[0]["NameFirst"].ToString();
            txtBankName.Text = bankInformation[0]["BankName"].ToString();
            txtBranchCity.Text = bankInformation[0]["City"].ToString();
            cmbStates.SelectedValue = bankInformation[0]["StateTypeID"].ToString();
            cmbAccountType.SelectedValue = bankInformation[0]["FlagSavingsAccnt"].ToString();
            txtRoutingNumber.Text = bankInformation[0]["CheckRouting"].ToString();
            txtAccountNumber.Text = "****-****-" + bankInformation[0]["Last4"];
            hdnBankPNRef.Value = bankInformation[0]["PNRef"].ToString();
            chkBankPrimarySeconday.Checked = Convert.ToBoolean(bankInformation[0]["FlagPrimary"]);
        }
        else
        {
            txtFirstName.Text = ClientSession.FirstName;
            txtLastName.Text = ClientSession.LastName;
        }

        // Displaying Bank Details
        //GetBankDetails();
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

    protected void txtRoutingNumber_OnTextChanged(object sender, EventArgs e)
    {
        GetBankDetails();
        ManagePopupHeader(true, true);
    }

    private void GetBankDetails()
    {
        if (string.IsNullOrEmpty(txtRoutingNumber.Text))
        {
            txtBankName.Text = string.Empty;
            txtBranchCity.Text = string.Empty;
            cmbStates.SelectedValue = string.Empty;
            return;
        }

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_banktype_get", new Dictionary<string, object>
        {
            {"@routingnum", txtRoutingNumber.Text}
        });

        foreach (DataRow row in reader.Rows)
        {
            txtBankName.Text = row["bankabbr"].ToString();
            txtBranchCity.Text = row["City"].ToString();
            cmbStates.SelectedValue = row["StateTypeID"].ToString();
        }
    }

    private bool ValidateBank()
    {
        var validCheck = new ValidCheck(txtRoutingNumber.Text.Trim(), txtAccountNumber.Text.Trim(), txtFirstName.Text.Trim() + " " + txtLastName.Text.Trim(), cmbAccountType.Text, ClientSession.PatientID, 0, ClientSession.AccountID, ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID);
        if (validCheck.Success)
        {
            hdnBankPNRef.Value = validCheck.PNRef;
        }

        return validCheck.Success;
    }


    #endregion

    #region Input Data Show Popup

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                if (!ValidateBank())
                {
                    RadWindow.RadAlert("Please revise your information again because provided information was not correct", 350, 150, "", "", "~/Content/Images/warning.png");
                    return;
                }


                var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.PatientID },
                                    { "@NameLast", txtLastName.Text.Trim() },
                                    { "@NameFirst", txtFirstName.Text.Trim() },
                                    { "@BankName", txtBankName.Text.Trim() },
                                    { "@City", txtBranchCity.Text.Trim() },
                                    { "@StateTypeID", cmbStates.SelectedValue },
                                    { "@CheckRouting", txtRoutingNumber.Text},
                                    { "@FlagSavingsAccnt", cmbAccountType.SelectedValue },
                                    { "@CardLast4", txtAccountNumber.Text.Trim().Substring(txtAccountNumber.Text.Trim().Length-4) },
                                    { "@FlagPrimary", chkBankPrimarySeconday.Checked },
                                    { "@PNRef", hdnBankPNRef.Value },
                                    { "@FlagActive", 1},
                                    { "@UserID", ClientSession.UserID },
                                    { "@IPAddress", ClientSession.IPAddress },
                                };

                var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_add", cmdParams);
                foreach (DataRow row in reader.Rows)
                {
                    if (Convert.ToBoolean(row["FlagDupCard"]))
                    {
                        RadWindow.RadAlert("Please revise your information again, you entered a duplicate card number", 350, 150, "", "", "~/Content/Images/warning.png");
                    }
                    else
                    {
                        RadWindow.RadAlert("Bank Account added successfully", 350, 120, "", "reloadPage", "~/Content/Images/success.png");
                    }
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

                var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.PatientID },
                                    { "@PaymentCardID", cmbExistingBanks.SelectedValue },                                    
                                    { "@NameLast", txtLastName.Text.Trim() },
                                    { "@NameFirst", txtFirstName.Text.Trim() },
                                    { "@BankName", txtBankName.Text.Trim() },
                                    { "@City", txtBranchCity.Text.Trim() },
                                    { "@StateTypeID", cmbStates.SelectedValue },
                                    //{ "@CheckRouting", txtRoutingNumber.Text.Trim() },
                                    { "@FlagSavingsAccnt", cmbAccountType.SelectedValue },
                                    { "@FlagPrimary", chkBankPrimarySeconday.Checked },
                                    { "@PNRef", hdnBankPNRef.Value },
                                    { "@FlagActive", 1},
                                    { "@UserID", ClientSession.UserID },
                                    { "@IPAddress", ClientSession.IPAddress },
                                };

                SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
                RadWindow.RadAlert("Bank Account updated successfully", 350, 120, "", "reloadPage", "~/Content/Images/success.png");
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    private void ManageBankAccountValidations(bool isEnable)
    {
        cmbAccountType.Enabled = isEnable;
        txtRoutingNumber.Enabled = isEnable;
        txtAccountNumber.Enabled = isEnable;
        RgrExpnAccountNumber.Enabled = isEnable;
    }

    #endregion

    private void ClearBankPopupFields()
    {
        cmbExistingBanks.ClearSelection();
        txtLastName.Text = string.Empty;
        txtFirstName.Text = string.Empty;
        txtBankName.Text = string.Empty;
        txtBranchCity.Text = string.Empty;
        cmbStates.ClearSelection();
        cmbAccountType.ClearSelection();
        txtRoutingNumber.Text = string.Empty;
        txtAccountNumber.Text = string.Empty;
        chkBankPrimarySeconday.Checked = false;
    }

    #endregion

    #region Manage Credit Card

    #region Show CreditCard Popup

    private bool ValidateCreditCard()
    {
        var cardType = Convert.ToInt32(cmbCardType.SelectedValue); //Convert.ToInt32(hdnCardType.Value);
        var month = txtMonth.Text.Length == 1 ? "0" + txtMonth.Text : txtMonth.Text;
        var expiryDate = month + txtYear.Text.Substring(2, 2);
        var fsv = new ValidCard(cardType, txtCardNumber.Text, expiryDate, ClientSession.PatientID, 0, ClientSession.AccountID, ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, txtCreditCardFirstName.Text.Trim() + " " + txtCreditCardLastName.Text.Trim(), txtStreet.Text, txtZipCode.Text, txtCVVSecurityID.Text);
        if (fsv.Success) //card was validated.
            hdnPref.Value = fsv.PNRef;

        return fsv.Success;
    }

    private void InitializeCreditCardPopup(Int32 paymentID = 0)
    {
        var existingCards = GetExistingCards();
        cmbExistingCards.DataSource = existingCards;
        cmbExistingCards.DataBind();


        //Get Card Types
        cmbCardType.ClearSelection();
        cmbCardType.DataSource = GetCardTypes();
        cmbCardType.DataBind();

        //Get States
        BindCreditCardStates();

        // Get Card info
        GetCardInformation(paymentID);

        if (paymentID > 0)
        {
            cmbExistingCards.SelectedValue = paymentID.ToString();
            cmbExistingCards.Enabled = false;
            divExistingCard.Visible = true;
            cmbCardType.Enabled = false;
            return;
        }
        cmbCardType.Enabled = true;
        divExistingCard.Visible = false;
    }

    private DataTable GetCardTypes()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } };
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_cardtype_list", cmdParams);
    }

    private DataTable GetExistingCards()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID }, { "FlagCreditOnly", 1 } };
        var existingCards = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        ClientSession.Object = existingCards;
        return existingCards;
    }

    private void BindCreditCardStates()
    {
        var cmdParams = new Dictionary<string, object>();
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", cmdParams);
        cmbCreditCardStates.DataSource = states;
        cmbCreditCardStates.DataBind();
    }

    private void GetCardInformation(Int32 paymentID)
    {
        if (paymentID > 0)
        {
            var cardInformation = ClientSession.Object.Select("PaymentCardID=" + paymentID + "");
            txtCreditCardLastName.Text = cardInformation[0]["NameLast"].ToString();
            txtCreditCardFirstName.Text = cardInformation[0]["NameFirst"].ToString();
            txtStreet.Text = cardInformation[0]["Address1"].ToString();
            txtAptSuite.Text = cardInformation[0]["Address2"].ToString();
            txtCity.Text = cardInformation[0]["City"].ToString();
            cmbCreditCardStates.SelectedValue = cardInformation[0]["StateTypeID"].ToString();
            txtZipCode.Text = cardInformation[0]["Zip"].ToString();
            cmbCardType.SelectedValue = cardInformation[0]["PaymentCardTypeID"].ToString();
            txtIssuingBank.Text = cardInformation[0]["BankName"].ToString();
            txtBankPhone.Text = cardInformation[0]["BankPhone"].ToString();
            txtShowCardNumber.Text = cardInformation[0]["CardNumberAbbr"].ToString();
            txtMonth.Text = cardInformation[0]["ExpMonth"].ToString();
            txtYear.Text = cardInformation[0]["ExpYear"].ToString();
            hdnPref.Value = cardInformation[0]["PNRef"].ToString();
            var cardClass = Convert.ToInt32(cardInformation[0]["FlagCommercialCard"]);

            if (cardClass == (int)CardClass.Personal) rdPersonal.Checked = true;
            else rdCorporate.Checked = true;

            SetValidationExpression();

            chkCreditPrimarySeconday.Checked = Convert.ToBoolean(cardInformation[0]["FlagPrimary"]);
            //ckhCreditAdditionalUse.Checked = (bool)cardInformation[0]["FlagActive"];
            var existingCardName = cardInformation[0]["CardTypeAbbr"].ToString();
            txtCVVSecurityID.Text = existingCardName.Contains("American Express") ? "****" : "***";
        }
        else
        {
            txtCreditCardFirstName.Text = ClientSession.FirstName;
            txtCreditCardLastName.Text = ClientSession.LastName;
            txtStreet.Text = ClientSession.PatientInfo["Address1"];
            txtAptSuite.Text = ClientSession.PatientInfo["Address2"];
            txtCity.Text = ClientSession.PatientInfo["City"];
            cmbCreditCardStates.SelectedValue = ClientSession.PatientInfo["StateID"];
            txtZipCode.Text = ClientSession.PatientInfo["ZipCode"];
        }
    }


    protected void cmbCardType_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        SetValidationExpression();
        PopupTitle = " Linked Credit Card Manager";
        PopupDescription = ViewState["PopupDescription"].ToString();
    }


    private void SetValidationExpression()
    {
        var cardTypes = GetCardTypes();
        var existingCardName = cardTypes.Select("PaymentCardTypeID=" + cmbCardType.SelectedValue)[0]["Name"].ToString();

        if (existingCardName.Contains("American Express"))
        {
            txtCardNumber.Mask = "####-######-#####";
            regexpCardNumber.ValidationExpression = @"\d{4}\-\d{6}\-\d{5}";
            txtCVVSecurityID.MaxLength = 4;
            rglExprrCVVSecurityID.ValidationExpression = "^[0-9]{4}$";
            txtIssuingBank.Text = "American Express";
            txtBankPhone.Text = "8005284800";
        }
        else
        {
            txtCardNumber.Mask = "####-####-####-####";
            regexpCardNumber.ValidationExpression = @"\d{4}\-\d{4}\-\d{4}\-\d{4}";
            txtCVVSecurityID.MaxLength = 3;
            rglExprrCVVSecurityID.ValidationExpression = "^[0-9]{3}$";
            txtIssuingBank.Text = string.IsNullOrEmpty(cmbExistingCards.SelectedValue) ? string.Empty : txtIssuingBank.Text;
            txtBankPhone.Text = string.IsNullOrEmpty(cmbExistingCards.SelectedValue) ? string.Empty : txtBankPhone.Text;
            if (existingCardName.Contains("Discover"))
            {
                txtIssuingBank.Text = "Discover";
                txtBankPhone.Text = "8003472683";
            }
        }
        txtCVVSecurityID.Text = string.Empty;
    }


    #endregion

    #region Input Data show Popup

    protected void btnCreditCardSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            if (!ValidateCreditCard())
            {
                RadWindow.RadAlert("Please revise your information again because provided information was not correct", 350, 150, "", "", "~/Content/Images/warning.png");
                return;
            }

            var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.PatientID },
                                    { "@NameLast", txtCreditCardLastName.Text.Trim() },
                                    { "@NameFirst", txtCreditCardFirstName.Text.Trim() },
                                    { "@Addr1", txtStreet.Text.Trim() },
                                    { "@Addr2", txtAptSuite.Text.Trim() },
                                    { "@City", txtCity.Text.Trim()},
                                    { "@StateTypeID", cmbCreditCardStates.SelectedValue },
                                    { "@Zip", txtZipCode.Text.Trim() },
                                    { "@PaymentCardTypeID", cmbCardType.SelectedValue },
                                    { "@BankName", txtIssuingBank.Text.Trim() },
                                    { "@BankPhone", txtBankPhone.Text.Trim() },
                                    { "@CardLast4", txtCardNumber.Text.Trim().Substring( txtCardNumber.Text.Trim().Length-4) },
                                    { "@ExpMonth", txtMonth.Text.Trim() },
                                    { "@ExpYear", txtYear.Text.Trim() },
                                    { "@PNRef", hdnPref.Value },                                    
                                    { "@FlagCommercialCard", rdPersonal.Checked ? "0" : "1"},
                                    { "@FlagPrimary", chkCreditPrimarySeconday.Checked },
                                    { "@UserID", ClientSession.UserID},
                                    { "@FlagActive", 1},
                                    { "@IPAddress", ClientSession.IPAddress},
                                 };


            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_add", cmdParams);
            foreach (DataRow row in reader.Rows)
            {
                if (Convert.ToBoolean(row["FlagDupCard"]))
                {
                    RadWindow.RadAlert("Please revise your information again, you entered a duplicate card number", 350, 150, "", "", "~/Content/Images/warning.png");
                }
                else
                {
                    RadWindow.RadAlert("Credit Card added successfully", 350, 120, "", "reloadPage", "~/Content/Images/success.png");
                }
            }
        }
        catch (Exception)
        {
            throw;
        }
    }

    protected void btnCreditCardUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            var cmdParams = new Dictionary<string, object>
                                    {
                                        {"@PatientID", ClientSession.PatientID},
                                        {"@PaymentCardID", cmbExistingCards.SelectedValue},
                                        {"@NameLast", txtCreditCardLastName.Text.Trim() },
                                        {"@NameFirst", txtCreditCardFirstName.Text.Trim() },
                                        {"@Addr1", txtStreet.Text.Trim() },
                                        {"@Addr2", txtAptSuite.Text.Trim() },
                                        {"@City", txtCity.Text.Trim()},
                                        {"@StateTypeID", cmbCreditCardStates.SelectedValue },
                                        {"@Zip", txtZipCode.Text.Trim() },
                                        //{"@PaymentCardTypeID", cmbCardType.SelectedValue},
                                        {"@BankName", txtIssuingBank.Text.Trim()},
                                        {"@BankPhone", txtBankPhone.Text.Trim()},
                                        {"@PNRef", hdnPref.Value }, 
                                        {"@FlagPrimary", chkCreditPrimarySeconday.Checked },
                                        {"@UserID", ClientSession.UserID},
                                        {"@FlagActive", 1},
                                        {"@IPAddress", ClientSession.IPAddress},
                                     };

            SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
            RadWindow.RadAlert("Credit Card has been updated successfully", 350, 120, "", "reloadPage", "~/Content/Images/success.png");
        }
        catch (Exception)
        {

            throw;
        }
    }

    #endregion

    private void ClearCreditPopupFields()
    {
        cmbExistingCards.ClearSelection();
        txtCreditCardLastName.Text = string.Empty;
        txtCreditCardFirstName.Text = string.Empty;
        txtStreet.Text = string.Empty;
        txtAptSuite.Text = string.Empty;
        txtCity.Text = string.Empty;
        cmbCreditCardStates.ClearSelection();
        txtZipCode.Text = string.Empty;
        chkCreditPrimarySeconday.Checked = false;
        cmbCardType.ClearSelection();
        txtIssuingBank.Text = string.Empty;
        txtBankPhone.Text = string.Empty;
        txtCardNumber.Text = string.Empty;
        txtMonth.Text = string.Empty;
        txtYear.Text = string.Empty;
        txtCVVSecurityID.Text = string.Empty;
        rdPersonal.Checked = true;
        rdCorporate.Checked = false;
    }

    private void ManageCreditCardSubmitButtons(bool isEdit)
    {
        if (isEdit)
        {
            btnCreditCardSubmit.Visible = false;
            btnCreditCardSubmit.Enabled = false;
            btnCreditCardUpdate.Visible = true;
            btnCreditCardUpdate.Enabled = true;
        }
        else
        {
            btnCreditCardSubmit.Visible = true;
            btnCreditCardSubmit.Enabled = true;
            btnCreditCardUpdate.Visible = false;
            btnCreditCardUpdate.Enabled = false;
        }
    }

    private void ManageCreditCardValidations(bool isEnable)
    {
        txtCardNumber.Enabled = isEnable;
        regexpCardNumber.Enabled = isEnable;
        cstVldCardNumber.Enabled = isEnable;
        txtMonth.Enabled = isEnable;
        txtYear.Enabled = isEnable;
        txtCVVSecurityID.Enabled = isEnable;
        rdPersonal.Enabled = isEnable;
        rdCorporate.Enabled = isEnable;

        if (isEnable)
        {
            txtCardNumber.Visible = true;
            txtShowCardNumber.Visible = false;
            rglExprrCVVSecurityID.Enabled = true;
            rqdCardNumber.Enabled = true;
        }
        else
        {
            txtCardNumber.Visible = false;
            txtShowCardNumber.Visible = true;
            rglExprrCVVSecurityID.Enabled = false;
            rqdCardNumber.Enabled = false;
        }
    }

    #endregion


    private void ManagePanels(bool isBankAccount)
    {
        if (isBankAccount)
        {
            BindAccountType();
            BindStates();
            ManageBankAccountPanel();
        }
        else
        {
            ManageCreditCardPanel();
        }
    }

    private void ManageBankAccountPanel()
    {
        pnlCreditCard.Visible = false;
        pnlBankAccount.Visible = true;
    }

    private void ManageCreditCardPanel()
    {
        rngValidatorYear.MinimumValue = DateTime.Now.Year.ToString();
        rngValidatorYear.MaximumValue = (DateTime.Now.Year + 10).ToString();
        pnlCreditCard.Visible = true;
        pnlBankAccount.Visible = false;
        //Get Card Types
        cmbCardType.DataSource = GetCardTypes();
        cmbCardType.DataBind();

    }

    private void ValidateAccounts()
    {
        if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.ManageBankAccount)
        {
            ManageBankAccountValidations(false);
            ManagePanels(true);
            InitializeBankAccountPopup(Convert.ToInt32(ClientSession.ObjectID));
            //PopupTitle = "Linked Bank Account Manager";
            //PopupDescription = "Modify Bank Account";
            ManagePopupHeader(true, false);
        }
        else if (ClientSession.ObjectType == ObjectType.ManageBankAccount)
        {
            ManageLinkedBankAccount();
        }

        if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.ManageCreditCard)
        {
            ManageCreditCardValidations(false);
            ManageCreditCardSubmitButtons(true);
            InitializeCreditCardPopup(Convert.ToInt32(ClientSession.ObjectID));
            ManagePanels(false);
            //PopupTitle = " Linked Credit Card Manager";
            //PopupDescription = "Modify Credit Card";
            //ViewState["PopupDescription"] = "Modify Credit Card";
            ManagePopupHeader(false, false);
        }
        else if (ClientSession.ObjectType == ObjectType.ManageCreditCard)
        {
            ManageCreditCardAccount();
        }
    }

    private void ManageLinkedBankAccount()
    {
        ClearBankPopupFields();
        ManageBankAccountValidations(true);
        ManagePanels(true);
        InitializeBankAccountPopup();
        //PopupTitle = "Linked Bank Account Manager";
        //PopupDescription = "Add New Bank Account";
        ManagePopupHeader(true, true);
        cmbAccountType.SelectedIndex = 0;
    }

    private void ManageCreditCardAccount()
    {
        ClearCreditPopupFields();
        ManageCreditCardValidations(true);
        ManageCreditCardSubmitButtons(false);
        InitializeCreditCardPopup();
        ManagePanels(false);
        //PopupTitle = " Linked Credit Card Manager";
        //PopupDescription = "Add New Credit Card";
        //ViewState["PopupDescription"] = "Add New Credit Card";
        ManagePopupHeader(false, true);
    }

    private void ManagePopupHeader(bool isBankAccount, bool isNewAccount)
    {

        string popupTitle;
        string popupDescription;

        if (isBankAccount)
        {
            popupTitle = "Linked Bank Account Manager";
            popupDescription = isNewAccount ? "Add New Bank Account" : "Modify Bank Account";
        }
        else
        {
            popupTitle = "Linked Credit Card Manager";
            popupDescription = isNewAccount ? "Add New Credit Card" : "Modify Credit Card";
        }

        PopupTitle = popupTitle;
        PopupDescription = popupDescription;
        ViewState["PopupDescription"] = popupDescription;
    }

}
