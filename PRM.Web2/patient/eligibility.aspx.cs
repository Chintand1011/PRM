using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class eligibility : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.EligibilityDetail)
                {
                    popupEligibility.VisibleOnPageLoad = true;
                    popupRequestBenefit.VisibleOnPageLoad = false;
                }

                ValidateAndShowEligibilityPopup();

            }
            catch (Exception)
            {

                throw;
            }
        }
        else
        {
            popupEligibility.VisibleOnPageLoad = false;
            popupRequestBenefit.VisibleOnPageLoad = false;
        }
    }

    private void ValidateAndShowEligibilityPopup()
    {
        var param = Request.Params["rn"];
        if (!string.IsNullOrEmpty(param)) // rn means RUN NEW event
        {
            ShowEligibilityPopup();
        }
    }

    protected void grdEligibilityHistory_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", ClientSession.SelectedPatientID},
                                { "@UserID", ClientSession.UserID}
                                };

        var eligibilityHistory = SqlHelper.ExecuteDataTableProcedureParams("web_pr_eligibility_get", cmdParams);
        grdEligibilityHistory.DataSource = eligibilityHistory;
    }

    protected void grdEligibilityHistory_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "ViewEligilityInfo":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["EligibilityID"];
                ClientSession.ObjectType = ObjectType.EligibilityDetail;
                popupEligibility.VisibleOnPageLoad = true;
                popupRequestBenefit.VisibleOnPageLoad = false;
                break;

        }
    }

    protected void cmbPatients_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            grdEligibilityHistory.Rebind();
            popupEligibility.VisibleOnPageLoad = false;
            popupRequestBenefit.VisibleOnPageLoad = false;
        }
        catch (Exception)
        {

            throw;
        }
    }

    protected void btnRunNew_Click(object sender, EventArgs e)
    {
        ShowEligibilityPopup();
    }

    private void ShowEligibilityPopup()
    {
        ClientSession.ObjectID = ClientSession.SelectedPatientID;
        ClientSession.ObjectType = ObjectType.RequestPatientBenefit;
        popupRequestBenefit.VisibleOnPageLoad = true;
        popupEligibility.VisibleOnPageLoad = false;
    }

}