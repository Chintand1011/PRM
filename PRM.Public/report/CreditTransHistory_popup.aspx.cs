using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class CreditTransHistory_popup : BasePage
{
    #region Labels

    public string BlueCreditID { get; set; }
    public string PracticeName { get; set; }
    public string BorrowerName { get; set; }
    public string BorrowerDOB { get; set; }
    public string BorrowerSSN { get; set; }
    public string AccountName { get; set; }
    public string OpenDate { get; set; }
    public string TermAbbr { get; set; }

    #endregion

    public bool IsShowTransactionHistory { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                GetCreditTransactionHistoryInformation();
            }
            catch (Exception)
            {
                throw;
            }
        }
    }

    private void GetCreditTransactionHistoryInformation()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@BlueCreditID", ClientSession.ObjectID },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_til_get", cmdParams);

        foreach (DataRow row in reader.Rows)
        {
            PracticeName = row["PracticeName"].ToString();
            BorrowerName = row["BorrowerName"].ToString();
            BorrowerDOB = row["DateofBirth"].ToString();
            BorrowerSSN = ConvertSsnToFormattedSSN(CryptorEngine.Decrypt(row["BorrowerSSNenc"].ToString()));
            AccountName = row["AccountName"].ToString();
            OpenDate = row["OpenDate"].ToString();
            TermAbbr = row["PlanName"].ToString();
        }
    }

    public static string ConvertSsnToFormattedSSN(string ssn)
    {
        return string.IsNullOrEmpty(ssn) ? ssn : ssn.Insert(3, "-").Insert(6, "-");
    }

    private DataTable GetTransactionHistory()
    {
        var cmdParams = new Dictionary<string, object> { { "@BlueCreditID", ClientSession.ObjectID }, { "@FlagPtSetRecurringMin", 1 } };
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_amortsched", cmdParams);
    }

    protected void grdTransactionHistory_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdTransactionHistory.DataSource = GetTransactionHistory();
    }

    protected void btnPrint_OnClick(object sender, EventArgs e)
    {
        IsShowTransactionHistory = true;
        GetCreditTransactionHistoryInformation();
        grdTransactionHistory.AllowPaging = false;
        grdTransactionHistory.Rebind();
        Page.ClientScript.RegisterStartupScript(GetType(), "Print", "printPopup();", true);
    }


}