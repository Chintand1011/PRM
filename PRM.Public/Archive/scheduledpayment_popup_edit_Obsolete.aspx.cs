using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;

public partial class scheduledpayment_popup_edit : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                BindPaymentMethods();

                GetPaymentInformation();
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    private void BindPaymentMethods()
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID } };

        var paymentMethods = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        cmbPaymentMethods.DataSource = paymentMethods;
        cmbPaymentMethods.DataBind();
    }

    private void GetPaymentInformation()
    {
        if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.EditPendingPayment)
        {
            var cmdParams = new Dictionary<string, object> { { "@AccountID", ClientSession.AccountID } };

            var pendingPayments = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transaction_get", cmdParams);
            var payment = pendingPayments.Select("TransID=" + ClientSession.ObjectID)[0];

            lblStatementFullName.Text = payment["StatementNameLong"].ToString();
            cmbPaymentMethods.SelectedValue = payment["PaymentCardID"].ToString();
            dtPaymentDate.SelectedDate = Convert.ToDateTime(payment["PaymentDate"]);
            lblPaymentDatetMax.Text = "Please enter a date before " + Convert.ToDateTime(payment["PaymentDateMax"]).ToString("MM/dd/yyyy");

            txtPayment.Text = payment["Payment"].ToString();
            lblPaymentInterval.Text = "Enter between $" + payment["PaymentMin"] + " and $" + payment["PaymentMax"];

            rngPayment.MinimumValue = payment["PaymentMin"].ToString();
            rngPayment.MaximumValue = payment["PaymentMax"].ToString();

            dtPaymentDate.MaxDate = Convert.ToDateTime(payment["PaymentDateMax"]);
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            if (Page.IsValid)
            {
                var cmdParams = new Dictionary<string, object>
                                {
                                    { "@TransID", ClientSession.ObjectID },
                                    { "@PaymentCardTypeID", 2 },
                                    { "@PaymentCardID", cmbPaymentMethods.SelectedValue },
                                    { "@PaymentDate", dtPaymentDate.SelectedDate },
                                    { "@Amount", txtPayment.Text.Trim() }
                                };

                SqlHelper.ExecuteScalarProcedureParams("web_pt_payment_update_old", cmdParams);
                ClientScript.RegisterStartupScript(Page.GetType(), "mykey", "CloseAndRebind();", true);
                litMessage.Text = "Schedule Payment has been updated successfully.";
            }
        }
        catch (Exception)
        {

            throw;
        }
    }


}