using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using PatientPortal.Utility;
using Telerik.Web.UI;

public partial class sysaddssn : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnSubmit_OnClick(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txtInputs.Text))
        {
            ShowMessage("Please input your data first!");
            return;
        }

        var patientIDsandSsnList = new List<Tuple<Int32, string, string, Int32?, Int32?>>();
        var isValid = CreateListandValidateInputs(patientIDsandSsnList);
        if (isValid)
        {
            foreach (var cmdParam in patientIDsandSsnList.Select(data => new Dictionary<string, object>
            {
                {"@PatientID", data.Item1},
                {"@PatientSSNenc", data.Item2 ?? (object)DBNull.Value},
                {"@PatientSSN4", data.Item4 ?? (object)DBNull.Value},
                {"@GuardianSSNenc", data.Item3 ?? (object)DBNull.Value},
                {"@GuardianSSN4", data.Item5 ?? (object)DBNull.Value}

            }))
            {
                SqlHelper.ExecuteScalarProcedureParams("sys_ssn_add", cmdParam);
            }
        }
        else
        {
            ShowMessage("Please enter data like PatientId, PatientSsn, GuardianSsn(1111111, 11111111, 1111111)");
        }

        ShowMessage("Records has been updated on file!");

    }

    private bool CreateListandValidateInputs(ICollection<Tuple<Int32, string, string, Int32?, Int32?>> list)
    {
        try
        {
            var listOfPatientIdandSsn = txtInputs.Text.Replace("\r\n", "|").Replace("\n", "|").Split(new[] { '|' }, StringSplitOptions.RemoveEmptyEntries).ToList();
            foreach (var patientIDandSsn in listOfPatientIdandSsn)
            {
                var data = patientIDandSsn.Split(',');
                var patientID = Convert.ToInt32(data[0]);
                var patientSsn = data[1].Trim();
                var guardianSsn = data[2].Trim();
                var patientSsn4 = string.IsNullOrEmpty(patientSsn) ? (int?)null : Convert.ToInt32(patientSsn.Substring(patientSsn.Length - 4, 4));
                var guardianSsn4 = string.IsNullOrEmpty(guardianSsn) ? (int?)null : Convert.ToInt32(guardianSsn.Substring(guardianSsn.Length - 4, 4));
                patientSsn = CryptorEngine.Encrypt(patientSsn);
                guardianSsn = CryptorEngine.Encrypt(guardianSsn);

                list.Add(new Tuple<int, string, string, Int32?, Int32?>(patientID, patientSsn, guardianSsn, patientSsn4, guardianSsn4));
            }
            return true;
        }
        catch (Exception)
        {
            return false;
        }

    }


    private void ShowMessage(string errorMessage)
    {
        ScriptManager.RegisterStartupScript(Page, typeof(Page), "showMessage", string.Format("showMessage('{0}')", errorMessage), true);
    }

}