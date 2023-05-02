using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PatientPortal.Utility
{
    class Enums
    {
        public enum TUColorCodes
        {
            Unknown = -1,
            Default = 0,
            Green = 1,
            Yellow = 2,
            Red = 3
        }

        public enum TUResultTypeID
        {
            Unknown = -1,
            Default = 0,
            Success = 1,
            Failure = 2
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
            Voided = 5, 
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
        public enum TransactionTypeID
        {
            Unknown	= -1,
            Default	= 0,
            ValidateCreditCard = 11,
            ProcessCreditCharge = 12,
            ProcessCreditReturn = 13,
            ProcessCreditVoid = 14,
            ValidateDebitCard = 15,
            ProcessDebitCharge = 16,
            ProcessDebitReturn = 17,
            ProcessDebitVoid  = 18,
            ValidateCheck = 21,
            ProcessCheckCharge = 22,
            ProcessCheckReturn = 23,
            ProcessCheckVoid = 24,
            CashTendered = 101,
            OutsideCreditCharge = 102,
            OutsideCheckCharge = 103,
            ProviderAdjustment = 104,
            MiscAdminCharge = 105,
            OutsideCreditAccount = 106,
            CharityAdjustment = 107,
            ProviderWriteOff = 108,
            StatementCancelled = 197,
            ReturnCheckAdjustment = 198,
            VoidAdjustment = 199,
            BlueCreditCharge = 201,
            BlueCreditReturn = 202,
            BlueCreditInterest = 203,
            AdjudicationRefund = 204,
            AdjudicationDebit = 205,
            PaymentPlanFee = 301,
            BlueCreditAccountFee = 302,
            ReturnCheckNSFFee = 303
        }
        public enum EmailCode
        {
            Unknown = -1, //UnsubscribedEmailAddressException is a possible one from the documentation, but we should never get it.
            Succcess = 0,
            BouncedMail = 1,
            EmptyEmail = 2,
            InvalidEmailAddress = 3
        }
        public enum ServiceInfo
        {
            UserID = -5
        }
    }
}
