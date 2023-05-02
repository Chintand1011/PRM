using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class paymentTransactionReceipt_popup : BasePage
{
    public string ReceiptMessage { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                ClientSession.WasRequestFromPopup = true;
            }
            catch (Exception)
            {

                throw;
            }


        }
    }
}
