using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for EndPointSession
/// </summary>
public class EndPointSession
{
    public Int32 PatientID { get; set; }

    public Int32 ProviderID { get; set; }

    public Int32 PracticeID { get; set; }

    public string PracticeName { get; set; }

    public string PracticeLogo { get; set; }

    public Int32 AccountID { get; set; }

    public Int32 UserID { get; set; }

    public object ObjectID { get; set; }

    public object ObjectID2 { get; set; }

    public ObjectType? ObjectType { get; set; }

    public object ObjectValue { get; set; }

    public string UserName { get; set; }

    public string FirstName { get; set; }

    public string LastName { get; set; }

    public string DateOfBirth { get; set; }

    public Dictionary<string, string> PatientInfo { get; set; } 

    public string UserRole { get; set; }

    public string Message { get; set; }

    public bool IsAllowBlueCredit { get; set; }

    public bool IsAllowPaymentPlans { get; set; }

    public System.Data.DataTable Object { get; set; }

    public string AmountandDownpayment { get; set; }

    public int FrontStream { get; set; }

    public int Transunion { get; set; }

    public int Eligibility { get; set; }

    public string NotePatientSite { get; set; }

    public string MaintPtWebNote { get; set; }

    public string WebPathRootPatient { get; set; }

    public Int32 SessionTimeout { get; set; }

    public object ListofObject { get; set; }
    public bool EnablePrinting { get; set; }

    private string _ipAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ?? HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
    public string IPAddress
    {
        get { return _ipAddress; }
        set { _ipAddress = value; }
    }

    public string LogoName { get; set; }
    public int LogoWidth { get; set; }
    public int LogoHeight { get; set; }

    public decimal BlueCreditQualMin { get; set; }
    public decimal BlueCreditQualMax { get; set; }
}