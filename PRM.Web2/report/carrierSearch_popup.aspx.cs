using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class carrierSearch_popup : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            ClientSession.WasRequestFromPopup = true;
            BindCarrierTypesandStates();
        }
    }

    void BindCarrierTypesandStates()
    {
        // BIND STATES
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", new Dictionary<string, object>());
        cmbStates.DataSource = states;
        cmbStates.DataBind();

        // BIND POLICIES TYPES

        var policyTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_carriertype_list", new Dictionary<string, object>());
        cmbPolicyTypes.DataSource = policyTypes;
        cmbPolicyTypes.DataBind();
    }

    protected void btnSearch_OnClick(object sender, EventArgs e)
    {
        try
        {
            var cmdParams = new Dictionary<string, object>()
                                {
                                   { "@PracticeID", ClientSession.PracticeID},
                                   { "@CarrierTypeID", cmbPolicyTypes.SelectedValue},
                                   { "@CarrierStateTypeID", cmbStates.SelectedValue},
                                   { "@Name", txtCarrierName.Text},
                                };

            var carriers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_carrier_list", cmdParams);
            cmbCarrierTypes.DataSource = carriers;
            cmbCarrierTypes.DataBind();
            pnlSearch.Visible = true;
        }
        catch (Exception)
        {

            throw;
        }
    }


    protected void cmbCarrierTypes_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(cmbCarrierTypes.SelectedValue))
        {
            btnSelect.Enabled = true;
        }
    }

    protected void btnSelect_OnClick(object sender, EventArgs e)
    {
        ClientSession.ObjectID = cmbCarrierTypes.SelectedValue;
        ClientSession.ObjectType = ObjectType.CarriesSearch;
        // Calling the javascript function from here name is CloseAndRebind()
        ClientScript.RegisterStartupScript(Page.GetType(), "mykey", "CloseAndRebind();", true);
    }


}