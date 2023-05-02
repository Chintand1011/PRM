using System;
using System.Activities.Expressions;
using System.Activities.Statements;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading;
using System.Web;
using PatientPortal.Utility;
using Telerik.Web.UI;

/// <summary>
/// Summary description for Extension
/// </summary>
public static class Extension
{
    public static EndPointSession ClientSession
    {
        get
        {
            if (HttpContext.Current.Session["ClientSession"] == null)
                HttpContext.Current.Session["ClientSession"] = new EndPointSession();
            return (EndPointSession)HttpContext.Current.Session["ClientSession"];
        }
        set
        {
            HttpContext.Current.Session["ClientSession"] = value;
        }
    }


    public static void ClearPatientFromSession()
    {
        ClientSession.SelectedPatientID = 0;
        ClientSession.PatientFirstName = null;
        ClientSession.PatientLastName = null;
    }

    public static string ToApostropheStringIfAny(this string value)
    {
        return string.IsNullOrEmpty(value) ? string.Empty : value.Trim().Replace("'", "&#39;").Replace("\\r\\n", "<br>");
    }

    public static string Encrypt(this string originalValue)
    {
        if (string.IsNullOrEmpty(originalValue))
            return null;

        return CryptorEngine.Encrypt(originalValue);
    }

    public static string Decrypt(this string encryptedValue)
    {
        if (string.IsNullOrEmpty(encryptedValue))
            return null;

        return CryptorEngine.Decrypt(encryptedValue);
    }

    public static string ToSSNFormat(this string ssn)
    {
        return string.IsNullOrEmpty(ssn) ? ssn : ssn.Insert(3, "-").Insert(6, "-");
    }

    public static string UppercaseFirst(this string text)
    {
        var textInfo = new CultureInfo("en-US", false).TextInfo;
        return textInfo.ToTitleCase(text.ToLower());
    }

    public static void AltRowStyle(this GridItem item)
    {
        item.CssClass = "rgAltRow";
    }

    public static void RgRowStyle(this GridItem item)
    {
        item.CssClass = "rgRow";
    }

    public static bool ParseBool(this object sourceValue)
    {
        if (sourceValue == null || string.IsNullOrEmpty(sourceValue.ToString()))
            return false;

        if (sourceValue.ToString().ToLower().Equals("true"))
            return true;
        else if (sourceValue.ToString().ToLower().Equals("false"))
            return false;

        int value;
        Int32.TryParse(sourceValue.ToString(), out value);

        return value == 1;

    }

    public static int ParseInteger(this object sourceValue)
    {
        if (sourceValue == null)
            return 0;

        try
        {
            return Int32.Parse(sourceValue.ToString());
        }
        catch (Exception)
        {

            return 0;
        }
    }

    public static string AppendQueryString(this string url, object queryStrings, bool overriteQueryStrings = false)
    {
        if (string.IsNullOrEmpty(url) || queryStrings == null)
        {
            throw new Exception("Url or querystrings are missing");
        }

        if (overriteQueryStrings)
        {
            var index = url.IndexOf("?");
            url = index > 0 ? url.Split('?')[0] : url.Split('&')[0];
        }

        var type = queryStrings.GetType();
        var properties = type.GetProperties();


        foreach (var propertyInfo in properties)
        {
            var queryString = propertyInfo.Name;
            var value = type.GetProperty(queryString).GetValue(queryStrings, null).ToString();

            var index = url.IndexOf("?");
            if (index < 0)
            {
                url = url + "?" + queryString + "=" + value;
            }
            else
            {
                url = url + "&" + queryString + "=" + value;
            }
        }

        return url;
    }

    public static void AssignBackUpIdTo(this EndPointSession clientSession, string fieldName)
    {
        if (!(clientSession.BackUpID > 0))
            return;

        var property = clientSession.GetType().GetProperties().SingleOrDefault(x => x.Name == fieldName);
        if (property == null)
            throw new Exception("Invalid fieldname " + fieldName + "provided.");

        property.SetValue(clientSession, clientSession.BackUpID, null);
        clientSession.BackUpID = null;
    }

    public static bool IsAjaxRequest(this HttpRequest request)
    {
        return request.Headers["X-Requested-With"] == "XMLHttpRequest";

    }

}