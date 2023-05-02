using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;

public partial class Terms_bluecredit_approval : Page
{
    #region Labels

    public string OpenDate { get; set; }
    public string CreditLimit { get; set; }
    public string Balance { get; set; }
    public string AccountName { get; set; }
    public string AccountHolder { get; set; }

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
            OpenDate = row["OpenDate"].ToString();
            CreditLimit = row["CreditLimit$"].ToString();
            Balance = row["Balance$"].ToString();
            AccountName = row["AccountName"].ToString();
            AccountHolder = row["AccountHolder"].ToString();
        }
    }


}