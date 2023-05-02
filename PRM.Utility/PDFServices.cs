using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Data;
using System.Data.Sql;
using System.Diagnostics;
using System.IO;
using System.Web;
using System.Data.SqlClient;
using System.Threading;
using System.Configuration;
using System.Drawing;
using EO.Pdf;
using System.Net;
using System.Collections;
using System.Collections.Specialized;
using System.Xml;
using System.Net.Mail;
using System.Net.Mime;
using System.Reflection;
using PatientPortal.DataLayer;

namespace PatientPortal.Utility
{
    public static class PDFServices
    {
        public static void PDFCreate(string filename, string url, string defaultpath, string password = null)
        {
            var isExist = Directory.Exists(defaultpath);
            if (!isExist)
            {
                Directory.CreateDirectory(defaultpath);
            }
            // generate pdf
            string filepath = Path.Combine(defaultpath, filename.Trim());
            using (MemoryStream stream = new MemoryStream())
            {
                try
                {
                    //EO.Pdf 2011.2
                    //Runtime.AddLicense(
                    //    "yriJWZeksefyot7y8h/0q9zCw9bxpMbV1fryfqnNvBrBpOnv2R6usLTBzdry" +
                    //    "ot7y8h/0q9zCnrW7aOPt9BDtrNzCnrV14+30EO2s3MKetZ9Zl6TNF+ic3PIE" +
                    //    "EMidtbrkArZrqbXH4dFprrnB3rFps7P9FOKe5ff29ON3hI6xy59Zs/D6DuSn" +
                    //    "6un26bto4+30EO2s3OnPuIlZl6Sx5+Cl4/MI6YxDl6Sxy59Zl6TNDOOdl/gK" +
                    //    "G+R2mcng2c+d3aaxIeSr6u0AGbxbqrLBzZ9otZGby59Zl8DADOul5vvPuIlZ" +
                    //    "l6Sx5+6r2+kD9O2f5qT1DPOetKbC2rFwprbB3LFbl/r2HfKi5vLOzbJbl7PP");
                    //EO.Pdf 2012
                    EO.Pdf.Runtime.AddLicense(
                        "rp60psLasXCmtsHcsVuX+vYd8qLm8s7NsluXs8+4iVmXpLHn8qLe8vIf9Kvc" +
                        "wgEP7mns1+EFwYC8tcDj1X2wyd701nq0wc3a8qLe8vIf9Kvcwp61u2jj7fQQ" +
                        "7azcwp61dePt9BDtrNzCnrWfWZekzRfonNzyBBDInbW65AK2a6m1x+HRaa65" +
                        "wd6xabOz/RTinuX39vTjd4SOscufWbPw+g7kp+rp9um7aOPt9BDtrNzpz7iJ" +
                        "WZeksefgpePzCOmMQ5ekscufWZekzQzjnZf4ChvkdpnJ4NnPnd2msSHkq+rt" +
                        "ABm8W6uywc2faLWRm8ufWZfAwAzrpeb7z7iJWZeksefuq9vpA/Ttn+ak9Qzz");

                    HtmlToPdf.Options.PageSize = new SizeF(8.5f, 11f);
                    HtmlToPdf.Options.OutputArea = new RectangleF(0.0f, 0.0f, 8.5f, 11f);
                    HtmlToPdf.Options.AutoAdjustForDPI = false;
                    HtmlToPdf.Options.JpegQualityLevel = 100;
                    HtmlToPdf.Options.PreserveHighResImages = true;
                    HtmlToPdf.ConvertUrl(url, filepath);
                    
                    if (!string.IsNullOrEmpty(password))
                    {
                        PdfDocumentSecurity security = new PdfDocumentSecurity("1234");

                        //Load the PDF file with the given password
                        PdfDocument doc = new PdfDocument(filepath, security);
                        doc.Security.UserPassword = password;
                        doc.Security.OwnerPassword = password;
                        doc.Save(filepath);
                    }
                    // update status
                    stream.Close();

                }
                catch (Exception)
                {
                    throw;
                }
            }
        }

        public static void PDFMerge(List<string> docs, string resultpath, string resultname)
        {
            PdfDocument[] DocumentArray = new PdfDocument[docs.Count()];
            int count = 0;
            foreach (var pdf in docs)
            {
                DocumentArray[count] = new PdfDocument(pdf);
                count++;
            }
            var result = PdfDocument.Merge(DocumentArray);

            result.Save(resultpath + resultname);

            // Deleting the unneccessary files.
            foreach (var pdf in docs)
            {
                File.Delete(pdf);
            }
        }

        public static void CombineLendingAgreementPdfs(string pdfSource, Int32 blueCreditID)
        {
            var popupPath = string.Empty;
            var reader = SqlHelper.ExecuteDataTableProcedureParams("web_sysconfig_list", new Dictionary<string, object>());
            foreach (DataRow row in reader.Rows)
            {
                popupPath = row["WebPathRoot"].ToString();
            }
            
            var pdfList = new[] { "bluecredit_title", "bluecredit_application", "bluecreditSummary_popup", "bluecredit_payments", "bluecredit_StandardProvisions", "bluecredit_StandardProvisions1", "bluecredit_Section4", "bluecredit_privacy", "bluecredit_privacy1", "bluecredit_approval" };

            foreach (var pdf in pdfList)
            {
                PDFCreate(pdf + ".pdf", popupPath + "Terms/" + pdf + ".aspx?HideButtons=1", pdfSource);
            }

            var result = PdfDocument.Merge(new PdfDocument(pdfSource + pdfList[0] + ".pdf"),
                                           new PdfDocument(pdfSource + pdfList[1] + ".pdf"),
                                           new PdfDocument(pdfSource + pdfList[2] + ".pdf"),
                                           new PdfDocument(pdfSource + pdfList[3] + ".pdf"),
                                           new PdfDocument(pdfSource + pdfList[4] + ".pdf"),
                                           new PdfDocument(pdfSource + pdfList[5] + ".pdf"),
                                           new PdfDocument(pdfSource + pdfList[6] + ".pdf"),
                                           new PdfDocument(pdfSource + pdfList[7] + ".pdf"),
                                           new PdfDocument(pdfSource + pdfList[8] + ".pdf"),
                                           new PdfDocument(pdfSource + pdfList[9] + ".pdf"));

            result.Save(pdfSource + "la_" + blueCreditID + ".pdf");

            // Deleting the unneccessary files.

            foreach (var pdf in pdfList)
            {
                File.Delete(pdfSource + pdf + ".pdf");
            }

        }

        public static string FileDownload(string filePath, string fileName)
        {
            var message = ValidateFileLocation(filePath);

            if (!string.IsNullOrEmpty(message))
                return message;

            var fileStream = File.Open(filePath, FileMode.Open);
            var bytes = new byte[fileStream.Length];
            fileStream.Read(bytes, 0, Convert.ToInt32(fileStream.Length));
            fileStream.Close();
            
            HttpContext.Current.Response.AddHeader("Content-disposition", "attachment; filename=\"" + fileName + "\"");
            HttpContext.Current.Response.ContentType = "application/octet-stream";
            HttpContext.Current.Response.BinaryWrite(bytes);
            HttpContext.Current.Response.End();

            return message;
        }

        public static void DownloadandDeleteFile(string filePath, string fileName)
        {
            filePath = Path.Combine(filePath, fileName);

            var fileStream = File.Open(filePath, FileMode.Open);
            var bytes = new byte[fileStream.Length];
            fileStream.Read(bytes, 0, Convert.ToInt32(fileStream.Length));
            fileStream.Close();
            File.Delete(filePath);
            HttpContext.Current.Response.AddHeader("Content-disposition", "attachment; filename=" + fileName);
            HttpContext.Current.Response.ContentType = "application/octet-stream";
            HttpContext.Current.Response.BinaryWrite(bytes);
            HttpContext.Current.Response.End();
        }

        public static string PDFView(string pdfPath, string filename)
        {
            var message = ValidateFileLocation(pdfPath);

            if (!string.IsNullOrEmpty(message))
                return message;

            var client = new WebClient();
            var buffer = client.DownloadData(pdfPath);
            HttpContext.Current.Response.AddHeader("Accept-Ranges", "ascii");
            HttpContext.Current.Response.AddHeader("Content-Length", buffer.Length.ToString());
            HttpContext.Current.Response.AddHeader("Cache-Control", "post-check=0, pre-check=0");
            HttpContext.Current.Response.ContentType = "application/pdf";
            HttpContext.Current.Response.AddHeader("Content-Disposition", "inline; filename=\"" + filename + "\"");
            HttpContext.Current.Response.AddHeader("Pragma", "no-cache");
            HttpContext.Current.Response.Flush();
            HttpContext.Current.Response.BinaryWrite(buffer);
            HttpContext.Current.Response.End();
            return message;


        }


        //public static string ViewImage(string path)
        //{
        //    var message = ValidateFileLocation(path);

        //    if (!string.IsNullOrEmpty(message))
        //        return message;

        //    var client = new WebClient();
        //    var buffer = client.DownloadData(path);
        //    HttpContext.Current.Response.ContentType = "image/jpeg";
        //    HttpContext.Current.Response.AddHeader("content-length", buffer.Length.ToString());
        //    HttpContext.Current.Response.BinaryWrite(buffer);

        //    return message;
        //}

        public static string ValidateFileLocation(string path)
        {
            var isExist = File.Exists(path);
            return isExist ? string.Empty : "The requested file is not available at this time, please wait and try your request again later.";
        }
    }
}