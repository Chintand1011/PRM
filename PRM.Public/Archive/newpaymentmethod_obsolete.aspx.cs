using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;


public partial class newpaymentmethod : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCreditCard();
            // For Credit Card Validations
            rngValidatorYear.MinimumValue = DateTime.Now.Year.ToString();
            rngValidatorYear.MaximumValue = (DateTime.Now.Year + 10).ToString();
        }
        popupMessage.VisibleOnPageLoad = false;
    }
    protected void rdCreditCard_CheckedChanged(object sender, EventArgs e)
    {
        pnlCreditCard.Visible = true;
        pnlBankAccount.Visible = false;
        LoadCreditCard();
    }

    protected void rdBankAccount_CheckedChanged(object sender, EventArgs e)
    {
        LoadBankAccount();

        pnlCreditCard.Visible = false;
        pnlBankAccount.Visible = true;
    }



    #region CredCard Account

    private void LoadCreditCard()
    {
        //Get Card Types
        cmbCardType.DataSource = GetCardTypes();
        cmbCardType.DataBind();

        //Get States
        BindStates();
    }

    private DataTable GetCardTypes()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } };
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_cardtype_list", cmdParams);

    }

    private void BindStates()
    {
        var cmdParams = new Dictionary<string, object>();
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", cmdParams);

        cmbStates.DataSource = states;
        cmbStates.DataBind();

        cmbBankStates.DataSource = states;
        cmbBankStates.DataBind();
    }

    protected void cmbCardType_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
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
        }
        else
        {
            txtCardNumber.Mask = "####-####-####-####";
            regexpCardNumber.ValidationExpression = @"\d{4}\-\d{4}\-\d{4}\-\d{4}";
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {

                ValidCard FSV; //Front Stream Validate
                var cardType = Convert.ToInt32(hdnCardType.Value);
                var expiryDate = txtMonth.Text + txtYear.Text.Substring(2, 4);
                var ipAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                FSV = new ValidCard(cardType, txtCardNumber.Text, expiryDate, ClientSession.PatientID, 10000,
                                    ClientSession.AccountID, ClientSession.PracticeID, ipAddress, ClientSession.UserID, "",
                                    txtStreet.Text, txtZipCode.Text, txtCVVSecurityID.Text);
                                    
                if (FSV.Success) //card was validated.
                {
                    var pnref = FSV.PNRef;
                    var cmdParams = new Dictionary<string, object>
                                        {
                                            {"@PatientID", ClientSession.PatientID},
                                            {"@NameLast", txtLastName.Text.Trim()},
                                            {"@NameFirst", txtFirstName.Text.Trim()},
                                            {"@Addr1", txtStreet.Text.Trim()},
                                            {"@Addr2", txtAptSuite.Text.Trim()},
                                            {"@City", txtCity.Text.Trim()},
                                            {"@StateTypeID", cmbStates.SelectedValue},
                                            {"@Zip", txtZipCode.Text.Trim()},
                                            {"@PaymentCardTypeID", cmbCardType.SelectedValue},
                                            {"@BankName", txtIssuingBank.Text.Trim()},
                                            {"@BankPhone", txtBankPhone.Text.Trim()},
                                            {"@CardLast4", txtCardNumber.Text.Trim().Substring( txtCardNumber.Text.Trim().Length-4) },
                                            {"@ExpMonth", txtMonth.Text.Trim()},
                                            {"@ExpYear", txtYear.Text.Trim()},
                                            {"@CVV2ID", txtCVVSecurityID.Text.Trim()},
                                            {"@PNRef", pnref},
                                            {"@CardClassID", rdPersonal.Checked ? "0" : "1"},
                                            {"@FlagPrimary", chkPrimarySeconday.Checked}
                                        };

                    SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
                    litMessage.Text = "Credit Card has been added sucessfully";
                }
                else
                {
                    lblPopupMessage.Text = FSV.Message;  //in case error message should be displayed
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

    #region Bank Account

    private void LoadBankAccount()
    {
        //Get AccountType
        BindAccountType();

        //Get States
        BindStates();
    }

    private void BindAccountType()
    {
        cmbAccountType.Items.Add(new RadComboBoxItem { Text = AccountType.Checking.ToString(), Value = ((int)AccountType.Checking).ToString() });
        cmbAccountType.Items.Add(new RadComboBoxItem { Text = AccountType.Savings.ToString(), Value = ((int)AccountType.Savings).ToString() });
    }

    protected void btnBankAccountSubmit_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {

                var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.PatientID },
                                    { "@NameLast", txtBankLastName.Text.Trim() },
                                    { "@NameFirst", txtBankFirstName.Text.Trim() },
                                    { "@BankName", txtBankName.Text.Trim() },
                                    { "@City", txtBranchCity.Text.Trim() },
                                    { "@StateTypeID", cmbBankStates.SelectedValue },
                                    { "@AccountTypeID", cmbAccountType.SelectedValue },
                                    { "@CardLast4", txtAccountNumber.Text.Trim().Substring(txtAccountNumber.Text.Trim().Length-4) },
                                    { "@FlagPrimary", chkPrimarySeconday.Checked }
                                };

                SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
                litBankMessage.Text = "Bank account has been added successfully";
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
    #endregion
}