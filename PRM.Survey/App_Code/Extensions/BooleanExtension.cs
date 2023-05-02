using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


public static class BooleanExtension
{
    public static bool ToBoolean(this object sourceValue)
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
}