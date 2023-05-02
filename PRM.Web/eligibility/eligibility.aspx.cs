using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class eligibility : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                BindEligibilityPayers();
                BindProviders();
            }
            catch (Exception)
            {

                throw;
            }
        }
        popupEligibility.VisibleOnPageLoad = false;
    }

    private void BindEligibilityPayers()
    {
        var payers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_carrier_list", new Dictionary<string, object>());
        cmbEligibilityPayer.DataSource = payers;
        cmbEligibilityPayer.DataBind();
    }

    private void BindProviders()
    {
        var cmdParams = new Dictionary<string, object>() { { "@PracticeID", ClientSession.PracticeID } };
        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);
        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();
    }

    private void BindSubscribers()
    {
        var cmdParams = new Dictionary<string, object>()
                            {
                                {"@CarrierID", cmbEligibilityPayer.SelectedValue},
                                {"@ProviderID", cmbProviders.SelectedValue}
                            };


        var subscribers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_subscriber_list ", cmdParams);
        cmbSubscriber.DataSource = subscribers;
        cmbSubscriber.DataBind();
    }

    private void BindGender()
    {
        cmbGender.Items.Clear();
        cmbGender.Items.Add(new RadComboBoxItem { Text = Gender.Male.ToString(), Value = ((int)Gender.Male).ToString() });
        cmbGender.Items.Add(new RadComboBoxItem { Text = Gender.Female.ToString(), Value = ((int)Gender.Female).ToString() });
    }

    private void BindRelationShipTypes()
    {
        var relationshipTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_relationtype_list", new Dictionary<string, object>());
        cmbRelation.DataSource = relationshipTypes;
        cmbRelation.DataBind();
    }

    protected void cmbEligibilityPayer_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {

            var cmdParams = new Dictionary<string, object>
            {
                { "@CarrierID", cmbEligibilityPayer.SelectedValue },
                { "@UserID", ClientSession.UserID}
            };
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_carrier_get", cmdParams);
            foreach (DataRow row in reader.Rows)
            {
                txtCarrierName.Text = row["CarrierName"].ToString();
                txtPayerGroup.Text = row["CarrierGroupAbbr"].ToString();
                txtPolicyType.Text = row["CarrierPolicyTypeAbbr"].ToString();
                txtEdiRequired.Text = row["FlagEDIReqEnrollAbbr"].ToString();
                txtRegisteredState.Text = row["CarrierStateAbbr"].ToString();
            }
            ClearSubscriberSection();
            BindSubscribers();
            cmbProviders.Enabled = true;
        }
        catch (Exception)
        {

            throw;
        }
    }

    protected void cmbProviders_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            var cmdParams = new Dictionary<string, object>
            {
                { "@ProviderID", cmbProviders.SelectedValue },
                { "@UserID", ClientSession.UserID}
            };
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_get", cmdParams);
            foreach (DataRow row in reader.Rows)
            {
                txtPractice.Text = row["PracticeName"].ToString();
                txtProviderID.Text = row["ProviderID"].ToString();
            }
            ClearSubscriberSection();
            BindSubscribers();
            cmbSubscriber.Enabled = true;
        }
        catch (Exception)
        {

            throw;
        }
    }

    protected void cmbSubscriber_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            var cmdParams = new Dictionary<string, object>()
                                {
                                    {"@PatientID", cmbSubscriber.SelectedValue},
                                    {"@UserID", ClientSession.UserID}
                                };

            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_subscriber_get ", cmdParams);
            foreach (DataRow row in reader.Rows)
            {
                txtLastName.Text = row["SubNameLast"].ToString();
                txtFirstName.Text = row["SubNameFirst"].ToString();

                dtDateofBirth.SelectedDate = Convert.ToDateTime(row["SubDateofBirth"]);
                txtSubscriberID.Text = row["SubscriberID"].ToString();
                txtGroupNumber.Text = row["GroupID"].ToString();

                cmbGender.SelectedValue = row["GenderID"].ToString();
                cmbRelation.SelectedValue = row["RelTypeID"].ToString();
                dtServiceDate.SelectedDate = DateTime.Now;
            }
        }
        catch (Exception)
        {
            //throw;
        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        var isValidated = Validator.ValidateCreditCheck(radWindowDialog);
        if (!isValidated)
            return;

        Eligibility eligibility;
        var npiID = GetSelectedProviderNPI();
        Int32 iPlexPayerID;
        //string  subscriberIDCode;
        iPlexPayerID = GetSelectedEligibilityValue();
        //GetSelectedSubscriberValues(out relationTypeID, out subscriberIDCode);
        var patientID = -1;
        if (!string.IsNullOrEmpty(cmbSubscriber.SelectedValue)) patientID = Convert.ToInt32(cmbSubscriber.SelectedValue);

        eligibility = new Eligibility(Convert.ToDateTime(dtServiceDate.SelectedDate), Convert.ToDateTime(dtServiceDate.SelectedDate), patientID, txtFirstName.Text.Trim(), txtLastName.Text.Trim(), txtSubscriberID.Text.Trim(), dtDateofBirth.SelectedDate != null ? Convert.ToDateTime(dtDateofBirth.SelectedDate).ToString("yyyyMMdd") : string.Empty, cmbRelation.SelectedValue, npiID, Convert.ToInt32(cmbEligibilityPayer.SelectedValue), iPlexPayerID);
        //E_obj.Message

        if (eligibility.Success) //Eligibility was processed successfully.
        {
            ClientSession.ObjectID = eligibility.EligibilityID;
            ClientSession.ObjectType = ObjectType.EligibilityDetail;
            popupEligibility.VisibleOnPageLoad = true;
        }
        else
        {
            radWindowDialog.RadAlert(eligibility.Message, 500, 150, string.Empty, string.Empty);
            //string Message = eligibility.Message; //in case error message should be displayed
        }

    }


    private Int32 GetSelectedProviderNPI()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@ProviderID", cmbProviders.SelectedValue },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_get", cmdParams);
        var npiID = 0;
        foreach (DataRow row in reader.Rows)
        {
            npiID = Convert.ToInt32(row["NPI"]);
        }
        return npiID;
    }

    private int GetSelectedEligibilityValue()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@CarrierID", cmbEligibilityPayer.SelectedValue },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_carrier_get", cmdParams);
        var iPlexPayerID = 0;
        foreach (DataRow row in reader.Rows)
        {
            iPlexPayerID = Convert.ToInt32(row["iPlexPayerID"]);
        }
        return iPlexPayerID;
    }

    //private void GetSelectedSubscriberValues(out Int32 relTypeID, out string subscriberIDCode)
    //{
    //    var cmdParams = new Dictionary<string, object>()
    //                            {  {"@PatientID", cmbSubscriber.SelectedValue}  };
    //    relTypeID = 0;
    //    subscriberIDCode = string.Empty;
    //    var selectedPayer = SqlHelper.ExecuteDataTableProcedureParams("web_pr_subscriber_get", cmdParams);
    //    if (selectedPayer.Read())
    //    {
    //        relTypeID = Convert.ToInt32(selectedPayer["RelTypeID"]);
    //        subscriberIDCode = selectedPayer["SubscriberID"].ToString();
    //    }
    //    selectedPayer.Close();
    //}

    private void ClearSubscriberSection()
    {
        txtLastName.Text = string.Empty;
        txtFirstName.Text = string.Empty;
        txtSubscriberID.Text = string.Empty;
        txtGroupNumber.Text = string.Empty;

        cmbSubscriber.Text = string.Empty;
        cmbRelation.Text = string.Empty;
        cmbGender.Text = string.Empty;

        BindRelationShipTypes();
        BindGender();

        dtDateofBirth.SelectedDate = null;
        dtServiceDate.SelectedDate = DateTime.Now;
    }
}