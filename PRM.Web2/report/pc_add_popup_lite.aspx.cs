using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;
using System.Text.RegularExpressions;

public partial class pc_add_popup_lite : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                OnPageLoad();
                AutoSelectPatientandStatementDropdown();

                //Displaying Description dropdown
                divDescriptionDropdown.Visible = cmbStatements.SelectedValue == "0";

                txtMagTek.Focus();
            }
            catch (Exception)
            {

                throw;
            }
        }
        hdnValidate.Value = "";
        popupConfirmationPayment.VisibleOnPageLoad = false;
    }

    #region Manage Popup

    private void OnPageLoad()
    {
        // for close the RadWidnow in case of any error
        ClientSession.WasRequestFromPopup = true;

        // Managing Swipe Panel
        rdSwipeCard.Checked = true;
        txtMagTek.Focus();
        imgSwipeCard.ImageUrl = "~/content/images/swipe-card-go.jpg";

        // Getting Email of selected patient
        ManageEmailTextBoxandLables();


        // Binding the Payment and Statement dropdowns
        BindPatients();
        BindStatements();
        BindProviders();
        BindLocations();
        BindGender();
        BindDescriptions();

        // Binding the Patient Panel's Dropdown if Patient is not active
        if (ClientSession.SelectedPatientID == 0)
        {
            pnlPatientInformation.Visible = true;
            // only activating this, if PatientID is 0
            rqdPatient.Enabled = true;
            rqdStatements.Enabled = true;
            // Managing the Patient Panels
            ManagePatientFields();
        }

        if (GetPatientIDOrStatementID(true) == 0)
        {
            // Need to call first time in case when there is no active patient
            ManagePaymentOptions();
        }


    }

    private void AutoSelectPatientandStatementDropdown()
    {
        var patientID = GetPatientIDOrStatementID(true);
        if (patientID <= 0) return;

        var isRequestfromGlobal = Request.Params["IsGlobal"] == "1";

        if (isRequestfromGlobal)
        {
            ClientSession.ObjectID = null;
        }

        // Auto-selecting the patient dropdown
        cmbPatients.ClearSelection();
        cmbPatients.SelectedValue = patientID.ToString();
        cmbPatients.Enabled = isRequestfromGlobal;

        // Binding the statement dropdown
        BindStatements();

        // Auto-selecting the statement and if there is no any statement is session then I am displaying highest one.
        var statementID = GetPatientIDOrStatementID(false);
        if (statementID > 0)
        {
            cmbStatements.SelectedValue = statementID.ToString();
            ManagePatientFields();    // Manage payment Options
        }
        else
        {
            ShowHighestStatement();
        }


        // Displaying the selected statement in Amount field.
        DisplayAmountForSelectedStatement();

        // Displaying Information of patient
        ShowPatientInformation(true);

        // Managing the Payment Options in case when there is an active patient in the memory
        var isPatientHasCards = (bool)ViewState["IsPatientHasCards"];
        ManagePaymentOptions(isPatientHasCards);

    }

    private void BindPatients()
    {

        if (ClientSession.PatientCount <= ClientSession.MaxPatientDropdown)
        {
            var patients = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_list", new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } });

            // Adding New row in datatable
            var newRow = patients.NewRow();
            newRow["PatientID"] = 0;
            newRow["ComboBoxAbbr"] = "Create New Patient";
            patients.Rows.InsertAt(newRow, 0);

            //Binding the Combobox
            cmbPatients.DataSource = patients;
            cmbPatients.DataBind();

        }
        else
        {
            BindCurrentPatientIntoDropdown();
            cmbPatients.AllowCustomText = true;
            cmbPatients.EnableLoadOnDemand = true;
        }

        cmbPatients.SelectedValue = "0";
    }

    private void BindStatements()
    {
        cmbStatements.ClearSelection();

        var selectedPatientId = cmbPatients.SelectedValue == "0" ? "-1" : cmbPatients.SelectedValue;

        var cmdParams = new Dictionary<string, object>
            {
                {"@PatientID", selectedPatientId},
                {"@FlagCurrent", 1},
                {"@FlagBalance", 1},
                {"@UserID", ClientSession.UserID}
            };

        var statements = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);

        // Inserting new row at top.
        var newRow = statements.NewRow();
        newRow["StatementID"] = 0;
        newRow["Balance"] = 0m;
        newRow["ComboBoxAbbr"] = "Create New Statement";
        statements.Rows.InsertAt(newRow, 0);

        // Binding the dropdown
        cmbStatements.DataSource = statements;
        cmbStatements.DataBind();
        cmbStatements.SelectedValue = "0";


        // Saving the statements in viewdata for further use
        var listOfStatementBalance = Enumerable.Select(statements.AsEnumerable(), res => new Tuple<int, decimal>((int)res["StatementID"], (decimal)res["Balance"])).ToList();
        ViewState["Statements"] = listOfStatementBalance;

    }

    private void BindDescriptions()
    {
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_qpdesc_get",
            new Dictionary<string, object>
            {
                { "@PracticeID", ClientSession.PracticeID },
                { "@UserID", ClientSession.UserID}
            });

        foreach (DataRow row in reader.Rows)
        {

            for (var i = 1; i <= 5; i++)
            {

                var description = row["QPDesc" + i].ToString();
                if (!string.IsNullOrEmpty(description))
                {
                    cmbDescription.Items.Add(new RadComboBoxItem { Text = description, Value = description });
                }
            }
            cmbDescription.Items.Add(new RadComboBoxItem { Text = row["QPDesc0"].ToString(), Value = row["QPDesc0"].ToString() });
        }

        cmbDescription.SelectedIndex = 0;
    }

    protected void cmbPatients_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        if (string.IsNullOrEmpty(cmbPatients.SelectedValue))
        {
            cmbPatients.Text = string.Empty;
            cmbPatients.ClearSelection();
            cmbPatients.SelectedValue = ClientSession.SelectedPatientID.ToString();
        }

        BindStatements();
        ManagePatientFields();
        ShowPatientInformation(true);

        // Manage payment Options to validate if patient has card or not 
        var isPatientHasCards = (bool)ViewState["IsPatientHasCards"];
        ManagePaymentOptions(isPatientHasCards);

        // Binding the payment methods
        if (rdCardOnFile.Checked)
            BindPaymentMethod();

        //Managing lables and textboxes according to the patient
        ManageEmailTextBoxandLables();
        //Selecting highest statement
        ShowHighestStatement();
        //Displaying amount for selected statement
        DisplayAmountForSelectedStatement();

        // Displaying Description Dropdown
        divDescriptionDropdown.Visible = cmbStatements.SelectedValue == "0";

        txtMagTek.Focus();
    }

    protected void cmbPatients_ItemsRequested(object sender, RadComboBoxItemsRequestedEventArgs e)
    {
        var query = e.Text;
        if (string.IsNullOrEmpty(query) || query.Length < 3)
            return;

        var cmdParams = new Dictionary<string, object>
        {
            { "@PracticeID", ClientSession.PracticeID },
            { "@LastName", query },
            { "@StatusTypeID", ClientSession.FlagPtSearchActiveDefault ? 1 : (object)DBNull.Value },
        };
        var patients = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_search", cmdParams);

        //Binding the Combobox
        cmbPatients.DataSource = patients;
        cmbPatients.DataBind();

    }

    protected void cmbStatements_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        // Managing the Patient FieldsProject
        ManagePatientFields();

        // Displaying Amount According to the StatementID
        DisplayAmountForSelectedStatement();
        txtMagTek.Focus();

        // Displaying Description Dropdown
        divDescriptionDropdown.Visible = cmbStatements.SelectedValue == "0";

    }

    protected void ManagePaymentModes(object sender, EventArgs e)
    {
        // Adding validation for each payment method
        ManageRequiredFieldsOfTopDropdowns();

        // Managing panels according to payment method
        if (rdSwipeCard.Checked)
        {
            ManageSwipePanel();
        }
        else if (rdSaveCard.Checked)
        {
            pnlSaveCard.Visible = true;
            pnlKeyArea.Visible = false;
            pnlCardOnFile.Visible = false;
            pnlSwipeCard.Visible = false;
            pnlTransaction.Visible = false;
            ManagePatientFields();
            hdnValidate.Value = "1";

        }
        else if (rdKeyCard.Checked)
        {
            pnlKeyArea.Visible = true;
            pnlBankAccount.Visible = false;
            pnlCreditCard.Visible = false;
            pnlSaveCard.Visible = false;
            pnlTransaction.Visible = false;
            pnlCardOnFile.Visible = false;
            pnlSwipeCard.Visible = false;
            rdCreditCard.Checked = true;
            rdBankAccount.Checked = false;
            ManageCreditCardAccount();
            ManagePatientFields();
        }
        else if (rdTransaction.Checked)
        {
            pnlTransaction.Visible = true;
            pnlKeyArea.Visible = false;
            pnlBankAccount.Visible = false;
            pnlCreditCard.Visible = false;
            pnlSaveCard.Visible = false;
            pnlCardOnFile.Visible = false;
            pnlSwipeCard.Visible = false;
            BindTransactionType();
        }
        else
        {
            pnlCardOnFile.Visible = true;
            pnlSaveCard.Visible = false;
            pnlKeyArea.Visible = false;
            pnlSwipeCard.Visible = false;
            pnlTransaction.Visible = false;

            // Hiding the Cards panel
            pnlCreditCardDetails.Visible = false;
            pnlBankAccountDetails.Visible = false;

            // Binding the payment methods 
            BindPaymentMethod();
            cmbPaymentMethods.SelectedIndex = 0;
            ShowBankOrCreditCardInformation();
            ManagePatientFields();
        }

        // Displaying Amount According to the StatementID
        DisplayAmountForSelectedStatement();

        // Displaying the Patient Information
        ShowPatientInformation(false);

        //Managing the email text/labels
        ManageEmailTextBoxandLables();

    }

    private void ManageSwipePanel()
    {
        pnlSwipeCard.Visible = true;
        pnlKeyArea.Visible = false;
        pnlCardOnFile.Visible = false;
        pnlSaveCard.Visible = false;
        pnlTransaction.Visible = false;
        ManagePatientFields();
        hdnValidate.Value = "1";
    }

    #endregion

    #region Swipe Card

    protected void btnMagtek_Click(object sender, EventArgs e)
    {
        DisplayValues();
    }

    private void DisplayValues()
    {
        // changing the image
        imgSwipeCard.ImageUrl = "~/content/images/swipe-card-stop.jpg";

        // Validating the MagTek
        var cardData = txtMagTek.Text.Split('|');
        if (cardData.Length <= 12 || cardData[0].IndexOf("%B") != 0)
        {
            RadWindow.RadAlert("Please re-swipe, we encountered an error reading the card data.", 330, 100, "", "resetAll", "../Content/Images/warning.png");
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
        var cardTypes = GetCardTypes();

        if (!cardTypes.AsEnumerable().Any(x => x["Abbr"].ToString().Contains(cardType.ToString())))
        {
            var message = string.Format("There is no merchant account associated with {0} and it is not supported at this time. Please resubmit a different card type before processing the transaction.",cardType.Value.GetDescription());
            RadWindow.RadAlert(message, 400, 100, "", "resetAll", "../Content/Images/warning.png");
            return;
        }

        // Getting carriage return

        var carriageReturn = cardData[cardData.Length - 1];

        // Setting up the path according to the ID
        if (cardType != null)
        {
            switch ((int)cardType)
            {
                case (int)CreditCardTypeType.Amex:
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
            RadWindow.RadAlert("The card number enterd does not appar to be valid, please verify the information or try adding a different card.", 330, 100, "", "", "../Content/Images/warning.png");
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

        chkCardForFutureUse.Checked = true;
        chkCreditPrimary.Enabled = true;
        chkCreditPrimary.Checked = false;

        if (rdSwipeCard.Checked)
            txtMagTek.Focus();
        else
            txtSaveCardMagtek.Focus();


    }

    protected void btnValidateCreditCard_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        // Validating the MagTek
        var cardData = txtMagTek.Text.Split('|');
        if (cardData.Length <= 12 || cardData[0].IndexOf("%B") != 0)
        {
            RadWindow.RadAlert("Please re-swipe, we encountered an error reading the card data.", 330, 100, "", "", "../Content/Images/warning.png");
            return;
        }

        var values = ViewState["Values"] as Dictionary<string, object>;

        object ccLast4;
        values.TryGetValue("CCLast4", out ccLast4);


        try
        {
            if (Convert.ToDecimal(txtAmount.Text) > 0)
            {
                ClientSession.AmountandDownpayment = Convert.ToDecimal(txtAmount.Text) + "," + "Card Ending in " + ccLast4;
                ClientSession.ObjectType = ObjectType.Payment;
                popupConfirmationPayment.VisibleOnPageLoad = true;
                popupConfirmationPayment.NavigateUrl = "~/report/paymentConfirmation_popup.aspx?q=true";
            }
            else
            {
                RadWindow.RadAlert("Please re-swipe, we encountered an error reading the card data.", 330, 100, "", "", "../Content/Images/warning.png");
            }
            
        }
        catch (Exception)
        {
            throw;
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs args)
    {
        
        // Checking if email was empty or not
        if (txtEmail.Visible && !lblEmail.Visible && !string.IsNullOrEmpty(txtEmail.Text))
            SaveEmail(txtEmail.Text);

        // Creating New Patient and statement
        var isPatientValidated = ValidateandCreatePatientOrStatement();
        if (!isPatientValidated)
        {
            if (!Common.Success)
            {
                RadWindow.RadAlert("The card account enterd was not validated by the issuing bank, please verify the information or try adding a different card.", 330, 100, "", "", "../Content/Images/warning.png");
                return;
            }

            ShowErrorMessage("We identified you are attempting to add a patient which already exists. Please note that the existing patient will be used for this transaction.");
            return;
        }

        var values = ViewState["Values"] as Dictionary<string, object>;

        object FirstName, LastName, CardType, ccLast4, ExpDate, expMonth, expYear;

        values.TryGetValue("CardType", out CardType);
        values.TryGetValue("FirstName", out FirstName);
        values.TryGetValue("LastName", out LastName);
        values.TryGetValue("ExpDate", out ExpDate);
        values.TryGetValue("CCLast4", out ccLast4);
        values.TryGetValue("ExpMonth", out expMonth);
        values.TryGetValue("ExpYear", out expYear);

        //// Validating the magtek information
        //var fsv = new ValidCard((Int32)CardType, Convert.ToString(ccLast4), Convert.ToString(ExpDate), GetPatientIDOrStatementID(true), 0, ClientSession.SelectedPatientAccountID, ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, Convert.ToString(FirstName) + " " + Convert.ToString(LastName), string.Empty, txtZipCode.Text, txtCVVSecurityID.Text, txtMagTek.Text);
        //if (!fsv.Success) //card was validated.
        //{
        //    RadWindow.RadAlert("Card Validation failed.", 330, 100, "", "", "../Content/Images/warning.png");
        //    return;
        //}

        var cmdParams = new Dictionary<string, object>
            {
                { "@PatientID", GetPatientIDOrStatementID(true) },
                { "@NameLast", Convert.ToString(LastName) },
                { "@NameFirst", Convert.ToString(FirstName)  },
                { "@Addr1", DBNull.Value },
                { "@Addr2", DBNull.Value },
                { "@City", DBNull.Value},
                { "@StateTypeID", DBNull.Value },
                { "@Zip", string.Empty },
                { "@PaymentCardTypeID", (Int32)CardType },
                { "@BankName", DBNull.Value },
                { "@BankPhone", DBNull.Value },
                { "@CardLast4", ccLast4 },
                { "@ExpMonth", expMonth },
                { "@ExpYear", expYear },
                { "@PNRef", hdnPref.Value},                                    
                { "@FlagSwiped", 1 },
                { "@UserID", ClientSession.UserID},
                //{ "@FlagActive", chkCardForFutureUse.Checked ? 1 : (object)DBNull.Value},
                { "@FlagActive", chkCardForFutureUse.Checked},
                { "@FlagPrimary", chkCreditPrimary.Checked ? 1 : (object)DBNull.Value},
                { "@IPAddress", ClientSession.IPAddress},
                { "@TransactionID", Common.ReturnTransID}
            };


        var paymentCardID = 0;
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_add", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            paymentCardID = Convert.ToInt32(row["PaymentCardID"]);
        }

        //if (Convert.ToInt32(value) < 0)
        //{
        //    RadWindow.RadAlert("It appears that we already have this payment account on file. If the account was previously deleted, it has been re-activated. You may close the window to add a new payment method and on exit your existing account should be shown. Thank you.", 350, 150, "", "", "../Content/Images/warning.png");
        //    return;
        //}

        ProcessPayment(Convert.ToDecimal(txtAmount.Text), paymentCardID); //Processing Payment with selected Payment Method.
        if (Common.Success)
        {
            //Adding Transaction ID for receipt
            ClientSession.ObjectID = Common.ReturnTransID;
            ClientSession.ObjectType = ObjectType.PaymentReceipt;

            // Managing print options
            ManageReceiptPopups();

        }
        else
        {
            RadWindow.RadAlert(GetFailureMessage(), 400, 150, "", "refreshPage");
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

    #region Key Card

    #region Bank Account

    private void BindAccountType()
    {
        var accountypes = new ArrayList
            {
                new {Text = AccountType.Checking.ToString(), Value = ((int) AccountType.Checking).ToString()},
                new {Text = AccountType.Savings.ToString(), Value = ((int) AccountType.Savings).ToString()}
            };

        cmbAccountType.DataSource = accountypes;
        cmbAccountType.DataBind();
        cmbAccountType.SelectedIndex = 0;
    }
    private void BindStates()
    {
        var cmdParams = new Dictionary<string, object>();
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", cmdParams);

        cmbBankStates.DataSource = states;
        cmbBankStates.DataBind();
    }

    protected void rdBankAccount_CheckedChanged(object sender, EventArgs e)
    {
        // Setting up the Credit Bank Account Panel
        ManageLinkedBankAccount();

        // Auto selecting first value of Account Type
        cmbAccountType.SelectedIndex = 0;

        // Adding validation of Amount
        cmpValidatorAmount.ValidationGroup = "BankAccountValidationGroup";

        ManageRequiredFieldsOfTopDropdowns();
        ManagePatientFields();
        ShowPatientInformation(false);
    }

    protected void txtRoutingNumber_OnTextChanged(object sender, EventArgs e)
    {

        if (string.IsNullOrEmpty(txtRoutingNumber.Text))
        {
            txtBankName.Text = string.Empty;
            cmbBankStates.Text = string.Empty;
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
            ViewState["BankCity"] = row["City"].ToString();
            cmbBankStates.SelectedValue = row["StateTypeID"].ToString();
        }
    }

    private void ManageLinkedBankAccount()
    {
        ManageBankAccountValidations(true);
        ManagePanels(true);
        ClearBankPopupFields();
        btnSubmit.Visible = true;
    }

    private void ClearBankPopupFields()
    {
        txtLastName.Text = string.Empty;
        txtFirstName.Text = string.Empty;
        txtBankName.Text = string.Empty;
        cmbBankStates.ClearSelection();
        cmbAccountType.ClearSelection();
        txtRoutingNumber.Text = string.Empty;
        txtAccountNumber.Text = string.Empty;
        chkBankPrimarySeconday.Checked = false;
    }


    private void ManageBankAccountValidations(bool isEnable)
    {
        cmbAccountType.Enabled = isEnable;
        txtRoutingNumber.Enabled = isEnable;
        txtAccountNumber.Enabled = isEnable;
        RgrExpnAccountNumber.Enabled = isEnable;
    }

    private void ManageBankAccountPanel()
    {
        pnlCreditCard.Visible = false;
        pnlBankAccount.Visible = true;
    }

    private bool ValidateBank()
    {
        var validCheck = new ValidCheck(txtRoutingNumber.Text.Trim(), txtAccountNumber.Text.Trim(), txtFirstName.Text.Trim() + " " + txtLastName.Text.Trim(), cmbAccountType.Text, GetPatientIDOrStatementID(true), 0, GetAccountIDOfSelectedPatient(), ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID);
        if (validCheck.Success)
        {
            hdnBankPNRef.Value = validCheck.PNRef;
        }

        Common.Success = validCheck.Success;
        return validCheck.Success;
    }

    protected void btnBankSubmit_AssignValues(object sender, EventArgs e)
    {
        var accountNumber = txtAccountNumber.Text;
        AssignValues(txtBankAccountAmount.Text, cmbAccountType.SelectedItem.Text + " ending in " + accountNumber.Substring(accountNumber.Length - 4, 4));
    }

    protected void btnSubmitBank_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                // Checking if email was empty or not
                if (!string.IsNullOrEmpty(txtBankAccountEmail.Text))
                    SaveEmail(txtBankAccountEmail.Text);


                // Creating New Patient and statement
                var isPatientValidated = ValidateandCreatePatientOrStatement();
                if (!isPatientValidated)
                {

                    if (!Common.Success)
                    {
                        RadWindow.RadAlert("The patient's financial institution was unable to validate the information entered, please verify all fields and resubmit.", 350, 150, "Validation Failure", "", "../Content/Images/warning.png");
                        return;
                    }

                    ShowErrorMessage("We identified you are attempting to add a patient which already exists. Please note that the existing patient will be used for this transaction.");
                    return;
                }

                var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", GetPatientIDOrStatementID(true) },
                                    { "@NameLast", txtLastName.Text.Trim() },
                                    { "@NameFirst", txtFirstName.Text.Trim() },
                                    //{ "@Zip", txtBankAccountZipCode.Text.Trim()},
                                    { "@BankName", txtBankName.Text.Trim() },
                                    { "@City", ViewState["BankCity"] },
                                    { "@StateTypeID", cmbBankStates.SelectedValue },
                                    { "@CheckRouting", txtRoutingNumber.Text},
                                    { "@FlagSavingsAccnt", cmbAccountType.SelectedValue },
                                    { "@CardLast4", txtAccountNumber.Text.Trim().Substring(txtAccountNumber.Text.Trim().Length-4) },
                                    { "@FlagPrimary", chkBankPrimarySeconday.Checked },
                                    { "@PNRef", hdnBankPNRef.Value },
                                    { "@UserID", ClientSession.UserID },
                                    { "@IPAddress", ClientSession.IPAddress },
                                };

                if (chkBankFutureUse.Checked)
                    cmdParams.Add("@FlagActive", 1);

                var paymentCardID = 0;
                var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_add", cmdParams);
                foreach (DataRow row in reader.Rows)
                {
                    paymentCardID = Convert.ToInt32(row["PaymentCardID"]);
                }

                ProcessPayment(Convert.ToDecimal(txtBankAccountAmount.Text), paymentCardID); //Processing Payment with selected Payment Method.
                // Will handle threee cases when Payment was successfull, when not successfull and when successfull but email sending failed

                if (Common.Success)
                {
                    ClientSession.ObjectID = Common.ReturnTransID;
                    ClientSession.ObjectType = ObjectType.PaymentReceipt;
                    ManageReceiptPopups();
                }
                else
                {
                    RadWindow.RadAlert(GetFailureMessage(), 400, 150, "", "", "../Content/Images/warning.png");
                }

            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    #endregion

    #region Credit Card


    private DataTable GetCardTypes()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } };
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_cardtype_list", cmdParams);

    }

    protected void rdCreditCard_CheckedChanged(object sender, EventArgs e)
    {
        // Setting up the Credit Card Panel
        ManageCreditCardAccount();

        //Adding validation of Amount
        cmpValidatorAmount.ValidationGroup = "CreditCardValidationGroup";

        ManageRequiredFieldsOfTopDropdowns();
        ManagePatientFields();
        ShowPatientInformation(false);
    }

    protected void cmbCardType_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        // Changing the validations on change of the Card Type
        SetValidationExpression();
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
            rgExpCvvSecurityID.ValidationExpression = "^[0-9]{4}$";
        }
        else
        {
            txtCardNumber.Mask = "####-####-####-####";
            regexpCardNumber.ValidationExpression = @"\d{4}\-\d{4}\-\d{4}\-\d{4}";
            txtCVVSecurityID.MaxLength = 3;
            rgExpCvvSecurityID.ValidationExpression = "^[0-9]{3}$";

        }

        txtCVVSecurityID.Text = string.Empty;
        txtCardNumber.Focus();
    }

    private void ManageCreditCardAccount()
    {
        ManageCreditCardValidations(true);
        ManageCreditCardSubmitButtons(false);
        InitializeCreditCardPopup();
        ClearCreditPopupFields();
        ManagePanels(false);
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
            rglExprrCVVSecurityID.Enabled = true;
            rqdCardNumber.Enabled = true;
        }
        else
        {
            txtCardNumber.Visible = false;
            rglExprrCVVSecurityID.Enabled = false;
            rqdCardNumber.Enabled = false;
        }
    }

    private void ClearCreditPopupFields()
    {
        txtCreditCardLastName.Text = string.Empty;
        txtCreditCardFirstName.Text = string.Empty;
        //txtStreet.Text = string.Empty;
        //txtAptSuite.Text = string.Empty;
        //txtCity.Text = string.Empty;
        //cmbCreditCardStates.ClearSelection();
        txtZipCode.Text = string.Empty;
        chkCreditPrimarySeconday.Checked = false;
        cmbCardType.ClearSelection();
        //txtIssuingBank.Text = string.Empty;
        //txtBankPhone.Text = string.Empty;
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
        }
        else
        {
            btnCreditCardSubmit.Visible = true;
            btnCreditCardSubmit.Enabled = true;
        }
    }

    private void InitializeCreditCardPopup()
    {

        //Get Card Types
        cmbCardType.ClearSelection();
        cmbCardType.DataSource = GetCardTypes();
        cmbCardType.DataBind();

        //Get States
        BindCreditCardStates();
        cmbCardType.Enabled = true;

    }

    private void BindCreditCardStates()
    {
        var cmdParams = new Dictionary<string, object>();
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", cmdParams);
        //cmbCreditCardStates.DataSource = states;
        //cmbCreditCardStates.DataBind();
    }

    protected void btnCreditCardSubmit_AssignVaues(object sender, EventArgs e)
    {
        var cardNumber = txtCardNumber.Text;
        AssignValues(txtCreditCardAmount.Text, cmbCardType.SelectedItem.Text + " ending in " + cardNumber.Substring(cardNumber.Length - 4, 4));
    }

    protected void btnCreditCardSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            // Checking if email was empty or not
            if (!string.IsNullOrEmpty(txtCardEmail.Text))
                SaveEmail(txtCardEmail.Text);


            // Creating New Patient and statement
            var isPatientValidated = ValidateandCreatePatientOrStatement();
            if (!isPatientValidated)
            {
                if (!Common.Success)
                {
                    var message = "The patient's financial institution was unable to validate the information entered, please verify all fields and resubmit.".ToApostropheStringIfAny();
                    RadWindow.RadAlert(message, 350, 150, "Validation Failure", "", "../Content/Images/warning.png");
                    return;
                }

                ShowErrorMessage("We identified you are attempting to add a patient which already exists. Please note that the existing patient will be used for this transaction.");
                return;
            }


            var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", GetPatientIDOrStatementID(true) },
                                    { "@NameLast", txtCreditCardLastName.Text.Trim() },
                                    { "@NameFirst", txtCreditCardFirstName.Text.Trim() },
                                    { "@Zip", txtCreditCardZipCode.Text.Trim() },
                                    { "@PaymentCardTypeID", cmbCardType.SelectedValue },
                                    { "@CardLast4", txtCardNumber.Text.Trim().Substring( txtCardNumber.Text.Trim().Length-4) },
                                    { "@ExpMonth", txtMonth.Text.Trim() },
                                    { "@ExpYear", txtYear.Text.Trim() },
                                    { "@PNRef", hdnPref.Value },                                    
                                    { "@FlagCommercialCard", rdPersonal.Checked ? "0" : "1"},
                                    { "@FlagPrimary", chkCreditPrimarySeconday.Checked },
                                    { "@FlagActive", chkCreditFutureUse.Checked },
                                    { "@UserID", ClientSession.UserID},
                                    { "@IPAddress", ClientSession.IPAddress},
                                 };

            //if (chkCreditFutureUse.Checked)
            //    cmdParams.Add("@FlagActive", 1);

            var paymentCardID = 0;
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_add", cmdParams);
            foreach (DataRow row in reader.Rows)
            {
                paymentCardID = Convert.ToInt32(row["PaymentCardID"]);
            }

            //if (Convert.ToInt32(paymentCardID) == -1)
            //{
            //    RadWindow.RadAlert("It appears that we already have this payment account on file. If the account was previously deleted, it has been re-activated. You may close the window to add a new payment method and on exit your existing account should be shown. Thank you.", 350, 150, "", "", "../Content/Images/warning.png");
            //}
            //else
            //{

            //}

            ProcessPayment(Convert.ToDecimal(txtCreditCardAmount.Text), paymentCardID); //Processing Payment with selected Payment Method.

            if (Common.Success)
            {
                ClientSession.ObjectID = Common.ReturnTransID;
                ClientSession.ObjectType = ObjectType.PaymentReceipt;
                ManageReceiptPopups();
            }
            else
            {
                RadWindow.RadAlert(GetFailureMessage(), 400, 150, "", "", "../Content/Images/warning.png");
            }

        }
        catch (Exception ex)
        {
            RadWindow.RadAlert(ex.Message, 400, 150, "", "", "../Content/Images/warning.png");
            throw;
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

    #endregion

    #region Card On File

    private void GetBankInformation()
    {
        var bankInformation = ClientSession.Object.Select("PaymentCardID=" + cmbPaymentMethods.SelectedValue);
        lblBALastName.Text = bankInformation[0]["NameLast"].ToString();
        lblBAFirstName.Text = bankInformation[0]["NameFirst"].ToString();
        lblBABankName.Text = bankInformation[0]["BankName"].ToString();
        lblBABrachCity.Text = bankInformation[0]["City"].ToString();
        lblBABankState.Text = bankInformation[0]["StateTypeAbbr"].ToString();
        lblBAAccountType.Text = bankInformation[0]["CardTypeAbbr"].ToString();
        lblBARountingNumber.Text = bankInformation[0]["CheckRouting"].ToString();
        lblBAAccountNumber.Text = bankInformation[0]["CardNumberAbbr"].ToString();
        lblBAPrimaryCard.Text = Convert.ToBoolean(bankInformation[0]["FlagPrimary"]) ? "Yes" : "No";

    }

    private void GetCardInformation()
    {

        var selectedPaymentMethod = ClientSession.Object.Select("PaymentCardID=" + cmbPaymentMethods.SelectedValue)[0];

        lblCCFirstName.Text = selectedPaymentMethod["NameFirst"].ToString();
        lblCCLastName.Text = selectedPaymentMethod["NameLast"].ToString();
        lblCCStreet.Text = selectedPaymentMethod["Address1"].ToString();
        lblCCAptSuite.Text = selectedPaymentMethod["Address2"].ToString();
        lblCCCity.Text = selectedPaymentMethod["City"].ToString();
        lblCCState.Text = selectedPaymentMethod["StateTypeAbbr"].ToString();
        lblCCZipCode.Text = selectedPaymentMethod["Zip"].ToString();

        lblCCCardType.Text = selectedPaymentMethod["CardTypeAbbr"].ToString();
        lblCCIssuingBank.Text = selectedPaymentMethod["BankName"].ToString();
        lblCCBankPhone.Text = selectedPaymentMethod["BankPhone"].ToString();
        lblCCCardNumber.Text = selectedPaymentMethod["CardNumberAbbr"].ToString();
        lblCCExpiration.Text = selectedPaymentMethod["Expiration"].ToString();
        lblCCCVVSecurityID.Text = selectedPaymentMethod["CardTypeAbbr"].ToString().Contains("American Express") ? "****" : "***";

        var cardClass = Convert.ToInt32(selectedPaymentMethod["FlagCommercialCard"]);
        lblCCCardClass.Text = cardClass == (int)CardClass.Personal ? CardClass.Personal.ToString() : CardClass.Corporate.ToString();

    }


    protected void cmbPaymentMethods_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        ShowBankOrCreditCardInformation();
    }

    private void ShowBankOrCreditCardInformation()
    {
        var selectedPaymentMethod = ClientSession.Object.Select("PaymentCardID=" + cmbPaymentMethods.SelectedValue)[0];
        if ((Int32)selectedPaymentMethod["FSPTypeID"] == (int)TransactionType.CreditSale)
        {
            pnlCreditCardDetails.Visible = true;
            pnlBankAccountDetails.Visible = false;
            GetCardInformation();
        }
        else
        {
            pnlCreditCardDetails.Visible = false;
            pnlBankAccountDetails.Visible = true;
            GetBankInformation();
        }
    }


    protected void btnAssignValue_OnClick(object sender, EventArgs e)
    {
        AssignValues(txtCardOnFileAmount.Text, cmbPaymentMethods.SelectedItem.Text);
    }

    protected void btnProcessCard_Click(object sender, EventArgs e)
    {

        // Checking if email was empty or not
        if (txtCardOnFileEmail.Visible && !lblCardOnFileEmail.Visible && !string.IsNullOrEmpty(txtCardOnFileEmail.Text))
            SaveEmail(txtCardOnFileEmail.Text);


        var amount = Convert.ToDecimal(txtCardOnFileAmount.Text);
        if (amount <= 0)
            return;

        // Creating the Statement if needed
        var isPatientValidated = ValidateandCreatePatientOrStatement();
        if (!isPatientValidated)
        {
            ShowErrorMessage("We identified you are attempting to add a patient which already exists. Please note that the existing patient will be used for this transaction.");
            return;
        }

        // Processing the payments 
        ProcessPayment(amount, Convert.ToInt32(cmbPaymentMethods.SelectedValue));

        if (Common.Success)
        {
            ClientSession.ObjectID = Common.ReturnTransID;
            ClientSession.ObjectType = ObjectType.PaymentReceipt;

            // Managing print options
            ManageReceiptPopups();

        }
        else
        {
            RadWindow.RadAlert(GetFailureMessage(), 400, 150, "", "", "../Content/Images/warning.png");
        }

        
    }


    #endregion

    #region Other Transaction
    private void BindTransactionType()
    {
        var cmdParams = new Dictionary<string, object> { { "FlagPayAction", 1 } };

        var transactions = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transtype_list", cmdParams);
        ClientSession.Object = transactions;
        cmbTransactionType.DataSource = transactions;
        cmbTransactionType.DataBind();

    }

    protected void cmbTransactionType_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        // Auto populate the message field.
        var serviceMessage = ClientSession.Object.Select("TransactionTypeID=" + cmbTransactionType.SelectedValue);
        txtMessage.Text = serviceMessage[0]["ServiceMsg"].ToString();
    }

    protected void btnTransaction_Click(object sender, EventArgs e)
    {
        try
        {
            // Checking if email was empty or not
            if (!string.IsNullOrEmpty(txtTransactionEmail.Text))
                SaveEmail(txtTransactionEmail.Text);

            ValidateandCreatePatientOrStatement();

            var cmdParams = new Dictionary<string, object>()
                                {
                                    { "@StatementID", GetPatientIDOrStatementID(false)},
                                    { "@PatientID", GetPatientIDOrStatementID(true) },
                                    { "@AccountID", GetAccountIDOfSelectedPatient()},
                                    { "@TransactionTypeID", cmbTransactionType.SelectedValue },
                                    { "@Amount", txtTransactionAmount.Text },
                                    { "@FSPMessage", txtMessage.Text.Trim() },
                                    { "@Notes", txtTransactionNotes.Text.Trim() },
                                    { "@UserID", ClientSession.UserID },
                                    { "@IPAddress", ClientSession.IPAddress },
                                };

            var transactionID = SqlHelper.ExecuteScalarProcedureParams("web_pr_transaction_add", cmdParams);
            Common.ReturnTransID = (Int32)transactionID;
            var errorMessage = SendEmail();

            var bouncedEmailMessage = string.IsNullOrEmpty(errorMessage) ? "" : "But " + errorMessage;
            RadWindow.RadAlert("This transaction has been saved." + bouncedEmailMessage, 330, 100, "", "reloadPage", "../Content/Images/success.png");

        }
        catch (Exception)
        {
            throw;
        }
    }

    #endregion

    #region Common Functions

    private void ManagePatientFields()
    {
        var pateintID = Convert.ToInt32(cmbPatients.SelectedValue);
        var statementID = Convert.ToInt32(cmbStatements.SelectedValue);

        var isTrue = pateintID == 0 && statementID == 0; ;

        if (rdSwipeCard.Checked)
        {
            pnlPatientInformation.Visible = isTrue;
            pnlPatientInformation.Enabled = isTrue;
        }

        if (rdKeyCard.Checked)
        {
            if (rdCreditCard.Checked)
            {
                pnlCreditPateint.Visible = isTrue;
                pnlCreditPateint.Enabled = isTrue;
            }
            else
            {
                pnlBankAccountPatient.Visible = isTrue;
                pnlBankAccountPatient.Enabled = isTrue;
            }
        }

    }

    private void BindLocations()
    {
        var cmdParams = new Dictionary<string, object> {
        {"@PracticeID", ClientSession.PracticeID}, };
        var locations = SqlHelper.ExecuteDataTableProcedureParams("web_pr_location_list", cmdParams);

        // Binding Location for Swipe
        cmbLocations.DataSource = locations;
        cmbLocations.DataBind();

        // Binding Location for Credit Card
        cmbCreditLocations.DataSource = locations;
        cmbCreditLocations.DataBind();

        // Binding Location for Credit Card
        cmbBankLocations.DataSource = locations;
        cmbBankLocations.DataBind();


        if (locations.Rows.Count == 1)
        {
            cmbLocations.SelectedIndex = 0;
            cmbCreditLocations.SelectedIndex = 0;
            cmbBankLocations.SelectedIndex = 0;
        }
        else
        {
            cmbLocations.SelectedValue = ClientSession.DefaultLocationID.ToString();
            cmbCreditLocations.SelectedValue = ClientSession.DefaultLocationID.ToString();
            cmbBankLocations.SelectedValue = ClientSession.DefaultLocationID.ToString();
        }

    }

    private void BindProviders()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } };
        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);

        // Binding Provider for Swipe
        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();

        // Binding Provider for Credit Card
        cmbCreditProviders.DataSource = providers;
        cmbCreditProviders.DataBind();

        // Binding Provider for Credit Card
        cmbBankProviders.DataSource = providers;
        cmbBankProviders.DataBind();


        if (providers.Rows.Count == 1)
        {
            cmbProviders.SelectedIndex = 0;
            cmbCreditProviders.SelectedIndex = 0;
            cmbBankProviders.SelectedIndex = 0;
        }
        else
        {
            cmbProviders.SelectedValue = ClientSession.DefaultProviderID.ToString();
            cmbCreditProviders.SelectedValue = ClientSession.DefaultProviderID.ToString();
            cmbBankProviders.SelectedValue = ClientSession.DefaultProviderID.ToString();
        }

    }

    private void BindGender()
    {
        var gender = new ArrayList { 
                                     new { Text = Gender.Male.ToString(), Value = ((int)Gender.Male).ToString() },
                                     new { Text = Gender.Female.ToString(), Value = ((int)Gender.Female).ToString() } 
                                   };

        // Binding gender for Swipe
        cmbGender.DataSource = gender;
        cmbGender.DataBind();

        // Binding gender for Credit Card
        cmbCreditGender.DataSource = gender;
        cmbCreditGender.DataBind();

        // Binding gender for Bank Account
        cmbBankGender.DataSource = gender;
        cmbBankGender.DataBind();

    }

    private DataTable GetPaymentMethods(Int32 paymentCardID = 0)
    {
        var param = paymentCardID > 0 ? "@PaymentCardID" : "@PatientID";
        var value = paymentCardID > 0 ? paymentCardID : GetPatientIDOrStatementID(true);

        var cmdParams = new Dictionary<string, object> { { param, value }, { "@UserID", ClientSession.UserID } };
        var paymentMethods = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        return paymentMethods;
    }

    private void ProcessPayment(decimal amount, Int32 paymentCardID)
    {
        var paymentMethods = GetPaymentMethods(paymentCardID);
        var selectedPaymentMethod = paymentMethods.Select("PaymentCardID=" + paymentCardID);
        var FSPTypeID = Convert.ToInt32(selectedPaymentMethod[0]["FSPTypeID"]);
        var PNRef = selectedPaymentMethod[0]["PNRef"].ToString();
        //FSPTypeID is returned as TransactionTypeID from SQL which matches the enum here to associate the FSP method


        switch (FSPTypeID)
        {
            case (int)ProcessCheckCreditDebit.ProcessCreditSale:
                //hardeep update 0 with statementid, update ipAddress
                var processCreditSale = new ProcessCreditSale(amount.ToString(""), PNRef, GetPatientIDOrStatementID(true), paymentCardID, GetPatientIDOrStatementID(false), GetAccountIDOfSelectedPatient(), ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, null, (int)SourceType.PatientPortalWeb, 0, string.Empty, null, null);
                Common.FSPTypeID = (int)ProcessCheckCreditDebit.ProcessCreditSale;
                Common.Success = processCreditSale.Success;
                Common.FSPStatusID = processCreditSale.FSPStatusID;
                Common.FSPMessage = processCreditSale.FSPMessage;
                Common.FSPPNRef = processCreditSale.FS_PNRef;
                Common.FSPAuthRef = processCreditSale.FSPAuthRef;
                Common.ReturnTransID = processCreditSale.ReturnTransID;
                break;
            case (int)ProcessCheckCreditDebit.ProcessDebitSale:

                break;
            case (int)ProcessCheckCreditDebit.ProcessCheckSale:
                //hardeep update 0 with statementid, update ipAddress
                var processCheckSale = new ProcessCheckSale(amount.ToString(""), PNRef, GetPatientIDOrStatementID(true), Convert.ToInt32(paymentCardID), GetPatientIDOrStatementID(false), GetAccountIDOfSelectedPatient(), ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, null, (int)SourceType.PatientPortalWeb, 0, string.Empty, null, null);
                Common.FSPTypeID = (int)ProcessCheckCreditDebit.ProcessCheckSale;
                Common.Success = processCheckSale.Success;
                Common.FSPStatusID = processCheckSale.FSPStatusID;
                Common.FSPMessage = processCheckSale.FSPMessage;
                Common.FSPPNRef = processCheckSale.FS_PNRef;
                Common.FSPAuthRef = null;
                Common.ReturnTransID = processCheckSale.ReturnTransID;
                break;
        }


        // Checking if payment was successfull or not
        if (Convert.ToInt32(cmbStatements.SelectedValue) == 0 && !Common.Success)
        {
            var cmdParams = new Dictionary<string, object>
            {
                {"@UserID", ClientSession.UserID},
                {"@PatientID", GetPatientIDOrStatementID(true)},
                {"@StatementID", GetPatientIDOrStatementID(false)},
                {"@Amount", amount},
                {"@FlagRevert", 1},
            };

            SqlHelper.ExecuteScalarProcedureParams("web_pr_statement_quick_add", cmdParams);
        }

        ViewState["PatientID"] = null;
        ViewState["StatementID"] = null;
        ViewState["PaymentCardID"] = null;

    }

    private string SendEmail()
    {
        var emailcode = EmailServices.SendPaymentReceiptbyID(Common.ReturnTransID, ClientSession.UserID);
        if (emailcode == (int)EmailCode.Succcess) return string.Empty;

        string message;
        switch (emailcode)
        {
            case (int)EmailCode.BouncedMail:
                message = "Please Note: An email receipt was attempted but the address was returned as undeliverable. Please update the patient email on file.";
                break;
            case (int)EmailCode.EmptyEmail:
                return string.Empty;
            case (int)EmailCode.InvalidEmailAddress:
                message = "Please Note: An email receipt was attempted but the address does not appear to be valid. Please update the patient email on file.";
                break;
            default:
                message = "Please Note: An email receipt was attempted but but a delivery error occurred. Support has been notified. Do not re-attempt this transaction.";
                break;
        }
        //RadWindow.RadAlert(message, 400, 150, "", "reloadPage");
        return message;
    }

    private void AssignValues(string amount, string card)
    {
        ClientSession.AmountandDownpayment = Convert.ToDecimal(amount) + "," + card;
        ClientSession.ObjectType = ObjectType.Payment;
        popupConfirmationPayment.VisibleOnPageLoad = true;
    }

    private void SaveEmail(string email)
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", GetPatientIDOrStatementID(true) }, { "@PracticeID", ClientSession.PracticeID }, { "@Email", email }, { "@UserID", ClientSession.UserID } };
        SqlHelper.ExecuteScalarProcedureParams("web_pr_patient_email_add", cmdParams);
    }

    private Int32 GetPatientIDOrStatementID(bool isPatientID)
    {

        var newPatientID = Convert.ToInt32(ViewState["PatientID"]);

        var patientID = Convert.ToInt32(cmbPatients.SelectedValue) > 0 ? Convert.ToInt32(cmbPatients.SelectedValue)
                                                                       : newPatientID > 0 ? newPatientID
                                                                       : ClientSession.SelectedPatientID;




        var statementID = (Convert.ToInt32(cmbStatements.SelectedValue) > 0 ? cmbStatements.SelectedValue : ViewState["StatementID"] ?? ClientSession.ObjectID);

        return isPatientID ? patientID : Convert.ToInt32(statementID);
    }

    private void ManagePaymentOptions(bool isPatientHasCards = false)
    {
        //Managing Payment options(hiding/showing)

        var isRequestfromGlobal = Request.Params["IsGlobal"] == "1";
        bool isEnableOption;
        rdSwipeCard.Visible = true;
        rdKeyCard.Visible = true;

        if (!isRequestfromGlobal)
        {
            isEnableOption = ClientSession.SelectedPatientID > 0 ? ClientSession.IsPatientHasCard : isPatientHasCards;
        }
        else
        {
            isEnableOption = isPatientHasCards;
        }

        rdCardOnFile.Visible = isEnableOption && Convert.ToInt32(cmbPatients.SelectedValue) > 0;

        var patientID = Convert.ToInt32(cmbPatients.SelectedValue);
        if (patientID == 0)
        {
            rdTransaction.Visible = false;
            rdTransaction.Checked = false;
            rdKeyCard.Checked = false;
            rdCardOnFile.Checked = false;
            rdSwipeCard.Checked = true;
            ManageSwipePanel();
            // Will remove any selected values
            ShowPatientInformation(false);


        }
        else
        {
            rdTransaction.Visible = true;
        }


        //var values = ClientSession.ObjectValue as Dictionary<string, bool>;
        //if (values != null)
        //{
        //    bool isHide;
        //    values.TryGetValue("CardOnFile", out isHide);

        //    if (isHide)
        //        rdCardOnFile.Visible = false;

        //    ClientSession.ObjectValue = null;
        //}

        if (rdCardOnFile.Checked && rdCardOnFile.Visible == false)
        {
            rdSwipeCard.Checked = true;
            rdCardOnFile.Checked = false;
            ManageSwipePanel();
        }

    }

    private void ManageRequiredFieldsOfTopDropdowns()
    {
        if (ClientSession.SelectedPatientID <= 0)
            ManageTopDropdownRequiredFields();
    }

    private void ManageTopDropdownRequiredFields()
    {
        // Assigning the validation group according the payment method
        var validationGroup = rdSwipeCard.Checked
                                  ? "SwipeCardValidationGroup"
                                  : rdKeyCard.Checked
                                  ? (rdCreditCard.Checked ? "CreditCardValidationGroup" : "BankAccountValidationGroup")
                                  : rdCardOnFile.Checked ? "CardOnFileValidationGroup" : rdSaveCard.Checked ? "SaveCardValidationGroup"
                                  : rdTransaction.Checked ? "Transactions" : string.Empty;

        rqdStatements.ValidationGroup = validationGroup;
        rqdPatient.ValidationGroup = validationGroup;
        cstmValidatorDescription.ValidationGroup = validationGroup;
    }

    private bool ValidateandCreatePatientOrStatement()
    {
        // Creating new patient and statement

        var patientID = 0;
        var statementID = 0;

        Dictionary<string, object> cmdParams;

        var amount = rdSwipeCard.Checked ? txtAmount.Text : rdKeyCard.Checked ? (rdCreditCard.Checked ? txtCreditCardAmount.Text : txtBankAccountAmount.Text) : rdCardOnFile.Checked ? txtCardOnFileAmount.Text : rdTransaction.Checked ? txtTransactionAmount.Text : string.Empty;

        if (Convert.ToInt32(cmbPatients.SelectedValue) == 0)
        {

            string mrn, firstName, lastName, dateOfBirth, patientSSN, patientSSNEnc, homePhone, locationID, providerID, gender, email, zipCode;


            if (rdSwipeCard.Checked)
            {
                mrn = txtMRN.Text.Trim();
                firstName = txtPatientFirstName.Text.Trim();
                lastName = txtPatientLastName.Text.Trim();
                dateOfBirth = dtDateofBirth.SelectedDate.ToString();
                patientSSN = txtSocialSecurity.Text;
                patientSSNEnc = patientSSN.Encrypt();
                homePhone = txtHomePhone.Text.Trim();
                locationID = cmbLocations.SelectedValue.Trim();
                providerID = cmbProviders.SelectedValue.Trim();
                gender = cmbGender.SelectedValue.Trim();
                email = txtPatientEmail.Text.Trim();
                zipCode = txtZip.Text;
            }

            else if (rdKeyCard.Checked)
            {

                mrn = rdCreditCard.Checked ? txtCreditMRN.Text : txtBankMRN.Text;
                firstName = rdCreditCard.Checked ? txtCreditCardFirstName.Text : txtFirstName.Text;
                lastName = rdCreditCard.Checked ? txtCreditCardLastName.Text : txtLastName.Text;
                dateOfBirth = rdCreditCard.Checked ? rdCreditDateOfBirth.SelectedDate.ToString() : dtBankDateOfBirth.SelectedDate.ToString();
                patientSSN = rdCreditCard.Checked ? txtCreditSocialSecurity.Text : txtBankSocialSecurity.Text;
                patientSSNEnc = patientSSN.Encrypt();
                homePhone = rdCreditCard.Checked ? txtCreditHomePhone.Text : txtBankHomePhone.Text;
                locationID = rdCreditCard.Checked ? cmbCreditLocations.SelectedValue : cmbBankLocations.SelectedValue;
                providerID = rdCreditCard.Checked ? cmbCreditProviders.SelectedValue : cmbBankProviders.SelectedValue;
                gender = rdCreditCard.Checked ? cmbCreditGender.SelectedValue : cmbBankGender.SelectedValue;
                email = rdCreditCard.Checked ? txtCreditEmail.Text : txtBankEmail.Text;
                zipCode = rdCreditCard.Checked ? txtCreditCardZipCode.Text : string.Empty; //txtBankAccountZipCode.Text
            }
            else
            {
                mrn = string.Empty;
                firstName = string.Empty;
                lastName = string.Empty;
                dateOfBirth = string.Empty;
                patientSSN = string.Empty;
                patientSSNEnc = string.Empty;
                homePhone = string.Empty;
                locationID = string.Empty;
                providerID = string.Empty;
                gender = string.Empty;
                email = string.Empty;
                zipCode = string.Empty;

            }


            cmdParams = new Dictionary<string, object>
                                {
                                    {"@PracticeID", ClientSession.PracticeID},
                                    {"@MRN", mrn},
                                    {"@NameFirst",firstName},
                                    {"@NameLast", lastName},
                                    {"@DateofBirth", dateOfBirth},
                                    {"@PatientSSNenc", string.IsNullOrEmpty(patientSSNEnc) ? (object)DBNull.Value : patientSSNEnc},
                                    {"@PatientSSN4",  string.IsNullOrEmpty(patientSSN) ? (object)DBNull.Value : patientSSN.Trim().Substring(patientSSN.Trim().Length - 4, 4)},
                                    {"@PhonePri", homePhone},
                                    {"@LocationID", locationID},
                                    {"@ProviderID", providerID},
                                    {"@StatusTypeID", 1},
                                    {"@GenderID", gender},
                                    {"@Email", email},
                                    {"@AddrPrimaryID", 1},
                                    {"@ZipPri", zipCode},

                                    {"@GuardianRelTypeID", 18},
                                    {"@GuardianAddrID", 1},
                                    
                                    {"@UserID", ClientSession.UserID},
                                    {"@FlagActive", true}
                                    };


            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_add", cmdParams);
            foreach (DataRow row in reader.Rows)
            {

                patientID = (Int32)row["PatientID"];
                ViewState["AccountID"] = GetAccountIDOfSelectedPatient(patientID);

                var isPatientAlreadyExist = ((int)row["ErrorDuplicate"]) == 1;

                if (isPatientAlreadyExist && hdnIsContinueProcess.Value != "true")
                {
                    return false;
                }
                else
                {
                    hdnIsContinueProcess.Value = string.Empty;
                }

            }

        }

        // we need patientId in payment validation method
        ViewState["PatientID"] = patientID;

        if (rdSwipeCard.Checked || rdKeyCard.Checked)
        {
            var isCardValidated = rdKeyCard.Checked && rdBankAccount.Checked ? ValidateBank() : ValidateCreditCard();
            if (!isCardValidated)
            {
                return false;
            }

        }

        if (Convert.ToInt32(cmbStatements.SelectedValue) == 0)
        {
            var description = ValidateAndGetDescriptionValue();
            cmdParams = new Dictionary<string, object>
            {
                {"@PatientID", patientID == 0 ? Convert.ToInt32(cmbPatients.SelectedValue) : patientID},
                {"@UserID", ClientSession.UserID},
                {"@Amount", amount},
                {"@QPDesc", description },
                {"@Source", "QP"},
            };

            statementID = (Int32)SqlHelper.ExecuteScalarProcedureParams("web_pr_statement_quick_add", cmdParams);
        }

     
        ViewState["StatementID"] = statementID;

        return true;
    }

    private string ValidateAndGetDescriptionValue()
    {
        var selectedValue = cmbDescription.SelectedValue;
        if (!string.IsNullOrEmpty(selectedValue))
            return selectedValue;

        var enteredText = cmbDescription.Text;
        if (!string.IsNullOrEmpty(enteredText) && enteredText.Length > 2)
            return enteredText;


        return null;
    }

    private void DisplayAmountForSelectedStatement()
    {
        // Getting balance from the list of statement's balance according to the statementId
        var statements = ViewState["Statements"] as List<Tuple<int, decimal>>;
        var balance = statements.Single(res => res.Item1.Equals(Convert.ToInt32(cmbStatements.SelectedValue))).Item2.ToString();

        // Assigning the Amount for validating the Amount
        balance = Convert.ToDecimal(balance) > 0 ? balance : Request.Params["q"];
        hdnAmount.Value = balance;

        // Assigning the Balance
        if (rdSwipeCard.Checked)
            txtAmount.Text = balance;
        else if (rdCardOnFile.Checked)
            txtCardOnFileAmount.Text = balance;
        else if (rdTransaction.Checked)
            txtTransactionAmount.Text = balance;
        else
        {
            txtCreditCardAmount.Text = balance;
            txtBankAccountAmount.Text = balance;
        }
    }

    private void ShowPatientInformation(bool isNeedToCallProc)
    {
        var patientID = Convert.ToInt32(cmbPatients.SelectedValue);
        string firstName = string.Empty, lastName = string.Empty, zipCode = string.Empty;

        if (isNeedToCallProc)
        {

            var cmdParams = new Dictionary<string, object> { { "PatientID", patientID }, { "@UserID", ClientSession.UserID } };
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
            foreach (DataRow row in reader.Rows)
            {
                firstName = row["NameFirst"].ToString();
                lastName = row["NameLast"].ToString();
                //email = row["Email"].ToString();
                zipCode = row["ZipPri"].ToString(); //+ " " + row["Zip4Pri"];

                // Getting values for further use and this will also help to decrease number of requests to database
                ViewState["Email"] = row["Email"].ToString();
                ViewState["IsPatientHasCards"] = ((int)row["SavedPaymentCardCnt"] > 0);
                ViewState["PatientInformation"] = new Dictionary<string, string>
                {
                    {"FirstName", row["NameFirst"].ToString()},
                    {"LastName", row["NameLast"].ToString()},
                    {"Email", row["Email"].ToString()},
                    {"Zip", row["ZipPri"].ToString()},
                };

                ViewState["AccountID"] = row["AccountID"].ToString();
            }

        }
        else
        {
            string value;
            var values = (Dictionary<string, string>)ViewState["PatientInformation"];
            if (values == null) return;

            values.TryGetValue("FirstName", out value);
            firstName = value;
            values.TryGetValue("LastName", out value);
            lastName = value;
            //values.TryGetValue("Email", out value);
            //email = value;
            values.TryGetValue("Zip", out value);
            zipCode = value;
        }

        // Removing any value in variables if patient is not selected
        if (patientID == 0)
        {
            firstName = string.Empty;
            lastName = string.Empty;
            zipCode = string.Empty;
        }


        if (rdSwipeCard.Checked)
        {
            txtPatientFirstName.Text = firstName;
            txtPatientLastName.Text = lastName;
            txtZip.Text = zipCode;
            //txtEmail.Text = email;
            //lblEmail.Text = email;
        }
        else if (rdKeyCard.Checked)
        {

            txtCreditCardFirstName.Text = firstName;
            txtCreditCardLastName.Text = lastName;
            txtCreditCardZipCode.Text = zipCode;
            //lblCardEmail.Text = email;
            //txtCardEmail.Text = email;

            txtFirstName.Text = firstName;
            txtLastName.Text = lastName;
            //txtBankAccountZipCode.Text = zipCode;
            //lblBankEmail.Text = email;
            //txtBankAccountEmail.Text = email;

        }

    }

    private void BindPaymentMethod()
    {
        // Clearing the default value if any
        cmbPaymentMethods.ClearSelection();

        var methods = GetPaymentMethods();
        cmbPaymentMethods.DataSource = methods;
        cmbPaymentMethods.DataBind();
        ClientSession.Object = methods;

    }

    private void ManageEmailTextBoxandLables()
    {
        var patientId = !string.IsNullOrEmpty(cmbPatients.SelectedValue)
            ? Convert.ToInt32(cmbPatients.SelectedValue)
            : ClientSession.SelectedPatientID;

        if (patientId == 0)
        {
            lblEmail.Visible = true;
            lblEmail.Text = string.Empty;
            lblCardEmail.Visible = true;
            lblCardEmail.Text = string.Empty;
            lblBankEmail.Visible = true;
            lblBankEmail.Text = string.Empty;
            lblCardOnFileEmail.Visible = true;
            lblCardOnFileEmail.Text = string.Empty;
            lblTransactionEmail.Visible = true;
            lblTransactionEmail.Text = string.Empty;
            txtEmail.Visible = false;
            txtCardEmail.Visible = false;
            txtBankAccountEmail.Visible = false;
            txtCardOnFileEmail.Visible = false;
            txtTransactionEmail.Visible = false;
            return;
        }

        string email;

        if (ViewState["Email"] == null)
        {
            var cmdParams = new Dictionary<string, object> { { "@PatientID", patientId }, { "@UserID", ClientSession.UserID } };
            var patinetInformation = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
            email = patinetInformation.Rows[0]["Email"].ToString();
        }
        else
        {
            email = ViewState["Email"].ToString();
        }


        // if email is null or emptly the enabling the textbox and disabling the labels and vice versa.
        if (string.IsNullOrEmpty(email))
        {
            if (rdSwipeCard.Checked)
            {
                txtEmail.Visible = true;
                lblEmail.Visible = false;
            }
            else if (rdKeyCard.Checked)
            {
                txtCardEmail.Visible = true;
                txtBankAccountEmail.Visible = true;

                lblCardEmail.Visible = false;
                lblBankEmail.Visible = false;
            }
            else if (rdCardOnFile.Checked)
            {
                txtCardOnFileEmail.Visible = true;
                lblCardOnFileEmail.Visible = false;
            }
            else
            {
                txtTransactionEmail.Visible = true;
                lblTransactionEmail.Visible = false;
            }

        }
        else
        {

            if (rdSwipeCard.Checked)
            {
                lblEmail.Text = email;
                lblEmail.Visible = true;
                txtEmail.Visible = false;
            }
            else if (rdKeyCard.Checked)
            {
                txtCardEmail.Visible = false;
                txtBankAccountEmail.Visible = false;
                lblCardEmail.Text = email;
                lblCardEmail.Visible = true;
                lblBankEmail.Text = email;
                lblBankEmail.Visible = true;
            }
            else if (rdCardOnFile.Checked)
            {
                txtCardOnFileEmail.Visible = false;
                lblCardOnFileEmail.Text = email;
                lblCardOnFileEmail.Visible = true;
            }
            else
            {
                txtTransactionEmail.Visible = false;
                lblTransactionEmail.Text = email;
                lblTransactionEmail.Visible = true;
            }

        }
    }

    private void ShowHighestStatement()
    {
        var statements = ViewState["Statements"] as List<Tuple<int, decimal>>;
        if (statements == null || statements.Count == 0)
            return;

        var balance = statements.Max(res => res.Item2);
        var statementId = statements.First(res => res.Item2 == balance).Item1.ToString();
        cmbStatements.SelectedValue = statementId;
    }

    private void ShowErrorMessage(string message)
    {
        RadWindowManager.RadConfirm(message, "continueProcessPayment", 500, 120, null, "");
    }

    protected void btnSignature_Click(object sender, EventArgs e)
    {
        ClientSession.EnablePrinting = false;
        ClientSession.EnableClientSign = true;
        hdnIsReceipt.Value = "0";
        ScriptManager.RegisterStartupScript(Page, typeof(Page), "showPaymentReceiptByOption", "showPaymentReceiptByOption()", true);
    }

    private void ManageReceiptPopups()
    {
        var emailMessage = SendEmail();

        var isPrintReceipt = ClientSession.FlagPrintPayReceipts;
        var isSignCapture = ClientSession.FlagSigCaptureReceipts;

        var bothOptionsUnSelected = !isPrintReceipt && !isSignCapture;
        if (bothOptionsUnSelected)
        {
            hdnIsReceipt.Value = "1";
            ClientSession.EnablePrinting = true;

            if (string.IsNullOrEmpty(emailMessage))
            {
                RadWindow.RadConfirm(GetSuccessMessage(null), "reloadPage", 450, 150, null, "", "../Content/Images/Success.png");
            }
            else
            {
                RadWindow.RadConfirm(GetSuccessMessage(emailMessage), "reloadPage", 500, 150, null, "", "../Content/Images/Success.png");
            }

        }
        else if (isSignCapture)
        {
            hdnIsReceipt.Value = "0";
            ClientSession.EnablePrinting = false;
            ClientSession.EnableClientSign = true;
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "showPaymentReceiptByOption", "showPaymentReceiptByOption()", true);
        }
        else
        {
            hdnIsReceipt.Value = "2";
            ClientSession.EnablePrinting = true;
            ClientSession.EnableClientSign = false;
            ScriptManager.RegisterStartupScript(Page, typeof(Page), "showPaymentReceiptByOption", "showPaymentReceiptByOption()", true);
        }

        if (!string.IsNullOrEmpty(emailMessage) && !bothOptionsUnSelected)
        {
            RadWindow.RadAlert(GetSuccessMessage(emailMessage), 500, 150, "", "showPaymentReceiptByOption", "../Content/Images/Success.png");
        }
    }

    private static string GetSuccessMessage(string emailMessage)
    {
        var message = "Payment is confirmed.";

        if (!string.IsNullOrEmpty(emailMessage))
        {
            message += " But " + emailMessage;
        }

        message += string.Format("<br /> Response: {0} ({1})", Common.FSPMessage, Common.FSPAuthRef);
        return message;
    }

    private string GetFailureMessage()
    {
        var message = string.Format("The attempt to process this payment was unsuccessful.<br/>Reason: {0}<br/><br/>Verify all details or try a different payment method.", Common.FSPMessage);
        return message;
    }

    private bool ValidateCreditCard()
    {
        ValidCard fsv;

        if (rdSwipeCard.Checked)
        {
            object firstName, lastName, cardType, ccLast4, expDate;
            var values = ViewState["Values"] as Dictionary<string, object>;
            values.TryGetValue("CardType", out cardType);
            values.TryGetValue("FirstName", out firstName);
            values.TryGetValue("LastName", out lastName);
            values.TryGetValue("ExpDate", out expDate);
            values.TryGetValue("CCLast4", out ccLast4);

            // Validating the magtek information
            fsv = new ValidCard((Int32)cardType, Convert.ToString(ccLast4), Convert.ToString(expDate), GetPatientIDOrStatementID(true), 0, GetAccountIDOfSelectedPatient(), ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, Convert.ToString(firstName) + " " + Convert.ToString(lastName), string.Empty, txtZipCode.Text, txtCVVSecurityID.Text, txtMagTek.Text);
        }
        else
        {
            var cardTypeValue = Convert.ToInt32(cmbCardType.SelectedValue); //Convert.ToInt32(hdnCardType.Value);
            var month = txtMonth.Text.Length == 1 ? "0" + txtMonth.Text : txtMonth.Text;
            var expiryDate = month + txtYear.Text.Substring(2, 2);
            fsv = new ValidCard(cardTypeValue, txtCardNumber.Text, expiryDate, GetPatientIDOrStatementID(true), 0, GetAccountIDOfSelectedPatient(), ClientSession.PracticeID, ClientSession.IPAddress, ClientSession.UserID, txtCreditCardFirstName.Text.Trim() + " " + txtCreditCardLastName.Text.Trim(), string.Empty, txtZipCode.Text, txtCVVSecurityID.Text);
        }

        if (fsv.Success)
        {
            Common.ReturnTransID = fsv.ReturnTransID;
            hdnPref.Value = fsv.PNRef;
        }

        Common.Success = fsv.Success;
        return fsv.Success;
    }

    private Int32 GetAccountIDOfSelectedPatient(Int32 patientID = 0)
    {
        if (patientID > 0)
        {
            var cmdParams = new Dictionary<string, object> { { "PatientID", patientID }, { "@UserID", ClientSession.UserID } };
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
            foreach (DataRow row in reader.Rows)
            {
                var accountID = row["AccountID"].ToString();
                return Int32.Parse(accountID);
            }
        }

        var value = ViewState["AccountID"] ?? "0";
        return Int32.Parse(value.ToString());

    }

    private void BindCurrentPatientIntoDropdown()
    {
        var dataTable = new DataTable();

        dataTable.Columns.Add("PatientID");
        dataTable.Columns.Add("ComboBoxAbbr");

        var newRow = dataTable.NewRow();
        newRow["PatientID"] = 0;
        newRow["ComboBoxAbbr"] = "Create New Patient";
        dataTable.Rows.InsertAt(newRow, 0);

        if (ClientSession.SelectedPatientID > 0)
        {
            newRow = dataTable.NewRow();
            newRow["PatientID"] = ClientSession.SelectedPatientID;
            newRow["ComboBoxAbbr"] = string.Format("{0}, {1} | {2}", ClientSession.PatientFirstName, ClientSession.PatientLastName, ClientSession.DateOfBirth);
            dataTable.Rows.InsertAt(newRow, 1);
        }

        cmbPatients.DataSource = dataTable;
        cmbPatients.DataBind();
    }

    #endregion


}



