using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class addBCLoan_popup : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // for close the RadWidnow in case of any error
                ClientSession.WasRequestFromPopup = true;
                BindQuickDescription();
                GetValidationFields();
            }
            catch (Exception)
            {
                throw;
            }
        }
    }


    private void GetValidationFields()
    {
        var cmdParams = new Dictionary<string, object>
        {
            {"@PracticeID", ClientSession.PracticeID},
            {"@PatientID", ClientSession.SelectedPatientID},
            {"@UserID", ClientSession.UserID}
        };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_limits_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            var blueCreditQualMin = double.Parse(row["BlueCreditQualMin"].ToString());
            var blueCreditQualMax = double.Parse(row["BlueCreditQualMax"].ToString());

            ViewState["BlueCreditMinDP"] = row["CombinedMinDP"];
            ViewState["blueCreditQualMin"] = blueCreditQualMin;
            ViewState["blueCreditQualMax"] = blueCreditQualMax;

            txtAmount.MinValue = blueCreditQualMin;
            txtAmount.MaxValue = blueCreditQualMax * 2;

            pgBlueCreditQualAbbr.InnerText = row["BlueCreditQualAbbr"].ToString();
            pgLenderQualAbbr.InnerText = row["LenderQualAbbr"].ToString();
        }
    }

    private void BindQuickDescription()
    {
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_qpdesc_get", new Dictionary<string, object>
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
                    cmbQuickPick.Items.Add(new RadComboBoxItem { Text = description, Value = description });
                }
            }

            cmbQuickPick.Items.Add(new RadComboBoxItem { Text = row["QPDesc0"].ToString(), Value = row["QPDesc0"].ToString() });
        }
        //  cmbQuickPick.DataBind();
    }


    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            var qpDescValue = ValidateAndGetQpDescValue();
            if (string.IsNullOrEmpty(qpDescValue))
            {
                RadWindow.RadAlert("Invalid charge description.", 350, 150, "", "", "../Content/Images/warning.png");
                return;
            }

            var errorMessage = ValidateFinancedAmount();
            if (!string.IsNullOrEmpty(errorMessage))
            {
                RadWindow.RadAlert(errorMessage, 350, 150, "", "", "../Content/Images/warning.png");
                return;
            }

            var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.SelectedPatientID },
                                    { "@UserID", ClientSession.UserID },
                                    { "@Amount", txtAmount.Text },
                                    { "@QPDesc", qpDescValue },
                                    { "@Source", "BC" },
                                    { "@FlagBlueCredit", "1"}
                                };

            var statementId = SqlHelper.ExecuteScalarProcedureParams("web_pr_statement_quick_add", cmdParams);
            ClientSession.ObjectValue = new Dictionary<string, object>
            {
                {"StatementID", statementId},
                {"Balance", txtAmount.Text},
                {"DownPayment", txtDownPayment.Text},
                {"FlagBCLoan", 1}
            };

            ScriptManager.RegisterStartupScript(Page, typeof(Page), "goToBCApplyCredit", "goToBCApplyCredit()", true);

        }
        catch (Exception)
        {
            throw;
        }
    }

    private string ValidateFinancedAmount()
    {
        var minValue = decimal.Parse(ViewState["blueCreditQualMin"].ToString());
        var maxValue = decimal.Parse(ViewState["blueCreditQualMax"].ToString());
        var value = decimal.Parse(ViewState["BlueCreditMinDP"].ToString());

        var amount = decimal.Parse(txtAmount.Text);
        var downPayment = decimal.Parse(txtDownPayment.Text);

        var downPaymentMinValue = amount*value;
        if (downPayment < downPaymentMinValue)
        {
            return string.Format("Downpayment should be greater than or equal to {0:C}", downPaymentMinValue);
        }

        var financedAmount = amount - downPayment;
        var isValid = financedAmount >= minValue && financedAmount <= maxValue;

        return !isValid ? string.Format("Financed Amount should be between {0:C} and {1:C}", minValue, maxValue) : null;
    }

    private string ValidateAndGetQpDescValue()
    {
        var selectedValue = cmbQuickPick.SelectedValue;
        if (!string.IsNullOrEmpty(selectedValue))
            return selectedValue;

        var enteredText = cmbQuickPick.Text;
        if (!string.IsNullOrEmpty(enteredText) && enteredText.Length > 2)
            return enteredText;


        return null;
    }

}
