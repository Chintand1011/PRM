using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using PatientPortal.DataLayer;
using System.Web.UI.WebControls;
using PatientPortal.Utility;

public partial class bluecreditApplication_popup : Page
{

    #region Labels

    #region Bluecredit Labels

    public string AccountId { get; set; }
    public string CreditTypeID { get; set; }
    public string PlanName { get; set; }
    public string CreditStatusTypeID { get; set; }
    public string CreditStatusTypeAbbr { get; set; }
    public string FlagCreditEligible { get; set; }
    public string CreditLimit { get; set; }
    public string CreditLimitCurrency { get; set; }
    public string CreditLimitMax { get; set; }
    public string Balance { get; set; }
    public string BalanceCurrency { get; set; }
    public string LastCycle { get; set; }
    public string MinDownPayRate { get; set; }
    public string MaxDownPay { get; set; }
    public string MaxDownPayCurrency { get; set; }
    public string RatePromo { get; set; }
    public string TermPromo { get; set; }
    public string RateStd { get; set; }
    public string TermStd { get; set; }
    public string RateTermStdAbbr { get; set; }
    public string TermMax { get; set; }
    public string TermMaxAbbr { get; set; }
    public string DefaultAbbr { get; set; }
    public string LateFee { get; set; }
    public string MaxExtensionUndo { get; set; }
    public string MaxExtension { get; set; }
    public string MinPayRate { get; set; }
    public string MinPayDollar { get; set; }
    public string OpenDate { get; set; }
    public string AccountHolder { get; set; }
    public string AccountHolderType { get; set; }
    public string AccountName { get; set; }
    public string AddrAbbr { get; set; }
    public string City { get; set; }

    public string Email { get; set; }
    public string FlagEmailBillsAbbrVerbose { get; set; }
    public string MinDownPay { get; set; }
    public string MinPayAmount { get; set; }
    public string PhonePri { get; set; }
    public string PhoneSec { get; set; }
    public string PromoRemainAbbr { get; set; }
    public string PtSetRecurringMin { get; set; }
    public string State { get; set; }
    public string StateTypeID { get; set; }
    public string TermRemainAbbr { get; set; }
    public string ZipAbbr { get; set; }
    public string PaymentCardAbbr { get; set; }
    public string PaymentCardFeeAbbr { get; set; }
    public string PaymentCardSecAbbr { get; set; }
    public string Notes { get; set; }
    public string PtSetRecurringMinCurrency { get; set; }
    public string NextPayAmountCurrency { get; set; }
    public string MinPayAmountCurrency { get; set; }
    public string NextPayDate { get; set; }
    public string PaymentDueDay { get; set; }
    
    public string FileLATimestamp { get; set; }
    public string BlueCreditSSN { get; set; }
    public string BlueCreditSSN4 { get; set; }
    public string PracticeName { get; set; }
    public string PracticeAddress1 { get; set; }
    public string PracticeAddress2 { get; set; }
    public string PracticePhone { get; set; }
    public string PracticeFax { get; set; }
    public string CompanyName { get; set; }
    public string CompanyAddress1 { get; set; }
    public string CompanyAddress2 { get; set; }
    public string CompanyBlueCreditPhone { get; set; }
    public string CompanyFax { get; set; }

    #endregion

    #region Identification Labels

    public Int32 IdentificationID { get; set; }
    public string IdentificationTypeAbbr { get; set; }
    public string IDNumber { get; set; }
    public string LocationAbbr { get; set; }
    public string DOB { get; set; }
    public DateTime? IssueDate { get; set; }

    public string ExpirationDate { get; set; }

    #endregion


    #endregion

    public EndPointSession ClientSession
    {
        get
        {
            if (HttpContext.Current.Session["ClientSession"] == null)
                HttpContext.Current.Session["ClientSession"] = new EndPointSession();
            return (EndPointSession)HttpContext.Current.Session["ClientSession"];
        }
        set
        {
            HttpContext.Current.Session["ClientSession"] = value;
        }
    }

    public Int32 PatientID
    {
        get
        {
            var patientId = Extension.ClientSession.SelectedPatientID == 0
                ? Int32.Parse(Request.Params["PatientId"])
                : Extension.ClientSession.SelectedPatientID;

            return patientId;

        }
    }

    public Int32 PracticeID
    {
        get
        {
            return Int32.Parse(Request.Params["PracticeId"] ?? Extension.ClientSession.PracticeID.ToString());
        }
    }

    public Int32 BlueCreditID
    {
        get
        {
            return Int32.Parse(Request.Params["BluecreditId"] ?? Extension.ClientSession.ObjectID.ToString());
        }
    }

    public bool IsCreatePdfWithoutSign
    {
        get
        {
            return !string.IsNullOrEmpty(Request.Params["CreatePdfWithoutSign"]);
        }
    }

    public bool IsShowLenderInformation { get { return Request["IsShowLenderInformation"] == null; } }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsCreatePdfWithoutSign && Extension.ClientSession == null)
        {
            throw new Exception("Trying to access the Terms Folder without login");
        }

        if (!Page.IsPostBack)
        {
            GetBluecreditDetails();
            GetPatientIdentifcation();
            ValidateHidePanels();
        }

    }

    private void ValidateHidePanels()
    {
        if (!IsCreatePdfWithoutSign) return;
        pnlSignData.Visible = false;
        pnlClientSignImage.Visible = false;
        pnlSign.Visible = true;

    }

    private void GetBluecreditDetails()
    {

        var cmdparams = new Dictionary<string, object>
        {
            { "@PracticeID", PracticeID },
            { "@BluecreditID", BlueCreditID },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_get", cmdparams);
        foreach (DataRow row in reader.Rows)
        {

            AccountHolder = row["AccountHolder"].ToString();
            AccountHolderType = row["AccountHolderType"].ToString();
            AccountName = row["AccountName"].ToString();
            AddrAbbr = row["AddrAbbr"].ToString();
            City = row["City"].ToString();
            CreditLimit = row["CreditLimit$"].ToString();
            PlanName = row["PlanName"].ToString();
            Email = row["Email"].ToString();
            FlagEmailBillsAbbrVerbose = row["FlagEmailBillsAbbrVerbose"].ToString();
            MinDownPay = row["MinDownPay$"].ToString();
            MinPayAmount = row["MinPayAmount$"].ToString();
            OpenDate = row["OpenDate"].ToString();
            PhonePri = row["PhonePri"].ToString();
            PhoneSec = row["PhoneSec"].ToString();
            PromoRemainAbbr = row["PromoRemainAbbr"].ToString();
            PtSetRecurringMin = row["PtSetRecurringMin$"].ToString();
            State = row["State"].ToString();
            StateTypeID = row["StateTypeID"].ToString();
            TermRemainAbbr = row["TermRemainAbbr"].ToString();
            ZipAbbr = row["ZipAbbr"].ToString();

            CreditStatusTypeAbbr = row["CreditStatusTypeAbbr"].ToString();
            CreditLimitCurrency = row["CreditLimit$"].ToString();
            BalanceCurrency = row["Balance$"].ToString();
            LastCycle = row["LastCycle"].ToString();
            RatePromo = row["RatePromo"].ToString();
            TermPromo = row["TermPromo"].ToString();
            RateStd = row["RateStd"].ToString();
            TermStd = row["TermStd"].ToString();
            PlanName = row["PlanName"].ToString();
            RateTermStdAbbr = row["RateTermStdAbbr"].ToString();
            PlanName = row["PlanName"].ToString();
            TermMax = row["TermMax"].ToString();
            TermMaxAbbr = row["TermMaxAbbr"].ToString();
            DefaultAbbr = row["DefaultAbbr"].ToString();
            LateFee = row["DefaultFee$"].ToString();
            MinPayDollar = row["MinPayDollar"].ToString();
            Notes = row["Notes"].ToString();
            PaymentCardAbbr = row["PaymentCardAbbr"].ToString();
            PaymentCardFeeAbbr = row["PaymentCardFeeAbbr"].ToString();
            PaymentCardSecAbbr = row["PaymentCardSecAbbr"].ToString();
            PtSetRecurringMinCurrency = row["PtSetRecurringMin$"].ToString();
            NextPayAmountCurrency = row["NextPayAmount$"].ToString();
            MinPayAmountCurrency = row["MinPayAmount$"].ToString();
            NextPayDate = row["NextPayDate"].ToString();
            PaymentDueDay = row["PaymentDueDay"].ToString();
            FileLATimestamp = row["FileLATimestamp"].ToString();
            BlueCreditSSN = row["BlueCreditSSNenc"].ToString().Decrypt().ToSSNFormat();
            BlueCreditSSN4 = row["BlueCreditSSN4"].ToString();

            if (IsShowLenderInformation)
            {
                PracticeName = row["PracticeName"].ToString();
                PracticeAddress1 = row["PracticeAddress1"].ToString();
                PracticeAddress2 = row["PracticeAddress2"].ToString();
                PracticePhone = row["PracticePhone"].ToString();
                PracticeFax = row["PracticeFax"].ToString();
                CompanyName = row["CompanyName"].ToString();
                CompanyAddress1 = row["CompanyAddress1"].ToString();
                CompanyAddress2 = row["CompanyAddress2"].ToString();
                CompanyBlueCreditPhone = row["CompanyBlueCreditPhone"].ToString();
                CompanyFax = row["CompanyFax"].ToString();

                btnClose.Visible = false;
            }

            ViewState["CreditTypeID"] = row["CreditTypeID"].ToString();

            var signature = row["LASignature"].ToString();
            
            if (string.IsNullOrEmpty(signature))
            {
                pnlSignData.Visible = true;
                pnlSignData.Enabled = true;
                pnlClientSignImage.Visible = false;
                pnlClientSignImage.Enabled = false;
            }
            else
            {
                pnlSignData.Visible = false;
                pnlSignData.Enabled = false;
                pnlClientSignImage.Visible = true;
                pnlClientSignImage.Enabled = true;
                chkAgreementTerms.Checked = true;
                CreateClientSignImage(signature);
            }

            // Show/Hide resgin button according to the flag
            btnResign.Visible = Convert.ToBoolean(row["FlagLASigResign"]);

            if (Request.Params["BluecreditId"] != null)
            {
                btnResign.Visible = false;
            }
        }
    }

    private void GetPatientIdentifcation()
    {
        var flagGuardian = Request.Params["FlagGuardian"] ?? Extension.ClientSession.ObjectID2;
        var cmdparams = new Dictionary<string, object> { { "@PatientID", PatientID }, { "@flagguardian", flagGuardian }, { "@flagprimary", 1 }, { "@UserID", ClientSession.UserID } };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_identification_get", cmdparams);

        foreach (DataRow row in reader.Rows)
        {
            // PatinetID = (int)indentification["PatientID"];
            IdentificationID = (int)row["IdentificationID"];
            IdentificationTypeAbbr = row["IdentificationTypeAbbr"].ToString();
            IDNumber = row["IDNumber"].ToString();
            LocationAbbr = row["LocationAbbr"].ToString();
            DOB = row["DOBAbbr"].ToString();
            IssueDate = !string.IsNullOrEmpty(row["IssueDate"].ToString()) ? (DateTime)row["IssueDate"] : (DateTime?)null;
            ExpirationDate = row["ExpirationDateAbbr"].ToString();
            Notes = row["Notes"].ToString();
        }
    }


    protected void btnSubmit_OnClick(object sender, EventArgs e)
    {
        if (hdnSigData.Value == "undefined")
            return;

        // Displaying information
        GetBluecreditDetails();
        GetPatientIdentifcation();

        // Hiding signing components
        pnlSignData.Visible = false;
        pnlSignData.Enabled = false;

        // Displaying the image from client sign
        pnlClientSignImage.Visible = true;
        pnlClientSignImage.Enabled = true;
        CreateClientSignImage();

        // Saving the client sign in database
        var fileName = "la_" + ClientSession.ObjectID + ".pdf";
        var cmdParams = new Dictionary<string, object>
        {
            {"@BlueCreditID",ClientSession.ObjectID},
            {"@SigString", hdnSigData.Value},
            {"@FilenameLA", fileName},
            {"@FlagLASig", 1},
            {"@UserID",ClientSession.UserID},
        };


        SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecreditsig_add", cmdParams);
        var filesNeedToBeMerge = new List<string>();

        // Creating PDF
        var source = Path.Combine(ClientSession.FilePathBlueCredit, ClientSession.PracticeID.ToString(), ClientSession.SelectedPatientID + "\\");
        var filePath = source + fileName;

        if (File.Exists(filePath))
        {
            File.Delete(filePath);
        }

        if (!File.Exists(filePath))
        {
            var tempFileName = Guid.NewGuid() + ".pdf";
            filesNeedToBeMerge.Add(source + tempFileName);

            var queryStrings = string.Format("?BlueCreditID={0}&PracticeID={1}", Extension.ClientSession.ObjectID, ClientSession.PracticeID);
            var addtionalParams = string.Format("&PatientId={0}&FlagGuardian={1}", ClientSession.SelectedPatientID, ClientSession.ObjectID2);
            PDFServices.PDFCreate(tempFileName, ClientSession.WebPathRootProvider + "report/bluecreditApplication_popup.aspx" + queryStrings + addtionalParams, source);

            // Copying PDF
            tempFileName = Guid.NewGuid() + ".pdf";
            filesNeedToBeMerge.Add(source + tempFileName);

            var fileNameTerms = string.Format("BlueCredit_Terms_{0}.pdf", ViewState["CreditTypeID"]);
            fileNameTerms = Server.MapPath("~/Terms/BlueCredit/" + fileNameTerms);
            File.Copy(fileNameTerms, source + tempFileName);

            // Merging PDF
            PDFServices.PDFMerge(filesNeedToBeMerge, source, fileName);

        }
        
        PopulateDataForDisplayPDF();

    }

    private void CreateClientSignImage(string sign = null)
    {
        // Getting client sign
        var clientSign = string.IsNullOrEmpty(hdnSigData.Value) ? sign : hdnSigData.Value;
        var bytes = SigPlusNet.GetImageBytesFromClientSign(clientSign);
        var base64String = Convert.ToBase64String(bytes, 0, bytes.Length);
        imgClientSign.ImageUrl = "data:image/png;base64," + base64String;

        // If client sign is empty or null then hiding the image
        if (string.IsNullOrEmpty(clientSign))
        {
            imgClientSign.Visible = false;
        }
        else
        {
            imgClientSign.Visible = true;
        }

    }

    protected void btnResign_OnClick(object sender, EventArgs e)
    {
        // Displaying information
        GetBluecreditDetails();
        GetPatientIdentifcation();

        // Managing the panels and button in order to show clinet sign components
        pnlSignData.Visible = true;
        pnlSignData.Enabled = true;

        pnlClientSignImage.Visible = false;
        pnlClientSignImage.Enabled = false;

    }

    protected void btnShowPdf_OnClick(object sender, EventArgs e)
    {
        // Displaying information
        GetBluecreditDetails();
        GetPatientIdentifcation();

        PopulateDataForDisplayPDF();

    }

    private void PopulateDataForDisplayPDF()
    {
        // For PDF Viewer popup
        ClientSession.ObjectValue = new Dictionary<string, string> { { "FileName", "la" }, { "PageTitle", "Lending Agreement" }, { "IsRequestFromBlueCredit", "True" } };
        Page.ClientScript.RegisterStartupScript(GetType(), "showLaPdf", "showLaPdf();", true);
        Page.ClientScript.RegisterStartupScript(GetType(), "closePopup", "closePopup();", true);
    }

}