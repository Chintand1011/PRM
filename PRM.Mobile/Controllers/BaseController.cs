using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace PatientPortal.Mobile.Controllers
{
    public class BaseController : Controller
    {
        //
        // GET: /Base/

        public EndPointSession ClientSession
        {
            get
            {
                if (HttpContext.Session["ClientSession"] == null)
                    HttpContext.Session["ClientSession"] = new EndPointSession();
                return (EndPointSession)HttpContext.Session["ClientSession"];
            }
            set
            {
                HttpContext.Session["ClientSession"] = value;
            }
        }


        protected override void OnActionExecuting(ActionExecutingContext filterContext)
       {
            try
            {
                var controller = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;

                if (controller == "Public" && ClientSession.PatientID == 0)
                {
                    Response.Redirect("~/Account/Logout");
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

    }
}
