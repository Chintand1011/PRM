using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Helpers
/// </summary>
public static class Helpers
{
    public static decimal TryParseDecimal(this string value)
    {
        decimal parsedValue;
        decimal.TryParse(value, out parsedValue);
        return parsedValue;
    }
}