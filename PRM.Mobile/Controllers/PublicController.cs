using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using PatientPortal.DataLayer;
using PatientPortal.Mobile.Models;
using PatientPortal.Utility;

namespace PatientPortal.Mobile.Controllers
{
    public class PublicController : BaseController
    {

        #region Create Payments

        public ActionResult Index(Int32? statementID)
        {
            // Allow user to download the statement
            if (statementID > 0)
            {

                var savedStatements = ClientSession.Object as DataTable;
                var statement = savedStatements.Select("StatementID=" + statementID);
                var path = statement[0]["FilePathStatements"].ToString();
                var fileName = statement[0]["Filename"].ToString();

                if (string.IsNullOrEmpty(fileName))
                {
                    TempData["Message"] = "The selected statement is still being processed and will be available for download tomorrow.";
                    return RedirectToAction("Index");
                }

                path += fileName;
                var returnmsg = PDFServices.FileDownload(path, fileName);
                if (returnmsg != "")
                {
                    TempData["Message"] = returnmsg;
                    return RedirectToAction("Index");
                }
            }


            var paymentMethod = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_get", new Dictionary<string, object> { { "@PatientId", ClientSession.PatientID } });
            ViewBag.PaymentMethods = paymentMethod.AsEnumerable().Select(res => new Dropdown { Value = res["PaymentCardID"].ToString(), Text = res["AccountName"].ToString() }).ToList();
            TempData["PaymentMethods"] = paymentMethod;

            var cmdParams = new Dictionary<string, object> { { "@AccountID", ClientSession.AccountID }, { "@flagcurrent", 1 }, { "@FlagBalance", 1 } };
            var statements = SqlHelper.ExecuteDataTableProcedureParams("web_pr_statement_get", cmdParams);
            ClientSession.Object = statements;

            ViewBag.Statements = statements.AsEnumerable().Select(res => new Dropdown { Value = res["StatementID"].ToString(), Text = string.Format("{0} - {1}", res["StatementID"], res["Balance$"]) }).ToList();

            // Getting Balance according the statement
            var selectedStatement = statements.Select("StatementID=" + ClientSession.StatmentID);
            var balance = 0m;

            // If user has paid entire amount else checking if user have atleast one row to show default balance
            if (selectedStatement.FirstOrDefault() != null)
            {
                balance = (decimal)selectedStatement[0]["Balance"];
                balance = Math.Round(balance, 2);
            }
            else
            {
                if (statements.Rows.Count > 0)
                {
                    balance = (decimal)statements.Rows[0]["Balance"];
                    balance = Math.Round(balance, 2);
                }

            }

            // Checking if email is null then displaying textbox else displaying label
            object email;
            ClientSession.PatientInformation.TryGetValue("Email", out email);

            var model = new PaymentViewModel
            {
                Amount = balance,
                Email = email.ToString(),
                StatementID = ClientSession.StatmentID
            };

            return View(model);
        }

        [HttpPost]
        public ActionResult Index(PaymentViewModel model)
        {
            try
            {

                if (!string.IsNullOrEmpty(model.Email))
                {
                    SaveEmail(model.Email);
                }

                var paymentMethods = TempData["PaymentMethods"] as DataTable;
                var selectedPaymentMethod = paymentMethods.Select("PaymentCardID=" + model.PaymentCardID);
                var FspTypeID = Convert.ToInt32(selectedPaymentMethod[0]["FSPTypeID"]);
                var pnRef = selectedPaymentMethod[0]["PNRef"].ToString();

                // Charging Payment
                switch (FspTypeID)
                {
                    case (int)ProcessCheckCreditDebit.ProcessCreditSale:

                        var processCreditSale = new ProcessCreditSale(model.Amount.ToString(), pnRef, ClientSession.PatientID, model.PaymentCardID, model.StatementID, ClientSession.AccountID, ClientSession.PracticeID, ClientSession.IpAddress, ClientSession.UserID, null, (int)SourceType.PatientPortalPublic, 0, string.Empty, null, null);
                        Common.FSPTypeID = (int)ProcessCheckCreditDebit.ProcessCreditSale;
                        Common.Success = processCreditSale.Success;
                        Common.FSPStatusID = processCreditSale.FSPStatusID;
                        Common.FSPMessage = processCreditSale.FSPMessage;
                        Common.FSPPNRef = processCreditSale.FS_PNRef;
                        Common.FSPAuthRef = processCreditSale.FSPAuthRef;
                        Common.ReturnTransID = processCreditSale.ReturnTransID;
                        break;

                    case (int)ProcessCheckCreditDebit.ProcessCheckSale:
                        var processCheckSale = new ProcessCheckSale(model.Amount.ToString(), pnRef, ClientSession.PatientID, model.PaymentCardID, model.StatementID, ClientSession.AccountID, ClientSession.PracticeID, ClientSession.IpAddress, ClientSession.UserID, null, (int)SourceType.PatientPortalPublic, 0, string.Empty, null, null);
                        Common.FSPTypeID = (int)ProcessCheckCreditDebit.ProcessCheckSale;
                        Common.Success = processCheckSale.Success;
                        Common.FSPStatusID = processCheckSale.FSPStatusID;
                        Common.FSPMessage = processCheckSale.FSPMessage;
                        Common.FSPPNRef = processCheckSale.FS_PNRef;
                        Common.FSPAuthRef = null;
                        Common.ReturnTransID = processCheckSale.ReturnTransID;
                        break;
                }

                TempData["Message"] = "Payment process was completed successfully";

                // Sending an email
                var emailcode = EmailServices.SendPaymentReceiptbyID(Common.ReturnTransID, ClientSession.UserID);
                if (emailcode != (int)EmailCode.Succcess)
                {
                    var message = "";
                    switch (emailcode)
                    {
                        case (int)EmailCode.BouncedMail:
                            message = "A confirmation email was attempted but the address on file does not appear to be valid. Please update the email address to resolve the issue.";
                            break;
                        case (int)EmailCode.EmptyEmail:
                            message = "No email address on file. Please update the email address to receive a receipt of this payment.";
                            break;
                        case (int)EmailCode.InvalidEmailAddress:
                            message = "A confirmation email was attempted but the address on file does not appear to be valid. Please update the email address to resolve the issue.";
                            break;
                        default:
                            message = "A confirmation email was attempted but an error occurred. The technical support team has been notified.";
                            break;
                    }

                    TempData["Message"] = message;
                }

            }
            catch
            {
                throw;
            }
            return RedirectToAction("Index");

        }

        private void SaveEmail(string email)
        {
            var cmdParams = new Dictionary<string, object> { { "@PatientID", ClientSession.PatientID }, { "@PracticeID", ClientSession.PracticeID }, { "@Email", email }, { "@UserID", ClientSession.UserID } };
            SqlHelper.ExecuteScalarProcedureParams("web_pr_patient_email_add", cmdParams);
        }

        public JsonResult ValidateAmount(decimal amount, Int32 statementID)
        {
            var statementandBalance = ClientSession.Object as DataTable;
            var selectedStatement = statementandBalance.Select("StatementID=" + statementID);
            var balance = (decimal)selectedStatement[0]["Balance"];
            return Json(amount <= balance, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetBalanceAccordingToStatement(Int32 statementID)
        {
            var statementandBalance = ClientSession.Object as DataTable;
            var selectedStatement = statementandBalance.Select("StatementID=" + statementID);
            var balance = (decimal)selectedStatement[0]["Balance"];
            return Json(Math.Round(balance, 2), JsonRequestBehavior.AllowGet);
        }


        #endregion

        #region Add New Credit Card

        public ActionResult AddNewCard()
        {
            // Displaying the patient information
            object zip;
            ClientSession.PatientInformation.TryGetValue("Zip", out zip);

            var model = new AddCardsModel
            {
                FirstName = ClientSession.FirstName,
                LastName = ClientSession.LastName,
                Zip = Convert.ToInt32(zip),
                ExpireMonth = null,
                ExpireYear = null,
                CvvSecurityID = null

            };

            return View(model);
        }

        [HttpPost]
        public ActionResult AddNewCard(AddCardsModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            // Making year of 4 digits
            var firstTwoDigits = DateTime.Now.Year.ToString().Substring(0, 2);
            model.ExpireYear = Convert.ToInt32(firstTwoDigits + model.ExpireYear);

            if (!ValidateCreditCard(model))
            {
                TempData["Message"] = "The patient's financial institution was unable to validate the information entered, please verify all fields and resubmit.";
                return View(model);
            }


            var card = model.CardNumber.Trim();
            var cmdParams = new Dictionary<string, object>
                                {
                                    { "@PatientID", ClientSession.PatientID },
                                    { "@NameLast", model.LastName.Trim() },
                                    { "@NameFirst", model.FirstName.Trim() },
                                    { "@Zip", model.Zip },
                                    { "@PaymentCardTypeID", (int)GetCardTypeFromNumber(model.CardNumber) },
                                    { "@CardLast4", card.Substring( card.Length-4) },
                                    { "@ExpMonth", model.ExpireMonth },
                                    { "@ExpYear", model.ExpireYear },
                                    { "@PNRef", Common.FSPPNRef },                                    
                                    { "@FlagPrimary", true },
                                    { "@UserID", ClientSession.UserID},
                                    { "@FlagActive", 1},
                                    { "@IPAddress", ClientSession.IpAddress},
                                 };


            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_paymentcard_add", cmdParams);
            foreach (DataRow row in reader.Rows)
            {

                var flagDupCard = Convert.ToBoolean(row["FlagDupCard"]);
                if (flagDupCard)
                {
                    TempData["Message"] = "It appears that we already have this payment account on file. If the account was previously deleted, it has been re-activated. You may close the window to add a new payment method and on exit your existing account should be shown. Thank you.";
                }
                else
                {
                    TempData["Message"] = "A new credit card account has been successfully added.";
                }

            }

            return RedirectToAction("Index");
        }

        public JsonResult ValidateYear(int expireYear)
        {
            var firstTwoDigits = DateTime.Now.Year.ToString().Substring(0, 2);
            expireYear = Convert.ToInt32(firstTwoDigits + expireYear);
            return Json(expireYear > DateTime.Now.Year, JsonRequestBehavior.AllowGet);
        }

        private bool ValidateCreditCard(AddCardsModel model)
        {
            var cardType = (int)GetCardTypeFromNumber(model.CardNumber);
            var month = model.ExpireMonth.ToString().Length == 1 ? "0" + model.ExpireMonth : model.ExpireMonth.ToString();
            var expiryDate = month + model.ExpireYear.ToString().Substring(2, 2);
            var fsv = new ValidCard(cardType, model.CardNumber, expiryDate, ClientSession.PatientID, 0, ClientSession.AccountID, ClientSession.PracticeID, ClientSession.IpAddress, ClientSession.UserID, model.FirstName.Trim() + " " + model.LastName.Trim(), string.Empty, model.Zip.ToString(), model.CvvSecurityID.ToString());
            if (fsv.Success) //card was validated.
                Common.FSPPNRef = fsv.PNRef;

            return fsv.Success;
        }

        private static CreditCardTypeType? GetCardTypeFromNumber(string cardNum)
        {
            const string cardRegex = "^(?:(?<Visa>4\\d{3})|(?<MasterCard>5[1-5]\\d{2})|(?<Discover>6011)|(?<DinersClub>(?:3[68]\\d{2})|(?:30[0-5]\\d))|(?<Amex>3[47]\\d{2}))([ -]?)(?(DinersClub)(?:\\d{6}\\1\\d{4})|(?(Amex)(?:\\d{6}\\1\\d{5})|(?:\\d{4}\\1\\d{4}\\1\\d{4})))$";

            //Create new instance of Regex comparer with our
            //credit card regex patter
            var cardTest = new Regex(cardRegex);

            //Compare the supplied card number with the regex
            //pattern and get reference regex named groups
            var gc = cardTest.Match(cardNum).Groups;

            //Compare each card type to the named groups to 
            //determine which card type the number matches
            if (gc[CreditCardTypeType.Amex.ToString()].Success)
            {
                return CreditCardTypeType.Amex;
            }

            if (gc[CreditCardTypeType.MasterCard.ToString()].Success)
            {
                return CreditCardTypeType.MasterCard;
            }

            if (gc[CreditCardTypeType.Visa.ToString()].Success)
            {
                return CreditCardTypeType.Visa;
            }

            if (gc[CreditCardTypeType.Discover.ToString()].Success)
            {
                return CreditCardTypeType.Discover;
            }

            //Card type is not supported by our system, return null
            //(You can modify this code to support more (or less)
            // card types as it pertains to your application)
            return null;
        }

        #endregion

    }

    #region Common
    public static class Common
    {

        public static bool Success { get; set; }

        public static Int32 FSPTypeID { get; set; }

        public static Int32 FSPStatusID { get; set; }

        public static string FSPMessage { get; set; }

        public static string FSPPNRef { get; set; }

        public static string FSPAuthRef { get; set; }

        public static Int32 ReturnTransID { get; set; }

    }
    #endregion
}
