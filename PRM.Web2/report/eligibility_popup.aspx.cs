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
using Telerik.Web.UI;

public partial class report_eligibility_popup : BasePage
{

    #region Table Properties

    public string Elig_Prof_CoPay_Ind_IN_Visit;
    public string Elig_Prof_CoIns_Ind_IN_Visit;
    public string Elig_Prof_CoPay_Ind_OoN_Visit;
    public string Elig_Prof_CoIns_Ind_OoN_Visit;

    public string Elig_HBP_Ded_Ind_IN_CY;
    public string Elig_HBP_Ded_Ind_IN_YTD;
    public string Elig_HBP_Ded_Ind_IN_Rem;

    public string Elig_HBP_Ded_Fam_IN_CY;
    public string Elig_HBP_Ded_Fam_IN_YTD;
    public string Elig_HBP_Ded_Fam_IN_Rem;


    public string Elig_HBP_Ded_Ind_OoN_CY;
    public string Elig_HBP_Ded_Ind_OoN_YTD;
    public string Elig_HBP_Ded_Ind_OoN_Rem;

    public string Elig_HBP_Ded_Fam_OoN_CY;
    public string Elig_HBP_Ded_Fam_OoN_YTD;
    public string Elig_HBP_Ded_Fam_OoN_Rem;


    public string Elig_HBP_OoP_Ind_IN_CY;
    public string Elig_HBP_OoP_Ind_IN_YTD;
    public string Elig_HBP_OoP_Ind_IN_Rem;

    public string Elig_HBP_OoP_Fam_IN_CY;
    public string Elig_HBP_OoP_Fam_IN_YTD;
    public string Elig_HBP_OoP_Fam_IN_Rem;


    public string Elig_HBP_OoP_Ind_OoN_CY;
    public string Elig_HBP_OoP_Ind_OoN_YTD;
    public string Elig_HBP_OoP_Ind_OoN_Rem;

    public string Elig_HBP_OoP_Fam_OoN_CY;
    public string Elig_HBP_OoP_Fam_OoN_YTD;
    public string Elig_HBP_OoP_Fam_OoN_Rem;

    #endregion


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // Closing the popup in case of any error 
                ClientSession.WasRequestFromPopup = true;
                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.EligibilityDetail)
                {
                    GetEligibilityInformation();
                    ClientSession.ObjectID = null;
                    ClientSession.ObjectType = null;
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    private void GetEligibilityInformation()
    {
        var cmdParams = new Dictionary<string, object>
                                {
                                    { "@EligibilityID", ClientSession.ObjectID },
                                    { "@UserID", ClientSession.UserID}
                                };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_eligibility_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            //Transaction Details
            lblSubmitDate.Text = row["ServiceDate"].ToString();
            lblSubmitID.Text = row["EligibilityID"].ToString();
            lblTraceNumber.Text = row["Resp_RefIdent"].ToString();
            lblCarrier.Text = row["CarrierName"].ToString();
            lblProvider.Text = row["ProviderName"].ToString();
            lblProviderNPI.Text = row["ProviderIDCode"].ToString();

            //Subscription Information
            lblSubscriber.Text = row["SubscriberName"].ToString();
            lblDateofBirth.Text = row["DateofBirth"].ToString();
            lblGender.Text = row["GenderAbbr"].ToString();
            lblAddress1.Text = row["SubscriberAddr1"].ToString();
            lblAddress2.Text = row["SubscriberAddr2"].ToString();
            lblMemberID.Text = row["SubscriberIDCode"].ToString();
            lblGroupNumber.Text = row["GroupID"].ToString();
            lblSSN.Text = CryptorEngine.Decrypt(row["SubSSNenc"].ToString());

            lblRelationship.Text = row["RelationshipType"].ToString();
            lblCoverageClass.Text = row["SubscriberStatus"].ToString();
            lblDependentType.Text = row["RelationshipType"].ToString();
            lblDependentName.Text = row["SubscriberName"].ToString();
            lblDependentDateofBirth.Text = row["DateofBirth"].ToString();
            lblDependentGender.Text = row["GenderAbbr"].ToString();

            //Benefit Coverage
            lblPlanBeginDate.Text = row["HBP_Start_Date"].ToString();
            lblPlanType.Text = row["SubscriberStatus"].ToString();

            txtPlanDescription.Text = row["HBP_Desc"].ToString();
            lblBenefitStatus.Text = row["HBP_Status_Gen"].ToString();
            SetBenefitStatusColor((int)row["Elig_Status_Color"]);
            lblNetworkStatus.Text = row["ProviderStatus"].ToString();

            //Table section
            lblResDateTime.Text = row["ServiceDate"] + " " + row["ServiceTime"];

            Elig_Prof_CoPay_Ind_IN_Visit = row["Elig_Prof_CoPay_Ind_IN_Visit"].ToString();
            Elig_Prof_CoIns_Ind_IN_Visit = row["Elig_Prof_CoIns_Ind_IN_Visit"].ToString();
            Elig_Prof_CoPay_Ind_OoN_Visit = row["Elig_Prof_CoPay_Ind_OoN_Visit"].ToString();
            Elig_Prof_CoIns_Ind_OoN_Visit = row["Elig_Prof_CoIns_Ind_OoN_Visit"].ToString();
            Elig_HBP_Ded_Ind_IN_CY = row["Elig_HBP_Ded_Ind_IN_CY"].ToString();
            Elig_HBP_Ded_Ind_IN_YTD = row["Elig_HBP_Ded_Ind_IN_YTD"].ToString();
            Elig_HBP_Ded_Ind_IN_Rem = row["Elig_HBP_Ded_Ind_IN_Rem"].ToString();
            Elig_HBP_Ded_Fam_IN_CY = row["Elig_HBP_Ded_Fam_IN_CY"].ToString();
            Elig_HBP_Ded_Fam_IN_YTD = row["Elig_HBP_Ded_Fam_IN_YTD"].ToString();
            Elig_HBP_Ded_Fam_IN_Rem = row["Elig_HBP_Ded_Fam_IN_Rem"].ToString();
            Elig_HBP_Ded_Ind_OoN_CY = row["Elig_HBP_Ded_Ind_OoN_CY"].ToString();
            Elig_HBP_Ded_Ind_OoN_YTD = row["Elig_HBP_Ded_Ind_OoN_YTD"].ToString();
            Elig_HBP_Ded_Ind_OoN_Rem = row["Elig_HBP_Ded_Ind_OoN_Rem"].ToString();
            Elig_HBP_Ded_Fam_OoN_CY = row["Elig_HBP_Ded_Fam_OoN_CY"].ToString();
            Elig_HBP_Ded_Fam_OoN_YTD = row["Elig_HBP_Ded_Fam_OoN_YTD"].ToString();
            Elig_HBP_Ded_Fam_OoN_Rem = row["Elig_HBP_Ded_Fam_OoN_Rem"].ToString();
            Elig_HBP_OoP_Ind_IN_CY = row["Elig_HBP_OoP_Ind_IN_CY"].ToString();
            Elig_HBP_OoP_Ind_IN_YTD = row["Elig_HBP_OoP_Ind_IN_YTD"].ToString();
            Elig_HBP_OoP_Ind_IN_Rem = row["Elig_HBP_OoP_Ind_IN_Rem"].ToString();
            Elig_HBP_OoP_Fam_IN_CY = row["Elig_HBP_OoP_Fam_IN_CY"].ToString();
            Elig_HBP_OoP_Fam_IN_YTD = row["Elig_HBP_OoP_Fam_IN_YTD"].ToString();
            Elig_HBP_OoP_Fam_IN_Rem = row["Elig_HBP_OoP_Fam_IN_Rem"].ToString();
            Elig_HBP_OoP_Ind_OoN_CY = row["Elig_HBP_OoP_Ind_OoN_CY"].ToString();
            Elig_HBP_OoP_Ind_OoN_YTD = row["Elig_HBP_OoP_Ind_OoN_YTD"].ToString();
            Elig_HBP_OoP_Ind_OoN_Rem = row["Elig_HBP_OoP_Ind_OoN_Rem"].ToString();
            Elig_HBP_OoP_Fam_OoN_CY = row["Elig_HBP_OoP_Fam_OoN_CY"].ToString();
            Elig_HBP_OoP_Fam_OoN_YTD = row["Elig_HBP_OoP_Fam_OoN_YTD"].ToString();
            Elig_HBP_OoP_Fam_OoN_Rem = row["Elig_HBP_OoP_Fam_OoN_Rem"].ToString();


            //Bottom Section
            var chiroPractic = new RadPanelItem("Chiropractic");
            chiroPractic.Items.Add(new RadPanelItem("Status: " + row["hbp_status_chiro"]));

            var hospital = new RadPanelItem("Hospital");
            hospital.Items.Add(new RadPanelItem("Status: " + row["hbp_status_hos"]));

            var hospitalIn = new RadPanelItem("Hospital In-Patient");
            hospitalIn.Items.Add(new RadPanelItem("Status: " + row["hbp_status_hosip"]));

            var hospitalOut = new RadPanelItem("Hospital Out-Patient");
            hospitalOut.Items.Add(new RadPanelItem("Status: " + row["hbp_status_hosop"]));

            var emergencyCare = new RadPanelItem("Emergency Care");
            emergencyCare.Items.Add(new RadPanelItem("Status: " + row["hbp_status_emerg"]));

            var professional = new RadPanelItem("Professional");
            professional.Items.Add(new RadPanelItem("Status: " + row["hbp_status_prof"]));

            var visual = new RadPanelItem("Visual");
            visual.Items.Add(new RadPanelItem("Status: " + row["hbp_status_vis"]));

            var dental = new RadPanelItem("Dental");
            dental.Items.Add(new RadPanelItem("Status: " + row["hbp_status_dent"]));

            var generalMedical = new RadPanelItem("General Mecical");
            generalMedical.Items.Add(new RadPanelItem("Status: " + row["hbp_status_med"]));

            panelCoverage.Items.Add(chiroPractic);
            panelCoverage.Items.Add(hospital);
            panelCoverage.Items.Add(hospitalIn);
            panelCoverage.Items.Add(hospitalOut);
            panelCoverage.Items.Add(emergencyCare);
            panelCoverage.Items.Add(professional);
            panelCoverage.Items.Add(visual);
            panelCoverage.Items.Add(dental);
            panelCoverage.Items.Add(generalMedical);
        }
    }

    private void SetBenefitStatusColor(Int32 statusID)
    {
        switch (statusID)
        {
            case 1:
                lblBenefitStatus.ForeColor = Color.Green;
                break;
            case 2:
                lblBenefitStatus.ForeColor = Color.Yellow;
                break;
            case 3:
                lblBenefitStatus.ForeColor = Color.Red;
                break;
        }

    }
}