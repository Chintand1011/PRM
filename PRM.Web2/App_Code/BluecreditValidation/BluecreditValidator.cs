using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Telerik.Web.UI;

/// <summary>
/// Summary description for BluecreditValidator
/// </summary>
public static class BluecreditValidator
{
    public static EndPointSession ClientSession { get { return Extension.ClientSession; } }


    public static bool HasCreatePermission(RadWindowManager radWindowManager)
    {
        var havePermission = ClientSession.FlagBCCreate;
        if (!havePermission)
        {
            var message = "You don't have permission to perform this action. Please contact your billing manager.".ToApostropheStringIfAny();
            radWindowManager.RadAlert(message, 350, 150, "", "", "../Content/Images/warning.png");
            return false;
        }

        return true;
    }

    public static bool HasModifyPermission(RadWindowManager radWindowManager, bool flagBlocked)
    {
        var havePermission = (!flagBlocked && ClientSession.FlagBCModify); //added by mvs 5/7/16 || ClientSession.FlagSysAdmin; 
        if (!havePermission)
        {
            var message = "You don't have permission to perform this action. Please contact an administrator.".ToApostropheStringIfAny();
            radWindowManager.RadAlert(message, 350, 150, "", "", "../Content/Images/warning.png");
            return false;
        }

        return true;
    }

    public static bool HasAccessToSeeTerminatedAccounts()
    {
        return ClientSession.RoleTypeID >= (int)RoleType.Billing;
    }


}