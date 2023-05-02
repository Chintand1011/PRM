using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;

public partial class requestpatientbenefit_popup : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                ClientSession.WasRequestFromPopup = true;

                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.RequestPatientBenefit)
                {
                    GetInitialBasicInformation();
                }

            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    private void GetInitialBasicInformation()
    {
        var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.ObjectID },
                                    { "@UserID", ClientSession.UserID}
                                };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            //Transaction Details
            txtLastName.Text = row["NameLast"].ToString();
            txtFirstName.Text = row["NameFirst"].ToString();
            dtDateofBirth.SelectedDate = Convert.ToDateTime(row["DateofBirth"]);
            txtGender.Text = row["GenderAbbr"].ToString();
            txtSSN.Text = CryptorEngine.Decrypt(row["PatientSSNenc"].ToString());

            txtCarrier.Text = row["InsName"].ToString();
            txtProvider.Text = row["ProviderName"].ToString();
            txtSubscriberID.Text = row["SubscriberIDCode"].ToString();
            txtGroupNumber.Text = row["SubscriberGroupCode"].ToString();
            txtRelationship.Text = row["InsRelTypeAbbr"].ToString();
            hdnSubscriberIDCode.Value = row["SubscriberIDCode"].ToString();
            hdnProviderIDCode.Value = row["ProviderIDCode"].ToString();
            hdnPayerID.Value = row["PayerID"].ToString();
            hdnPayerIDCode.Value = row["PayerIDCode"].ToString();
            hdnRelationShipTypeID.Value = row["SubscriberRelationCode"].ToString();
        }
        
        ManageValidations();
    }


    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            var eligibility = new Eligibility(DateTime.Now, DateTime.Now, Convert.ToInt32(ClientSession.ObjectID), txtFirstName.Text.Trim(), txtLastName.Text.Trim(),
                                              hdnSubscriberIDCode.Value, dtDateofBirth.SelectedDate != null ? Convert.ToDateTime(dtDateofBirth.SelectedDate).ToString("yyyyMMdd") : string.Empty,
                                              hdnRelationShipTypeID.Value.ToString(), Convert.ToInt32(hdnProviderIDCode.Value), Convert.ToInt32(hdnPayerID.Value), Convert.ToInt32(hdnPayerIDCode.Value));

            if (eligibility.Success) //Eligibility was processed successfully.
            {
                ClientSession.ObjectID = eligibility.EligibilityID;
                ClientSession.ObjectType = ObjectType.EligibilityDetail;
                // Refreshing the Parent Page
                ClientScript.RegisterStartupScript(Page.GetType(), "mykey", "openEligibilityDetailPopup();", true);
            }
            else
            {
                windowManager.RadAlert(eligibility.Message.Replace(",", ""), 350, 150, "", "", "/Content/Images/warning.png");
            }
        }
        catch (Exception)
        {
            throw;
        }
    }

    private void ManageValidations()
    {
        if (!string.IsNullOrEmpty(txtSubscriberID.Text)) return;
        btnSubmit.Enabled = false;
        btnSubmit.ImageUrl = "../Content/Images/btn_submit_fade.gif";

        // Showing message to the user that:
        // Please update the patient's Insurance information before submitting the eligibility request.
        divMessage.Visible = true;
    }
}