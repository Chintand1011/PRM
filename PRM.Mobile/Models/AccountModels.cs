using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Web.Security;

namespace PatientPortal.Mobile.Models
{
    public class LoginModel
    {
        
        [Required]
        [Display(Name = "PIN")]
        [RegularExpression("^[0-9]{4,8}$", ErrorMessage = "{0} Should be correct")]
        public Int32? Pin { get; set; }

        [Required]
        [Display(Name = "Account ID")]
        public Int32? AccountID { get; set; }

        [Required]
        [Display(Name = "Last Name")]
        [StringLength(50, ErrorMessage = "Max {1} chars allowed")]
        public string LastName { get; set; }

        [Display(Name = "Practice")]
        public string Practice { get; set; }

    }
    
}
