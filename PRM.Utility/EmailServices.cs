using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Security.Policy;
using System.Text;
using System.Web.Services.Protocols;
using EO.Pdf.Internal;
using System.Web;
using PatientPortal.DataLayer;
using PatientPortal.Utility.JangoMail;
using System.Globalization;
using System.Text.RegularExpressions;

namespace PatientPortal.Utility
{
    public class RegexUtilities
    {
        bool invalid = false;

        public bool IsValidEmail(string strIn)
        {
            invalid = false;
            if (String.IsNullOrEmpty(strIn))
                return false;

            // Use IdnMapping class to convert Unicode domain names.
            strIn = Regex.Replace(strIn, @"(@)(.+)$", this.DomainMapper);
            if (invalid)
                return false;

            // Return true if strIn is in valid e-mail format.
            return Regex.IsMatch(strIn,
                   @"^(?("")(""[^""]+?""@)|(([0-9a-z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-z])@))" +
                   @"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-z][-\w]*[0-9a-z]*\.)+[a-z0-9]{2,17}))$",
                   RegexOptions.IgnoreCase);
        }

        private string DomainMapper(Match match)
        {
            // IdnMapping class with default property values.
            IdnMapping idn = new IdnMapping();

            string domainName = match.Groups[2].Value;
            try
            {
                domainName = idn.GetAscii(domainName);
            }
            catch (ArgumentException)
            {
                invalid = true;
            }
            return match.Groups[1].Value + domainName;
        }
    }

    public class EmailServices
    {
        private const string JangoUser = "careblue";
        private const string JangoPass = "Broadway1133";

        public static decimal EmailTransactionID { get; set; }
        public static int EmailCode { get; set; }

        //Sub - Methods:
        private static bool UploadAttachment(string filePath, string fileName, JangoMailSoapClient jangoMail)
        {
            bool isFileUploded;

            if (!Directory.Exists(filePath)) return false;
            using (var fileStream = File.OpenRead(filePath + fileName))
            {
                var memoryStream = new MemoryStream();
                memoryStream.SetLength(fileStream.Length);
                fileStream.Read(memoryStream.GetBuffer(), 0, (int)fileStream.Length);
                var result = jangoMail.UploadAttachment(JangoUser, JangoPass, memoryStream.GetBuffer(), fileName, true);
                isFileUploded = result.Split()[1] == "SUCCESS";
            }

            return isFileUploded;
        }

        private static void SaveEmailInformation(string fromEmail, string name, string toEmailAddress, string subject, string plainMessage, string htmlMessage, string ccEmail, string bccEmail, string options, int userID, int returnedValue, string returnedMessage, decimal returnedID, int flagException, string exceptionName, int? flagBounce, Nullable<int> PracticeID = null, Nullable<int> PatientID = null, Nullable<int> AccountID = null, Nullable<int> StatementID = null, Nullable<int> TransactionID = null, Nullable<int> NightlyLogID = null)
        {
            var cmdParam = new Dictionary<string, object>
                               {
                                   {"EmailLogID", null},
                                   {"FromEmail", fromEmail},
                                   {"FromName", name},
                                   {"ToEmailAddress", toEmailAddress},
                                   {"CCEmailAddress", ccEmail},
                                   {"BCCEmailAddress", bccEmail},
                                   {"Subject", subject},
                                   {"MessagePlain", plainMessage},
                                   {"MessageHTML", htmlMessage},
                                   {"Options", options},
                                   {"UserID", userID},
                                   {"ReturnValue", returnedValue},
                                   {"ReturnMsg", returnedMessage},
                                   {"ReturnID", returnedID},
                                   {"@FlagException", flagException},
                                   {"@ExceptionName", exceptionName},
                                   {"@FlagBounce", flagBounce},
                                   {"@PracticeID", PracticeID},
                                   {"@PatientID", PatientID},
                                   {"@AccountID", AccountID},
                                   {"@StatementID", StatementID},
                                   {"@TransactionID", TransactionID},
                                   {"@NightlyLogID", NightlyLogID}
                               };

            SqlHelper.ExecuteScalarProcedureParams("sys_email_add", cmdParam);
        }

        public static void SendTransactionEmail(string fromEmail, string name, string toEmailAddress, string subject, string plainMessage, string htmlMessage, string ccEmail, string bccEmail, string priority, Int32 userID, string attachmentPath, string fileName, Nullable<int> PracticeID = null, Nullable<int> PatientID = null, Nullable<int> AccountID = null, Nullable<int> StatementID = null, Nullable<int> TransactionID = null, Nullable<int> NightlyLogID = null)
        {
            bool receipt = false; //We probably won't ever used this, but if we decide to, we can move this up to be an input parameter. JHV 7/20/2013
            var options = "CC=" + ccEmail + ", BCC=" + bccEmail + ", Receipt=" + receipt + ", Priority=" + priority;
            try
            {
                var jangoMailSoapClient = new JangoMailSoapClient();

                if (!string.IsNullOrEmpty(attachmentPath))
                {
                    //UploadAttachment(attachmentPath, fileName, jangoMailSoapClient);
                    ftp ftpClient = new ftp(@"ftp://client.jangomail.com", JangoUser, JangoPass);
                    ftpClient.upload(@"Attachments/" + fileName, attachmentPath + fileName);
                    options += ",Attachment1=" + fileName;
                }
                RegexUtilities util = new RegexUtilities();
                if (String.IsNullOrEmpty(toEmailAddress)) { EmailCode = 2; return; } //(int)EmailCode.EmptyEmail
                if (!util.IsValidEmail(toEmailAddress)) { EmailCode = 3; return; } //(int)EmailCode.InvalidEmailAddress

                var transactionData = jangoMailSoapClient.SendTransactionalEmail(JangoUser, JangoPass, fromEmail, name, toEmailAddress, subject, plainMessage, htmlMessage, options);
                var data = transactionData.Split();
                var returnedValue = Convert.ToInt32(data[0]);
                var returnedMessage = data[1];
                EmailTransactionID = Convert.ToDecimal(data[2]);
                SaveEmailInformation(fromEmail, name, toEmailAddress, subject, plainMessage, htmlMessage, ccEmail, bccEmail, options, userID, returnedValue, returnedMessage, EmailTransactionID, 0, string.Empty, null, PracticeID, PatientID, AccountID, StatementID, TransactionID, NightlyLogID);
                EmailCode = 0; // 0 = success

                // Delete the uploaded File
                if (!string.IsNullOrEmpty(attachmentPath))
                {
                    ftp ftpClient = new ftp(@"ftp://client.jangomail.com", JangoUser, JangoPass);
                    ftpClient.delete(@"Attachments/" + fileName);
                }
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("BouncedEmailAddressException")) { EmailCode = (Int32)Enums.EmailCode.BouncedMail; }
                else if (ex.Message.Contains("InvalidBCCEmailException")) { EmailCode = (Int32)Enums.EmailCode.InvalidEmailAddress; }
                else if (ex.Message.Contains("InvalidEmailAddressException")) { EmailCode = (Int32)Enums.EmailCode.InvalidEmailAddress; }
                else if (ex.Message.Contains("NoAddressesSpecifiedException")) { EmailCode = (Int32)Enums.EmailCode.EmptyEmail; }
                else if (ex.Message.Contains("NoRecipientsException")) { EmailCode = (Int32)Enums.EmailCode.EmptyEmail; }
                else { EmailCode = (Int32)Enums.EmailCode.Unknown; }

                SaveEmailInformation(fromEmail, name, toEmailAddress, subject, plainMessage, htmlMessage, ccEmail,
                                     bccEmail, options, userID, 0, "Exception", EmailTransactionID, EmailCode,
                                     ex.Message.Split(':')[0], null, PracticeID, PatientID, AccountID, StatementID, TransactionID, NightlyLogID);
            }

        }

        //Error
        public static int SendRunTimeErrorEmail(string url, string errorType, string errorMessage, string stackTrace, string htmlErrorMessage, string userName, string patientName, string dateOfBirth, string practiceName, int userID, int PatientID, int PracticeID, string ipAddress, string SQLQuery)
        {
            try
            {
                #region EmailBodyHTML
                var messageBody = String.Format(@"
                                               <html>
                                               <body>
                                                 <h1>An Error Has Occurred!</h1>
                                                 <table cellpadding=""5"" cellspacing=""0"" border=""1"">
                                                 <tr>
                                                 <tdtext-align: right;font-weight: bold"">Timestamp:</td>
                                                 <td>{10}</td>
                                                 </tr>
                                                 <tr>
                                                 <tdtext-align: right;font-weight: bold"">UserName:</td>
                                                 <td>{0} ({7})</td>
                                                 </tr>
                                                 <tr>
                                                 <tdtext-align: right;font-weight: bold"">IP Address:</td>
                                                 <td>{13}</td>
                                                 </tr>
                                                 <tr>
                                                 <tdtext-align: right;font-weight: bold"">PatientName:</td>
                                                 <td>{1} [{11}] ({8})</td>
                                                 </tr>                                         
                                                 <tr>
                                                 <tdtext-align: right;font-weight: bold"">PracticeName:</td>
                                                 <td>{2} ({9})</td>
                                                 </tr>                                         
                                                 <tr>
                                                 <tdtext-align: right;font-weight: bold"">URL:</td>
                                                 <td>{3}</td>
                                                 </tr>
                                                 <tr>
                                                 <tdtext-align: right;font-weight: bold"">Exception Type:</td>
                                                 <td>{4}</td>
                                                 </tr>
                                                 <tr>
                                                 <tdtext-align: right;font-weight: bold"">SQL Query:</td>
                                                 <td>{12}</td>
                                                 </tr> 
                                                 <tr>
                                                 <tdtext-align: right;font-weight: bold"">Message:</td>
                                                 <td>{5}</td>
                                                 </tr>
                                                 <tr>
                                                 <tdtext-align: right;font-weight: bold"">Stack Trace:</td>
                                                 <td>{6}</td>
                                                 </tr> 
                                               </table>
                                               </body>
                                               </html>", userName, patientName, practiceName, url, errorType, errorMessage, stackTrace, userID, PatientID, PracticeID, DateTime.Now, dateOfBirth, SQLQuery, ipAddress);
                #endregion

                var ErrorLogID = LogErrors.SaveErrors(url, errorType, errorMessage, stackTrace, htmlErrorMessage, SQLQuery, userID, PracticeID, PatientID, ipAddress);
                EmailServices.SendTransactionEmail("no-reply@careblue.com", "CareBlue", "dev@careblue.com", "Run Time Error Has Occurred - ErrorID: " + ErrorLogID, messageBody + htmlErrorMessage, messageBody + htmlErrorMessage, string.Empty, string.Empty, string.Empty, userID, string.Empty, string.Empty, PracticeID, PatientID);

                return EmailServices.EmailCode;
            }
            catch
            {
                throw;
            }
        }

        //Password
        public static int SendResetPasswordLink(string UserEmail, string ResetLinkURLSuffix, string expiration, string firstName, string url, string resetLinkUserID)
        {
            try
            {
                #region EmailBodyHTML
                string messageBody = @"<html xmlns:v=""urn:schemas-microsoft-com:vml"" xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:w=""urn:schemas-microsoft-com:office:word"" xmlns:m=""http://schemas.microsoft.com/office/2004/12/omml"" xmlns=""http://www.w3.org/TR/REC-html40"">
                                        <head>
                                        <META HTTP-EQUIV=""Content-Type"" CONTENT=""text/html; charset=us-ascii"">
                                        <meta name=Generator content=""Microsoft Word 14 (filtered medium)"">
                                        <!--[if !mso]>
	                                        <style>v\:* {behavior:url(#default#VML);}
	                                        o\:* {behavior:url(#default#VML);}
	                                        w\:* {behavior:url(#default#VML);}
	                                        .shape {behavior:url(#default#VML);}
	                                        </style>
                                        <![endif]-->

                                        <title>CareBlue Password Reset Request</title>
                                        <style><!--
                                        /* Font Definitions */
                                        @font-face
	                                        {font-family:""Cambria Math"";
	                                        panose-1:2 4 5 3 5 4 6 3 2 4;}
                                        @font-face
	                                        {font-family:Calibri;
	                                        panose-1:2 15 5 2 2 2 4 3 2 4;}
                                        @font-face
	                                        {font-family:Tahoma;
	                                        panose-1:2 11 6 4 3 5 4 4 2 4;}
                                        /* Style Definitions */
                                        p.MsoNormal, li.MsoNormal, div.MsoNormal
	                                        {margin:0in;
	                                        margin-bottom:.0001pt;
	                                        font-size:12.0pt;
	                                        font-family:""Times New Roman"",""serif"";}
                                        a:link, span.MsoHyperlink
	                                        {mso-style-priority:99;
	                                        color:blue;
	                                        text-decoration:underline;}
                                        a:visited, span.MsoHyperlinkFollowed
	                                        {mso-style-priority:99;
	                                        color:purple;
	                                        text-decoration:underline;}
                                        p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	                                        {mso-style-priority:99;
	                                        mso-style-link:""Balloon Text Char"";
	                                        margin:0in;
	                                        margin-bottom:.0001pt;
	                                        font-size:8.0pt;
	                                        font-family:""Tahoma"",""sans-serif"";}
                                        span.BalloonTextChar
	                                        {mso-style-name:""Balloon Text Char"";
	                                        mso-style-priority:99;
	                                        mso-style-link:""Balloon Text"";
	                                        font-family:""Tahoma"",""sans-serif"";}
                                        span.EmailStyle19
	                                        {mso-style-type:personal;
	                                        font-family:""Calibri"",""sans-serif"";
	                                        color:#1F497D;}
                                        span.EmailStyle20
	                                        {mso-style-type:personal;
	                                        font-family:""Calibri"",""sans-serif"";
	                                        color:#002060;
	                                        font-weight:normal;
	                                        font-style:normal;}
                                        span.EmailStyle21
	                                        {mso-style-type:personal-reply;
	                                        font-family:""Calibri"",""sans-serif"";
	                                        color:#002060;
	                                        font-weight:normal;
	                                        font-style:normal;}
                                        .MsoChpDefault
	                                        {mso-style-type:export-only;
	                                        font-size:10.0pt;}
                                        @page WordSection1
	                                        {size:8.5in 11.0in;
	                                        margin:1.0in 1.0in 1.0in 1.0in;}
                                        div.WordSection1
	                                        {page:WordSection1;}
                                        --></style>

                                        <!--[if gte mso 9]>
	                                        <xml>
	                                        <o:shapedefaults v:ext=""edit"" spidmax=""1026"" />
	                                        </xml>
                                        <![endif]-->
                                        <!--[if gte mso 9]>
	                                        <xml>
	                                        <o:shapelayout v:ext=""edit"">
	                                        <o:idmap v:ext=""edit"" data=""1"" />
	                                        </o:shapelayout>
	                                        </xml>
                                        <![endif]-->
                                        </head>

                                        <body lang=EN-US link=blue vlink=purple>
	                                        <div class=WordSection1>
		                                        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=""98%"" style='width:98.0%;border-collapse:collapse'>
			                                        <tr><td style='padding:0in 0in 0in 0in'>
                                                        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=620 style='width:465.0pt;border-collapse:collapse'> 
                                                            <tr><td valign=bottom style='background:#3B5998;padding:3.75pt 15.0pt 3.75pt 15.0pt'>
                                                                <p class=MsoNormal><b>
                                                                    <span style='font-family:""Tahoma"",""sans-serif"";color:white;letter-spacing:-.35pt'>
                                                                    <span style='color:white;background:#3B5998;text-decoration:none'>CareBlue Provider Support</span><o:p></o:p>
                                                                    </span>
                                                                </b></p>
                                                            </td></tr>
                                                        </table>
                                                        <!--<p class=MsoNormal><span style='font-size:9.0pt;font-family:""Tahoma"",""sans-serif""'><o:p>&nbsp;</o:p></span></p>-->
                                                        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=620 style='width:465.0pt;border-collapse:collapse'>
                                                            <tr><td style='background:#F2F2F2;padding:0in 0in 0in 0in'>
                                                                <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 style='border-collapse:collapse'>
                                                                    <tr><td width=620 style='width:465.0pt;padding:0in 0in 0in 0in'>
                                                                        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=""100%"" style='width:100.0%;border-collapse:collapse'>
                                                                            <tr><td style='background:white;padding:15.0pt 15.0pt 15.0pt 15.0pt'>
                                                                                <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=""100%"" style='width:100.0%;border-collapse:collapse'>
                                                                                    <tr><td style='padding:0in 0in 3.0pt 0in'><p class=MsoNormal>
                                                                                        <span style='font-size:8.5pt;font-family:""Tahoma"",""sans-serif""'>Hi <span style='color:black'>[NameFirst]</span>,
                                                                                        <br><br>You recently requested to reset your CareBlue password.
                                                                                        <span style='color:#3B5998;text-decoration:none'><br></span>
                                                                                        <span style='color:#002060;text-decoration:none'><a href='[LinkChangePassword]'>Click here to change your password</a></span>
                                                                                        <br><br>To maintain the security of your account, you must initiate this change within 30 minutes.<o:p></o:p></span></p>
                                                                                    </td></tr>
                                                                                    <tr><td style='border:none;border-top:solid #E8E8E8 1.0pt;padding:4.5pt 0in 4.5pt 0in'>
                                                                                        <div><p class=MsoNormal><span style='font-size:8.5pt;font-family:""Tahoma"",""sans-serif""'>Request Expiration: <span style='color:black'>[ResetLinkURLExpireAbbr]</span><o:p></o:p></span></p></div>
                                                                                    </td></tr>
                                                                                    <tr><td style='border:none;border-top:solid #E8E8E8 1.0pt;padding:3.0pt 0in 0in 0in'>
                                                                                        <p class=MsoNormal><span style='font-size:6.0pt;font-family:""Calibri"",""sans-serif"";color:#002060'><o:p>&nbsp;</o:p></span></p>
                                                                                        <p class=MsoNormal><b><span style='font-size:8.5pt;font-family:""Tahoma"",""sans-serif""'>Didn't request this change?</span></b>
                                                                                            <span style='font-size:8.5pt;font-family:""Tahoma"",""sans-serif""'><br />If you didn't request a new password, please contact your practice administrator and
                                                                                        <span style='color:#0066FF'><a href='[LinkPracticeAdmin]'><span style='color:#002060;text-decoration:none'>let us know immediately</span></a>.</span><o:p></o:p></span></p>
                                                                                    </td></tr>
                                                                                </table>
                                                                            </td></tr>
                                                                        </table>
                                                                    </td></tr>
                                                                    <tr><td width=620 style='width:465.0pt;padding:0in 0in 0in 0in'>
                                                                        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=""100%"" style='width:100.0%;border-collapse:collapse'>
                                                                            <tr><td style='border-top:solid #CCCCCC 1.0pt;border-left:none;border-bottom:solid #CCCCCC 1.0pt;border-right:none;background:#F2F2F2;padding:5.25pt 15.0pt 5.25pt 15.0pt'>
                                                                                <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0>
                                                                                    <tr><td style='padding:0in 0in 0in 0in'>
                                                                                        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 style='border-collapse:collapse'>
                                                                                            <tr><td style='border:solid #29447E 1.0pt;border-bottom:solid #1A356E 1.0pt;background:#5B74A8;padding:0in 0in 0in 0in'>
                                                                                                <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 style='border-collapse:collapse'>
                                                                                                    <tr><td style='border:none;border-top:solid #8A9CC2 1.0pt;padding:1.5pt 4.5pt 3.0pt 4.5pt'>
                                                                                                        <p class=MsoNormal><span style='font-size:8.5pt;font-family:""Tahoma"",""sans-serif"";color:white'>
                                                                                                        <a style=""text-decoration:none;"" href='[LinkChangePassword]'><b><span style='color:white;'>Change Password</span></b></a></span>
                                                                                                        <span style='font-size:8.5pt;font-family:""Tahoma"",""sans-serif""'><o:p></o:p></span></p>
                                                                                                    </td></tr>
                                                                                                </table>
                                                                                            </td></tr>
                                                                                        </table>
                                                                                    </td></tr>
                                                                                </table>
                                                                            </td></tr>
                                                                        </table>
                                                                    </td></tr>
                                                                </table>
                                                            </td></tr>
                                                        </table>
                                                        <p class=MsoNormal><span style='font-size:6.0pt;font-family:""Tahoma"",""sans-serif"";display:none'><o:p>&nbsp;</o:p></span></p>
                                                        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=620 style='width:465.0pt;border-collapse:collapse'>
                                                            <tr><td style='background:white;padding:15.0pt 15.0pt 10.0pt 15.0pt'>
                                                                <p class=MsoNormal><span style='font-size:8.5pt;font-family:""Tahoma"",""sans-serif"";color:#7F7F7F'>This message was sent to <span style='color:#0066FF;'>[Email]</span> </span>
                                                                <span style='font-size:8.5pt;font-family:""Tahoma"",""sans-serif"";color:#002060'> </span>
                                                                <span style='font-size:8.5pt;font-family:""Tahoma"",""sans-serif"";color:#7F7F7F'>at your request.</span>
                                                                <span style='font-size:8.5pt;font-family:""Tahoma"",""sans-serif"";color:#999999'><br></span>
                                                                <span style='font-size:8.5pt;font-family:""Tahoma"",""sans-serif"";color:#999999'><o:p></o:p></span></p>
                                                            </td></tr>
                                                        </table>
                                                        </td></tr>
                                                </table>
                                                <p class=MsoNormal><o:p>&nbsp;</o:p></p>
                                            </div>
                                        </body>
                                        </html>";
                #endregion
                var linkChangePassword = url + "?u=" + resetLinkUserID + "&k=" + ResetLinkURLSuffix;
                var linkPracticeAdmin = url + "?u=" + resetLinkUserID + "&v=0";

                messageBody = messageBody.Replace("[NameFirst]", firstName);
                messageBody = messageBody.Replace("[ResetLinkURLExpireAbbr]", expiration);
                messageBody = messageBody.Replace("[Email]", UserEmail);
                messageBody = messageBody.Replace("[LinkChangePassword]", linkChangePassword);
                messageBody = messageBody.Replace("[LinkPracticeAdmin]", linkPracticeAdmin);

                SendTransactionEmail("support@careblue.com", "CareBlue Provider Support", UserEmail, "Your Password Reset Request", messageBody, messageBody, string.Empty, string.Empty, string.Empty, (Int32)Enums.ServiceInfo.UserID, string.Empty, string.Empty);
                return EmailCode;
            }
            catch
            {
                throw;
            }
        }

        //Payment Receipt
        public static int SendPaymentReceipt(string paymentAmount, string paymentNumber, string PracticeAddr, string FSPBillAs, string paymentMethod, string patientInfo, string PatientEmail, Dictionary<string, string> logoDetails, Int32 UserID, string cardType, string practiceName, string statementID, string patientBalanceSum, bool flagFspTrans, string practicePhoneBilling, Nullable<int> PracticeID = null, Nullable<int> PatientID = null, Nullable<int> AccountID = null, Nullable<int> TransactionID = null, Nullable<int> NightlyLogID = null)
        {
            try
            {
                var reader = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", new Dictionary<string, object>());
                var PatientLegalURL = "";
                foreach (DataRow row in reader.Rows)
                {
                    PatientLegalURL = row["WebPathRootPatient"] + "terms/financial.htm";
                }

                #region EmailBodyHTML
                string messageBody = @"<table width=""500"" cellspacing=""0"" cellpadding=""0"" border=""0"" style=""width: 335.0pt;""> 
                    <tbody>
                        <tr>
                            <td style=""padding: 0in 0in 0in 0in"">
                                <div style=""margin-bottom: 5px;"">
                                    <img src=""[LogoURL]"" alt=""Logo"" height=""[Height]"" width=""200"" />
                                </div>
                                <span style=""font-size: 10pt; font-family: tahoma;"">[PracticeName]</span><br />
                                <span style=""font-size: 10pt; font-family: tahoma;"">[PracticeAddr]</span><br />
                                <span style=""font-size: 10pt; font-family: tahoma;"">Billing Inquiries: [PhoneBillingAbbr]</span>
                                <div style=""border: none; border-bottom: solid black 2.25pt; padding: 0in 0in 2.0pt 0in;
                                    margin-top: 7.5pt; margin-bottom: 3.75pt"">
                                    <p style=""margin-top: 15.0pt; line-height: 13.5pt"" class=""MsoNormal"">
                                        <b><span style=""font-size: 12pt; font-family: tahoma;"">
                                            Payment Confirmation<u></u><u></u></span></b></p>
                                </div>
                                <div style=""border: none; border-bottom: dashed #b75400 1.0pt; padding: 0in 0in 19.0pt 0in"">
                                    <table cellspacing=""0"" cellpadding=""0"" border=""0"">
                                        <tbody>
                                            <tr>
                                                <td valign=""top"" nowrap="""" style=""padding: 0in 0in 0in 0in"">
                                                    <p style=""line-height: 13.5pt"" class=""MsoNormal"">
                                                        <span style=""font-size: 10pt; font-family: tahoma;"">
                                                            <b>Statement:</b> [StatementId]<br>
                                                            <b>Amount:</b> <span> [PaymentAmount]</span><br>
                                                            <b>Date:</b> [Date]<br>
                                                            <b>Ref Number:</b> [PaymentNumber]<br>
                                                            <b>Type:</b> [paymentMethod] [PaymentCard]<br>
                                                            <b>Balance:</b> [PatientBalSum$]<br> 
                                                            <br>[Text]<br>
                                                        <u></u><u></u></span></p>
                                                </td>
                                                <td width=""100%"" style=""width: 100.0%; padding: 0in 0in 0in 0in"">
                                                    <p class=""MsoNormal"">
                                                        &nbsp;<u></u><u></u></p>
                                                </td>
                                                <td valign=""top"" nowrap="""" style=""padding: 0in 0in 0in 7.5pt"">
                                                    <p style=""line-height: 13.5pt"" class=""MsoNormal"">
                                                        <span style=""font-size: 10pt; font-family: tahoma;"">
                                                           [PatientInformation]
                                                            <br>
                                                            <u></u><u></u></span>
                                                    </p>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div style=""margin-top: 15.0pt"">
                                    <p style=""margin-top: 15.0pt; line-height: 13.5pt"" class=""MsoNormal"">
                                        <span style=""font-size: 9pt; font-family: tahoma;"">Please retain this receipt for your records.</span>
                                            <b><span style=""font-size: 12pt; font-family: tahoma; ""><br></span></b>
                                            <span style=""font-size: 9pt; font-family: tahoma;""><a target=""_blank"" href=""[PatientLegalURL]"">
                                                    <span style="""">Payment Terms and Conditions</span></a><u></u><u></u></span>
                                    </p>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>";
                #endregion

                messageBody = messageBody.Replace("[PaymentAmount]", paymentAmount);
                messageBody = messageBody.Replace("[TotalPayment]", paymentAmount);
                messageBody = messageBody.Replace("[PracticeAddr]", PracticeAddr);
                messageBody = messageBody.Replace("[PaymentNumber]", paymentNumber);
                messageBody = messageBody.Replace("[paymentMethod]", paymentMethod);
                messageBody = messageBody.Replace("[Date]", DateTime.Now.ToString());
                messageBody = messageBody.Replace("[PatientLegalURL]", PatientLegalURL);
                messageBody = messageBody.Replace("[PatientInformation]", patientInfo);
                messageBody = messageBody.Replace("[PracticeName]", practiceName);
                messageBody = messageBody.Replace("[PhoneBillingAbbr]", practicePhoneBilling);
                messageBody = messageBody.Replace("[StatementId]", statementID);
                messageBody = messageBody.Replace("[PatientBalSum$]", patientBalanceSum);

                if (!flagFspTrans)
                {
                    messageBody = messageBody.Replace("[Text]", string.Empty);
                    messageBody = messageBody.Replace("[PaymentCard]", string.Empty);
                }
                else
                {
                    messageBody = messageBody.Replace("[Text]", string.Format("This charge will appear on your financial statement from:<b>  {0}</b>", FSPBillAs));
                    messageBody = messageBody.Replace("[PaymentCard]", string.Format("<br><b>Payment Card:</b> {0}", cardType));
                }

                string value;
                // Trying to pass the logo details
                logoDetails.TryGetValue("PracticeLogo", out value);
                messageBody = messageBody.Replace("[LogoURL]", value);
                logoDetails.TryGetValue("PracticeLogoHeight", out value);
                messageBody = messageBody.Replace("[Height]", value);

                SendTransactionEmail("no-reply@careblue.com", "Healthcare Payments", PatientEmail, "Your Payment Confirmation", messageBody, messageBody, string.Empty, string.Empty, string.Empty, UserID, string.Empty, string.Empty, PracticeID, PatientID, AccountID, Convert.ToInt32(statementID), TransactionID, NightlyLogID);
                return EmailCode;
            }
            catch
            {
                throw;
            }
        }
        public static int SendPaymentReceiptbyID(Int32 TransID, Int32 UserID)
        {
            try
            {
                var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pt_payment_receipt", new Dictionary<string, object> { { "@TransactionID", TransID } });
                foreach (DataRow row in reader.Rows)
                {
                    var statementInfo = row["PracticeAddrDesc"].ToString();
                    var logoDetails = new Dictionary<string, string>
                                    {
                                        { "PracticeLogo", row["PracticeLogo"].ToString() },
                                        { "Width", row["PracticeLogoWidth"].ToString() },
                                        { "PracticeLogoHeight", row["PracticeLogoHeight"].ToString() }
                                    };

                    var isFlagfspTrans = row["FlagFSPTrans"].ToString() == "1";
                    SendPaymentReceipt(row["Amount$"].ToString(), row["StatementID"].ToString() + '-' + TransID.ToString(""), statementInfo, row["FSPBillAs"].ToString(), row["PaymentMethod"].ToString(), row["PatientHTML"].ToString(), row["PatientEmail"].ToString(), logoDetails, UserID, row["PaymentCardDesc"].ToString(), row["PracticeName"].ToString(), row["StatementID"].ToString(), row["PatientBalSum$"].ToString(), isFlagfspTrans, row["PhoneBillingAbbr"].ToString(), Convert.ToInt32(row["PracticeID"]), Convert.ToInt32(row["PatientID"]), Convert.ToInt32(row["AccountID"]), Convert.ToInt32(row["TransactionID"]));
                }
                return EmailCode;
            }
            catch
            {
                throw;
            }
        }

        //Statement
        public static int SendStatement(int? NightlyLogID, DataRow dataRow)
        {
            try
            {
                string PatientLoginURL = ""; string PatientLegalURL = "";
                var reader = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", new Dictionary<string, object>());
                foreach (DataRow row in reader.Rows)
                {
                    PatientLoginURL = row["WebPathRootPatient"] + "login.aspx";
                    PatientLegalURL = row["WebPathRootPatient"] + "terms/privacy.htm";
                }
                var accountID = CryptorEngine.Encrypt(dataRow["AccountID"].ToString());
                var statementID = CryptorEngine.Encrypt(dataRow["StatementID"].ToString());
                var firstName = dataRow["NameFirst"].ToString();
                var lastName = dataRow["NameLast"].ToString();
                var practiceName = dataRow["PracticeName"].ToString();

                PatientLoginURL += string.Format("?aid={0}&sid={1}&fn={2}&ln={3}&pn={4}", accountID, statementID, firstName, lastName, practiceName);

                #region EmailBodyHTML
                string messageBody = @"<table width=""500"" cellspacing=""0"" cellpadding=""0"" border=""0"" style=""width: 335.0pt;""> 
                <tbody>
                    <tr>
                        <td style=""padding: 0in 0in 0in 0in"">
                            <div style=""margin-bottom: 5px;"">
                                <img src=""[PracticeLogo]"" alt=""Logo"" height=""[PracticeLogoHeight]"" width=""200"" />
                            </div>
                            <span style=""font-size: 10pt; font-family: tahoma;"">[PracticeName]</span><br />
                            <span style=""font-size: 10pt; font-family: tahoma;"">[PracticeAddrDesc]</span><br />
                            <span style=""font-size: 10pt; font-family: tahoma;"">Billing Inquiries: [PhoneBillingAbbr]</span>
                            <div style=""border: none; border-bottom: solid black 2.25pt; padding: 0in 0in 2.0pt 0in;
                                margin-top: 7.5pt; margin-bottom: 3.75pt"">
                                <p style=""margin-top: 15.0pt; line-height: 13.5pt"" class=""MsoNormal"">
                                    <b><span style=""font-size: 12pt; font-family: tahoma;"">
                                        Statement Notification<u></u><u></u></span></b></p>
                            </div>
                            <div style=""border: none; border-bottom: dashed #b75400 1.0pt; padding: 0in 0in 19.0pt 0in"">
                                <table cellspacing=""0"" cellpadding=""0"" border=""0"">
                                    <tbody>
                                        <tr>
                                            <td colspan=3>
                                                <span style=""font-size: 9pt; font-family: tahoma; line-height: 13.5pt"" class=""MsoNormal"">
                                                    The most recent statement for your account is now available as an attachment
                                                    Please note that this statement includes an important notice about your account.
                                                    You may <a href='[PatientLoginURL]'>view your statements online</a> at any time.
                                                    </br>&nbsp;
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign=""top"" nowrap="""" style=""padding: 0in 0in 0in 0in"">
                                                <p style=""line-height: 13.5pt"" class=""MsoNormal"">
                                                    <span style=""font-size: 10pt; font-family: tahoma;"">
                                                        <b>Statement:</b> [StatementID]<br>
                                                        <b>Date:</b> [StatementDate]<br>
                                                        <br>
                                                    <u></u><u></u></span></p>
                                            </td>
                                            <td width=""100%"" style=""width: 100.0%; padding: 0in 0in 0in 0in"">
                                                <p class=""MsoNormal"">
                                                    &nbsp;<u></u><u></u></p>
                                            </td>
                                            <td valign=""top"" nowrap="""" style=""padding: 0in 0in 0in 7.5pt"">
                                                <p style=""line-height: 13.5pt"" class=""MsoNormal"">
                                                    <span style=""font-size: 10pt; font-family: tahoma;"">
                                                       [PatientAddress]
                                                        <br>
                                                        <u></u><u></u></span>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div style=""margin-top: 15.0pt"">
                                <p style=""margin-top: 15.0pt; line-height: 13.5pt"" class=""MsoNormal"">
                                    <span style=""font-size: 9pt; font-family: tahoma;"">Please do not reply to this email, instead call your provider directly with any questions. Information on maintaining your privacy can be found on our privacy page.</span>
                                        <span style=""font-size: 9pt; font-family: tahoma;""><a target=""_blank"" href=""[PatientLegalURL]"">
                                                <span style="""">Privacy Terms and Conditions</span></a><u></u><u></u></span>
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>";

                #endregion

                messageBody = messageBody.Replace("[PracticeName]", dataRow["PracticeName"].ToString());
                messageBody = messageBody.Replace("[LocationName]", dataRow["LocationName"].ToString());
                messageBody = messageBody.Replace("[PracticeLogo]", dataRow["PracticeLogo"].ToString());
                messageBody = messageBody.Replace("[PracticeLogoWidth]", dataRow["PracticeLogoWidth"].ToString());
                messageBody = messageBody.Replace("[PracticeLogoHeight]", dataRow["PracticeLogoHeight"].ToString());
                messageBody = messageBody.Replace("[PracticeAddrDesc]", dataRow["PracticeAddrDesc"].ToString());
                messageBody = messageBody.Replace("[PhoneBillingAbbr]", dataRow["PhoneBillingAbbr"].ToString());
                messageBody = messageBody.Replace("[PatientAddress]", dataRow["PatientHTML"].ToString());
                messageBody = messageBody.Replace("[PatientLoginURL]", PatientLoginURL);
                messageBody = messageBody.Replace("[PatientLegalURL]", PatientLegalURL);
                messageBody = messageBody.Replace("[StatementID]", dataRow["StatementID"].ToString());
                messageBody = messageBody.Replace("[StatementDate]", dataRow["StatementDateAbbr"].ToString());
                messageBody = messageBody.Replace("[WebPathRootProvider]", dataRow["WebPathRootProvider"].ToString());

                SendTransactionEmail("no-reply@careblue.com", "Healthcare Statement", dataRow["PatientEmail"].ToString(), "Your Healthcare Statement", messageBody, messageBody, string.Empty, string.Empty, string.Empty, (Int32)Enums.ServiceInfo.UserID, dataRow["DefaultPath"].ToString(), dataRow["FileName"].ToString(), Convert.ToInt32(dataRow["PracticeID"]), Convert.ToInt32(dataRow["PatientID"]), Convert.ToInt32(dataRow["AccountID"]), Convert.ToInt32(dataRow["StatementID"]), null, NightlyLogID);
                return EmailCode;
            }
            catch
            {
                throw;
            }
        }

        // Payment Reminder -- MAY NO LONGER BE USED, NEED TO CHECK
        public static Int32 SendPaymentReminder(int? NightlyLogID, DataRow dataRow)
        {
            try
            {
                string PatientLoginURL = ""; string PatientLegalURL = "";
                var reader = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", new Dictionary<string, object>());
                foreach (DataRow row in reader.Rows)
                {
                    PatientLoginURL = row["WebPathRootPatient"] + "login.aspx";
                    PatientLegalURL = row["WebPathRootPatient"] + "terms/privacy.htm";
                }

                var accountID = CryptorEngine.Encrypt(dataRow["AccountID"].ToString());
                var statementID = CryptorEngine.Encrypt(dataRow["StatementID"].ToString());
                var firstName = dataRow["NameFirst"].ToString();
                var lastName = dataRow["NameLast"].ToString();
                var practiceName = dataRow["PracticeName"].ToString();

                PatientLoginURL += string.Format("?aid={0}&sid={1}&fn={2}&ln={3}&pn={4}", accountID, statementID, firstName, lastName, practiceName);

                #region EmailBodyHTML
                string messageBody = @"<table width=""500"" cellspacing=""0"" cellpadding=""0"" border=""0"" style=""width: 335.0pt;""> 
                <tbody>
                    <tr>
                        <td style=""padding: 0in 0in 0in 0in"">
                            <div style=""margin-bottom: 5px;"">
                                <img src=""[PracticeLogo]"" alt=""Logo"" height=""[PracticeLogoHeight]"" width=""200"" />
                            </div>
                            <span style=""font-size: 10pt; font-family: tahoma;"">[PracticeName]</span><br />
                            <span style=""font-size: 10pt; font-family: tahoma;"">[PracticeAddrDesc]</span><br />
                            <span style=""font-size: 10pt; font-family: tahoma;"">Billing Inquiries: [PhoneBillingAbbr]</span>
                            <div style=""border: none; border-bottom: solid black 2.25pt; padding: 0in 0in 2.0pt 0in;
                                margin-top: 7.5pt; margin-bottom: 3.75pt"">
                                <p style=""margin-top: 15.0pt; line-height: 13.5pt"" class=""MsoNormal"">
                                    <b><span style=""font-size: 12pt; font-family: tahoma;"">
                                        Statement Notification<u></u><u></u></span></b></p>
                            </div>
                            <div style=""border: none; border-bottom: dashed #b75400 1.0pt; padding: 0in 0in 19.0pt 0in"">
                                <table cellspacing=""0"" cellpadding=""0"" border=""0"">
                                    <tbody>
                                        <tr>
                                            <td colspan=3>
                                                <span style=""font-size: 9pt; font-family: tahoma; line-height: 13.5pt"" class=""MsoNormal"">
                                                    The most recent statement for your account is now available as an attachment
                                                    Please note that this statement includes an important notice about your account.
                                                    You may <a href='[PatientLoginURL]'>view your statements online</a> at any time.
                                                    </br>&nbsp;
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign=""top"" nowrap="""" style=""padding: 0in 0in 0in 0in"">
                                                <p style=""line-height: 13.5pt"" class=""MsoNormal"">
                                                    <span style=""font-size: 10pt; font-family: tahoma;"">
                                                        <b>Statement:</b> [StatementID]<br>
                                                        <b>Date:</b> [StatementDate]<br>
                                                        <br>
                                                    <u></u><u></u></span></p>
                                            </td>
                                            <td width=""100%"" style=""width: 100.0%; padding: 0in 0in 0in 0in"">
                                                <p class=""MsoNormal"">
                                                    &nbsp;<u></u><u></u></p>
                                            </td>
                                            <td valign=""top"" nowrap="""" style=""padding: 0in 0in 0in 7.5pt"">
                                                <p style=""line-height: 13.5pt"" class=""MsoNormal"">
                                                    <span style=""font-size: 10pt; font-family: tahoma;"">
                                                       [PatientAddress]
                                                        <br>
                                                        <u></u><u></u></span>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div style=""margin-top: 15.0pt"">
                                <p style=""margin-top: 15.0pt; line-height: 13.5pt"" class=""MsoNormal"">
                                    <span style=""font-size: 9pt; font-family: tahoma;"">Please do not reply to this email, instead call your provider directly with any questions. Information on maintaining your privacy can be found on our privacy page.</span>
                                        <span style=""font-size: 9pt; font-family: tahoma;""><a target=""_blank"" href=""[PatientLegalURL]"">
                                                <span style="""">Privacy Terms and Conditions</span></a><u></u><u></u></span>
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>";

                #endregion

                messageBody = messageBody.Replace("[PracticeName]", dataRow["PracticeName"].ToString());
                messageBody = messageBody.Replace("[LocationName]", dataRow["LocationName"].ToString());
                messageBody = messageBody.Replace("[PracticeLogo]", dataRow["PracticeLogo"].ToString());
                messageBody = messageBody.Replace("[PracticeLogoWidth]", dataRow["PracticeLogoWidth"].ToString());
                messageBody = messageBody.Replace("[PracticeLogoHeight]", dataRow["PracticeLogoHeight"].ToString());
                messageBody = messageBody.Replace("[PracticeAddrDesc]", dataRow["PracticeAddrDesc"].ToString());
                messageBody = messageBody.Replace("[PhoneBillingAbbr]", dataRow["PhoneBillingAbbr"].ToString());
                messageBody = messageBody.Replace("[PatientAddress]", dataRow["PatientHTML"].ToString());
                messageBody = messageBody.Replace("[PatientLoginURL]", PatientLoginURL);
                messageBody = messageBody.Replace("[PatientLegalURL]", PatientLegalURL);
                messageBody = messageBody.Replace("[StatementID]", dataRow["StatementID"].ToString());
                messageBody = messageBody.Replace("[StatementDate]", dataRow["StatementDate"].ToString());
                messageBody = messageBody.Replace("[WebPathRootProvider]", dataRow["WebPathRootProvider"].ToString());

                SendTransactionEmail("no-reply@careblue.com", "Healthcare Payment Reminder", dataRow["PatientEmail"].ToString(), "Your Healthcare Statement", messageBody, messageBody, string.Empty, string.Empty, string.Empty, (Int32)Enums.ServiceInfo.UserID, dataRow["DefaultPath"].ToString(), dataRow["FileName"].ToString(), Convert.ToInt32(dataRow["PracticeID"]), Convert.ToInt32(dataRow["PatientID"]), Convert.ToInt32(dataRow["AccountID"]), Convert.ToInt32(dataRow["StatementID"]), null, NightlyLogID);
                return EmailCode;
            }
            catch
            {
                throw;
            }
        }

        //Refund Receipt
        public static int SendRefundReceipt(string refundNumber, Int32 userID, DataRow dataRow)
        {
            try
            {
                string PatientLegalURL = "";
                var reader = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", new Dictionary<string, object>());

                foreach (DataRow row in reader.Rows)
                {
                    PatientLegalURL = row["WebPathRootPatient"] + "terms/financial.htm";
                }

                #region EmailBodyHTML
                var messageBody = @"<table width=""500"" cellspacing=""0"" cellpadding=""0"" border=""0"" style=""width: 335.0pt;""> 
                <tbody>
                    <tr>
                        <td style=""padding: 0in 0in 0in 0in"">
                            <div style=""margin-bottom: 5px;"">
                                <img src=""[LogoURL]"" alt=""Logo"" height=""[Height]"" width=""200"" />
                            </div>
                            <span style=""font-size: 10pt; font-family: tahoma;"">[PracticeName]</span> <br />
                            <span style=""font-size: 10pt; font-family: tahoma;"">[PracticeAddr]</span> <br />
                            <span style=""font-size: 10pt; font-family: tahoma;"">Billing Inquiries: [PhoneBillingAbbr]</span>
                            <div style=""border: none; border-bottom: solid black 2.25pt; padding: 0in 0in 2.0pt 0in;
                                margin-top: 7.5pt; margin-bottom: 3.75pt"">
                                <p style=""margin-top: 15.0pt; line-height: 13.5pt"" class=""MsoNormal"">
                                    <b><span style=""font-size: 12pt; font-family: tahoma;"">
                                        Refund Confirmation<u></u><u></u></span></b></p>
                            </div>
                            <div style=""border: none; border-bottom: dashed #b75400 1.0pt; padding: 0in 0in 19.0pt 0in"">
                                <table cellspacing=""0"" cellpadding=""0"" border=""0"">
                                    <tbody>
                                        <tr>
                                            <td valign=""top"" nowrap="""" style=""padding: 0in 0in 0in 0in"">

                                                <span style=""line-height: 13.5pt; font-size: 10pt; font-family: tahoma;"" class=""MsoNormal"">
                                                        Hello [PatientName],
                                                        <br>Your refund has been processed and a credit back to your 
                                                        <br>original form of payment is pending. Please allow 7-10 days 
                                                        <br>for a credit to appear on your account.
                                                        <br>
                                                    <u></u><u></u></span>
                                                </p>

                                                <p style=""line-height: 13.5pt"" class=""MsoNormal"">
                                                    <span style=""font-size: 10pt; font-family: tahoma;"">
                                                        <b>Refund Amount:</b> 
                                                            <span> [RefundAmount]</span><br>
                                                        <b>Refund Date:</b> [Date]<br>
                                                        <b>Refund Number:</b> [RefundNumber]<br>
                                                        <b>Refund Type:</b> [RefundMethod]<br>
                                                        <br>
                                                        This credit will appear on your financial statement from:<b> [FSPBillAs]</b><br>
                                                    <u></u><u></u></span>
                                                </p>
                                            </td>
                                            <td width=""100%"" style=""width: 100.0%; padding: 0in 0in 0in 0in"">
                                                <p class=""MsoNormal"">
                                                    &nbsp;<u></u><u></u></p>
                                            </td>
                                            <td valign=""top"" nowrap="""" style=""padding: 0in 0in 0in 7.5pt"">
                                                <p style=""line-height: 13.5pt"" class=""MsoNormal"">
                                                    <span style=""font-size: 10pt; font-family: tahoma;"">
                                                       [PatientInformation]
                                                        <br>
                                                        <u></u><u></u></span>
                                                </p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div style=""margin-top: 15.0pt"">
                                <p style=""margin-top: 15.0pt; line-height: 13.5pt"" class=""MsoNormal"">
                                    <span style=""font-size: 9pt; font-family: tahoma;"">Please retain this receipt for your records.</span>
                                        <b><span style=""font-size: 12pt; font-family: tahoma; ""><br></span></b>
                                        <span style=""font-size: 9pt; font-family: tahoma;""><a target=""_blank"" href=""[PatientLegalURL]"">
                                                <span style="""">Payment Terms and Conditions</span></a><u></u><u></u></span>
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>";
                #endregion

                messageBody = messageBody.Replace("[RefundAmount]", dataRow["Amount$"].ToString());
                messageBody = messageBody.Replace("[TotalRefund]", dataRow["Amount$"].ToString());
                messageBody = messageBody.Replace("[FSPBillAs]", dataRow["FSPBillAs"].ToString());
                messageBody = messageBody.Replace("[RefundNumber]", refundNumber);
                messageBody = messageBody.Replace("[RefundMethod]", dataRow["PaymentCardDesc"].ToString());
                messageBody = messageBody.Replace("[Date]", DateTime.Now.ToString());
                messageBody = messageBody.Replace("[PatientName]", dataRow["NameFirst"].ToString());
                messageBody = messageBody.Replace("[CardType]", dataRow["PaymentCardDesc"].ToString());
                messageBody = messageBody.Replace("[PatientInformation]", dataRow["PatientHTML"].ToString());
                messageBody = messageBody.Replace("[PatientLegalURL]", PatientLegalURL);
                messageBody = messageBody.Replace("[PracticeAddr]", dataRow["PracticeAddrDesc"].ToString());
                messageBody = messageBody.Replace("[PracticeName]", dataRow["PracticeName"].ToString());
                messageBody = messageBody.Replace("[PhoneBillingAbbr]", dataRow["PracticePhone"].ToString());
                messageBody = messageBody.Replace("[LogoURL]", dataRow["PracticeLogo"].ToString());
                messageBody = messageBody.Replace("[Width]", dataRow["PracticeLogoWidth"].ToString());
                messageBody = messageBody.Replace("[Height]", dataRow["PracticeLogoHeight"].ToString());

                SendTransactionEmail("no-reply@careblue.com", "Healthcare Payments", dataRow["PatientEmail"].ToString(), "Your Refund Confirmation", string.Empty, messageBody, string.Empty, string.Empty, string.Empty, userID, string.Empty, string.Empty, Convert.ToInt32(dataRow["PracticeID"]), Convert.ToInt32(dataRow["PatientID"]), Convert.ToInt32(dataRow["AccountID"]), Convert.ToInt32(dataRow["StatementID"]), Convert.ToInt32(dataRow["TransactionID"]), null);
                return EmailCode;
            }
            catch
            {
                throw;
            }
        }
        public static int SendRefundReceiptbyID(Int32 TransID, Int32 userID)
        {
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pt_payment_receipt", new Dictionary<string, object> { { "@TransactionID", TransID } });

            var refundNumber = reader.Rows[0]["StatementID"].ToString() + '-' + TransID;
            SendRefundReceipt(refundNumber, userID, reader.Rows[0]);

            return EmailCode;
        }

        // Forward Message
        public static int SendMessageFwd(int messageID, int practiceID, string userName, int userID, string messageSubject, string messageDate, string messageNote, string messageBody, string messageType, string messagePriority, string messagePatient, string messageProvider, string messagePractice, string messageURL, string messageToAddress, string messageFromAddress, string messageFromSubject, string ipAddress)
        {
            try
            {
                #region EmailBodyHTML
                var template = String.Format(@"
                                       <html>
                                       <body>
                                         <h1>Message details are as follows:</h1>
                                         <table cellpadding=""5"" cellspacing=""0"" border=""1"">
                                         <tr>
                                         <td text-align: right;font-weight: bold"">MessageID:</td>
                                         <td>{0}</td>
                                         </tr>
                                         <tr>
                                         <td text-align: right;font-weight: bold"">PracticeID:</td>
                                         <td>{1}</td>
                                         </tr>
                                         <tr>
                                         <td text-align: right;font-weight: bold"">UserName:</td>
                                         <td>{2}</td>
                                         </tr>
                                         <tr>
                                         <td text-align: right;font-weight: bold"">Subject:</td>
                                         <td>{3}</td>
                                         </tr>
                                         <tr>
                                         <td text-align: right;font-weight: bold"">Note:</td>
                                         <td>{4}</td>
                                         </tr>                                         
                                         <tr>
                                         <td text-align: right;font-weight: bold"">Message:</td>
                                         <td>{5}</td>
                                         </tr>                                         
                                         <tr>
                                         <td text-align: right;font-weight: bold"">Type:</td>
                                         <td>{6}</td>
                                         </tr>
                                         <tr>
                                         <td text-align: right;font-weight: bold"">Priority:</td>
                                         <td>{7}</td>
                                         </tr>
                                         <tr>
                                         <td text-align: right;font-weight: bold"">Patient:</td>
                                         <td>{8}</td>
                                         </tr> 
                                         <tr>
                                         <td text-align: right;font-weight: bold"">Provider:</td>
                                         <td>{9}</td>
                                         </tr>
                                         <tr>
                                         <td text-align: right;font-weight: bold"">Practice:</td>
                                         <td>{10}</td>
                                         </tr> 
                                         <tr>
                                         <td text-align: right;font-weight: bold"">URL:</td>
                                         <td>{11}</td>
                                         </tr>
                                         <tr>
                                         <td text-align: right;font-weight: bold"">IpAddress:</td>
                                         <td>{12}</td>
                                         </tr>
                                         </table> 
                                       </body>
                                       </html>", messageID, practiceID, userName, messageSubject, messageNote, messageBody, messageType, messagePriority, messagePatient, messageProvider, messagePractice, messageURL, ipAddress);
                #endregion

                EmailServices.SendTransactionEmail(messageFromAddress, "Careblue", messageToAddress, messageFromSubject, string.Empty, template, string.Empty, string.Empty, string.Empty, userID, string.Empty, string.Empty);
                return EmailServices.EmailCode;
            }
            catch
            {
                throw;
            }
        }



        public static void SendCreditPracticeNotificationEmail(Dictionary<string, string> fields)
        {
            #region EmailBodyHTML


            string messageBody = @"<html xmlns:v=""urn:schemas-microsoft-com:vml"" xmlns:o=""urn:schemas-microsoft-com:office:office"" xmlns:w=""urn:schemas-microsoft-com:office:word"" xmlns:m=""http://schemas.microsoft.com/office/2004/12/omml"" xmlns=""http://www.w3.org/TR/REC-html40"">
                                        <head>
                                        <META HTTP-EQUIV=""Content-Type"" CONTENT=""text/html; charset=us-ascii"">
                                        <meta name=Generator content=""Microsoft Word 14 (filtered medium)"">
                                        <!--[if !mso]>
	                                        <style>v\:* {behavior:url(#default#VML);}
	                                        o\:* {behavior:url(#default#VML);}
	                                        w\:* {behavior:url(#default#VML);}
	                                        .shape {behavior:url(#default#VML);}
	                                        </style>
                                        <![endif]-->

                                        <title>You Have a New Website Lead</title>
                                        <style><!--
                                        /* Font Definitions */
                                        @font-face
	                                        {font-family:""Cambria Math"";
	                                        panose-1:2 4 5 3 5 4 6 3 2 4;}
                                        @font-face
	                                        {font-family:Calibri;
	                                        panose-1:2 15 5 2 2 2 4 3 2 4;}
                                        @font-face
	                                        {font-family:Tahoma;
	                                        panose-1:2 11 6 4 3 5 4 4 2 4;}
                                        /* Style Definitions */
                                        p.MsoNormal, li.MsoNormal, div.MsoNormal
	                                        {margin:0in;
	                                        margin-bottom:.0001pt;
	                                        font-size:12.0pt;
	                                        font-family:""Times New Roman"",""serif"";}
                                        a:link, span.MsoHyperlink
	                                        {mso-style-priority:99;
	                                        color:blue;
	                                        text-decoration:underline;}
                                        a:visited, span.MsoHyperlinkFollowed
	                                        {mso-style-priority:99;
	                                        color:purple;
	                                        text-decoration:underline;}
                                        p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	                                        {mso-style-priority:99;
	                                        mso-style-link:""Balloon Text Char"";
	                                        margin:0in;
	                                        margin-bottom:.0001pt;
	                                        font-size:8.0pt;
	                                        font-family:""Tahoma"",""sans-serif"";}
                                        span.BalloonTextChar
	                                        {mso-style-name:""Balloon Text Char"";
	                                        mso-style-priority:99;
	                                        mso-style-link:""Balloon Text"";
	                                        font-family:""Tahoma"",""sans-serif"";}
                                        span.EmailStyle19
	                                        {mso-style-type:personal;
	                                        font-family:""Calibri"",""sans-serif"";
	                                        color:#1F497D;}
                                        span.EmailStyle20
	                                        {mso-style-type:personal;
	                                        font-family:""Calibri"",""sans-serif"";
	                                        color:#002060;
	                                        font-weight:normal;
	                                        font-style:normal;}
                                        span.EmailStyle21
	                                        {mso-style-type:personal-reply;
	                                        font-family:""Calibri"",""sans-serif"";
	                                        color:#002060;
	                                        font-weight:normal;
	                                        font-style:normal;}
                                        .MsoChpDefault
	                                        {mso-style-type:export-only;
	                                        font-size:10.0pt;}
                                        @page WordSection1
	                                        {size:8.5in 11.0in;
	                                        margin:1.0in 1.0in 1.0in 1.0in;}
                                        div.WordSection1
	                                        {page:WordSection1;}
                                        --></style>

                                        <!--[if gte mso 9]>
	                                        <xml>
	                                        <o:shapedefaults v:ext=""edit"" spidmax=""1026"" />
	                                        </xml>
                                        <![endif]-->
                                        <!--[if gte mso 9]>
	                                        <xml>
	                                        <o:shapelayout v:ext=""edit"">
	                                        <o:idmap v:ext=""edit"" data=""1"" />
	                                        </o:shapelayout>
	                                        </xml>
                                        <![endif]-->
                                        </head>

                                        <body lang=EN-US link=blue vlink=purple>
	                                        <div class=WordSection1>
		                                        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=""98%"" style='width:98.0%;border-collapse:collapse'>
			                                        <tr><td style='padding:0in 0in 0in 0in'>
                                                        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=620 style='width:465.0pt;border-collapse:collapse'> 
                                                            <tr><td valign=bottom style='background:#3B5998;padding:3.75pt 15.0pt 3.75pt 15.0pt'>
                                                                <p class=MsoNormal><b>
                                                                    <span style='font-family:""Tahoma"",""sans-serif"";color:white;letter-spacing:-.35pt'>
                                                                    <span style='color:white;background:#3B5998;text-decoration:none'>You Have a New Website Lead</span><o:p></o:p>
                                                                    </span>
                                                                </b></p>
                                                            </td></tr>
                                                        </table>
                                                        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=620 style='width:465.0pt;border-collapse:collapse'>
                                                            <tr><td style='background:#F2F2F2;padding:0in 0in 0in 0in'>
                                                                <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 style='border-collapse:collapse'>
                                                                    <tr><td width=620 style='width:465.0pt;padding:0in 0in 0in 0in'>
                                                                        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=""100%"" style='width:100.0%;border-collapse:collapse'>
                                                                            <tr><td style='background:white;padding:15.0pt 15.0pt 0pt 15.0pt'>
                                                                                <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=""100%"" style='width:100.0%;border-collapse:collapse'>
                                                                                    <tr><td style='padding:0in 0in 3.0pt 0in'><p class=MsoNormal>
                                                                                        <span style='color:#002060; font-size:11pt;font-family:""Tahoma"",""sans-serif""'>
                                                                                    </td></tr>
                                                                                    <tr><td style='border:none;border-top:solid #E8E8E8 1.0pt;padding:4.5pt 0in 4.5pt 0in'>
                                                                                        #Details#
                                                                                    </td></tr>
                                                                                    <tr><td style='border:none;border-top:solid #E8E8E8 1.0pt;padding:4.5pt 0in 0pt 0in'>&nbsp;
                                                                                    </td></tr>
                                                                                </table>
                                                                            </td></tr>
                                                                        </table>
                                                                    </td></tr>
                                                                </table>
                                                            </td></tr>
                                                        </table>
                                                        <table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0 width=620 style='width:465.0pt;border-collapse:collapse'>
                                                            <tr><td style='background:white;padding:0.0pt 15.0pt 10.0pt 15.0pt'>
                                                                <p class=MsoNormal><span style='font-size:10pt;font-family:""Tahoma"",""sans-serif"";color:#7F7F7F'>To view additional details of this inquiry, login to your CareBlue Practice Portal at <span style='color:#0066FF;'>https://prm.careblue.com</span> </span>
                                                            </td></tr>
                                                        </table>
                                                        </td></tr>
                                                </table>
                                                <p class=MsoNormal><o:p>&nbsp;</o:p></p>
                                            </div>
                                        </body>
                                        </html>";

            var details = String.Format(@"
                                                 <table class=MsoNormalTable style=""font-family:Tahoma; font-size:10pt;"" cellpadding=""5"" cellspacing=""0"" border=""0"">
                                                 <tr>
                                                 <td text-align: right;font-weight: bold"" width=""140"">Name:</td>
                                                 <td>{0} {1}</td>
                                                 </tr>
                                                 <tr>
                                                 <td text-align: right;font-weight: bold"">City:</td>
                                                 <td>{2}</td>
                                                 </tr>
                                                 <tr>
                                                 <td text-align: right;font-weight: bold"">State:</td>
                                                 <td>{3}</td>
                                                 </tr>                                         
                                                 <tr>
                                                 <td text-align: right;font-weight: bold"">Product/Service:</td>
                                                 <td>{4}</td>
                                                 </tr>                                        
                                                <tr>
                                                 <td text-align: right;font-weight: bold"">Phone Number:</td>
                                                 <td>{5}</td>
                                                 </tr>                                         
                                                <tr>
                                                 <td text-align: right;font-weight: bold"">Email:</td>
                                                 <td>{6}</td>
                                                 </tr>                                         
                                                 <tr>
                                                 <td text-align: right;font-weight: bold"">Comments:</td>
                                                 <td>{7}</td>
                                                 </tr>                                          
                                                 <tr>
                                                 <td text-align: right;font-weight: bold"">Current Patient:</td>
                                                 <td>{8}</td>
                                                 </tr>                                          
                                               </table>
                                                   ", fields["FirstName"], fields["LastName"], fields["City"], fields["State"], fields["ServiceType"], fields["PhoneNumber"], fields["PatientEmail"], fields["Comments"], fields["IsCurrentPatient"]);
            #endregion



            messageBody = messageBody.Replace("#Name#", fields["LastName"] + ", " + fields["FirstName"]);
            messageBody = messageBody.Replace("#Details#", details);

            SendTransactionEmail("no-reply@careblue.com", "CareBlue Service", fields["NotificationEmail"], "You Have a New Website Lead", string.Empty, messageBody, string.Empty, string.Empty, string.Empty, 0, string.Empty, string.Empty);


        }

    }

}
