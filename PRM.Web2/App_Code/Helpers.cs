using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using Telerik.Web.UI;

/// <summary>
/// Summary description for Helpers
/// </summary>
public static class Helpers
{
    public static decimal ParseDecimal(this object value, object numberStyles = null)
    {
        try
        {
            decimal parsedValue;

            if (numberStyles != null)
            {
                parsedValue = decimal.Parse(value.ToString(), (NumberStyles)numberStyles);
            }
            else
            {
                decimal.TryParse(value.ToString(), out parsedValue);
            }

            return parsedValue;
        }
        catch (Exception)
        {
            return 0;
        }
    }

    public static string GetDescription(this Enum value)
    {
        var fieldInfo = value.GetType().GetField(value.ToString());
        var attribute = Attribute.GetCustomAttribute(fieldInfo, typeof(DescriptionAttribute)) as DescriptionAttribute;
        return attribute == null ? value.ToString() : attribute.Description;
    }

    public static void InsertValueIntoDataTable(this DataTable dataTable, Int32 insertAt, string valueColumn, string textColumn, string value, string text)
    {
        var newRow = dataTable.NewRow();
        newRow[valueColumn] = value ?? (object)DBNull.Value;
        newRow[textColumn] = text;
        dataTable.Rows.InsertAt(newRow, insertAt);
    }

    public static void ResetSelection(this RadComboBox radComboBox, bool isFlagActive, Int32 value = 0)
    {
        if (isFlagActive)
        {
            radComboBox.SelectedValue = value.ToString();
        }
        else
        {
            radComboBox.SelectedIndex = 0;
        }
    }

    public static T GetControl<T>(this GridDataItem item, string name) where T : Control
    {
        return (T)GetControl(item, name);
    }

    public static T GetControl<T>(this GridItem item, string name) where T : Control
    {
        return (T)GetControl(item, name);
    }

    private static Control GetControl(Control item, string name)
    {
        try
        {
            return item.FindControl(name);
        }
        catch (Exception)
        {
            throw new InvalidOperationException(string.Format("Id {0} does not exist in given DataItem", name));
        }
    }

}