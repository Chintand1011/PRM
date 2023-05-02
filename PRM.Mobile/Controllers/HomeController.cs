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
    public class HomeController : BaseController
    {

        public ActionResult About()
        {
            return View();
        }

        public ActionResult Contact()
        {
            return View();
        }


    }

}
