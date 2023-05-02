using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Windows.Forms.VisualStyles;

/// <summary>
/// Summary description for CustomWebClient
/// </summary>
public class CustomWebClient : WebClient
{
    public int Timeout { get; set; }

    public CustomWebClient(int timeout)
    {
        Timeout = timeout;
    }

    protected override WebRequest GetWebRequest(Uri address)
    {
        var result = base.GetWebRequest(address);
        result.Timeout = Timeout;
        return result;
    }

}