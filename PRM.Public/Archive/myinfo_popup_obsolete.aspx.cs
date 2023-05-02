using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class myinfo_popup : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                BindStates();
                BindStatements();
                GetPatientInformation();
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    private void GetPatientInformation()
    {
        var cmdParams = new Dictionary<string, object> { { "PatientID", ClientSession.PatientID } };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            
            txtAltPhone.Text = row["PhoneSec"].ToString();
            txtEmail.Text = row["Email"].ToString();

            lblStreet.Text = row["Addr1Pri"].ToString();
            lblAptSuite.Text = row["Addr2Pri"].ToString();

            txtAltStreet.Text = row["Addr1Sec"].ToString();
            txtAltAptSuite.Text = row["Addr2Sec"].ToString();

            lblCity.Text = row["CityPri"].ToString();
            txtAltCity.Text = row["CitySec"].ToString();

            cmbAltStates.SelectedValue = row["StateTypeIDSec"].ToString();

            txtAltZipCode1.Text = row["ZipSec"].ToString();
            txtAltZipCode2.Text = row["Zip4Sec"].ToString();

            cmbStatements.SelectedValue = Convert.ToBoolean(row["AddrPrimaryID"]) ? "1" : "0";
            chkEmailMyStatements.Checked = Convert.ToBoolean(row["FlagEmailBills"]);
        }
    }

    private void BindStatements()
    {
        cmbStatements.Items.Add(new RadComboBoxItem { Text = Statements.Primary.ToString(), Value = ((int)Statements.Primary).ToString() });
        cmbStatements.Items.Add(new RadComboBoxItem { Text = Statements.Secondary.ToString(), Value = ((int)Statements.Secondary).ToString() });
    }

    private void BindStates()
    {
        var cmdParams = new Dictionary<string, object>();
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", cmdParams);

        cmbAltStates.DataSource = states;
        cmbAltStates.DataBind();
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                var cmdParams = new Dictionary<string, object>
                            {
                            {"@PatientID",ClientSession.PatientID},
                            {"@PhoneSec",txtAltPhone.Text.Trim()},
                            {"@Email",txtEmail.Text.Trim()},
                            {"@Addr1Sec",txtAltStreet.Text.Trim()},
                            {"@Addr2Sec",txtAltAptSuite.Text.Trim()},
                            {"@CitySec",txtAltCity.Text.Trim()},
                            {"@StateTypeIDSec",cmbAltStates.SelectedValue},
                            {"@ZipSec",txtAltZipCode1.Text.Trim()},
                            {"@Zip4Sec",txtAltZipCode2.Text.Trim()},
                            {"@FlagEmailBills",chkEmailMyStatements.Checked?"1":"0"},
                            {"@AddrPrimaryID",cmbStatements.SelectedValue}
                            };

                SqlHelper.ExecuteScalarProcedureParams("web_pt_patient_update", cmdParams);
                litMessage.Text = "Patient Information has been updated";
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}