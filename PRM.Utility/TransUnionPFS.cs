using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Data;
using System.Data.Sql;
using System.Xml;
using System.Xml.Linq;
using System.Collections.Specialized;
using System.Data.SqlClient;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using System.Text.RegularExpressions;

// For the database connections and objects.

namespace PatientPortal.Utility
{
    public class TransUnionPFSRequest
    {
        public int TUPFSID { get; set; }
        public string Message { get; set; }
        public Boolean Success { get; set; }
        public Boolean FlagShowTUFSReport { get; set; }

        public TransUnionPFSRequest(int? PatientID, string PatientFirstName, string PatientMiddleName, string PatientLastName, string PatientAddress, string PatientCity, string PatientState, string PatientZip, int? PatientSS, DateTime PatientDoB, int PracticeID, int? FlagGuardian, int TUReasonTypeID, string IPAddress, decimal statedIncome, string housingType, int UserID, int creditApplicationID, string outputFormat = "HTML")
        {
            // IN ALL CASES, THIS METHOD NEEDS TO ADD ENTRIES ABOUT REQUESTS AND THEIR STATUS TO THE DATABASE IN THE TU_ TABLES
            // when patientid is not null, use patient information and ignore passed parameters. you should also expect @PracticeID, @UserID (for audit) and @FlagGuardian if @PatientID is passed
            // in this case, we use the values from the database as they have already been verified by the user
            //if (PatientID <> null) 
            //{
            //}


            //TransUnion subscriber code is a combination of a 4 digit <inquirySubscriberPrefixCode>, one character <industryCode> and an 8 digit <memberCode>.
            try
            {
                string TUURL = "";

                string TUUsername = "";
                string TUPassword = "";
                bool TUFlagLive = false;
                bool TUAbort = false;
                //
                //0622M03432412  prefix is first four digits, industry code is the letter, and last 8 digits is member code - JHV 7/11/2013
                string SubscriberPrefixCode = "0622";
                string IndustryCode = "M";
                string MemberCode = "03432412";
                string SubscriberPassword = "WY31"; //The length password is alphanumeric with a length of four characters. Partners will have to store the subscriber code and password on every end customer profile and should send this information in the request.
                string QueryType = "FAAPID";
                var parsedPatientDOB = PatientDoB == new DateTime() ? (object)DBNull.Value : PatientDoB;

                var reader = SqlHelper.ExecuteDataTableProcedureParams("sys_TUInfo_process", new Dictionary<string, object> { { "@PracticeID", PracticeID } });
                foreach (DataRow row in reader.Rows)
                {
                    TUFlagLive = (bool)row["TUFlagLive"];

                    TUUsername = CryptorEngine.Decrypt(row["TUUsername"].ToString());
                    TUPassword = CryptorEngine.Decrypt(row["TUPassword"].ToString());
                    SubscriberPrefixCode = row["TUSubscriberPrefixCode"].ToString();
                    IndustryCode = row["TUIndustryCode"].ToString();
                    MemberCode = row["TUMemberCode"].ToString();
                    SubscriberPassword = row["TUSubPass"].ToString();
                    TUAbort = (bool)row["TUAbort"];
                    TUURL = row["TUURL"].ToString();
                }

                if (TUAbort == true && TUFlagLive == true) //Too many PFS calls or other reasons, check sys_TUInfo_get for possibilities. If TUFlagLive = false, make as many requests as desired.
                {
                    TUPFSID = -1;
                    Success = false;
                    Message = "Exceeded TUPFS calls";
                    return;
                }

                string inputSSN, inputSSN4;
                if (PatientSS.ToString().Length > 5)
                {
                    inputSSN = PatientSS.ToString();
                    inputSSN4 = PatientSS.ToString().Substring(PatientSS.ToString().Length - 4, 4);
                }
                else
                {
                    inputSSN = null;
                    inputSSN4 = null;
                }

                var cmdParams = new Dictionary<string, object>
                                    {
                                        {"@PracticeID", PracticeID},
                                        {"@CreditApplicationID", creditApplicationID >0 ? creditApplicationID : (object)DBNull.Value},
                                        {"@TUFlagLive", TUFlagLive},
                                        {"@PatientID", PatientID},
                                        {"@TUResultTypeID", (Int32)Enums.TUResultTypeID.Unknown},
                                        {"@TUResultMessage", "Inserted pre-submission"},
                                        {"@TUReasonTypeID", TUReasonTypeID},
                                        {"@inputQueryType", QueryType},
                                        {"@inputNameFirst", PatientFirstName},
                                        {"@inputNameMiddle", PatientMiddleName},
                                        {"@inputNameLast", PatientLastName},
                                        {"@inputAddrStreet", PatientAddress},
                                        {"@inputAddrCity", PatientCity},
                                        {"@inputAddrState", PatientState},
                                        {"@inputAddrZip", PatientZip},
                                        {"@inputSSNenc", CryptorEngine.Encrypt(inputSSN)},
                                        {"@inputSSN4", inputSSN4},
                                        {"@inputDOB", parsedPatientDOB},
                                        {"@IPAddress", IPAddress},
                                        {"@StatedIncome", statedIncome},
                                        {"@HousingType", housingType},
                                        {"@UserID", UserID}                                        
                                    };

                if (FlagGuardian != null)
                {
                    cmdParams.Add("@FlagBorrowerGuardian", FlagGuardian);
                }


                reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_tupfs_add", cmdParams);
                foreach (DataRow row in reader.Rows)
                {
                    TUPFSID = (int)row["TUPFSID"];
                }

                string XMLSubmission = @"<?xml version=""1.0"" encoding=""UTF-8""?>";
                XMLSubmission = XMLSubmission + @"<pfs xmlns=""http://www.transunion.com/namespace/pfs/v3"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:schemaLocation=""http://www.transunion.com/namespace pfsV3.xsd"">";
                XMLSubmission = XMLSubmission + "<document>request</document>";
                XMLSubmission = XMLSubmission + "<version>V3</version>";
                XMLSubmission = XMLSubmission + "<transactionControl>";
                XMLSubmission = XMLSubmission + "<subscriber>";
                XMLSubmission = XMLSubmission + "<industryCode>" + IndustryCode + "</industryCode>";
                XMLSubmission = XMLSubmission + "<memberCode>" + MemberCode + "</memberCode>";
                //XMLSubmission = XMLSubmission + "<subscriberId>" + SubscriberIDCode + "</subscriberId>";// [Alpha-numeric, max 80 characters]";
                XMLSubmission = XMLSubmission + "<inquirySubscriberPrefixCode>" + SubscriberPrefixCode + "</inquirySubscriberPrefixCode>";
                XMLSubmission = XMLSubmission + "<password>" + SubscriberPassword + "</password>";
                XMLSubmission = XMLSubmission + "</subscriber>";
                XMLSubmission = XMLSubmission + "<userKey>" + UserID + "</userKey>"; //Filler field that can accept the external user ID of the user that is triggering the request. Value sent in this field is echoed back in the response.
                XMLSubmission = XMLSubmission + "<queryType>" + QueryType + "</queryType>";
                //CR is a Financial Assessment request. It returns both ID/Address and financial information.
                //CV is an ID/Address Verification request. It returns ID and address verification information.
                //IV is an Insurance Verification request. The response for an IV request is the insurance verification response returned by the payer.
                //CRIV is a combination request for Financial Assessment and Insurance Verification. CRIV request will result in Financial Assessment + Insurance Verification response.
                //CVIV is a combination request for ID/Address Verification and Insurance Verification. CVIV request will result in ID/Address Verification + Insurance Verification response.

                XMLSubmission = XMLSubmission + "<outputFormat>" + outputFormat + "</outputFormat>"; //HTML can be passed too.
                XMLSubmission = XMLSubmission + "<referenceID>" + TUPFSID + "</referenceID>"; //Filler field that can accept an external unique ID. The ID received in the request is echoed out in the response.
                XMLSubmission = XMLSubmission + "</transactionControl>";
                XMLSubmission = XMLSubmission + "<product><subject><subjectRecord><indicative>";
                XMLSubmission = XMLSubmission + "<name>";
                XMLSubmission = XMLSubmission + "<person>";
                XMLSubmission = XMLSubmission + "<first>" + PatientFirstName + "</first>";
                XMLSubmission = XMLSubmission + "<middle>" + PatientMiddleName + "</middle>";
                XMLSubmission = XMLSubmission + "<last>" + PatientLastName + "</last>";
                XMLSubmission = XMLSubmission + "</person>";
                XMLSubmission = XMLSubmission + "</name>";
                XMLSubmission = XMLSubmission + "<address>";
                XMLSubmission = XMLSubmission + "<street>";
                XMLSubmission = XMLSubmission + "<unparsed>" + PatientAddress + "</unparsed>";
                XMLSubmission = XMLSubmission + "</street>";
                XMLSubmission = XMLSubmission + "<location>";
                XMLSubmission = XMLSubmission + "<city>" + PatientCity + "</city>";
                XMLSubmission = XMLSubmission + "<state>" + PatientState + "</state>";
                XMLSubmission = XMLSubmission + "<zipCode>" + PatientZip + "</zipCode>";
                XMLSubmission = XMLSubmission + "</location>";
                XMLSubmission = XMLSubmission + "</address>";
                XMLSubmission = XMLSubmission + "<socialSecurity><number>" + PatientSS + "</number></socialSecurity>";
                XMLSubmission = XMLSubmission + "<dateOfBirth>" + PatientDoB.ToString("yyyy-MM-dd") + "</dateOfBirth>";
                XMLSubmission = XMLSubmission + "</indicative></subjectRecord></subject>";
                XMLSubmission = XMLSubmission + "<billingRecord><originatingSourceCode/></billingRecord>";
                XMLSubmission = XMLSubmission + "</product></pfs>";

                // 40000 = 40 Seconds
                var client = new CustomWebClient(40000);
                var reqparm = new NameValueCollection
                                  {
                                      {"username", TUUsername},
                                      {"password", TUPassword},
                                      {"type", "PFS"},
                                      {"PFS", XMLSubmission}
                                  };
                //To Read from File, change bool to True, and update PFSFile1 & PFSFile2
                bool readfromfile = false;
                string PFSFile1 = "C:\\cbprm-xml\\TU_2016-05-12_07-49-59-PM.xml";
                string PFSFile2 = "C:\\CBPRM-XML\\TU2_2016-05-12_07-51-26-PM.xml";
                string XMLResponse = "";


                if (!readfromfile)
                {
                    XMLResponse = Encoding.UTF8.GetString(client.UploadValues(TUURL, "POST", reqparm));

                    //*** Write Response to File ***
                    System.IO.Directory.CreateDirectory(@"C:\CBPRM-XML\");
                    using (System.IO.StreamWriter file = new System.IO.StreamWriter(string.Format(@"C:\CBPRM-XML\TU_{0:yyyy-MM-dd_hh-mm-ss-tt}.xml", DateTime.Now), true))
                    {
                        file.WriteLine(XMLResponse);
                    }
                }
                else
                {
                    //*** Optionally, you can read from file instead of submitting new request ***
                    StreamReader streamReader = new StreamReader(PFSFile1);
                    XMLResponse = streamReader.ReadToEnd();
                    streamReader.Close();
                }


                int TUResultTypeID = (Int32)Enums.TUResultTypeID.Success;
                string respNameFirst = null, respNameMiddle = null, respNameLast = null;
                string respAddrunParsed = null, respAddrNum = null, respAddrPreDir = null, respAddrStreet = null, respAddrPostDir = null, respAddrType = null, respAddrUnit = null, respAddrCity = null, respAddrState = null, respAddrZip = null;
                string respAddr2unParsed = null, respAddr2Num = null, respAddr2PreDir = null, respAddr2Street = null, respAddr2PostDir = null, respAddr2Type = null, respAddr2Unit = null, respAddr2City = null, respAddr2State = null, respAddr2Zip = null;
                string respAddr3unParsed = null, respAddr3Num = null, respAddr3PreDir = null, respAddr3Street = null, respAddr3PostDir = null, respAddr3Type = null, respAddr3Unit = null, respAddr3City = null, respAddr3State = null, respAddr3Zip = null;
                string respPhone = null, respSSN = null, respDOB = null;
                string respCalcAC = null, respCalcDTI = null, respCalcRI = null, respCalcFPL = null, respCalcEHHI = null, respCalcEHHS = null;
                string respScoreNAResult = null, respScoreRResult = null, respScoreFICOResult = null;
                bool? respScoreNAFlagAlert = null, respScoreRFlagAlert = null, respScoreFICOFlagAlert = null, respScoreNAFlagImpact = null, respScoreRFlagImpact = null, respScoreFICOFlagImpact = null;
                int? respFlagNameLast = null, respFlagNameFirst = null, respFlagSSN = null, respFlagDoB = null, respFlagAddr = null;
                string respScoreNACard = null, respScoreNAFactor1 = null, respScoreNAFactor2 = null, respScoreNAFactor3 = null, respScoreNAFactor4 = null, respScoreNAFactor5 = null,
                    respScoreRCard = null, respScoreRFactor1 = null, respScoreRFactor2 = null, respScoreRFactor3 = null, respScoreRFactor4 = null, respScoreRFactor5 = null,
                    respScoreFICOCard = null, respScoreFICOFactor1 = null, respScoreFICOFactor2 = null, respScoreFICOFactor3 = null, respScoreFICOFactor4 = null, respScoreFICOFactor5 = null;
                DateTime? respReptPullDate = null;
                string respPrintImage = null;
                string respStatusAccuracyTxt = null, respStatusFinAidTxt = null, respStatusCollectTxt = null, respStatusRiskTxt = null, respStatusRedFlagTxt = null, respWarning1 = null, respWarning2 = null, respWarning3 = null, respWarning4 = null, respWarning5 = null;
                string respHTMLBody = null;
                int WarningCount = 1;
                Stack<string> Node = new Stack<string>();
                bool FlagIndicative = false, FlagCalculations = false, FlagAddress = false, FlagpreviousAddresses = false, FlagpreviousAddress1 = false, FlagpreviousAddress2 = false, FlagScoreModel = false, FlagScoreNA = false, FlagScoreR = false, FlagScoreFICO = false, FlagSS = false, FlagdeterminationStatus = false, FlagcreditReport = false; //, Flaghtml = false
                bool FlagFactors = false, FlagRank1 = false, FlagRank2 = false, FlagRank3 = false, FlagRank4 = false, FlagRank5 = false;

                int? respStatusAccuracyID = null, respStatusFinAidID = null, respStatusCollectID = null, respStatusRiskID = null, respStatusRedFlagID = null;
                Success = true; //default to true, will override if there's an error.


                /**********************************************************************************************************************************/
                //To Modify parsing, there are several areas in the function that may need to be modified. 
                //1. Any xml node being referenced (either as a parent, or a child) must be added to NodeList. Duplicates in the array are okay.
                //2. Any Parent Node (a node which has children and does not contain data itself) must be referenced in the "case XmlNodeType.Element" portion of the switch. It must enable a Flag, which must be declared. This makes the parent an "enclosure" to make children value uniquely identifable.
                //3. Any Child Node (nodes with data) must be referenced in the "case XmlNodeType.Text" portion of the switch. They should be referenced by ensuring that the appropriate Parent Flag is enabled. This will prevent similar child nodes from intermixing when they have different parents.
                //4. Any Parent Node must also be referenced in "case XmlNodeType.EndElement" in order to disable their parent flag.
                //5. In some cases, a Child Node acts as a Parent node by using the child's data element as an identifying flag. If that is the case, you will need an additional "parent flag" for the child, which is processed in "case XmlNodeType.Text".

                string[] NodeList = { 
                                        "calculations", "dti", "residualIncome", "fpl", "availableCredit", "estHouseholdIncome", "estHouseholdSize", //Calculations
                                        "scores", "scoreModel", "code", "score", "results", "derogatoryAlert", "fileInquiriesImpactedScore", "factors", "factor", "rank", "code", "scoreCard", //ScoreModel
                                        "determinationStatus", "accuracy", "financialAid", "collection", "riskIndicator", "redFlag", "warnings", //Determination Status
                                        "creditReport", "pullDate", "printImage", //Credit Report
                                        "indicative", "error",
                                        "name", "person", "first", "middle", "socialSecurity", "dateOfBirth", //Name
                                        "address", "last", "street", "unparsed", "number", "preDirectional", "name", "postDirectional", "type", "unit", "location", "city", "state", "zipCode", //Address
                                        "previousAddresses", "address", "street", "unparsed", "number", "preDirectional", "name", "postDirectional", "type", "unit", "location", "city", "state", "zipCode", //Address
                                        "html", "body"  //HTML
                                        
                                    };
                StringBuilder output = new StringBuilder();
                using (XmlReader readerxml = XmlReader.Create(new StringReader(XMLResponse)))
                {
                    XmlWriterSettings ws = new XmlWriterSettings();
                    ws.Indent = true;
                    using (XmlWriter writer = XmlWriter.Create(output, ws))
                    {
                        // Parse the file and display each of the nodes.
                        while (readerxml.Read())
                        {
                            switch (readerxml.NodeType)
                            {
                                case XmlNodeType.Element:
                                    if (readerxml.IsEmptyElement == false) //no need to process empty elements
                                    {
                                        switch (readerxml.Name)
                                        {
                                            case "indicative": if (readerxml.GetAttribute("source") == "file") { FlagIndicative = true; } break;
                                            case "calculations": FlagCalculations = true; break;
                                            case "address": FlagAddress = true; break;
                                            case "previousAddresses": FlagpreviousAddresses = true; break;
                                            case "scoreModel": FlagScoreModel = true; break;
                                            case "socialSecurity": FlagSS = true; break;
                                            case "factors": FlagFactors = true; break;
                                            case "determinationStatus": FlagdeterminationStatus = true; break;
                                            case "creditReport": FlagcreditReport = true; break;
                                            case "html": break; //Flaghtml = true; 
                                            case "accuracy": if (readerxml.HasAttributes == true && FlagdeterminationStatus == true) { respStatusAccuracyID = TUColorID(readerxml.GetAttribute("DisplayColor")); } break;
                                            case "financialAid": if (readerxml.HasAttributes == true && FlagdeterminationStatus == true) { respStatusFinAidID = TUColorID(readerxml.GetAttribute("DisplayColor")); } break;
                                            case "collection": if (readerxml.HasAttributes == true && FlagdeterminationStatus == true) { respStatusCollectID = TUColorID(readerxml.GetAttribute("DisplayColor")); } break;
                                            case "riskIndicator": if (readerxml.HasAttributes == true && FlagdeterminationStatus == true) { respStatusRiskID = TUColorID(readerxml.GetAttribute("DisplayColor")); } break;
                                            case "redFlag": if (readerxml.HasAttributes == true && FlagdeterminationStatus == true) { respStatusRedFlagID = TUColorID(readerxml.GetAttribute("DisplayColor")); } break;
                                            case "number": if (readerxml.HasAttributes == true && FlagSS == true) { respFlagSSN = TUColorID(readerxml.GetAttribute("DisplayColor")); } break;
                                            case "unparsed": if (readerxml.HasAttributes == true && FlagAddress == true) { respFlagAddr = TUColorID(readerxml.GetAttribute("DisplayColor")); } break;
                                            case "first": if (readerxml.HasAttributes == true && FlagpreviousAddresses == false) { respFlagNameFirst = TUColorID(readerxml.GetAttribute("DisplayColor")); } break;
                                            case "last": if (readerxml.HasAttributes == true && FlagpreviousAddresses == false) { respFlagNameLast = TUColorID(readerxml.GetAttribute("DisplayColor")); } break;
                                            case "dateOfBirth": if (readerxml.HasAttributes == true && FlagpreviousAddresses == false) { respFlagDoB = TUColorID(readerxml.GetAttribute("DisplayColor")); } break;

                                        }
                                        if (NodeList.Contains(readerxml.Name)) { Node.Push(readerxml.Name); break; } //Remaining Node List.
                                    }
                                    break;
                                case XmlNodeType.Text:
                                    if (Node.Count > 0)
                                    {
                                        if (FlagIndicative == true)
                                        {
                                            if (FlagpreviousAddresses == false)
                                            {
                                                switch (Node.Peek()) //Grab Child Node then Pop.
                                                {
                                                    case "first": respNameFirst = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "middle": respNameMiddle = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "last": respNameLast = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "unparsed": respAddrunParsed = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "number": if (FlagAddress == true) { respAddrNum = Convert.ToString(readerxml.Value); Node.Pop(); }
                                                        else if (FlagSS == true)
                                                        { respSSN = Convert.ToString(readerxml.Value); Node.Pop(); } break;
                                                    case "preDirectional": respAddrPreDir = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "name": if (FlagAddress == true) { respAddrStreet = Convert.ToString(readerxml.Value); Node.Pop(); } break;
                                                    case "postDirectional": respAddrPostDir = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "type": respAddrType = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "unit": respAddrUnit = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "city": respAddrCity = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "state": respAddrState = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "zipCode": respAddrZip = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "phone": respPhone = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "dateOfBirth": respDOB = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "error": Success = false; Message = Convert.ToString(readerxml.Value); TUResultTypeID = (Int32)Enums.TUResultTypeID.Failure; Node.Pop(); break;
                                                }
                                            }
                                            else if (FlagpreviousAddresses == true && FlagpreviousAddress1 == false) //enable FlagPreviousAddress1 or FlagPreviousAddress2
                                            {
                                                switch (Node.Peek()) //Grab Child Node then Pop.
                                                {
                                                    case "status":
                                                        if (Convert.ToString(readerxml.Value) == "previous") { FlagpreviousAddress1 = true; } else if (Convert.ToString(readerxml.Value) == "secondPrevious") { FlagpreviousAddress2 = true; } Node.Pop(); break;
                                                }
                                            }
                                            else if (FlagpreviousAddresses == true && FlagpreviousAddress1 == true)
                                            {
                                                switch (Node.Peek()) //Grab Child Node then Pop.
                                                {
                                                    case "unparsed": respAddr2unParsed = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "number": if (FlagAddress == true) { respAddr2Num = Convert.ToString(readerxml.Value); Node.Pop(); } break;
                                                    case "preDirectional": respAddr2PreDir = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "name": if (FlagAddress == true) { respAddr2Street = Convert.ToString(readerxml.Value); Node.Pop(); } break;
                                                    case "postDirectional": respAddr2PostDir = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "type": respAddr2Type = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "unit": respAddr2Unit = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "city": respAddr2City = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "state": respAddr2State = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "zipCode": respAddr2Zip = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                }
                                            }
                                            else if (FlagpreviousAddresses == true && FlagpreviousAddress2 == true)
                                            {
                                                switch (Node.Peek()) //Grab Child Node then Pop.
                                                {
                                                    case "unparsed": respAddr3unParsed = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "number": if (FlagAddress == true) { respAddr3Num = Convert.ToString(readerxml.Value); Node.Pop(); } break;
                                                    case "preDirectional": respAddr3PreDir = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "name": if (FlagAddress == true) { respAddr3Street = Convert.ToString(readerxml.Value); Node.Pop(); } break;
                                                    case "postDirectional": respAddr3PostDir = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "type": respAddr3Type = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "unit": respAddr3Unit = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "city": respAddr3City = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "state": respAddr3State = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                    case "zipCode": respAddr3Zip = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                }
                                            }
                                        }

                                        if (FlagCalculations == true)
                                        {
                                            switch (Node.Peek()) //Grab Child Node then Pop.
                                            {
                                                case "dti": respCalcDTI = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                case "residualIncome": respCalcRI = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                case "fpl": respCalcFPL = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                case "availableCredit": respCalcAC = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                case "estHouseholdIncome": respCalcEHHI = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                case "estHouseholdSize": respCalcEHHS = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                            }
                                        }

                                        if (FlagScoreModel == true)
                                        {
                                            switch (Node.Peek()) //Grab Child Node then Pop.
                                            {
                                                case "code":
                                                    if (Convert.ToString(readerxml.Value) == "New Account") { FlagScoreNA = true; }
                                                    else if (Convert.ToString(readerxml.Value) == "Recovery") { FlagScoreR = true; }
                                                    else if (Convert.ToString(readerxml.Value) == "FICO") { FlagScoreFICO = true; }
                                                    if (FlagFactors == true)
                                                    {
                                                        if (FlagRank1 == true) { if (FlagScoreNA == true) { respScoreNAFactor1 = Convert.ToString(readerxml.Value); } else if (FlagScoreR == true) { respScoreRFactor1 = Convert.ToString(readerxml.Value); } else if (FlagScoreFICO == true) { respScoreFICOFactor1 = Convert.ToString(readerxml.Value); } }
                                                        else if (FlagRank2 == true) { if (FlagScoreNA == true) { respScoreNAFactor2 = Convert.ToString(readerxml.Value); } else if (FlagScoreR == true) { respScoreRFactor2 = Convert.ToString(readerxml.Value); } else if (FlagScoreFICO == true) { respScoreFICOFactor1 = Convert.ToString(readerxml.Value); } }
                                                        else if (FlagRank3 == true) { if (FlagScoreNA == true) { respScoreNAFactor3 = Convert.ToString(readerxml.Value); } else if (FlagScoreR == true) { respScoreRFactor3 = Convert.ToString(readerxml.Value); } else if (FlagScoreFICO == true) { respScoreFICOFactor1 = Convert.ToString(readerxml.Value); } }
                                                        else if (FlagRank4 == true) { if (FlagScoreNA == true) { respScoreNAFactor4 = Convert.ToString(readerxml.Value); } else if (FlagScoreR == true) { respScoreRFactor4 = Convert.ToString(readerxml.Value); } else if (FlagScoreFICO == true) { respScoreFICOFactor1 = Convert.ToString(readerxml.Value); } }
                                                        else if (FlagRank5 == true) { if (FlagScoreNA == true) { respScoreNAFactor5 = Convert.ToString(readerxml.Value); } else if (FlagScoreR == true) { respScoreRFactor5 = Convert.ToString(readerxml.Value); } else if (FlagScoreFICO == true) { respScoreFICOFactor1 = Convert.ToString(readerxml.Value); } }
                                                    }
                                                    Node.Pop();
                                                    break;
                                                case "results": if (FlagScoreNA == true) { respScoreNAResult = Convert.ToString(readerxml.Value); }
                                                    else if (FlagScoreR == true) { respScoreRResult = Convert.ToString(readerxml.Value); }
                                                    else if (FlagScoreFICO == true) { respScoreFICOResult = Convert.ToString(readerxml.Value); } Node.Pop(); break;
                                                case "derogatoryAlert": if (FlagScoreNA == true) { respScoreNAFlagAlert = Convert.ToBoolean(readerxml.Value); }
                                                    else if (FlagScoreR == true) { respScoreRFlagAlert = Convert.ToBoolean(readerxml.Value); }
                                                    else if (FlagScoreFICO == true) { respScoreFICOFlagAlert = Convert.ToBoolean(readerxml.Value); } Node.Pop(); break;
                                                case "fileInquiriesImpactedScore": if (FlagScoreNA == true) { respScoreNAFlagImpact = Convert.ToBoolean(readerxml.Value); }
                                                    else if (FlagScoreR == true) { respScoreRFlagImpact = Convert.ToBoolean(readerxml.Value); }
                                                    else if (FlagScoreFICO == true) { respScoreFICOFlagImpact = Convert.ToBoolean(readerxml.Value); } Node.Pop(); break;
                                                case "rank":
                                                    switch (Convert.ToString(readerxml.Value))
                                                    {
                                                        case "1": FlagRank1 = true; break;
                                                        case "2": FlagRank2 = true; break;
                                                        case "3": FlagRank3 = true; break;
                                                        case "4": FlagRank4 = true; break;
                                                        case "5": FlagRank5 = true; break;
                                                    } break;
                                                case "scoreCard": if (FlagScoreNA == true) { respScoreNACard = Convert.ToString(readerxml.Value); }
                                                    else if (FlagScoreR == true) { respScoreRCard = Convert.ToString(readerxml.Value); }
                                                    else if (FlagScoreFICO == true) { respScoreFICOCard = Convert.ToString(readerxml.Value); } Node.Pop(); break;
                                            }
                                            break;
                                        }
                                        if (FlagdeterminationStatus == true)
                                        {
                                            switch (Node.Peek()) //Grab Child Node then Pop.
                                            {
                                                case "accuracy":
                                                    if (readerxml.HasAttributes == true) { respStatusAccuracyID = TUColorID(readerxml.GetAttribute("DisplayColor")); }
                                                    respStatusAccuracyTxt = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                case "financialAid":
                                                    if (readerxml.HasAttributes == true) { respStatusFinAidID = TUColorID(readerxml.GetAttribute("DisplayColor")); }
                                                    respStatusFinAidTxt = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                case "collection":
                                                    if (readerxml.HasAttributes == true) { respStatusCollectID = TUColorID(readerxml.GetAttribute("DisplayColor")); }
                                                    respStatusCollectTxt = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                case "riskIndicator":
                                                    if (readerxml.HasAttributes == true) { respStatusRiskID = TUColorID(readerxml.GetAttribute("DisplayColor")); }
                                                    respStatusRiskTxt = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                case "redFlag":
                                                    if (readerxml.HasAttributes == true) { respStatusRedFlagID = TUColorID(readerxml.GetAttribute("DisplayColor")); }
                                                    respStatusRedFlagTxt = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                                case "warnings":
                                                    switch (WarningCount) //Grab Child Node then Pop.
                                                    {
                                                        case 1: respWarning1 = Convert.ToString(readerxml.Value); WarningCount++; break;
                                                        case 2: respWarning2 = Convert.ToString(readerxml.Value); WarningCount++; break;
                                                        case 3: respWarning3 = Convert.ToString(readerxml.Value); WarningCount++; break;
                                                        case 4: respWarning4 = Convert.ToString(readerxml.Value); WarningCount++; break;
                                                        case 5: respWarning5 = Convert.ToString(readerxml.Value); WarningCount++; break;
                                                    }
                                                    Node.Pop(); break;
                                            }
                                        }

                                        if (FlagcreditReport == true)
                                        {
                                            switch (Node.Peek()) //Grab Child Node then Pop.
                                            {
                                                case "pullDate": respReptPullDate = Convert.ToDateTime(readerxml.Value); Node.Pop(); break;
                                                case "printImage": respPrintImage = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                            }
                                        }

                                        //if (Flaghtml == true)
                                        //{
                                        //    switch (Node.Peek()) //Grab Child Node then Pop.
                                        //    {
                                        //        case "body": respHTMLBody = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                        //    }
                                        //}
                                    }
                                    break;
                                case XmlNodeType.CDATA: //CDATA sections are used to escape blocks of text that would otherwise be recognized as markup. 
                                    if (FlagcreditReport == true)
                                    {
                                        switch (Node.Peek()) //Grab Child Node then Pop.
                                        {
                                            case "printImage": respPrintImage = Convert.ToString(readerxml.Value); Node.Pop(); break;
                                        }
                                    }
                                    break;
                                case XmlNodeType.XmlDeclaration:
                                case XmlNodeType.ProcessingInstruction:
                                    //writer.WriteProcessingInstruction(readerxml.Name, readerxml.Value);
                                    break;
                                case XmlNodeType.Comment:
                                    //writer.WriteComment(readerxml.Value);
                                    break;
                                case XmlNodeType.EndElement:
                                    if (Node.Count() > 0 && readerxml.Name == Node.Peek())
                                    {
                                        switch (Node.Peek())
                                        {
                                            case "indicative": FlagIndicative = false; break;
                                            case "calculations": FlagCalculations = false; break;
                                            case "address": FlagAddress = false; break;
                                            case "previousAddresses": FlagpreviousAddresses = false; FlagpreviousAddress1 = false; FlagpreviousAddress2 = false; break;
                                            case "socialSecurity": FlagSS = false; break;
                                            case "scoreModel": FlagScoreModel = false; FlagScoreNA = false; FlagScoreR = false; FlagScoreFICO = false; break;
                                            case "factor": FlagRank1 = false; FlagRank2 = false; FlagRank3 = false; FlagRank4 = false; FlagRank5 = false; break;
                                            case "factors": FlagFactors = false; break;
                                            case "determinationStatus": FlagdeterminationStatus = false; break;
                                            case "creditReport": FlagcreditReport = false; break;
                                            case "html": break; //Flaghtml = false;
                                        }
                                    }
                                    if (NodeList.Contains(readerxml.Name) && Node.Count() > 0 && readerxml.Name == Node.Peek()) { Node.Pop(); }
                                    break;
                            }
                        }
                    }
                }
                if (XMLResponse.Length > 0 && XMLResponse.Contains("printImageText") && XMLResponse.Contains("END OF TRANSUNION REPORT"))
                {
                    respHTMLBody = XMLResponse.Substring(XMLResponse.IndexOf("<html>"), XMLResponse.IndexOf("</html>") - XMLResponse.IndexOf("<html>") + 7);
                    respHTMLBody = respHTMLBody.Replace("\n", "<br>");
                }

                if (!readfromfile)
                {
                    System.IO.Directory.CreateDirectory(@"C:\CBPRM-XML\");
                    using (System.IO.StreamWriter file = new System.IO.StreamWriter(string.Format(@"C:\CBPRM-XML\TU2_{0:yyyy-MM-dd_hh-mm-ss-tt}.xml", DateTime.Now), true))
                    {
                        file.WriteLine(respHTMLBody);
                    }
                }
                else
                {
                    //*** Optionally, you can read from file instead of submitting new request ***
                    StreamReader streamReader = new StreamReader(PFSFile2);
                    respHTMLBody = streamReader.ReadToEnd();
                    streamReader.Close();
                }
                //Process Credit Summary 
                string respRevolving, respInstallment, respMortgage, respOpen, respTotals, respRevolvingHighCred = null, respRevolvingCredLim = null, respRevolvingBalance = null, respRevolvingPastDue = null, respRevolvingMonthlyPay = null, respRevolvingAvailable = null;
                string respInstallmentHighCred = null, respInstallmentCredLim = null, respInstallmentBalance = null, respInstallmentPastDue = null, respInstallmentMonthlyPay = null, respInstallmentAvailable = null;
                string respMortgageHighCred = null, respMortgageCredLim = null, respMortgageBalance = null, respMortgagePastDue = null, respMortgageMonthlyPay = null, respMortgageAvailable = null;
                string respOpenHighCred = null, respOpenCredLim = null, respOpenBalance = null, respOpenPastDue = null, respOpenMonthlyPay = null, respOpenAvailable = null;
                string respTotalsHighCred = null, respTotalsCredLim = null, respTotalsBalance = null, respTotalsPastDue = null, respTotalsMonthlyPay = null, respTotalsAvailable = null;
                string respCreditSummary = null;

                if (respHTMLBody != null)
                {
                    //Search for CREDIT Summary, and keep going to get the block until you find the next section, which has been TRADES in the past. If it's not TRADES, it might be INQUIRIES, and then cut off everything after that.
                    respCreditSummary = GetCreditSummary(respHTMLBody);
                }
                else
                {
                    respCreditSummary = "";
                }
                if (respCreditSummary.Length > 0 && respCreditSummary.Contains("<br> REVOLVING:"))
                {
                    respRevolving = respCreditSummary.Substring(respCreditSummary.IndexOf("<br> REVOLVING:"), 82);
                    respRevolvingHighCred = respRevolving.Substring(19, 10).Trim();
                    if (respRevolvingHighCred.Contains("K")) { respRevolvingHighCred = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respRevolvingHighCred, @"(\d*\.)?\d+").Value) * 1000)); }
                    respRevolvingCredLim = respRevolving.Substring(30, 9).Trim();
                    if (respRevolvingCredLim.Contains("K")) { respRevolvingCredLim = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respRevolvingCredLim, @"(\d*\.)?\d+").Value) * 1000)); }
                    respRevolvingBalance = respRevolving.Substring(40, 8).Trim();
                    if (respRevolvingBalance.Contains("K")) { respRevolvingBalance = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respRevolvingBalance, @"(\d*\.)?\d+").Value) * 1000)); }
                    respRevolvingPastDue = respRevolving.Substring(49, 9).Trim();
                    if (respRevolvingPastDue.Contains("K")) { respRevolvingPastDue = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respRevolvingPastDue, @"(\d*\.)?\d+").Value) * 1000)); }
                    respRevolvingMonthlyPay = respRevolving.Substring(59, 9).Trim();
                    if (respRevolvingMonthlyPay.Contains("K")) { respRevolvingMonthlyPay = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respRevolvingMonthlyPay, @"(\d*\.)?\d+").Value) * 1000)); }
                    respRevolvingAvailable = respRevolving.Substring(69, 10).Trim();
                    respRevolvingAvailable = Regex.Match(respRevolvingAvailable, @"\d+").Value;
                }
                if (respCreditSummary.Length > 0 && respCreditSummary.Contains("<br> INSTALLMENT:"))
                {
                    respInstallment = respCreditSummary.Substring(respCreditSummary.IndexOf("<br> INSTALLMENT:"), 82);
                    respInstallmentHighCred = respInstallment.Substring(19, 10).Trim();
                    if (respInstallmentHighCred.Contains("K")) { respInstallmentHighCred = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respInstallmentHighCred, @"(\d*\.)?\d+").Value) * 1000)); }
                    respInstallmentCredLim = respInstallment.Substring(30, 9).Trim();
                    if (respInstallmentCredLim.Contains("K")) { respInstallmentCredLim = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respInstallmentCredLim, @"(\d*\.)?\d+").Value) * 1000)); }
                    respInstallmentBalance = respInstallment.Substring(40, 8).Trim();
                    if (respInstallmentBalance.Contains("K")) { respInstallmentBalance = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respInstallmentBalance, @"(\d*\.)?\d+").Value) * 1000)); }
                    respInstallmentPastDue = respInstallment.Substring(49, 9).Trim();
                    if (respInstallmentPastDue.Contains("K")) { respInstallmentPastDue = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respInstallmentPastDue, @"(\d*\.)?\d+").Value) * 1000)); }
                    respInstallmentMonthlyPay = respInstallment.Substring(59, 9).Trim();
                    if (respInstallmentMonthlyPay.Contains("K")) { respInstallmentMonthlyPay = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respInstallmentMonthlyPay, @"(\d*\.)?\d+").Value) * 1000)); }
                    respInstallmentAvailable = respInstallment.Substring(69, 10).Trim();
                    respInstallmentAvailable = Regex.Match(respInstallmentAvailable, @"\d+").Value;
                }
                if (respCreditSummary.Length > 0 && respCreditSummary.Contains("<br> MORTGAGE:"))
                {
                    respMortgage = respCreditSummary.Substring(respCreditSummary.IndexOf("<br> MORTGAGE:"), 82);
                    respMortgageHighCred = respMortgage.Substring(19, 10).Trim();
                    if (respMortgageHighCred.Contains("K")) { respMortgageHighCred = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respMortgageHighCred, @"(\d*\.)?\d+").Value) * 1000)); }
                    respMortgageCredLim = respMortgage.Substring(30, 9).Trim();
                    if (respMortgageCredLim.Contains("K")) { respMortgageCredLim = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respMortgageCredLim, @"(\d*\.)?\d+").Value) * 1000)); }
                    respMortgageBalance = respMortgage.Substring(40, 8).Trim();
                    if (respMortgageBalance.Contains("K")) { respMortgageBalance = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respMortgageBalance, @"(\d*\.)?\d+").Value) * 1000)); }
                    respMortgagePastDue = respMortgage.Substring(49, 9).Trim();
                    if (respMortgagePastDue.Contains("K")) { respMortgagePastDue = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respMortgagePastDue, @"(\d*\.)?\d+").Value) * 1000)); }
                    respMortgageMonthlyPay = respMortgage.Substring(59, 9).Trim();
                    if (respMortgageMonthlyPay.Contains("K")) { respMortgageMonthlyPay = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respMortgageMonthlyPay, @"(\d*\.)?\d+").Value) * 1000)); }
                    respMortgageAvailable = respMortgage.Substring(69, 10).Trim();
                    respMortgageAvailable = Regex.Match(respMortgageAvailable, @"\d+").Value;
                }
                if (respCreditSummary.Length > 0 && respCreditSummary.Contains("<br> OPEN:"))
                {
                    respOpen = respCreditSummary.Substring(respCreditSummary.IndexOf("<br> OPEN:"), 82);
                    respOpenHighCred = respOpen.Substring(19, 10).Trim();
                    if (respOpenHighCred.Contains("K")) { respOpenHighCred = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respOpenHighCred, @"(\d*\.)?\d+").Value) * 1000)); }
                    respOpenCredLim = respOpen.Substring(30, 9).Trim();
                    if (respOpenCredLim.Contains("K")) { respOpenCredLim = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respOpenCredLim, @"(\d*\.)?\d+").Value) * 1000)); }
                    respOpenBalance = respOpen.Substring(40, 8).Trim();
                    if (respOpenBalance.Contains("K")) { respOpenBalance = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respOpenBalance, @"(\d*\.)?\d+").Value) * 1000)); }
                    respOpenPastDue = respOpen.Substring(49, 9).Trim();
                    if (respOpenPastDue.Contains("K")) { respOpenPastDue = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respOpenPastDue, @"(\d*\.)?\d+").Value) * 1000)); }
                    respOpenMonthlyPay = respOpen.Substring(59, 9).Trim();
                    if (respOpenMonthlyPay.Contains("K")) { respOpenMonthlyPay = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respOpenMonthlyPay, @"(\d*\.)?\d+").Value) * 1000)); }
                    respOpenAvailable = respOpen.Substring(69, 10).Trim();
                    respOpenAvailable = Regex.Match(respOpenAvailable, @"\d+").Value;
                }
                if (respCreditSummary.Length > 0 && respCreditSummary.Contains("<br> TOTALS:"))
                {
                    respTotals = respCreditSummary.Substring(respCreditSummary.IndexOf("<br> TOTALS:"), 82);
                    respTotalsHighCred = respTotals.Substring(19, 10).Trim();
                    if (respTotalsHighCred.Contains("K")) { respTotalsHighCred = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respTotalsHighCred, @"(\d*\.)?\d+").Value) * 1000)); }
                    respTotalsCredLim = respTotals.Substring(30, 9).Trim();
                    if (respTotalsCredLim.Contains("K")) { respTotalsCredLim = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respTotalsCredLim, @"(\d*\.)?\d+").Value) * 1000)); }
                    respTotalsBalance = respTotals.Substring(40, 8).Trim();
                    if (respTotalsBalance.Contains("K")) { respTotalsBalance = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respTotalsBalance, @"(\d*\.)?\d+").Value) * 1000)); }
                    respTotalsPastDue = respTotals.Substring(49, 9).Trim();
                    if (respTotalsPastDue.Contains("K")) { respTotalsPastDue = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respTotalsPastDue, @"(\d*\.)?\d+").Value) * 1000)); }
                    respTotalsMonthlyPay = respTotals.Substring(59, 9).Trim();
                    if (respTotalsMonthlyPay.Contains("K")) { respTotalsMonthlyPay = Convert.ToString(Convert.ToInt32(Convert.ToDecimal(Regex.Match(respTotalsMonthlyPay, @"(\d*\.)?\d+").Value) * 1000)); }
                    respTotalsAvailable = respTotals.Substring(69, 10).Trim();
                    respTotalsAvailable = Regex.Match(respTotalsAvailable, @"\d+").Value;
                }

                //Process Collections
                List<string> respSubName = new List<string>(), respSubCode = new List<string>(), respECOA = new List<string>(), respCreditor = new List<string>(), respMOP = new List<string>(), respAccount = new List<string>(), respRemarks = new List<string>(), respOpened = new List<string>(), respClosed = new List<string>(), respVerified = new List<string>();
                List<int> respPlaced = new List<int>(), respBalance = new List<int>();

                if (respCreditSummary.Length > 0 && respCreditSummary.Contains("C O L L E C T I O N S"))
                {
                    string[] respCollections = Regex.Split(respCreditSummary.Substring(respCreditSummary.IndexOf("C O L L E C T I O N S")), "\r<br>");

                    for (int x = 3; x < respCollections.Length; x++)
                    {
                        if (respCollections[x].Contains("----------------------------------------------------------------------------")) { break; }
                        respSubName.Add(respCollections[x].Substring(1, 14).Trim());
                        respSubCode.Add(respCollections[x].Substring(15, 10).Trim());
                        respECOA.Add(respCollections[x].Substring(25, 6).Trim());
                        respOpened.Add(respCollections[x].Substring(31, 7).Trim());
                        respClosed.Add(respCollections[x].Substring(38, 7).Trim());
                        respPlaced.Add(Convert.ToInt32(respCollections[x].Substring(46, 8).Trim()));
                        respCreditor.Add(respCollections[x].Substring(54, 20).Trim());
                        respMOP.Add(respCollections[x].Substring(74, 3).Trim());
                        x += 1;
                        respAccount.Add(respCollections[x].Substring(1, 14).Trim());
                        respVerified.Add(respCollections[x].Substring(31, 7).Trim());
                        respBalance.Add(Convert.ToInt32(respCollections[x].Substring(46, 8).Trim()));
                        respRemarks.Add(respCollections[x].Substring(54, 20).Trim());
                    }
                }
                if (respHTMLBody != null && respHTMLBody.Length > 0 && respHTMLBody.Contains("printImageText") && respHTMLBody.Contains("END OF TRANSUNION REPORT"))
                {
                    respHTMLBody = respHTMLBody.Substring(respHTMLBody.IndexOf("printImageText") + 16, respHTMLBody.IndexOf("END OF TRANSUNION REPORT") - respHTMLBody.IndexOf("printImageText") + 8);
                }
                cmdParams = new Dictionary<string, object>
                                    {
                                        {"@TUPFSID", TUPFSID},
                                        {"@PracticeID", PracticeID},
                                        {"@PatientID", PatientID},
                                        {"@TUResultTypeID", TUResultTypeID},
                                        {"@TUResultMessage", Message},
                                        {"@TUReasonTypeID", TUReasonTypeID},
                                        {"@inputQueryType", QueryType},
                                        {"@inputNameFirst", PatientFirstName},
                                        {"@inputNameMiddle", PatientMiddleName},
                                        {"@inputNameLast", PatientLastName},
                                        {"@inputAddrStreet", PatientAddress},
                                        {"@inputAddrCity", PatientCity},
                                        {"@inputAddrState", PatientState},
                                        {"@inputAddrZip", PatientZip},
                                        {"@inputSSNenc", CryptorEngine.Encrypt(PatientSS.ToString())},
                                        {"@inputSSN4", (PatientSS < 1000 || string.IsNullOrEmpty(PatientSS.ToString())) ? PatientSS.ToString() : PatientSS.ToString().Substring(PatientSS.ToString().Length - 4, 4)},
                                        {"@inputDOB", parsedPatientDOB},
                                        {"@XMLSubmission", XMLSubmission},
                                        {"@XMLResponse", XMLResponse},
                                        
                                        {"@respNameFirst", respNameFirst},
                                        {"@respNameMiddle", respNameMiddle},
                                        {"@respNameLast", respNameLast},
                                        {"@respAddrunParsed", respAddrunParsed},
                                        {"@respAddrNum", respAddrNum},
                                        {"@respAddrPreDir", respAddrPreDir},
                                        {"@respAddrStreet", respAddrStreet},
                                        {"@respAddrPostDir", respAddrPostDir},
                                        {"@respAddrType", respAddrType},
                                        {"@respAddrUnit", respAddrUnit},
                                        {"@respAddrCity", respAddrCity},
                                        {"@respAddrState", respAddrState},
                                        {"@respAddrZip", respAddrZip},
                                        {"@respPhone", respPhone},
                                        {"@respSSNenc", CryptorEngine.Encrypt(respSSN)},
                                        {"@respSSN4", string.IsNullOrEmpty(respSSN) ? respSSN : respSSN.Substring(respSSN.Length - 4, 4)},
                                        {"@respDOB", respDOB},
                                       
                                        {"@respFlagNameFirst", respFlagNameFirst},
                                        {"@respFlagNameLast", respFlagNameLast},
                                        {"@respFlagAddr", respFlagAddr},
                                        {"@respFlagSSN", respFlagSSN},
                                        {"@respFlagDoB", respFlagDoB},


                                        {"@respAddr2unParsed", respAddr2unParsed},
                                        {"@respAddr2Num", respAddr2Num},
                                        {"@respAddr2PreDir", respAddr2PreDir},
                                        {"@respAddr2Street", respAddr2Street},
                                        {"@respAddr2PostDir", respAddr2PostDir},
                                        {"@respAddr2Type", respAddr2Type},
                                        {"@respAddr2Unit", respAddr2Unit},
                                        {"@respAddr2City", respAddr2City},
                                        {"@respAddr2State", respAddr2State},
                                        {"@respAddr2Zip", respAddr2Zip},

                                        {"@respAddr3unParsed", respAddr3unParsed},
                                        {"@respAddr3Num", respAddr3Num},
                                        {"@respAddr3PreDir", respAddr3PreDir},
                                        {"@respAddr3Street", respAddr3Street},
                                        {"@respAddr3PostDir", respAddr3PostDir},
                                        {"@respAddr3Type", respAddr3Type},
                                        {"@respAddr3Unit", respAddr3Unit},
                                        {"@respAddr3City", respAddr3City},
                                        {"@respAddr3State", respAddr3State},
                                        {"@respAddr3Zip", respAddr3Zip},

                                        {"@respCalcDTI", respCalcDTI},
                                        {"@respCalcRI", respCalcRI},
                                        {"@respCalcFPL", respCalcFPL},
                                        {"@respCalcAC", respCalcAC},
                                        {"@respCalcEHHI", respCalcEHHI},
                                        {"@respCalcEHHS", respCalcEHHS},

                                        {"@respScoreNAResult", respScoreNAResult},
                                        {"@respScoreNAFactor1", respScoreNAFactor1},
                                        {"@respScoreNAFactor2", respScoreNAFactor2},
                                        {"@respScoreNAFactor3", respScoreNAFactor3},
                                        {"@respScoreNAFactor4", respScoreNAFactor4},
                                        {"@respScoreNAFactor5", respScoreNAFactor5},
                                        {"@respScoreNACard", respScoreNACard},
                                        {"@respScoreNAFlagAlert", respScoreNAFlagAlert},
                                        {"@respScoreNAFlagImpact", respScoreNAFlagImpact},

                                        {"@respScoreRResult", respScoreRResult},
                                        {"@respScoreRFactor1", respScoreRFactor1},
                                        {"@respScoreRFactor2", respScoreRFactor2},
                                        {"@respScoreRFactor3", respScoreRFactor3},
                                        {"@respScoreRFactor4", respScoreRFactor4},
                                        {"@respScoreRFactor5", respScoreRFactor5},
                                        {"@respScoreRCard", respScoreRCard},
                                        {"@respScoreRFlagAlert", respScoreRFlagAlert},
                                        {"@respScoreRFlagImpact", respScoreRFlagImpact},

                                        {"@respScoreFICOResult", respScoreFICOResult},
                                        {"@respScoreFICOFactor1", respScoreFICOFactor1},
                                        {"@respScoreFICOFactor2", respScoreFICOFactor2},
                                        {"@respScoreFICOFactor3", respScoreFICOFactor3},
                                        {"@respScoreFICOFactor4", respScoreFICOFactor4},
                                        {"@respScoreFICOFactor5", respScoreFICOFactor5},
                                        {"@respScoreFICOCard", respScoreFICOCard},
                                        {"@respScoreFICOFlagAlert", respScoreFICOFlagAlert},
                                        {"@respScoreFICOFlagImpact", respScoreFICOFlagImpact},

                                        {"@respStatusAccuracyTxt", respStatusAccuracyTxt},
                                        {"@respStatusAccuracyID", respStatusAccuracyID},
                                        {"@respStatusFinAidTxt", respStatusFinAidTxt},
                                        {"@respStatusFinAidID", respStatusFinAidID},
                                        {"@respStatusCollectTxt", respStatusCollectTxt},
                                        {"@respStatusCollectID", respStatusCollectID},
                                        {"@respStatusRiskTxt", respStatusRiskTxt},
                                        {"@respStatusRiskID", respStatusRiskID},
                                        {"@respStatusRedFlagTxt", respStatusRedFlagTxt},
                                        {"@respStatusRedFlagID", respStatusRedFlagID},

                                        {"@respWarning1", respWarning1},
                                        {"@respWarning2", respWarning2},
                                        {"@respWarning3", respWarning3},
                                        {"@respWarning4", respWarning4},
                                        {"@respWarning5", respWarning5},
                                        {"@respReptPullDate", respReptPullDate},
                                        {"@respPrintImage", respPrintImage},
                                        {"@respHTMLBody", respHTMLBody},

                                        {"@respRevolvingHighCred", respRevolvingHighCred},
                                        {"@respRevolvingCredLim", respRevolvingCredLim},
                                        {"@respRevolvingBalance", respRevolvingBalance},
                                        {"@respRevolvingPastDue", respRevolvingPastDue},
                                        {"@respRevolvingMonthlyPay", respRevolvingMonthlyPay},
                                        {"@respRevolvingAvailable", respRevolvingAvailable},

                                        {"@respInstallmentHighCred", respInstallmentHighCred},
                                        {"@respInstallmentCredLim", respInstallmentCredLim},
                                        {"@respInstallmentBalance", respInstallmentBalance},
                                        {"@respInstallmentPastDue", respInstallmentPastDue},
                                        {"@respInstallmentMonthlyPay", respInstallmentMonthlyPay},
                                        {"@respInstallmentAvailable", respInstallmentAvailable},

                                        {"@respMortgageHighCred", respMortgageHighCred},
                                        {"@respMortgageCredLim", respMortgageCredLim},
                                        {"@respMortgageBalance", respMortgageBalance},
                                        {"@respMortgagePastDue", respMortgagePastDue},
                                        {"@respMortgageMonthlyPay", respMortgageMonthlyPay},
                                        {"@respMortgageAvailable", respMortgageAvailable},

                                        {"@respOpenHighCred", respOpenHighCred},
                                        {"@respOpenCredLim", respOpenCredLim},
                                        {"@respOpenBalance", respOpenBalance},
                                        {"@respOpenPastDue", respOpenPastDue},
                                        {"@respOpenMonthlyPay", respOpenMonthlyPay},
                                        {"@respOpenAvailable", respOpenAvailable},

                                        {"@respTotalsHighCred", respTotalsHighCred},
                                        {"@respTotalsCredLim", respTotalsCredLim},
                                        {"@respTotalsBalance", respTotalsBalance},
                                        {"@respTotalsPastDue", respTotalsPastDue},
                                        {"@respTotalsMonthlyPay", respTotalsMonthlyPay},
                                        {"@respTotalsAvailable", respTotalsAvailable},

                                        {"@respSubName1",   (respSubName.Count >= 1) ? respSubName[0] : (object)DBNull.Value},
                                        {"@respSubCode1",   (respSubName.Count >= 1) ? respSubCode[0] : (object)DBNull.Value},
                                        {"@respECOA1",      (respSubName.Count >= 1) ? respECOA[0] : (object)DBNull.Value},
                                        {"@respOpened1",    (respSubName.Count >= 1) ? respOpened[0] : (object)DBNull.Value},
                                        {"@respClosed1",    (respSubName.Count >= 1) ? respClosed[0] : (object)DBNull.Value},
                                        {"@respPlaced1",    (respSubName.Count >= 1) ? respPlaced[0] : (object)DBNull.Value},
                                        {"@respCreditor1",  (respSubName.Count >= 1) ? respCreditor[0] : (object)DBNull.Value},
                                        {"@respMOP1",       (respSubName.Count >= 1) ? respMOP[0] : (object)DBNull.Value},
                                        {"@respAccount1",   (respSubName.Count >= 1) ? respAccount[0] : (object)DBNull.Value},
                                        {"@respVerified1",  (respSubName.Count >= 1) ? respVerified[0] : (object)DBNull.Value},
                                        {"@respBalance1",   (respSubName.Count >= 1) ? respBalance[0] : (object)DBNull.Value},
                                        {"@respRemarks1",   (respSubName.Count >= 1) ? respRemarks[0] : (object)DBNull.Value},

                                        {"@respSubName2",   (respSubName.Count >= 2) ? respSubName[1] : (object)DBNull.Value},
                                        {"@respSubCode2",   (respSubName.Count >= 2) ? respSubCode[1] : (object)DBNull.Value},
                                        {"@respECOA2",      (respSubName.Count >= 2) ? respECOA[1] : (object)DBNull.Value},
                                        {"@respOpened2",    (respSubName.Count >= 2) ? respOpened[1] : (object)DBNull.Value},
                                        {"@respClosed2",    (respSubName.Count >= 2) ? respClosed[1] : (object)DBNull.Value},
                                        {"@respPlaced2",    (respSubName.Count >= 2) ? respPlaced[1] : (object)DBNull.Value},
                                        {"@respCreditor2",  (respSubName.Count >= 2) ? respCreditor[1] : (object)DBNull.Value},
                                        {"@respMOP2",       (respSubName.Count >= 2) ? respMOP[1] : (object)DBNull.Value},
                                        {"@respAccount2",   (respSubName.Count >= 2) ? respAccount[1] : (object)DBNull.Value},
                                        {"@respVerified2",  (respSubName.Count >= 2) ? respVerified[1] : (object)DBNull.Value},
                                        {"@respBalance2",   (respSubName.Count >= 2) ? respBalance[1] : (object)DBNull.Value},
                                        {"@respRemarks2",   (respSubName.Count >= 2) ? respRemarks[1] : (object)DBNull.Value},

                                        {"@respSubName3",   (respSubName.Count >= 3) ? respSubName[2] : (object)DBNull.Value},
                                        {"@respSubCode3",   (respSubName.Count >= 3) ? respSubCode[2] : (object)DBNull.Value},
                                        {"@respECOA3",      (respSubName.Count >= 3) ? respECOA[2] : (object)DBNull.Value},
                                        {"@respOpened3",    (respSubName.Count >= 3) ? respOpened[2] : (object)DBNull.Value},
                                        {"@respClosed3",    (respSubName.Count >= 3) ? respClosed[2] : (object)DBNull.Value},
                                        {"@respPlaced3",    (respSubName.Count >= 3) ? respPlaced[2] : (object)DBNull.Value},
                                        {"@respCreditor3",  (respSubName.Count >= 3) ? respCreditor[2] : (object)DBNull.Value},
                                        {"@respMOP3",       (respSubName.Count >= 3) ? respMOP[2] : (object)DBNull.Value},
                                        {"@respAccount3",   (respSubName.Count >= 3) ? respAccount[2] : (object)DBNull.Value},
                                        {"@respVerified3",  (respSubName.Count >= 3) ? respVerified[2] : (object)DBNull.Value},
                                        {"@respBalance3",   (respSubName.Count >= 3) ? respBalance[2] : (object)DBNull.Value},
                                        {"@respRemarks3",   (respSubName.Count >= 3) ? respRemarks[2] : (object)DBNull.Value},

                                        {"@respSubName4",   (respSubName.Count >= 4) ? respSubName[3] : (object)DBNull.Value},
                                        {"@respSubCode4",   (respSubName.Count >= 4) ? respSubCode[3] : (object)DBNull.Value},
                                        {"@respECOA4",      (respSubName.Count >= 4) ? respECOA[3] : (object)DBNull.Value},
                                        {"@respOpened4",    (respSubName.Count >= 4) ? respOpened[3] : (object)DBNull.Value},
                                        {"@respClosed4",    (respSubName.Count >= 4) ? respClosed[3] : (object)DBNull.Value},
                                        {"@respPlaced4",    (respSubName.Count >= 4) ? respPlaced[3] : (object)DBNull.Value},
                                        {"@respCreditor4",  (respSubName.Count >= 4) ? respCreditor[3] : (object)DBNull.Value},
                                        {"@respMOP4",       (respSubName.Count >= 4) ? respMOP[3] : (object)DBNull.Value},
                                        {"@respAccount4",   (respSubName.Count >= 4) ? respAccount[3] : (object)DBNull.Value},
                                        {"@respVerified4",  (respSubName.Count >= 4) ? respVerified[3] : (object)DBNull.Value},
                                        {"@respBalance4",   (respSubName.Count >= 4) ? respBalance[3] : (object)DBNull.Value},
                                        {"@respRemarks4",   (respSubName.Count >= 4) ? respRemarks[3] : (object)DBNull.Value},

                                        {"@respSubName5",   (respSubName.Count >= 5) ? respSubName[4] : (object)DBNull.Value},
                                        {"@respSubCode5",   (respSubName.Count >= 5) ? respSubCode[4] : (object)DBNull.Value},
                                        {"@respECOA5",      (respSubName.Count >= 5) ? respECOA[4] : (object)DBNull.Value},
                                        {"@respOpened5",    (respSubName.Count >= 5) ? respOpened[4] : (object)DBNull.Value},
                                        {"@respClosed5",    (respSubName.Count >= 5) ? respClosed[4] : (object)DBNull.Value},
                                        {"@respPlaced5",    (respSubName.Count >= 5) ? respPlaced[4] : (object)DBNull.Value},
                                        {"@respCreditor5",  (respSubName.Count >= 5) ? respCreditor[4] : (object)DBNull.Value},
                                        {"@respMOP5",       (respSubName.Count >= 5) ? respMOP[4] : (object)DBNull.Value},
                                        {"@respAccount5",   (respSubName.Count >= 5) ? respAccount[4] : (object)DBNull.Value},
                                        {"@respVerified5",  (respSubName.Count >= 5) ? respVerified[4] : (object)DBNull.Value},
                                        {"@respBalance5",   (respSubName.Count >= 5) ? respBalance[4] : (object)DBNull.Value},
                                        {"@respRemarks5",   (respSubName.Count >= 5) ? respRemarks[4] : (object)DBNull.Value},

                                        {"@UserID", UserID}
                                    };

                SqlHelper.ExecuteScalarProcedureParams("web_pr_tupfs_add", cmdParams);
                FlagShowTUFSReport = !string.IsNullOrEmpty(respNameLast);
            }
            catch (Exception ex)
            {
                TUPFSID = -1;
                Success = false;
                FlagShowTUFSReport = false;
                Message = ex.Message;
                if (PatientID == null) { PatientID = -1; }
                var sqlData = SqlHelper.GetSqlData(ex.Data);
                EmailServices.SendRunTimeErrorEmail("TransUnion Run Time Error: " + ex.HelpLink, ex.GetType().ToString(), ex.Message, ex.StackTrace, "", "N/A", "N/A", "N/A", "N/A", UserID, PatientID == null ? -1 : (int)PatientID, PracticeID, IPAddress.ToString(), sqlData);
            }

        }

        private static string GetCreditSummary(string respHTMLBody)
        {
            var startIndex = respHTMLBody.IndexOf("C R E D I T   S U M M A R Y");
            var tradeLength = respHTMLBody.IndexOf("T R A D E S");
            int length;

            if (tradeLength == -1)
            {
                length = respHTMLBody.IndexOf("I N Q U I R I E S");
            }
            else
            {
                length = tradeLength - startIndex;
            }

            try
            {
                return respHTMLBody.Substring(startIndex, length);
            }
            catch (Exception)
            {
                return string.Empty;
            }
        }

        private int? TUColorID(string TUColor)
        {
            switch (TUColor.ToUpper())
            {
                case "GREEN": return (Int32)Enums.TUColorCodes.Green;
                case "YELLOW": return (Int32)Enums.TUColorCodes.Yellow;
                case "RED": return (Int32)Enums.TUColorCodes.Red;
                default: return (Int32)Enums.TUColorCodes.Unknown;
            }
        }

    }
}
