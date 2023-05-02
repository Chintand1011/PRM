using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class insurances : BasePage
{
    private List<CustomUploadedFileInfo> uploadedFiles = new List<CustomUploadedFileInfo>();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (ClientSession.SelectedPatientID == 0) Response.Redirect("search.aspx");

        if (!IsPostBack)
        {
            ClientSession.InsuranceImage = null;
            ClientSession.CardImage = null;

            BindActiceCarriers();
            BindPlanTypes();
            BindRelationshipTypes();
            BindGenderDropDown();
            GetInsuranceInformation();
            // For WebPathRoot
            hdnPath.Value = ClientSession.WebPathRootProvider;
        }
    }

    private void BindActiceCarriers()
    {
        var activeCarriers = SqlHelper.ExecuteDataTableProcedureParams("[web_pr_carrier_list]", new Dictionary<string, object> { { "@PracticeID", ClientSession.PracticeID } });
        cmbActiveCarriers.DataSource = activeCarriers;
        cmbActiveCarriers.DataBind();
        ViewState["ActiveCarriers"] = activeCarriers;
    }

    private void BindPlanTypes()
    {
        var planTypes = SqlHelper.ExecuteDataTableProcedureParams("[web_pr_plantype_list]", new Dictionary<string, object>());
        cmbPlanTypes.DataSource = planTypes;
        cmbPlanTypes.DataBind();
        ViewState["PlanTypes"] = planTypes;
    }

    private void BindRelationshipTypes()
    {
        var relationshipTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_relationtype_list", new Dictionary<string, object>());
        cmbRelationshipType.DataSource = relationshipTypes;
        cmbRelationshipType.DataBind();

    }

    private void BindGenderDropDown()
    {
        cmbGender.Items.Add(new RadComboBoxItem { Text = Gender.Male.ToString(), Value = ((int)Gender.Male).ToString() });
        cmbGender.Items.Add(new RadComboBoxItem { Text = Gender.Female.ToString(), Value = ((int)Gender.Female).ToString() });
    }

    private void GetPatientInformation()
    {
        var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.SelectedPatientID },
                                    { "@UserID", ClientSession.UserID}
                                };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            txtFirstName.Text = row["NameFirst"].ToString();
            txtLastName.Text = row["NameLast"].ToString();
            dtDOB.SelectedDate = Convert.ToDateTime(row["DateofBirth"]);
            txtSSN.Text = CryptorEngine.Decrypt(row["PatientSSNenc"].ToString());
            cmbGender.SelectedValue = row["GenderID"].ToString();
        }
    }

    private void GetInsuranceInformation()
    {
        var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.SelectedPatientID },
                                    { "@UserID", ClientSession.UserID}
                                };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_insurance_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            // Path for upload and download the Image
            ViewState["FilePath"] = row["FilePathInsurance"].ToString();

            cmbActiveCarriers.SelectedValue = row["CarrierID"].ToString();
            cmbPlanTypes.SelectedValue = row["PolicyTypeID"].ToString();
            cmbRelationshipType.SelectedValue = row["RelTypeID"].ToString();

            // 18 is for self
            if (string.IsNullOrEmpty(cmbRelationshipType.SelectedValue))
            {
                cmbRelationshipType.SelectedValue = "18";
            }

            if (cmbRelationshipType.SelectedValue == "18")
            {
                lblPatientInfo.Text = "patient is Subscriber";
                GetPatientInformation();
                EnableDisableandClearFields(false);
            }
            else if (cmbRelationshipType.SelectedValue != "18")
            {
                lblPatientInfo.Text = "Primary Subscriber Info:";
                EnableDisableandClearFields(true);

                // Getting Inforamation about patient
                txtFirstName.Text = row["SubNameFirst"].ToString();
                txtLastName.Text = row["SubNameLast"].ToString();
                var dob = row["SubDateofBirth"].ToString();
                dtDOB.SelectedDate = string.IsNullOrEmpty(dob) ? (DateTime?)null : Convert.ToDateTime(dob);
                txtSSN.Text = CryptorEngine.Decrypt(row["SubSSNenc"].ToString());
                cmbGender.SelectedValue = row["SubGenderID"].ToString();

            }


            txtPlanName.Text = row["PlanName"].ToString();
            txtSubscriberID.Text = row["SubscriberID"].ToString();
            txtGroupNumber.Text = row["GroupID"].ToString();
            txtPlanID.Text = row["PlanID"].ToString();
            if (row["ExpDate"] != null && !string.IsNullOrEmpty(row["ExpDate"].ToString()))
                dtExpiration.SelectedDate = Convert.ToDateTime(row["ExpDate"]);
            txtEligibilityPhone.Text = row["CarrierPhone"].ToString();
            txtNotes.Text = row["Notes"].ToString();
            hdnIns.Value = row["InsID"].ToString();

            if (!string.IsNullOrEmpty(row["ImgCard1GUID"].ToString()))
            {
                var insuranceImage = new CustomUploadedFileInfo();
                insuranceImage.ID = row["ImgCard1GUID"].ToString();
                insuranceImage.FileName = row["ImgCard1Name"].ToString();
                ClientSession.InsuranceImage = insuranceImage;

                lblInsCardImage.Text = row["ImgCard1Name"].ToString();
                divInsDownloadRemove.Visible = true;
                divInsCardImage.Visible = false;
            }

            if (!string.IsNullOrEmpty(row["ImgCard2GUID"].ToString()))
            {
                var cardImage = new CustomUploadedFileInfo();
                cardImage.ID = row["ImgCard2GUID"].ToString();
                cardImage.FileName = row["ImgCard2Name"].ToString();
                ClientSession.CardImage = cardImage;

                lblIDCardImage.Text = row["ImgCard2Name"].ToString();
                divIDDownloadRemove.Visible = true;
                divIDCardImage.Visible = false;
            }
            btnSubmit.ImageUrl = "../Content/Images/btn_update.gif";
        }
    }

    protected void cmbPlanTypes_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        var activeCarriers = ViewState["ActiveCarriers"] as DataTable;
        var planTypes = ViewState["PlanTypes"] as DataTable;
        var selectedActiveCarrier = activeCarriers.Select("CarrierID=" + cmbActiveCarriers.SelectedValue);
        var selectedPlanType = planTypes.Select("PolicyTypeID=" + cmbPlanTypes.SelectedValue);
        txtPlanName.Text = selectedActiveCarrier[0]["CarrierAbbr"] + " " + selectedPlanType[0]["PolicyType"];
    }

    protected void cmbRelationshipType_OnSelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        if (cmbRelationshipType.SelectedValue == "18")
        {
            lblPatientInfo.Text = "patient is Subscriber";
            GetPatientInformation();
            EnableDisableandClearFields(false);
        }
        else
        {
            lblPatientInfo.Text = "Please enter primary subscriber info:";
            //EnableDisableandClearFields(true, true);
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        SaveUploadedFiles();

        var cmdParams = new Dictionary<string, object>
                                {
                                    { "@InsID", hdnIns.Value },
                                    { "@PatientID", ClientSession.SelectedPatientID },
                                    { "@PracticeID", ClientSession.PracticeID },
                                    { "@PolicyTypeID", cmbPlanTypes.SelectedValue },
                                    { "@CarrierID", cmbActiveCarriers.SelectedValue },
                                    { "@RelTypeID", cmbRelationshipType.SelectedValue },
                                    { "@SubscriberID", txtSubscriberID.Text.Trim() },
                                    { "@GroupID", txtGroupNumber.Text.Trim() },
                                    { "@PlanID", txtPlanID.Text.Trim() },
                                    { "@PlanName", txtPlanName.Text.Trim() },
                                    { "@ExpDate", dtExpiration.SelectedDate},
                                    { "@Notes", txtNotes.Text.Trim() },
                                    { "@UserID", ClientSession.UserID },
                                    { "@CarrierPhone", txtEligibilityPhone.Text.Trim() }
                                    
                                };
        if (ClientSession.InsuranceImage != null)
        {
            cmdParams.Add("@ImgCard1Name", ClientSession.InsuranceImage.FileName);
            cmdParams.Add("@ImgCard1GUID", string.IsNullOrEmpty(ClientSession.InsuranceImage.FileName) ? (object)DBNull.Value : ClientSession.InsuranceImage.ID);

            //if (!string.IsNullOrEmpty(ClientSession.InsuranceImage.FileName) && ClientSession.InsuranceImage.IsAddUpdate)
            //    cmdParams.Add("@FlagImgInsActive", true);
            //else if (!string.IsNullOrEmpty(ClientSession.InsuranceImage.FileName) && !ClientSession.InsuranceImage.IsAddUpdate)
            //    cmdParams.Add("@FlagImgInsActive", null);
            //else
            //    cmdParams.Add("@FlagImgInsActive", false);

        }

        if (ClientSession.CardImage != null)
        {
            cmdParams.Add("@ImgCard2Name", ClientSession.CardImage.FileName);
            cmdParams.Add("@ImgCard2GUID", string.IsNullOrEmpty(ClientSession.CardImage.FileName) ? (object)DBNull.Value : ClientSession.CardImage.ID);


            //if (!string.IsNullOrEmpty(ClientSession.CardImage.FileName) && ClientSession.CardImage.IsAddUpdate)
            //    cmdParams.Add("@FlagImgIDActive", true);
            //else if (!string.IsNullOrEmpty(ClientSession.CardImage.FileName) && !ClientSession.CardImage.IsAddUpdate)
            //    cmdParams.Add("@FlagImgIDActive", null);
            //else
            //    cmdParams.Add("@FlagImgIDActive", false);
        }


        if (cmbRelationshipType.SelectedValue != "18")
        {
            var ssn = txtSSN.Text;
            cmdParams.Add("@SubNameFirst", txtFirstName.Text);
            cmdParams.Add("@SubNameLast", txtLastName.Text);
            cmdParams.Add("@SubDateofBirth", dtDOB.SelectedDate);
            cmdParams.Add("@SubSSNenc", CryptorEngine.Encrypt(ssn));
            cmdParams.Add("@SubGenderID", cmbGender.SelectedValue);

            if (!string.IsNullOrEmpty(ssn))
            {
                cmdParams.Add("@SubSSN4", ssn.Substring(ssn.Length - 4, 4));
            }

        }

        SqlHelper.ExecuteScalarProcedureParams("web_pr_insurance_add", cmdParams);
        ClientSession.InsuranceImage = null;
        ClientSession.CardImage = null;

        RadWindow.RadAlert("Record successfully saved.", 350, 150, "", "redirectToPatientDashboard", "../Content/Images/success.png");
    }

    private void SaveUploadedFiles()
    {
        var location = GetSavedImageLocation();
        var insuranceImage = new CustomUploadedFileInfo();
        foreach (UploadedFile file in insCard1ImageUpload.UploadedFiles)
        {

            //if (ClientSession.InsuranceImage != null) insuranceImage.ID = ClientSession.InsuranceImage.ID ?? Guid.NewGuid();
            //else insuranceImage.ID = Guid.NewGuid();

            insuranceImage.ID = Guid.NewGuid().ToString();
            var fileName = file.GetName();
            file.SaveAs(location + insuranceImage.ID);

            insuranceImage.FileName = fileName;
            insuranceImage.IsAddUpdate = true;
            ClientSession.InsuranceImage = insuranceImage;

            //var buffer = new byte[file.ContentLength];
            //file.InputStream.Read(buffer, 0, buffer.Length);
            //insuranceImage.Bytes = buffer;
            //insuranceImage.ContentLength = file.ContentLength;
        }
        var cardImage = new CustomUploadedFileInfo();
        foreach (UploadedFile file in insCard2ImageUpload.UploadedFiles)
        {
            //if (ClientSession.CardImage != null) cardImage.ID = ClientSession.CardImage.ID ?? Guid.NewGuid();
            //else cardImage.ID = Guid.NewGuid();

            cardImage.ID = Guid.NewGuid().ToString();
            var fileName = file.GetName();
            file.SaveAs(location + cardImage.ID);

            cardImage.FileName = fileName;
            cardImage.IsAddUpdate = true;
            ClientSession.CardImage = cardImage;

            //var buffer = new byte[file.ContentLength];
            //file.InputStream.Read(buffer, 0, buffer.Length);
            //cardImage.Bytes = buffer;
            //cardImage.ContentLength = file.ContentLength;
        }
    }


    protected void insImageDownload_Click(object sender, ImageClickEventArgs e)
    {
        //var path = string.Format("{0}", location + GetImageFileName(ClientSession.InsuranceImage.FileName, ClientSession.InsuranceImage.ID));
        //ClientSession.ObjectValue = new Dictionary<string, string> { { "PageTitle", "Insurance" }, { "FilePath", path } };
        //Page.ClientScript.RegisterStartupScript(GetType(), "ViewImage", "viewPdfViewer()", true);

        var location = GetSavedImageLocation();
        location = Path.Combine(location, ClientSession.InsuranceImage.ID);
        var returnmsg = PDFServices.FileDownload(location, ClientSession.InsuranceImage.FileName);
        if (returnmsg != "")
        {
            RadWindow.RadAlert(returnmsg, 350, 150, "", "");
        }
    }
    protected void insImageRemove_Click(object sender, ImageClickEventArgs e)
    {
        ClientSession.InsuranceImage.FileName = null;
        ClientSession.InsuranceImage.IsAddUpdate = false;
        divInsDownloadRemove.Visible = false;
        divInsCardImage.Visible = true;
    }

    protected void cardImageDownload_Click(object sender, ImageClickEventArgs e)
    {
        //var path = string.Format("{0}", location + GetImageFileName(ClientSession.CardImage.FileName, ClientSession.CardImage.ID));
        //ClientSession.ObjectValue = new Dictionary<string, string> { { "PageTitle", "Insurance" }, { "FilePath", path } };
        //Page.ClientScript.RegisterStartupScript(GetType(), "ViewImage", "viewPdfViewer()", true);

        var location = GetSavedImageLocation();
        location = Path.Combine(location, ClientSession.CardImage.ID);
        var returnmsg = PDFServices.FileDownload(location, ClientSession.CardImage.FileName);
        if (returnmsg != "")
        {
            RadWindow.RadAlert(returnmsg, 350, 150, "", "");
        }
    }
    protected void cardImageRemove_Click(object sender, ImageClickEventArgs e)
    {
        ClientSession.CardImage.FileName = null;
        ClientSession.CardImage.IsAddUpdate = false;
        divIDDownloadRemove.Visible = false;
        divIDCardImage.Visible = true;
    }

    private string GetSavedImageLocation()
    {
        var path = ViewState["FilePath"].ToString();

        if (!Directory.Exists(path))
            Directory.CreateDirectory(path);

        return path;
    }


    private void EnableDisableandClearFields(bool isEnable, bool isClear = false)
    {
        txtFirstName.Enabled = isEnable;
        txtLastName.Enabled = isEnable;
        dtDOB.Enabled = isEnable;
        txtSSN.Enabled = isEnable;
        cmbGender.Enabled = isEnable;

        if (!isClear) return;
        txtFirstName.Text = string.Empty;
        txtLastName.Text = string.Empty;
        dtDOB.SelectedDate = null;
        txtSSN.Text = string.Empty;
        cmbGender.ClearSelection();
    }
}

