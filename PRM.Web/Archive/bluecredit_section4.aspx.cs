﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Terms_bluecredit_Section4 : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        HideSubmitButtons();

        if (Extension.ClientSession == null)
        {
            throw new Exception("Trying to access the Terms Folder");
        }
    }

    private void HideSubmitButtons()
    {
        var hideButtons = Request.Params["HideButtons"];
        if (hideButtons == "1")
        {
            divButtons.Visible = false;
        }
    }
}