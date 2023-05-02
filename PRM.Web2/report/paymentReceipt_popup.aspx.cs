using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class paymentReceipt_popup : BasePage
{

    #region Table Properties

    public string PracticeName;
    public string PracticeAddr1;
    public string PracticeAddr2;
    public string PracticePhone;
    public string StatementID;
    public string TransDateTime;
    public string TransactionID;
    public string FSPPNRef;
    public string AuthRef;
    public string TransTypeAbbr;
    public string Amount;
    public string TransStateTypeAbbr;
    public string PatientName;
    public string AccountID { get; set; }
    public string PaymentMethod;
    public string PaymentCardAbbr;
    public string BillingName;
    public string PatientAddr1;
    public string PatientAddr2;
    protected string SignatureText;

    // Image properties
    public string PracticeLogo;
    public string PracticeReceiptLogo;
    public string PracticeLogoWidth;
    public string PracticeLogoHeight;

    // For Validation
    public string OnPageLoad { get; set; }

    #endregion


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // Closing the popup in case of any error
            ClientSession.WasRequestFromPopup = true;
            try
            {
                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.PaymentReceipt)
                {
                    // Displaying patient information
                    GetPaymentReceiptInformation();

                    // Displaying Client sign components in case of Enable client sign
                    if (ClientSession.EnableClientSign)
                    {
                        pnlSignData.Enabled = true;
                        pnlSignData.Visible = true;
                        ClientSession.EnableClientSign = false;
                    }
                    else
                    {
                        CreateClientSignImage();
                        pnlClientSignImage.Visible = true;
                        pnlClientSignImage.Enabled = true;
                        HideLabelsandImageSign();
                    }

                    // removing values from session
                    ClientSession.ObjectType = null;

                }

                // hiding the print buttons in case of printing
                if (ClientSession.EnablePrinting)
                {
                    divButtons.Visible = false;
                    OnPageLoad = "onload='window.print()'";
                    ClientSession.EnablePrinting = false;
                }

            }
            catch (Exception)
            {

                throw;
            }
        }


    }

    private void GetPaymentReceiptInformation()
    {
        var cmdParams = new Dictionary<string, object>
                                {
                                    {"@TransactionID",ClientSession.ObjectID},
                                };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pt_payment_receipt", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            PracticeName = row["PracticeName"].ToString();
            PracticeAddr1 = row["PracticeAddr1"].ToString();
            PracticeAddr2 = row["PracticeAddr2"].ToString();
            PracticePhone = row["PracticePhone"].ToString();
            StatementID = row["StatementID"].ToString();
            TransDateTime = row["TransDateTime"].ToString();
            TransactionID = row["TransactionID"].ToString();
            FSPPNRef = row["FSPPNRef"].ToString();
            AuthRef = row["FSPAuthRef"].ToString();
            TransTypeAbbr = row["TransTypeAbbr"].ToString();
            Amount = row["Amount$"].ToString();
            TransStateTypeAbbr = row["TransStateTypeAbbr"].ToString();
            AccountID = row["AccountID"].ToString();
            PatientName = row["PatientName"].ToString();
            PaymentMethod = row["PaymentMethod"].ToString();
            PaymentCardAbbr = row["PaymentCardAbbr"].ToString();
            BillingName = row["BillingName"].ToString();
            PatientAddr1 = row["PatientAddr1"].ToString();
            PatientAddr2 = row["PatientAddr2"].ToString();
            PracticeLogo = row["PracticeLogo"].ToString();
            PracticeReceiptLogo = row["PracticeReceiptLogo"].ToString();
            PracticeLogoWidth = row["PracticeLogoWidth"].ToString();
            PracticeLogoHeight = row["PracticeLogoHeight"].ToString();
            SignatureText = row["SignatureText"].ToString();
            ViewState["SigString"] = row["SigString"].ToString();
            ViewState["FlagFSPTrans"] = Convert.ToBoolean(row["FlagFSPTrans"]);

            // Managing the Re-Sign Button
            var isResign = Convert.ToInt32(row["FlagSigResign"]) == 1;
            btnResign.Visible = isResign;
            btnResign.Enabled = isResign;
        }
    }


    private void HideLabelsandImageSign()
    {
        var flagFspTrans = Convert.ToBoolean(ViewState["FlagFSPTrans"]);
        if (flagFspTrans) return;
        divFields.Visible = false;
        pnlClientSignImage.Visible = false;
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {

        if (hdnSigData.Value == "undefined")
            return;


        // Saving the client sign in database
        var cmdParams = new Dictionary<string, object>
        {
            {"@TransactionID",ClientSession.ObjectID},
            {"@SigString", hdnSigData.Value}
        };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_transsig_add", cmdParams);

        // Displaying receipt information
        GetPaymentReceiptInformation();

        // Hiding signing components
        pnlSignData.Visible = false;
        pnlSignData.Enabled = false;

        // Displaying the image from client sign
        pnlClientSignImage.Visible = true;
        pnlClientSignImage.Enabled = true;
        CreateClientSignImage(false);

        HideLabelsandImageSign();

    }

    private void CreateClientSignImage(bool getImageFromSavedSign = true)
    {
        // Getting client sign
        var clientSign = getImageFromSavedSign ? ViewState["SigString"].ToString() : hdnSigData.Value;
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

        // This case is for showing the image so we also need print button so making the print button visible = true
        divButtons.Visible = true;
    }

    protected void btnResign_Click(object sender, EventArgs e)
    {
        // Managing the panels and button in order to show clinet sign components

        GetPaymentReceiptInformation();

        pnlSignData.Visible = true;
        pnlSignData.Enabled = true;

        pnlClientSignImage.Visible = false;
        pnlClientSignImage.Enabled = false;

        divButtons.Visible = false;
    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {
        AuditLog.CreatePrintLog(Request.UrlReferrer.AbsoluteUri);

        // Displaying receipt information
        GetPaymentReceiptInformation();

        // Hiding signing components
        pnlSignData.Visible = false;
        pnlSignData.Enabled = false;

        pnlClientSignImage.Visible = true;
        pnlClientSignImage.Enabled = true;
        CreateClientSignImage();

        Page.ClientScript.RegisterStartupScript(GetType(), "Print", "printPopup();", true);
        Page.ClientScript.RegisterStartupScript(GetType(), "Close", "closePopup();", true);    

    }

}