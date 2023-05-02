using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EO.Pdf.Internal;
using PatientPortal.DataLayer;
using Telerik.Charting.Styles;
using Telerik.Web.UI;
using Excel;

public partial class importFeeSchedules_popup : BasePage
{

    private static Int32 FeeScheduleId
    {
        get
        {
            return Extension.ClientSession.ObjectType == ObjectType.FeeSchedule ? Convert.ToInt32(Extension.ClientSession.ObjectID) : 0;
        }
    }

    public static Int32 TotalSuccessfulRecords { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                // for close the RadWidnow in case of any error
                ClientSession.WasRequestFromPopup = true;
            }
            catch (Exception)
            {
                throw;
            }
        }
    }


    protected void btnSubmit_OnClick(object sender, EventArgs e)
    {
        var collection = GetCollectionFromFile();
        var message = IsExcelFileGood(collection);
        if (message != "")
        {
            RadWindow.RadAlert(message, 350, 150, "", "", "../Content/Images/warning.png");
            return;
        }

        var invalidRecords = SaveCPTCodes(collection);
        if (invalidRecords.Rows.Count > 0)
        {
            divInvalidRecords.Visible = true;
            grdInvalidRecords.DataSource = invalidRecords;
            grdInvalidRecords.DataBind();
            btnSubmit.ImageUrl = "../Content/Images/btn_resubmit.gif";
            btnCancel.ImageUrl = "../Content/Images/btn_close.gif";
            TotalSuccessfulRecords = collection.Rows.Count - invalidRecords.Rows.Count;
        }
        else
        {
            divInvalidRecords.Visible = false;
            RadWindow.RadAlert("<p>Import process was successful, all CPT codes processed.</p>", 350, 150, "", "reloadPage", "../Content/Images/success.png");
        }

    }

    private string IsExcelFileGood(DataTable collection)
    {

        if (collection.Rows.Count == 0)
            return "Your excel file is empty or you are trying to upload invalid file.";


        var row = collection.Rows[0];
        var errorMessage = string.Empty;

        if (chkHeaders.Checked)
        {
            var columns = row.Table.Columns.Cast<DataColumn>().Select(res => res.ColumnName).ToList();

            if (!columns.Contains("CPTCode"))
                errorMessage = "CPTCode column is missing. <br />";

            if (!columns.Contains("Category"))
                errorMessage += "Category column is missing. <br />";

            if (!columns.Contains("CPTName"))
                errorMessage += "CPTName column is missing. <br />";

            if (!columns.Contains("ProviderCharge"))
                errorMessage += "ProviderCharge column is missing. <br />";

            if (!columns.Contains("Allowable"))
                errorMessage += "Allowable column is missing!";
        }
        else
        {
            if (string.IsNullOrEmpty(GetValueFromDataRow(row, 0)))
                errorMessage = "CPTCode column is missing. <br />";

            if (string.IsNullOrEmpty(GetValueFromDataRow(row, 1)))
                errorMessage += "Category column is missing. <br />";

            if (string.IsNullOrEmpty(GetValueFromDataRow(row, 2)))
                errorMessage += "CPTName column is missing. <br />";

            if (string.IsNullOrEmpty(GetValueFromDataRow(row, 3)))
                errorMessage += "ProviderCharge column is missing. <br />";

            if (string.IsNullOrEmpty(GetValueFromDataRow(row, 4)))
                errorMessage += "Allowable column is missing.";
        }


        return errorMessage;
    }


    private DataTable SaveCPTCodes(DataTable collection)
    {
        var invalidRecords = new DataTable();

        foreach (var row in collection.AsEnumerable())
        {
            try
            {
                string cptCode, category, cptName, invoiceName, serviceTypeCode, cptType, description;
                decimal providerCharge, allowable;

                if (chkHeaders.Checked)
                {
                    cptCode = row["CPTCode"].ToString();
                    category = row["Category"].ToString();
                    cptName = row["CPTName"].ToString();
                    providerCharge = decimal.Parse(row["ProviderCharge"].ToString(), NumberStyles.Currency);
                    allowable = decimal.Parse(row["Allowable"].ToString(), NumberStyles.Currency);

                    // Additional fields
                    invoiceName = GetValueFromDataRow(row, 0, "InvoiceName");
                    serviceTypeCode = GetValueFromDataRow(row, 0, "ServiceTypeCode");
                    cptType = GetValueFromDataRow(row, 0, "CPTType");
                    description = GetValueFromDataRow(row, 0, "Description");

                }
                else
                {
                    cptCode = row[0].ToString();
                    category = row[1].ToString();
                    cptName = row[2].ToString();
                    providerCharge = decimal.Parse(row[3].ToString(), NumberStyles.Currency);
                    allowable = decimal.Parse(row[4].ToString(), NumberStyles.Currency);

                    // Addtional fields
                    invoiceName = GetValueFromDataRow(row, 5);
                    serviceTypeCode = GetValueFromDataRow(row, 6);
                    cptType = GetValueFromDataRow(row, 7);
                    description = GetValueFromDataRow(row, 8);

                }

                // Validating CPTCode
                ValidateCPTCode(cptCode);

                var cmdParam = new Dictionary<string, object>
                {
                    {"@FeeScheduleID", FeeScheduleId},
                    {"@UserID", Extension.ClientSession.UserID},
                    {"@CPTCode", cptCode.ToUpper()},
                    {"@CPTCategory", category},
                    {"@CPTName", cptName},
                    {"@ProviderCharge", providerCharge},
                    {"@Allowable", allowable},
                    {"@CPTAbbr", invoiceName},
                    {"@CPTType", cptType},
                    {"@ServiceTypeCode", serviceTypeCode},
                    {"@CPTDesc", description},
                };

                SqlHelper.ExecuteScalarProcedureParams("web_pr_feeschedulecpt_add", cmdParam);

            }
            catch (Exception)
            {
                CreateListOfInvalidRecords(invalidRecords, row);
            }
        }

        return invalidRecords;
    }

    private DataTable GetCollectionFromFile()
    {

        var fileCount = rauExcel.UploadedFiles.Count;
        if (fileCount <= 0)
        {
            return new DataTable();
        }

        var file = rauExcel.UploadedFiles[0];

        IExcelDataReader excelReader = null;
        switch (Path.GetExtension(file.FileName))
        {
            case ".xls":
                excelReader = ExcelReaderFactory.CreateBinaryReader(file.InputStream);
                break;
            case ".xlsx":
                excelReader = ExcelReaderFactory.CreateOpenXmlReader(file.InputStream);
                break;
        }

        excelReader.IsFirstRowAsColumnNames = chkHeaders.Checked;
        var result = excelReader.AsDataSet();

        excelReader.Close();
        return result.Tables.Count > 0 ? result.Tables[0] : new DataTable();
    }

    private void CreateListOfInvalidRecords(DataTable invalidRecords, DataRow dataRow)
    {

        if (invalidRecords.Columns.Count == 0)
        {
            invalidRecords.Columns.Add("CPTCode", typeof(string));
            invalidRecords.Columns.Add("CPTName", typeof(string));
            invalidRecords.Columns.Add("Category", typeof(string));
            invalidRecords.Columns.Add("ProviderCharge$", typeof(string));
            invalidRecords.Columns.Add("Allowable$", typeof(string));
            invalidRecords.Columns.Add("ProviderCharge", typeof(string));
            invalidRecords.Columns.Add("Allowable", typeof(string));
            invalidRecords.Columns.Add("CPTType", typeof(string));
            invalidRecords.Columns.Add("ServiceTypeCode", typeof(string));

        }

        // Creating new row
        var newRow = invalidRecords.NewRow();

        // Getting Data
        string cptCode, category, cptName, providerCharge, allowable, serviceTypeCode, cptType;

        if (chkHeaders.Checked)
        {
            cptCode = dataRow["CPTCode"].ToString();
            cptName = dataRow["CPTName"].ToString();
            category = dataRow["Category"].ToString();
            providerCharge = dataRow["ProviderCharge"].ToString();
            allowable = dataRow["Allowable"].ToString();

            // Additional fields
            serviceTypeCode = GetValueFromDataRow(dataRow, 0, "ServiceTypeCode");
            cptType = GetValueFromDataRow(dataRow, 0, "CPTType");
        }
        else
        {
            cptCode = dataRow[0].ToString();
            category = dataRow[1].ToString();
            cptName = dataRow[2].ToString();
            providerCharge = dataRow[3].ToString();
            allowable = dataRow[4].ToString();

            // Addtional fields
            serviceTypeCode = GetValueFromDataRow(dataRow, 6);
            cptType = GetValueFromDataRow(dataRow, 7);

        }



        // Assinging Values
        newRow["CPTCode"] = cptCode;
        newRow["CPTName"] = cptName;
        newRow["Category"] = category;
        newRow["ProviderCharge$"] = providerCharge;
        newRow["Allowable$"] = allowable;
        newRow["CPTType"] = cptType;
        newRow["ServiceTypeCode"] = serviceTypeCode;
        invalidRecords.Rows.InsertAt(newRow, 0);

    }

    private static string GetValueFromDataRow(DataRow row, Int32 index = 0, string columnName = null)
    {
        try
        {
            var value = !string.IsNullOrEmpty(columnName) ? row[columnName].ToString() : row[index].ToString();
            return value;
        }
        catch (Exception)
        {
            return null;
        }
    }

    private void ValidateCPTCode(string cptCode)
    {
        if (cptCode.Length < 3 || cptCode.Length > 5)
        {
            throw new Exception("CPTCode is invalid");
        }


        var regex = new Regex("^[a-zA-Z0-9]*$");
        var match = regex.Match(cptCode);
        if (!match.Success)
        {
            throw new Exception("CPTCode is invalid");
        }

    }


}
