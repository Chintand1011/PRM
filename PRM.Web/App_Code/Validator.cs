using System;
using System.Linq;
using System.Web;
using Telerik.Web.UI;

public static class Validator
{
    private static EndPointSession ClientSession
    {
        get
        {
            return Common.ClientSession;
        }
    }

    public static bool ValidateCreditCheck(RadWindowManager radWindowManager)
    {
        if (!ClientSession.FlagEDIGet)
        {
            var message = "You don't have permission to perform this action".ToApostropheStringIfAny();
            radWindowManager.RadAlert(message, 350, 150, "", "", "../Content/Images/warning.png");
        }

        return ClientSession.FlagEDIGet;
    }


    public static bool ValidateFlagCreditCheck(RadWindowManager radWindowManager, string callBackFunc)
    {
        if (!ClientSession.FlagCreditCheck)
        {
            const string message = "Your account to submit patient credit check is not yet active. Please contact support to enable this feature. The following request will be submitted against test database";
            radWindowManager.RadAlert(message, 500, 150, string.Empty, callBackFunc, "../Content/Images/warning.png");
        }

        return ClientSession.FlagCreditCheck;
    }


}