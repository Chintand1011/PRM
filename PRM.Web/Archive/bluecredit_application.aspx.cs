using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using PatientPortal.DataLayer;
using System.Web.UI.WebControls;
using PatientPortal.Utility;

public partial class Terms_bluecredit_application : Page
{

    #region Labels

    public string AccountHolder { get; set; }
    public string AccountHolderType { get; set; }
    public string AccountName { get; set; }
    public string Addr1 { get; set; }
    public string Addr2 { get; set; }
    public string City { get; set; }
    public string CreditLimit { get; set; }
    public string PlanName { get; set; }
    public string Email { get; set; }
    public string FlagEmailBillsAbbr { get; set; }
    public string MinDownPay { get; set; }
    public string MinPayAmount { get; set; }
    public string OpenDate { get; set; }
    public string PhonePri { get; set; }
    public string PromoRemainAbbr { get; set; }
    public string PtSetRecurringMin { get; set; }
    public string State { get; set; }
    public string StateTypeID { get; set; }
    public string TermRemainAbbr { get; set; }
    public string Zip { get; set; }
    public string Zip4 { get; set; }
    public Int32 PatinetID { get; set; }
    public Int32 IdentificationID { get; set; }
    public string IdentificationTypeAbbr { get; set; }
    public decimal IDNumber { get; set; }
    public string LocationAbbr { get; set; }
    public DateTime DOB { get; set; }
    public DateTime? IssueDate { get; set; }
    public DateTime ExpirationDate { get; set; }
    public string Notes { get; set; }
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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Extension.ClientSession == null)
        {
            throw new Exception("Trying to access the Terms Folder without login");
        }

        HideSubmitButtons();
        GetBluecreditDetails();
        GetPatientIdentifcation();
    }

    private void HideSubmitButtons()
    {
        var hideButtons = Request.Params["HideButtons"];
        if (hideButtons == "1")
        {
            divButtons.Visible = false;
        }
    }


    private void GetBluecreditDetails()
    {
        var cmdparams = new Dictionary<string, object>
        {
            { "@PracticeID", Extension.ClientSession.PracticeID }, 
            { "@BluecreditID", Extension.ClientSession.ObjectID },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_get", cmdparams);

        foreach (DataRow row in reader.Rows)
        {
            AccountHolder = row["AccountHolder"].ToString();
            AccountHolderType = row["AccountHolderType"].ToString();
            AccountName = row["AccountName"].ToString();
            Addr1 = row["Addr1"].ToString();
            Addr2 = row["Addr2"].ToString();
            City = row["City"].ToString();
            CreditLimit = row["CreditLimit$"].ToString();
            PlanName = row["PlanName"].ToString();
            Email = row["Email"].ToString();
            FlagEmailBillsAbbr = row["FlagEmailBillsAbbr"].ToString();
            MinDownPay = row["MinDownPay$"].ToString();
            MinPayAmount = row["MinPayAmount$"].ToString();
            OpenDate = row["OpenDate"].ToString();
            PhonePri = row["PhonePri"].ToString();
            PromoRemainAbbr = row["PromoRemainAbbr"].ToString();
            PtSetRecurringMin = row["PtSetRecurringMin$"].ToString();
            State = row["State"].ToString();
            StateTypeID = row["StateTypeID"].ToString();
            TermRemainAbbr = row["TermRemainAbbr"].ToString();
            Zip = row["Zip"].ToString();
            Zip4 = row["Zip4"].ToString();
        }
    }

    private void GetPatientIdentifcation()
    {
        var cmdparams = new Dictionary<string, object>
        {
            { "@PatientID", Extension.ClientSession.SelectedPatientID },
            { "@flagguardian", Extension.ClientSession.ObjectID2 },
            { "@flagprimary", 1 },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_identification_get", cmdparams);

        foreach (DataRow row in reader.Rows)
        {
            PatinetID = (int)row["PatientID"];
            IdentificationID = (int)row["IdentificationID"];
            IdentificationTypeAbbr = row["IdentificationTypeAbbr"].ToString();
            IDNumber = Convert.ToInt32(row["IDNumber"]);
            LocationAbbr = row["LocationAbbr"].ToString();
            DOB = (DateTime)row["DOB"];
            IssueDate = !string.IsNullOrEmpty(row["IssueDate"].ToString()) ? (DateTime)row["IssueDate"] : (DateTime?)null;
            ExpirationDate = (DateTime)row["ExpirationDate"];
            Notes = row["Notes"].ToString();
        }
    }


    protected void btnSubmit_Click(object sender, EventArgs e)
    {

        if (hdnSigData.Value == "undefined")
            return;


        // Saving the client sign in database
        var cmdParams = new Dictionary<string, object>
        {
            {"@TransactionID",ClientSession.ObjectID},
            {"@UserID",ClientSession.UserID},
            {"@SigString", hdnSigData.Value}
        };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_transsig_add", cmdParams);

        // Hiding signing components
        pnlSignData.Visible = false;
        pnlSignData.Enabled = false;

        // Displaying the image from client sign
        pnlClientSignImage.Visible = true;
        pnlClientSignImage.Enabled = true;
        CreateClientSignImage();

    }

    private void CreateClientSignImage()
    {
        // Getting client sign
        var clientSign = hdnSigData.Value;
        var bytes = SigPlusNet.GetImageBytesFromClientSign(clientSign);
        var base64String = Convert.ToBase64String(bytes, 0, bytes.Length);
        imgClientSign.ImageUrl = "data:image/png;base64," + base64String;

        // If client sign is empty or null then hiding the image
        if (string.IsNullOrEmpty(clientSign))
        {
            imgClientSign.Visible = false;
            lthtml.Visible = true;
        }
        else
        {
            imgClientSign.Visible = true;
            lthtml.Visible = false;
        }

    }


}