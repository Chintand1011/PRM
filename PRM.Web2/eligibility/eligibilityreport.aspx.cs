using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class pfsreports : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                BindPatients();
                BindLocations();
                BindProviders();
                BindPublicStatus();
                BindTypes();
                BindResultType();
                BindReasonType();
            }
            catch (Exception)
            {
                throw;
            }

        }

        popupProgress.VisibleOnPageLoad = false;
        popupCreditReport.VisibleOnPageLoad = false;
    }


    #region Bind Dropdowns

    private void BindPatients()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID", ClientSession.PracticeID}
                                };

        var patients = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_list", cmdParams);
        cmbPatients.DataSource = patients;
        cmbPatients.DataBind();
    }

    private void BindLocations()
    {
        var cmdParams = new Dictionary<string, object> {
        {"@PracticeID", ClientSession.PracticeID}, };
        var locations = SqlHelper.ExecuteDataTableProcedureParams("web_pr_location_list", cmdParams);
        cmbLocations.DataSource = locations;
        cmbLocations.DataBind();
    }

    private void BindProviders()
    {
        var cmdParams = new Dictionary<string, object> { {"@PracticeID", ClientSession.PracticeID}};
        var providers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_provider_list", cmdParams);
        cmbProviders.DataSource = providers;
        cmbProviders.DataBind();
    }

    private void BindPublicStatus()
    {
        var cmdParams = new Dictionary<string, object>();
        var statusTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statustype_list", cmdParams);
        cmbPublicStatus.DataSource = statusTypes;
        cmbPublicStatus.DataBind();
    }

    private void BindTypes()
    {
        cmbTypes.Items.Add(new RadComboBoxItem { Text = "Current Patients", Value = "0" });
        cmbTypes.Items.Add(new RadComboBoxItem { Text = "Ad-Hoc Queries", Value = "1" });
    }

    private void BindResultType()
    {
        var resultTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_turesulttype_list", new Dictionary<string, object>());
        cmbResultType.DataSource = resultTypes;
        cmbResultType.DataBind();
    }

    private void BindReasonType()
    {
        var reasonTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_tureasontype_list", new Dictionary<string, object>());
        cmbReasonType.DataSource = reasonTypes;
        cmbReasonType.DataBind();
    }

    #endregion


    private DataTable GetPastCreditReports()
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PatientID", cmbPatients.SelectedValue},
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@PatientStatusTypeID", cmbPublicStatus.SelectedValue},
                                {"@LocationID", cmbLocations.SelectedValue},
                                {"@ProviderID", cmbProviders.SelectedValue},
                                {"@flagadhoc", cmbTypes.SelectedValue},
                                {"@TUResultTypeID", cmbResultType.SelectedValue},
                                {"@TUReasonTypeID", cmbReasonType.SelectedValue},
                                {"@UserID", ClientSession.UserID}
                            };
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_tupfs_get", cmdParams);
    }

    protected void grdPastCreditReports_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdPastCreditReports.DataSource = GetPastCreditReports();
    }

    protected void grdPastCreditReports_OnItemCommand(object source, GridCommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "ViewHistory":
                ClientSession.ObjectID = e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PFSID"];
                ClientSession.ObjectID2 = null;
                ClientSession.ObjectType = ObjectType.PFSReportDetail;
                popupCreditReport.VisibleOnPageLoad = true;
                break;

        }
    }


    protected void grdPastCreditReports_ItemDataBound(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridDataItem)
        {
            var item = (GridDataItem)e.Item;
            var patientID = 0;
            Int32.TryParse((item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["PatientID"]).ToString(), out patientID);
            var imageButton = (ImageButton)item.FindControl("btnCreatePatient");

            if (patientID > 0)
            {
                var label = (Label)item.FindControl("lblCreatePatient");
                imageButton.Enabled = false;
                imageButton.Visible = false;
                label.Text = patientID.ToString();
                label.Visible = true;
            }
            else
            {
                imageButton.ImageUrl = patientID > 0 ? "~/Content/Images/check.png" : "~/Content/Images/icon_add.png";
            }

        }
    }

    protected void btnCreatePatient_OnClick(object sender, EventArgs e)
    {
        var button = (ImageButton)sender;
        var item = button.NamingContainer as GridDataItem;

        ClientSession.ObjectID = item.GetDataKeyValue("PFSID");
        ClientSession.ObjectType = ObjectType.PFSReportAddPatient;
        var firstName = item.GetDataKeyValue("InputNameFirst");
        var lastName = item.GetDataKeyValue("InputNameLast");
        var dob = item.GetDataKeyValue("InputDOB");
        var ssnEnc = item.GetDataKeyValue("InputSSNenc");
        var streetAddr = item.GetDataKeyValue("InputAddrStreet");
        var cityAddr = item.GetDataKeyValue("InputAddrCity");
        var stateAddr = item.GetDataKeyValue("InputAddrState");
        var zipAddr = item.GetDataKeyValue("InputAddrZip");

        ClientSession.ObjectValue = new Dictionary<string, string>
                    {
                        {"FirstName", firstName.ToString()},
                        {"LastName", lastName.ToString()},
                        {"DOB", dob.ToString()},
                        {"SSNenc", ssnEnc.ToString()},
                        {"StreetAddress", streetAddr.ToString()},
                        {"CityAddress", cityAddr.ToString()},
                        {"StateAddress", stateAddr.ToString()},
                        {"ZipAddress", zipAddr.ToString()},
                    };

        // Clearing the values of client session
        ClearClientSession();

        Response.Redirect("~/patient/manage.aspx");

    }


    protected void cmbPatients_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        try
        {
            //grdPastCreditReports.Rebind();
            btnRunNew.Visible = true;
        }
        catch (Exception)
        {
            throw;
        }
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        cmbPatients.ClearSelection();
        cmbPublicStatus.ClearSelection();
        cmbLocations.ClearSelection();
        cmbProviders.ClearSelection();
        cmbTypes.ClearSelection();
        cmbResultType.ClearSelection();
        grdPastCreditReports.DataSource = new List<string>();
        grdPastCreditReports.DataBind();
        btnRunNew.Visible = false;
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        grdPastCreditReports.Rebind();
    }

    protected void btnReport_OnClick(object sender, EventArgs e)
    {
        grdPastCreditReports.ExportSettings.FileName = "PFS Search Report";
        grdPastCreditReports.ExportSettings.ExportOnlyData = true;
        grdPastCreditReports.MasterTableView.GetColumn("View").Visible = false;

        foreach (GridColumn col in grdPastCreditReports.MasterTableView.Columns)
            col.HeaderStyle.Width = Unit.Point(100);

        foreach (GridDataItem item in grdPastCreditReports.MasterTableView.Items)
        {
            Int32 patientID;
            Int32.TryParse(item.GetDataKeyValue("PatientID").ToString(), out patientID);
            item["AddPatient"].Text = patientID == 0 ? "N/A" : patientID.ToString();
        }

        grdPastCreditReports.MasterTableView.ExportToExcel();
    }
    
    
    protected void btnRunNew_Click(object sender, EventArgs e)
    {
        ClientSession.SelectedPatientID = Int32.Parse(cmbPatients.SelectedValue);
        (new UserLogin()).LoadPatientIntoSession();
        Response.Redirect("~/patient/eligibility.aspx?rn=1");
    }

    //protected void btnRunNew_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        var cmdParams = new Dictionary<string, object>
    //                        {
    //                            {"@PatientID", cmbPatients.SelectedValue}
    //                        };
    //        var patientDetails = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
    //        if (patientDetails.Read())
    //        {
    //            var reasonType = string.IsNullOrEmpty(cmbReasonType.SelectedValue) ? "0" : cmbReasonType.SelectedValue;
    //            var transUnionPFSRequest = new TransUnionPFSRequest(0, patientDetails["NameFirst"].ToString(), patientDetails["NameMiddle"].ToString(), patientDetails["NameLast"].ToString(), patientDetails["Addr1pri"].ToString(), patientDetails["CityPri"].ToString(), patientDetails["StatePriAbbr"].ToString(), patientDetails["ZipPriAbbr"].ToString(), Convert.ToInt32(CryptorEngine.Decrypt(patientDetails["PatientSSNenc"].ToString(), false)), DateTime.Parse(patientDetails["DateOfBirth"].ToString()), Convert.ToInt32(patientDetails["PracticeID"].ToString()), 0, Convert.ToInt32(reasonType), ClientSession.IPAddress, 0m, "", ClientSession.UserID);

    //            if (!transUnionPFSRequest.Success)
    //            {
    //                radWindowDialog.RadAlert(transUnionPFSRequest.Message.Replace("'", string.Empty), 450, 150, string.Empty, string.Empty, "../Content/Images/Success.png");
    //            }
    //            else
    //            {
    //                ClientSession.ObjectID = transUnionPFSRequest.TUPFSID;
    //                ClientSession.ObjectID2 = cmbPatients.SelectedValue;
    //                ClientSession.ObjectType = ObjectType.PFSReportDetail;
    //                popupCreditReport.VisibleOnPageLoad = true;
    //            }

    //        }
    //        patientDetails.Close();
    //    }
    //    catch (Exception)
    //    {
    //        throw;
    //    }
    //}

    private void ClearClientSession()
    {
        Extension.ClientSession.SelectedPatientID = 0;
        Extension.ClientSession.PatientFirstName = null;
        Extension.ClientSession.PatientLastName = null;
    }
}