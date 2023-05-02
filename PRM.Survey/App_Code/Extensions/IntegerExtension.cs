using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


public static class IntegerExtension
{
    public static int ToInteger(this object value)
    {
        try
        {
            return Convert.ToInt32(value);
        }
        catch (Exception)
        {
            return 0;
        }
    }

}