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

public partial class paymentConfirmation_popup : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // Closing the popup in case of any error.
            ClientSession.WasRequestFromPopup = true;

            try
            {
                if (!string.IsNullOrEmpty(ClientSession.AmountandDownpayment) && ClientSession.ObjectType == ObjectType.Payment)
                {
                    // Fetching Payment method and amount from client session.
                    var values = ClientSession.AmountandDownpayment.Split(',');
                    hdnAmount.Value = values[0];
                    lblTotalAmount.Text = string.Format("{0:c}", Convert.ToDecimal(values[0]));
                    lblSelectedPaymentMethod.Text = values[1];
                    hdnIsDisableCheckBox.Value = string.IsNullOrEmpty(Request.Params["q"]) ? "0" : "1";
                }
            }
            catch (Exception)
            {

                throw;
            }


        }
    }



}
