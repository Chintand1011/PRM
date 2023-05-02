﻿using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OpenSource;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class truthInLending_popup : System.Web.UI.Page
{
    #region Blue Credit Properties

    public string PracticeName { get; set; }
    public string PracticeAddress { get; set; }
    public string PracticePhone { get; set; }
    public string PracticeFax { get; set; }
    public string BorrowerName { get; set; }
    public string BorrowerAddress1 { get; set; }
    public string BorrowerAddress2 { get; set; }
    public string BorrowerPhone { get; set; }
    public string BlueCreditID { get; set; }
    public string BorrowerDOB { get; set; }
    public string BorrowerSSN { get; set; }
    public string AccountName { get; set; }
    public string OpenDate { get; set; }
    public string TermAbbr { get; set; }
    public string Principal { get; set; }
    public string APR { get; set; }
    public string eAPR { get; set; }
    public string FinCharges { get; set; }
    public string TotPayments { get; set; }
    public string MinMonthly { get; set; }
    public string Message { get; set; }
    #endregion

    public EndPointSession ClientSession
    {
        get
        {
            if (HttpContext.Current.Session["ClientSession"] == null)
                HttpContext.Current.Session["ClientSession"] = new EndPointSession();
            return (EndPointSession)HttpContext.Current.Session["ClientSession"];
        }
        set
        {
            HttpContext.Current.Session["ClientSession"] = value;
        }
    }

    public bool IsShowBlueCreditAmortschedTable
    {
        get
        {
            return Request["IsShowBlueCreditAmortsched"] == null;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                ClientSession.WasRequestFromPopup = true;


                Message = ClientSession.ObjectType == ObjectType.BlueCreditEdit
                              ? "THIS IS A REVISED STATEMENT BASED ON CURRENT BALANCE AND LOAN TERMS"
                              : string.Empty;

                GetBlueCreditDetails();
                ValidateHidePanels();
                ClientSession.ObjectType = null;

                // means its request for printing info only
                if (IsShowBlueCreditAmortschedTable)
                {
                    btnClose.Visible = false;
                }

            }
            catch (Exception)
            {

                throw;
            }
        }
    }


    private void ValidateHidePanels()
    {
        var iscreatePdfWithoutSign = !string.IsNullOrEmpty(Request.Params["CreatePdfWithoutSign"]);
        if (iscreatePdfWithoutSign)
        {
            pnlSignData.Visible = false;
            pnlClientSignImage.Visible = false;
            pnlSign.Visible = true;
        }
    }

    private void GetBlueCreditDetails()
    {
        var blueCreditID = Convert.ToInt32(Request.Params["BlueCreditID"] ?? ClientSession.ObjectID);
        var practiceID = Convert.ToInt32(Request.Params["PracticeID"] ?? ClientSession.PracticeID.ToString());

        if (!string.IsNullOrEmpty(Request.Params["BlueCreditID"]))
        { 
            pnlSign.Visible = false;
        }

        var cmbParams = new Dictionary<string, object>
                            {
                                {"@BlueCreditID", blueCreditID}, 
                                {"@PracticeID", practiceID },
                                { "@UserID", ClientSession.UserID}
                            };

        //var dt = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_til_get", cmbParams);
        //DisplayAllFieldsFromProc(dt);

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_til_get", cmbParams);
        foreach (DataRow row in reader.Rows)
        {
            PracticeName = row["PracticeName"].ToString();
            PracticeAddress = row["PracticeAddress"].ToString();
            PracticePhone = row["PracticePhone"].ToString();
            PracticeFax = row["PracticeFax"].ToString();
            BorrowerName = row["BorrowerName"].ToString();
            BorrowerAddress1 = row["BorrowerAddress1"].ToString();
            BorrowerAddress2 = row["BorrowerAddress2"].ToString();
            BorrowerPhone = row["BorrowerPhonePri"].ToString();
            BorrowerDOB = row["DateofBirth"].ToString();
            BorrowerSSN = row["BorrowerSSNenc"].ToString().Decrypt().ToSSNFormat();
            BlueCreditID = row["BlueCreditID"].ToString();
            AccountName = row["AccountName"].ToString();
            OpenDate = row["OpenDate"].ToString();
            TermAbbr = row["PlanName"].ToString();

            // Below fields need to be revised either in the stored proc or calculated here after getting values from the proc. 
            APR = row["RateAPRAbbr"].ToString(); 
            Principal = row["Balance$"].ToString();
            decimal TotalPaymentsTemp = MathFunctions.CalcTotalPay(Convert.ToDecimal(row["Balance"]), Convert.ToDecimal(row["RatePromo"]), Convert.ToDecimal(row["PromoCyclesRemaining"]), Convert.ToDecimal(row["RateStd"]), Convert.ToDecimal(row["MaxCycles"]), Convert.ToDecimal(row["MinPayAmount"]));
            TotPayments = TotalPaymentsTemp.ToString("C");
            FinCharges = (TotalPaymentsTemp - Convert.ToDecimal(row["Balance"])).ToString("C");
            MinMonthly = row["MinPayAmount$"].ToString();
            decimal eAPRTemp = MathFunctions.CalculateEffectiveAPR(Convert.ToDecimal(row["Balance"]), Convert.ToDecimal(TotalPaymentsTemp), Convert.ToDecimal(row["MaxCycles"]));
            eAPR = eAPRTemp.ToString("F");

            var signature = row["TILSignature"].ToString();
            
            if (string.IsNullOrEmpty(signature))
            {
                pnlSignData.Visible = true;
                pnlSignData.Enabled = true;
                pnlClientSignImage.Visible = false;
                pnlClientSignImage.Enabled = false;
            }
            else
            {
                pnlSignData.Visible = false;
                pnlSignData.Enabled = false;
                pnlClientSignImage.Visible = true;
                pnlClientSignImage.Enabled = true;
                chkAgreementTerms.Checked = true;
                CreateClientSignImage(signature);
            }

            // Show/Hide resgin button according to the flag
            btnResign.Visible = Convert.ToBoolean(row["FlagTILSigResign"]);

            if (Request.Params["BluecreditId"] != null)
            {
                btnResign.Visible = false;
            }

        }

    }

    private DataTable GetBlueCreditAmortsched()
    {
        if (!IsShowBlueCreditAmortschedTable)
            return new DataTable();

        var blueCreditID = Request.Params["BlueCreditID"];
        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_amortsched", new Dictionary<string, object> { { "@BlueCreditID", string.IsNullOrEmpty(blueCreditID) ? ClientSession.ObjectID : blueCreditID } });
    }

    protected void grdBlueCreditAmortsched_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        grdBlueCreditAmortsched.DataSource = GetBlueCreditAmortsched();
    }

    protected void btnSubmit_OnClick(object sender, EventArgs e)
    {

        if (hdnSigData.Value == "undefined")
            return;

        // displaying information
        GetBlueCreditDetails();

        // Hiding signing components
        pnlSignData.Visible = false;
        pnlSignData.Enabled = false;

        // Displaying the image from client sign
        pnlClientSignImage.Visible = true;
        pnlClientSignImage.Enabled = true;
        CreateClientSignImage();

        // Saving the client sign in database
        var fileName = "til_" + ClientSession.ObjectID + ".pdf";
        var cmdParams = new Dictionary<string, object>
        {
            {"@BlueCreditID", ClientSession.ObjectID},
            {"@SigString", hdnSigData.Value},
            {"@FilenameTIL", fileName},
            {"@FlagTILSig", 1},
            {"@UserID", ClientSession.UserID}
        };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_bluecreditsig_add", cmdParams);

        // Creating Pdf
        var source = Path.Combine(ClientSession.FilePathBlueCredit, ClientSession.PracticeID.ToString(), ClientSession.SelectedPatientID + "\\");
        var filePath = source + fileName;

        if (File.Exists(filePath))
        {
            File.Delete(filePath);
        }

        if (!File.Exists(filePath))
        {
            PDFServices.PDFCreate(fileName, ClientSession.WebPathRootProvider + "report/truthInLending_popup.aspx?&BlueCreditID=" + ClientSession.ObjectID + "&PracticeID=" + ClientSession.PracticeID, source);
        }
        
        PopulateDataForDisplayPDF();

    }

    private void CreateClientSignImage(string sign = null)
    {
        // Getting client sign
        var clientSign = string.IsNullOrEmpty(hdnSigData.Value) ? sign : hdnSigData.Value;
        var bytes = SigPlusNet.GetImageBytesFromClientSign(clientSign);
        var base64String = Convert.ToBase64String(bytes, 0, bytes.Length);
        imgClientSign.ImageUrl = "data:image/png;base64," + base64String;

        // If client sign is empty or null then hiding the image
        imgClientSign.Visible = !string.IsNullOrEmpty(clientSign);

    }

    protected void btnResign_OnClick(object sender, EventArgs e)
    {
        // Displaying information
        GetBlueCreditDetails();

        // Managing the panels and button in order to show clinet sign components
        pnlSignData.Visible = true;
        pnlSignData.Enabled = true;

        pnlClientSignImage.Visible = false;
        pnlClientSignImage.Enabled = false;
    }

    protected void btnShowPdf_OnClick(object sender, EventArgs e)
    {
        // Displaying information
        GetBlueCreditDetails();

        PopulateDataForDisplayPDF();
    }

    private void PopulateDataForDisplayPDF()
    {
        // For PDF Viewer popup
        ClientSession.ObjectValue = new Dictionary<string, string> { { "FileName", "til" }, { "PageTitle", "Truth In Lending" }, { "IsRequestFromBlueCredit", "True" } };
        Page.ClientScript.RegisterStartupScript(GetType(), "ShowTILPdf", "showTILPdf();", true);
        Page.ClientScript.RegisterStartupScript(GetType(), "closePopup", "closePopup();", true);
    }

    //private void DisplayAllFieldsFromProc(DataTable dt)
    //{

    //    var html = "<table> <tr> <th> Displaying Records from web_pr_bluecredit_til_get Proc </th></tr>";
    //    var columnNames = dt.Columns.Cast<DataColumn>()
    //                             .Select(x => x.ColumnName)
    //                             .ToList();



    //    foreach (var columnName in columnNames)
    //    {
    //        html += "<tr>";
    //        html += "<td>" + columnName + "</td>";
    //        html += "<td>" + dt.Rows[0][columnName] + "</td>";
    //        html += "</tr>";
    //    }

    //    html += "</table>";

    //    divBluecreditTil.InnerHtml = html;

    //}

}