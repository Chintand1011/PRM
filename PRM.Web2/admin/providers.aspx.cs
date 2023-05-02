using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class admin_providers : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindExistingProviders();
        }
    }

    #region Bind Dropdowns

    private void BindExistingProviders()
    {
        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } });
        cmbExistingProvider.DataSource = providers;
        cmbExistingProvider.DataBind();
    }

    private void BindPrimaryLocations()
    {
        var primaryLocations = SqlHelper.ExecuteDataTableProcedureParams("web_pr_location_list", new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } });
        cmbPrimaryLocations.DataSource = primaryLocations;
        cmbPrimaryLocations.DataBind();
    }

    private void BindServicePlaces()
    {
        var servicePlaces = SqlHelper.ExecuteDataTableProcedureParams("web_pr_serviceplace_list", new Dictionary<string, object>());
        cmbServicePlaces.DataSource = servicePlaces;
        cmbServicePlaces.DataBind();
    }

    private void BindServiceClasses()
    {
        var serviceClasses = SqlHelper.ExecuteDataTableProcedureParams("web_pr_serviceclass_list", new Dictionary<string, object>());
        cmbServiceClass.DataSource = serviceClasses;
        cmbServiceClass.DataBind();
    }

    private void BindStatus()
    {
        cmbStatus.Items.Add(new RadComboBoxItem { Text = StatusType.Active.ToString(), Value = ((int)StatusType.Active).ToString() });
        cmbStatus.Items.Add(new RadComboBoxItem { Text = StatusType.InActive.ToString(), Value = ((int)StatusType.InActive).ToString() });
    }

    private void BindDegreeTypes()
    {
        var degreeTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_providertype_list", new Dictionary<string, object>());
        cmbDegreeType.DataSource = degreeTypes;
        cmbDegreeType.DataBind();
    }

    #endregion

    #region Add or Edit existing provider


    private void LoadProviderBasicSetup(bool isFromAdd = false)
    {
        pnlProviderInformation.Visible = true;
        pnlExistingProvider.Enabled = false;
        divRunNew.Visible = false;

        if (isFromAdd)
            pnlExistingProvider.Visible = false;

        BindPrimaryLocations();
        BindServicePlaces();
        BindServiceClasses();
        BindStatus();
        BindDegreeTypes();
    }

    private void GetSelectedProviderInformation()
    {
        var cmdParams = new Dictionary<string, object>()
        {
            { "@ProviderID", cmbExistingProvider.SelectedValue },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            cmbPrimaryLocations.SelectedValue = row["LocationID"].ToString();
            cmbServicePlaces.SelectedValue = row["PlaceofServiceTypeID"].ToString();
            cmbServiceClass.SelectedValue = row["ServiceClassTypeID"].ToString();
            cmbStatus.SelectedValue = Convert.ToBoolean(row["FlagActive"]) != true
                                          ? ((int)StatusType.InActive).ToString("") : ((int)StatusType.Active).ToString("");
            txtDisplayName.Text = string.Format("{0} {1} {2}", row["NameLast"], row["NameFirst"], row["NameMiddle"]);
            txtFirstName.Text = row["NameFirst"].ToString();
            txtMiddleName.Text = row["NameMiddle"].ToString();
            txtLastName.Text = row["NameLast"].ToString();
            cmbDegreeType.SelectedValue = row["ProviderTypeID"].ToString();
            txtNPINumber.Text = row["NPI"].ToString();
            txtCMSMultiplier.Text = row["CMSMultiplier"].ToString();
            txtNotes.Text = row["Notes"].ToString();
        }
    }

    protected void cmbExistingProvider_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        if (!string.IsNullOrEmpty(cmbExistingProvider.SelectedValue))
        {
            LoadProviderBasicSetup();
            GetSelectedProviderInformation();
            btnSubmit.ImageUrl = "../Content/Images/btn_update.gif";
        }
    }

    protected void btnNew_Click(object sender, EventArgs e)
    {
        LoadProviderBasicSetup(true);
        hTitle.Visible = true;
        txtCMSMultiplier.Text = "1.50";
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("providers.aspx");
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {

            var cmdParams = new Dictionary<string, object>() { 
                                                        { "@ProviderID", cmbExistingProvider.SelectedValue},
                                                        { "@PracticeID", ClientSession.PracticeID},
                                                        { "@LocationID", cmbPrimaryLocations.SelectedValue},   
                                                        { "@PlaceofServiceTypeID", cmbServicePlaces.SelectedValue },
                                                        { "@ServiceClassTypeID", cmbServiceClass.SelectedValue },
                                                        { "@FlagActive",cmbStatus.SelectedValue },
                                                        { "@NameFirst", txtFirstName.Text },
                                                        { "@NameMiddle", txtMiddleName.Text },
                                                        { "@NameLast", txtLastName.Text },
                                                        { "@ProviderTypeID",  cmbDegreeType.SelectedValue },
                                                        { "@NPI", txtNPINumber.Text },
                                                        { "@CMSMultiplier",txtCMSMultiplier.Text},
                                                        { "@Notes",txtNotes.Text},
                                                        { "@UserID",ClientSession.UserID}
                                                            };

            SqlHelper.ExecuteScalarProcedureParams("web_pr_provider_add", cmdParams);

            var isAddNewProvider = string.IsNullOrEmpty(cmbExistingProvider.SelectedValue);
            if (!isAddNewProvider)
            {
                (new UserLogin()).ReloadSessionValues(ClientSession.UserID);
            }

            var message = isAddNewProvider ? "Record successfully created." : "Record successfully updated.";
            RadWindow.RadAlert(message, 350, 150, "", "refreshPage", "../Content/Images/success.png");
        }
        catch (Exception)
        {

            throw;
        }
    }

    #endregion

}