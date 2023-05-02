using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class statements : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            LoadBasicInitialInformation();
        }
        litMessage.Text = string.Empty;
    }



    private void LoadBasicInitialInformation()
    {
        BindLeftLogoPlacement();
        ShowConfiguration();
    }

    private void BindLeftLogoPlacement()
    {
        cmbLogoLeftPlacement.Items.Add(new RadComboBoxItem { Text = YesNo.Yes.ToString(), Value = ((int)YesNo.Yes).ToString() });
        cmbLogoLeftPlacement.Items.Add(new RadComboBoxItem { Text = YesNo.No.ToString(), Value = ((int)YesNo.No).ToString() });
    }

    private void ShowConfiguration()
    {
        var cmdParams = new Dictionary<string, object>
        {
            { "@PracticeID", ClientSession.PracticeID },
            { "@UserID", ClientSession.UserID}
        };
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_configstmt_get", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            txtLogoName.Text = row["InvLogoName"].ToString();
            txtHeight.Text = row["InvLogoHeight"].ToString();
            txtWidth.Text = row["InvLogoWidth"].ToString();
            txtAddress1.Text = row["InvAddr1"].ToString();
            txtAddress2.Text = row["InvAddr2"].ToString();
            txtAddress3.Text = row["InvAddr3"].ToString();
            txtAddress4.Text = row["InvAddr4"].ToString();
            txtCheckPayableTo.Text = row["InvPayToName"].ToString();
            txtInvoicePaymentNote.Text = row["InvPayNote"].ToString();
            txtInvoiceInquiryNote.Text = row["InvInquiryNote"].ToString();
            txtQuickPayDesc1.Text = row["QPDesc1"].ToString();
            txtQuickPayDesc2.Text = row["QPDesc2"].ToString();
            txtQuickPayDesc3.Text = row["QPDesc3"].ToString();
            txtQuickPayDesc4.Text = row["QPDesc4"].ToString();
            txtQuickPayDesc5.Text = row["QPDesc5"].ToString();
            txtInvoiceMessage1.Text = row["InvMessage1"].ToString();
            txtInvoiceMessage2.Text = row["InvMessage2"].ToString();
            txtInvoiceFooterNote.Text = row["InvFooterNote"].ToString();
            txtInvoiceEOBNote.Text = row["InvEOBNote"].ToString();
            txtInvoiceServiceNote.Text = row["InvServiceNote"].ToString();
            txtInvoiceSchedPayNote.Text = row["InvSchedPayNote"].ToString();
            cmbLogoLeftPlacement.SelectedValue = row["FlagInvLogoLeft"].ToString() == ((int)YesNo.Yes).ToString("") ? ((int)YesNo.Yes).ToString("") : ((int)YesNo.No).ToString("");
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            var cmdParams = new Dictionary<string, object>()
                                {
                                    { "@FlagInvLogoLeft", cmbLogoLeftPlacement.SelectedValue },
                                    { "@InvLogoName", txtLogoName.Text.Trim() },
                                    { "@InvLogoHeight", txtHeight.Text },
                                    { "@InvLogoWidth", txtWidth.Text },
                                    { "@InvAddr1", txtAddress1.Text.Trim() },
                                    { "@InvAddr2", txtAddress2.Text.Trim() },
                                    { "@InvAddr3", txtAddress3.Text.Trim() },
                                    { "@InvAddr4", txtAddress4.Text.Trim() },
                                    { "@InvPayToName", txtCheckPayableTo.Text.Trim() },
                                    { "@InvPayNote", txtInvoicePaymentNote.Text.Trim() },
                                    { "@InvInquiryNote", txtInvoiceInquiryNote.Text },
                                    { "@QPDesc1", txtQuickPayDesc1.Text},
                                    { "@QPDesc2", txtQuickPayDesc2.Text},
                                    { "@QPDesc3", txtQuickPayDesc3.Text},
                                    { "@QPDesc4", txtQuickPayDesc4.Text},
                                    { "@QPDesc5", txtQuickPayDesc5.Text},
                                    { "@InvMessage1", txtInvoiceMessage1.Text.Trim() },
                                    { "@InvMessage2", txtInvoiceMessage2.Text.Trim() },
                                    { "@InvFooterNote",  txtInvoiceFooterNote.Text },
                                    { "@InvEOBNote",  txtInvoiceEOBNote.Text },
                                    { "@InvServiceNote",  txtInvoiceServiceNote.Text },
                                    { "@InvSchedPayNote",  txtInvoiceSchedPayNote.Text },
                                    { "@UserID", ClientSession.UserID },
                                    { "@PracticeID", ClientSession.PracticeID}
                                };

            SqlHelper.ExecuteScalarProcedureParams("web_pr_configstmt_add", cmdParams);
            RadWindow.RadAlert("Record successfully updated.", 350, 150, "", "refreshPage", "../Content/Images/success.png");
        }
        catch (Exception)
        {

            throw;
        }
    }

}
