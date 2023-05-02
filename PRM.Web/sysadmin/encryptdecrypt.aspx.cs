using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using PatientPortal.Utility;

public partial class encryptdecrypt : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnSubmit_OnClick(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txtInput.Text))
        {
            ShowMessage("Please input your data first!");
            return;
        }

        try
        {
            string result;
            if (rdEncrypt.Checked)
            {
                result = CryptorEngine.Encrypt(txtInput.Text);
            }
            else
            {
                result = CryptorEngine.Decrypt(txtInput.Text);
            }

            spanResult.InnerHtml = "<b>Result: </b>" + result;
        }
        catch (Exception)
        {
            // Error will only occur when we'll try to decrypt un encrypted code
            ShowMessage("Please enter valid encrypted text.");

        }

    }


    private void ShowMessage(string errorMessage)
    {
        ScriptManager.RegisterStartupScript(Page, typeof(Page), "showMessage",  string.Format("showMessage('{0}')", errorMessage), true);
    }

}