using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class EndPointSession
{
    public Int32 PatientID { get; set; }
    public Int32 AccountID { get; set; }
    public Int32 StatmentID { get; set; }
    public Int32 UserID { get; set; }
    public Int32 PracticeID { get; set; }
    public object Object { get; set; }
    public Dictionary<string, object> PatientInformation { get; set; }
    public string PracticeName { get; set; }

    public string EncAccountID { get; set; }
    public string LastName { get; set; }

    public string FirstName { get; set; }

    private string _ipAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ?? HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
    public string IpAddress
    {
        get { return _ipAddress; }
        set { _ipAddress = value; }
    }
}