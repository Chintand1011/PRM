using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for UserMenus
/// </summary>
public class UserMenu
{
    public Int32 MenuID { get; set; }

    public string MenuName { get; set; }

    public string PageName { get; set; }

    public string FullPath { get; set; }

    public string NavigateURL { get; set; }

    public bool HideShow { get; set; }

    public bool IsAllow { get; set; }
}

