using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;
using PatientPortal.Utility.MedDataService;
using PatientPortal.DataLayer;

// For system functions like Console.
// For generic collections like List.
// For the database connections and objects.


//enum PatientRelationCode
//{
//    Spouse = 01,
//    Grandparent = 04,
//    Grandchild = 05,
//    Nephew = 07,
//    Fosterchild = 10,
//    Ward = 15,
//    Stepchild = 17,
//    Self = 18,
//    Child = 19,
//    Employee = 20,
//    Unknown = 21,
//    Handicappeddependent = 22,
//    Sponsoreddependent = 23,
//    dependentofminor = 24,
//    significantother = 29,
//    Mother = 32,
//    Father = 33,
//    EmancipatedMinor = 36,
//    Organdonor = 39,
//    Cadaverdonor = 40,
//    Injuredplaintiff = 41,
//    Childinsurednotresp = 43, //Child where insured has no financial responsibility
//    lifepartner = 53
//    //otherrel = G8 //only allows numeric, so disabled this option.
//};

namespace PatientPortal.Utility
{
    public class Eligibility
    {
        public int EligibilityID { get; set; }
        public string Message { get; set; }
        public Boolean Success { get; set; }

        public Eligibility(DateTime DateofServiceStart, DateTime DateofServiceEnd, int PatientID, string PatientFirstName, string PatientLastName, string SubscriberIDCode = "", string SubscriberDoB = "", string SubscriberRelationCode = "", int ProviderIDCode = 0, int PayerID = 0, int PayerIDCode = 0)
        {
            try
            {
                var connectionstring = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
                SqlConnection connection = new SqlConnection(connectionstring);
                SqlCommand cmd = new SqlCommand();
                SqlDataReader reader;


                MedDataExternalSubmissionPortalSoapClient CarebluePortal = new MedDataExternalSubmissionPortalSoapClient();
                SecurityHeader CareblueTest = new SecurityHeader();
                //iPlexus Credentials
                //CareblueTest.UserName = "ip1careblue115";
                //CareblueTest.Password = "uWCRDa46jdPRe6j6mrWi-01";
                //CareblueTest.UserName = "2013252"; //Fixed Case
                CareblueTest.UserName = "2013228"; //Dynamic Case
                CareblueTest.Password = "thI!W1x4";
                string XMLSubmission = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><requests>";
                XMLSubmission = XMLSubmission + "<request requestType=\"Eligibility\">";
                ////XMLSubmission = XMLSubmission + "<trackingId>123456789</trackingId>";//[Alpha-numeric, max 30 characters]
                XMLSubmission = XMLSubmission + "<dateOfService>" + DateofServiceStart.ToString("yyyyMMdd") + "-" + DateofServiceEnd.ToString("yyyyMMdd") + "</dateOfService>";// YYYYMMDD-YYYYMMDD can be same date [numeric, min 8/max 17 characters]";
                XMLSubmission = XMLSubmission + "<payerId>" + PayerIDCode.ToString() + "</payerId>";// [numeric, 5 characters]";
                XMLSubmission = XMLSubmission + "<providerId>" + ProviderIDCode.ToString() + " </providerId>";// [Alpha-numeric, max 80 characters]";
                //XMLSubmission = XMLSubmission + "<providerLastNameOrgName>BLUE CROSS - CA, LOS ANGELES</providerLastNameOrgName>";// [Alpha-numeric, max 35 characters]";
                XMLSubmission = XMLSubmission + "<subscriberId>" + SubscriberIDCode + "</subscriberId>";// [Alpha-numeric, max 80 characters]";
                //XMLSubmission = XMLSubmission + "<subscriberSSN>340409251</subscriberSSN>";// [Alpha-numeric, 9 characters]";
                //XMLSubmission = XMLSubmission + "<subscriberGroupNumber>307163</subscriberGroupNumber>";// [Alpha-numeric, max 30 characters]";
                XMLSubmission = XMLSubmission + "<subscriberFirstName>" + PatientFirstName + "</subscriberFirstName>";// [Alpha-numeric, max 25 characters]";
                //XMLSubmission = XMLSubmission + "<subscriberMiddleName>P</subscriberMiddleName>";// [Alpha-numeric, max 25 characters]";
                XMLSubmission = XMLSubmission + "<subscriberLastName>" + PatientLastName + "</subscriberLastName>";// [Alpha-numeric, max 35 characters]";
                //XMLSubmission = XMLSubmission + "<subscriberGender>M</subscriberGender>";// [Alpha, 1 characters]";
                XMLSubmission = XMLSubmission + "<subscriberDOB>" + SubscriberDoB + "</subscriberDOB>";// YYYYMMDD [numeric, 8 characters]";
                XMLSubmission = XMLSubmission + "<patientRelationCode>" + SubscriberRelationCode + "</patientRelationCode>";// [numeric, max 2 characters]";
                //    //XMLSubmission = XMLSubmission + "<dependentSSN>123456789</dependentSSN>";// [numeric, 9 characters]";
                //    //XMLSubmission = XMLSubmission + "<dependentGroupNumber>12345</dependentGroupNumber>";// [Alpha-numeric, max 30 characters]";
                //    //XMLSubmission = XMLSubmission + "<dependentFirstName>MARY</dependentFirstName>";// [Alpha-numeric, max 25 characters]";
                //    //XMLSubmission = XMLSubmission + "<dependentMiddleName>J</dependentMiddleName>";// [Alpha-numeric, max 25 characters]";
                //    //XMLSubmission = XMLSubmission + "<dependentLastName>SMITH</dependentLastName>";// [Alpha-numeric, max 35 characters]";
                //    //XMLSubmission = XMLSubmission + "<dependentSuffixName>JR</dependentSuffixName>";// [Alpha-numeric, max 10 characters]";
                //    //XMLSubmission = XMLSubmission + "<dependentGender>F</dependentGender>";// [Alpha, 1 characters]";
                //    //XMLSubmission = XMLSubmission + "<dependentDOB>19900101</dependentDOB>";// [numeric, 8 characters]";
                //XMLSubmission = XMLSubmission + "<serviceTypeCode>73</serviceTypeCode>";// [numeric, max 2 characters]
                XMLSubmission = XMLSubmission + "</request>";
                XMLSubmission = XMLSubmission + "</requests>";


                string XMLResponse = string.Empty;


                bool readfromfile = true;

                if (!readfromfile)
                {
                    XMLResponse = CarebluePortal.SubmitSync(CareblueTest, XMLSubmission, "FlatXml", "VerboseXml", "0.00:01:00", "0.00:01:00");
                    //  *** Write Response to File ***
                    System.IO.Directory.CreateDirectory(@"C:\CBPRM-XML\");
                    using (System.IO.StreamWriter file = new System.IO.StreamWriter(string.Format(@"C:\CBPRM-XML\iPlexus_{0:yyyy-MM-dd_hh-mm-ss-tt}.xml", DateTime.Now), true))
                    {
                        file.WriteLine(XMLResponse);
                    }
                }
                else
                {
                    ////  *** Optionally, you can read from file instead of submitting new request ***
                    //string PFSFile1 = "C:\\iPlexus_2012-12-14_07-37-15-PM.xml";
                    //StreamReader streamReader = new StreamReader(PFSFile1);
                    //XMLResponse = streamReader.ReadToEnd();
                    //streamReader.Close();


                    //Read from SQL Database but treat it as a new Eligibility Request
                    var reader3 = SqlHelper.ExecuteDataTableProcedureParams("web_pr_eligibilityaudit_get", new Dictionary<string, object> { { "@EligibilityID", 16 } });
                    foreach (DataRow row in reader3.Rows)
                    {
                        XMLResponse = row["XMLResponse"].ToString();
                    }
                }

                var cmdParams = new Dictionary<string, object>
                                {
                                    {"CarrierID", PayerID},
                                    {"PayerIDCode", PayerIDCode},
                                    {"ProviderIDCode", ProviderIDCode},
                                    {"PatientID", PatientID},
                                    {"XMLSubmission", XMLSubmission},
                                    {"XMLResponse", XMLResponse}
                                };

                var reader2 = SqlHelper.ExecuteDataTableProcedureParams("web_pr_eligibility_add", cmdParams);
                foreach (DataRow row in reader2.Rows)
                {
                    EligibilityID = (int)row["EligibilityID"];
                }
                

                EligibilityRawCreate(EligibilityID);

                //Call Process Eligilibility procedure to process raw data to processed data.
                cmd = new SqlCommand();
                cmd.CommandText = "process_EligibilityRaw";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new SqlParameter("EligibilityID", EligibilityID));
                cmd.Connection = connection;
                connection.Open();
                reader = cmd.ExecuteReader();

                Success = true;
                Message = "Success";

                //Console.WriteLine(DateTime.Now);
                //Console.Read();
            }
            catch (Exception ex)
            {
                Success = false;
                Message = ex.Message;
                throw;
            }
        }
        public void EligibilityRawCreate(int EligibilityID)
        {
            try
            {
                var connectionstring = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
                SqlConnection connection = new SqlConnection(connectionstring);
                SqlCommand cmd = new SqlCommand();
                //SqlDataReader reader;
                string XMLResponse = "";

                var reader2 = SqlHelper.ExecuteDataTableProcedureParams("web_pr_eligibilityaudit_get", new Dictionary<string, object> { { "@EligibilityID", EligibilityID } });
                foreach (DataRow row in reader2.Rows)
                {
                    XMLResponse = row["XMLResponse"].ToString();
                }
                Stack<string> flattenxml = new Stack<string>();
                Stack<string> reverseflattenxml = new Stack<string>();
                string outputtext = "", LastLoopName = "", LoopName = "", XMLType = "";
                int LoopID = 1, LineNum = 0;
                DataRow drEligibilityRaw;
                DataTable dtEligibilityRaw = new DataTable();
                dtEligibilityRaw.Columns.Add("EligibilityID", typeof(int));
                dtEligibilityRaw.Columns.Add("LoopID", typeof(int));
                dtEligibilityRaw.Columns.Add("Stack", typeof(String));
                dtEligibilityRaw.Columns.Add("Value", typeof(String));
                dtEligibilityRaw.Columns.Add("LineNum", typeof(int));

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
                                    XMLType = "Element";
                                    flattenxml.Push(readerxml.Name);
                                    LineNum++;
                                    if (readerxml.Name == "TransactionResponse") { flattenxml.Pop(); }
                                    if (LastLoopName == readerxml.Name) { LoopID++; LoopName = readerxml.Name; outputtext += "Start new Loop" + System.Environment.NewLine; }
                                    break;
                                case XmlNodeType.Text:
                                    XMLType = "Text";
                                    reverseflattenxml = new Stack<string>(flattenxml);
                                    outputtext = "";
                                    foreach (string number in reverseflattenxml)
                                    {
                                        outputtext += "<" + number + ">";
                                    }
                                    drEligibilityRaw = dtEligibilityRaw.NewRow();
                                    drEligibilityRaw["EligibilityID"] = EligibilityID;
                                    drEligibilityRaw["LoopID"] = LoopID;
                                    drEligibilityRaw["Stack"] = outputtext;
                                    drEligibilityRaw["Value"] = readerxml.Value;
                                    drEligibilityRaw["LineNum"] = LineNum;
                                    dtEligibilityRaw.Rows.Add(drEligibilityRaw);
                                    break;
                                case XmlNodeType.XmlDeclaration:
                                    XMLType = "Declaration";
                                    break;
                                case XmlNodeType.ProcessingInstruction:
                                    XMLType = "ProcessingInstructions";
                                    //writer.WriteProcessingInstruction(readerxml.Name, readerxml.Value);
                                    break;
                                case XmlNodeType.Comment:
                                    XMLType = "Comment";
                                    //writer.WriteComment(readerxml.Value);
                                    break;
                                case XmlNodeType.EndElement:
                                    if (XMLType == "EndElement") { LineNum++; } //If the last xml element was an "End Element", then LineNum needs to be increased so it matches the xml layout.
                                    XMLType = "EndElement";
                                    LastLoopName = readerxml.Name;
                                    if (readerxml.Name == "TransactionResponse") { break; }
                                    if (readerxml.Name == LoopName) { outputtext += "End Loop" + System.Environment.NewLine; LoopName = ""; }
                                    flattenxml.Pop();
                                    //Console.WriteLine(flattenxml);
                                    break;
                            }
                        }

                        SqlBulkCopy bulkcopy = new SqlBulkCopy(connection, SqlBulkCopyOptions.TableLock | SqlBulkCopyOptions.UseInternalTransaction, null);
                        bulkcopy.DestinationTableName = "dbo.EligibilityRaw";
                        bulkcopy.ColumnMappings.Add("EligibilityID", "EligibilityID");
                        bulkcopy.ColumnMappings.Add("LoopID", "LoopID");
                        bulkcopy.ColumnMappings.Add("Stack", "Stack");
                        bulkcopy.ColumnMappings.Add("Value", "Value");
                        bulkcopy.ColumnMappings.Add("LineNum", "LineNum");
                        connection.Open();
                        bulkcopy.WriteToServer(dtEligibilityRaw);
                        bulkcopy.Close();
                        connection.Close();

                        Success = true;
                        Message = "Success";
                    }
                }
            }
            catch (Exception ex)
            {
                Success = false;
                Message = ex.Message;
                throw;
            }
        }
    }
}
