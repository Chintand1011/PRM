using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OpenSource;
using PatientPortal.DataLayer;

public partial class invoice_popup : System.Web.UI.Page
{
    #region Invoice Properties

    public string AccountID { get; set; }
    public string StatementID { get; set; }
    public string PatientID { get; set; }
    public string PatientName { get; set; }
    public string PatientIDPri { get; set; }
    public string PatientNamePri { get; set; }
    public string PatientRelTypeID { get; set; }
    public string StatementDate { get; set; }
    public string StatementDueDate { get; set; }
    public string StatementStatus { get; set; }
    public string StatementRefCode { get; set; }
    public string StatementBarcodeImg { get; set; }
    public string StatementQRImg { get; set; }
    public string PracticeLogo { get; set; }
    public string PracticeLogoWidth { get; set; }
    public string PracticeLogoHeight { get; set; }
    public string BackgroundImg { get; set; }
    public string ServiceColor { get; set; }
    public string ServiceImg { get; set; }
    public string CCTableColor { get; set; }
    public string ServiceTableColor { get; set; }
    public string ServiceHeaderColor { get; set; }
    public string ServiceHeaderTextColor { get; set; }
    public string ServiceBodyTextColor { get; set; }
    public string PracticeAddr1 { get; set; }
    public string PracticeAddr2 { get; set; }
    public string PracticeAddr3 { get; set; }
    public string PracticeAddr4 { get; set; }
    public string PracticeNote1 { get; set; }
    public string PracticeNote2 { get; set; }
    public string PracticeNote3 { get; set; }
    public string PracticeNote4 { get; set; }
    public string DoctorName { get; set; }
    public string BillingAddr1 { get; set; }
    public string BillingAddr2 { get; set; }
    public string BillingAddr3 { get; set; }
    public string BillingAddr4 { get; set; }
    public string BillingBarcodeID { get; set; }
    public string TotalDue { get; set; }
    public string PaymentWebURL { get; set; }
    public string PaymentPhone { get; set; }
    public string PaymentCheckName { get; set; }
    public string PaymentCreditImg { get; set; }
    public string EOBNote1 { get; set; }
    public string EOBNote2 { get; set; }
    public string EOBNote3 { get; set; }
    public string EOBNote4 { get; set; }
    public string EOBDate { get; set; }
    public string EOBCarrier { get; set; }
    public string EOBPlanName { get; set; }
    public string EOBServiceType { get; set; }
    public string EOBPreferred { get; set; }
    public string EOBPatientIssuedReimb { get; set; }
    public string EOBPatientRelation { get; set; }
    public string EOBSubscriberID { get; set; }
    public string EOBStatus { get; set; }
    public string EOBDeduct { get; set; }
    public string EOBDeductMet { get; set; }
    public string EOBDeductRemain { get; set; }
    public string EOBStopLoss { get; set; }
    public string EOBStopLossYTD { get; set; }
    public string EOBStopLossRemain { get; set; }
    public string EOBCoIns { get; set; }
    public string EOBCoPay { get; set; }
    public string EOBVisitsCurrent { get; set; }
    public string EOBVisitsMax { get; set; }
    public string EOBLimitMax { get; set; }
    public string ServiceNote1 { get; set; }
    public string ServiceNote2 { get; set; }
    public string ServiceNote3 { get; set; }
    public string ServiceNote4 { get; set; }
    public string FooterNote1 { get; set; }
    public string FooterNote2 { get; set; }
    public string FooterNote3 { get; set; }
    public string FooterNote4 { get; set; }
    public string PaymentPlanActive { get; set; }
    public string PaymentPlanNextAmt { get; set; }
    public string PaymentPlanNextDate { get; set; }
    public string PaymentPlanNextSource { get; set; }
    public string PaymentPlanNote1 { get; set; }
    public string PaymentPlanNote2 { get; set; }
    public string SrvLinesTotal { get; set; }
    public string Srv01 { get; set; }
    public string Srv02 { get; set; }
    public string Srv03 { get; set; }
    public string Srv04 { get; set; }
    public string Srv05 { get; set; }
    public string Srv06 { get; set; }
    public string Srv07 { get; set; }
    public string Srv08 { get; set; }
    public string Srv09 { get; set; }
    public string Srv10 { get; set; }
    public string Srv11 { get; set; }
    public string Srv12 { get; set; }
    public string Srv13 { get; set; }
    public string Srv14 { get; set; }
    public string Srv15 { get; set; }
    public string Srv16 { get; set; }
    public string Srv17 { get; set; }
    public string Srv18 { get; set; }
    public string Srv19 { get; set; }
    public string Srv20 { get; set; }
    public string Srv21 { get; set; }
    public string Srv22 { get; set; }
    public string Srv23 { get; set; }
    public string Srv24 { get; set; }
    public string Srv25 { get; set; }
    public string Srv26 { get; set; }
    public string Srv27 { get; set; }
    public string Srv28 { get; set; }
    public string Srv29 { get; set; }
    public string Srv30 { get; set; }
    public string Srv31 { get; set; }
    public string Srv32 { get; set; }
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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // Closing the popup in case of any error
            ClientSession.WasRequestFromPopup = true;
            try
            {
                // Validating the current logged in user or not
                var serviceIp = ClientSession.ServiceIPAddress;
                var requestIPAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ?? Request.ServerVariables["REMOTE_ADDR"];
                var statementID = 0;

                if (string.IsNullOrEmpty(ClientSession.LastName) && serviceIp != requestIPAddress) Response.Redirect("~/login.aspx");

                else if (!string.IsNullOrEmpty(ClientSession.LastName))
                {
                    var pagePath = HttpContext.Current.Request.Url.AbsolutePath;
                    var fileInfo = new System.IO.FileInfo(pagePath);
                    var pageName = fileInfo.Name.Split('.').ToList();

                    var isAuthorized = true;
                    if (!pageName[0].ToLower().Contains("popup"))
                        isAuthorized = ClientSession.UserMenus.Any(res => res.PageName.ToLower().Contains(pageName[0].ToLower()));

                    // if not Authorized then redirect to the error page
                    if (!isAuthorized)
                    {
                        Response.Redirect("~/ErrorPages/error.aspx");
                    }
                    statementID = Convert.ToInt32(ClientSession.ObjectID);
                } // again check if the requested IpAddress match with logged in user's IpAddress
                else if (serviceIp != requestIPAddress) Response.Redirect("~/login.aspx");

                // Checking if the request is from web project or not
                if (statementID == 0)
                {
                    if (Request.QueryString["StatementID"] == null) Response.Redirect("~/login.aspx");
                    else statementID = Convert.ToInt32(Request.QueryString["StatementID"]);
                }

                var cmdParams = new Dictionary<string, object> { { "@EstimateID", statementID }, { "@UserID", ClientSession.UserID } };
                var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_estimate_build", cmdParams);
                foreach (DataRow row in reader.Rows)
                {
                    #region Assigning SP values to properties
                    AccountID = row["AccountID"].ToString();
                    StatementID = row["StatementID"].ToString();
                    PatientID = row["PatientID"].ToString();
                    PatientName = row["PatientName"].ToString();
                    PatientIDPri = row["PatientIDPri"].ToString();
                    PatientNamePri = row["PatientNamePri"].ToString();
                    PatientRelTypeID = row["PatientRelTypeID"].ToString();
                    StatementDate = row["StatementDate"].ToString();
                    StatementDueDate = row["StatementDueDate"].ToString();
                    StatementStatus = row["StatementStatus"].ToString();
                    StatementRefCode = row["StatementRefCode"].ToString();
                    //barCode.Text = StatementRefCode; //Displaying barcode on the page
                    StatementBarcodeImg = row["StatementBarcodeImg"].ToString();
                    StatementQRImg = row["StatementQRImg"].ToString();
                    PracticeLogo = row["PracticeLogo"].ToString();
                    PracticeLogoWidth = row["PracticeLogoWidth"].ToString();
                    PracticeLogoHeight = row["PracticeLogoHeight"].ToString();
                    BackgroundImg = row["BackgroundImg"].ToString();
                    ServiceColor = row["ServiceColor"].ToString();
                    ServiceImg = row["ServiceImg"].ToString();
                    CCTableColor = row["CCTableColor"].ToString();
                    ServiceTableColor = row["ServiceTableColor"].ToString();
                    ServiceHeaderColor = row["ServiceHeaderColor"].ToString();
                    ServiceHeaderTextColor = row["ServiceHeaderTextColor"].ToString();
                    ServiceBodyTextColor = row["ServiceBodyTextColor"].ToString();
                    PracticeAddr1 = row["PracticeAddr1"].ToString();
                    PracticeAddr2 = row["PracticeAddr2"].ToString();
                    PracticeAddr3 = row["PracticeAddr3"].ToString();
                    PracticeAddr4 = row["PracticeAddr4"].ToString();
                    PracticeNote1 = row["PracticeNote1"].ToString();
                    PracticeNote2 = row["PracticeNote2"].ToString();
                    PracticeNote3 = row["PracticeNote3"].ToString();
                    PracticeNote4 = row["PracticeNote4"].ToString();
                    DoctorName = row["DoctorName"].ToString();
                    BillingAddr1 = row["BillingAddr1"].ToString();
                    BillingAddr2 = row["BillingAddr2"].ToString();
                    BillingAddr3 = row["BillingAddr3"].ToString();
                    BillingAddr4 = row["BillingAddr4"].ToString();
                    BillingBarcodeID = Extensions.GetBarCode(row["BillingBarcodeID"].ToString());
                    TotalDue = row["TotalDue"].ToString();
                    PaymentWebURL = row["PaymentWebURL"].ToString();
                    PaymentPhone = row["PaymentPhone"].ToString();
                    PaymentCheckName = row["PaymentCheckName"].ToString();
                    PaymentCreditImg = row["PaymentCreditImg"].ToString();
                    EOBNote1 = row["EOBNote1"].ToString();
                    EOBNote2 = row["EOBNote2"].ToString();
                    EOBNote3 = row["EOBNote3"].ToString();
                    EOBNote4 = row["EOBNote4"].ToString();
                    EOBDate = row["EOBDate"].ToString();
                    EOBCarrier = row["EOBCarrier"].ToString();
                    EOBPlanName = row["EOBPlanName"].ToString();
                    EOBServiceType = row["EOBServiceType"].ToString();
                    EOBPreferred = row["EOBPreferred"].ToString();
                    EOBSubscriberID = row["EOBSubscriberID"].ToString();
                    EOBPatientIssuedReimb = row["EOBPatientIssuedReimb"].ToString();
                    EOBPatientRelation = row["EOBPatientRelation"].ToString();
                    EOBStatus = row["EOBStatus"].ToString();
                    EOBDeduct = row["EOBDeduct"].ToString();
                    EOBDeductMet = row["EOBDeductMet"].ToString();
                    EOBDeductRemain = row["EOBDeductRemain"].ToString();
                    EOBStopLoss = row["EOBStopLoss"].ToString();
                    EOBStopLossYTD = row["EOBStopLossYTD"].ToString();
                    EOBStopLossRemain = row["EOBStopLossRemain"].ToString();
                    EOBCoIns = row["EOBCoIns"].ToString();
                    EOBCoPay = row["EOBCoPay"].ToString();
                    EOBVisitsCurrent = row["EOBVisitsCurrent"].ToString();
                    EOBVisitsMax = row["EOBVisitsMax"].ToString();
                    EOBLimitMax = row["EOBLimitMax"].ToString();
                    ServiceNote1 = row["ServiceNote1"].ToString();
                    ServiceNote2 = row["ServiceNote2"].ToString();
                    ServiceNote3 = row["ServiceNote3"].ToString();
                    ServiceNote4 = row["ServiceNote4"].ToString();
                    FooterNote1 = row["FooterNote1"].ToString();
                    FooterNote2 = row["FooterNote2"].ToString();
                    FooterNote3 = row["FooterNote3"].ToString();
                    FooterNote4 = row["FooterNote4"].ToString();
                    PaymentPlanActive = row["PaymentPlanActive"].ToString();
                    PaymentPlanNextAmt = row["PaymentPlanNextAmt"].ToString();
                    PaymentPlanNextDate = row["PaymentPlanNextDate"].ToString();
                    PaymentPlanNextSource = row["PaymentPlanNextSource"].ToString();
                    PaymentPlanNote1 = row["PaymentPlanNote1"].ToString();
                    PaymentPlanNote2 = row["PaymentPlanNote2"].ToString();
                    SrvLinesTotal = row["SrvLinesTotal"].ToString();
                    Srv01 = row["Srv01"].ToString();
                    Srv02 = row["Srv02"].ToString();
                    Srv03 = row["Srv03"].ToString();
                    Srv04 = row["Srv04"].ToString();
                    Srv05 = row["Srv05"].ToString();
                    Srv06 = row["Srv06"].ToString();
                    Srv07 = row["Srv07"].ToString();
                    Srv08 = row["Srv08"].ToString();
                    Srv09 = row["Srv09"].ToString();
                    Srv10 = row["Srv10"].ToString();
                    Srv11 = row["Srv11"].ToString();
                    Srv12 = row["Srv12"].ToString();
                    Srv13 = row["Srv13"].ToString();
                    Srv14 = row["Srv14"].ToString();
                    Srv15 = row["Srv15"].ToString();
                    Srv16 = row["Srv16"].ToString();
                    Srv17 = row["Srv17"].ToString();
                    Srv18 = row["Srv18"].ToString();
                    Srv19 = row["Srv19"].ToString();
                    Srv20 = row["Srv20"].ToString();
                    Srv21 = row["Srv21"].ToString();
                    Srv22 = row["Srv22"].ToString();
                    Srv23 = row["Srv23"].ToString();
                    Srv24 = row["Srv24"].ToString();
                    Srv25 = row["Srv25"].ToString();
                    Srv26 = row["Srv26"].ToString();
                    Srv27 = row["Srv27"].ToString();
                    Srv28 = row["Srv28"].ToString();
                    Srv29 = row["Srv29"].ToString();
                    Srv30 = row["Srv30"].ToString();
                    Srv31 = row["Srv31"].ToString();
                    Srv32 = row["Srv32"].ToString();

                    #endregion
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}