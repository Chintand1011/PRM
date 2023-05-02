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

public partial class users : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        litMessage.Text = String.Empty;
        if (IsPostBack) return;
        BindStatusTypes();
        BindAccountTypes();
        BindSecurityQuestions();
        BindLandingPages();
        ShowSelectedUser();

        // Only Manager and Administrator can add user those have roleTypeID greater than 3,
        if (ClientSession.RoleTypeID == (int)RoleType.User || ClientSession.RoleTypeID == (int)RoleType.Reporting
                                                           || ClientSession.RoleTypeID == (int)RoleType.ReadOnly
                                                           || ClientSession.RoleTypeID == (int)RoleType.Billing)
            btnAddNew.Visible = false;

    }


    #region Grid Operations

    protected void grdUsers_ItemCommand(object source, GridCommandEventArgs e)
    {
        try
        {
            switch (e.CommandName)
            {
                case "EditUser":
                    {
                        hdnSysUserID.Value = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["SysUserID"].ToString();
                        ShowUserPanel();
                        ShowHideandValidateFields(false);
                        break;
                    }
            }
        }
        catch (Exception)
        {
            throw;
        }
    }

    protected void grdUsers_ItemDataBound(object sender, GridItemEventArgs e)
    {

        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var roleTypeID = Convert.ToInt32(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["RoleTypeID"]);
            var sysUserID = Convert.ToInt32(item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["SysUserID"]);

            if (ClientSession.RoleTypeID > 3)
            {
                item["Modify"].Enabled = roleTypeID <= ClientSession.RoleTypeID;
            }
            else
            {
                item["Modify"].Enabled = sysUserID == ClientSession.UserID;
            }

            (item["Modify"].Controls[0] as ImageButton).ImageUrl = item["Modify"].Enabled ? "~/Content/Images/edit.png" : "~/Content/Images/icon_cancelx_fade.gif";

        }
    }

    protected void grdUsers_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdUsers.DataSource = GetUsers();
    }

    protected DataTable GetUsers()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID",ClientSession.PracticeID},
                                {"@FlagInactive", chkShowInActiveUsers.Checked},
                                {"@UserID", ClientSession.UserID}
                            };
        var users = SqlHelper.ExecuteDataTableProcedureParams("web_pr_user_get", cmdParams);
        return users;
    }

    #endregion

    #region Bind Dropdowns

    private void BindStatusTypes()
    {
        cmbStatusTypes.Items.Add(new RadComboBoxItem { Text = StatusType.Active.ToString(), Value = ((int)StatusType.Active).ToString() });
        cmbStatusTypes.Items.Add(new RadComboBoxItem { Text = StatusType.InActive.ToString(), Value = ((int)StatusType.InActive).ToString() });
    }

    private void BindAccountTypes()
    {
        var cmdParams = new Dictionary<string, object> { { "@UserID", ClientSession.UserID }, { "@SysUserID", string.IsNullOrEmpty(hdnSysUserID.Value) ? (object)DBNull.Value : Convert.ToInt32(hdnSysUserID.Value) } };
        var roleTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_roletype_list", cmdParams);

        cmbAccountTypes.DataSource = roleTypes;
        cmbAccountTypes.DataBind();
    }

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

    private void BindSecurityQuestions()
    {
        var cmdParams = new Dictionary<string, object>();
        var securityQuestions = SqlHelper.ExecuteDataTableProcedureParams("web_pr_securityquestiontype_list", cmdParams);

        cmbSecurityQuestion.DataSource = securityQuestions;
        cmbSecurityQuestion.DataBind();
    }

    private void BindLandingPages()
    {
        var cmdParams = new Dictionary<string, object> { { "@SysUserID", string.IsNullOrEmpty(hdnSysUserID.Value) ? (object)DBNull.Value : Convert.ToInt32(hdnSysUserID.Value) } };
        var pageOptions = SqlHelper.ExecuteDataTableProcedureParams("web_pr_landingpage_list", cmdParams);

        cmbLandingPages.DataSource = pageOptions;
        cmbLandingPages.DataBind();
    }
    
    protected void chkShowInActiveUsers_OnCheckChanged(object sender, EventArgs e)
    {
        grdUsers.Rebind();
    }

    #endregion

    #region Show User Details and Add or Edit User

    private void ShowUserDetails()
    {
        // Re-Bind the AccountType Dropdown
        BindAccountTypes();
        BindExistingProviders();
        BindPrimaryLocations();
        BindLandingPages();

        var cmdParams = new Dictionary<string, object>
                            {
                                {"@SysUserID", Convert.ToInt32(hdnSysUserID.Value)},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@UserID", ClientSession.UserID}
                            };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_user_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            txtLastName.Text = row["NameLast"].ToString();
            txtFirstName.Text = row["NameFirst"].ToString();
            txtUserName.Text = row["UserName"].ToString();
            txtUserName.Enabled = false;
            txtPhone.Text = row["Phone"].ToString();
            txtEmail.Text = row["Email"].ToString();
            chkPayment.Checked = (bool)row["FlagPrintPayReceipts"];
            chkSignature.Checked = (bool)row["FlagSigCaptureReceipts"];
            txtNotes.Text = row["Notes"].ToString();
            lblLoginState.Text = row["LockoutAbbr"].ToString();
            cmbAccountTypes.SelectedValue = row["RoleTypeID"].ToString();
            cmbLandingPages.SelectedValue = row["LandingPage"].ToString();
            cmbStatusTypes.SelectedValue = row["FlagActiveAbbr"].ToString() == "Active" ? "1" : "0";
            cmbPrimaryLocations.SelectedValue = row["DefaultLocationID"].ToString();
            cmbExistingProvider.SelectedValue = row["DefaultProviderID"].ToString();
            cmbSecurityQuestion.SelectedValue = row["SecurityQuestionTypeID"].ToString();
            if (string.IsNullOrEmpty(cmbSecurityQuestion.SelectedValue))
                cmbSecurityQuestion.SelectedIndex = 0;
            ViewState["Name"] = txtLastName.Text + ", " + txtFirstName.Text;
        }
    }

    void ShowUserPanel()
    {
        pnlUser.Visible = true;
        if (!string.IsNullOrEmpty(hdnSysUserID.Value)) ShowUserDetails();
    }

    protected void btnAddNew_OnClick(object sender, EventArgs e)
    {
        hdnSysUserID.Value = null;
        ClearAllFields();
        ShowUserPanel();
        ShowHideandValidateFields(true);
        BindExistingProviders();
        BindPrimaryLocations();
        BindLandingPages();
    }

    protected void lnkReset_OnClick(object sender, EventArgs e)
    {
        var cmdParams = new Dictionary<string, object>() { 
                                                      
                                                             {"@SysUserID", Convert.ToInt32(hdnSysUserID.Value)},
                                                             {"@UserID",ClientSession.UserID},
                                                             {"@ResetLogin", 1}
                                                         };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_user_add", cmdParams);
        ClientSession.ObjectType = ObjectType.Reset;
        ClientSession.ObjectID = Convert.ToInt32(hdnSysUserID.Value);
        Response.Redirect("users.aspx");
    }

    protected void txtUserName_OnTextChanged(object sender, EventArgs e)
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@UserName", txtUserName.Text},
                            };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_username_check", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            var flagInUse = (Int32)row["FlagInUse"];
            cstmUserName.IsValid = flagInUse == 0;
            cstmUserName.ToolTip = flagInUse == 1 ? "This Username already exists" : string.Empty;
            cstmUserName.ErrorMessage = flagInUse == 1 ? "This Username already exists" : string.Empty;
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {

            var cmdParams = new Dictionary<string, object>() { 
                                                                { "@PracticeID", ClientSession.PracticeID},
                                                                { "@UserName", txtUserName.Text.Trim()},
                                                                { "@Password", txtPassword.Text.Trim()},
                                                                { "@RoleTypeID", cmbAccountTypes.SelectedValue},   
                                                                { "@NameLast", txtLastName.Text.Trim()},
                                                                { "@NameFirst", txtFirstName.Text.Trim() },
                                                                { "@Phone", txtPhone.Text.Trim()},
                                                                { "@Email", txtEmail.Text.Trim() },
                                                                { "@LandingPage", cmbLandingPages.SelectedValue },
                                                                { "@FlagPrintPayReceipts", chkPayment.Checked},
                                                                { "@FlagSigCaptureReceipts", chkSignature.Checked},
                                                                { "@Notes", txtNotes.Text.Trim() },
                                                                { "@FlagActive", cmbStatusTypes.SelectedValue },
                                                                { "@DefaultLocationID", cmbPrimaryLocations.SelectedValue },
                                                                { "@DefaultProviderID", cmbExistingProvider.SelectedValue },
                                                                { "@SecurityQuestionTypeID", cmbSecurityQuestion.SelectedValue },
                                                                { "@SecurityAnswer", txtSecurityAnswer.Text },
                                                                { "@SysUserID", hdnSysUserID.Value },
                                                                { "@UserID", ClientSession.UserID }
                                                             };

            SqlHelper.ExecuteScalarProcedureParams("web_pr_user_add", cmdParams);
            grdUsers.Rebind();

            var isAddNewUser = string.IsNullOrEmpty(hdnSysUserID.Value);
            if (!isAddNewUser)
            {
                (new UserLogin()).ReloadSessionValues(ClientSession.UserID);
            }

            var message = isAddNewUser ? "Record successfully created." : "Record successfully updated.";
            RadWindow.RadAlert(message, 350, 150, "", "refreshPage", "../Content/Images/success.png");
        }
        catch (Exception)
        {

            throw;
        }
    }

    #endregion

    #region Utility

    private void ClearAllFields()
    {
        txtLastName.Text = string.Empty;
        txtFirstName.Text = string.Empty;
        txtUserName.Text = string.Empty;
        txtUserName.Enabled = true;
        txtPhone.Text = string.Empty;
        txtEmail.Text = string.Empty;
        txtNotes.Text = string.Empty;
        cmbAccountTypes.ClearSelection();
        cmbPrimaryLocations.ClearSelection();
        cmbExistingProvider.ClearSelection();
        cmbStatusTypes.SelectedValue = "1";
        lblLoginState.Text = string.Empty;
        cmbSecurityQuestion.ClearSelection();
        txtSecurityAnswer.Text = string.Empty;

    }

    private void ShowHideandValidateFields(bool isCreateUser)
    {
        if (isCreateUser)
        {
            btnSubmit.ImageUrl = "../Content/Images/btn_submit.gif";
            divLoginStates.Visible = false;
            rqrFieldPassword.Enabled = true;
            rqrFieldConfirmPassword.Enabled = true;
            rqdSecurityAnswer.Enabled = true;
            h2MainHeading.InnerText = "Add New User.";
            pMessage.Visible = false;
        }
        else
        {
            btnSubmit.ImageUrl = "../Content/Images/btn_update.gif";
            divLoginStates.Visible = true;
            rqrFieldPassword.Enabled = false;
            rqrFieldConfirmPassword.Enabled = false;
            rqdSecurityAnswer.Enabled = false;
            h2MainHeading.InnerText = "Edit record for " + ViewState["Name"];
            pMessage.Visible = true;
        }
    }

    private void ShowSelectedUser()
    {
        if (ClientSession.ObjectType != ObjectType.Reset) return;
        hdnSysUserID.Value = ClientSession.ObjectID.ToString();
        ShowUserPanel();
        ShowHideandValidateFields(false);

        // Reset the value from session

        ClientSession.ObjectType = null;
        ClientSession.ObjectID = 0;
    }
    

    #endregion

}