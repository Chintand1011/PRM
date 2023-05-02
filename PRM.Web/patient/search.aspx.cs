using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;


public partial class search : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindLocations();
            BindProviders();
            BindStatusTypes();
        }

        if (ClientSession.ObjectType == ObjectType.RefreshPage)
        {
            ClientSession.ObjectType = null;
            popupPayLite.VisibleOnPageLoad = true;
        }
        else
        {
            popupPayLite.VisibleOnPageLoad = false;
        }

    }


    private void BindLocations()
    {
        var cmdParams = new Dictionary<string, object> {
        {"@PracticeID", ClientSession.PracticeID}, };
        var locations = SqlHelper.ExecuteDataTableProcedureParams("web_pr_location_list", cmdParams);
        locations.InsertValueIntoDataTable(0, "LocationID", "Abbr", null, "All Locations");
        cmbLocations.DataSource = locations;
        cmbLocations.DataBind();

        if (ClientSession.FlagPtSearchLocationDefault)
            cmbLocations.SelectedValue = ClientSession.DefaultLocationID.ToString();

    }

    private void BindProviders()
    {
        var cmdParams = new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } };
        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);
        providers.InsertValueIntoDataTable(0, "ProviderID", "ProviderAbbr", null, "All Providers");
        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();

        if (ClientSession.FlagPtSearchProviderDefault)
            cmbProviders.SelectedValue = ClientSession.DefaultProviderID.ToString();

    }

    private void BindStatusTypes()
    {
        var cmdParams = new Dictionary<string, object>();
        var statusTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statustype_list", cmdParams);
        statusTypes.InsertValueIntoDataTable(0, "StatusTypeID", "Abbr", null, "All Statuses");
        cmbStatusTypes.DataSource = statusTypes;
        cmbStatusTypes.DataBind();

        if (ClientSession.FlagPtSearchActiveDefault)
            cmbStatusTypes.SelectedIndex = 1; // 1 index means second record

    }

    private DataTable GetPatients()
    {
        if (!Page.IsPostBack)
            return new DataTable();

        var statusType = string.IsNullOrEmpty(cmbStatusTypes.SelectedValue) ? "-1" : cmbStatusTypes.SelectedValue;

        var patients = new DataTable();
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@LastName", txtLastName.Text.Trim()},
                                {"@FirstName", txtFirstName.Text.Trim()},
                                {"@DOB",  dtDOB.SelectedDate},
                                {"@PatientID", txtSocialMRN.Text.Trim()},
                                {"@PhoneNum", txtPhoneNumber.Text.Trim()},
                                {"@LocationID", cmbLocations.SelectedValue},
                                {"@ProviderID", cmbProviders.SelectedValue},
                                {"@StatusTypeID", statusType}
                                };

        patients = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_search", cmdParams);
        hdnDate.Value = string.Empty;
        return patients;
    }

    protected void grdPatients_ItemCommand(object source, GridCommandEventArgs e)
    {
        try
        {
            switch (e.CommandName)
            {
                case "EditPatient":
                    {
                        ClientSession.SelectedPatientID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientID"]);
                        ClientSession.SelectedPatientAccountID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["AccountID"]);
                        (new UserLogin()).LoadPatientIntoSession();
                        Response.Redirect("manage.aspx");
                        break;
                    }
                case "RowClick":
                    {
                        ClientSession.SelectedPatientID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientID"]);
                        ClientSession.SelectedPatientAccountID = Convert.ToInt32(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["AccountID"]);
                        (new UserLogin()).LoadPatientIntoSession();
                        Response.Redirect("status.aspx");
                        break;
                    }
                case "AWV":
                    {
                        var awvUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["AWVSurveyURL"].ToString();
                        Response.Redirect(awvUrl);
                        break;
                    }
                case "PHQ":
                    {
                        var phqUrl = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PHQSurveyURL"].ToString();
                        Response.Redirect(phqUrl);
                        break;
                    }
            }
        }
        catch (Exception)
        {
            throw;
        }
    }

    protected void grdPatients_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            SetAwvAndPhqImages(item);
        }
    }

    private void SetAwvAndPhqImages(GridDataItem item)
    {
        var awvSurveyStatusTypeID = item.GetDataKeyValue("AWVSurveyStatusTypeID").ParseInteger();
        var phqSurveyStatusTypeID = item.GetDataKeyValue("PHQSurveyStatusTypeID").ParseInteger();

        var amwImageButton = (item["AWV"].Controls[0] as ImageButton);
        if (awvSurveyStatusTypeID == 0)
        {
            amwImageButton.ImageUrl = "~/content/Images/icon_dash.png";
            amwImageButton.CssClass = "cursor-default";
            amwImageButton.Enabled = false;
        }

        if (awvSurveyStatusTypeID == 1)
        {
            amwImageButton.ImageUrl = "~/content/Images/toolbar_forward.gif";
        }

        if (awvSurveyStatusTypeID == 2)
        {
            amwImageButton.ImageUrl = "~/content/Images/icon_pdfblue.gif";
        }

        
        var phqImageButton = (item["PHQ"].Controls[0] as ImageButton);
        if (phqSurveyStatusTypeID == 0)
        {
            phqImageButton.ImageUrl = "~/content/Images/icon_dash.png";
            phqImageButton.CssClass = "cursor-default";
            phqImageButton.Enabled = false;
        }

        if (phqSurveyStatusTypeID == 1)
        {
            phqImageButton.ImageUrl = "~/content/Images/toolbar_forward.gif";
        }

        if (phqSurveyStatusTypeID == 2)
        {
            phqImageButton.ImageUrl = "~/content/Images/icon_pdfblue.gif";
        }
    }

    protected void grdPatients_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdPatients.DataSource = GetPatients();
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        grdPatients.Rebind();
    }

    protected void btnAddNewPatient_Click(object sender, EventArgs e)
    {
        ClearClientSession();
        Response.Redirect("manage.aspx");
    }

    protected void btnAddPayPatient_OnClick(object sender, EventArgs e)
    {
        ClearClientSession();
        ClientSession.ObjectType = ObjectType.RefreshPage;
        Response.Redirect("search.aspx");
    }

    private void ClearClientSession()
    {
        Extension.ClientSession.SelectedPatientID = 0;
        Extension.ClientSession.PatientFirstName = null;
        Extension.ClientSession.PatientLastName = null;
    }

    protected void btnClear_OnClick(object sender, EventArgs e)
    {
        txtLastName.Text = string.Empty;
        txtFirstName.Text = string.Empty;
        txtSocialMRN.Text = string.Empty;
        txtPhoneNumber.Text = string.Empty;
        dtDOB.Clear();
        cmbStatusTypes.ResetSelection(false);
        cmbLocations.ResetSelection(false);
        cmbProviders.ResetSelection(false);

        // clear the grid
        grdPatients.DataSource = new List<string>();
        grdPatients.Rebind();
    }
}