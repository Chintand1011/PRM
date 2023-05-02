using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using OpenSource;
using System.Data;
using PatientPortal.DataLayer;

public partial class estimateview_popup : System.Web.UI.Page
{
    #region Invoice Properties

    public string AccountID { get; set; }
    public string PatientID { get; set; }
    public string PatientName { get; set; }
    public string BillToName { get; set; }
    public string PatientIDPri { get; set; }
    public string PatientRelTypeID { get; set; }
    public string StatementIDfromDB { get; set; }
    public string InvoiceID { get; set; }
    public string StatementDate { get; set; }
    public string StatementDueDate { get; set; }
    public string StatementStatus { get; set; }
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
    public string EOBNote { get; set; }
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
    public string EOBVisitsCurrent { get; set; }
    public string EOBVisitsMax { get; set; }
    public string EOBLimitMax { get; set; }
    public string ServiceNote { get; set; }
    public string FooterNote { get; set; }
    public string PaymentPlanActive { get; set; }
    public string PaymentPlanNextAmt { get; set; }
    public string PaymentPlanNextDate { get; set; }
    public string PaymentPlanNextSource { get; set; }
    public string PaymentPlanNote { get; set; }
    public string EOBCoPay { get; set; }
    public string SrvLinesTotal { get; set; }
    public string EOBCoIns { get; set; }
    public string PTDeductResp { get; set; }
    public string PTCoIns { get; set; }
    public string PTDedTot { get; set; }
    public string PTCoInsTot { get; set; }

    //public String[,] StatementDetails;

    public string InvoiceDate
    {
        get
        {
            var date = Request.Params["InvoiceDate"];
            return string.IsNullOrEmpty(date) ? null : DateTime.Parse(date).ToString("yyyy-MM-dd");
        }
    }

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
        ClientSession.WasRequestFromPopup = true;

        if (!Page.IsPostBack)
        {
            var statementIDFromQueryString = Request.QueryString["StatementID"];
            var estimateIDFromQueryString = Request.QueryString["EstimateID"];
            var paramName = string.IsNullOrEmpty(statementIDFromQueryString) ? "@EstimateID" : "@StatementID";



            if (!string.IsNullOrEmpty(statementIDFromQueryString) || !string.IsNullOrEmpty(estimateIDFromQueryString))
            {
                // Validating the IPAddress request

                var serviceIPAddress = string.Empty;
                var ipAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ?? HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];

                var reader = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", new Dictionary<string, object>());
                foreach (DataRow row in reader.Rows)
                {
                    serviceIPAddress = row["ServiceIPAddress"].ToString();
                }
#if(!DEBUG)
                if (serviceIPAddress != ipAddress) return;
#endif
                var cmdParams = new Dictionary<string, object>
                {
                    { paramName, paramName == "@EstimateID" ? estimateIDFromQueryString : statementIDFromQueryString },
                    { "@UserID", ClientSession.UserID }
                };

                // for ShowStatementDetails method
                ClientSession.ObjectID = paramName == "@EstimateID"
                                             ? estimateIDFromQueryString
                                             : statementIDFromQueryString;

                ClientSession.ObjectType = paramName == "@EstimateID"
                                               ? ObjectType.Estimate
                                               : ObjectType.Statement;

                AssignSpValuesToProperties(cmdParams);
            }
            else
            {
                var id = 0;
                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.Estimate || ClientSession.ObjectType == ObjectType.BlueCredit || ClientSession.ObjectType == ObjectType.Statement)
                    id = Convert.ToInt32(ClientSession.ObjectID);

                var param = ClientSession.ObjectType == ObjectType.Statement ? "@StatementID" : "@EstimateID";
                var cmdParams = new Dictionary<string, object> { { param, id }, { "@UserId", ClientSession.UserID } };
                ViewState["RequestFrom"] = param == "@EstimateID" ? "Estimate" : "Statement";
                AssignSpValuesToProperties(cmdParams);
            }

        }

    }

    private void AssignSpValuesToProperties(object cmdParams)
    {
        try
        {
            var allParams = cmdParams as Dictionary<string, object>;
            ValidateAndAppendInvoiceParam(allParams);

            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_estimate_build", allParams);

            foreach (DataRow row in reader.Rows)
            {
                #region Assigning SP values to properties

                if (ClientSession.PracticeID != 0)
                {
                    if (ClientSession.PracticeID != Convert.ToInt32(row["PracticeID"].ToString()))
                    {
                        radWindowDialog.RadAlert("An error occurred when trying to retrieve the statement; please contact support.", 350, 150, string.Empty, "closeRadWindow");
                        return;
                    }
                }

                AccountID = row["AccountID"].ToString();

                InvoiceID = row["InvoiceID"].ToString();
                barCode.Text = InvoiceID;

                StatementIDfromDB = row["StatementID"].ToString();

                PatientID = row["PatientID"].ToString();

                PatientName = row["PatientName"].ToString();

                BillToName = row["BillToName"].ToString();

                PatientRelTypeID = row["PatientRelTypeID"].ToString();

                StatementDate = row["StatementDate"].ToString();

                StatementDueDate = row["StatementDueDate"].ToString();

                StatementStatus = row["StatementStatus"].ToString();

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

                EOBNote = row["EOBNote"].ToString();

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

                EOBVisitsCurrent = row["EOBVisitsCurrent"].ToString();

                EOBVisitsMax = row["EOBVisitsMax"].ToString();

                EOBLimitMax = row["EOBLimitMax"].ToString();

                ServiceNote = row["ServiceNote"].ToString();

                FooterNote = row["FooterNote"].ToString();

                PaymentPlanActive = row["PaymentPlanActive"].ToString();

                PaymentPlanNextAmt = row["PaymentPlanNextAmt"].ToString();

                PaymentPlanNextDate = row["PaymentPlanNextDate"].ToString();

                PaymentPlanNextSource = row["PaymentPlanNextSource"].ToString();

                PaymentPlanNote = row["ScheduledPaymentNote"].ToString();

                SrvLinesTotal = row["SrvLinesTotal"].ToString();

                EOBCoPay = row["EOBCoPay"].ToString();

                EOBCoIns = row["EOBCoIns"].ToString();

                PTDeductResp = row["ptDeductResp"].ToString();

                PTCoIns = row["ptCoIns"].ToString();

                PTDedTot = row["ptDedTot"].ToString();

                PTCoInsTot = row["ptCoInsTot"].ToString();

                // For Create a PDF
                if (string.IsNullOrEmpty(Request.QueryString["StatementID"]) && string.IsNullOrEmpty(Request.QueryString["EstimateID"]))
                {
                    var webPath = ViewState["RequestFrom"].ToString() == "Estimate"
                                      ? "WebPathEstimates"
                                      : "WebPathStatements";
                    var fielPath = ViewState["RequestFrom"].ToString() == "Estimate"
                                      ? "FilePathEstimates"
                                      : "FilePathStatements";

                    var values = new Dictionary<string, string>
                                 {
                                     {"FileName", row["FileName"].ToString()},
                                     {"WebPath", row[webPath].ToString()},
                                     {"FilePath", row[fielPath].ToString()},
                                     {"ID", ClientSession.ObjectID.ToString()},
                                     {"Password", row["Password"].ToString()},
                                     {"RequestFrom", ViewState["RequestFrom"].ToString()}
                                 };

                    ClientSession.ObjectValue = values;
                }

                #endregion
            }
        }
        catch (Exception)
        {
            throw;
        }
    }

    private DataTable GetStatementDetails()
    {
        var id = 0;
        if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.Estimate || ClientSession.ObjectType == ObjectType.BlueCredit || ClientSession.ObjectType == ObjectType.Statement)
            id = Convert.ToInt32(ClientSession.ObjectID);

        var param = ClientSession.ObjectType == ObjectType.Statement ? "@StatementID" : "@EstimateID";
        var cmdParams = new Dictionary<string, object> { { param, id } };
        ValidateAndAppendInvoiceParam(cmdParams);

        return SqlHelper.ExecuteDataTableProcedureParams("web_pr_estimate_build_detail", cmdParams);
    }

    public void ShowStatementDetails()
    {
        var statements = GetStatementDetails();
        string htmlStatementDetails = "";
        for (var i = 0; i < statements.Rows.Count; i++)
        {
            htmlStatementDetails += "<tr>";
            for (var j = 0; j < 1; j++)
            {
                htmlStatementDetails += "<td class='t1'>";
                htmlStatementDetails += statements.Rows[i][j].ToString();
                htmlStatementDetails += "</td>";
            }
            for (var j = 1; j < 2; j++)
            {
                htmlStatementDetails += "<td class='t2'>";
                htmlStatementDetails += statements.Rows[i][j].ToString();
                htmlStatementDetails += "</td>";
            }
            for (var j = 2; j < statements.Columns.Count; j++)
            {
                htmlStatementDetails += "<td class='t3'>";
                htmlStatementDetails += statements.Rows[i][j].ToString();
                htmlStatementDetails += "</td>";
            }
            htmlStatementDetails += "</tr>";
        }
        Response.Write(htmlStatementDetails);
    }

    public void ValidateAndAppendInvoiceParam(Dictionary<string, object> cmdParans)
    {
        if (!string.IsNullOrEmpty(InvoiceDate))
        {
            cmdParans.Add("@StatementDate", InvoiceDate);
        }
    }
}