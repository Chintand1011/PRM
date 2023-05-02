using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class Identification : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                BindAllIdTypes();
                ShowPatientandGuardianInformation();
                GetAllIdentification();
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    #region Show Patient and Guardian Information

    private void ShowPatientandGuardianInformation()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "PatientID", ClientSession.SelectedPatientID },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {

            //Patient Information

            lblFirstName.Text = row["NameFirst"].ToString();
            lblLastName.Text = row["NameLast"].ToString();
            lblDateOfBirth.Text = row["DateofBirth"].ToString();
            lblSocialSecurity.Text = row["PatientSSNenc"].ToString().Decrypt().ToSSNFormat(); 
            lblFinancialResponsibility.Text = (Convert.ToBoolean(row["FlagGuardianPay"]) == false ? 0 : 1) == (int)FinancialResponsibility.Patient
                                                                                     ? FinancialResponsibility.Patient.ToString()
                                                                                     : FinancialResponsibility.Guardian.ToString();

            lblStreet.Text = row["Addr1Pri"].ToString();
            lblAppSuite.Text = row["Addr2Pri"].ToString();
            lblCity.Text = row["CityPri"].ToString();
            lblState.Text = row["StatePriName"].ToString();
            lblZipCode.Text = row["ZipPri"] + " " + row["Zip4Pri"];
            ViewState["FlagPatientMinor"] = row["FlagPatientMinor"];

            //Guardian Information

            lblSecFirstName.Text = row["GuardianFirst"].ToString();
            lblSecLastName.Text = row["GuardianLast"].ToString();
            lblSecDateOfBirth.Text = row["GuardianDateofBirth"].ToString();
            lblSecSocialSecurity.Text = row["GuardianSSNenc"].ToString().Decrypt().ToSSNFormat(); 
            lblSecRelationShip.Text = string.IsNullOrEmpty(lblSecLastName.Text) ? string.Empty : row["GuardianRelTypeAbbr"].ToString();

            lblSecStreet.Text = row["Addr1Sec"].ToString();
            lblSecAppSuite.Text = row["Addr2Sec"].ToString();
            lblSecCity.Text = row["CitySec"].ToString();
            lblSecState.Text = row["StateSecName"].ToString();
            lblSecZipCode.Text = row["ZipSec"] + " " + row["Zip4Sec"];
            ViewState["FlagGuardianExists"] = row["FlagGuardianExists"];
        }

    }



    #endregion

    #region Binding All Dropdowns

    private void BindAllIdTypes()
    {
        var identificationTypes = SqlHelper.ExecuteDataTableProcedureParams("web_pr_identificationtype_list", new Dictionary<string, object>());

        cmbPatientPriIDType.DataSource = identificationTypes;
        cmbPatientPriIDType.DataBind();

        cmbPatientSecIDType.DataSource = identificationTypes;
        cmbPatientSecIDType.DataBind();

        cmbGuardianPriIDType.DataSource = identificationTypes;
        cmbGuardianPriIDType.DataBind();

        cmbGuardianSecIDType.DataSource = identificationTypes;
        cmbGuardianSecIDType.DataBind();

    }


    private DataTable CountriesOrStates(bool isState)
    {
        return SqlHelper.ExecuteDataTableProcedureParams(isState ? "web_pr_statetype_list" : "web_pr_countrytype_list", new Dictionary<string, object>());
    }

    #endregion

    #region Getting All Identifications Information

    private void GetAllIdentification()
    {
        var skipLoadingIdentificationData = HideShowPatientGuardianSections();
        if (skipLoadingIdentificationData)
            return;

        // Binding Patient Primary Idenfication

        var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@FlagGuardian", 0 }, { "@FlagPrimary", 1 }, { "@UserID", ClientSession.UserID } };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_identification_get", cmdParams);

        foreach (DataRow row in reader.Rows)
        {
            var identificationTypeId = Convert.ToInt32(row["IdentificationTypeID"].ToString());
            cmbPatientPriIDType.SelectedValue = identificationTypeId.ToString();
            txtPatientPriIDNumber.Text = row["IDNumber"].ToString();
            dtPatientPriIssueDate.SelectedDate = string.IsNullOrEmpty(row["IssueDate"].ToString()) ? (DateTime?)null : Convert.ToDateTime(row["IssueDate"].ToString());
            dtPatientPriExpirationDate.SelectedDate = string.IsNullOrEmpty(row["ExpirationDate"].ToString()) ? (DateTime?)null : Convert.ToDateTime(row["ExpirationDate"].ToString());
            txtPatientPriNotes.Text = row["Notes"].ToString();

            // Binding the Country/State Dropdown
            var stateCountryId = row[identificationTypeId > 10 ? "CountryTypeID" : "StateTypeID"].ToString();
            BindStateDropdown(0, 1, identificationTypeId, stateCountryId);

            // Loading the images details
            LoadImages(0, 1, reader);

        }


        // Binding Patient Secondary Idenfication
        cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@FlagGuardian", 0 }, { "@FlagPrimary", 0 }, { "@UserID", ClientSession.UserID } };
        reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_identification_get", cmdParams);

        foreach (DataRow row in reader.Rows)
        {
            var identificationTypeId = Convert.ToInt32(row["IdentificationTypeID"].ToString());
            cmbPatientSecIDType.SelectedValue = identificationTypeId.ToString();
            txtPatientSecIDNumber.Text = row["IDNumber"].ToString();
            dtPatientSecIssueDate.SelectedDate = string.IsNullOrEmpty(row["IssueDate"].ToString()) ? (DateTime?)null : Convert.ToDateTime(row["IssueDate"].ToString());
            dtPatientSecExpirationDate.SelectedDate = string.IsNullOrEmpty(row["ExpirationDate"].ToString()) ? (DateTime?)null : Convert.ToDateTime(row["ExpirationDate"].ToString());
            txtPatientSecNotes.Text = row["Notes"].ToString();

            // Binding the Country/State Dropdown
            var stateCountryId = row[identificationTypeId > 10 ? "CountryTypeID" : "StateTypeID"].ToString();
            BindStateDropdown(0, 0, identificationTypeId, stateCountryId);

            // Loading the images details
            LoadImages(0, 0, reader);
        }


        // Binding Guardian Primary Idenfication
        cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@FlagGuardian", 1 }, { "@FlagPrimary", 1 }, { "@UserID", ClientSession.UserID } };
        reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_identification_get", cmdParams);

        foreach (DataRow row in reader.Rows)
        {
            var identificationTypeId = Convert.ToInt32(row["IdentificationTypeID"].ToString());
            cmbGuardianPriIDType.SelectedValue = identificationTypeId.ToString();
            txtGuardianPriIDNumber.Text = row["IDNumber"].ToString();
            dtGuardianPriIssueDate.SelectedDate = string.IsNullOrEmpty(row["IssueDate"].ToString()) ? (DateTime?)null : Convert.ToDateTime(row["IssueDate"].ToString());
            dtGuardianPriExpirationDate.SelectedDate = string.IsNullOrEmpty(row["ExpirationDate"].ToString()) ? (DateTime?)null : Convert.ToDateTime(row["ExpirationDate"].ToString());
            txtGuardianPriNotes.Text = row["Notes"].ToString();

            // Binding the Country/State Dropdown
            var stateCountryId = row[identificationTypeId > 10 ? "CountryTypeID" : "StateTypeID"].ToString();
            BindStateDropdown(1, 1, identificationTypeId, stateCountryId);

            // Loading the images details
            LoadImages(1, 1, reader);

        }



        // Binding Guardian Secondary Idenfication
        cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.SelectedPatientID }, { "@FlagGuardian", 1 }, { "@FlagPrimary", 0 }, { "@UserID", ClientSession.UserID } };
        reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_identification_get", cmdParams);

        foreach (DataRow row in reader.Rows)
        {
            var identificationTypeId = Convert.ToInt32(row["IdentificationTypeID"].ToString());
            cmbGuardianSecIDType.SelectedValue = identificationTypeId.ToString();
            txtGuardianSecIDNumber.Text = row["IDNumber"].ToString();
            dtGuardianSecIssueDate.SelectedDate = string.IsNullOrEmpty(row["IssueDate"].ToString()) ? (DateTime?)null : Convert.ToDateTime(row["IssueDate"].ToString());
            dtGuardianSecExpirationDate.SelectedDate = string.IsNullOrEmpty(row["ExpirationDate"].ToString()) ? (DateTime?)null : Convert.ToDateTime(row["ExpirationDate"].ToString());
            txtGuardianSecNotes.Text = row["Notes"].ToString();

            // Binding the Country/State Dropdown
            var stateCountryId = row[identificationTypeId > 10 ? "CountryTypeID" : "StateTypeID"].ToString();
            BindStateDropdown(1, 0, identificationTypeId, stateCountryId);

            // Loading the images details
            LoadImages(1, 0, reader);
        }



    }

    private bool HideShowPatientGuardianSections()
    {
        var flagPatientMinor = Convert.ToBoolean(ViewState["FlagPatientMinor"]);
        var flagGuardianExists = Convert.ToBoolean(ViewState["FlagGuardianExists"]);

        // Hiding Sections 
        if (flagPatientMinor)
        {
            pnlPatientInformation.Visible = false;
            pnlPatientInformation.Enabled = false;
            divPatient.Visible = true;
        }

        if (!flagGuardianExists)
        {
            pnlGuardianInformation.Visible = false;
            pnlGuardianInformation.Enabled = false;
            divGuardian.Visible = true;
        }

        // Hiding submit button
        if (flagPatientMinor && !flagGuardianExists)
        {
            btnSubmit.Visible = false;
            btnSubmit.Enabled = false;
            return true;
        }

        return false;
    }

    #endregion

    #region Saving All Identifications

    protected void btnSubmit_SaveAllIdentifications(object sender, EventArgs e)
    {
        try
        {
            // Saving Images
            SaveUploadedFiles();

            // Saving Identification for the Patient Primary Information
            var cmdParams = new Dictionary<string, object>
        {
            {"@IdentificationTypeID", cmbPatientPriIDType.SelectedValue},
            {"@PatientID", ClientSession.SelectedPatientID},
            {"@IDNumber ", txtPatientPriIDNumber.Text},
            {"@StateTypeID",  GetIdentificationId(cmbPatientPriIDType.SelectedValue) <= 10  ? cmbPatientPriStateCountry.SelectedValue : "0"},
            {"@CountryTypeID", GetIdentificationId(cmbPatientPriIDType.SelectedValue)  > 10  ? cmbPatientPriStateCountry.SelectedValue : "0"},
            {"@IssueDate", dtPatientPriIssueDate.SelectedDate ?? (object)DBNull.Value},
            {"@ExpirationDate", dtPatientPriExpirationDate.SelectedDate ?? (object)DBNull.Value},
            {"@Notes", txtPatientPriNotes.Text},
            {"@FlagGuardian", 0},
            {"@FlagPrimary", 1},
            {"@UserID", ClientSession.UserID}
        };

            // Assigning values to params
            AssignValuesToParams("01", cmdParams);


            SqlHelper.ExecuteScalarProcedureParams("web_pr_identification_add", cmdParams);


            // Saving Identification for the Patient Secondary
            cmdParams = new Dictionary<string, object>
        {
            {"@IdentificationTypeID", cmbPatientSecIDType.SelectedValue},
            {"@PatientID", ClientSession.SelectedPatientID},
            {"@IDNumber ", txtPatientSecIDNumber.Text},
            {"@StateTypeID",  GetIdentificationId(cmbPatientSecIDType.SelectedValue) <= 10  ? cmbPatientSecStateCountry.SelectedValue : "0"},
            {"@CountryTypeID", GetIdentificationId(cmbPatientSecIDType.SelectedValue) > 10  ? cmbPatientSecStateCountry.SelectedValue : "0"},
            {"@IssueDate", dtPatientSecIssueDate.SelectedDate ?? (object)DBNull.Value},
            {"@ExpirationDate", dtPatientSecExpirationDate.SelectedDate ?? (object)DBNull.Value},
            {"@Notes", txtPatientSecNotes.Text},
            {"@FlagGuardian", 0},
            {"@FlagPrimary", 0},
            {"@UserID", ClientSession.UserID}
        };

            // Assigning values to params
            AssignValuesToParams("00", cmdParams);

            SqlHelper.ExecuteScalarProcedureParams("web_pr_identification_add", cmdParams);


            // Saving Identification for the Guardian Primary
            cmdParams = new Dictionary<string, object>
        {
            {"@IdentificationTypeID", cmbGuardianPriIDType.SelectedValue},
            {"@PatientID", ClientSession.SelectedPatientID},
            {"@IDNumber ", txtGuardianPriIDNumber.Text},
            {"@StateTypeID",  GetIdentificationId(cmbGuardianPriIDType.SelectedValue) <= 10  ? cmbGuardianPriStateCountry.SelectedValue : "0"},
            {"@CountryTypeID", GetIdentificationId(cmbGuardianPriIDType.SelectedValue) > 10  ? cmbGuardianPriStateCountry.SelectedValue : "0"},
            {"@IssueDate", dtGuardianPriIssueDate.SelectedDate ?? (object)DBNull.Value},
            {"@ExpirationDate", dtGuardianPriExpirationDate.SelectedDate ?? (object)DBNull.Value},
            {"@Notes", txtGuardianPriNotes.Text},
            {"@FlagGuardian", 1},
            {"@FlagPrimary", 1},
            {"@UserID", ClientSession.UserID}
        };

            // Assigning values to params
            AssignValuesToParams("11", cmdParams);

            SqlHelper.ExecuteScalarProcedureParams("web_pr_identification_add", cmdParams);


            // Saving Identification for the Guardian Secondary
            cmdParams = new Dictionary<string, object>
         {
            {"@IdentificationTypeID", cmbGuardianSecIDType.SelectedValue},
            {"@PatientID", ClientSession.SelectedPatientID},
            {"@IDNumber ", txtGuardianSecIDNumber.Text},
            {"@StateTypeID",   GetIdentificationId(cmbGuardianSecIDType.SelectedValue) <= 10  ? cmbGuardianSecStateCountry.SelectedValue : "0"},
            {"@CountryTypeID", GetIdentificationId(cmbGuardianSecIDType.SelectedValue) > 10  ? cmbGuardianSecStateCountry.SelectedValue : "0"},
            {"@IssueDate", dtGuardianSecIssueDate.SelectedDate ?? (object)DBNull.Value},
            {"@ExpirationDate", dtGuardianSecExpirationDate.SelectedDate ?? (object)DBNull.Value},
            {"@Notes", txtGuardianSecNotes.Text},
            {"@FlagGuardian", 1},
            {"@FlagPrimary", 0},
            {"@UserID", ClientSession.UserID}
        };

            // Assigning values to params
            AssignValuesToParams("10", cmdParams);

            SqlHelper.ExecuteScalarProcedureParams("web_pr_identification_add", cmdParams);

            var callbackFunction = ClientSession.IsRedirectToBluecredit.ParseBool() ? "refreshPage" : "redirectToPatientDashboard";
            windowManager.RadAlert("Record successfully updated.", 350, 150, "", callbackFunction, "../Content/Images/success.png");

            // Checking if request came from bluecredit page then assigning value to auto open bluecredit Add popup
            ClientSession.IsBlueCreditAddRequest = ClientSession.IsRedirectToBluecredit;

        }
        catch (Exception)
        {
            throw;
        }


    }

    private void AssignValuesToParams(string flags, IDictionary<string, object> cmdParams)
    {
        if (ViewState["Image" + flags] == null) return;
        var imageInformation = (CustomUploadedFileInfo)ViewState["Image" + flags];
        cmdParams.Add("@IdentificationId", imageInformation.IdentificationId);
        cmdParams.Add("@ImgCard1Name", imageInformation.FileName);
        cmdParams.Add("@ImgCard1GUID", string.IsNullOrEmpty(imageInformation.FileName) ? (object)DBNull.Value : imageInformation.ID);
    }

    private static Int32 GetIdentificationId(string id)
    {
        Int32 identificationId;
        Int32.TryParse(id ?? "0", out identificationId);
        return identificationId;
    }

    #endregion

    #region Common Functions and other functions

    protected void cmbIdentifications_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
    {
        var identificationComboBox = (RadComboBox)sender;
        var identificationId = Convert.ToInt32(identificationComboBox.SelectedValue);
        var isEnable = identificationId > 0;

        if (identificationComboBox.ID.Contains("PatientPri"))
        {
            BindStateDropdown(0, 1, identificationId, null);
            AddRemoveValidationsandClearFields(0, 1, isEnable);
        }
        else if (identificationComboBox.ID.Contains("PatientSec"))
        {
            BindStateDropdown(0, 0, identificationId, null);
            AddRemoveValidationsandClearFields(0, 0, isEnable);
        }
        else if (identificationComboBox.ID.Contains("GuardianPri"))
        {
            BindStateDropdown(1, 1, identificationId, null);
            AddRemoveValidationsandClearFields(1, 1, isEnable);
        }
        else
        {
            BindStateDropdown(1, 0, identificationId, null);
            AddRemoveValidationsandClearFields(1, 0, isEnable);
        }
    }


    private void BindStateDropdown(int flagGuardian, int flagPrimary, int identificationTypeId, string selectedValue)
    {
        var isIdentificationIdGreater = identificationTypeId > 10;
        var statesOrCountries = isIdentificationIdGreater ? CountriesOrStates(false) : CountriesOrStates(true);
        var stateCountry = isIdentificationIdGreater ? "CountryTypeID" : "StateTypeID";

        if (flagGuardian == 0 && flagPrimary == 1)
        {
            cmbPatientPriStateCountry.ClearSelection();
            cmbPatientPriStateCountry.DataValueField = stateCountry;
            cmbPatientPriStateCountry.DataSource = statesOrCountries;
            cmbPatientPriStateCountry.DataBind();
            cmbPatientPriStateCountry.SelectedValue = selectedValue;
        }
        else if (flagGuardian == 0 && flagPrimary == 0)
        {
            cmbPatientSecStateCountry.ClearSelection();
            cmbPatientSecStateCountry.DataValueField = stateCountry;
            cmbPatientSecStateCountry.DataSource = statesOrCountries;
            cmbPatientSecStateCountry.DataBind();
            cmbPatientSecStateCountry.SelectedValue = selectedValue;
        }
        else if (flagGuardian == 1 && flagPrimary == 1)
        {
            cmbGuardianPriStateCountry.ClearSelection();
            cmbGuardianPriStateCountry.DataValueField = stateCountry;
            cmbGuardianPriStateCountry.DataSource = statesOrCountries;
            cmbGuardianPriStateCountry.DataBind();
            cmbGuardianPriStateCountry.SelectedValue = selectedValue;
        }
        else
        {
            cmbGuardianSecStateCountry.ClearSelection();
            cmbGuardianSecStateCountry.DataValueField = stateCountry;
            cmbGuardianSecStateCountry.DataSource = statesOrCountries;
            cmbGuardianSecStateCountry.DataBind();
            cmbGuardianSecStateCountry.SelectedValue = selectedValue;
        }

    }

    private void AddRemoveValidationsandClearFields(int flagGuardian, int flagPrimary, bool isEnable)
    {

        var expirationMinDate = isEnable ? DateTime.Now.AddDays(1) : Convert.ToDateTime("1900/1/1"); ;
        var expirationMaxDate = Convert.ToDateTime("1/1/2030");
        var issueMinDate = isEnable ? Convert.ToDateTime("1/1/1950") : Convert.ToDateTime("1900/1/1");
        var issueMaxDate = isEnable ? DateTime.Now : Convert.ToDateTime("1/1/2030");

        if (flagGuardian == 0 && flagPrimary == 1)
        {
            cstmPatientPriIDNumberValidator.Enabled = isEnable;
            rqdPatientPriStateCountryValidator.Enabled = isEnable;
            rqdPatientPriExpirationDateValidator.Enabled = isEnable;
            dtPatientPriExpirationDate.MinDate = expirationMinDate;
            dtPatientPriExpirationDate.MaxDate = expirationMaxDate;
            dtPatientPriIssueDate.MinDate = issueMinDate;
            dtPatientPriIssueDate.MaxDate = issueMaxDate;
            cmbPatientPriStateCountry.ClearSelection();

            if (isEnable)
            {
                cmbPatientPriStateCountry.Focus();
            }
        }
        else if (flagGuardian == 0 && flagPrimary == 0)
        {
            cstmPatientSecIDNumberValidator.Enabled = isEnable;
            rqdPatientSecStateCountryValidator.Enabled = isEnable;
            rqdPatientSecExpirationDateValidator.Enabled = isEnable;
            dtPatientSecExpirationDate.MinDate = expirationMinDate;
            dtPatientSecExpirationDate.MaxDate = expirationMaxDate;
            dtPatientSecIssueDate.MinDate = issueMinDate;
            dtPatientSecIssueDate.MaxDate = issueMaxDate;
            cmbPatientSecStateCountry.ClearSelection();

            if (isEnable)
            {
                cmbPatientSecStateCountry.Focus();
            }

        }
        else if (flagGuardian == 1 && flagPrimary == 1)
        {
            cstmGuardianPriIDNumberValidator.Enabled = isEnable;
            rqdGuardianPriStateCountryValidator.Enabled = isEnable;
            rqdGuardianPriExpirationDateValidator.Enabled = isEnable;
            dtGuardianPriExpirationDate.MinDate = expirationMinDate;
            dtGuardianPriExpirationDate.MaxDate = expirationMaxDate;
            dtGuardianPriIssueDate.MinDate = issueMinDate;
            dtGuardianPriIssueDate.MaxDate = issueMaxDate;
            cmbGuardianPriStateCountry.ClearSelection();

            if (isEnable)
            {
                cmbGuardianPriStateCountry.Focus();
            }
        }
        else
        {
            cstmGuardianSecIDNumberValidator.Enabled = isEnable;
            rqdGuardianSecStateCountryValidator.Enabled = isEnable;
            rqdGuardianSecExpirationDateValidator.Enabled = isEnable;
            dtGuardianSecExpirationDate.MinDate = expirationMinDate;
            dtGuardianSecExpirationDate.MaxDate = expirationMaxDate;
            dtGuardianSecIssueDate.MinDate = issueMinDate;
            dtGuardianSecIssueDate.MaxDate = issueMaxDate;
            cmbGuardianSecStateCountry.ClearSelection();

            if (isEnable)
            {
                cmbGuardianSecStateCountry.Focus();
            }
        }

        if (isEnable) return;
        ClearFields(flagGuardian, flagPrimary);

    }

    protected void btnClear_OnClick(object sender, EventArgs e)
    {
        var imageButton = (ImageButton)sender;

        switch (imageButton.ID)
        {
            case "btnGuardianSecClear":
                ClearFields(1, 0);
                break;

            case "btnGuardianPriClear":
                ClearFields(1, 1);
                break;

            case "btnPatientPriClear":
                ClearFields(0, 1);
                break;
            default:
                ClearFields(0, 0);
                break;

        }


    }

    private void ClearFields(int flagGuardian, int flagPrimary)
    {
        if (flagGuardian == 0 && flagPrimary == 1)
        {
            cmbPatientPriIDType.ClearSelection();
            txtPatientPriIDNumber.Text = string.Empty;
            dtPatientPriIssueDate.Clear();
            dtPatientPriExpirationDate.Clear();
            txtPatientPriNotes.Text = string.Empty;
            cmbPatientPriStateCountry.ClearSelection();
        }
        else if (flagGuardian == 0 && flagPrimary == 0)
        {
            cmbPatientSecIDType.ClearSelection();
            txtPatientSecIDNumber.Text = string.Empty;
            dtPatientSecIssueDate.Clear();
            dtPatientSecExpirationDate.Clear();
            txtPatientSecNotes.Text = string.Empty;
            cmbPatientSecStateCountry.ClearSelection();

        }
        else if (flagGuardian == 1 && flagPrimary == 1)
        {
            cmbGuardianPriIDType.ClearSelection();
            txtGuardianPriIDNumber.Text = string.Empty;
            dtGuardianPriIssueDate.Clear();
            dtGuardianPriExpirationDate.Clear();
            txtGuardianPriNotes.Text = string.Empty;
            cmbGuardianPriStateCountry.ClearSelection();
        }
        else
        {
            cmbGuardianSecIDType.ClearSelection();
            txtGuardianSecIDNumber.Text = string.Empty;
            cmbGuardianSecStateCountry.ClearSelection();
            dtGuardianSecIssueDate.Clear();
            dtGuardianSecExpirationDate.Clear();
            txtGuardianSecNotes.Text = string.Empty;
        }

        RemoveImage(flagGuardian, flagPrimary);
    }

    private void RemoveImage(int flagGuardian, int flagPrimary)
    {
        if (flagGuardian == 0 && flagPrimary == 1)
        {
            ManageCustomUploadedInfo("01");
            divDownloadRemovePatientPrimary.Visible = false;
            divCardImagePatientPrimary.Visible = true;
        }
        else if (flagGuardian == 0 && flagPrimary == 0)
        {
            ManageCustomUploadedInfo("00");
            divDownloadRemovePatientSecondary.Visible = false;
            divCardImagePatientSecondary.Visible = true;

        }
        else if (flagGuardian == 1 && flagPrimary == 1)
        {
            ManageCustomUploadedInfo("11");
            divDownloadRemoveGuardianPrimary.Visible = false;
            divCardImageGuardianPrimary.Visible = true;
        }
        else
        {
            ManageCustomUploadedInfo("10");
            divDownloadRemoveGuardianSecondary.Visible = false;
            divCardImageGuardianSecondary.Visible = true;
        }
    }

    #endregion

    #region Managing Images

    protected void ImageDownload_Click(object sender, ImageClickEventArgs e)
    {
        var button = (ImageButton)sender;
        string fileName = string.Empty, id = string.Empty;

        if (button.ID.Contains("btnDownloadPatientPrimary"))
        {
            var info = (CustomUploadedFileInfo)ViewState["Image01"];
            fileName = info.FileName;
            id = info.ID;
        }
        else if (button.ID.Contains("btnDownloadPatientSecondary"))
        {
            var info = (CustomUploadedFileInfo)ViewState["Image00"];
            fileName = info.FileName;
            id = info.ID;
        }
        else if (button.ID.Contains("btnDownloadGuardianPrimary"))
        {
            var info = (CustomUploadedFileInfo)ViewState["Image11"];
            fileName = info.FileName;
            id = info.ID;
        }
        else
        {
            var info = (CustomUploadedFileInfo)ViewState["Image10"];
            fileName = info.FileName;
            id = info.ID;
        }

        var location = GetSavedImageLocation();
        location = Path.Combine(location, id);
        var returnmsg = PDFServices.FileDownload(location, fileName);
        if (returnmsg != "")
        {
            windowManager.RadAlert(returnmsg, 350, 150, "", "");
        }
    }
    protected void ImageRemove_Click(object sender, ImageClickEventArgs e)
    {
        var imageButton = (ImageButton)sender;

        if (imageButton.ID.Contains("btnRemovePatientPrimary"))
        {
            RemoveImage(0, 1);
        }
        else if (imageButton.ID.Contains("btnRemovePatientSecondary"))
        {
            RemoveImage(0, 0);
        }
        else if (imageButton.ID.Contains("btnRemoveGuardianPrimary"))
        {
            RemoveImage(1, 1);
        }
        else
        {
            RemoveImage(1, 0);
        }

    }

    private void ManageCustomUploadedInfo(string flags)
    {
        if (ViewState["Image" + flags] == null) return;
        var imageInformation = (CustomUploadedFileInfo)ViewState["Image" + flags];
        imageInformation.FileName = null;

        ViewState["Image" + flags] = imageInformation;
    }

    private string GetSavedImageLocation()
    {
        var path = ClientSession.FilePathIdentification;

        if (!Directory.Exists(path))
            Directory.CreateDirectory(path);

        return path;
    }

    private void LoadImages(int flagGuardian, int flagPrimary, DataTable reader)
    {
        foreach (DataRow row in reader.Rows)
        {
            var insuranceImage = new CustomUploadedFileInfo
               {
                   ID = row["ImgCard1GUID"].ToString(),
                   FileName = row["ImgCard1Name"].ToString(),
                   IdentificationId = Convert.ToInt32(row["IdentificationID"])
               };

            ViewState["Image" + flagGuardian + flagPrimary] = insuranceImage;

            if (flagGuardian == 0 && flagPrimary == 1)
            {
                if (!string.IsNullOrEmpty(row["ImgCard1GUID"].ToString()))
                {
                    lblFileNamePatientPrimary.Text = row["ImgCard1Name"].ToString();
                    divDownloadRemovePatientPrimary.Visible = true;
                    divCardImagePatientPrimary.Visible = false;
                }
            }
            else if (flagGuardian == 0 && flagPrimary == 0)
            {
                if (!string.IsNullOrEmpty(row["ImgCard1GUID"].ToString()))
                {
                    lblFileNamePatientSecondary.Text = row["ImgCard1Name"].ToString();
                    divDownloadRemovePatientSecondary.Visible = true;
                    divCardImagePatientSecondary.Visible = false;
                }
            }
            else if (flagGuardian == 1 && flagPrimary == 1)
            {
                if (!string.IsNullOrEmpty(row["ImgCard1GUID"].ToString()))
                {
                    lblFileNameGuardianPrimary.Text = row["ImgCard1Name"].ToString();
                    divDownloadRemoveGuardianPrimary.Visible = true;
                    divCardImageGuardianPrimary.Visible = false;
                }
            }
            else
            {
                if (!string.IsNullOrEmpty(row["ImgCard1GUID"].ToString()))
                {
                    lblFileNameGuardianSecondary.Text = row["ImgCard1Name"].ToString();
                    divDownloadRemoveGuardianSecondary.Visible = true;
                    divCardImageGuardianSecondary.Visible = false;
                }
            }
        }
    }

    private void SaveUploadedFiles()
    {
        var location = GetSavedImageLocation();


        foreach (UploadedFile file in insPatientPrimaryImageUpload.UploadedFiles)
        {
            AssignFileInformationToViewState(file, location, "01");
        }

        foreach (UploadedFile file in insPatientSecondaryImageUpload.UploadedFiles)
        {
            AssignFileInformationToViewState(file, location, "00");
        }

        foreach (UploadedFile file in insGuardianPrimaryImageUpload.UploadedFiles)
        {
            AssignFileInformationToViewState(file, location, "11");
        }

        foreach (UploadedFile file in insGuardianSecondaryImageUpload.UploadedFiles)
        {
            AssignFileInformationToViewState(file, location, "10");
        }

    }

    private void AssignFileInformationToViewState(UploadedFile file, string location, string flags)
    {
        var imageInfo = new CustomUploadedFileInfo { ID = Guid.NewGuid().ToString() };
        var fileName = file.GetName();
        file.SaveAs(location + imageInfo.ID);

        imageInfo.FileName = fileName;
        imageInfo.IsAddUpdate = true;

        var customFileInfo = (CustomUploadedFileInfo)ViewState["Image" + flags];
        if (customFileInfo != null)
        {
            imageInfo.IdentificationId = customFileInfo.IdentificationId;
        }

        ViewState["Image" + flags] = imageInfo;
    }

    #endregion
}