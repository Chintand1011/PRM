using System;
using System.Collections.Generic;
using System.Data;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class report_printStatements_popup : BasePage
{
    #region Properties

    protected string FirstName { get; set; }
    protected string LastName { get; set; }
    protected string PracticeAbbr { get; set; }
    protected string LogoName { get; set; }
    protected string LogoHeight { get; set; }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        AuditLog.CreatePrintLog(Request.UrlReferrer.AbsoluteUri);
        LoadHeaderInformation();
    }

    private void LoadHeaderInformation()
    {
        var cmdParams = new Dictionary<string, object>
        {
            {"@PracticeID", ClientSession.PracticeID},
            {"@UserId", ClientSession.UserID},
        };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_login_reload", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            FirstName = row["NameFirst"].ToString();
            LastName = row["NameLast"].ToString();
            PracticeAbbr = row["PracticeAbbr"].ToString();
            LogoName = row["LogoName"].ToString();
            LogoHeight = row["LogoHeight"].ToString();
        }

        // Assigning Params values
        var filters = ClientSession.ObjectValue as Dictionary<string, object>;
        lblPatientId.Text = filters["@PatientID"].ToString();
        lblPatientStatus.Text = filters["@PtFlagActive"].ToString();
        lblLocation.Text = filters["@LocationID"].ToString();
        lblPatientStatus.Text = filters["@ProviderID"].ToString();
        lblStatementId.Text = filters["@StatementID"].ToString();
        lblStatus.Text = filters["@CreditStatusTypeID"].ToString();
        lblInvoiceMin.Text = FormatDate(filters["@DateMin"]);
        lblInvoiceMax.Text = FormatDate(filters["@DateMax"]);
        lblOBMin.Text = filters["@BalanceMin"].ToString();
        lblOBMax.Text = filters["@BalanceMax"].ToString();
    }

    private DataTable GetStatements()
    {
        var cmdParams = ClientSession.ObjectValue as Dictionary<string, object>;
        if (!cmdParams.ContainsKey("@UserID"))
        {
            cmdParams.Add("@UserID", ClientSession.UserID);
        }
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
    }

    protected void grdStatements_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdStatements.DataSource = GetStatements();
    }

    private static string FormatDate(object objDate)
    {
        objDate = objDate ?? string.Empty;

        DateTime date;
        var isSuccess = DateTime.TryParse(objDate.ToString(), out date);
        return isSuccess ? date.ToShortDateString() : string.Empty;
    }

}