using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Security;
using System.Web;
using System.Web.Mvc;

namespace PatientPortal.Mobile.Models
{
    public class AddCardsModel
    {

        [Required]
        [Display(Name = "Number")]
        [CreditCard]
        public string CardNumber { get; set; }


        [Required]
        [Display(Name = "Expiry Month")]
        [Range(1, 12, ErrorMessage = "Invalid Month")]
        public int? ExpireMonth { get; set; }

        [Required]
        [Display(Name = "Expiry Year")]
        [Remote("ValidateYear", "Public", ErrorMessage = "{0} should be greater than current year")]
        public int? ExpireYear { get; set; }

        [Required]
        [Display(Name = "First")]
        public string FirstName { get; set; }

        [Required]
        [Display(Name = "Last")]
        public string LastName { get; set; }

        [Required]
        [Display(Name = "Zip")]
        public Int32 Zip { get; set; }

        [Required]
        [Display(Name = "CVV")]
        [RegularExpression("^[0-9]{3,4}$", ErrorMessage = "{0} should be min 3 and max 4 digits long")]
        public int? CvvSecurityID { get; set; }

    }





}