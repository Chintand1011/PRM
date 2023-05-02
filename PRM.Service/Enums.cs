using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PatientPortal.Service
{
    class Enums
    {
        public enum ProcessCheckCreditDebit
        {
            ValidCard = 11,
            ValidDebit = 15,
            ValidCheck = 21,
            ProcessCreditSale = 12,
            ProcessCreditReturn = 13,
            ProcessCreditVoid = 14,
            ProcessDebitSale = 16,
            ProcessDebitReturn = 17,
            ProcessDebitVoid = 18,
            ProcessCheckSale = 22,
            ProcessCheckReturn = 23,
            ProcessCheckVoid = 24
        }

        public enum SourceType
        {
            PatientPortalWeb = 1,
            PatientPortalPublic = 2,
            Service = 3
        }

        public enum ServiceInfo
        {
            UserID = -5
        }
        
        public enum FSPTransReasonType
        {
            AccidentalOverage = 1,
            CourtesyAdjustment = 2,
            ReturnServiceRefusal = 3,
            ServicesNotProvided = 4,
            AlternatePaymentMade = 7,
            ClaimAdjudicated = 8, 
            Other = 9,
            PNRefRenewal = 10
        }

        public enum FSPTransStateTypeID
        {
            Unknown = -1,
            Default = 0,
            Approved = 1,
            Scheduled = 2,
            Pending = 3,
            Settled = 4,
            Validated = 11,
            Returned = 21,
            Declined = 31,
            Referred = 32,
            Invalid = 41,
            Failed = 42,
            Exception = 43,
            Disputed = 51,
            Resolved = 52,
            ChargedBack = 53,
            Applied = 101,
            Adjusted = 102
        }
    }
}
