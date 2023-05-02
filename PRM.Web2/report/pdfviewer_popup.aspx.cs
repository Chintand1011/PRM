using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;
using PatientPortal.Utility;

public partial class pdfviewer_popup : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // Closing the popup in case of any error
                ClientSession.WasRequestFromPopup = true;
                string pageTitle;
                // Fetching the Page title from session for displaying right title for right PDF
                var values = ClientSession.ObjectValue as Dictionary<string, string>;
                values.TryGetValue("PageTitle", out pageTitle);

                Page.Title = pageTitle;

                // Checking is BluecreditID is null or not, if null then showing the Image instead PDF and vice versa.
                if (string.IsNullOrEmpty(ClientSession.ObjectID.ToString()))
                    ViewImage();
                else
                    hdnAllowButtonClick.Value = "1";


            }
            catch (Exception)
            {
                throw;
            }


            popupInfo.VisibleOnPageLoad = false;
        }
    }

    protected void btnGetResponse_OnClick(object sender, EventArgs e)
    {
        ViewPDF();
    }

    #region View PDF

    private void ViewPDF()
    {
        string fileName, isRequestFromBluecredit;
        var values = ClientSession.ObjectValue as Dictionary<string, string>;

        // Fetching necessary information from clientsession
        values.TryGetValue("FileName", out fileName);
        values.TryGetValue("IsRequestFromBlueCredit", out isRequestFromBluecredit);

        var path = string.Empty;

        // Checking if request comming from Bluecredit.
        var isBluecredit = Convert.ToBoolean(isRequestFromBluecredit);

        if (isBluecredit)
        {
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_pr_bluecredit_get", new Dictionary<string, object> { { "BluecreditID", ClientSession.ObjectID }, { "@PracticeID", ClientSession.PracticeID }, { "@UserID", ClientSession.UserID } });
            foreach (DataRow row in reader.Rows)
            {
                path = row["FilePathBlueCredit"].ToString();
            }

            path = Path.Combine(path, fileName + "_" + ClientSession.ObjectID + ".pdf");
        }
        else
        {
            path = ClientSession.FilePath;
        }

        // Getting file name.

        var filename = Path.GetFileName(path);

        // Displaying the response of the PDF
        var returnmsg = PDFServices.PDFView(path, filename);
        if (returnmsg != "")
        {
            ShowErrorMessage(returnmsg);
        }

    }

    #endregion

    #region View Image

    private void ViewImage()
    {
        string source;
        var values = ClientSession.ObjectValue as Dictionary<string, string>;
        values.TryGetValue("FilePath", out source);

        var message = PDFServices.ValidateFileLocation(source);

        if (!string.IsNullOrEmpty(message))
        {
            ShowErrorMessage(message);
            return;
        }

        imgFile.Visible = true;
        imgFile.ImageUrl = source;
    }

    #endregion

    private void ShowErrorMessage(string message)
    {
        h1ErrorMessage.InnerText = message;
        hdnAllowButtonClick.Value = "0";
    }

}