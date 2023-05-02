using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class report_bluecredtaccountvalidation_popup : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                if (Request.Form["IsRedirect"] == "1")
                {
                    ClientSession.IsRedirectToBluecredit = true;
                    return;
                }

                ShowValidationResult();

            }
            catch (Exception)
            {
                throw;
            }
        }
    }

    private void ShowValidationResult()
    {
        var flagGuardianPay = ClientSession.SelectedPatientInformation["FlagGuardianPay"].ParseBool();

        var cmdParam = new Dictionary<string, object>
        {
            { "@PracticeID", ClientSession.PracticeID },
            { "@PatientID", ClientSession.SelectedPatientID },
            { "@UserID", ClientSession.UserID },
            { "@FlagGuardian", flagGuardianPay ? 1 : 0},
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecreditcheck_get", cmdParam);

        foreach (DataRow row in reader.Rows)
        {
            var flagAge = Convert.ToInt32(row["FlagAge"]);
            var flagIdent = Convert.ToInt32(row["FlagIdent"]);
            var flagSsn = Convert.ToInt32(row["FlagSSN"]);
            var flagCheckCard = Convert.ToInt32(row["FlagCheckCard"]);
            var flagTupfs = Convert.ToInt32(row["FlagTUPFS"]);
            var flagEligState = Convert.ToInt32(row["FlagEligState"]);
            var flagBlueCredit = Convert.ToBoolean(row["FlagBCActive"]);
            var flagMustFixed = Convert.ToBoolean(row["FlagMustFix"]);

            // 0=fail, 1=pass, 2=caution

            imgAge.ImageUrl = flagAge == 1 ? "../Content/Images/icon_pass_sm.png" : flagAge == 2 ? "../Content/Images/icon_caution_sm.png" : "../Content/Images/icon_fail_sm.png";
            if (flagAge != 1)
            {
                imgFixAge.Visible = true;
                lblAge.Visible = true;
            }

            imgIdent.ImageUrl = flagIdent == 1 ? "../Content/Images/icon_pass_sm.png" : flagIdent == 2 ? "../Content/Images/icon_caution_sm.png" : "../Content/Images/icon_fail_sm.png";
            if (flagIdent != 1)
            {
                imgFixIdent.Visible = true;
                lblIdent.Visible = true;
            }

            imgSsn.ImageUrl = flagSsn == 1 ? "../Content/Images/icon_pass_sm.png" : flagSsn == 2 ? "../Content/Images/icon_caution_sm.png" : "../Content/Images/icon_fail_sm.png";
            if (flagSsn != 1)
            {
                imgFixSsn.Visible = true;
                lblSsn_fail.Visible = true;
            }
            if (flagSsn == 2)
            {
                lblSsn_fail.Visible = false;
                lblSsn_warn.Visible = true;
            }

            imgCheckCard.ImageUrl = flagCheckCard == 1 ? "../Content/Images/icon_pass_sm.png" : flagCheckCard == 2 ? "../Content/Images/icon_caution_sm.png" : "../Content/Images/icon_fail_sm.png";
            if (flagCheckCard != 1)
            {
                imgFixCheckCard.Visible = true;
                lblCheckCard.Visible = true;
            }

            imgTUPFS.ImageUrl = flagTupfs == 1 ? "../Content/Images/icon_pass_sm.png" : flagTupfs == 2 ? "../Content/Images/icon_caution_sm.png" : "../Content/Images/icon_fail_sm.png";
            if (flagTupfs != 1)
            {
                imgFixTUPFS.Visible = true;
                lblTUPFS_fail.Visible = true;
            }
            if (flagTupfs == 2)
            {
                lblTUPFS_fail.Visible = false;
                lblTUPFS_warn.Visible = true;
            }

            imgEligState.ImageUrl = flagEligState == 1 ? "../Content/Images/icon_pass_sm.png" : flagEligState == 2 ? "../Content/Images/icon_caution_sm.png" : "../Content/Images/icon_fail_sm.png";
            if (flagEligState != 1)
            {
                imgFixEligState.Visible = true;
                lblEligState.Visible = true;
            }


            imgBlueCredit.ImageUrl = flagBlueCredit ? "../Content/Images/icon_pass_sm.png" : "../Content/Images/icon_fail_sm.png";

            if (!flagBlueCredit)
            {
                imgFixBlueCredit.Visible = true;
                lblBlueCredit.Visible = true;
            }

            if (flagMustFixed)
            {
                pError.Visible = true;
                btnNext.ImageUrl = "../Content/Images/btn_next_fade.gif";
                btnNext.Enabled = false;
            }
            else
            {
                btnNext.ImageUrl = "../Content/Images/btn_next.gif";
                imgCancel.ImageUrl = "../Content/Images/btn_cancel.gif";
                btnNext.Enabled = true;
                pError.Visible = false;
            }
        }
    }
}
