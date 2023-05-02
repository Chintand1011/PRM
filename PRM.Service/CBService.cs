using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Sql;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Data.SqlClient;
using System.Threading;
using System.Configuration;
using System.Drawing;
using System.Net;
using System.Collections;
using System.Collections.Specialized;
using System.Web;
using System.Xml;
using System.Net.Mail;
using System.Net.Mime;
using System.Reflection;
using PatientPortal.Utility;
using PatientPortal.DataLayer;


//kb create and deploy service: http://support.microsoft.com/kb/816169 and also http://msdn.microsoft.com/en-us/library/zt39148a.aspx

namespace PatientPortal.Service
{
    public partial class PatientPortalService : ServiceBase
    {
        private bool stopping;
        private int count = 0;
        private ManualResetEvent stoppedEvent;

        public PatientPortalService()
        {
            InitializeComponent();
            if (EventLog.SourceExists("CBService"))
            {
                // Find the log associated with this source.    
                string logName = EventLog.LogNameFromSourceName("CBService", ".");
                // Make sure the source is in the log we believe it to be in. 
                if (logName != "CBPRM")
                    return;
                // Delete the source and the log.
                EventLog.DeleteEventSource("CBService");
                EventLog.Delete(logName);

                //Console.WriteLine(logName + " deleted.");
            }
            else //if (!EventLog.SourceExists("CBService")) 
            {
                EventLog.CreateEventSource("CBService", "CBPRM");
            }

            this.stopping = false;
            this.stoppedEvent = new ManualResetEvent(false);

        }
        protected override void OnStart(string[] args)
        {
            EventLog.WriteEntry("CBService", "In OnStart", EventLogEntryType.Information, 0);
            // Queue the main service function for execution in a worker thread. 
            ThreadPool.QueueUserWorkItem(new WaitCallback(ServiceWorkerThread));
        }

        protected override void OnPause()
        {
            EventLog.WriteEntry("CBService", "In OnPause", EventLogEntryType.Information, 0);
        }
        protected override void OnStop()
        {
            EventLog.WriteEntry("CBService", "In onStop.", EventLogEntryType.Information, 0);
        }
        protected override void OnContinue()
        {
            EventLog.WriteEntry("CBService", "In OnContinue.", EventLogEntryType.Information, 0);
        }

        private void ServiceWorkerThread(object state)
        {
            // Periodically check if the service is stopping. 
            while (!this.stopping)
            {
                // Perform main service function here... 

                count++;
                EventLog.WriteEntry("CBService", "RunMethods(9-12-15) Start: " + count.ToString(), EventLogEntryType.Information, 0);
                RunServiceMethods.RunMethods(); //Run all Procedures
                Thread.Sleep(60000);  // Simulate some lengthy operations.
            }

            // Signal the stopped event. 
            this.stoppedEvent.Set();
        }


    }

    public static class RunServiceMethods
    {
        public static void RunMethods()
        {
            try
            {
                if (!EventLog.SourceExists("CBService")) { EventLog.CreateEventSource("CBService", "CBPRM"); }
                EventLog.WriteEntry("CBService", "Try to SQL...", EventLogEntryType.Information, 0);
#if(!DEBUG)
                var ServiceProcessYesNo = SqlHelper.ExecuteScalarProcedureParams("svc_ServiceProcessingDate", new Dictionary<string, object>());   
                if (Convert.ToInt32(ServiceProcessYesNo) == 0) { return; } //If it's not time for the Service to process, abort procedure. It's supposed to process after 4am.
#endif
                //#if(!DEBUG)
                FSPAudit();

                ProcessStatements();
                //#endif
            }
            catch (Exception ex)
            {
                var sqlData = SqlHelper.GetSqlData(ex.Data);
                EmailServices.SendRunTimeErrorEmail("Request submitted from Service: " + ex.HelpLink, ex.GetType().ToString(), ex.Message, ex.StackTrace, "", "N/A", "N/A", "N/A", "N/A", (Int32)Enums.ServiceInfo.UserID, -1, -1, "127.0.0.1", sqlData);
            }
        }

        public static void FSPAudit()
        {
            EventLog.WriteEntry("CBService", "FSPAudit() Start", EventLogEntryType.Information, 0);

            var pendingPractice = SqlHelper.ExecuteDataTableProcedureParams("web_pr_practice_list", new Dictionary<string, object> { { "@FSAudit", 1 } });
            foreach (var practice in pendingPractice.AsEnumerable())
            {
                try
                {
                    var frontStreamPaymentList = new List<FrontStreamPaymentsXml>();
                    var isRecordsMatched = true;
                    var resultList = "<table>";
                    DateTime BeginDT = DateTime.Today.AddDays(90 > (DateTime.Today - Convert.ToDateTime("1/17/2014")).Days ? -(DateTime.Today - Convert.ToDateTime("1/17/2014")).Days : -90);
                    DateTime EndDT = DateTime.Today.AddDays(5);
                    var GetCardTrx = new GetCardTrx((int)practice["PracticeID"], Convert.ToBoolean((int)practice["FSFlagLive"]), "", BeginDT, EndDT, false, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "");
                    if (GetCardTrx.Success == false) { continue; } //Abort Practice Audit for this particular practice. Error notification will be sent.
                    var response = GetCardTrx.response;
                    
                    var GetCheckTrx = new GetCheckTrx((int)practice["PracticeID"], Convert.ToBoolean((int)practice["FSFlagLive"]), "", BeginDT, EndDT, false, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "");
                    if (GetCheckTrx.Success == false) { continue; } //Abort Practice Audit for this particular practice. Error notification will be sent.
                    var response2 = GetCheckTrx.response;

                    var xmlDocument = new XmlDocument { InnerXml = response.Replace("</RichDBDS>", "").Replace("<RichDBDS />", "<RichDBDS>") + response2.Replace("<RichDBDS>", "").Replace("<RichDBDS />", "</RichDBDS>") };
                    var cardNodes = xmlDocument.GetElementsByTagName("TrxDetailCard");
                    var checkNodes = xmlDocument.GetElementsByTagName("TrxDetailCheck");

                    #region Parse CreditCard Transactions
                    frontStreamPaymentList.AddRange(from XmlNode xmlNode in cardNodes
                                                    select new FrontStreamPaymentsXml
                                                    {
                                                        PnRef = xmlNode["TRX_HD_Key"] == null ? null : xmlNode["TRX_HD_Key"].InnerText,
                                                        FSP_Auth_Amt_MN = xmlNode["Auth_Amt_MN"] == null ? (decimal?)null : Convert.ToDecimal(xmlNode["Auth_Amt_MN"].InnerText),
                                                        FSP_AVS_Resp_CH = xmlNode["AVS_Resp_CH"] == null ? null : xmlNode["AVS_Resp_CH"].InnerText,
                                                        FSP_Batch_Number = xmlNode["Batch_Number"] == null ? null : xmlNode["Batch_Number"].InnerText,
                                                        FSP_Last_Update_DT = xmlNode["Last_Update_DT"] == null ? (DateTime?)null : Convert.ToDateTime(xmlNode["Last_Update_DT"].InnerText),
                                                        FSP_Manual = xmlNode["Manual"] == null ? (bool?)null : ValidateBoolValue(xmlNode["Manual"].InnerText),
                                                        FSP_Orig_TRX_HD_Key = xmlNode["Orig_TRX_HD_Key"] == null ? (int?)null : Convert.ToInt32(xmlNode["Orig_TRX_HD_Key"].InnerText),
                                                        FSP_Payment_Type_ID = xmlNode["Payment_Type_ID"] == null ? null : xmlNode["Payment_Type_ID"].InnerText,
                                                        FSP_Result_CH = xmlNode["Result_CH"] == null ? null : xmlNode["Result_CH"].InnerText,
                                                        FSP_Result_Txt_VC = xmlNode["Result_Txt_VC"] == null ? null : xmlNode["Result_Txt_VC"].InnerText,
                                                        FSP_Result_Msg_VC = xmlNode["Result_Msg_VC"] == null ? null : xmlNode["Result_Msg_VC"].InnerText,
                                                        FSP_TRX_Settle_Msg_VC = xmlNode["TRX_Settle_Msg_VC"] == null ? null : xmlNode["TRX_Settle_Msg_VC"].InnerText,
                                                        FSP_Settle_Flag_CH = xmlNode["Settle_Flag_CH"] == null ? (bool?)null : ValidateBoolValue(xmlNode["Settle_Flag_CH"].InnerText),
                                                        FSP_Total_Amt_MN = xmlNode["Total_Amt_MN"] == null ? (decimal?)null : Convert.ToDecimal(xmlNode["Total_Amt_MN"].InnerText),
                                                        FSP_Trans_Type_ID = xmlNode["Trans_Type_ID"] == null ? null : xmlNode["Trans_Type_ID"].InnerText,
                                                        FSP_Void_Flag_CH = xmlNode["Void_Flag_CH"] == null ? (bool?)null : ValidateBoolValue(xmlNode["Void_Flag_CH"].InnerText),
                                                        FSP_Zip_CH = xmlNode["Zip_CH"] == null ? null : xmlNode["Zip_CH"].InnerText,
                                                        PaymentType = "Card"
                                                    });
                    #endregion
                    #region Parse Check Transactions
                    frontStreamPaymentList.AddRange(from XmlNode xmlNode in checkNodes
                                                    select new FrontStreamPaymentsXml
                                                    {
                                                        PnRef = xmlNode["TRX_HD_Key"] == null ? null : xmlNode["TRX_HD_Key"].InnerText,
                                                        FSP_Auth_Amt_MN = xmlNode["Amount_MN"] == null ? (decimal?)null : Convert.ToDecimal(xmlNode["Amount_MN"].InnerText),
                                                        FSP_Batch_Number = xmlNode["Batch_Number"] == null ? null : xmlNode["Batch_Number"].InnerText,
                                                        FSP_Last_Update_DT = xmlNode["Last_Update_DT"] == null ? (DateTime?)null : Convert.ToDateTime(xmlNode["Last_Update_DT"].InnerText),
                                                        FSP_Payment_Type_ID = xmlNode["Payment_Type_ID"] == null ? null : xmlNode["Payment_Type_ID"].InnerText,
                                                        FSP_Result_CH = xmlNode["Result_CH"] == null ? null : xmlNode["Result_CH"].InnerText,
                                                        FSP_Result_Txt_VC = xmlNode["Result_Txt_VC"] == null ? null : xmlNode["Result_Txt_VC"].InnerText,
                                                        FSP_Result_Msg_VC = xmlNode["Result_Msg_VC"] == null ? null : xmlNode["Result_Msg_VC"].InnerText,
                                                        FSP_TRX_Settle_Msg_VC = xmlNode["TRX_Settle_Msg_VC"] == null ? null : xmlNode["TRX_Settle_Msg_VC"].InnerText,
                                                        FSP_Settle_Flag_CH = xmlNode["Settle_Flag_CH"] == null ? (bool?)null : ValidateBoolValue(xmlNode["Settle_Flag_CH"].InnerText),
                                                        FSP_Trans_Type_ID = xmlNode["Trans_Type_ID"] == null ? null : xmlNode["Trans_Type_ID"].InnerText,
                                                        FSP_Void_Flag_CH = xmlNode["Void_Flag_CH"] == null ? (bool?)null : ValidateBoolValue(xmlNode["Void_Flag_CH"].InnerText),
                                                        FSP_Reversal_Flag_CH = xmlNode["Reversal_Flag_CH"] == null ? (bool?)null : ValidateBoolValue(xmlNode["Reversal_Flag_CH"].InnerText),
                                                        PaymentType = "Check"
                                                    });
                    #endregion


                    var dataTable = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transaction_get", new Dictionary<string, object> { { "@PracticeID", (int)practice["PracticeID"] }, { "@DateMin", BeginDT }, { "@DateMax", EndDT }, { "@FlagOnlyFSP", 1 }, { "@FlagProdTrans", 1 }, { "@FlagAllowRenewals", 1 } });

                    #region Check the records from FSP XML against CB Database
                    var count = 0;
                    foreach (var frontStreamPayment in from frontStreamPayment in frontStreamPaymentList let data = dataTable.Select("FSPPNRef=" + frontStreamPayment.PnRef).SingleOrDefault() where data == null select frontStreamPayment)
                    {
                        //Check if the record has been entered into the FlagAuditExemptions Table. If it has not, create a row for it.
                        bool skipnotification;
                        skipnotification = false;
                        var FSPAuditExemptions = SqlHelper.ExecuteDataTableProcedureParams("svc_FSPAuditExemptions_get", new Dictionary<string, object> { { "@FSPPnref", frontStreamPayment.PnRef } });
                        foreach (DataRow row in FSPAuditExemptions.Rows) 
                            {
                                if (Convert.ToBoolean(row["FlagAuditExempted"])) { skipnotification = true; }
                            }
                        if (FSPAuditExemptions.Rows.Count == 0)
                        {
                            if (Convert.ToBoolean((int)practice["FSFlagLive"])) SqlHelper.ExecuteScalarProcedureParams("svc_FSPAuditExemptions_add", new Dictionary<string, object> { { "@PracticeID", (int)practice["PracticeID"] }, { "@PaymentType", frontStreamPayment.PaymentType }, { "@FSPPnRef", frontStreamPayment.PnRef }, { "@FSP_Last_Update_DT", frontStreamPayment.FSP_Last_Update_DT }, { "@FSP_Auth_Amt_MN", frontStreamPayment.FSP_Auth_Amt_MN }, { "@FSP_Orig_TRX_HD_Key", frontStreamPayment.FSP_Orig_TRX_HD_Key.ToString() }, { "@FSP_Trans_Type_ID", frontStreamPayment.FSP_Trans_Type_ID.ToString() }, { "@FSP_Result_CH", frontStreamPayment.FSP_Result_CH }, { "@FSP_Result_Txt_VC", frontStreamPayment.FSP_Result_Txt_VC } });
                        }
                        if (skipnotification == false)
                        {
                            if (count == 0)
                                resultList += "<tr><td colspan='7' align='left'><b>Records missing in CB but exists in FSP XML</b></td></tr><tr><th>#</th><th>FSP Date</th><th>TransactionID</th><th>CardType</th><th>PNRef</th><th>Amount</th><th>Parent Trx</th><th>Trans Type</th><th>Result Code</th><th>Result Txt</th></tr>";
                            count++;
                            resultList += string.Format("<tr>" +
                                                        "<td>1.{0}</td>" +
                                                        "<td>{1:MM/dd/yy hh:mm:ss}</td>" +
                                                        "<td>N/A</td>" +
                                                        "<td>{2}</td>" +
                                                        "<td>{3}</td>" +
                                                        "<td>{4}</td>" +
                                                        "<td>{5}</td>" +
                                                        "<td>{6}</td>" +
                                                        "<td>{7}</td>" +
                                                        "<td>{8}</td></tr>", count.ToString() +')', frontStreamPayment.FSP_Last_Update_DT, frontStreamPayment.PaymentType, frontStreamPayment.PnRef, string.Format("{0:C}", frontStreamPayment.FSP_Auth_Amt_MN), frontStreamPayment.FSP_Orig_TRX_HD_Key.ToString() ?? string.Empty, frontStreamPayment.FSP_Trans_Type_ID.ToString() ?? string.Empty, frontStreamPayment.FSP_Result_CH, frontStreamPayment.FSP_Result_Txt_VC ?? string.Empty);
                            isRecordsMatched = false;
                            
                        }
                    }
                    #endregion
                    #region Check the records from CB Database against FSP XML
                    count = 0;
                    foreach (var dataRow in from dataRow in dataTable.AsEnumerable() let data = frontStreamPaymentList.SingleOrDefault(res => res.PnRef == dataRow["FSPPNRef"].ToString().Trim()) where data == null select dataRow)
                    {
                        if (count == 0)
                            resultList += "<br><tr><td colspan='4' align='left'><b>Record Missing in FSP but exists in CB</b></td></tr><tr><th>#</th><th>Date Created</th><th>TransactionID</th><th>CardType</th><th>PNRef</th><th>Amount</th></tr>";

                        var transactionTypeID = Convert.ToInt32(dataRow["TransactionTypeID"]);
                        var cardType = transactionTypeID >= 21 && transactionTypeID <= 24 ? "Check" : "Card";
                        resultList += string.Format("<tr>" +
                                                    "<td>2.{0}</td>" +
                                                    "<td>{1}</td>" +
                                                    "<td>{2}</td>" +
                                                    "<td>{3}</td>" +
                                                    "<td>{4}</td>" +
                                                    "<td>{5}</td></tr>", count.ToString() + ')', dataRow["TransactionDate"], dataRow["TransactionID"], cardType, dataRow["FSPPNRef"].ToString().Trim(), string.Format("{0:C}", dataRow["Amount"]));

                        isRecordsMatched = false;
                        count++;
                    }
                    #endregion

                    #region Process records that exist in both CB & FSP XML -> update CB Transactions with FSP XML status
                    foreach (var cmdParams in from frontStreamPayment in frontStreamPaymentList
                                              let data = dataTable.Select("FSPPNRef=" + frontStreamPayment.PnRef)
                                              where data.Any()
                                              select new Dictionary<string, object>
                                                                                {
                                                                                    {"@TransactionID", data[0]["TransactionID"]},
                                                                                    {"@TransStateTypeID", frontStreamPayment.TransStateTypeID ?? (object)DBNull.Value},
                                                                                    {"@FSP_Auth_Amt_MN", frontStreamPayment.FSP_Auth_Amt_MN ?? (object)DBNull.Value},
                                                                                    {"@FSP_AVS_Resp_CH", frontStreamPayment.FSP_AVS_Resp_CH?? (object)DBNull.Value},
                                                                                    {"@FSP_Batch_Number", frontStreamPayment.FSP_Batch_Number?? (object)DBNull.Value},
                                                                                    {"@FSP_Last_Update_DT", frontStreamPayment.FSP_Last_Update_DT?? (object)DBNull.Value},
                                                                                    {"@FSP_Manual", frontStreamPayment.FSP_Manual?? (object)DBNull.Value},
                                                                                    {"@FSP_Orig_TRX_HD_Key", frontStreamPayment.FSP_Orig_TRX_HD_Key?? (object)DBNull.Value},
                                                                                    {"@FSP_Payment_Type_ID", frontStreamPayment.FSP_Payment_Type_ID?? (object)DBNull.Value},
                                                                                    {"@FSP_Result_CH", frontStreamPayment.FSP_Result_CH?? (object)DBNull.Value},
                                                                                    {"@FSP_Result_Txt_VC", frontStreamPayment.FSP_Result_Txt_VC?? (object)DBNull.Value},
                                                                                    {"@FSP_Result_Msg_VC", frontStreamPayment.FSP_Result_Msg_VC?? (object)DBNull.Value},
                                                                                    {"@FSP_TRX_Settle_Msg_VC", frontStreamPayment.FSP_TRX_Settle_Msg_VC?? (object)DBNull.Value},
                                                                                    {"@FSP_Settle_Flag_CH", frontStreamPayment.FSP_Settle_Flag_CH?? (object)DBNull.Value},
                                                                                    {"@FSP_Total_Amt_MN", frontStreamPayment.FSP_Total_Amt_MN?? (object)DBNull.Value},
                                                                                    {"@FSP_Trans_Type_ID", frontStreamPayment.FSP_Trans_Type_ID?? (object)DBNull.Value},
                                                                                    {"@FSP_Void_Flag_CH", frontStreamPayment.FSP_Void_Flag_CH?? (object)DBNull.Value},
                                                                                    {"@FSP_Reversal_Flag_CH", frontStreamPayment.FSP_Reversal_Flag_CH?? (object)DBNull.Value},
                                                                                    {"@FSP_Zip_CH", frontStreamPayment.FSP_Zip_CH?? (object)DBNull.Value}
                                                                                })
                    {
                        SqlHelper.ExecuteScalarProcedureParams("web_pr_transaction_add", cmdParams);
                    }
                    #endregion
                    #region Confirm if there are any records where CB and FSP have a disagreement on the Amount Processed
                    var AuditTable = SqlHelper.ExecuteDataTableProcedureParams("svc_transaction_audit", new Dictionary<string, object> { { "@PracticeID", (int)practice["PracticeID"] } });

                    count = 0;
                    foreach (var dataRow in AuditTable.AsEnumerable())
                    {
                        if (count == 0)
                            resultList += "<tr><td colspan='5' align='center'><b>Amount Mismatch between CB and FSP</b></td></tr><tr><th>#</th><th>Date Created</th><th>TransactionID</th><th>CardType</th><th>PNRef</th><th>CB Amount</th><th>FSP Amount</th></tr>";
                        count++;
                        var transactionTypeID = Convert.ToInt32(dataRow["TransactionTypeID"]);
                        var cardType = transactionTypeID >= 21 && transactionTypeID <= 24 ? "Check" : "Card";
                        resultList += string.Format("<tr>" +
                                                    "<td>3.{0}</td>" +
                                                    "<td>{1}</td>" +
                                                    "<td>{2}</td>" +
                                                    "<td>{3}</td>" +
                                                    "<td>{4}</td>" +
                                                    "<td>{5}</td>" +
                                                    "<td>{6}</td></tr>", count.ToString() + ')', dataRow["TransactionDate"], dataRow["TransactionID"], cardType, dataRow["FSPPNRef"].ToString().Trim(), string.Format("{0:C}", dataRow["Amount"]), string.Format("{0:C}", dataRow["FSP_Auth_Amt_Mn"]));

                        isRecordsMatched = false;
                        
                    }
                    #endregion

                    #region Notify Dev/Support if there were any differences in Transactions between CB and FSP
                    if (!isRecordsMatched && Convert.ToBoolean((int)practice["FSFlagLive"]) == true)
                    {
                        string ServiceDevEmail = "";
                        resultList += "</table>";
                        var information = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", new Dictionary<string, object>());
                        foreach (DataRow row in information.Rows)
                        {
                            ServiceDevEmail = row["ServiceDevEmail"].ToString();
                        }
                        EmailServices.SendTransactionEmail("no-reply@careblue.com", "Careblue Service", ServiceDevEmail, "Service: (" + (int)practice["PracticeID"] + ")" + (string)practice["Abbr"] + " Failed FSPAudit", resultList, resultList, string.Empty, string.Empty, string.Empty, (Int32)Enums.ServiceInfo.UserID, string.Empty, string.Empty, null, null, null, null, null, null);
                    }
                    #endregion
                }
                catch (Exception ex)
                {
                    var sqlData = SqlHelper.GetSqlData(ex.Data);
                    EmailServices.SendRunTimeErrorEmail("Request submitted from Service: " + ex.HelpLink, ex.GetType().ToString(), ex.Message, ex.StackTrace, "", "N/A", "N/A", "N/A", "N/A", (Int32)Enums.ServiceInfo.UserID, -1, -1, "127.0.0.1", sqlData);
                }
            }
        }

        private static bool ValidateBoolValue(string value)
        {
            if (value == "true" || value == "1")
                return true;

            if (value == "false" || value == "0")
                return false;
            if (value == "3") return false;
            return Convert.ToBoolean(value);
        }

        class FrontStreamPaymentsXml
        {
            public string PnRef { get; set; }
            public int? TransStateTypeID { get; set; }
            public string Amount { get; set; }
            public string PaymentType { get; set; }
            public decimal? FSP_Auth_Amt_MN { get; set; }
            public string FSP_AVS_Resp_CH { get; set; }
            public string FSP_Batch_Number { get; set; }
            public DateTime? FSP_Last_Update_DT { get; set; }
            public bool? FSP_Manual { get; set; }
            public int? FSP_Orig_TRX_HD_Key { get; set; }
            public string FSP_Payment_Type_ID { get; set; }
            public string FSP_Result_CH { get; set; }
            public string FSP_Result_Txt_VC { get; set; }
            public string FSP_Result_Msg_VC { get; set; }
            public string FSP_TRX_Settle_Msg_VC { get; set; }
            public bool? FSP_Settle_Flag_CH { get; set; }
            public decimal? FSP_Total_Amt_MN { get; set; }
            public string FSP_Trans_Type_ID { get; set; }
            public bool? FSP_Void_Flag_CH { get; set; }
            public bool? FSP_Reversal_Flag_CH { get; set; }
            public string FSP_Zip_CH { get; set; }
        }

        public static void ProcessStatements()
        {
            try
            {
                EventLog.WriteEntry("CBService", "ProcessStatements() Start");

                //In this context, return codes (RC) return 0 or greater means the number of records processed. Negative numbers means errors.
                int MaxDays = -1; //Due today should be MaxDays=0. MaxDays = -1 for due yesterday if running at 4am of the following day.
                int ServicePaymentsRC = 0, StatementPDFsRC = 0;

                //Pre-Insert a NightlyLogID
                var NightlyLogID = SqlHelper.ExecuteScalarProcedureParams("svc_nightlylog_add", new Dictionary<string, object> { { "@ShadowInterestAdded", DBNull.Value }, { "@BCInterestPPFeesAdded", DBNull.Value }, { "@ServicePaymentsProcessed", DBNull.Value }, { "@StatementStatusChanges", DBNull.Value }, { "@StatementPDFsAdded", DBNull.Value } });

                //Update all Transactions States
                var TransactionState = SqlHelper.ExecuteScalarProcedureParams("svc_transactionstate_process", new Dictionary<string, object>() { { "@NightlyLogID", NightlyLogID } });
                if (Convert.ToInt32(TransactionState) == -1) return;

                //Add Interest to BC Shadow Table. Only adds interest for yesterday, prevents adding interest multiple times per statement per date.
                var ShadowInterestRC = SqlHelper.ExecuteScalarProcedureParams("svc_bc_interest_process", new Dictionary<string, object>() { { "@NightlyLogID", NightlyLogID } });
                if (Convert.ToInt32(ShadowInterestRC) == -1) return;

                //Add Fees and Interest to all BC and PP that are due within MaxDays. 
                var BCInterestPPFeesRC = SqlHelper.ExecuteScalarProcedureParams("svc_bc_pp_process", new Dictionary<string, object> { { "@MaxDays", MaxDays }, { "@NightlyLogID", NightlyLogID } });
                if (Convert.ToInt32(BCInterestPPFeesRC) == -1) return;

                #region Process Payments - All BC and PP payments that are scheduled for today
                var pendingPayments = SqlHelper.ExecuteDataTableProcedureParams("svc_pending_payments", new Dictionary<string, object> { { "@MaxDays", MaxDays } });

                foreach (var payment in pendingPayments.AsEnumerable())
                {
                    var transTypeID = (int)payment["TransTypeID"];
                    var statementInfo = string.Format("{0} {1} {2} {3}", payment["PracticeAddr1"], payment["PracticeAddr2"], payment["PracticeAddr3"], payment["PracticeAddr4"]);
                    var NextPayDate = (DateTime)payment["NextPayDate"];
                    var logoDetails = new Dictionary<string, string>
                                          {
                                              { "PracticeLogo", payment["PracticeLogo"].ToString() },
                                              { "Width", payment["PracticeLogoWidth"].ToString() },
                                              { "PracticeLogoHeight", payment["PracticeLogoHeight"].ToString() }
                                          };

                    switch (transTypeID)
                    {
                        case (int)Enums.ProcessCheckCreditDebit.ProcessCreditSale:
                            var processCreditSale = new ProcessCreditSale(payment["NextPayAmount"].ToString(),
                                                                            payment["PNRef"].ToString(),
                                                                            Convert.ToInt32(payment["PatientID"]),
                                                                            Convert.ToInt32((Int32)payment["PaymentCardID"]),
                                                                            Convert.ToInt32(payment["StatementID"]),
                                                                            Convert.ToInt32(payment["AccountID"]),
                                                                            Convert.ToInt32(payment["PracticeID"]), "127.0.0.1",
                                                                            (Int32)Enums.ServiceInfo.UserID,
                                                                            null, (Int32)Enums.SourceType.Service, 0, string.Empty,
                                                                            Convert.ToInt32(payment["LastCycle"]) + 1, (int)NightlyLogID);
                            if (processCreditSale.Success)
                            {
                                ServicePaymentsRC++;
                                if (payment["DPTransactionID"] == DBNull.Value && payment["PaymentPlanID"] != DBNull.Value)
                                {
                                    var cmdParams = new Dictionary<string, object> { { "@PaymentPlanID", Convert.ToInt32(payment["PaymentPlanID"]) }, { "@NextPayDate", payment["NextNextPayDate"] }, { "@DPTransactionID", processCreditSale.ReturnTransID }, { "@LastCycle", Convert.ToInt32(payment["LastCycle"]) + 1 }, { "@UserID", (Int32)Enums.ServiceInfo.UserID } };
                                    SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentplan_add", cmdParams);
                                }
                                else if (payment["DPTransactionID"] != DBNull.Value && payment["PaymentPlanID"] != DBNull.Value)
                                {
                                    var cmdParams = new Dictionary<string, object> { { "@PaymentPlanID", Convert.ToInt32(payment["PaymentPlanID"]) }, { "@NextPayDate", payment["NextNextPayDate"] }, { "@LastCycle", Convert.ToInt32(payment["LastCycle"]) + 1 }, { "@UserID", (Int32)Enums.ServiceInfo.UserID } };
                                    SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentplan_add", cmdParams);
                                }
                                else if (payment["BlueCreditID"] != DBNull.Value)
                                {
                                    var cmdParams = new Dictionary<string, object> { { "@BlueCreditID", Convert.ToInt32(payment["BlueCreditID"]) }, { "@NextPayDate", payment["NextNextPayDate"] }, { "@LastCycle", Convert.ToInt32(payment["LastCycle"]) + 1 }, { "@UserID", (Int32)Enums.ServiceInfo.UserID } };
                                    SqlHelper.ExecuteScalarProcedureParams("Web_pr_bluecredit_add", cmdParams);
                                }
                                EmailServices.SendPaymentReceipt(payment["NextPayAmount$"].ToString(), payment["StatementID"].ToString() + '-' + processCreditSale.ReturnTransID.ToString(""), statementInfo, payment["FSPBillAs"].ToString(), "Credit Card", payment["PatientHTML"].ToString(), payment["PatientEmail"].ToString(), logoDetails, (Int32)Enums.ServiceInfo.UserID, payment["PaymentCardDesc"].ToString(), payment["PracticeName"].ToString(), payment["StatementID"].ToString(), payment["Balance$"].ToString(), true, payment["PhoneBillingAbbr"].ToString());
                            }
                            else
                            {
                                #region Backup Payment Source
                                if (payment["PaymentCardID"] != payment["PaymentCardIDSec"] && payment["PaymentCardIDSec"] != DBNull.Value)
                                {
                                    var processCheckSalebk = new ProcessCheckSale(payment["NextPayAmount"].ToString(),
                                                                                                            payment["PNRefSec"].ToString(),
                                                                                                            Convert.ToInt32(payment["PatientID"]),
                                                                                                            Convert.ToInt32((Int32)payment["PaymentCardIDSec"]),
                                                                                                            Convert.ToInt32(payment["StatementID"]),
                                                                                                            Convert.ToInt32(payment["AccountID"]),
                                                                                                            Convert.ToInt32(payment["PracticeID"]), "127.0.0.1",
                                                                                                            (Int32)Enums.ServiceInfo.UserID,
                                                                                                            null, (Int32)Enums.SourceType.Service, 0, string.Empty,
                                                                                                            Convert.ToInt32(payment["LastCycle"]) + 1, (int)NightlyLogID, "PPD");
                                    if (processCheckSalebk.Success)
                                    {
                                        ServicePaymentsRC++;
                                        if (payment["DPTransactionID"] == DBNull.Value && payment["PaymentPlanID"] != DBNull.Value)
                                        {
                                            var cmdParams = new Dictionary<string, object> { { "@PaymentPlanID", Convert.ToInt32(payment["PaymentPlanID"]) }, { "@NextPayDate", payment["NextNextPayDate"] }, { "@DPTransactionID", processCheckSalebk.ReturnTransID }, { "@LastCycle", Convert.ToInt32(payment["LastCycle"]) + 1 }, { "@UserID", (Int32)Enums.ServiceInfo.UserID } };
                                            SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentplan_add", cmdParams);
                                        }
                                        else if (payment["DPTransactionID"] != DBNull.Value && payment["PaymentPlanID"] != DBNull.Value)
                                        {
                                            var cmdParams = new Dictionary<string, object> { { "@PaymentPlanID", Convert.ToInt32(payment["PaymentPlanID"]) }, { "@NextPayDate", payment["NextNextPayDate"] }, { "@LastCycle", Convert.ToInt32(payment["LastCycle"]) + 1 }, { "@UserID", (Int32)Enums.ServiceInfo.UserID } };
                                            SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentplan_add", cmdParams);
                                        }
                                        else if (payment["BlueCreditID"] != DBNull.Value)
                                        {
                                            var cmdParams = new Dictionary<string, object> { { "@BlueCreditID", Convert.ToInt32(payment["BlueCreditID"]) }, { "@NextPayDate", payment["NextNextPayDate"] }, { "@LastCycle", Convert.ToInt32(payment["LastCycle"]) + 1 }, { "@UserID", (Int32)Enums.ServiceInfo.UserID } };
                                            SqlHelper.ExecuteScalarProcedureParams("Web_pr_bluecredit_add", cmdParams);
                                        }
                                        EmailServices.SendPaymentReceipt(payment["NextPayAmount$"].ToString(), payment["StatementID"].ToString() + '-' + processCheckSalebk.ReturnTransID, statementInfo, payment["FSPBillAs"].ToString(), "eCheck", payment["PatientHTML"].ToString(), payment["PatientEmail"].ToString(), logoDetails, (Int32)Enums.ServiceInfo.UserID, payment["PaymentCardDesc"].ToString(), payment["PracticeName"].ToString(), payment["StatementID"].ToString(), payment["Balance$"].ToString(), true, payment["PhoneBillingAbbr"].ToString());
                                    }
                                }

                                #endregion
                            }
                            break;

                        case (int)Enums.ProcessCheckCreditDebit.ProcessCheckSale:
                            var processCheckSale = new ProcessCheckSale(payment["NextPayAmount"].ToString(),
                                                                        payment["PNRef"].ToString(),
                                                                        Convert.ToInt32(payment["PatientID"]),
                                                                        Convert.ToInt32((Int32)payment["PaymentCardID"]),
                                                                        Convert.ToInt32(payment["StatementID"]),
                                                                        Convert.ToInt32(payment["AccountID"]),
                                                                        Convert.ToInt32(payment["PracticeID"]), "127.0.0.1",
                                                                        (Int32)Enums.ServiceInfo.UserID,
                                                                        null, (Int32)Enums.SourceType.Service, 0, string.Empty,
                                                                        Convert.ToInt32(payment["LastCycle"]) + 1, (int)NightlyLogID, "PPD");
                            if (processCheckSale.Success)
                            {
                                ServicePaymentsRC++;
                                if (payment["DPTransactionID"] == DBNull.Value && payment["PaymentPlanID"] != DBNull.Value)
                                {
                                    var cmdParams = new Dictionary<string, object> { { "@PaymentPlanID", Convert.ToInt32(payment["PaymentPlanID"]) }, { "@NextPayDate", payment["NextNextPayDate"] }, { "@DPTransactionID", processCheckSale.ReturnTransID }, { "@LastCycle", Convert.ToInt32(payment["LastCycle"]) + 1 }, { "@UserID", (Int32)Enums.ServiceInfo.UserID } };
                                    SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentplan_add", cmdParams);
                                }
                                else if (payment["DPTransactionID"] != DBNull.Value && payment["PaymentPlanID"] != DBNull.Value)
                                {
                                    var cmdParams = new Dictionary<string, object> { { "@PaymentPlanID", Convert.ToInt32(payment["PaymentPlanID"]) }, { "@NextPayDate", payment["NextNextPayDate"] }, { "@LastCycle", Convert.ToInt32(payment["LastCycle"]) + 1 }, { "@UserID", (Int32)Enums.ServiceInfo.UserID } };
                                    SqlHelper.ExecuteScalarProcedureParams("web_pr_paymentplan_add", cmdParams);
                                }
                                else if (payment["BlueCreditID"] != DBNull.Value)
                                {
                                    var cmdParams = new Dictionary<string, object> { { "@BlueCreditID", Convert.ToInt32(payment["BlueCreditID"]) }, { "@NextPayDate", payment["NextNextPayDate"] }, { "@LastCycle", Convert.ToInt32(payment["LastCycle"]) + 1 }, { "@UserID", (Int32)Enums.ServiceInfo.UserID } };
                                    SqlHelper.ExecuteScalarProcedureParams("Web_pr_bluecredit_add", cmdParams);
                                }
                                EmailServices.SendPaymentReceipt(payment["NextPayAmount$"].ToString(), payment["StatementID"].ToString() + '-' + processCheckSale.ReturnTransID, statementInfo, payment["FSPBillAs"].ToString(), "eCheck", payment["PatientHTML"].ToString(), payment["PatientEmail"].ToString(), logoDetails, (Int32)Enums.ServiceInfo.UserID, payment["PaymentCardDesc"].ToString(), payment["PracticeName"].ToString(), payment["StatementID"].ToString(), payment["Balance$"].ToString(), true, payment["PhoneBillingAbbr"].ToString());
                            }
                            break;
                    }
                }
                #endregion

                #region Renew PaymentCards
                //Process renewal on all payment records have not been used in "Max Number of days". Currently 9 months. ValidCard() is not an alternative to this.
                var pendingRenewal = SqlHelper.ExecuteDataTableProcedureParams("svc_renew_paymentcard", new Dictionary<string, object> { { "@MaxDays", -279 } });
                foreach (var renewal in pendingRenewal.AsEnumerable())
                {
                    var transTypeID = (int)renewal["TransTypeID"];

                    switch (transTypeID)
                    {
                        case (int)Enums.ProcessCheckCreditDebit.ProcessCreditSale:
                            var processCreditSale = new ProcessCreditSale(renewal["NextPayAmount"].ToString(),
                                                                            renewal["PNRef"].ToString(),
                                                                            Convert.ToInt32(renewal["PatientID"]),
                                                                            Convert.ToInt32((Int32)renewal["PaymentCardID"]),
                                                                            Convert.ToInt32(renewal["StatementID"]),
                                                                            Convert.ToInt32(renewal["AccountID"]),
                                                                            Convert.ToInt32(renewal["PracticeID"]), "127.0.0.1",
                                                                            (Int32)Enums.ServiceInfo.UserID,
                                                                            null, (Int32)Enums.SourceType.Service, (Int32)Enums.FSPTransReasonType.PNRefRenewal, string.Empty,
                                                                            null, (int)NightlyLogID);
                            if (processCreditSale.Success)
                            {
                                var processCreditVoid = new ProcessCreditVoid(renewal["NextPayAmount"].ToString(), processCreditSale.FS_PNRef,
                                                Convert.ToInt32(renewal["PatientID"]), Convert.ToInt32((Int32)renewal["PaymentCardID"]),
                                                Convert.ToInt32(renewal["StatementID"]), Convert.ToInt32(renewal["AccountID"]),
                                                Convert.ToInt32(renewal["PracticeID"]), "127.0.0.1",
                                                (Int32)Enums.ServiceInfo.UserID, processCreditSale.ReturnTransID,
                                                (Int32)Enums.SourceType.Service, (Int32)Enums.FSPTransReasonType.PNRefRenewal,
                                                string.Empty, null, (int)NightlyLogID);
                            }
                            break;

                        case (int)Enums.ProcessCheckCreditDebit.ProcessCheckSale:
                            var processCheckSale = new ProcessCheckSale(renewal["NextPayAmount"].ToString(),
                                                                        renewal["PNRef"].ToString(),
                                                                        Convert.ToInt32(renewal["PatientID"]),
                                                                        Convert.ToInt32((Int32)renewal["PaymentCardID"]),
                                                                        Convert.ToInt32(renewal["StatementID"]),
                                                                        Convert.ToInt32(renewal["AccountID"]),
                                                                        Convert.ToInt32(renewal["PracticeID"]), "127.0.0.1",
                                                                        (Int32)Enums.ServiceInfo.UserID,
                                                                        null, (Int32)Enums.SourceType.Service, (Int32)Enums.FSPTransReasonType.PNRefRenewal, string.Empty,
                                                                        null, (int)NightlyLogID, "PPD");
                            if (processCheckSale.Success)
                            {
                                var processCheckVoid = new ProcessCheckVoid(renewal["NextPayAmount"].ToString(), processCheckSale.FS_PNRef,
                                                Convert.ToInt32(renewal["PatientID"]), Convert.ToInt32((Int32)renewal["PaymentCardID"]),
                                                Convert.ToInt32(renewal["StatementID"]), Convert.ToInt32(renewal["AccountID"]),
                                                Convert.ToInt32(renewal["PracticeID"]), "127.0.0.1",
                                                (Int32)Enums.ServiceInfo.UserID, processCheckSale.ReturnTransID,
                                                (Int32)Enums.SourceType.Service, (Int32)Enums.FSPTransReasonType.PNRefRenewal,
                                                string.Empty, null, (int)NightlyLogID);
                            }

                            break;
                    }
                }
                #endregion

                var StatementStatusChanges = SqlHelper.ExecuteScalarProcedureParams("svc_statements_process", new Dictionary<string, object> { { "@MaxDays", MaxDays }, { "@NightlyLogID", NightlyLogID }, { "@FlagProcess", 1 } });

                try
                {
                    //Generate PDFs for Mailruns/Emails.
                    var statements = SqlHelper.ExecuteDataTableProcedureParams("svc_pending_statementinv", new Dictionary<string, object>());
                    foreach (var statement in statements.AsEnumerable())
                    {
                        #if(!DEBUG)
                        //Don't generate statements and email them to clients during debug. This can only be done on production server.
                        StatementPDFsRC++;
                        PDFServices.PDFCreate(statement["FileName"].ToString(),
                                              statement["WebPathStatements"].ToString() + statement["statementID"],
                                              statement["DefaultPath"].ToString(),
                                              statement["Password"].ToString());

                        EmailServices.SendStatement((int)NightlyLogID, statement);
                        SqlHelper.ExecuteScalarProcedureParams("web_pr_statementinv_add", new Dictionary<string, object> { { "@InvoiceID", Convert.ToInt32(statement["InvoiceID"]) }, { "@FileName", statement["FileName"].ToString() }, { "@NightlyLogID", NightlyLogID }, { "@FlagLocked", 1 } });
                        #endif
                    }
                }
                catch (Exception ex)
                {
                    StatementPDFsRC = -1;
                    var sqlData = SqlHelper.GetSqlData(ex.Data);
                    EmailServices.SendRunTimeErrorEmail("Request submitted from Service: " + ex.HelpLink, ex.GetType().ToString(), ex.Message, ex.StackTrace, "", "N/A", "N/A", "N/A", "N/A", (Int32)Enums.ServiceInfo.UserID, -1, -1, "127.0.0.1", sqlData);
                }

                //Update the Nightly Log
                SqlHelper.ExecuteScalarProcedureParams("svc_nightlylog_add", new Dictionary<string, object> { { "@NightlyLogID", NightlyLogID }, { "@ShadowInterestAdded", ShadowInterestRC }, { "@BCInterestPPFeesAdded", BCInterestPPFeesRC }, { "@ServicePaymentsProcessed", ServicePaymentsRC }, { "@StatementStatusChanges", StatementStatusChanges }, { "@StatementPDFsAdded", StatementPDFsRC } });

                //Send Nightly Log Email
                var htmlMessage = "<table><tr><td colspan='2' align='center'><b>Nightly Service Log</b></td></tr>";
                htmlMessage += "<tr><td>NightlyLogID</td><td>" + NightlyLogID.ToString();
                if (TimeZoneInfo.ConvertTimeBySystemTimeZoneId(DateTime.UtcNow, "Eastern Standard Time").TimeOfDay.Hours != 4)// Time not between 4-5am EST
                {
                    htmlMessage += "<font color = red>";
                    htmlMessage += " (" + TimeZoneInfo.ConvertTimeBySystemTimeZoneId(DateTime.UtcNow, "Eastern Standard Time").ToString() + ")</font></td></tr>";
                }
                else
                {
                    htmlMessage += " (" + TimeZoneInfo.ConvertTimeBySystemTimeZoneId(DateTime.UtcNow, "Eastern Standard Time").ToString() + ")</td></tr>";
                }
                htmlMessage += string.Format(
                                        "<tr><td>ShadowInterestAdded</td><td>{0}</td></tr>" +
                                        "<tr><td>BCInterestPPFeesAdded</td><td>{1}</td></tr>" +
                                        "<tr><td>ServicePaymentsProcessedSuccessfully</td><td>{2}</td></tr>" +
                                        "<tr><td>StatementStatusChanges</td><td>{3}</td></tr>" +
                                        "<tr><td>StatementPDFsAdded</td><td>{4}</td></tr></table>",
                                        ShadowInterestRC, BCInterestPPFeesRC.ToString(), ServicePaymentsRC.ToString(), StatementStatusChanges.ToString(), StatementPDFsRC.ToString());

                var DetailedLogs = SqlHelper.ExecuteDataTableProcedureParams("svc_nightlylog_get", new Dictionary<string, object> { { "@NightlyLogID", NightlyLogID } });
                foreach (var DetailedLog in DetailedLogs.AsEnumerable())
                    {
                        htmlMessage += DetailedLog["HTML"].ToString();
                    }

                var EmailSubject = "Nightly Service Log (" + TimeZoneInfo.ConvertTimeBySystemTimeZoneId(DateTime.UtcNow, "Eastern Standard Time").ToString("d") + ")";
                if ((int)ShadowInterestRC < 0 || (int)BCInterestPPFeesRC < 0 || ServicePaymentsRC < 0 || (int)StatementStatusChanges < 0 || StatementPDFsRC < 0)
                {
                    EmailSubject += " - FAILURE";
                }
                else
                {
                    EmailSubject += " - SUCCESS";
                }

                string ServiceDevEmail = "";
                var information = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", new Dictionary<string, object>());
                foreach (DataRow row in information.Rows)
                {
                    ServiceDevEmail = row["ServiceDevEmail"].ToString();
                }
                EmailServices.SendTransactionEmail("no-reply@careblue.com", "Careblue Service", ServiceDevEmail, EmailSubject, htmlMessage, htmlMessage, string.Empty, string.Empty, string.Empty, (Int32)Enums.ServiceInfo.UserID, string.Empty, string.Empty, null, null, null, null, null, Convert.ToInt32(NightlyLogID));
            }
            catch (Exception ex)
            {
                //SqlHelper.ExecuteScalarProcedureParams("svc_ServiceProcessingDate", new Dictionary<string, object> { { "@revert", true } });
                var sqlData = SqlHelper.GetSqlData(ex.Data);
                EmailServices.SendRunTimeErrorEmail("Request submitted from Service: " + ex.HelpLink, ex.GetType().ToString(), ex.Message, ex.StackTrace, "", "N/A", "N/A", "N/A", "N/A", 1, -1, -1, "127.0.0.1", sqlData);
            }
        }
    }

    #region Fax
    /*public class FaxQueue
    {
        public FaxQueue(string connectionstring)
        {
            SqlConnection connection = new SqlConnection(connectionstring);
            SqlConnection connection2 = new SqlConnection(connectionstring);
            SqlCommand cmd = new SqlCommand();
            SqlCommand cmd2 = new SqlCommand();
            SqlDataReader reader;
            SqlDataReader reader2;
            
            cmd.CommandText = "usp_process_faxqueue";
            cmd.CommandType = CommandType.StoredProcedure;
            //if (parameter1_desc != null) { cmd.Parameters.Add(new SqlParameter(parameter1_desc, parameter1_value)); }

            cmd.Connection = connection;

            try
            {
                connection.Open();
                reader = cmd.ExecuteReader();

                // Call Read before accessing data.
                while (reader.Read())
                {
                    int StatusTypeID;
                    string StatusDescLong = "";
                    string faxToSend = null;
                    byte[] binaryData;
                    using (FileStream freader = new FileStream(reader["FileLocation"].ToString(), FileMode.Open, FileAccess.Read))
                    {
                        if (freader.CanSeek)
                            freader.Seek(0, SeekOrigin.Begin);

                        binaryData = new byte[freader.Length];

                        freader.Read(binaryData, 0, (int)freader.Length);

                        freader.Close();
                    }

                    faxToSend = Convert.ToBase64String(binaryData, 0, binaryData.Length);

                    // POST the data
                    NameValueCollection NC = new NameValueCollection();
                    NC.Add("username", reader["FaxUser"].ToString());
                    NC.Add("company", reader["FaxCompanyID"].ToString());
                    NC.Add("password", reader["FaxPassword"].ToString());
                    NC.Add("operation", "sendfax");
                    NC.Add("faxno", reader["DestinationAddress"].ToString());
                    NC.Add("faxfilenames[0]", reader["FileName"].ToString());
                    NC.Add("faxfiledata[0]", faxToSend);

                    string address = "https://www.faxage.com/httpsfax.php";
                    WebClient client = new WebClient();

                    byte[] bytes = client.UploadValues(address, NC);
                    string response = Encoding.ASCII.GetString(bytes);

                    if (response.Trim().Substring(0, 3) == "ERR")
                    {
                        StatusTypeID = 100003; //Error
                        StatusDescLong = response;
                    }
                    else
                    {
                        StatusTypeID = 100001; //Pending
                    }
                    string[] strArray = response.Split(new[] { ':' });

                    cmd2 = new SqlCommand();
                    cmd2.CommandText = "usp_process_faxqueue_update";
                    cmd2.CommandType = CommandType.StoredProcedure;
                    cmd2.Parameters.Add(new SqlParameter("QueueID", (int)reader["QueueID"]));
                    cmd2.Parameters.Add(new SqlParameter("StatusTypeID", StatusTypeID));
                    cmd2.Parameters.Add(new SqlParameter("StatusDescLong", StatusDescLong));
                    cmd2.Parameters.Add(new SqlParameter("TransactionID", Int32.Parse(strArray[1].Trim()))); //Fax Service's TransID
                    cmd2.Connection = connection2;
                    connection2.Open();
                    reader2 = cmd2.ExecuteReader();
                    reader2.Close();
                    connection2.Close();
                }
            }
            catch (Exception e)
            {
                ErrorHandling ehandler = new ErrorHandling(e.ToString());
                return;
            }
        }
    }*/
    /*public class FaxQueueStatus
    {
        private DateTime ParseDateTime(string sendtime)
        {
            DateTime test;
            if (DateTime.TryParse(sendtime, out test))
                return test;
            else
                return DateTime.Now;
        }
        public FaxQueueStatus(string connectionstring)
        {
            SqlConnection connection = new SqlConnection(connectionstring);
            SqlConnection connection2 = new SqlConnection(connectionstring);
            SqlCommand cmd = new SqlCommand();
            SqlCommand cmd2 = new SqlCommand();
            SqlDataReader reader;
            SqlDataReader reader2;

            cmd.CommandText = "usp_process_faxqueue_status";
            cmd.CommandType = CommandType.StoredProcedure;
            //if (parameter1_desc != null) { cmd.Parameters.Add(new SqlParameter(parameter1_desc, parameter1_value)); }

            cmd.Connection = connection;

            try
            {
                connection.Open();
                reader = cmd.ExecuteReader();

                // Call Read before accessing data.
                int StatusTypeID;
                string[] strArray;
                while (reader.Read())
                {
                    NameValueCollection NC = new NameValueCollection();
                    NC.Add("username", reader["FaxUser"].ToString());
                    NC.Add("company", reader["FaxCompanyID"].ToString());
                    NC.Add("password", reader["FaxPassword"].ToString());
                    NC.Add("operation", "status");
                    NC.Add("pagecount", "1");
                    NC.Add("useronly", "1");
                    NC.Add("extqueue", "1");
                    NC.Add("csid", "1");
                    NC.Add("showlogin", "1");
                    NC.Add("xmitpages", "1");
                    NC.Add("jobids[0]", reader["TransactionID"].ToString()); //continue looping TransactionID values.

                    string address = "https://www.faxage.com/httpsfax.php";
                    WebClient client = new WebClient();

                    string response = Encoding.ASCII.GetString(client.UploadValues(address, NC));

                    string[] delimiter1 = new[] { "n" };
                    strArray = null;
                    strArray = response.Split(new[] { "\t" }, StringSplitOptions.RemoveEmptyEntries);

                    if (response.Trim().Substring(0, 3) == "ERR")
                    {
                        StatusTypeID = 100003; //Error
                    }
                    else
                    {
                        StatusTypeID = 100002; //Confirmed
                    }

                    string jobid = strArray[0];
                    string commid = strArray[1];
                    string destname = strArray[2];
                    string destnum = strArray[3];
                    string shortstatus = strArray[4];
                    string longstatus = strArray[5];
                    string sendtime = strArray[6];
                    string completetime = strArray[7];
                    string xmittime = strArray[8];
                    string pagecount = strArray[9];
                    string csid = strArray[10];
                    string login = strArray[11];
                    string xmitpages = strArray[12];

                    if (shortstatus == "pending") { StatusTypeID = 100001; } //Pending. Maintain status until it changes away from pending
                    if (shortstatus == "failure") { StatusTypeID = 100003; } //Error

                    cmd2 = new SqlCommand();
                    cmd2.CommandText = "usp_process_faxqueue_status_update";
                    cmd2.CommandType = CommandType.StoredProcedure;
                    cmd2.Parameters.Add(new SqlParameter("QueueID", (int)reader["QueueID"]));
                    cmd2.Parameters.Add(new SqlParameter("StatusTypeID", StatusTypeID));
                    cmd2.Parameters.Add(new SqlParameter("ReportSendTS", ParseDateTime(sendtime)));
                    cmd2.Parameters.Add(new SqlParameter("ReportXmitTime", ParseDateTime(xmittime)));
                    cmd2.Parameters.Add(new SqlParameter("ReportPageCnt", int.Parse(pagecount)));
                    cmd2.Parameters.Add(new SqlParameter("StatusDescShort", shortstatus));
                    cmd2.Parameters.Add(new SqlParameter("StatusDescLong", longstatus));
                    cmd2.Parameters.Add(new SqlParameter("TransactionID", int.Parse(jobid)));
                    cmd2.Parameters.Add(new SqlParameter("CommID", int.Parse(commid)));
                    cmd2.Parameters.Add(new SqlParameter("FaxCSIDName", csid));
                    cmd2.Parameters.Add(new SqlParameter("FaxLogin", login));
                    cmd2.Connection = connection2;
                    connection2.Open();
                    reader2 = cmd2.ExecuteReader();
                    reader2.Close();
                    connection2.Close();
                }
                // Call Close when done reading.

                //Console.ReadLine(); 
                reader.Close();
                connection.Close();
            }
            catch (Exception e)
            {
                ErrorHandling ehandler = new ErrorHandling(e.ToString());
                return;
            }
        }
    }*/
    #endregion
}
