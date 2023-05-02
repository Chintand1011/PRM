using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using PatientPortal.DataLayer;



public class UserLogin
{
    #region Public Fields

    public Int32 ReturnCode { get; set; }
    public bool FlagPrWebActive { get; set; }
    public bool FlagSysAdmin { get; set; }
    public string SecurityQuestion { get; set; }
    public string ReturnMessage { get; set; }
    public string LandingPage { get; set; }

    #endregion

    private EndPointSession ClientSession
    {
        get
        {
            return Common.ClientSession;
        }
    }

    public void Login(string practiceLoginID, string userName, string password, Int32 practiceID = 0)
    {

        var cmdParams = new Dictionary<string, object>();
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            FlagPrWebActive = row["FlagPrWebActive"].ParseBool();
            if (!FlagPrWebActive)
            {
                return;
            }

            ClientSession.NoteProviderSite = row["NoteProviderSite"].ToString();
            ClientSession.ServiceIPAddress = row["ServiceIPAddress"].ToString();
            ClientSession.FilePathInsurance = row["FilePathInsurance"].ToString();
            ClientSession.FilePathBlueCredit = row["FilePathBlueCredit"].ToString();
            ClientSession.FilePathStatements = row["FilePathStatements"].ToString();
            ClientSession.WebPathRootProvider = row["WebPathRootProvider"].ToString();
            ClientSession.FilePathIdentification = row["FilePathIdentification"].ToString();
            ClientSession.MaintPrWebNote = row["MaintPrWebNote"].ToString();
            ClientSession.ServiceTimeout = (Int32)row["ServiceTimeout"];
            ClientSession.MaxPatientDropdown = (Int32)row["MaxPatientDropdown"];
        }


        cmdParams = new Dictionary<string, object>
        {
            {"@PracticeLoginID", practiceLoginID},
            {"@UserName", userName},
            {"@Password", password},
            {"@IPAddress", ClientSession.IPAddress}
        };

        reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_login", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            ReturnCode = (int)row["ReturnCode"];
            FlagSysAdmin = row["FlagSysAdmin"].ParseBool();
            SecurityQuestion = row["SecurityQuestionAbbr"].ToString();
            ReturnMessage = row["ReturnMsg"].ToString();
            LandingPage = string.Format("~/{0}?Leads={1}&Messages={2}", row["LandingPage"], row["WebLeadCount"], row["MessageCount"]);

            if (ReturnCode != 0)
            {
                return;
            }

            if (FlagSysAdmin)
            {
                AssigningValuesToClientSession(reader, practiceID);
                return;
            }

            AssigningValuesToClientSession(reader);

        }

    }

    public void ResetPassword(Dictionary<string, object> cmdParams)
    {
        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_login", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            ReturnCode = (int)row["ReturnCode"];
            ReturnMessage = row["ReturnMsg"].ToString();
            if (ReturnCode != 10)
            {
                return;
            }

            AssigningValuesToClientSession(reader);
        }
    }

    public void ReloadSessionValues(Int32 userId)
    {
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@PracticeID", ClientSession.PracticeID},
                                {"@UserId", userId}
                            };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_login_reload", cmdParams);
        foreach (DataRow row in reader.Rows)
        {
            AssigningValuesToClientSession(reader, ClientSession.PracticeID);
        }
    }

    private void AssigningValuesToClientSession(DataTable reader, Int32 practiceID = 0)
    {
        foreach (DataRow row in reader.Rows)
        { 
            ClientSession.PracticeID = practiceID > 0 ? practiceID : (Int32)row["PracticeID"];
            ClientSession.UserID = (int)row["UserID"];

            ClientSession.UserName = row["UserName"].ToString();
            ClientSession.FirstName = row["NameFirst"].ToString();
            ClientSession.LastName = row["NameLast"].ToString();
            ClientSession.UserType = UserType.Provider;
            ClientSession.UserMenus = GetMenuItems(); //Getting Menu Items
            ClientSession.PracticeName = row["PracticeName"].ToString();
            ClientSession.PracticeAbbr = row["PracticeAbbr"].ToString();
            ClientSession.LogoName = row["LogoName"].ToString();
            ClientSession.LogoHeight = Convert.ToInt32(row["LogoHeight"].ToString());
            ClientSession.LogoWidth = Convert.ToInt32(row["LogoWidth"].ToString());
            ClientSession.DefaultDirectory = row["DefaultDirectory"].ToString();
            ClientSession.NoteProviderSite = row["NoteProviderSite"].ToString();
            ClientSession.RoleTypeID = (int)row["RoleTypeID"];
            ClientSession.SessionTimeout = (int)row["SessionTimeout"];
            ClientSession.FlagPrintPayReceipts = ((int)row["FlagPrintPayReceipts"] == 1);
            ClientSession.FlagSigCaptureReceipts = ((int)row["FlagSigCaptureReceipts"] == 1);
            ClientSession.PatientCount = (int)row["PatientCount"];
            ClientSession.DefaultLocationID = (int)row["DefaultLocationID"];
            ClientSession.DefaultProviderID = (int)row["DefaultProviderID"];
            ClientSession.FlagPtSearchActiveDefault = row["FlagPtSearchActiveDefault"].ParseBool();
            ClientSession.FlagPtSearchLocationDefault = row["FlagPtSearchLocationDefault"].ParseBool();
            ClientSession.FlagPtSearchProviderDefault = row["FlagPtSearchProviderDefault"].ParseBool();
            ClientSession.FlagSysAdmin = row["FlagSysAdmin"].ParseBool(); //added by mvs 5/7/16
            ClientSession.FlagBCCreate = row["FlagBCCreate"].ParseBool();
            ClientSession.FlagBCModify = row["FlagBCModify"].ParseBool();
            ClientSession.FlagEDIGet = row["FlagEDIGet"].ParseBool();
            ClientSession.FlagCreditCheck = row["FlagCreditCheck"].ParseBool(); //added by mvs 9/5/16
            ClientSession.FlagBlueCredit = row["FlagBlueCredit"].ParseBool();
            ClientSession.BCLenderFlagLive = row["BCLenderFlagLive"].ParseBool();
        }
    }

    private List<UserMenu> GetMenuItems()
    {
        var myTextInfo = System.Threading.Thread.CurrentThread.CurrentCulture.TextInfo;
        var cmdParams = new Dictionary<string, object>
                            {
                                {"@UserID", ClientSession.UserID}
                            };

        var userMenusReader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_menu_get", cmdParams);
        var userMenus = new List<UserMenu>();
        foreach (DataRow row in userMenusReader.Rows)
        {
            var items = row["MenuName"].ToString().Split('/').ToList();
            userMenus.Add(new UserMenu
            {
                MenuID = Convert.ToInt32(row["MenuID"]),
                MenuName = myTextInfo.ToTitleCase(items[0]),
                PageName = items[1],
                FullPath = row["Location"].ToString() + row["PageName"],
                NavigateURL = "~/" + row["Location"] + row["PageName"],
                HideShow = Convert.ToInt32(row["FlagShow"]) == 1,
                IsAllow = Convert.ToInt32(row["FlagAllow"]) == 1
            });
        }
        return userMenus;
    }

    public void LoadPatientIntoSession()
    {
        var cmdParams = new Dictionary<string, object> {
            {"@PatientID", ClientSession.SelectedPatientID},
            {"@UserID", ClientSession.UserID}
        };

        var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_patient_get", cmdParams);

        foreach (DataRow row in reader.Rows)
        {
            ClientSession.PatientFirstName = row["NameFirst"].ToString();
            ClientSession.PatientLastName = row["NameLast"].ToString();
            ClientSession.DateOfBirth = row["DateofBirth"].ToString();
            ClientSession.SelectedPatientProviderID = Convert.ToInt32(row["ProviderID"]);

            var selectedPatientInformation = new Dictionary<string, object>
                                                 {
                                                     {"AddrPrimaryID", row["AddrPrimaryID"].ToString()},
                                                     {"AddrPri", row["AddrPri"].ToString()},
                                                     {"AddrSec", row["AddrSec"].ToString()},
                                                     {"Addr1Pri", row["Addr1Pri"].ToString()},
                                                     {"Addr1Sec", row["Addr1Sec"].ToString()},
                                                     {"Addr2Pri", row["Addr2Pri"].ToString()},
                                                     {"Addr2Sec", row["Addr2Sec"].ToString()},
                                                     {"PhonePri", row["PhonePri"].ToString()},
                                                     {"CityPri", row["CityPri"].ToString()},
                                                     {"CitySec", row["CitySec"].ToString()},
                                                     {"StateTypeIDPri", row["StateTypeIDPri"].ToString()},
                                                     {"StateTypeIDSec", row["StateTypeIDSec"].ToString()},
                                                     {"Email", row["Email"].ToString()},
                                                     {"ZipPri", row["ZipPri"].ToString()},
                                                     {"ZipSec", row["ZipSec"].ToString()},
                                                     {"FlagEmailBills", row["FlagEmailBills"].ToString()},
                                                     {"GuardianAddrID", row["GuardianAddrID"].ToString()},
                                                     {
                                                         "FlagGuardianPay",
                                                         Convert.ToBoolean(row["FlagGuardianPay"]) == false
                                                             ? 0
                                                             : 1
                                                     },
                                                     {
                                                         "GuardianName",
                                                         string.Format("{0} {1}", row["GuardianFirst"],
                                                                       row["GuardianLast"])
                                                     },
                                                     {"GuardianFirstName", row["GuardianFirst"]},
                                                     {"GuardianLastName", row["GuardianLast"]},
                                                     {"GuardianPhone", row["GuardianPhone"]},
                                                     {"FlagAddrSecValid", row["FlagAddrSecValid"].ToString() == "1"},
                                                     {"GuardianEmail", row["GuardianEmail"]}
                                                 };

            ClientSession.SelectedPatientInformation = selectedPatientInformation;
            ClientSession.IsFlagGuardianExists = Convert.ToBoolean(row["FlagGuardianExists"].ToString());
            ClientSession.IsPatientHasCard = Convert.ToInt32(row["SavedPaymentCardCnt"]) > 0;
        }
    }
}