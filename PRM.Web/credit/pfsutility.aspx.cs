using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;
using PatientPortal.Utility;

public partial class pfsutility : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                BindStates();
                BindHousingType();
                BindCreditReasons();
                ShowDefualtValues();
                PopulateWebQueryInfo();
            }
            catch (Exception)
            {
                throw;
            }
        }
        popupCreditReport.VisibleOnPageLoad = false;
    }

    private void BindStates()
    {
        var cmdParams = new Dictionary<string, object>();
        var states = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statetype_list", cmdParams);

        cmbStates.DataSource = states;
        cmbStates.DataBind();
    }

    public void BindHousingType()
    {
        var hostingValues = Enum.GetValues(typeof(HousingType))
            .Cast<HousingType>()
            .OrderBy(x => (Int32)x)
            .Select(x => new { Text = x.GetDescription(), Value = (Int32)x });


        cmbHousingType.DataSource = hostingValues;
        cmbHousingType.DataBind();
    }

    private void BindCreditReasons()
    {
        var creditReasons = SqlHelper.ExecuteDataTableProcedureParams("web_pr_tureasontype_list", new Dictionary<string, object>());

        cmbCreditReasons.DataSource = creditReasons;
        cmbCreditReasons.DataBind();
    }

    private void ShowDefualtValues()
    {
        cmbHousingType.SelectedIndex = 0;
    }

    private void PopulateWebQueryInfo()
    {
        if (ClientSession.ObjectType != ObjectType.PFSReportAddPatient)
        {
            ViewState["CreditApplicationID"] = 0;
            return;
        }


        ClientSession.ObjectType = null;

        var values = ClientSession.ObjectValue as Dictionary<string, string>;

        txtFirstName.Text = values["FirstName"];
        txtLastName.Text = values["LastName"];
        dtDateofBirth.SelectedDate = string.IsNullOrEmpty(values["DOB"]) ? (DateTime?)null : DateTime.Parse(values["DOB"]);
        txtStreet.Text = values["Address1"];
        txtAptSuite.Text = values["Address2"];
        txtCity.Text = values["City"];
        cmbStates.SelectedValue = values["StateAbbr"];
        txtZipCode1.Text = values["ZipCode"];
        txtHomePhone.Text = values["Phone"];
        ViewState["CreditApplicationID"] = values["CreditApplicationID"];

        // Changing clear button to cancel
        btnCancel.ImageUrl = "~/Content/Images/btn_cancel.gif";
        btnCancel.OnClientClick = "redirectToWebinquiry();";
    }


    // commented out since grid is repetitive with credit/pfsreports

    //private DataTable GetPastCreditReports()
    //{
    //    var cmdParams = new Dictionary<string, object>()
    //                        {
    //                            {"@PracticeID",ClientSession.PracticeID},
    //                            {"@FlagAdHoc", 1},
    //                        };
    //    return SqlHelper.ExecuteDataTableProcedureParams("web_pr_tupfs_get", cmdParams);

    //}

    //protected void grdPastCreditReports_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    //{
    //    grdPastCreditReports.DataSource = GetPastCreditReports();
    //}

    //protected void grdPastCreditReports_OnItemCommand(object source, GridCommandEventArgs e)
    //{
    //    switch (e.CommandName)
    //    {
    //        case "ViewHistory":
    //            ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PFSID"];
    //            ClientSession.ObjectType = ObjectType.PFSReportDetail;
    //            popupCreditReport.VisibleOnPageLoad = true;
    //            break;

    //    }
    //}


    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                var isValidated = Validator.ValidateCreditCheck(radWindowDialog);
                if (!isValidated)
                    return;

                if (!ValidateRecords())
                    return;

                isValidated = Validator.ValidateFlagCreditCheck(radWindowDialog, "submitPfs");
                if (!isValidated && ViewState["FlagCreditCheck"] == null)
                {
                    ViewState["FlagCreditCheck"] = "1";
                    return;
                }


                int SSN;
                Int32.TryParse(txtSocialSecurity.Text.Trim(), out SSN);

                var creditApplicationID = Int32.Parse(ViewState["CreditApplicationID"].ToString());
                
                var address = !string.IsNullOrEmpty(txtStreet.Text.Trim()) ? string.Format("{0}, {1}", txtStreet.Text.Trim(), txtAptSuite.Text.Trim()) : txtStreet.Text.Trim();
                var zipCode = !string.IsNullOrEmpty(txtZipCode2.Text.Trim()) ? string.Format("{0}-{1}", txtZipCode1.Text.Trim(), txtZipCode2.Text.Trim()) : txtZipCode1.Text.Trim();

                var transUnionPFSRequest = new TransUnionPFSRequest(null, txtFirstName.Text.Trim(), txtMiddleName.Text.Trim(), txtLastName.Text.Trim(), address, txtCity.Text, cmbStates.SelectedValue, zipCode, SSN, Convert.ToDateTime(dtDateofBirth.SelectedDate), ClientSession.PracticeID, null, Convert.ToInt32(cmbCreditReasons.SelectedValue), ClientSession.IPAddress, decimal.Parse(txtIncone.Text), cmbHousingType.SelectedValue, ClientSession.UserID, creditApplicationID);

                if (!transUnionPFSRequest.Success)
                {
                    radWindowDialog.RadAlert(transUnionPFSRequest.Message.ToApostropheStringIfAny(), 450, 150, string.Empty, string.Empty, "../Content/Images/warning.png");
                }
                else
                {
                    ClientSession.ObjectID = transUnionPFSRequest.TUPFSID;
                    ClientSession.ObjectType = ObjectType.PFSReportDetail;

                    if (transUnionPFSRequest.FlagShowTUFSReport)
                    {
                        popupCreditReport.VisibleOnPageLoad = true;
                    }
                    else
                    {
                        radWindowDialog.RadAlert("A credit profile match could not be found based on the supplied data. Please verify the information or include additional fields before resubmitting. <BR><BR>PLEASE NOTE THAT EACH CREDIT REQUEST IS CHARGEABLE FROM THE REPORTING AGENCY, REGARDLESS OF A CREDIT MATCH.", 450, 200, string.Empty, string.Empty, "../Content/Images/warning.png");
                    }
                }
                
            }
            catch (Exception ex)
            {
                radWindowDialog.RadAlert(ex.Message.ToApostropheStringIfAny(), 450, 150, string.Empty, string.Empty, "../Content/Images/warning.png");
            }
        }
    }


    private bool ValidateRecords()
    {
        var cmdParams = new Dictionary<string, object>
        {
            {"@PracticeID", ClientSession.PracticeID},
            {"@inputNameFirst", txtFirstName.Text},
            {"@inputNameLast", txtLastName.Text},
            {"@inputAddrZip", txtZipCode1.Text},
            {"@inputSSN4",  string.IsNullOrEmpty(txtSocialSecurity.Text) ? (object)DBNull.Value : txtSocialSecurity.Text.Substring(txtSocialSecurity.Text.Length - 4, 4)},
            {"@inputDOB", dtDateofBirth.SelectedDate }
        };

        var result = SqlHelper.ExecuteDataTableProcedureParams("svc_tupfs_patientcheck", cmdParams);

        if (result.Rows.Count <= 0) return true;

        var message = string.Format("<p> Your request cannot be completed - credit inquiries may only be submitted once every {0} days, and this patient credit was previously requested on {1}. Please search the credit history for PFS {2} in order to view the report. </p>", result.Rows[0]["PFSDayRange"], result.Rows[0]["DateCreatedAbbr"], result.Rows[0]["TUPFSID"]);
        radWindowDialog.RadAlert(message, 500, 150, string.Empty, string.Empty, "../Content/Images/warning.png");
        return false;
    }


}