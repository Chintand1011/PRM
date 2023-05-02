using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.Utility;
using PatientPortal.DataLayer;

using Telerik.Web.UI;

//  CHANGE LOG
//  2016-09-02  hsingh  Modified name input fields to copy from the currently selected patient
//  


public partial class pc_add_popup : BasePage
{
    public string PopupTitle;
    public string PopupDescription;
    public bool IsShowPaymentMethods { get { return Request.QueryString["ShowPaymentMethods"].ParseBool(); } }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // Closing the popup in case of any error
            ClientSession.WasRequestFromPopup = true;

            try
            {
                // Checking if need to show the Credit Card and Bank account as a options
                if (IsShowPaymentMethods)
                {
                    // will run if request received from Bluecredit_Applycredit_popup.aspx
                    hdnIsRebind.Value = "1";
                    // Managing the accounts
                    ManageCreditCardAccount();

                    // Displaying Swipe Panel first
                    ManageSwipeandKeyCardPanels(false, true);

                    // Displaying titles
                    BindPopupDescriptionandTitle();

                    ShowPatientInformation();

                    return;
                }

                // Displaying the single Card according to the request(Credit or Bank)
                HideShowSections();

                if (IsCreditCardEditCase() || IsBankAccountEditCase())
                {
                    divPaymentMethods.Visible = false;
                }
                else
                {
                    ShowPatientInformation();
                }

            }
            catch (Exception)
            {

                throw;
            }

        }
    }



    protected void rdCreditCard_CheckedChanged(object sender, EventArgs e)
    {
        // Setting up the Credit Card Panel
        ManageCreditCardAccount();
        BindPopupDescriptionandTitle();
        rdSwipeCard.Visible = true;
        rdKeyCard.Visible = true;
        rdCardLabel.Visible = true;
        ShowPatientInformation();
    }

    protected void rdBankAccount_CheckedChanged(object sender, EventArgs e)
    {
        // Setting up the Credit Bank Account Panel
        ManageLinkedBankAccount();
        BindPopupDescriptionandTitle();
        ManageSwipeandKeyCardPanels(false);
        ShowPatientInformation();
    }


    #region Manage Bank Account

    protected void txtRoutingNumber_OnTextChanged(object sender, EventArgs e)
    {
        GetBankDetails();
        BindPopupDescriptionandTitle();
    }

    private void GetBankDetails()
    {
        if (string.IsNullOrEmpty(txtRoutingNumber.Text))
        {
            txtBankName.Text = string.Empty;
            txtBranchCity.Text = string.Empty;
            cmbStates.ClearSelection();
            return;
        }


        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_banktype_get", new Dictionary<string, object>
        {
            {"@routingnum", txtRoutingNumber.Text},
            {"@UserID", ClientSession.UserID}
        });

        foreach (DataRow row in reader.Rows)
        {
            txtBankName.Text = row["bankabbr"].ToString();
            txtBranchCity.Text = row["City"].ToString();
            cmbStates.SelectedValue = row["StateTypeID"].ToString();
        }

    }

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
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@FlagBankOnly", 1 }, { "@UserID", ClientSession.UserID } };

        var existingBanks = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        ClientSession.Object = existingBanks;
        return existingBanks;
    }

    private void InitializeBankAccountPopup(Int32 paymentID = 0)
    {
        cmbExistingBanks.DataSource = GetExistingBanks();
        cmbExistingBanks.DataBind();

        // Edit Case from BankInfo Page
        if (paymentID > 0)
        {
            GetBankInformation(paymentID);
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

    private bool ValidateBank()
    {
        var validCheck = new ValidCheck(txtRoutingNumber.Text.Trim(), txtAccountNumber.Text.Trim(), txtFirstName.Text.Trim() + " " + txtLastName.Text.Trim(), cmbAccountType.Text, ClientSession.SelectedPatientID, 0, ClientSession.SelectedPatientAccountID, ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID);
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
                // Re-Binding the title which being erased during Json Request
                BindPopupDescriptionandTitle();

                // Checking if email was empty or not
                if (txtBankEmail.Visible && !lblBankEmail.Visible && !string.IsNullOrEmpty(txtBankEmail.Text))
                    SaveEmail(txtBankEmail.Text);

                // Validating the Bank Account Information, Is Bank is valid or not 
                if (!ValidateBank())
                {
                    RadWindow.RadAlert("The patient's financial institution was unable to validate the information entered, please verify all fields and resubmit.", 350, 150, "Validation Failure", "", "../Content/Images/warning.png");
                    return;
                }


                var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.SelectedPatientID },
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

                    var flagDupCard = Convert.ToBoolean(row["FlagDupCard"]);
                    if (flagDupCard)
                    {
                        RadWindow.RadAlert("It appears that we already have this payment account on file. If the account was previously deleted, it has been re-activated. You may close the window to add a new payment method and on exit your existing account should be shown. Thank you.", 350, 150, "", "", "../Content/Images/warning.png");
                    }
                    else
                    {
                        RadWindow.RadAlert("Record successfully added.", 350, 150, "", "reloadPage", "../Content/Images/success.png");
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
                // Re-Binding the title which being erased during Json Request
                BindPopupDescriptionandTitle();

                // Checking if email was empty or not
                if (txtBankEmail.Visible && !lblBankEmail.Visible && !string.IsNullOrEmpty(txtBankEmail.Text))
                    SaveEmail(txtBankEmail.Text);

                var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.SelectedPatientID },
                                    { "@PaymentCardID", cmbExistingBanks.SelectedValue },                                    
                                    { "@NameLast", txtLastName.Text.Trim() },
                                    { "@NameFirst", txtFirstName.Text.Trim() },
                                    { "@BankName", txtBankName.Text.Trim() },
                                    { "@City", txtBranchCity.Text.Trim() },
                                    { "@StateTypeID", cmbStates.SelectedValue },
                                    { "@FlagSavingsAccnt", cmbAccountType.SelectedValue },
                                    { "@FlagPrimary", chkBankPrimarySeconday.Checked },
                                    { "@PNRef", hdnBankPNRef.Value },
                                    { "@FlagActive", 1},
                                    { "@UserID", ClientSession.UserID },
                                    { "@IPAddress", ClientSession.IPAddress },
                                };

                SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
                RadWindow.RadAlert("Record successfully updated.", 350, 150, "", "reloadPage", "../Content/Images/success.png");
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
        var fsv = new ValidCard(cardType, txtCardNumber.Text, expiryDate, ClientSession.SelectedPatientID, 0, ClientSession.SelectedPatientAccountID, ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, txtCreditCardFirstName.Text.Trim() + " " + txtCreditCardLastName.Text.Trim(), txtStreet.Text, txtZipCode.Text, txtCVVSecurityID.Text);
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
        if (paymentID > 0)
        {
            cmbExistingCards.SelectedValue = paymentID.ToString();
            cmbExistingCards.Enabled = false;
            GetCardInformation(paymentID);
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
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "FlagCreditOnly", 1 }, { "@UserID", ClientSession.UserID } };
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
        var existingCardName = cardInformation[0]["CardTypeAbbr"].ToString();
        txtCVVSecurityID.Text = existingCardName.Contains("American Express") ? "****" : "***";
    }


    protected void cmbCardType_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        // Changing the validations on change of the Card Type
        SetValidationExpression();

        // Binding the title in order to show the correct title and description
        BindPopupDescriptionandTitle();


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
        txtCardNumber.Focus();
    }


    #endregion

    #region Input Data show Popup

    protected void btnCreditCardSubmit_Click(object sender, EventArgs e)
    {
        try
        {

            // Re-Binding the title which being erased during Json Request
            BindPopupDescriptionandTitle();

            // Checking if email was empty or not
            if (txtCreditEmail.Visible && !lblCreditEmail.Visible && !string.IsNullOrEmpty(txtCreditEmail.Text))
                SaveEmail(txtCreditEmail.Text);

            // Validating the Credit card, is credit card is valid or not
            if (!ValidateCreditCard())
            {
                RadWindow.RadAlert("The patient's financial institution was unable to validate the information entered, please verify all fields and resubmit.", 350, 150, "Validation Failure", "", "../Content/Images/warning.png");
                return;
            }


            var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.SelectedPatientID },
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
                                    { "@ExpYear",  txtYear.Text.Trim()},
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

                var flagDupCard = Convert.ToBoolean(row["FlagDupCard"]);
                if (flagDupCard)
                {
                    RadWindow.RadAlert("It appears that we already have this payment account on file. If the account was previously deleted, it has been re-activated. You may close the window to add a new payment method and on exit your existing account should be shown. Thank you.", 350, 150, "", "", "../Content/Images/warning.png");
                }
                else
                {
                    RadWindow.RadAlert("Record successfully added.", 350, 150, "", "reloadPage", "../Content/Images/success.png");
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

            // Re-Binding the title which being erased during Json Request
            BindPopupDescriptionandTitle();

            // Checking if email was empty or not
            if (txtCreditEmail.Visible && !lblCreditEmail.Visible && !string.IsNullOrEmpty(txtCreditEmail.Text))
                SaveEmail(txtCreditEmail.Text);

            var cmdParams = new Dictionary<string, object>
                                    {
                                        {"@PatientID", ClientSession.SelectedPatientID},
                                        {"@PaymentCardID", cmbExistingCards.SelectedValue},
                                        {"@NameLast", txtCreditCardLastName.Text.Trim() },
                                        {"@NameFirst", txtCreditCardFirstName.Text.Trim() },
                                        {"@Addr1", txtStreet.Text.Trim() },
                                        {"@Addr2", txtAptSuite.Text.Trim() },
                                        {"@City", txtCity.Text.Trim()},
                                        {"@StateTypeID", cmbCreditCardStates.SelectedValue },
                                        {"@Zip", txtZipCode.Text.Trim() },
                                        {"@BankName", txtIssuingBank.Text.Trim()},
                                        {"@BankPhone", txtBankPhone.Text.Trim()},
                                        {"@PNRef", hdnPref.Value }, 
                                        {"@FlagPrimary", chkCreditPrimarySeconday.Checked },
                                        {"@UserID", ClientSession.UserID},
                                        {"@FlagActive", 1},
                                        {"@IPAddress", ClientSession.IPAddress},
                                     };

            SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
            RadWindow.RadAlert("Record successfully updated.", 350, 150, "", "reloadPage", "../Content/Images/success.png");

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
            // Setting up the fields for Bank Account 
            ManageBankAccountPanel();
        }
        else
        {
            // Setting up the fields for CreditCard
            ManageCreditCardPanel();
        }
    }


    private void ManageBankAccountPanel()
    {

        rdBankAccount.Checked = true;
        rdCreditCard.Checked = false;

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

    private void HideShowSections()
    {

        var isShowSwipeandKeyCardOptions = false;
        // This is for Updating the Bank Account
        if (IsBankAccountEditCase())
        {
            ManageBankAccountValidations(false);
            ManagePanels(true);
            InitializeBankAccountPopup(Convert.ToInt32(ClientSession.ObjectID));

            ViewState["PopupTitle"] = "Linked Bank Account Manager";
            ViewState["PopupDescription"] = "Modify Bank Account";

        }
        // This is for Adding the New Bank Account
        else if (ClientSession.ObjectType == ObjectType.ManageBankAccount)
        {
            ManageLinkedBankAccount();
        }

        // This is for updating the credit card
        if (IsCreditCardEditCase())
        {
            ManageCreditCardValidations(false);
            ManageCreditCardSubmitButtons(true);
            InitializeCreditCardPopup(Convert.ToInt32(ClientSession.ObjectID));
            ManagePanels(false);

            ViewState["PopupTitle"] = "Linked Credit Card Manager";
            ViewState["PopupDescription"] = "Modify Credit Card";

        }
        // This is for Adding the new credit card
        else if (ClientSession.ObjectType == ObjectType.ManageCreditCard)
        {
            ManageCreditCardAccount();
            isShowSwipeandKeyCardOptions = true;
        }

        // Displaying the title
        BindPopupDescriptionandTitle();

        // Manging the panels and options
        ManageSwipeandKeyCardPanels(isShowSwipeandKeyCardOptions);
    }

    private void ManageLinkedBankAccount()
    {
        ManageBankAccountValidations(true);
        ManagePanels(true);
        InitializeBankAccountPopup();
        ClearBankPopupFields();

        // Auto Select First value
        cmbAccountType.SelectedIndex = 0;

        ViewState["PopupTitle"] = "Linked Bank Account Manager";
        ViewState["PopupDescription"] = "Add New Bank Account";
    }

    private void ManageCreditCardAccount()
    {
        ManageCreditCardValidations(true);
        ManageCreditCardSubmitButtons(false);
        InitializeCreditCardPopup();
        ClearCreditPopupFields();
        ManagePanels(false);

        ViewState["PopupTitle"] = "Linked Credit Card Manager";
        ViewState["PopupDescription"] = "Add New Credit Card";

    }

    private void BindPopupDescriptionandTitle()
    {
        var title = ViewState["PopupTitle"] == null ? string.Empty : ViewState["PopupTitle"].ToString();
        var popupDescription = ViewState["PopupDescription"] == null ? string.Empty : ViewState["PopupDescription"].ToString();

        PopupTitle = title;
        PopupDescription = popupDescription;
    }

    private void SaveEmail(string email)
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@PracticeID", ClientSession.PracticeID }, { "@Email", email }, { "@UserID", ClientSession.UserID } };
        SqlHelper.ExecuteScalarProcedureParams("web_pr_patient_email_add", cmdParams);
    }

    private void ManageSwipeandKeyCardPanels(bool isShowSwipeandKeyCardOptions, bool isShowKeyCardandSwipeOptions = false)
    {

        if (isShowKeyCardandSwipeOptions)
        {
            rdSwipeCard.Visible = true;
            rdKeyCard.Visible = true;
            rdCardLabel.Visible = true;
        }
        else
        {
            rdSwipeCard.Visible = isShowSwipeandKeyCardOptions;
            rdKeyCard.Visible = isShowSwipeandKeyCardOptions;
            rdCardLabel.Visible = isShowSwipeandKeyCardOptions;
        }


        if (isShowSwipeandKeyCardOptions)
        {
            rdSwipeCard.Checked = true;
            rdKeyCard.Checked = false;

            pnlKeyCard.Visible = false;
            pnlKeyCard.Enabled = false;
            pnlSwipeCard.Visible = true;
            pnlSwipeCard.Enabled = true;

            imgSwipeCard.ImageUrl = "~/content/images/swipe-card-go.jpg";
            txtMagTek.Focus();

        }
        else
        {

            rdSwipeCard.Checked = false;
            rdKeyCard.Checked = true;

            pnlKeyCard.Visible = true;
            pnlKeyCard.Enabled = true;
            pnlSwipeCard.Visible = false;
            pnlSwipeCard.Enabled = false;

        }

        // checking if email is null then asking again as input
        ManageEmailTextboxesandLabels();

    }


    #region Swipe Card

    protected void ManageCardPanels(object sender, EventArgs e)
    {
        if (rdSwipeCard.Checked)
        {
            pnlSwipeCard.Visible = true;
            pnlSwipeCard.Enabled = true;
            pnlKeyCard.Visible = false;
            pnlKeyCard.Enabled = false;
            imgSwipeCard.ImageUrl = "~/content/images/swipe-card-go.jpg";
            txtMagTek.Focus();
        }
        else
        {
            pnlSwipeCard.Visible = false;
            pnlSwipeCard.Enabled = false;
            pnlKeyCard.Visible = true;
            pnlKeyCard.Enabled = true;
        }


        BindPopupDescriptionandTitle();
        ShowPatientInformation();
    }

    private void ManageEmailTextboxesandLabels()
    {
        // Validating the Email if does not exist then need to get input from user
        object email;
        ClientSession.SelectedPatientInformation.TryGetValue("Email", out email);

        if (string.IsNullOrEmpty(email.ToString()))
        {
            txtEmail.Visible = true;
            txtCreditEmail.Visible = true;
            txtBankEmail.Visible = true;
        }
        else
        {
            lblEmail.Visible = true;
            lblCreditEmail.Visible = true;
            lblBankEmail.Visible = true;

            lblEmail.Text = email.ToString();
            lblCreditEmail.Text = email.ToString();
            lblBankEmail.Text = email.ToString();
        }


    }

    protected void btnMagtek_Click(object sender, EventArgs e)
    {
        // Getting Infotmation from the Magtek string
        DisplayValues();
        // Re-binding the title information which being erased during json request
        BindPopupDescriptionandTitle();
    }

    private void DisplayValues()
    {
        // changing the image
        imgSwipeCard.ImageUrl = "~/content/images/swipe-card-stop.jpg";

        // Validating the MagTek
        var cardData = txtMagTek.Text.Split('|');
        if (cardData.Length <= 12 || cardData[0].IndexOf("%B") != 0)
        {
            RadWindow.RadAlert("Please re-swipe, we encountered an error reading the card data.", 350, 150, "", "resetAll", "../Content/Images/warning.png");
            return;
        }


        var fullname = cardData[0].Substring(cardData[0].IndexOf('^') + 1).Substring(0, cardData[0].Substring(cardData[0].IndexOf('^') + 1).IndexOf('^'));
        var lastName = fullname.Substring(0, fullname.IndexOf('/'));
        var firstName = fullname.Substring(fullname.IndexOf('/') + 1, fullname.Length - fullname.IndexOf('/') - 1).Trim();
        var expDate = cardData[0].Substring(cardData[0].IndexOf('=') + 3, 2) + cardData[0].Substring(cardData[0].IndexOf('=') + 1, 2);
        string ccLast4 = txtMagTek.Text.Substring(txtMagTek.Text.IndexOf("^") - 4, 4);
        string expMonth = cardData[0].Substring(cardData[0].IndexOf('=') + 3, 2);
        string expYear = DateTime.Now.Year.ToString().Substring(0, 2) + cardData[0].Substring(cardData[0].IndexOf('=') + 1, 2);

        // Getting card type
        var cardNumber = cardData[0].Substring(cardData[0].IndexOf(';') + 1).Substring(0, cardData[0].Substring(cardData[0].IndexOf(';') + 1).IndexOf("="));
        var cardType = GetCardTypeFromNumber(cardNumber);

        // Getting carriage return
        var carriageReturn = cardData[cardData.Length - 1];

        // Adding expression for validate the CVV Security Id
        rgExpCvvSecurityID.ValidationExpression = "^[0-9]{3}$";
        txtSwipeCvvSecurityID.MaxLength = 3;

        // Setting up the path according to the ID
        if (cardType != null)
        {
            switch ((int)cardType)
            {
                case (int)CreditCardTypeType.Amex:
                    rgExpCvvSecurityID.ValidationExpression = "^[0-9]{4}$";
                    txtSwipeCvvSecurityID.MaxLength = 4;
                    imgcards.ImageUrl = "~/content/images/icon_paymentcard_amex.jpg";
                    break;

                case (int)CreditCardTypeType.MasterCard:
                    imgcards.ImageUrl = "~/content/images/icon_paymentcard_mc.jpg";
                    break;

                case (int)CreditCardTypeType.Visa:
                    imgcards.ImageUrl = "~/content/images/icon_paymentcard_visa.jpg";
                    break;

                case (int)CreditCardTypeType.Discover:
                    imgcards.ImageUrl = "~/content/images/icon_paymentcard_disc.jpg";
                    break;

                case 10:
                case 11:
                    imgcards.ImageUrl = "~/content/images/icon_paymentcard_bank.jpg";
                    break;

                default:
                    imgcards.ImageUrl = "~/content/images/icon_paymentcard_all.jpg";
                    break;

            }
        }
        else
        {
            RadWindow.RadAlert("The card number enterd does not appar to be valid, please verify the information or try adding a different card.", 350, 150, "", "", "../Content/Images/warning.png");
            return;
        }


        // Removing the upper casing
        firstName = firstName.UppercaseFirst();
        lastName = lastName.UppercaseFirst();


        // Saving values for further use
        ViewState["Values"] = new Dictionary<string, object>
                {
                    {"CardNumber", cardNumber},
                    {"CCLast4",ccLast4},
                    {"CardType", (int)cardType},
                    {"LastName", lastName},
                    {"FirstName", firstName},
                    {"ExpMonth", expMonth},
                    {"ExpYear",  expYear},
                    {"ExpDate", expDate}
                };


        // changing the image
        imgSwipeCard.ImageUrl = "~/content/images/swipe-card-ready.jpg";


        // Displaying the values.
        txtFirstName.Text = firstName;
        txtLastName.Text = lastName;
        txtPatientFirstName.Text = firstName;
        txtPatientLastName.Text = lastName;
        lblCardLast4.Text = ccLast4;
        lblExpMonth.Text = expMonth;
        lblExpYear.Text = expYear;

    }

    protected void btnClear_ClearSavedValues(object sender, EventArgs e)
    {
        ViewState["Values"] = null;
        // changing the image
        imgcards.ImageUrl = "~/content/images/icon_paymentcard_none.jpg";
        imgSwipeCard.ImageUrl = "~/content/images/swipe-card-go.jpg";
        txtMagTek.Text = string.Empty;
        lblCardLast4.Text = string.Empty;
        lblExpMonth.Text = string.Empty;
        lblExpYear.Text = string.Empty;
        txtMagTek.Focus();
        BindPopupDescriptionandTitle();
    }

    protected void btnSaveMagtek_Click(object sender, EventArgs args)
    {
        try
        {
            // Re-Binding the title which being erased during Json Request
            BindPopupDescriptionandTitle();

            // Checking if email was empty or not
            if (txtEmail.Visible && !lblEmail.Visible && !string.IsNullOrEmpty(txtEmail.Text))
                SaveEmail(txtEmail.Text);


            var values = ViewState["Values"] as Dictionary<string, object>;

            object FirstName, LastName, CardType, ccLast4, ExpDate, expMonth, expYear;

            values.TryGetValue("CardType", out CardType);
            values.TryGetValue("FirstName", out FirstName);
            values.TryGetValue("LastName", out LastName);
            values.TryGetValue("ExpDate", out ExpDate);
            values.TryGetValue("CCLast4", out ccLast4);
            values.TryGetValue("ExpMonth", out expMonth);
            values.TryGetValue("ExpYear", out expYear);

            // Validating the magtek information
            var fsv = new ValidCard((Int32)CardType, Convert.ToString(ccLast4), Convert.ToString(ExpDate), ClientSession.SelectedPatientID, 0, ClientSession.SelectedPatientAccountID, ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, Convert.ToString(FirstName) + " " + Convert.ToString(LastName), string.Empty, txtZip.Text, txtSwipeCvvSecurityID.Text, txtMagTek.Text);
            if (!fsv.Success) //card was validated.
            {
                RadWindow.RadAlert("The card account enterd was not validated by the issuing bank, please verify the information or try adding a different card.", 350, 150, "", "", "../Content/Images/warning.png");
                return;
            }

            var cmdParams = new Dictionary<string, object>
            {
                { "@PatientID", ClientSession.SelectedPatientID },
                { "@NameLast", Convert.ToString(LastName) },
                { "@NameFirst", Convert.ToString(FirstName)  },
                { "@Addr1", DBNull.Value },
                { "@Addr2", DBNull.Value },
                { "@City", DBNull.Value},
                { "@StateTypeID", DBNull.Value },
                { "@Zip", txtZip.Text },
                { "@PaymentCardTypeID", (Int32)CardType },
                { "@BankName", DBNull.Value },
                { "@BankPhone", DBNull.Value },
                { "@CardLast4", ccLast4 },
                { "@ExpMonth", expMonth },
                { "@ExpYear", expYear },
                { "@PNRef", fsv.PNRef},                                    
                { "@FlagSwiped", 1 },
                { "@UserID", ClientSession.UserID},
                { "@FlagActive", 1},
                { "@FlagPrimary", chkCreditPrimary.Checked ? 1 : (object)DBNull.Value},
                { "@IPAddress", ClientSession.IPAddress},
                { "@TransactionID", fsv.ReturnTransID}
            };


            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_add", cmdParams);
            foreach (DataRow row in reader.Rows)
            {

                var flagDupCard = Convert.ToBoolean(row["FlagDupCard"]);
                if (flagDupCard)
                {
                    RadWindow.RadAlert("It appears that we already have this payment account on file. If the account was previously deleted, it has been re-activated. You may close the window to add a new payment method and on exit your existing account should be shown. Thank you.", 350, 150, "", "", "../Content/Images/warning.png");
                }
                else
                {
                    RadWindow.RadAlert("Record added successfully.", 350, 150, "", "reloadPage", "../Content/Images/success.png");
                }

            }


        }
        catch (Exception)
        {

            throw;
        }
    }

    private static CreditCardTypeType? GetCardTypeFromNumber(string cardNum)
    {
        const string cardRegex = "^(?:(?<Visa>4\\d{3})|(?<MasterCard>5[1-5]\\d{2})|(?<Discover>6011)|(?<DinersClub>(?:3[68]\\d{2})|(?:30[0-5]\\d))|(?<Amex>3[47]\\d{2}))([ -]?)(?(DinersClub)(?:\\d{6}\\1\\d{4})|(?(Amex)(?:\\d{6}\\1\\d{5})|(?:\\d{4}\\1\\d{4}\\1\\d{4})))$";

        //Create new instance of Regex comparer with our
        //credit card regex patter
        var cardTest = new Regex(cardRegex);

        //Compare the supplied card number with the regex
        //pattern and get reference regex named groups
        var gc = cardTest.Match(cardNum).Groups;

        //Compare each card type to the named groups to 
        //determine which card type the number matches
        if (gc[CreditCardTypeType.Amex.ToString()].Success)
        {
            return CreditCardTypeType.Amex;
        }

        if (gc[CreditCardTypeType.MasterCard.ToString()].Success)
        {
            return CreditCardTypeType.MasterCard;
        }

        if (gc[CreditCardTypeType.Visa.ToString()].Success)
        {
            return CreditCardTypeType.Visa;
        }

        if (gc[CreditCardTypeType.Discover.ToString()].Success)
        {
            return CreditCardTypeType.Discover;
        }

        //Card type is not supported by our system, return null
        //(You can modify this code to support more (or less)
        // card types as it pertains to your application)
        return null;
    }

    #endregion

    #region Show Patient Information

    private void ShowPatientInformation()
    {
        var needToShowPatientInformation = Extension.ClientSession.IsUserUnderPatientDirectory;
        if (!needToShowPatientInformation)
            return;

        string firstName, lastName, address, appSuite, city, stateId, zip;
        var info = ClientSession.SelectedPatientInformation;

        if (ClientSession.IsFlagGuardianExists)
        {
            firstName = info["GuardianFirstName"].ToString();
            lastName = info["GuardianFirstName"].ToString();
            address = info["Addr1Sec"].ToString();
            appSuite = info["Addr2Sec"].ToString();
            city = info["CitySec"].ToString();
            stateId = info["StateTypeIDSec"].ToString();
            zip = info["ZipSec"].ToString();
        }
        else
        {
            firstName = ClientSession.PatientFirstName;
            lastName = ClientSession.PatientLastName;
            address = info["Addr1Pri"].ToString();
            appSuite = info["Addr2Pri"].ToString();
            city = info["CityPri"].ToString();
            stateId = info["StateTypeIDPri"].ToString();
            zip = info["ZipPri"].ToString();
        }


        var email = info["Email"].ToString();

        if (rdCreditCard.Checked)
        {
            if (rdSwipeCard.Checked)
            {
                txtPatientFirstName.Text = firstName;
                txtPatientLastName.Text = lastName;
                txtZip.Text = zip;
                txtEmail.Text = email;
            }
            else
            {
                txtCreditCardFirstName.Text = firstName;
                txtCreditCardLastName.Text = lastName;
                txtStreet.Text = address;
                txtAptSuite.Text = appSuite;
                cmbCreditCardStates.SelectedValue = stateId;
                txtCity.Text = city;
                txtCreditEmail.Text = email;
                txtZipCode.Text = zip;
            }
        }
        else
        {
            txtFirstName.Text = firstName;
            txtLastName.Text = lastName;
            txtBankEmail.Text = email;
        }
    }

    private bool IsBankAccountEditCase()
    {
        return ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.ManageBankAccount;
    }

    private bool IsCreditCardEditCase()
    {
        return ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.ManageCreditCard;
    }

    #endregion


}
