using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using PatientPortal.DataLayer;
using PatientPortal.Mobile.Models;
using PatientPortal.Utility;

namespace PatientPortal.Mobile.Controllers
{

    [Authorize]
    public class AccountController : BaseController
    {
        //
        // GET: /Account/Index

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /Account/Login
        [AllowAnonymous]
        public ActionResult Login()
        {
            var lastName = Request.Params["ln"];
            var practiceName = Request.Params["pn"];
            var accountID = CryptorEngine.Decrypt(Request.Params["aid"]);

            // Saving values directly in clientsession because if user wants to use full site
            ClientSession.LastName = lastName;
            ClientSession.EncAccountID = Request.Params["aid"];

            var model = new LoginModel
            {
                LastName = lastName,
                AccountID = !string.IsNullOrEmpty(accountID) ? Convert.ToInt32(accountID) : (int?)null,
                Practice = practiceName,
                Pin = null
            };
            return View(model);
        }

        //
        // POST: /Account/Login
        [AllowAnonymous]
        [HttpPost]
        public ActionResult Login(LoginModel model)
        {
            if (!ModelState.IsValid) return View(model);

            try
            {
                var statementID = CryptorEngine.Decrypt(Request.Params["sid"]);

                var cmdParams = new Dictionary<string, object>
                {
                    {"@AccountId", model.AccountID},
                    {"@PINCode", model.Pin},
                    {"@NameLast", model.LastName},
                    {"@IPAddress", ClientSession.IpAddress}
                };

                var dataTable = SqlHelper.ExecuteDataTableProcedureParams("web_pt_login_m", cmdParams);
                var patientID = (int)dataTable.Rows[0]["PatientID"];

                if (patientID == 0)
                {
                    ModelState.AddModelError("", "Invalid Pin Code");
                    model.Practice = Request.Params["pn"];
                    return View(model);
                }

                ClientSession.AccountID = (int)model.AccountID;
                ClientSession.StatmentID = string.IsNullOrEmpty(statementID) ? 0 : Convert.ToInt32(statementID);
                ClientSession.PatientID = patientID;
                ClientSession.PracticeName = dataTable.Rows[0]["PracticeName"].ToString();
                ClientSession.LastName = dataTable.Rows[0]["NameLast"].ToString();
                ClientSession.FirstName = dataTable.Rows[0]["NameFirst"].ToString();

                var patientName = dataTable.Rows[0]["NameLast"] + " " + dataTable.Rows[0]["NameFirst"];
                ClientSession.PatientInformation = new Dictionary<string, object> 
                     {
                         {"Email", dataTable.Rows[0]["Email"]},
                         {"Zip", dataTable.Rows[0]["ZipCode"]},
                         
                     };

                CreateAuthenticationTicket(patientName);


            }
            catch
            {
                throw;
            }

            return RedirectToAction("Index", "Public");
        }

        private void CreateAuthenticationTicket(String userName)
        {
            var ticket = new FormsAuthenticationTicket(1, userName, DateTime.Now, DateTime.Now.AddDays(7), true, string.Empty);
            var cookiestr = FormsAuthentication.Encrypt(ticket);
            var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, cookiestr) { Path = FormsAuthentication.FormsCookiePath };
            Response.Cookies.Add(cookie);
        }


        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();

            //Getting values before clear
            var lastName = ClientSession.LastName;
            var practiceName = ClientSession.PracticeName;
            var encryptedAccountID = CryptorEngine.Encrypt(ClientSession.AccountID.ToString());

            ClientSession = new EndPointSession();
            return RedirectToAction("Login", new { aid = encryptedAccountID, ln = lastName, pn = practiceName });
        }

    }
}
