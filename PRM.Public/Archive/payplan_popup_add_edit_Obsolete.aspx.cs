using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;

public partial class patient_payplan_popup_add_edit : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                //Bind payment methods
                BindPaymentMethods();

                //Bind payment Frequency
                BindPaymentFrequency();

                //Get statement default values
                GetDefaultStatementValues();

                if (ClientSession.ObjectType == ObjectType.EditPaymentPlan)
                {
                    lblStartDate.Text = "Next Payment Date:";
                    lblInitialPayment.Text = "Next Payment:";
                }
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

    private void BindPaymentFrequency()
    {
        var payFrequency = SqlHelper.ExecuteDataTableProcedureParams("web_pr_payfreq_list", new Dictionary<string, object>());

        cmbPayFrequency.DataSource = payFrequency;
        cmbPayFrequency.DataBind();
    }


    private void GetDefaultStatementValues()
    {
        if (ClientSession.ObjectID != null && (ClientSession.ObjectType == ObjectType.AddPaymentPlan || ClientSession.ObjectType == ObjectType.EditPaymentPlan))
        {
            var cmdParams = new Dictionary<string, object> { { "@StatementID", ClientSession.ObjectID } };
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pt_payplan_defaults", cmdParams);
            foreach (DataRow row in reader.Rows)
            {
                dtStartDate.SelectedDate = Convert.ToDateTime(row["DateStart"]);
                dtStartDate.MaxDate = Convert.ToDateTime(row["DateStartMax"]);
                lblDateStartMax.Text = "Enter a date before " + Convert.ToDateTime(row["DateStartMax"]).ToString("MM/dd/yyyy");

                txtInitialPayment.Text = row["PaymentInitial"].ToString();
                lblInitialPaymentInterval.Text = "Enter between $" + row["PaymentInitialMin"] + " and $" + row["PaymentInitialMax"];
                rngInititalPayment.MinimumValue = row["PaymentInitialMin"].ToString();
                rngInititalPayment.MaximumValue = row["PaymentInitialMax"].ToString();

                txtRecurringPayment.Text = row["PaymentRecurring"].ToString();
                lblRecurringPaymentInterval.Text = "Enter between $" + row["PaymentRecurringMin"] + " and $" + row["PaymentRecurringMax"];
                rngRecurringPayment.MinimumValue = row["PaymentRecurringMin"].ToString();
                rngRecurringPayment.MaximumValue = row["PaymentRecurringMax"].ToString();

                cmbPayFrequency.SelectedValue = row["PaymentFreqTypeID"].ToString();

                litDisclaimer.Text = row["DisclaimerText"].ToString();
            }

            cmdParams = new Dictionary<string, object> { { "@AccountID", ClientSession.AccountID } };

            var activeStatements = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
            var selectedStatement = activeStatements.Select("StatementID=" + ClientSession.ObjectID);

            lblStatementFullName.Text = selectedStatement[0]["StatementNameLong"].ToString();
            hdnBalance.Value = selectedStatement[0]["Balance"].ToString();
            hdnPayFrequency.Value = cmbPayFrequency.SelectedValue;
            //calculating number of payments and end date
            var balance = Convert.ToDouble(selectedStatement[0]["Balance"].ToString());
            var initialPayment = Convert.ToDouble(txtInitialPayment.Text);
            var recurringPayment = Convert.ToDouble(txtRecurringPayment.Text);

            var numberPayments = Math.Ceiling((balance - initialPayment) / recurringPayment) + 1;
            lblNumberofPayments.Text = numberPayments.ToString();

            var startDate = Convert.ToDateTime(dtStartDate.SelectedDate);
            var elapseDays = GetElapsedDays(Convert.ToInt32(cmbPayFrequency.SelectedValue));
            var daysAdd = Convert.ToDouble((numberPayments - 1) * elapseDays) + 1;
            lblEndDate.Text = startDate.AddDays(daysAdd).ToString("MM/dd/yyyy");
        }
    }

    private static Int32 GetElapsedDays(Int32 selectedFreqValue)
    {
        var payFrequency = SqlHelper.ExecuteDataTableProcedureParams("web_pr_payfreq_list", new Dictionary<string, object>());
        var elapseDays = Convert.ToInt32(payFrequency.Select("PaymentFreqTypeID=" + selectedFreqValue)[0]["ElapseDays"]);
        return elapseDays ;
    }
    [WebMethod]
    public static Int32 ElapsedDays(string selectedFreqValue)
    {
        return GetElapsedDays(Convert.ToInt32(selectedFreqValue));
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                var cmdParams = new Dictionary<string, object>
                                    {
                                        { "@PatientID", ClientSession.PatientID },
                                        { "@StatementID", ClientSession.ObjectID },
                                        { "@PaymentPlanID", ClientSession.ObjectID2 },
                                        { "@PaymentCardTypeID", GetPaymentTypeID(cmbPaymentMethods.SelectedValue) },
                                        { "@PaymentCardID", cmbPaymentMethods.SelectedValue },
                                        { "@StartDate", dtStartDate.SelectedDate },
                                        { "@EndDate", GetCalculatedEndDate() },
                                        { "@InitialPayAmount", txtInitialPayment.Text.Trim() },
                                        { "@RecurringAmount ", txtRecurringPayment.Text.Trim() },
                                        { "@PaymentFreqTypeID ", cmbPayFrequency.SelectedValue },
                                        { "@FlagActive ", 1 }
                                        
                                    };

                SqlHelper.ExecuteScalarProcedureParams("web_pt_payplan_add", cmdParams);
                litMessage.Text = "Payment Plan information has been updated sucessfully";
                ClientScript.RegisterStartupScript(Page.GetType(), "mykey", "CloseAndRebind();", true);
            }
            catch (Exception)
            {

                throw;
            }
        }


    }
    private DateTime GetCalculatedEndDate()
    {
        var cmdParams = new Dictionary<string, object> { { "@AccountID", ClientSession.AccountID } };

        //calculating number of payments and end date
        var activeStatements = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
        var selectedStatement = activeStatements.Select("StatementID=" + ClientSession.ObjectID);

        var balance = Convert.ToDouble(selectedStatement[0]["Balance"].ToString());
        var initialPayment = Convert.ToDouble(txtInitialPayment.Text);
        var recurringPayment = Convert.ToDouble(txtRecurringPayment.Text);

        var numberPayments = Math.Ceiling((balance - initialPayment) / recurringPayment) + 1;


        var startDate = Convert.ToDateTime(dtStartDate.SelectedDate);
        var elapseDays = GetElapsedDays(Convert.ToInt32(cmbPayFrequency.SelectedValue));
        var daysAdd = Convert.ToDouble((numberPayments - 1) * elapseDays);
        startDate = startDate.AddDays(daysAdd);
        return startDate;

    }

    private Int32 GetPaymentTypeID(string paymentID)
    {
        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID } };

        var paymentMethods = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", cmdParams);
        return Convert.ToInt32(paymentMethods.Select("PaymentCardID=" + paymentID)[0]["PaymentCardTypeID"]);
    }


}