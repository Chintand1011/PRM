using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using Telerik.Web.UI;

public partial class User : MasterPage
{


    #region Custom Page Size For All Grids & Combox forwar year

    private readonly List<RadGrid> _radGrids = new List<RadGrid>();

    protected override void OnInit(EventArgs e)
    {
        if (Request.IsAjaxRequest())
            return;

        FindGridControls(MainContent);

        foreach (var grid in _radGrids)
        {
            grid.ItemCreated += RadGridControl_ItemCreated;
        }
    }

    private void FindGridControls(Control control)
    {
        foreach (var innerControl in control.Controls)
        {
            if (innerControl is RadGrid)
            {
                _radGrids.Add((RadGrid)innerControl);
            }
            else if (((Control)innerControl).Controls.Count > 0)
            {
                FindGridControls((Control)innerControl);
            }
        }
    }
    
    protected void RadGridControl_ItemCreated(object sender, GridItemEventArgs e)
    {
        if (e.Item is GridPagerItem)
        {
            var dropDown = (RadComboBox)e.Item.FindControl("PageSizeComboBox");
            var totalCount = ((GridPagerItem)e.Item).Paging.DataSourceCount;
            var sizes = new Dictionary<string, string>
            {
                {"10", "10"},
                {"20", "20"},
                {"50", "50"},
                {"100", "100"},
                {"All", totalCount.ToString()}
            };

            dropDown.Items.Clear();
            foreach (var size in sizes)
            {
                var cboItem = new RadComboBoxItem { Text = size.Key, Value = size.Value };
                cboItem.Attributes.Add("ownerTableViewId", e.Item.OwnerTableView.ClientID);
                dropDown.Items.Add(cboItem);
            }

            var pager = dropDown.FindItemByValue(e.Item.OwnerTableView.PageSize.ToString());
            if (pager != null)
            {
                pager.Selected = true;
            }

        }

    }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack)
            return;

        if (!Request.IsLocal && !Request.IsSecureConnection)
        {
            string redirectUrl = Request.Url.ToString().Replace("http:", "https:");
            Response.Redirect(redirectUrl);
        }
        {
            Page.Header.DataBind();
        }

        hdnPath.Value = Extension.ClientSession.WebPathRootProvider;

        litPatientName.Text = "<div class='txtActivePtName'>Patient: " + Extension.ClientSession.PatientLastName + ", " + Extension.ClientSession.PatientFirstName + "</div>";

        var isUserUnderPatientDirectory = IsUserUnderPatientDirectory();
        divPatient.Visible = isUserUnderPatientDirectory;
        Extension.ClientSession.IsUserUnderPatientDirectory = isUserUnderPatientDirectory;

        ValidatePopupError();

        // Validate if request from popup
        Extension.ClientSession.WasRequestFromPopup = false;
        popupNewAddPay.VisibleOnPageLoad = false;
        popupPaymentReceipt.VisibleOnPageLoad = false;

        // Show Add Patient and Pay popup
        AddPatientandPayPopup();
    }

    public static bool IsUserUnderPatientDirectory()
    {
        var url = HttpContext.Current.Request.Url;

        var values = url.AbsolutePath.Split(new[] { "/" }, StringSplitOptions.RemoveEmptyEntries);
        var count = values.Count();
        var directory = values[count > 2 ? 1 : 0];

        return !string.IsNullOrEmpty(Extension.ClientSession.PatientFirstName) && directory == "patient";
    }


    #region Clear Selected Patient

    protected void imgBtnClose_Click(object sender, ImageClickEventArgs e)
    {
        ClearClientSession();
        divPatient.Visible = false;
        Response.Redirect("~/patient/search.aspx");
    }

    #endregion

    private void ValidatePopupError()
    {
        if (!Extension.ClientSession.WasRequestFromPopup || !Extension.ClientSession.WasRequestFromGlobalAsax) return;
        Page.ClientScript.RegisterStartupScript(GetType(), "Close", "closePop();", true);
        Extension.ClientSession.WasRequestFromPopup = false;
        Extension.ClientSession.WasRequestFromGlobalAsax = false;
    }


    #region Add New Patient And Pay
    private void AddPatientandPayPopup()
    {
        var param = Request.Params["qp"];
        if (string.IsNullOrEmpty(param) || param != "1") return;
        popupNewAddPay.NavigateUrl = "~/report/pc_add_popup_lite.aspx?IsGlobal=1";
        popupNewAddPay.VisibleOnPageLoad = true;
    }

    #endregion

    private static void ClearClientSession()
    {
        Extension.ClientSession.SelectedPatientID = 0;
        Extension.ClientSession.PatientFirstName = null;
        Extension.ClientSession.PatientLastName = null;
        Extension.ClientSession.DateOfBirth = null;
    }


}
