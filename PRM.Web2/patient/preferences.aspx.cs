using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class preferences : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindAllFlagDropdowns();
            ShowPatientPreferences();
        }
    }



    private void BindAllFlagDropdowns()
    {
        // Allow Web Access
        cmbAllowWebAccess.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbAllowWebAccess.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });

        // Ok To Leave Messages
        cmbOkToLeaveMessages.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbOkToLeaveMessages.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });

        // Suspended Account
        cmbSuspendAccount.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbSuspendAccount.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });

        // Signed Financials On File
        cmbSignedFinancialsOnFile.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbSignedFinancialsOnFile.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });

        // Auto Assign Blue Credit
        cmbAutoAssignBlueCredit.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbAutoAssignBlueCredit.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });

        // Suspend Paper Billing
        cmbSuspendPaperBilling.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbSuspendPaperBilling.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });
    }


    protected void cmbSuspendPaperBilling_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        ValidateEmail();
    }

    private void ShowPatientPreferences()
    {
        var cmdParams = new Dictionary<string, object>() { { "@PatientID", ClientSession.SelectedPatientID }, { "@UserID", ClientSession.UserID } };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_ptpref_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            cmbAllowWebAccess.SelectedValue = row["FlagWebAccess"].ToString() == "True" ? "1" : "0";
            cmbOkToLeaveMessages.SelectedValue = row["FlagLeaveMsg"].ToString() == "True" ? "1" : "0";
            txtOtherAuthorizedParties.Text = row["NoteOthersAuthorized"].ToString();
            cmbSuspendAccount.SelectedValue = row["FlagAccountSuspend"].ToString() == "True" ? "1" : "0";
            txtReasonForSuspention.Text = row["NoteSuspendReason"].ToString();
            cmbSignedFinancialsOnFile.SelectedValue = row["FlagSignedFinancials"].ToString() == "True" ? "1" : "0";
            cmbAutoAssignBlueCredit.SelectedValue = row["FlagAutoAssignBlueCredit"].ToString() == "True" ? "1" : "0";
            cmbSuspendPaperBilling.SelectedValue = row["FlagSuspendPaperBills"].ToString() == "True" ? "1" : "0";
            txtEmailAddress.Text = row["Email"].ToString();
            if (!string.IsNullOrEmpty(row["DateSuspendPaperBills"].ToString()))
                dtExipratioForSuspention.SelectedDate = Convert.ToDateTime(row["DateSuspendPaperBills"].ToString());
            if (!string.IsNullOrEmpty(row["DateSignedFinancials"].ToString()))
                dtDateOfFilling.SelectedDate = Convert.ToDateTime(row["DateSignedFinancials"].ToString());
            ValidateEmail();
        }
    }



    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            var cmdParams = new Dictionary<string, object>()
                                {
                                    { "@FlagWebAccess", cmbAllowWebAccess.SelectedValue },
                                    { "@FlagLeaveMsg", cmbOkToLeaveMessages.SelectedValue },
                                    { "@NoteOthersAuthorized", txtOtherAuthorizedParties.Text },
                                    { "@FlagAccountSuspend", cmbSuspendAccount.SelectedValue  },
                                    { "@NoteSuspendReason",txtReasonForSuspention.Text },
                                    { "@FlagSignedFinancials", cmbSignedFinancialsOnFile.SelectedValue },
                                    { "@DateSignedFinancials",  dtDateOfFilling.SelectedDate },
                                    { "@FlagAutoAssignBlueCredit", cmbAutoAssignBlueCredit.SelectedValue },
                                    { "@FlagSuspendPaperBills",   cmbSuspendPaperBilling.SelectedValue },
                                    { "@Email",  txtEmailAddress.Text },
                                    { "@DateSuspendPaperBills",dtExipratioForSuspention.SelectedDate },
                                    { "@UserID", ClientSession.UserID },
                                    { "@PatientID", ClientSession.SelectedPatientID}
                                };

            SqlHelper.ExecuteScalarProcedureParams("web_pr_ptpref_add", cmdParams);

            var callbackFunction = ClientSession.IsRedirectToBluecredit.ParseBool() ? "refreshPage" : "redirectToPatientDashboard";
            RadWindow.RadAlert("Record successfully updated.", 350, 150, "", callbackFunction, "../Content/Images/success.png");
        }
        catch (Exception)
        {

            throw;
        }
    }

    private void ValidateEmail()
    {
        rqdEmailAddress.Enabled = cmbSuspendPaperBilling.SelectedValue == ((int)YesNo.Yes).ToString("");
    }
}
