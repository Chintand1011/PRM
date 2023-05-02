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
            try
            {
                if (!string.IsNullOrEmpty(ClientSession.AmountandDownpayment) && ClientSession.ObjectType == ObjectType.Payment)
                {
                    var values = ClientSession.AmountandDownpayment.Split(',');
                    var amount = Convert.ToDecimal(values[0]);
                    lblTotalAmount.Text = string.Format("{0:c}", amount);
                    lblSelectedPaymentMethod.Text = values[1];
                    hdnAmount.Value = amount.ToString();
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }



}
