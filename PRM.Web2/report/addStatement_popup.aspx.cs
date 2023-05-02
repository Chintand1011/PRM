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

public partial class addStatement_popup : BasePage
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
            }
            catch (Exception)
            {
                throw;
            }
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


            var cmdParams = new Dictionary<string, object>()
                                {
                                    { "@PatientID", ClientSession.SelectedPatientID },
                                    { "@UserID", ClientSession.UserID },
                                    { "@Amount", txtAmount.Text },
                                    { "@QPDesc", qpDescValue },
                                    { "@Source", "BC" },
                                };

            SqlHelper.ExecuteScalarProcedureParams("web_pr_statement_quick_add", cmdParams);
            RadWindow.RadAlert("Record successfully created.", 350, 150, "", "reloadPage", "../Content/Images/success.png");

        }
        catch (Exception)
        {
            throw;
        }
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
