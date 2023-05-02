using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class addTransactions_popup : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // for close the RadWidnow in case of any error
                ClientSession.WasRequestFromPopup = true;
                // Binding the Transaction Type dropdown
                BindTransactionType();
                // Checking if Selected patient has email or not
                ManageEmailAddress();
                ValidateFlagCanArhieveStatement();
                // Binding Top Section
                lblStatementID.Text = ClientSession.ObjectID.ToString();
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    private void ManageEmailAddress()
    {
        object email;
        ClientSession.SelectedPatientInformation.TryGetValue("Email", out email);

        if (string.IsNullOrEmpty(email.ToString()))
        {
            txtEmail.Visible = true;
        }
        else
        {
            lblEmail.Visible = true;
            lblEmail.Text = email.ToString();
        }
    }

    private void ValidateFlagCanArhieveStatement()
    {
        var param = Request.Params["FlagAllowClose"];
        spanArchiveStatement.Visible = param.ParseBool();
    }

    private void BindTransactionType()
    {
        var cmdParams = new Dictionary<string, object> { { "@FlagUserAction", 1 } };

        var transactions = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transtype_list", cmdParams);
        ClientSession.Object = transactions;
        cmbTransactionType.DataSource = transactions;
        cmbTransactionType.DataBind();
    }


    protected void cmbTransactionType_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        // Enabling the submit button onchange of the TransactionType dropdown
        btnSubmit.ImageUrl = "../Content/Images/btn_submit.gif";
        btnSubmit.Enabled = true;

        // Auto populate the message field.
        var serviceMessage = ClientSession.Object.Select("TransactionTypeID=" + cmbTransactionType.SelectedValue);
        txtMessage.Text = serviceMessage[0]["ServiceMsg"].ToString();
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            if (!string.IsNullOrEmpty(txtEmail.Text))
            {
                SaveEmail(txtEmail.Text);
            }

            var cmdParams = new Dictionary<string, object>()
                                {
                                    { "@StatementID", ClientSession.ObjectID},
                                    { "@PatientID", ClientSession.SelectedPatientID },
                                    { "@AccountID", ClientSession.SelectedPatientAccountID},
                                    { "@TransactionTypeID", cmbTransactionType.SelectedValue },
                                    { "@Amount", txtAmount.Text },
                                    { "@FSPMessage", txtMessage.Text.Trim() },
                                    { "@Notes", txtNotes.Text.Trim() },
                                    { "@UserID", ClientSession.UserID },
                                    { "@IPAddress", ClientSession.IPAddress },
                                };

            SqlHelper.ExecuteScalarProcedureParams("web_pr_transaction_add", cmdParams);
            RadWindow.RadAlert("Record successfully created.", 350, 150, "", "reloadPage", "../Content/Images/success.png");

        }
        catch (Exception)
        {
            throw;
        }
    }

    private void SaveEmail(string email)
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@PracticeID", ClientSession.PracticeID }, { "@Email", email }, { "@UserID", ClientSession.UserID } };
        SqlHelper.ExecuteScalarProcedureParams("web_pr_patient_email_add", cmdParams);
    }
}
