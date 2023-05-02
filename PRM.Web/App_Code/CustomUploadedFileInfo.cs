using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


[Serializable()]
public class CustomUploadedFileInfo
{
    public string ID { get; set; }

    public string FileName { get; set; }
    
    public string FileExtension { get; set; }

    public bool IsAddUpdate { get; set; }

    public Int32 IdentificationId { get; set; }

    }