using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for EndPointSession
/// </summary>
public class EndPointSession
{
    public Int32 ProviderID { get; set; }

    public Int32 PracticeID { get; set; }

    public string PracticeName { get; set; }

    public string PracticeLogo { get; set; }

    public Int32 SelectedPatientID { get; set; }

    public string PatientLastName { get; set; }

    public string PatientFirstName { get; set; }

    public Int32 SelectedPatientAccountID { get; set; }

    public Int32 UserID { get; set; }

    public object ObjectID { get; set; }

    public object ObjectID2 { get; set; }

    public ObjectType? ObjectType { get; set; }

    public object ListofObject { get; set; }

    public string UserName { get; set; }

    public string FirstName { get; set; }

    public string LastName { get; set; }

    public string DateOfBirth { get; set; }

    public string UserRole { get; set; }

    public bool IsAdmin { get; set; }

    public UserType UserType { get; set; }

    public System.Data.DataTable Object { get; set; }

    public List<UserMenu> UserMenus { get; set; }

    public CustomUploadedFileInfo InsuranceImage { get; set; }

    public CustomUploadedFileInfo CardImage { get; set; }

    public object ObjectValue { get; set; }

    public decimal SelectedStatementBalance { get; set; }

    public List<Int32> SelectedBlueCreditStatements { get; set; }

    public Dictionary<string, object> SelectedPatientInformation { get; set; }

    public string Message { get; set; }

    public bool IsFlagGuardianExists { get; set; }

    public string PracticeAbbr { get; set; }

    public string LogoName { get; set; }

    public int LogoHeight { get; set; }

    public int LogoWidth { get; set; }

    public string DefaultDirectory { get; set; }

    public string NoteProviderSite { get; set; }

    public int FrontStream { get; set; }

    public int Transunion { get; set; }

    public int Eligibility { get; set; }

    public int RoleTypeID { get; set; }

    public List<string> StatementIDandBalance { get; set; }

    public decimal HighestSelectedBalance { get; set; }

    public string AmountandDownpayment { get; set; }

    public string ServiceIPAddress { get; set; }

    public string FilePathInsurance { get; set; }

    public string FilePathBlueCredit { get; set; }

    public string FilePathStatements { get; set; }

    public string FilePathIdentification { get; set; }

    public string MaintPrWebNote { get; set; }

    public bool WasRequestFromPopup { get; set; }

    public bool WasRequestFromGlobalAsax { get; set; }

    public string FilePath { get; set; }

    public string PopupMessage { get; set; }

    public string WebPathRootProvider { get; set; }

    public Int32 SessionTimeout { get; set; }

    public bool IsPatientHasCard { get; set; }

    public bool FlagPrintPayReceipts { get; set; }

    public bool FlagSigCaptureReceipts { get; set; }

    public bool EnablePrinting { get; set; }

    public bool EnableClientSign { get; set; }

    public bool? IsBlueCreditAddRequest { get; set; }

    public bool IsBluecreditValidationsPassed { get; set; }

    public Int32 SelectedPatientProviderID { get; set; }

    public bool? IsRedirectToBluecredit { get; set; }
    
    public Int32? BackUpID { get; set; }

    public Int32 ServiceTimeout { get; set; }

    private string _ipAddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] ?? HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
    public string IPAddress
    {
        get { return _ipAddress; }
        set { _ipAddress = value; }
    }

    public Int32 PatientCount { get; set; }
    public Int32 MaxPatientDropdown { get; set; }

    public Int32 DefaultLocationID { get; set; }
    public Int32 DefaultProviderID { get; set; }
    public bool FlagPtSearchActiveDefault { get; set; }
    public bool FlagPtSearchLocationDefault { get; set; }
    public bool FlagPtSearchProviderDefault { get; set; }
    public bool FlagCMSSurveys { get; set; }
    public bool FlagManageElibility { get; set; }
    public bool FlagBCCreate { get; set; }
    public bool FlagBCModify { get; set; }
    public bool FlagSysAdmin { get; set; } //added by mvs 5/7/16
    public bool FlagEDIGet { get; set; }
    public bool FlagCreditCheck { get; set; } //added by mvs 9/5/16
    public bool FlagBlueCredit { get; set; }
    public bool BCLenderFlagLive { get; set; }
    public bool IsUserUnderPatientDirectory { get; set; }

}