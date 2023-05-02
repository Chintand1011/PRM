using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;

public partial class bluecreditSummary_popup : Page
{
    #region Labels

    public string PlanName { get; set; }
    public string PromoRemainAbbr { get; set; }
    public string TermRemainAbbr { get; set; }
    public string RateStd { get; set; }
    public string TermStd { get; set; }
    public string TermMax { get; set; }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Extension.ClientSession == null)
        {
            throw new Exception("Trying to access the Terms Folder without login");
        }

        HideSubmitButtons();
        GetBluecreditDetails();
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
            { "PracticeID", Extension.ClientSession.PracticeID },
            { "BluecreditID", Extension.ClientSession.ObjectID },
            { "@UserID", Extension.ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_get", cmdparams);

        foreach (DataRow row in reader.Rows)
        {
            PlanName = row["PlanName"].ToString();
            PromoRemainAbbr = row["PromoRemainAbbr"].ToString();
            TermRemainAbbr = row["TermRemainAbbr"].ToString();
            RateStd = row["RateStd"].ToString();
            TermStd = row["TermStd"].ToString();
            TermMax = row["TermMax"].ToString();
        }
    }

}