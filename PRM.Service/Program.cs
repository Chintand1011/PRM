using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using PatientPortal.Utility;
using PatientPortal.DataLayer;

namespace PatientPortal.Service
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main()
        {
            AppDomain.CurrentDomain.UnhandledException += new UnhandledExceptionEventHandler(MyHandler);
            #if(!DEBUG)
                ServiceBase[] ServicesToRun;
                ServicesToRun = new ServiceBase[] 
                { 
                    new PatientPortalService() 
                };
                ServiceBase.Run(ServicesToRun);
            #else
                RunServiceMethods.RunMethods();
            #endif
        }
        static void MyHandler(object sender, UnhandledExceptionEventArgs args)
        {
            Exception ex = (Exception)args.ExceptionObject;
            var sqlData = SqlHelper.GetSqlData(ex.Data);
            EmailServices.SendRunTimeErrorEmail("UnHandledException from Service: " + ex.HelpLink, ex.GetType().ToString(), ex.Message, ex.StackTrace, "", "N/A", "N/A", "N/A", "N/A", 1, -1, -1, "127.0.0.1", sqlData);
        }
    }
}
