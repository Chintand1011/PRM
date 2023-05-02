using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class welcome : BasePage
{
    #region Welcome Detail's Properties

    public string PracticeName { get; set; }
    public string ProviderName { get; set; }
    public string Addr1 { get; set; }
    public string Addr2 { get; set; }
    public string City { get; set; }
    public string StateAbbr { get; set; }
    public string Zip { get; set; }
    public string Phone { get; set; }
    public string Fax { get; set; }
    public string LogoName { get; set; }
    public string LogoWidth { get; set; }
    public string LogoHeight { get; set; }
    public string InvInquiryNote { get; set; }
    public string InvPayNote { get; set; }
   

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                GetWelcomeDetails();
            }
            catch (Exception)
            {
                throw;
            }
        }
    }



    private void GetWelcomeDetails()
    {
        var cmdParam = new Dictionary<string, object>
                           {
                               {"@AccountID",ClientSession.AccountID}
                           };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pt_welcome_get", cmdParam);
        foreach (DataRow row in reader.Rows)
        {
            PracticeName = row["PracticeName"].ToString();

            ProviderName = row["ProviderName"].ToString();

            Addr1 = row["Addr1"].ToString();

            Addr2 = row["Addr2"].ToString();

            City = row["City"].ToString();

            StateAbbr = row["StateAbbr"].ToString();

            Zip = row["Zip"].ToString();

            Phone = row["Phone"].ToString();

            Fax = row["Fax"].ToString();

            LogoName = row["LogoName"].ToString();

            LogoWidth = row["LogoWidth"].ToString();

            LogoHeight = row["LogoHeight"].ToString();

            InvInquiryNote = row["InvInquiryNote"].ToString();

            InvPayNote = row["InvPayNote"].ToString();

            if ((int)row["EmailBounceCnt"] > 0)
            {
                litBounceEmail.Text = "<img src='content/images/icon_error.gif'; style='margin-bottom:-3px;'>&nbsp;  Last email attempt unsuccessful, please update email address.";
            }

            lblLastWebLogin.Text = row["LastLoginWeb"].ToString();
            lblLastMobileLogin.Text = row["LastLoginMobile"].ToString();

            var fields = new Dictionary<string, string>
            {
                {"Address1", row["PtAddr1"].ToString()},
                {"Address2", row["PtAddr2"].ToString()},
                {"City", row["PtCity"].ToString()},
                {"StateID", row["PtStateTypeID"].ToString()},
                {"ZipCode", row["PtZip"].ToString()}
            };

            // Set patient information
            ClientSession.PatientInfo = fields;
        }
    }
}