using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using System.Data;
using PatientPortal.Utility;
using Telerik.Web.UI;
public partial class creditcardaccount_popup_add_edit : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                var existingCards = GetExistingCards();
                cmbExistingCards.DataSource = existingCards;
                cmbExistingCards.DataBind();

                rngValidatorYear.MinimumValue = DateTime.Now.Year.ToString();
                rngValidatorYear.MaximumValue = (DateTime.Now.Year + 10).ToString();

                //Get Card Types
                cmbCardType.DataSource = GetCardTypes();
                cmbCardType.DataBind();

                //Get States
                BindStates();
                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.CreditCard)
                {
                    GetCardInformation((int)ClientSession.ObjectID);
                    cmbExistingCards.SelectedValue = ClientSession.ObjectID.ToString();
                    btnUpdate.Visible = true;
                    cmbExistingCards.Enabled = false;
                    cmbCardType.Enabled = false;
                    return;
                }
                divExistingCard.Visible = false;
                btnSubmit.Visible = true;
            }
            catch (Exception)
            {

                throw;
            }
        }
        popupMessage.VisibleOnPageLoad = false;
    }

    private DataTable GetCardTypes()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } };
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_cardtype_list", cmdParams);
    }

    private DataTable GetExistingCards()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID } };

        var existingCards = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        ClientSession.Object = existingCards;
        return existingCards;
    }

    private void BindStates()
    {
        var cmdParams = new Dictionary<string, object>();
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", cmdParams);

        cmbStates.DataSource = states;
        cmbStates.DataBind();
    }

    private void GetCardInformation(Int32 paymentID)
    {
        if (ClientSession.Object != null)
        {
            var cardInformation = ClientSession.Object.Select("PaymentCardID=" + paymentID + "");
            txtLastName.Text = cardInformation[0]["NameLast"].ToString();
            txtFirstName.Text = cardInformation[0]["NameFirst"].ToString();
            txtStreet.Text = cardInformation[0]["Address1"].ToString();
            txtAptSuite.Text = cardInformation[0]["Address2"].ToString();
            txtCity.Text = cardInformation[0]["City"].ToString();
            cmbStates.SelectedValue = cardInformation[0]["StateTypeID"].ToString();
            txtZipCode.Text = cardInformation[0]["Zip"].ToString();
            cmbCardType.SelectedValue = cardInformation[0]["PaymentCardTypeID"].ToString();
            txtIssuingBank.Text = cardInformation[0]["BankName"].ToString();
            txtBankPhone.Text = cardInformation[0]["BankPhone"].ToString();
            txtCardNumber.Text = cardInformation[0]["CardNumberAbbr"].ToString();
            txtMonth.Text = cardInformation[0]["ExpMonth"].ToString();
            txtYear.Text = cardInformation[0]["ExpYear"].ToString();
            var cardClass = Convert.ToInt32(cardInformation[0]["CardClassID"]);

            if (cardClass == (int)CardClass.Personal) rdPersonal.Checked = true;
            else rdCorporate.Checked = true;

            SetValidationExpression();

            chkPrimarySeconday.Checked = Convert.ToBoolean(cardInformation[0]["FlagPrimary"]);

        }
    }

    protected void cmbExistingCards_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            var selectedCardID = Convert.ToInt32(cmbExistingCards.SelectedValue);

            if (selectedCardID > 0)
            {
                GetCardInformation(selectedCardID);
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

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            ValidCard FSV; //Front Stream Validate
            var cardType = Convert.ToInt32(cmbCardType.SelectedValue); //Convert.ToInt32(hdnCardType.Value);
            var expiryDate = txtMonth.Text + txtYear.Text.Substring(2, 2);
            //hardeep update ipAddress
            var ipAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ?? Request.ServerVariables["REMOTE_ADDR"];
            FSV = new ValidCard(cardType, txtCardNumber.Text, expiryDate, ClientSession.PatientID, 10000, ClientSession.AccountID, ClientSession.PracticeID, ipAddress, ClientSession.UserID, "",
                                    txtStreet.Text, txtZipCode.Text, txtCVVSecurityID.Text);
            if (FSV.Success) //card was validated.
            {
                var pnref = FSV.PNRef;

                var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.PatientID },
                                    { "@NameLast", txtLastName.Text.Trim() },
                                    { "@NameFirst", txtFirstName.Text.Trim() },
                                    { "@Addr1", txtStreet.Text.Trim() },
                                    { "@Addr2", txtAptSuite.Text.Trim() },
                                    { "@City", txtCity.Text.Trim()},
                                    { "@StateTypeID", cmbStates.SelectedValue },
                                    { "@Zip", txtZipCode.Text.Trim() },
                                    { "@CardLast4", txtCardNumber.Text.Trim().Substring( txtCardNumber.Text.Trim().Length-4) },
                                    { "@PaymentCardTypeID", cmbCardType.SelectedValue },
                                    { "@BankName", txtIssuingBank.Text.Trim() },
                                    { "@BankPhone", txtBankPhone.Text.Trim() },
                                    { "@CardLast4", txtCardNumber.Text.Trim().Substring( txtCardNumber.Text.Trim().Length-4) },
                                    { "@ExpMonth", txtMonth.Text.Trim() },
                                    { "@ExpYear", txtYear.Text.Trim() },
                                    { "@PNRef", pnref },                                    
                                    { "@CardClassID", rdPersonal.Checked?"0":"1" },
                                    { "@FlagPrimary", chkPrimarySeconday.Checked }
                                };

                SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
                ClientScript.RegisterStartupScript(Page.GetType(), "mykey", "CloseAndRebind();", true);
                litMessage.Text = "Credit account has been added successfully.";
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

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            ValidCard FSV; //Front Stream Validate
            var cardType = Convert.ToInt32(cmbCardType.SelectedValue); //Convert.ToInt32(hdnCardType.Value);
            var expiryDate = txtMonth.Text + txtYear.Text.Substring(2, 2);
            //hardeep update ipAddress
            var ipAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ?? Request.ServerVariables["REMOTE_ADDR"];
            FSV = new ValidCard(cardType, txtCardNumber.Text, expiryDate, ClientSession.PatientID, 10000, ClientSession.AccountID, ClientSession.PracticeID, ipAddress, ClientSession.UserID, "",
                                    txtStreet.Text, txtZipCode.Text, txtCVVSecurityID.Text);
            if (FSV.Success) //card was validated.
            {
                var pnref = FSV.PNRef;
                var cmdParams = new Dictionary<string, object>
                                    {
                                        {"@PatientID", ClientSession.PatientID},
                                        {"@PaymentCardID", cmbExistingCards.SelectedValue},
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
                                        {"@PNRef", pnref }, 
                                        {"@CardClassID", rdPersonal.Checked ? "0" : "1"},
                                        {"@FlagPrimary", chkPrimarySeconday.Checked}
                                    };

                SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentcard_add", cmdParams);
                ClientScript.RegisterStartupScript(Page.GetType(), "mykey", "CloseAndRebind();", true);
                litMessage.Text = "Credit account has been updated successfully.";
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
}