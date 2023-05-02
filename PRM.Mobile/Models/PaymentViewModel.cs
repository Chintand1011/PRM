using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace PatientPortal.Mobile.Models
{
    public class PaymentViewModel
    {
        [Required]
        [Display(Name = "Statement")]
        public Int32 StatementID { get; set; }

        [Required]
        [Display(Name = "Payment")]
        public Int32 PaymentCardID { get; set; }

        [Required]
        [Display(Name = "Amount")]
        [RegularExpression(@"^[1-9][0-9]*(\.[0-9]+)?|0+\.[0-9]*[1-9][0-9]*$", ErrorMessage = "{0} should be greather than 0")]
        [Remote("ValidateAmount", "Public", AdditionalFields = "StatementID", ErrorMessage = "Amount should be less than statement balance")]
        public decimal Amount { get; set; }


        [Display(Name = "Email")]
        [EmailAddress]
        public string Email { get; set; }

    }
}