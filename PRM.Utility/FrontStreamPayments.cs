using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using PatientPortal.DataLayer;

namespace PatientPortal.Utility
{
    static class FSPProperties
    {
        public static string SqlData { get; set; }
    }

    public class TransactionAdd
    {

        public int ReturnTransID { get; set; }
        public TransactionAdd(Nullable<int> TransactionID, int TransactionTypeID, Nullable<int> TransStateTypeID, int PatientID, int PaymentCardID, int StatementID, int AccountID, int PracticeID, string IPAddress, string Message, Boolean FlagSuccess, string FSPAuthRef, int FSPStatusTypeID, string Amount, string PNRef, int UserID, Nullable<int> TransactionIDPri, Nullable<int> SourceTypeID, Nullable<int> ReasonTypeID, string Notes, Nullable<int> Cycle, Nullable<int> NightlyLogID, string MagTek = null)
        {
            try
            {
                var cmdParams = new Dictionary<string, object>
                                {
                                    {"TransactionID", TransactionID},
                                    {"TransactionTypeID", TransactionTypeID},
                                    {"TransStateTypeID", TransStateTypeID},
                                    {"PatientID", PatientID},
                                    {"PaymentCardID", PaymentCardID},
                                    {"StatementID", StatementID},
                                    {"Cycle", Cycle},
                                    {"AccountID", AccountID},
                                    {"PracticeID", PracticeID},
                                    {"IPAddress", IPAddress},
                                    {"FSPMessage", Message},
                                    {"FSPPNRef", PNRef},
                                    {"FSPMagTek", MagTek},
                                    {"FSPAuthRef", FSPAuthRef},
                                    {"FSPStatusTypeID", FSPStatusTypeID},
                                    {"Amount", Amount},
                                    {"UserID", UserID},
                                    {"TransactionIDPri", TransactionIDPri},
                                    {"SourceTypeID", SourceTypeID},
                                    {"ReasonTypeID", ReasonTypeID},
                                    {"NightlyLogID", NightlyLogID},
                                    {"FlagSuccess", FlagSuccess},
                                    {"Notes", Notes}
                                };


                var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transaction_add", cmdParams);
                foreach (DataRow row in reader.Rows)
                {
                    ReturnTransID = (int)row["TransactionID"];
                }
                
            }
            catch
            {
                throw;
            }
        }
    }
    public class ValidCard
    {
        public string Message { get; set; }
        public string PNRef { get; set; }
        public string FSPAuthRef { get; set; }
        public int FSPStatusID { get; set; }
        public int FSPTransStateTypeID { get; set; }
        public Boolean Success { get; set; } //1 = success, 0 = failure
        public int ReturnTransID { get; set; }

        public ValidCard(int cardtype, string CardNumberAbbr, string ExpDate, int PatientID, int PaymentCardID, int AccountID, int PracticeID, string IPAddress, int UserID, string NameOnCard, string Street, string Zip, string CVNum, string MagTek = null)
        {

            try
            {
                Nullable<int> TransactionID = null;
                string amount = "0.00";
                if (cardtype == 1 || cardtype == 2) {amount = "0.00";}
                else if (cardtype == 3 || cardtype == 5){amount = "1.00";}
                PNRef = null;

                //pre-Insert Transaction Record
                TransactionAdd FSTAdd;
                FSTAdd = new TransactionAdd(null, (Int32)Enums.TransactionTypeID.ValidateCreditCard, null, PatientID, PaymentCardID, 0, AccountID, PracticeID, IPAddress, Message, Success, FSPAuthRef, FSPStatusID, amount, PNRef, UserID, null, null, null, null, null, null, MagTek);
                ReturnTransID = FSTAdd.ReturnTransID;

                ProcessCreditCard PCC;
                if (cardtype == 1 || cardtype == 2) //Mastercard and Visa
                {
                    PCC = new ProcessCreditCard(UserID, IPAddress, PatientID, PracticeID, "Auth", CardNumberAbbr, ExpDate, "", NameOnCard, amount, ReturnTransID.ToString(), "", Zip, Street, CVNum, "", MagTek);
                    if (PCC.Success == true)
                    {
                        FSPAuthRef = PCC.FSPAuthRef;
                        FSPStatusID = PCC.FSPStatusID;
                        FSPTransStateTypeID = PCC.FSPTransStateTypeID;
                        PNRef = PCC.FS_PNRef;
                        Message = PCC.FSPMessage;
                        Success = true;
                    }
                    else
                    {
                        FSPStatusID = PCC.FSPStatusID;
                        FSPTransStateTypeID = PCC.FSPTransStateTypeID;
                        PNRef = PCC.FS_PNRef;
                        Message = PCC.FSPMessage;
                        Success = false;
                    }
                }

                if (cardtype == 3 || cardtype == 5) //AmEx and Discover
                {
                    PCC = new ProcessCreditCard(UserID, IPAddress, PatientID, PracticeID, "Sale", CardNumberAbbr, ExpDate, "", "", amount, ReturnTransID.ToString(), "", Zip, Street, CVNum, "", MagTek);
                    if (PCC.Success == true)
                    {
                        FSPAuthRef = PCC.FSPAuthRef;
                        FSPStatusID = PCC.FSPStatusID;
                        FSPTransStateTypeID = PCC.FSPTransStateTypeID;
                        PNRef = PCC.FS_PNRef;
                        Message = PCC.FSPMessage;
                        Success = true;

                        //Updates the previously pre-Inserted Record
                        TransactionAdd FSTAdd2;
                        FSTAdd2 = new TransactionAdd(ReturnTransID, (Int32)Enums.TransactionTypeID.ValidateCreditCard, PCC.FSPTransStateTypeID, PatientID, PaymentCardID, 0, AccountID, PracticeID, IPAddress, Message, Success, FSPAuthRef, FSPStatusID, amount, PNRef, UserID, null, null, null, null, null, null, MagTek);
                        TransactionID = FSTAdd2.ReturnTransID;

                        //Pre-Inserts another record, link ReturnTransID to the new record.
                        TransactionAdd FSTAdd3;
                        FSTAdd3 = new TransactionAdd(null, (Int32)Enums.TransactionTypeID.ValidateCreditCard, null, PatientID, PaymentCardID, 0, AccountID, PracticeID, IPAddress, Message, Success, FSPAuthRef, FSPStatusID, amount, PNRef, UserID, null, null, null, null, null, null, MagTek);
                        ReturnTransID = FSTAdd3.ReturnTransID;

                        PCC = new ProcessCreditCard(UserID, IPAddress, PatientID, PracticeID, "Void", null, null, "", "", amount, "", PCC.FS_PNRef, "", "", "", "<PNRef>" + PCC.FS_PNRef + "</PNRef>", MagTek);
                        FSPAuthRef = PCC.FSPAuthRef;
                        FSPStatusID = PCC.FSPStatusID;
                        FSPTransStateTypeID = PCC.FSPTransStateTypeID;
                        PNRef = PCC.FS_PNRef;
                        Message = PCC.FSPMessage;

                    }
                    else
                    {
                        FSPStatusID = PCC.FSPStatusID;
                        FSPTransStateTypeID = PCC.FSPTransStateTypeID;
                        PNRef = PCC.FS_PNRef;
                        Message = PCC.FSPMessage;
                        Success = false;
                    }
                }

                //Updates the previously pre-Inserted Record
                FSTAdd = new TransactionAdd(ReturnTransID, (Int32)Enums.TransactionTypeID.ValidateCreditCard, FSPTransStateTypeID, PatientID, PaymentCardID, 0, AccountID, PracticeID, IPAddress, Message, Success, FSPAuthRef, FSPStatusID, null, PNRef, UserID, TransactionID, null, null, null, null, null, MagTek);
                ReturnTransID = FSTAdd.ReturnTransID;

                return;
            }
            catch
            {
                Success = false;
                throw;
            }
        }
    }

    public class ProcessCreditCard
    {
        public string FSPMessage { get; set; }
        public string FS_PNRef { get; set; }
        public Boolean Success { get; set; }
        public string FSPAuthRef { get; set; }
        public int FSPStatusID { get; set; }
        public int FSPTransStateTypeID { get; set; }

        public ProcessCreditCard(int UserID, string IPAddress, int PatientID, int PracticeID, string FSTranstype, string CardNumberAbbr, string ExpDate, string MagData, string NameOnCard, string Amount, string InvoiceID, string PNRef, string Zip, string Street, string CVNum, string ExtData, string MagTek = null)
        {
            try
            {
                //FrontStream credentials.

                var reader = SqlHelper.ExecuteDataTableProcedureParams("sys_FSInfo_get", new Dictionary<string, object> { { "PracticeID", PracticeID } });
                string FSUsername = "";
                string FSPassword = "";
                int FSMerchantID = 0;
                int FSPartnerID = 0;
                bool FSFlagLive = false;
                foreach (DataRow row in reader.Rows)
                {
                    FSFlagLive = (bool)row["FSFlagLive"];
                    if (FSFlagLive == true)
                    {
                        FSPartnerID = (int)row["FSPartnerID"];
                        FSMerchantID = (int)row["FSMerchantID"];
                        FSUsername = CryptorEngine.Decrypt((string)row["FSUserName"]);
                        FSPassword = CryptorEngine.Decrypt((string)row["FSPassword"]);
                    }
                    else
                    {
                        FSPartnerID = (int)row["FSDevPartnerID"];
                        FSMerchantID = (int)row["FSDevMerchantID"];
                        FSUsername = CryptorEngine.Decrypt((string)row["FSDevUsername"]);
                        FSPassword = CryptorEngine.Decrypt((string)row["FSDevPassword"]);
                    }
                }

                FS_Transact_Prod.SmartPayments Transact_Prod = new FS_Transact_Prod.SmartPayments();
                FS_Transact_Prod.Response response_Prod;
                FS_Transact_Dev.SmartPayments Transact_Dev = new FS_Transact_Dev.SmartPayments();
                FS_Transact_Dev.Response response_Dev;
                FS_Transact_Reader.SmartPayments3 Transact_Reader = new FS_Transact_Reader.SmartPayments3();
                FS_Transact_Reader.Response response_Reader;
                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12; //New Standard for PCI Compliance

                //FSTranstype = "Sale"; //possible options: Sale, Adjustment, Auth, Return, Void
                //CardNumberAbbr = "4788250000028291";
                //ExpDate = "0514";
                //MagData = ""; //Data located on the track 2 of the magnetic strip of the card. Once this field is populated,
                ////the transaction will be indicated as Card-Present transaction and usually result in a more favorable retail
                ////discount rate. The format of the MagData (or Track 2 data) is CardNum=ExpDate followed by the service code 
                ////and checksum. For example, 36438999960016=05121015432112345678.
                //NameOnCard = ""; //Optional, depending on different merchant processor setups. The cardholder’s name as it appears on the card. This parameter will remove invalid characters.
                //Amount = "5.00";
                //InvoiceID = "123456";
                //PNRef = ""; //Optional except for these TransType’s: Void, Force (PostAuth), Capture. Reference number assigned by the payment server
                //Zip = ""; //Optional depending on different merchant processor setups. Cardholder’s billing address zip code used in address verification.
                //Street = ""; //Optional depending on different merchant processor setup. Cardholder’s billing street address used in address verification.
                //CVNum = ""; //Optional. Card verification number
                //ExtData = ""; 
                /*Optional except in the cases of: AuthCode (required for a Force (ForceAuth) transaction); City and BillToState (required by certain processors); Invoice and
                associated nested data elements (required for Concord EFS Purchase Card Level 3 and Fuel purchases- see section below). Extended data in XML format. Valid values are:
                • <AuthCode>ApprovalCode</AuthCode> for original authorization code
                • <CustCode>CustomerCode</CustCode> for customer code or PO number */

                if (InvoiceID != "" && InvoiceID != null)
                {
                    ExtData = "<TransactionID>" + InvoiceID + "</TransactionID>" + ExtData;
                }

                int responseresult;

                if (MagTek != null && (PNRef == null || PNRef == ""))
                {
                    string[] CardData = MagTek.Split('|');
                    //if (CardData[0].Length != 0 && CardData[0].Length < 6)
                    //{
                    //}
                    //else if (CardData[0].Length() != 0)
                    //{
                
                    //}
                    //else if (txtMagtek.Text.Length() == 0)
                    //{
                    ExtData = "<SecureFormat>MagneSafeV1</SecureFormat>" + ExtData;
                    ExtData = "<SecurityInfo>" + CardData[9] + "</SecurityInfo>" + ExtData;
                    ExtData = "<CardAuthenticationData>" + CardData[6] + "</CardAuthenticationData>" + ExtData;
                    ExtData = "<Track1>" + CardData[2] + "</Track1>" + ExtData;
                    ExtData = "<Track2>" + CardData[3] + "</Track2>" + ExtData;
                    ExtData = "<MPStatus>" + CardData[5] + "</MPStatus>" + ExtData;

                    response_Reader = Transact_Reader.ProcessCreditCard(FSUsername, FSPassword, FSTranstype, CardNumberAbbr, ExpDate, MagData, NameOnCard, Amount, InvoiceID, PNRef, Zip, Street, CVNum, ExtData);
                    FS_PNRef = response_Reader.PNRef;
                    FSPAuthRef = response_Reader.AuthCode;
                    FSPStatusID = response_Reader.Result;
                    responseresult = response_Reader.Result;
                }
                else if (FSFlagLive == true)
                {
                    response_Prod = Transact_Prod.ProcessCreditCard(FSUsername, FSPassword, FSTranstype, CardNumberAbbr, ExpDate, MagData, NameOnCard, Amount, InvoiceID, PNRef, Zip, Street, CVNum, ExtData);
                    FS_PNRef = response_Prod.PNRef;
                    FSPAuthRef = response_Prod.AuthCode;
                    FSPStatusID = response_Prod.Result;
                    responseresult = response_Prod.Result;
                }
                else
                {
                    response_Dev = Transact_Dev.ProcessCreditCard(FSUsername, FSPassword, FSTranstype, CardNumberAbbr, ExpDate, MagData, NameOnCard, Amount, InvoiceID, PNRef, Zip, Street, CVNum, ExtData);
                    FS_PNRef = response_Dev.PNRef;
                    FSPAuthRef = response_Dev.AuthCode;
                    FSPStatusID = response_Dev.Result;
                    responseresult = response_Dev.Result;
                }


                #region ResponseResult
                switch (responseresult)
                {
                    case 0:
                        Success = true;
                        FSPMessage = "Success";
                        if (FSTranstype == "Void")
                            FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Voided;
                        else
                            FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Approved;
                        break;
                    case 1:
                        Success = false;
                        FSPMessage = "User Authentication Failed";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 2:
                        Success = false;
                        FSPMessage = "Invalid Transaction";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 3:
                        Success = false;
                        FSPMessage = "Invalid Transaction Type";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 4:
                        Success = false;
                        FSPMessage = "Invalid Amount";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 5:
                        Success = false;
                        FSPMessage = "Invalid Merchant Information";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 7:
                        Success = false;
                        FSPMessage = "Field Format Error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 8:
                        Success = false;
                        FSPMessage = "Not a Transaction Server ";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 9:
                        Success = false;
                        FSPMessage = "Invalid Parameter Stream";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 10:
                        Success = false;
                        FSPMessage = "Too Many Line Items";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 11:
                        Success = false;
                        FSPMessage = "Client Timeout Waiting for Response";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 12:
                        Success = false;
                        FSPMessage = "Decline";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Declined;
                        break;
                    case 13:
                        Success = false;
                        FSPMessage = "Referral";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Referred;
                        break;
                    case 14:
                        Success = false;
                        FSPMessage = "Transaction Type Not Supported In This Version";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 19:
                        Success = false;
                        FSPMessage = "Original Transaction ID Not Found";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 20:
                        Success = false;
                        FSPMessage = "Customer Reference Number Not Found ";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 22:
                        Success = false;
                        FSPMessage = "Invalid ABA Number";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 23:
                        Success = false;
                        FSPMessage = "Invalid Account Number";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 24:
                        Success = false;
                        FSPMessage = "Invalid Expiration Date";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 25:
                        Success = false;
                        FSPMessage = "Transaction Type Not Supported by Host";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 26:
                        Success = false;
                        FSPMessage = "Invalid Reference Number";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 27:
                        Success = false;
                        FSPMessage = "Invalid Receipt Information";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 28:
                        Success = false;
                        FSPMessage = "Invalid Check Holder Name";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 29:
                        Success = false;
                        FSPMessage = "Invalid Check Number";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 30:
                        Success = false;
                        FSPMessage = "Check DL Verification Requires DL State";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 40:
                        Success = false;
                        FSPMessage = "Transaction did not connect (to NCN because SecureNCIS is not running on the web server)";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 50:
                        Success = false;
                        FSPMessage = "Insufficient Funds Available";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Returned;
                        break;
                    case 99:
                        Success = false;
                        FSPMessage = "General Error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 100:
                        Success = false;
                        FSPMessage = "Invalid Transaction Returned from Host";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 101:
                        Success = false;
                        FSPMessage = "Timeout Value too Small or Invalid Time Out Value";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 102:
                        Success = false;
                        FSPMessage = "Processor Not Available";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 103:
                        Success = false;
                        FSPMessage = "Error Reading Response from Host";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 104:
                        Success = false;
                        FSPMessage = "Timeout waiting for Processor Response";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 105:
                        Success = false;
                        FSPMessage = "Credit Error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 106:
                        Success = false;
                        FSPMessage = "Host Not Available";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 107:
                        Success = false;
                        FSPMessage = "Duplicate Suppression Timeout";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 108:
                        Success = false;
                        FSPMessage = "Void Error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 109:
                        Success = false;
                        FSPMessage = "Timeout Waiting for Host Response";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 110:
                        Success = false;
                        FSPMessage = "Duplicate Transaction";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 111:
                        Success = false;
                        FSPMessage = "Capture Error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 112:
                        Success = false;
                        FSPMessage = "Failed AVS Check";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 113:
                        Success = false;
                        FSPMessage = "Cannot Exceed Sales Cap";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 1000:
                        Success = false;
                        FSPMessage = "Generic Host Error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1001:
                        Success = false;
                        FSPMessage = "Invalid Login";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1002:
                        Success = false;
                        FSPMessage = "Insufficient Privilege or Invalid Amount";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1003:
                        Success = false;
                        FSPMessage = "Invalid Login Blocked";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1004:
                        Success = false;
                        FSPMessage = "Invalid Login Deactivated";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1005:
                        Success = false;
                        FSPMessage = "Transaction Type Not Allowed";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 1006:
                        Success = false;
                        FSPMessage = "Unsupported Processor";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1007:
                        Success = false;
                        FSPMessage = "Invalid Request Message";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1008:
                        Success = false;
                        FSPMessage = "Invalid Version";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1010:
                        Success = false;
                        FSPMessage = "Payment Type Not Supported";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1011:
                        Success = false;
                        FSPMessage = "Error Starting Transaction";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1012:
                        Success = false;
                        FSPMessage = "Error Finishing Transaction";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1013:
                        Success = false;
                        FSPMessage = "Error Checking Duplicate";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1014:
                        Success = false;
                        FSPMessage = "No Records To Settle (in the current batch)";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1015:
                        Success = false;
                        FSPMessage = "No Records To Process (in the current batch)";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    default:
                        FSPMessage = "Unknown error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        Success = false;
                        break;
                }
                #endregion
            }
            catch (Exception ex)
            {
                Success = false;
                FSPMessage = "Unknown error";
                FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                var sqlData = SqlHelper.GetSqlData(ex.Data);
                EmailServices.SendRunTimeErrorEmail("FrontStreamPayments Run Time Error: " + ex.HelpLink, ex.GetType().ToString(), ex.Message, ex.StackTrace, "", "N/A", "N/A", "N/A", "N/A", UserID, PatientID, PracticeID, IPAddress.ToString(), sqlData);
            }
        }
    }
    public class ProcessCreditSale
    {
        public string FSPMessage { get; set; }
        public string FS_PNRef { get; set; }
        public Boolean Success { get; set; }
        public string FSPAuthRef { get; set; }
        public int FSPStatusID { get; set; }
        public int FSPTransStateTypeID { get; set; }
        public int ReturnTransID { get; set; }
        public ProcessCreditSale(string Amount, string PNRef, int PatientID, int PaymentCardID, int StatementID, int AccountID, int PracticeID, string IPAddress, int UserID, Nullable<int> TransactionIDPri, int SourceTypeID, int ReasonTypeID, string Notes, Nullable<int> Cycle, Nullable<int> NightlyLogID, string MagTek = null)
        {
            try
            {
                //Pre-Insert Record
                TransactionAdd FSTAdd;
                FSTAdd = new TransactionAdd(null, 12, null, PatientID, PaymentCardID, StatementID, AccountID, PracticeID, IPAddress, FSPMessage, Success, FSPAuthRef, FSPStatusID, Amount, PNRef, UserID, TransactionIDPri, SourceTypeID, ReasonTypeID, Notes, Cycle, NightlyLogID);
                ReturnTransID = FSTAdd.ReturnTransID;

                ProcessCreditCard PCC;
                PCC = new ProcessCreditCard(UserID, IPAddress, PatientID, PracticeID, "RepeatSale", "", "", "", "", Amount, ReturnTransID.ToString(""), PNRef, "", "", "", "", MagTek);
                FSPMessage = PCC.FSPMessage;
                FSPAuthRef = PCC.FSPAuthRef;
                FSPStatusID = PCC.FSPStatusID;
                FSPTransStateTypeID = PCC.FSPTransStateTypeID;
                Success = PCC.Success;
                FS_PNRef = PCC.FS_PNRef;

                //Update Transaction Record
                FSTAdd = new TransactionAdd(ReturnTransID, 12, FSPTransStateTypeID, PatientID, PaymentCardID, StatementID, AccountID, PracticeID, IPAddress, FSPMessage, Success, FSPAuthRef, FSPStatusID, Amount, FS_PNRef, UserID, TransactionIDPri, SourceTypeID, ReasonTypeID, Notes, Cycle, NightlyLogID);
                ReturnTransID = FSTAdd.ReturnTransID;
            }
            catch
            {
                throw;
            }

        }
    }
    public class ProcessCreditReturn
    {
        public string FSPMessage { get; set; }
        public string FS_PNRef { get; set; }
        public Boolean Success { get; set; }
        public string FSPAuthRef { get; set; }
        public int FSPStatusID { get; set; }
        public int FSPTransStateTypeID { get; set; }
        public int ReturnTransID { get; set; }
        public ProcessCreditReturn(string Amount, string PNRef, int PatientID, int PaymentCardID, int StatementID, int AccountID, int PracticeID, string IPAddress, int UserID, Nullable<int> TransactionIDPri, int SourceTypeID, int ReasonTypeID, string Notes, Nullable<int> Cycle, Nullable<int> NightlyLogID)
        {
            try
            {
                //Pre-Insert Record
                TransactionAdd FSTAdd;
                FSTAdd = new TransactionAdd(null, 13, null, PatientID, PaymentCardID, StatementID, AccountID, PracticeID, IPAddress, FSPMessage, Success, FSPAuthRef, FSPStatusID, Amount, PNRef, UserID, TransactionIDPri, SourceTypeID, ReasonTypeID, Notes, Cycle, NightlyLogID);
                ReturnTransID = FSTAdd.ReturnTransID;

                ProcessCreditCard PCC;
                PCC = new ProcessCreditCard(UserID, IPAddress, PatientID, PracticeID, "Return", "", "", "", "", Amount, ReturnTransID.ToString(""), PNRef, "", "", "", "");
                FSPMessage = PCC.FSPMessage;
                FSPAuthRef = PCC.FSPAuthRef;
                FSPStatusID = PCC.FSPStatusID;
                FSPTransStateTypeID = PCC.FSPTransStateTypeID;
                Success = PCC.Success;
                FS_PNRef = PCC.FS_PNRef;

                //Update Transaction Record
                FSTAdd = new TransactionAdd(ReturnTransID, 13, FSPTransStateTypeID, PatientID, PaymentCardID, StatementID, AccountID, PracticeID, IPAddress, FSPMessage, Success, FSPAuthRef, FSPStatusID, Amount, FS_PNRef, UserID, TransactionIDPri, SourceTypeID, ReasonTypeID, Notes, Cycle, NightlyLogID);
                ReturnTransID = FSTAdd.ReturnTransID;
            }
            catch
            {
                throw;
            }
        }
    }
    public class ProcessCreditVoid
    {
        public string FSPMessage { get; set; }
        public string FS_PNRef { get; set; }
        public Boolean Success { get; set; }
        public string FSPAuthRef { get; set; }
        public int FSPStatusID { get; set; }
        public int FSPTransStateTypeID { get; set; }
        public int ReturnTransID { get; set; }

        public ProcessCreditVoid(string Amount, string PNRef, int PatientID, int PaymentCardID, int StatementID, int AccountID, int PracticeID, string IPAddress, int UserID, Nullable<int> TransactionIDPri, int SourceTypeID, int ReasonTypeID, string Notes, Nullable<int> Cycle, Nullable<int> NightlyLogID)
        {
            try
            {
                //Pre-Insert Record
                TransactionAdd FSTAdd;
                FSTAdd = new TransactionAdd(null, 14, null, PatientID, PaymentCardID, StatementID, AccountID, PracticeID, IPAddress, FSPMessage, Success, FSPAuthRef, FSPStatusID, Amount, PNRef, UserID, TransactionIDPri, SourceTypeID, ReasonTypeID, Notes, Cycle, NightlyLogID);
                ReturnTransID = FSTAdd.ReturnTransID;

                ProcessCreditCard PCC;
                PCC = new ProcessCreditCard(UserID, IPAddress, PatientID, PracticeID, "Void", null, null, "", "", Amount, ReturnTransID.ToString(""), PNRef, "", "", "", "");
                FSPMessage = PCC.FSPMessage;
                FSPAuthRef = PCC.FSPAuthRef;
                FSPStatusID = PCC.FSPStatusID;
                FSPTransStateTypeID = PCC.FSPTransStateTypeID;
                Success = PCC.Success;
                FS_PNRef = PCC.FS_PNRef;

                //Update Transaction Record
                FSTAdd = new TransactionAdd(ReturnTransID, 14, FSPTransStateTypeID, PatientID, PaymentCardID, StatementID, AccountID, PracticeID, IPAddress, FSPMessage, Success, FSPAuthRef, FSPStatusID, Amount, FS_PNRef, UserID, TransactionIDPri, SourceTypeID, ReasonTypeID, Notes, Cycle, NightlyLogID);
                ReturnTransID = FSTAdd.ReturnTransID;
                //Update Original Transaction's State Type to Voided
                var cmdParams = new Dictionary<string, object>
                                {
                                    {"TransactionID", TransactionIDPri},
                                    {"TransStateTypeID", (Int32)Enums.FSPTransStateTypeID.Voided}
                                };
                SqlHelper.ExecuteScalarProcedureParams("web_pr_transaction_add", cmdParams);
            }
            catch
            {
                throw;
            }
        }
    }

    //    public class ProcessDebitCard
    //    {
    //        public string FSPMessage { get; set; }
    //        public string FS_PNRef { get; set; }
    //        public Boolean Success { get; set; }
    //        public ProcessDebitCard(string FSTranstype, string CardNumberAbbr, string ExpDate, string MagData, string NameOnCard, string Amount, string InvoiceID, string PNRef, string Pin, string RegisterNum, string SureChargeAmt, string CashBackAmt, string ExtData, int PatientID, int PracticeID, string IPAddress, int UserID)
    //        {
    //            try
    //            {
    //                //FrontStream credentials.

    //                var reader = SqlHelper.ExecuteDataTableProcedureParams("sys_FSInfo_get", new Dictionary<string, object> { { "PracticeID", PracticeID } });

    //                string FSUsername = "";
    //                string FSPassword = "";
    //                int FSMerchantID = 0;
    //                int FSPartnerID = 0;
    //                bool FSFlagLive = false;
    //                while (reader.Read())
    //                {
    //                    FSUsername = (string)reader["FSUserName"];
    //                    FSPassword = (string)reader["FSPassword"];
    //                    FSFlagLive = (bool)reader["FSFlagLive"];
    //                    FSMerchantID = (int)reader["FSMerchantID"];
    //                    FSPartnerID = (int)reader["FSPartnerID"];

    //                }
    //                if (FSFlagLive == false)
    //                {
    //                    FSUsername = "fvwd4268";
    //                    FSPassword = "2876";
    //                    FSMerchantID = 285;
    //                    FSPartnerID = 100;
    //                }
    //                reader.Close();

    //                FS_Transact_Prod.SmartPayments Transact_Prod = new FS_Transact_Prod.SmartPayments();
    //                FS_Transact_Prod.Response response_Prod;
    //                FS_Transact_Dev.SmartPayments Transact_Dev = new FS_Transact_Dev.SmartPayments();
    //                FS_Transact_Dev.Response response_Dev;

    //                //FSTranstype = "Sale"; //possible options: Sale, Adjustment, Auth, Return, Void
    //                //CardNumberAbbr = "4788250000028291";
    //                //ExpDate = "0514";
    //                //MagData = ""; //Data located on the track 2 of the magnetic strip of the card. Once this field is populated,
    //                ////the transaction will be indicated as Card-Present transaction and usually result in a more favorable retail
    //                ////discount rate. The format of the MagData (or Track 2 data) is CardNum=ExpDate followed by the service code 
    //                ////and checksum. For example, 36438999960016=05121015432112345678.
    //                NameOnCard = ""; //Optional, depending on different merchant processor setups. The cardholder’s name as it appears on the card. This parameter will remove invalid characters.
    //                //Amount = "5.00";
    //                //InvoiceID = "123456";
    //                //PNRef = ""; //Optional except for these TransType’s: Void, Force (PostAuth), Capture. Reference number assigned by the payment server
    //                //Pin = ""; //Required except for Capture and CaptureAll transactions and PIN-less debit transactions. The encrypted pin block returned by the pin-pad. The transaction will fail if an unencrypted pin value is used
    //                //RegisterNum = ""; //Optional. A number uniquely identifies the register or computer on which the transaction is performed. This parameter will remove invalid characters. See list of Removed Characters for more details
    //                //SureChargeAmt = ""; //Optional. The amount in DDDD.CC format that a merchant charges for processing a debit card transaction
    //                //CashBackAmt = ""; //Optional. The amount in DDDD.CC format that a cardholder requests for cash back
    //                //ExtData = ""; 
    //                /*Optional except in the cases of: AuthCode (required for a Force (ForceAuth) transaction); City and BillToState (required by certain processors); Invoice and
    //                associated nested data elements (required for Concord EFS Purchase Card Level 3 and Fuel purchases- see section below). Extended data in XML format. Valid values are:
    //                • <AuthCode>ApprovalCode</AuthCode> for original authorization code
    //                • <CustCode>CustomerCode</CustCode> for customer code or PO number */

    //                int responseresult;
    //                if (FSFlagLive == true)
    //                {
    //                    response_Prod = Transact_Prod.ProcessDebitCard(FSUsername, FSPassword, FSTranstype, CardNumberAbbr, ExpDate, MagData, NameOnCard, Amount, InvoiceID, PNRef, Pin, RegisterNum, SureChargeAmt, CashBackAmt, ExtData);
    //                    FS_PNRef = response_Prod.PNRef;
    //                    responseresult = response_Prod.Result;
    //                }
    //                else
    //                {
    //                    response_Dev = Transact_Dev.ProcessDebitCard(FSUsername, FSPassword, FSTranstype, CardNumberAbbr, ExpDate, MagData, NameOnCard, Amount, InvoiceID, PNRef, Pin, RegisterNum, SureChargeAmt, CashBackAmt, ExtData);
    //                    FS_PNRef = response_Dev.PNRef;
    //                    responseresult = response_Dev.Result;
    //                }

    //                #region Response Result
    //                switch (responseresult)
    //                {
    //                    case 0:
    //                        Success = true;
    //                        FSPMessage = "success";
    //                        break;
    //                    case 1:
    //                        Success = false;
    //                        FSPMessage = "User Authentication Failed";
    //                        break;
    //                    case 2:
    //                        Success = false;
    //                        FSPMessage = "Invalid Transaction";
    //                        break;
    //                    case 3:
    //                        Success = false;
    //                        FSPMessage = "Invalid Transaction Type";
    //                        break;
    //                    case 4:
    //                        Success = false;
    //                        FSPMessage = "Invalid Amount 5 Invalid Merchant Information";
    //                        break;
    //                    case 8:
    //                        Success = false;
    //                        FSPMessage = "Not a Transaction Server ";
    //                        break;
    //                    case 9:
    //                        Success = false;
    //                        FSPMessage = "Invalid Parameter Stream";
    //                        break;
    //                    case 10:
    //                        Success = false;
    //                        FSPMessage = "Too Many Line Items";
    //                        break;
    //                    case 11:
    //                        Success = false;
    //                        FSPMessage = "Client Timeout Waiting for Response";
    //                        break;
    //                    case 12:
    //                        Success = false;
    //                        FSPMessage = "Decline";
    //                        break;
    //                    case 13:
    //                        Success = false;
    //                        FSPMessage = "Referral";
    //                        break;
    //                    case 14:
    //                        Success = false;
    //                        FSPMessage = "Transaction Type Not Supported In This Version";
    //                        break;
    //                    case 19:
    //                        Success = false;
    //                        FSPMessage = "Original Transaction ID Not Found";
    //                        break;
    //                    case 20:
    //                        Success = false;
    //                        FSPMessage = "Customer Reference Number Not Found ";
    //                        break;
    //                    case 22:
    //                        Success = false;
    //                        FSPMessage = "Invalid ABA Number";
    //                        break;
    //                    case 23:
    //                        Success = false;
    //                        FSPMessage = "Invalid Account Numbe";
    //                        break;
    //                    case 24:
    //                        Success = false;
    //                        FSPMessage = "Invalid Expiration Date";
    //                        break;
    //                    case 25:
    //                        Success = false;
    //                        FSPMessage = "Transaction Type Not Supported by Host";
    //                        break;
    //                    case 26:
    //                        Success = false;
    //                        FSPMessage = "Invalid Reference Number";
    //                        break;
    //                    case 27:
    //                        Success = false;
    //                        FSPMessage = "Invalid Receipt Information";
    //                        break;
    //                    case 28:
    //                        Success = false;
    //                        FSPMessage = "Invalid Check Holder Name";
    //                        break;
    //                    case 29:
    //                        Success = false;
    //                        FSPMessage = "Invalid Check Number";
    //                        break;
    //                    case 30:
    //                        Success = false;
    //                        FSPMessage = "Check DL Verification Requires DL State";
    //                        break;
    //                    case 40:
    //                        Success = false;
    //                        FSPMessage = "Transaction did not connect (to NCN because SecureNCIS is not running on the web server)";
    //                        break;
    //                    case 50:
    //                        Success = false;
    //                        FSPMessage = "Insufficient Funds Available";
    //                        break;
    //                    case 99:
    //                        Success = false;
    //                        FSPMessage = "General Error";
    //                        break;
    //                    case 100:
    //                        Success = false;
    //                        FSPMessage = "Invalid Transaction Returned from Host";
    //                        break;
    //                    case 101:
    //                        Success = false;
    //                        FSPMessage = "Timeout Value too Small or Invalid Time Out Value";
    //                        break;
    //                    case 102:
    //                        Success = false;
    //                        FSPMessage = "Processor Not Available";
    //                        break;
    //                    case 103:
    //                        Success = false;
    //                        FSPMessage = "Error Reading Response from Host";
    //                        break;
    //                    case 104:
    //                        Success = false;
    //                        FSPMessage = "Timeout waiting for Processor Response";
    //                        break;
    //                    case 105:
    //                        Success = false;
    //                        FSPMessage = "Credit Error";
    //                        break;
    //                    case 106:
    //                        Success = false;
    //                        FSPMessage = "Host Not Available";
    //                        break;
    //                    case 107:
    //                        Success = false;
    //                        FSPMessage = "Duplicate Suppression Timeout 108 Void Error";
    //                        break;
    //                    case 109:
    //                        Success = false;
    //                        FSPMessage = "Timeout Waiting for Host Response";
    //                        break;
    //                    case 110:
    //                        Success = false;
    //                        FSPMessage = "Duplicate Transaction";
    //                        break;
    //                    case 111:
    //                        Success = false;
    //                        FSPMessage = "Capture Error";
    //                        break;
    //                    case 112:
    //                        Success = false;
    //                        FSPMessage = "Failed AVS Check";
    //                        break;
    //                    case 113:
    //                        Success = false;
    //                        FSPMessage = "Cannot Exceed Sales Cap";
    //                        break;
    //                    case 1000:
    //                        Success = false;
    //                        FSPMessage = "Generic Host Error";
    //                        break;
    //                    case 1001:
    //                        Success = false;
    //                        FSPMessage = "Invalid Login";
    //                        break;
    //                    case 1002:
    //                        Success = false;
    //                        FSPMessage = "Insufficient Privilege or Invalid Amount";
    //                        break;
    //                    case 1003:
    //                        Success = false;
    //                        FSPMessage = "Invalid Login Blocked";
    //                        break;
    //                    case 1004:
    //                        Success = false;
    //                        FSPMessage = "Invalid Login Deactivated";
    //                        break;
    //                    case 1005:
    //                        Success = false;
    //                        FSPMessage = "Transaction Type Not Allowed";
    //                        break;
    //                    case 1006:
    //                        Success = false;
    //                        FSPMessage = "Unsupported Processor";
    //                        break;
    //                    case 1007:
    //                        Success = false;
    //                        FSPMessage = "Invalid Request Message";
    //                        break;
    //                    case 1008:
    //                        Success = false;
    //                        FSPMessage = "Invalid Version";
    //                        break;
    //                    case 1010:
    //                        Success = false;
    //                        FSPMessage = "Payment Type Not Supported";
    //                        break;
    //                    case 1011:
    //                        Success = false;
    //                        FSPMessage = "Error Starting Transaction";
    //                        break;
    //                    case 1012:
    //                        Success = false;
    //                        FSPMessage = "Error Finishing Transaction";
    //                        break;
    //                    case 1013:
    //                        Success = false;
    //                        FSPMessage = "Error Checking Duplicate";
    //                        break;
    //                    case 1014:
    //                        Success = false;
    //                        FSPMessage = "No Records To Settle (in the current batch)";
    //                        break;
    //                    case 1015:
    //                        Success = false;
    //                        FSPMessage = "No Records To Process (in the current batch)";
    //                        break;
    //                    default:
    //                        FSPMessage = "Unknown error";
    //                        Success = false;
    //                        break;
    //                }
    //#endregion
    //            }
    //            catch (Exception ex)
    //            {
    //                Success = false;
    //                FSPMessage = ex.Message;
    //                throw;
    //            }
    //        }
    //    }

    public class ValidCheck
    {
        public string FSPMessage { get; set; }
        public string PNRef { get; set; }
        public Boolean Success { get; set; }
        public int FSPStatusID { get; set; }
        public int FSPTransStateTypeID { get; set; }
        public int ReturnTransID { get; set; }

        public ValidCheck(string TransitNum, string AccountNum, string NameOnCheck, string AccountType, int PatientID, int PaymentCardID, int AccountID, int PracticeID, string IPAddress, int UserID, string ACH_Payment_Type = "WEB")
        {

            try
            {
                //Pre-Insert Record
                string amount;
                amount = "0.00"; //$0 are not processed at batch time.
                TransactionAdd FSTAdd;
                FSTAdd = new TransactionAdd(null, (Int32)Enums.TransactionTypeID.ValidateCheck, null, PatientID, PaymentCardID, 0, AccountID, PracticeID, IPAddress, FSPMessage, Success, null, FSPStatusID, null, PNRef, UserID, null, null, null, null, null, null);
                ReturnTransID = FSTAdd.ReturnTransID;

                ProcessCheck PC;
                PC = new ProcessCheck(UserID, IPAddress, PatientID, PracticeID, "Sale", "", TransitNum, AccountNum, amount, "", NameOnCheck, "", "", "", "", "", ReturnTransID.ToString(""), "", "<AccountType>" + AccountType + "</AccountType>", ACH_Payment_Type);
                FSPMessage = PC.FSPMessage;
                Success = PC.Success;
                PNRef = PC.FS_PNRef;
                FSPStatusID = PC.FSPStatusID;
                FSPTransStateTypeID = PC.FSPTransStateTypeID;

                //Update Transaction Record
                FSTAdd = new TransactionAdd(ReturnTransID, (Int32)Enums.TransactionTypeID.ValidateCheck, FSPTransStateTypeID, PatientID, PaymentCardID, 0, AccountID, PracticeID, IPAddress, FSPMessage, Success, null, FSPStatusID, null, PNRef, UserID, null, null, null, null, null, null);
                ReturnTransID = FSTAdd.ReturnTransID;
            }
            catch
            {
                throw;
            }

        }
    }

    public class ProcessCheck
    {
        public string FSPMessage { get; set; }
        public string FS_PNRef { get; set; }
        public Boolean Success { get; set; }
        public int FSPStatusID { get; set; }
        public int FSPTransStateTypeID { get; set; }

        public ProcessCheck(int UserID, string IPAddress, int PatientID, int PracticeID, string FSTranstype, string CheckNum, string TransitNum, string AccountNum, string Amount, string MICR, string NameOnCheck, string DL, string SS, string DoB, string StateCode, string CheckType, string InvoiceID, string PNRef, string ExtData, string ACH_Payment_Type = "WEB")
        {

            try
            {
                //FrontStream credentials.

                var reader = SqlHelper.ExecuteDataTableProcedureParams("sys_FSInfo_get", new Dictionary<string, object> { { "PracticeID", PracticeID } });

                CheckNum = "";
                string FSUsername = "";
                string FSPassword = "";
                int FSMerchantID = 0;
                int FSPartnerID = 0;
                bool FSFlagLive = false;
                foreach (DataRow row in reader.Rows)
                {
                    FSFlagLive = (bool)row["FSFlagLive"];
                    if (FSFlagLive == true)
                    {
                        FSPartnerID = (int)row["FSPartnerID"];
                        FSMerchantID = (int)row["FSMerchantID"];
                        FSUsername = CryptorEngine.Decrypt((string)row["FSUserName"]);
                        FSPassword = CryptorEngine.Decrypt((string)row["FSPassword"]);
                    }
                    else
                    {
                        FSPartnerID = (int)row["FSDevPartnerID"];
                        FSMerchantID = (int)row["FSDevMerchantID"];
                        FSUsername = CryptorEngine.Decrypt((string)row["FSDevUsername"]);
                        FSPassword = CryptorEngine.Decrypt((string)row["FSDevPassword"]);
                    }
                }

                FS_Transact_Prod.SmartPayments Transact_Prod = new FS_Transact_Prod.SmartPayments();
                FS_Transact_Prod.Response response_Prod;
                FS_Transact_Dev.SmartPayments Transact_Dev = new FS_Transact_Dev.SmartPayments();
                FS_Transact_Dev.Response response_Dev;
                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12; //New Standard for PCI Compliance

                //FSTranstype = "Sale"; //possible options: Sale, Auth, Return, Void, RepeatSale
                //CheckNum = ""; //Required except for these TransType’s: Void, Capture, CaptureAll. Check number uniquely identifies each individual check
                //TransitNum = "0514"; //Required except for these TransType’s: Void, Capture, CaptureAll. Transit number uniquely identifies a bank routing number
                //AccountNum = ""; //Required except for these TransType’s: Void, Capture, CaptureAll. Account number uniquely identifies a check holder’s bank account number Amount Required
                //Amount = "5.00";
                //MICR = ""; //Optional. The Magnetic Ink Check Reader data line, which includes TransitNum, and AccountNum. Required for processing Check-Present transactions
                //NameOnCheck=""; //Required except for these TransType’s: Void, Capture, CaptureAll. The check holder’s name as it appears on the check. The parameter may be required, depending on the merchant’s processor setup. This parameter will remove invalid characters.
                //DL=""; //Optional. The check holder’s driver’s license number. This parameter will remove invalid characters.
                //SS=""; //Optional. The check holder’s Social Security Number. This parameter will remove invalid characters.
                //DoB="";
                //StateCode = ""; //Optional. The check holder’s 2 character state code. The parameter may be required depending on the merchant’s processor setup. This parameter will remove invalid characters.
                //CheckType=""; //Optional. The type of the check. Valid values are: • Personal • Corporate • Government
                //InvoiceID = "123456";
                //PNRef = ""; //Optional except for these TransType’s: Void, Force (PostAuth), Capture. Reference number assigned by the payment server
                //ExtData = ""; //These tags may be required for Sale and Return transactions depending on the merchant’s processor setup: CityOfAccount, BillToStreet, and BillToPostalCode. Required tag for Return, Void, Force, and Capture transactions is: PNRef.

                ExtData = "<ACH_Payment_Type>" + ACH_Payment_Type + "</ACH_Payment_Type>" + ExtData;

                //InvoiceID, PNRef
                if (PNRef != "" && PNRef != null)
                {
                    ExtData = "<PNRef>" + PNRef + "</PNRef>" + ExtData;
                }
                if (InvoiceID != "" && InvoiceID != null)
                {
                    ExtData = "<InvNum>" + InvoiceID + "</InvNum>" + ExtData;
                    ExtData = "<TransactionID>" + InvoiceID + "</TransactionID>" + ExtData;
                }

                int responseresult;
                if (FSFlagLive == true)
                {
                    response_Prod = Transact_Prod.ProcessCheck(FSUsername, FSPassword, FSTranstype, CheckNum, TransitNum, AccountNum, Amount, MICR, NameOnCheck, DL, SS, DoB, StateCode, CheckType, ExtData);
                    FS_PNRef = response_Prod.PNRef;
                    FSPStatusID = response_Prod.Result;
                    responseresult = response_Prod.Result;
                }
                else
                {
                    response_Dev = Transact_Dev.ProcessCheck(FSUsername, FSPassword, FSTranstype, CheckNum, TransitNum, AccountNum, Amount, MICR, NameOnCheck, DL, SS, DoB, StateCode, CheckType, ExtData);
                    FS_PNRef = response_Dev.PNRef;
                    FSPStatusID = response_Dev.Result;
                    responseresult = response_Dev.Result;
                }
                #region ResponseResult
                switch (responseresult)
                {
                    case 0:
                        Success = true;
                        FSPMessage = "Success";
                        if (FSTranstype == "Void")
                            FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Voided;
                        else
                            FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Scheduled;
                        break;
                    case 1:
                        Success = false;
                        FSPMessage = "User Authentication Failed";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 2:
                        Success = false;
                        FSPMessage = "Invalid Transaction";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 3:
                        Success = false;
                        FSPMessage = "Invalid Transaction Type";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 4:
                        Success = false;
                        FSPMessage = "Invalid Amount";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 5:
                        Success = false;
                        FSPMessage = "Invalid Merchant Information";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 7:
                        Success = false;
                        FSPMessage = "Field Format Error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 8:
                        Success = false;
                        FSPMessage = "Not a Transaction Server ";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 9:
                        Success = false;
                        FSPMessage = "Invalid Parameter Stream";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 10:
                        Success = false;
                        FSPMessage = "Too Many Line Items";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 11:
                        Success = false;
                        FSPMessage = "Client Timeout Waiting for Response";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 12:
                        Success = false;
                        FSPMessage = "Decline";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Declined;
                        break;
                    case 13:
                        Success = false;
                        FSPMessage = "Referral";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Referred;
                        break;
                    case 14:
                        Success = false;
                        FSPMessage = "Transaction Type Not Supported In This Version";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 19:
                        Success = false;
                        FSPMessage = "Original Transaction ID Not Found";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 20:
                        Success = false;
                        FSPMessage = "Customer Reference Number Not Found ";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 22:
                        Success = false;
                        FSPMessage = "Invalid ABA Number";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 23:
                        Success = false;
                        FSPMessage = "Invalid Account Number";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 24:
                        Success = false;
                        FSPMessage = "Invalid Expiration Date";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 25:
                        Success = false;
                        FSPMessage = "Transaction Type Not Supported by Host";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 26:
                        Success = false;
                        FSPMessage = "Invalid Reference Number";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 27:
                        Success = false;
                        FSPMessage = "Invalid Receipt Information";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 28:
                        Success = false;
                        FSPMessage = "Invalid Check Holder Name";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 29:
                        Success = false;
                        FSPMessage = "Invalid Check Number";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 30:
                        Success = false;
                        FSPMessage = "Check DL Verification Requires DL State";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 40:
                        Success = false;
                        FSPMessage = "Transaction did not connect (to NCN because SecureNCIS is not running on the web server)";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 50:
                        Success = false;
                        FSPMessage = "Insufficient Funds Available";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Returned;
                        break;
                    case 99:
                        Success = false;
                        FSPMessage = "General Error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 100:
                        Success = false;
                        FSPMessage = "Invalid Transaction Returned from Host";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 101:
                        Success = false;
                        FSPMessage = "Timeout Value too Small or Invalid Time Out Value";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 102:
                        Success = false;
                        FSPMessage = "Processor Not Available";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 103:
                        Success = false;
                        FSPMessage = "Error Reading Response from Host";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 104:
                        Success = false;
                        FSPMessage = "Timeout waiting for Processor Response";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 105:
                        Success = false;
                        FSPMessage = "Credit Error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 106:
                        Success = false;
                        FSPMessage = "Host Not Available";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 107:
                        Success = false;
                        FSPMessage = "Duplicate Suppression Timeout";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 108:
                        Success = false;
                        FSPMessage = "Void Error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 109:
                        Success = false;
                        FSPMessage = "Timeout Waiting for Host Response";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 110:
                        //Success = true;
                        //FSPMessage = "Success";
                        Success = false;
                        FSPMessage = "Duplicate Transaction";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 111:
                        Success = false;
                        FSPMessage = "Capture Error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 112:
                        Success = false;
                        FSPMessage = "Failed AVS Check";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 113:
                        Success = false;
                        FSPMessage = "Cannot Exceed Sales Cap";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 1000:
                        Success = false;
                        FSPMessage = "Generic Host Error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1001:
                        Success = false;
                        FSPMessage = "Invalid Login";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1002:
                        Success = false;
                        FSPMessage = "Insufficient Privilege or Invalid Amount";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1003:
                        Success = false;
                        FSPMessage = "Invalid Login Blocked";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1004:
                        Success = false;
                        FSPMessage = "Invalid Login Deactivated";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1005:
                        Success = false;
                        FSPMessage = "Transaction Type Not Allowed";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Invalid;
                        break;
                    case 1006:
                        Success = false;
                        FSPMessage = "Unsupported Processor";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1007:
                        Success = false;
                        FSPMessage = "Invalid Request Message";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1008:
                        Success = false;
                        FSPMessage = "Invalid Version";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1010:
                        Success = false;
                        FSPMessage = "Payment Type Not Supported";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1011:
                        Success = false;
                        FSPMessage = "Error Starting Transaction";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1012:
                        Success = false;
                        FSPMessage = "Error Finishing Transaction";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1013:
                        Success = false;
                        FSPMessage = "Error Checking Duplicate";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1014:
                        Success = false;
                        FSPMessage = "No Records To Settle (in the current batch)";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    case 1015:
                        Success = false;
                        FSPMessage = "No Records To Process (in the current batch)";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                    default:
                        Success = false;
                        FSPMessage = "Unknown error";
                        FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                        break;
                }
                #endregion
            }
            catch (Exception ex)
            {
                Success = false;
                FSPMessage = "Unknown error";
                FSPTransStateTypeID = (Int32)Enums.FSPTransStateTypeID.Failed;
                var sqlData = SqlHelper.GetSqlData(ex.Data);
                EmailServices.SendRunTimeErrorEmail("FrontStreamPayments Run Time Error: " + ex.HelpLink, ex.GetType().ToString(), ex.Message, ex.StackTrace, "", "N/A", "N/A", "N/A", "N/A", UserID, PatientID, PracticeID, IPAddress.ToString(), sqlData);
            }
        }
    }
    public class ProcessCheckSale
    {
        public string FSPMessage { get; set; }
        public string FS_PNRef { get; set; }
        public Boolean Success { get; set; }
        public int FSPStatusID { get; set; }
        public int FSPTransStateTypeID { get; set; }
        public int ReturnTransID { get; set; }

        public ProcessCheckSale(string Amount, string PNRef, int PatientID, int PaymentCardID, int StatementID, int AccountID, int PracticeID, string IPAddress, int UserID, Nullable<int> TransactionIDPri, int SourceTypeID, int ReasonTypeID, string Notes, Nullable<int> Cycle, Nullable<int> NightlyLogID, string ACH_Payment_Type = "WEB")
        {
            try
            {
                //Pre-Insert Record
                TransactionAdd FSTAdd;
                FSTAdd = new TransactionAdd(null, 22, null, PatientID, PaymentCardID, StatementID, AccountID, PracticeID, IPAddress, FSPMessage, Success, null, FSPStatusID, Amount, PNRef, UserID, TransactionIDPri, SourceTypeID, ReasonTypeID, Notes, Cycle, NightlyLogID);
                ReturnTransID = FSTAdd.ReturnTransID;

                ProcessCheck PC;
                PC = new ProcessCheck(UserID, IPAddress, PatientID, PracticeID, "RepeatSale", "", "", "", Amount, "", "", "", "", "", "", "", ReturnTransID.ToString(""), PNRef, "");
                FSPMessage = PC.FSPMessage;
                Success = PC.Success;
                FS_PNRef = PC.FS_PNRef;
                FSPStatusID = PC.FSPStatusID;
                FSPTransStateTypeID = PC.FSPTransStateTypeID;

                //Update Transaction Record
                FSTAdd = new TransactionAdd(ReturnTransID, 22, FSPTransStateTypeID, PatientID, PaymentCardID, StatementID, AccountID, PracticeID, IPAddress, FSPMessage, Success, null, FSPStatusID, Amount, FS_PNRef, UserID, TransactionIDPri, SourceTypeID, ReasonTypeID, Notes, Cycle, NightlyLogID);
                ReturnTransID = FSTAdd.ReturnTransID;
            }
            catch
            {
                throw;
            }
        }
    }
    public class ProcessCheckReturn
    {
        public string FSPMessage { get; set; }
        public string FS_PNRef { get; set; }
        public Boolean Success { get; set; }
        public int FSPStatusID { get; set; }
        public int FSPTransStateTypeID { get; set; }
        public int ReturnTransID { get; set; }

        public ProcessCheckReturn(string Amount, string PNRef, int PatientID, int PaymentCardID, int StatementID, int AccountID, int PracticeID, string IPAddress, int UserID, Nullable<int> TransactionIDPri, int SourceTypeID, int ReasonTypeID, string Notes, Nullable<int> Cycle, Nullable<int> NightlyLogID, string ACH_Payment_Type = "PPD")
        {
            try
            {
                //Pre-Insert Record
                TransactionAdd FSTAdd;
                FSTAdd = new TransactionAdd(null, 23, null, PatientID, PaymentCardID, StatementID, AccountID, PracticeID, IPAddress, FSPMessage, Success, null, FSPStatusID, Amount, PNRef, UserID, TransactionIDPri, SourceTypeID, ReasonTypeID, Notes, Cycle, NightlyLogID);
                ReturnTransID = FSTAdd.ReturnTransID;

                ProcessCheck PC;
                PC = new ProcessCheck(UserID, IPAddress, PatientID, PracticeID, "Return", "", "", "", Amount, "", "", "", "", "", "", "", ReturnTransID.ToString(""), PNRef, "");
                FSPMessage = PC.FSPMessage;
                Success = PC.Success;
                FS_PNRef = PC.FS_PNRef;
                FSPStatusID = PC.FSPStatusID;
                FSPTransStateTypeID = PC.FSPTransStateTypeID;

                //Update Transaction Record
                FSTAdd = new TransactionAdd(ReturnTransID, 23, FSPTransStateTypeID, PatientID, PaymentCardID, StatementID, AccountID, PracticeID, IPAddress, FSPMessage, Success, null, FSPStatusID, Amount, FS_PNRef, UserID, TransactionIDPri, SourceTypeID, ReasonTypeID, Notes, Cycle, NightlyLogID);
                ReturnTransID = FSTAdd.ReturnTransID;
            }
            catch
            {
                throw;
            }
        }
    }
    public class ProcessCheckVoid
    {
        public string FSPMessage { get; set; }
        public string FS_PNRef { get; set; }
        public Boolean Success { get; set; }
        public int FSPStatusID { get; set; }
        public int FSPTransStateTypeID { get; set; }
        public int ReturnTransID { get; set; }

        public ProcessCheckVoid(string Amount, string PNRef, int PatientID, int PaymentCardID, int StatementID, int AccountID, int PracticeID, string IPAddress, int UserID, Nullable<int> TransactionIDPri, int SourceTypeID, int ReasonTypeID, string Notes, Nullable<int> Cycle, Nullable<int> NightlyLogID, string ACH_Payment_Type = "WEB")
        {
            try
            {
                //Pre-Insert Record
                TransactionAdd FSTAdd;
                FSTAdd = new TransactionAdd(null, 24, null, PatientID, PaymentCardID, StatementID, AccountID, PracticeID, IPAddress, FSPMessage, Success, null, FSPStatusID, Amount, PNRef, UserID, TransactionIDPri, SourceTypeID, ReasonTypeID, Notes, Cycle, NightlyLogID);
                ReturnTransID = FSTAdd.ReturnTransID;

                ProcessCheck PC;
                PC = new ProcessCheck(UserID, IPAddress, PatientID, PracticeID, "Void", "", "", "", Amount, "", "", "", "", "", "", "", ReturnTransID.ToString(""), PNRef, "");
                FSPMessage = PC.FSPMessage;
                Success = PC.Success;
                FS_PNRef = PC.FS_PNRef;
                FSPStatusID = PC.FSPStatusID;
                FSPTransStateTypeID = PC.FSPTransStateTypeID;

                //Update Transaction Record
                FSTAdd = new TransactionAdd(ReturnTransID, 24, FSPTransStateTypeID, PatientID, PaymentCardID, StatementID, AccountID, PracticeID, IPAddress, FSPMessage, Success, null, FSPStatusID, Amount, FS_PNRef, UserID, TransactionIDPri, SourceTypeID, ReasonTypeID, Notes, Cycle, NightlyLogID);
                ReturnTransID = FSTAdd.ReturnTransID;
                //Update Original Transaction's State Type to Voided
                var cmdParams = new Dictionary<string, object>
                                {
                                    {"TransactionID", TransactionIDPri},
                                    {"TransStateTypeID", (Int32)Enums.FSPTransStateTypeID.Voided}
                                };
                SqlHelper.ExecuteScalarProcedureParams("web_pr_transaction_add", cmdParams);
            }
            catch
            {
                throw;
            }


        }
    }

    public class GetOpenBatchSummary
    {
        public string FSPMessage { get; set; }
        public string response { get; set; }
        //public string FS_PNRef { get; set; }
        //public Boolean Success { get; set; }
        //public int FSPStatusID { get; set; }

        public GetOpenBatchSummary(int PracticeID, DateTime BeginDt, DateTime EndDt)
        {
            try
            {
                //FrontStream credentials.
                var reader = SqlHelper.ExecuteDataTableProcedureParams("sys_FSInfo_get", new Dictionary<string, object> { { "PracticeID", PracticeID } });

                string FSUsername = "";
                string FSPassword = "";
                int FSMerchantID = 0;
                int FSPartnerID = 0;
                bool FSFlagLive = false;
                foreach (DataRow row in reader.Rows)
                {
                    FSFlagLive = (bool)row["FSFlagLive"];
                    if (FSFlagLive == true)
                    {
                        FSPartnerID = (int)row["FSPartnerID"];
                        FSMerchantID = (int)row["FSMerchantID"];
                        FSUsername = CryptorEngine.Decrypt((string)row["FSUserName"]);
                        FSPassword = CryptorEngine.Decrypt((string)row["FSPassword"]);
                    }
                    else
                    {
                        FSPartnerID = (int)row["FSDevPartnerID"];
                        FSMerchantID = (int)row["FSDevMerchantID"];
                        FSUsername = CryptorEngine.Decrypt((string)row["FSDevUsername"]);
                        FSPassword = CryptorEngine.Decrypt((string)row["FSDevPassword"]);
                    }
                }

                FS_TrxDetail_Prod.TrxDetail TrxDetail_Prod = new FS_TrxDetail_Prod.TrxDetail();
                //FS_TrxDetail_Prod.Response response_Prod;
                FS_TrxDetail_Dev.TrxDetail TrxDetail_Dev = new FS_TrxDetail_Dev.TrxDetail();
                //FS_TrxDetail_Dev.Response response_Dev;
                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12; //New Standard for PCI Compliance

                //UserName	Required: User Name
                //Password	Required: Password
                //RPNum	Required: The merchant's RP Number, the query will be run against this merchant's account.
                //BeginDt	Optional query field: The begin date of the date range in MM/DD/YYYY format. This date will be converted to MM/DD/YYYYT00:00:00:0000AM
                //EndDt	Optional query field: The end date of the date range in MM/DD/YYYY format. This date will be converted to MM/DD/YYYYT12:59:59:9999PM
                //ExtData	Optional: Extended Data in XML

                if (FSFlagLive == true)
                {
                    response = TrxDetail_Prod.GetOpenBatchSummary(FSUsername, FSPassword, FSMerchantID.ToString(), BeginDt.ToString("MM/dd/yyyy"), EndDt.ToString("MM/dd/yyyy"), "");
                }
                else
                {
                    response = TrxDetail_Dev.GetOpenBatchSummary(FSUsername, FSPassword, FSMerchantID.ToString(), BeginDt.ToString("MM/dd/yyyy"), EndDt.ToString("MM/dd/yyyy"), "");
                }
            }
            catch
            {
                throw;
            }
        }
    }
    public class GetCardTrx
    {
        public Boolean Success { get; set; }
        public string response { get; set; }

        public GetCardTrx(int PracticeID, bool FSFlagLive, string PNRef, DateTime BeginDt, DateTime EndDt, bool ExcludeVoid, string PaymentType, string ExcludePaymentType, string TransType, string ExcludeTransType, string ApprovalCode, string Result, string ExcludeResult, string NameOnCard, string CardNum, string CardType, string ExcludeCardType, string User, string InvoiceID, string SettleFlag, string SettleMsg, string SettleDt, string TransformType, string Amount)
        {
            try
            {
                //Optional Parameters

                #region ParameterDescription
                /*
                Parameter   Description 
                UserName:   Required. User name assigned in the payment server 
                Password:   Required. Password for the user name assigned in the payment server 
                RPNum:      Required. The merchant's RP Number in order to uniquely identify merchant's account for the query 
                PNRef:      Optional. The unique payment reference number assigned to the transaction. If this field is provided, all other query fields will be ignored when using PNRef parameter to query the system.
                BeginDt:    Required, except when PNRef is provided. The begin date of the date range in MM/DD/YYYY (or YYYY-MM-DD or YYYY-MM-DDThh:mm:ss) format. This date will be converted to YYYY-MM-DDThh:mm:ss (time is in 24-hour format). If the passed-in BeginDt does not contain time information, BeginDt will default to midnight on the given date. For 
                EndDt:      Required, except when PNRef is provided. The end date of the date range in MM/DD/YYYY (or YYYY-MM-DD or YYYY-MM-DDThh:mm:ss) format. This date will be converted to YYYY-MM-DDThh:mm:ss (time is in 24-hour format). If the passed-in EndDt does not contain time information, EndDt will be incremented to the next day at midnight such that no transaction on the desired end date will be excluded based on its time. 
                PaymentType:Optional. If provided, only those transactions matching the PaymentType will be included. 
                    Valid values are: • 'AMEX' American Express card
                    • 'CARTBLANCH' Carte Blanch card
                    • 'DEBIT' Debit card
                    • 'DINERS' Diners Club card
                    • 'DISCOVER' Novus Discover card
                    • 'EBT' Electronic Benefit Transfer
                    • 'JAL' JAL card
                    • 'JCB' Japanese Commercial Bank card
                    • 'MASTERCARD' Master card
                    • 'VISA' Visa card 
                    • ‘EGC’ Gift card 
                    • 'PAYRECEIPT' to retrieve receipt images that were uploaded to the payment server
                    • 'SETTLE' to retrieve requests to settle transactions
                    Or any permutation of the above values, e.g. "'PAYRECEIPT','SETTLE'" will pull all transactions with either PayReceipt or Settle payment types. 
            
                ExcludePaymentType Optional. If provided, any transaction matching the ExcludePaymentType will be excluded 
                TransType:  Optional. If provided, only those transactions matching the TransType will be included. Valid values are 
                    • 'Authorization' to retrieve previously-authorized (pre-auth) 
                    transactions
                    • 'Capture' to retrieve captured transactions
                    • 'Credit' to retrieve return transactions
                    • 'ForceCapture' to retrieve force-auth transactions 
                    • 'GetStatus' to make an inquiry to the EBT or gift card’s balance
                    • 'PostAuth' to retrieve post-auth transactions
                    • 'Purged' to remove a transaction from the current batch due to 
                    an error 
                    • 'Receipt' to retrieve receipt images that were uploaded to the 
                    payment server
                    • 'RepeatSale' to retrieve repeat-sale transactions
                    • 'Sale' to retrieve sale transactions
                    • 'Void' to retrieve void transactions
                    Or any permutation of the above values, e.g. "'Credit','Sale'" will pull all  transactions with either Credit or Sale transaction types. 
            
                ExcludeTransType: Optional. If provided, any transaction matching the ExcludeTransType will be excluded ApprovalCode Optional. If provided, only those transactions matching the ApprovalCode parameter will be included 
                Result:     Optional. If provided, only those transactions matching the Result will be included. Valid values are: 
                    • 0 is Approved 
                    • Anything else is declined; if you want all the declined transactions, you should leave this field empty and use the ExcludeResult=0 instead. 
                ExcludeResult:  Optional. If provided, any transactions matching the ExcludeResult will be excluded. 
                NameOnCard: Optional. Cardholder’s name as it is appears on the card. If provided, only those transactions with cardholder’s name matching NameOnCard will be included. Matching is done using wild cards: e.g. "test" will match "test", "1test" and "1test234" 
                CardNum:    Optional. A card number. If provided, only those transactions with the cardholder's name matching CardNum will be included. Matching is done using wild cards 
                CardType:
                    If provided, only those transactions matching the CardType will be 
                    included. Valid values are: 
                    • 'AMEX' American Express card
                    • 'CARTBLANCH' Carte Blanch card
                    • 'DEBIT' Debit card
                    • 'DINERS' Diners Club card
                    • 'DISCOVER' Novus Discover card
                    • 'EBT' Electronic Benefit Transfer
                    • 'JAL' JAL card
                    • 'JCB' Japanese Commercial Bank card
                    • 'MASTERCARD' Master card
                    • 'VISA' Visa card 
                    • ‘EGC’ Gift card 
                    Or any permutation of the above values, "'VISA','MASTER','DISCOVER'" will pull all transactions with either VISA, MASTER and DISCOVER card type. There are cases when Cardtype needs to be set to ALL, for example CardType=ALL 
            
                ExcludeCardType Optional. If provided, any transaction matching the ExcludeCardType will be excluded 
                ExcludeVoid: Required, except when PNRef is provided. An option to exclude voided transactions or not; must either be TRUE or FALSE
                User: Optional. The user who originated the transactions. If provided, only those transactions created by the matching User will be included. Matching is done using wild cards 
                InvoiceId: Optional. The invoice ID that was included in the original transaction. If provided, only those transactions with matching invoiceId will be included. Matching is done using wild cards 
                SettleFlag: Optional. An option to retrieve the settled transactions or unsettled transactions; must either be 1 for true or 0 for false 
                SettleMsg Optional. The settlement ID or message returned from the host 
                SettleDt Optional. The date of the settlement TransformType Optional. The type of format to transform the data into. Leave the field blank to default to XML
                    • XML will output the plain XML string 
                    • XSL will use XSL to transform the XML output 
                    • DELIM uses ColDelim and RowDelim to format the output 
                    Xsl 
                    Optional. This field is used only if the TransformType is XSL. The XSL to transform the resulting dataset. If provided, the resulting dataset will be transformed using this XSL. You may pass in a URL to the XSL file, or the XSL string itself. If this field is not empty, the Web Services will try to locate the file from the URL. If that also fails, it will treat it as an XSL string. In any case, the final XSL string will be loaded and validated against the XSL schema; if it passes, then that XSL will be used for transformation. A sample predefined XSL is included with this Web Services: 
                    • https://secure.ftipgw.com/admin/ws/TabDelim.xsl for a tab delimited transformation
                ColDelim Optional. This field is used only if the TransformType is DELIM. This defines the string that separates each column 
                RowDelim Optional. This field is used only if the TransformType is DELIM. This defines the string that separates each row IncludeHeader Optional. This field is used only if the TransformType is DELIM. If TRUE, then field headers will be included in the first row using the same delimiter strings; must either be TRUE or FALSE
                ExtData 
                    Optional. Extended data in XML format. Valid values are: 
                    • <IMAGE_TYPE>NO_IMAGE</IMAGE_TYPE> for no image 
                    • <IMAGE_TYPE>ONLY_IMAGE</IMAGE_TYPE> for only the image 
                    • <IMAGE_TYPE>ALL</IMAGE_TYPE> for all images 
                    • <CustomerID>CustomerID</CustomerID> for customer ID 
                    • <Amount>Amount</Amount> Total amount to search transactions for in DDDD.CC format. 
                    • <RegisterNum>RegisterNum</RegisterNum> Register number, originally passed with the transaction, to search transactions for.
                */
                #endregion

                //FrontStream credentials.

                var reader = SqlHelper.ExecuteDataTableProcedureParams("sys_FSInfo_get", new Dictionary<string, object> { { "PracticeID", PracticeID } });

                string FSUsername = "";
                string FSPassword = "";
                int FSMerchantID = 0;
                int FSPartnerID = 0;
                foreach (DataRow row in reader.Rows)
                {
                    FSFlagLive = (bool)row["FSFlagLive"];
                    if (FSFlagLive == true)
                    {
                        FSPartnerID = (int)row["FSPartnerID"];
                        FSMerchantID = (int)row["FSMerchantID"];
                        FSUsername = CryptorEngine.Decrypt((string)row["FSUserName"]);
                        FSPassword = CryptorEngine.Decrypt((string)row["FSPassword"]);
                    }
                    else
                    {
                        FSPartnerID = (int)row["FSDevPartnerID"];
                        FSMerchantID = (int)row["FSDevMerchantID"];
                        FSUsername = CryptorEngine.Decrypt((string)row["FSDevUsername"]);
                        FSPassword = CryptorEngine.Decrypt((string)row["FSDevPassword"]);
                    }
                }

                FS_TrxDetail_Prod.TrxDetail TrxDetail_Prod = new FS_TrxDetail_Prod.TrxDetail();
                //FS_TrxDetail_Prod.Response response_Prod;
                FS_TrxDetail_Dev.TrxDetail TrxDetail_Dev = new FS_TrxDetail_Dev.TrxDetail();
                //FS_TrxDetail_Dev.Response response_Dev;
                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12; //New Standard for PCI Compliance

                //UserName	Required: User Name
                //Password	Required: Password
                //RPNum	Required: The merchant's RP Number, the query will be run against this merchant's account.
                //BeginDt	Optional query field: The begin date of the date range in MM/DD/YYYY format. This date will be converted to MM/DD/YYYYT00:00:00:0000AM
                //EndDt	Optional query field: The end date of the date range in MM/DD/YYYY format. This date will be converted to MM/DD/YYYYT12:59:59:9999PM
                //ExtData	Optional: Extended Data in XML
                string ExtData = "";
                //InvoiceID, PNRef
                if (Amount != "" && Amount != null)
                {
                    ExtData += "<Amount>" + Amount + "</Amount>";
                }

                if (FSFlagLive == true)
                {
                    response = TrxDetail_Prod.GetCardTrx(FSUsername, FSPassword, FSMerchantID.ToString(), PNRef, BeginDt.ToString("MM/dd/yyyy"), EndDt.ToString("MM/dd/yyyy"), PaymentType, ExcludePaymentType, TransType, ExcludeTransType, ApprovalCode, Result, ExcludeResult, NameOnCard, CardNum, CardType, ExcludeCardType, ExcludeVoid.ToString(), User, InvoiceID, SettleFlag, SettleMsg, SettleDt, TransformType, "", "", "", "", ExtData);
                }
                else
                {
                    response = TrxDetail_Dev.GetCardTrx(FSUsername, FSPassword, FSMerchantID.ToString(), PNRef, BeginDt.ToString("MM/dd/yyyy"), EndDt.ToString("MM/dd/yyyy"), PaymentType, ExcludePaymentType, TransType, ExcludeTransType, ApprovalCode, Result, ExcludeResult, NameOnCard, CardNum, CardType, ExcludeCardType, ExcludeVoid.ToString(), User, InvoiceID, SettleFlag, SettleMsg, SettleDt, TransformType, "", "", "", "", ExtData);
                }

                if (response == "Expired Password") 
                {
                    Success = false;
                    EmailServices.SendRunTimeErrorEmail("FrontStreamPayments Audit Error: Practice has an Expired Password", "", "", "GetCardTrx()", "", "N/A", "N/A", "N/A", "N/A", -1, -1, PracticeID, "127.0.0.1", ""); 
                }
                else Success = true;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
    public class GetCheckTrx
    {
        public Boolean Success { get; set; }
        public string response { get; set; }

        public GetCheckTrx(int PracticeID, bool FSFlagLive, string PNRef, DateTime BeginDt, DateTime EndDt, bool ExcludeVoid, string PaymentType, string ExcludePaymentType, string TransType, string ExcludeTransType, string ApprovalCode, string Result, string ExcludeResult, string NameOnCheck, string CheckNum, string AcctNum, string RouteNum, string User, string InvoiceID, string SettleFlag, string SettleMsg, string SettleDt, string TransformType, string Amount)
        {
            try
            {
                //Optional Parameters

                #region ParameterDescription
                /*
                Parameter   Description 
                UserName:   Required. User name assigned in the payment server 
                Password:   Required. Password for the user name assigned in the payment server 
                RPNum:      Required. The merchant's RP Number in order to uniquely identify merchant's account for the query 
                PNRef:      Optional. The unique payment reference number assigned to the transaction. If this field is provided, all other query fields will be ignored when using PNRef parameter to query the system.
                BeginDt:    Required, except when PNRef is provided. The begin date of the date range in MM/DD/YYYY (or YYYY-MM-DD or YYYY-MM-DDThh:mm:ss) format. This date will be converted to YYYY-MM-DDThh:mm:ss (time is in 24-hour format). If the passed-in BeginDt does not contain time information, BeginDt will default to midnight on the given date. For 
                EndDt:      Required, except when PNRef is provided. The end date of the date range in MM/DD/YYYY (or YYYY-MM-DD or YYYY-MM-DDThh:mm:ss) format. This date will be converted to YYYY-MM-DDThh:mm:ss (time is in 24-hour format). If the passed-in EndDt does not contain time information, EndDt will be incremented to the next day at midnight such that no transaction on the desired end date will be excluded based on its time. 
                PaymentType:Optional. If provided, only those transactions matching the 
                            PaymentType will be included. Valid values are: 
                            • 'ACH' Automated Clearing House
                            • 'ECHECK' Electronic Check
                            • 'GUARANTEE' Guarantee check
                            • 'PAYRECEIPT' to retrieve receipt images that were uploaded 
                            to the payment server
                            • 'SETTLE' to retrieve requests to settle transactions
                            • 'VERIFY' to retrieve pre-authorized checks 
                            Or any permutation of the above values, e.g. "'ACH','ECHECK'" will 
                            pull all transactions with either ACH or ECHECK payment types 
            
                ExcludePaymentType Optional. If provided, any transaction matching the ExcludePaymentType will be excluded 
                TransType:  Optional. If provided, only those transactions matching the TransType will be included. Valid values are 
                    • 'Authorization' to retrieve previously-authorized (pre-auth) 
                    transactions
                    • 'Capture' to retrieve captured transactions
                    • 'Credit' to retrieve return transactions
                    • 'ForceCapture' to retrieve force-auth transactions 
                    • 'GetStatus' to make an inquiry to the EBT or gift card’s balance
                    • 'PostAuth' to retrieve post-auth transactions
                    • 'Purged' to remove a transaction from the current batch due to 
                    an error 
                    • 'Receipt' to retrieve receipt images that were uploaded to the 
                    payment server
                    • 'RepeatSale' to retrieve repeat-sale transactions
                    • 'Sale' to retrieve sale transactions
                    • 'Void' to retrieve void transactions
                    Or any permutation of the above values, e.g. "'Credit','Sale'" will pull all  transactions with either Credit or Sale transaction types. 
            
                ExcludeTransType: Optional. If provided, any transaction matching the ExcludeTransType will be excluded ApprovalCode Optional. If provided, only those transactions matching the ApprovalCode parameter will be included 
                Result:     Optional. If provided, only those transactions matching the Result will be included. Valid values are: 
                    • 0 is Approved 
                    • Anything else is declined; if you want all the declined transactions, you should leave this field empty and use the ExcludeResult=0 instead. 
                ExcludeResult:  Optional. If provided, any transactions matching the ExcludeResult will be excluded. 
                NameOnCheck: Optional. Check owner's name as it is appear on the check, if provided. Only those transactions with check owner's name matching NameOnCheck will be included. Matching is done using wild cards: e.g. "test" will match "test", "1test" and "1test234" 
                CheckNum:   Optional. Check number. If provided, only those transactions with matching CheckNum will be included 
                AcctNum:    Optional. Check account number. If provided, only those transactions matching the AcctNum will be included. Matching is done using wild cards 
                RouteNum:   Optional. If provided, any transactions matching the RouteNum (Transit Number) will be excluded. Matching is done using wild cards 
                ExcludeVoid: Required, except when PNRef is provided. An option to exclude voided transactions or not; must either be TRUE or FALSE
                User: Optional. The user who originated the transactions. If provided, only those transactions created by the matching User will be included. Matching is done using wild cards 
                InvoiceId: Optional. The invoice ID that was included in the original transaction. If provided, only those transactions with matching invoiceId will be included. Matching is done using wild cards 
                SettleFlag: Optional. An option to retrieve the settled transactions or unsettled transactions; must either be 1 for true or 0 for false 
                SettleMsg Optional. The settlement ID or message returned from the host 
                SettleDt Optional. The date of the settlement TransformType Optional. The type of format to transform the data into. Leave the field blank to default to XML
                    • XML will output the plain XML string 
                    • XSL will use XSL to transform the XML output 
                    • DELIM uses ColDelim and RowDelim to format the output 
                    Xsl 
                    Optional. This field is used only if the TransformType is XSL. The XSL to transform the resulting dataset. If provided, the resulting dataset will be transformed using this XSL. You may pass in a URL to the XSL file, or the XSL string itself. If this field is not empty, the Web Services will try to locate the file from the URL. If that also fails, it will treat it as an XSL string. In any case, the final XSL string will be loaded and validated against the XSL schema; if it passes, then that XSL will be used for transformation. A sample predefined XSL is included with this Web Services: 
                    • https://secure.ftipgw.com/admin/ws/TabDelim.xsl for a tab delimited transformation
                ColDelim Optional. This field is used only if the TransformType is DELIM. This defines the string that separates each column 
                RowDelim Optional. This field is used only if the TransformType is DELIM. This defines the string that separates each row IncludeHeader Optional. This field is used only if the TransformType is DELIM. If TRUE, then field headers will be included in the first row using the same delimiter strings; must either be TRUE or FALSE
                ExtData 
                    Optional. Extended data in XML format. Valid values are: 
                    • <IMAGE_TYPE>NO_IMAGE</IMAGE_TYPE> for no image 
                    • <IMAGE_TYPE>ONLY_IMAGE</IMAGE_TYPE> for only the image 
                    • <IMAGE_TYPE>ALL</IMAGE_TYPE> for all images 
                    • <CustomerID>CustomerID</CustomerID> for customer ID 
                    • <Amount>Amount</Amount> Total amount to search transactions for in DDDD.CC format. 
                    • <RegisterNum>RegisterNum</RegisterNum> Register number, originally passed with the transaction, to search transactions for.
                */
                #endregion
                //FrontStream credentials.
                var reader = SqlHelper.ExecuteDataTableProcedureParams("sys_FSInfo_get", new Dictionary<string, object> { { "PracticeID", PracticeID } });

                string FSUsername = "";
                string FSPassword = "";
                int FSMerchantID = 0;
                int FSPartnerID = 0;
                foreach (DataRow row in reader.Rows)
                {
                    FSFlagLive = (bool)row["FSFlagLive"];
                    if (FSFlagLive == true)
                    {
                        FSPartnerID = (int)row["FSPartnerID"];
                        FSMerchantID = (int)row["FSMerchantID"];
                        FSUsername = CryptorEngine.Decrypt((string)row["FSUserName"]);
                        FSPassword = CryptorEngine.Decrypt((string)row["FSPassword"]);
                    }
                    else
                    {
                        FSPartnerID = (int)row["FSDevPartnerID"];
                        FSMerchantID = (int)row["FSDevMerchantID"];
                        FSUsername = CryptorEngine.Decrypt((string)row["FSDevUsername"]);
                        FSPassword = CryptorEngine.Decrypt((string)row["FSDevPassword"]);
                    }
                }

                FS_TrxDetail_Prod.TrxDetail TrxDetail_Prod = new FS_TrxDetail_Prod.TrxDetail();
                //FS_TrxDetail_Prod.Response response_Prod;
                FS_TrxDetail_Dev.TrxDetail TrxDetail_Dev = new FS_TrxDetail_Dev.TrxDetail();
                //FS_TrxDetail_Dev.Response response_Dev;
                System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12; //New Standard for PCI Compliance

                //UserName	Required: User Name
                //Password	Required: Password
                //RPNum	Required: The merchant's RP Number, the query will be run against this merchant's account.
                //BeginDt	Optional query field: The begin date of the date range in MM/DD/YYYY format. This date will be converted to MM/DD/YYYYT00:00:00:0000AM
                //EndDt	Optional query field: The end date of the date range in MM/DD/YYYY format. This date will be converted to MM/DD/YYYYT12:59:59:9999PM
                //ExtData	Optional: Extended Data in XML
                string ExtData = "";
                //InvoiceID, PNRef
                if (Amount != "" && Amount != null)
                {
                    ExtData += "<Amount>" + Amount + "</Amount>";
                }

                if (FSFlagLive == true)
                {
                    response = TrxDetail_Prod.GetCheckTrx(FSUsername, FSPassword, FSMerchantID.ToString(), PNRef, BeginDt.ToString("MM/dd/yyyy"), EndDt.ToString("MM/dd/yyyy"), PaymentType, ExcludePaymentType, TransType, ExcludeTransType, ApprovalCode, Result, ExcludeResult, NameOnCheck, CheckNum, AcctNum, RouteNum, ExcludeVoid.ToString(), User, InvoiceID, SettleFlag, SettleMsg, SettleDt, TransformType, "", "", "", "", ExtData);
                }
                else
                {
                    response = TrxDetail_Dev.GetCheckTrx(FSUsername, FSPassword, FSMerchantID.ToString(), PNRef, BeginDt.ToString("MM/dd/yyyy"), EndDt.ToString("MM/dd/yyyy"), PaymentType, ExcludePaymentType, TransType, ExcludeTransType, ApprovalCode, Result, ExcludeResult, NameOnCheck, CheckNum, AcctNum, RouteNum, ExcludeVoid.ToString(), User, InvoiceID, SettleFlag, SettleMsg, SettleDt, TransformType, "", "", "", "", ExtData);
                }
                if (response == "Expired Password")
                {
                    Success = false;
                    EmailServices.SendRunTimeErrorEmail("FrontStreamPayments Audit Error: Practice has an Expired Password", "", "", "GetCheckTrx()", "", "N/A", "N/A", "N/A", "N/A", -1, -1, PracticeID, "127.0.0.1", "");
                }
                else Success = true;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
    //public class GetInfo
    //{
    //    public string response { get; set; }

    //    public GetInfo(int PracticeID, string BatchSequenceNum)
    //    {
    //        try
    //        {
    //            //Parameters
    //            string TransType = "BatchInquiry"; //Always should be BatchInquiry
    //            //FrontStream credentials.
    //            string connectionstring = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
    //            SqlConnection connection = new SqlConnection(connectionstring);
    //            SqlCommand cmd = new SqlCommand();
    //            SqlDataReader reader;

    //            cmd = new SqlCommand();
    //            cmd.CommandText = "sys_FSInfo_get";
    //            cmd.CommandType = CommandType.StoredProcedure;
    //            cmd.Parameters.Add(new SqlParameter("PracticeID", PracticeID));
    //            cmd.Connection = connection;
    //            connection.Open();
    //            reader = cmd.ExecuteReader();

    //            string FSUsername = "";
    //            string FSPassword = "";
    //            int FSMerchantID = 0;
    //            int FSPartnerID = 0;
    //            bool FSFlagLive = false;
    //            while (reader.Read())
    //            {
    //                FSUsername = (string)reader["FSUserName"];
    //                FSPassword = (string)reader["FSPassword"];
    //                FSFlagLive = (bool)reader["FSFlagLive"];
    //                FSMerchantID = (int)reader["FSMerchantID"];
    //                FSPartnerID = (int)reader["FSPartnerID"];

    //            }
    //            if (FSFlagLive == false)
    //            {
    //                FSUsername = "fvwd4268";
    //                FSPassword = "2876";
    //                FSMerchantID = 285;
    //                FSPartnerID = 100;
    //            }
    //            reader.Close();
    //            connection.Close();

    //            FS_TrxDetail_Prod.TrxDetail TrxDetail_Prod = new FS_TrxDetail_Prod.TrxDetail();

    //            FS_TrxDetail_Dev.TrxDetail TrxDetail_Dev = new FS_TrxDetail_Dev.TrxDetail();

    //            //UserName	Required: User Name
    //            //Password	Required: Password
    //            //RPNum	Required: The merchant's RP Number, the query will be run against this merchant's account.
    //            //BeginDt	Optional query field: The begin date of the date range in MM/DD/YYYY format. This date will be converted to MM/DD/YYYYT00:00:00:0000AM
    //            //EndDt	Optional query field: The end date of the date range in MM/DD/YYYY format. This date will be converted to MM/DD/YYYYT12:59:59:9999PM
    //            //ExtData	Optional: Extended Data in XML
    //            string ExtData = "";

    //            if (BatchSequenceNum != "" && BatchSequenceNum != null)
    //            {
    //                ExtData += "<BatchSequenceNum>" + BatchSequenceNum + "</BatchSequenceNum>";
    //            }

    //            if (FSFlagLive == true)
    //            {
    //                response = TrxDetail_Prod.GetInfo(FSUsername, FSPassword, TransType, ExtData);
    //            }
    //            else
    //            {
    //                response = TrxDetail_Dev.GetInfo(FSUsername, FSPassword, TransType, ExtData);
    //            }
    //        }
    //        catch (Exception)
    //        {
    //            throw;
    //        }
    //    }
    //}
}


