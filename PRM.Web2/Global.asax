<%@ Application Language="C#" %>
<%@ Import Namespace="System.Net" %>

<script RunAt="server">

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup

    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    void Application_Error(object sender, EventArgs e)
    {
       #if !DEBUG
        var lastErrorWrapper = HttpContext.Current.Server.GetLastError() as HttpException;
        if (lastErrorWrapper != null)
        {
            if (lastErrorWrapper.GetHttpCode() == (int)HttpStatusCode.NotFound)
            {
                Response.Redirect("~/ErrorPages/404.aspx");
                return;
            }

            if (Extension.ClientSession.WasRequestFromPopup)
                Extension.ClientSession.WasRequestFromGlobalAsax = true;
            
            LogRunTimeErrors.LogErrors(lastErrorWrapper);
            Response.Redirect("~/ErrorPages/unavailable.aspx");
        }
        #endif
    }


    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }

     
</script>
