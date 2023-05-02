using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Web.UI;

public partial class transaction_popup : BasePage
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                ClientSession.WasRequestFromPopup = true;

                if (ClientSession.ObjectID != null && ClientSession.ObjectType == ObjectType.Transaction)
                {
                    GetSelectedTransactionInformation();
                }
            }
            catch (Exception)
            {

                throw;
            }

        }
    }

    private void GetSelectedTransactionInformation()
    {
        var cmdParams = new Dictionary<string, object>
                                {
                                    {"@PracticeID",ClientSession.PracticeID},
                                    {"@TransactionID",ClientSession.ObjectID},
                                    {"@UserID", ClientSession.UserID}
                                };

        var dataTable = SqlHelper.ExecuteDataTableProcedureParams("web_pr_transaction_get", cmdParams);
        lblTransactionID.Text = dataTable.Rows[0]["TransactionID"].ToString();
        lblPatient.Text = dataTable.Rows[0]["PatientName"].ToString();
        lblDOB.Text = dataTable.Rows[0]["DateofBirth"].ToString();
        lblProviderName.Text = dataTable.Rows[0]["ProviderName"].ToString();
        lblAccountID.Text = dataTable.Rows[0]["AccountID"].ToString();
        lblStatementID.Text = dataTable.Rows[0]["StatementID"].ToString();
        lblStatementType.Text = dataTable.Rows[0]["CreditStatusTypeAbbr"].ToString(); ;
        lblPaymentPlanAccount.Text = dataTable.Rows[0]["PaymentPlanID"].ToString();
        lblBlueCreditAccount.Text = dataTable.Rows[0]["BlueCreditID"].ToString();
        lblTransactionDate.Text = dataTable.Rows[0]["TransactionDate"].ToString();
        lblTransactionType.Text = dataTable.Rows[0]["TransactionTypeAbbr"].ToString();
        lblTransactionStatus.Text = dataTable.Rows[0]["TransStateTypeAbbr"].ToString();
        lblPaymentCardType.Text = dataTable.Rows[0]["PaymentCardTypeAbbr"].ToString();
        lblCardLast4.Text = dataTable.Rows[0]["CardLast4"].ToString();
        lblAmount.Text = dataTable.Rows[0]["Amount$"].ToString();
        lblBalance.Text = dataTable.Rows[0]["Balance$"].ToString();
        lblMessage.Text = dataTable.Rows[0]["MessageAbbr"].ToString();
        lblAuthorizationReference.Text = dataTable.Rows[0]["AuthRef"].ToString();
        lblSystemUser.Text = dataTable.Rows[0]["UserName"].ToString();
        lblTransactionNotes.Text = dataTable.Rows[0]["Notes"].ToString();
        lblSourceIP.Text = dataTable.Rows[0]["IPAddress"].ToString();
        lblRecordDate.Text = dataTable.Rows[0]["DateCreated"].ToString();
    }


}