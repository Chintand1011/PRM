using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Hcpcs
/// </summary>
public class Hcpcs
{
    public Int32 SerialNo { get; set; }

    public string CptNo { get; set; }

    public string Quantity { get; set; }

    public DateTime? Dated { get; set; }

    public string FieldS { get; set; }

    public string Description { get; set; }

    public string Charge { get; set; }

    public decimal? AdjustMent { get; set; }

}