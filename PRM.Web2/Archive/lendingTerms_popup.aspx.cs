using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OpenSource;
using PatientPortal.DataLayer;
using PatientPortal.Utility;

public partial class lendingTerms_popup : System.Web.UI.Page
{
    #region Blue Credit Terms Properties

    public string PatientName { get; set; }
    public string BorrowerName { get; set; }
    public string BorrowerSSN { get; set; }
    public string BorrowerAddress1 { get; set; }
    public string BorrowerAddress2 { get; set; }
    public string BorrowerPhone { get; set; }
    public string BorrowerEmail { get; set; }
    public string TermsSection1 { get; set; }
    public string TermsSection2 { get; set; }
    public string TermsSection3 { get; set; }
    public string TermsSection4 { get; set; }
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
        if (!Page.IsPostBack)
        {
            try
            {
                ClientSession.WasRequestFromPopup = true;
                GetBlueCreditDetails();
            }
            catch (Exception)
            {

                throw;
            }
        }
    }

    private void GetBlueCreditDetails()
    {
        int flagGuardianPay = 0, addrPrimaryID = 0;
        var values = ClientSession.ObjectValue as Dictionary<string, int>;
        // validating if values not null and trying to fetching the flagGuardianPay and addrPrimaryID
        if (values != null)
        {
            values.TryGetValue("FlagGuardianPay", out flagGuardianPay);
            values.TryGetValue("AddrPrimaryID", out addrPrimaryID);
        }

        // if ClientSession.ObjectID is greater than 0 and ClientSession.ObjectType == ObjectType.BlueCreditDetail then we're passing the BluecreditID else passing DBNull
        var cmbParams = new Dictionary<string, object>
                            {
                                {"@PatientID", ClientSession.SelectedPatientID},
                                {"@FlagGuardianPay", flagGuardianPay},
                                {"@AddrPrimaryID", addrPrimaryID},
                                {"@BlueCreditID", Convert.ToInt32(ClientSession.ObjectID) > 0 && ClientSession.ObjectType == ObjectType.BlueCreditDetail? ClientSession.ObjectID : DBNull.Value},
                                {"@UserID", ClientSession.UserID}
                            };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_til_get", cmbParams);
        foreach (DataRow row in reader.Rows)
        {
            PatientName = row["PatientName"].ToString();
            BorrowerName = row["BorrowerName"].ToString();
            BorrowerAddress1 = row["BorrowerAddress1"].ToString();
            BorrowerAddress2 = row["BorrowerAddress2"].ToString();
            //BorrowerSSN = CryptorEngine.Decrypt(row["BorrowerSSNenc"].ToString());
            BorrowerPhone = row["BorrowerPhonePri"].ToString();
            BorrowerEmail = row["BorrowerEmail"].ToString();
            TermsSection1 = row["TermsSection1"].ToString();
            TermsSection2 = row["TermsSection2"].ToString();
            TermsSection3 = row["TermsSection3"].ToString();
            TermsSection4 = row["TermsSection4"].ToString();
        }
    }



}