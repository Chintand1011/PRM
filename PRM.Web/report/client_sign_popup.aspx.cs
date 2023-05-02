using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;

public partial class report_client_sign_popup : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        GetBluecreditDetails();
    }

    private void GetBluecreditDetails()
    {
        var blueCreditID = Convert.ToInt32(Request.Params["BlueCreditID"] ?? Extension.ClientSession.ObjectID);
        var practiceID = Convert.ToInt32(Request.Params["PracticeID"] ?? Extension.ClientSession.PracticeID.ToString());

        var cmbParams = new Dictionary<string, object>
                            {
                                {"@BlueCreditID", blueCreditID}, 
                                {"@PracticeID", practiceID },
                                {"@UserID", Extension.ClientSession.UserID}
                            };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_til_get", cmbParams);
        foreach (DataRow row in reader.Rows)
        {
            var signature = row["PNSignature"].ToString();

            if (string.IsNullOrEmpty(signature))
            {
                pnlClientSignImage.Visible = false;
                pnlClientSignImage.Enabled = false;
                pnlSign.Visible = true;
            }
            else
            {
                pnlClientSignImage.Visible = true;
                pnlClientSignImage.Enabled = true;
                pnlSign.Visible = false;
                chkAgreementTerms.Checked = true;
                CreateClientSignImage(signature);
            }
        }

    }

    private void CreateClientSignImage(string sign)
    {
        var bytes = SigPlusNet.GetImageBytesFromClientSign(sign);
        var base64String = Convert.ToBase64String(bytes, 0, bytes.Length);
        imgClientSign.ImageUrl = "data:image/png;base64," + base64String;

        // If client sign is empty or null then hiding the image
        imgClientSign.Visible = !string.IsNullOrEmpty(sign);

    }

}