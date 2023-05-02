using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class locations : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            BindLocations();
            BindStates();
            BindStatus();
        }
    }

    #region Bind Dropdowns

    private void BindLocations()
    {
        var locations = SqlHelper.ExecuteDataTableProcedureParams("web_pr_location_list", new Dictionary<string, object>() { { "@PracticeID", ClientSession.PracticeID } });
        cmbLocations.DataSource = locations;
        cmbLocations.DataBind();
    }
    
    private void BindStates()
    {
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", new Dictionary<string, object>());
        cmbStates.DataSource = states;
        cmbStates.DataBind();
    }
    
    private void BindStatus()
    {
        cmbStatus.Items.Add(new RadComboBoxItem { Text = StatusType.Active.ToString(), Value = ((int)StatusType.Active).ToString() });
        cmbStatus.Items.Add(new RadComboBoxItem { Text = StatusType.InActive.ToString(), Value = ((int)StatusType.InActive).ToString() });
    }
    
    #endregion

    #region Add or Edit Existing Location

    private void LoadProviderBasicSetup(bool isFromAdd = false)
    {
        pnlProviderInformation.Visible = true;
        pnlLocations.Enabled = false;
        divNew.Visible = false;

        if (isFromAdd)
            pnlLocations.Visible = false;
    }

    private void GetSelectedLocationInformation()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@LocationID", cmbLocations.SelectedValue },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_location_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            txtLocationName.Text = row["LocationName"].ToString();
            txtNameAbbreviation.Text = row["LocationAbbr"].ToString();
            txtOfficeManager.Text = row["OfficeMgrName"].ToString();
            txtAddress1.Text = row["Addr1"].ToString();
            txtAddress2.Text = row["Addr2"].ToString();
            txtCity.Text = row["City"].ToString();
            cmbStates.SelectedValue = row["StateTypeID"].ToString();
            txtZipCode1.Text = row["Zip"].ToString();
            txtZipCode2.Text = row["Zip4"].ToString();
            txtPhonePrimary.Text = row["PhonePri"].ToString();
            txtPhoneSecondary.Text = row["PhoneSec"].ToString();
            txtFaxNumber.Text = row["Fax"].ToString();
            chkPrimaryLocation.Checked = row["FlagPrimary"].ToString() == "True" ? true : false;
            cmbStatus.SelectedValue = row["FlagActive"].ToString() == "True" ? "1" : "0";
            txtNotes.Text = row["Notes"].ToString();
        }
    }

    protected void cmbLocations_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        if (!string.IsNullOrEmpty(cmbLocations.SelectedValue))
        {
            LoadProviderBasicSetup();
            GetSelectedLocationInformation();
            btnSubmit.ImageUrl = "../Content/Images/btn_update.gif";
        }
    }

    protected void btnNew_Click(object sender, EventArgs e)
    {
        hTitle.Visible = true;
        cmbLocations.ClearSelection();
        LoadProviderBasicSetup(true);
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("locations.aspx");
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {

            var cmdParams = new Dictionary<string, object>() { 
                                                        { "@LocationName ", txtLocationName.Text},
                                                        { "@LocationAbbr ", txtNameAbbreviation.Text},
                                                        { "@OfficeMgrName ",txtOfficeManager.Text},    
                                                        { "@Addr1 ", txtAddress1.Text },
                                                        { "@Addr2 ", txtAddress2.Text },
                                                        { "@City ",txtCity.Text },
                                                        { "@StateTypeID ", cmbStates.SelectedValue },
                                                        { "@Zip ", txtZipCode1.Text},
                                                        { "@Zip4 ", txtZipCode2.Text },
                                                        { "@PhonePri ",  txtPhonePrimary.Text},
                                                        { "@PhoneSec ", txtPhoneSecondary.Text},
                                                        { "@Fax ", txtFaxNumber.Text},
                                                        { "@FlagPrimary", chkPrimaryLocation.Checked ? "True" : "False"},
                                                        { "@FlagActive  ", cmbStatus.SelectedValue },
                                                        { "@Notes  ",txtNotes.Text },
                                                        { "@PracticeID", ClientSession.PracticeID},
                                                        { "@UserID", ClientSession.UserID}
                                                            };

            if (!string.IsNullOrEmpty(cmbLocations.SelectedValue))
            {
                cmdParams.Add("@LocationID", cmbLocations.SelectedValue);
            }

            SqlHelper.ExecuteScalarProcedureParams("web_pr_location_add", cmdParams);
            var isAddNewLocation = string.IsNullOrEmpty(cmbLocations.SelectedValue);
            if (!isAddNewLocation)
            {
                (new UserLogin()).ReloadSessionValues(ClientSession.UserID);
            }


            var message = isAddNewLocation ? "Record successfully created." : "Record successfully updated.";
            RadWindow.RadAlert(message, 350, 150, "", "refreshPage", "../Content/Images/success.png");
        }
        catch (Exception)
        {

            throw;
        }
    }

    #endregion

   
}