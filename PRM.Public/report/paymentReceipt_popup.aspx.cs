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
    public string OnLoad { get; set; }

    #endregion


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.PaymentReceipt)
                {
                    // Displaying patient information
                    GetPaymentReceiptInformation();

                    if (ClientSession.EnablePrinting)
                    {
                        ClientSession.EnablePrinting = false;
                        divButtons.Visible = false;
                        OnLoad = " onload='window.print();'";
                    }

                    // Displaying Client Sign
                    CreateClientSignImage();
                    pnlClientSignImage.Visible = true;
                    pnlClientSignImage.Enabled = true;
                    HideLabelsandImageSign();
                    
                }

                ValidateIfHtmlPopup();

            }
            catch (Exception)
            {

                throw;
            }

        }


    }

    private void ValidateIfHtmlPopup()
    {
        int value;
        Int32.TryParse(Request.Params["IsHtmlPopup"] ?? "0", out value);

        hdnIsHtmlPopup.Value = value.ToString();
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
        }
    }

    private void HideLabelsandImageSign()
    {
        var flagFspTrans = Convert.ToBoolean(ViewState["FlagFSPTrans"]);
        if (flagFspTrans) return;
        divFields.Visible = false;
        pnlClientSignImage.Visible = false;
    }


    private void CreateClientSignImage()
    {
        // Getting client sign
        var clientSign = ViewState["SigString"].ToString();
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

}
