using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;

public enum UserType
{
    Patient,
    Provider
}

public enum ObjectType
{
    PatientManagement,
    EligibilityDetail,
    ManageEligibility,
    RequestPatientBenefit,
    BlueCreditDetail,
    PFSReportDetail,
    PFSReportAddPatient,
    CarriesSearch,
    FeeSchedule,
    AddPaymentPlan,
    EditPaymentPlan,
    Estimate,
    BlueCredit,
    BlueCreditEdit,
    Transaction,
    Statement,
    Reset,
    PaymentReceipt,
    AddCreditOrBankAccount,
    ManageBankAccount,
    ManageCreditCard,
    Payment,
    RefreshPage
}

public enum AccountType
{
    Checking = 0,
    Savings = 1
}

public enum CardClass
{
    Personal = 0,
    Corporate = 1
}

public enum Gender
{
    UnKnown = -1,
    Male = 1,
    Female = 2
}

public enum AddressType
{
    Primary = 1,
    Secondary = 2
}

public enum ImageType
{
    InsuranceCard = 0,
    IDCard = 1
}

public enum FinancialResponsibility
{
    Patient = 0,
    Guardian = 1
}

public enum BillSchedule
{
    Monthly = 0,
    BiMonthly = 1
}

public enum StatusType
{
    InActive = 0,
    Active = 1
}

public enum ContractType
{
    [Description("Out of Network")]
    OutOfNetwork = 0,

    [Description("In Network")]
    InNetwork = 1
}

public enum Reimbursement
{
    [Description("Direct to Practice")]
    DirecttoPractice = 0,

    [Description("Patient Endorsed Check")]
    PatientEndorsedCheck = 1
}

public enum YesNo
{
    No = 0,
    Yes = 1
}

public enum DefaultSelectedTypes
{
    ProfessionalOfficeVisit = 23,
    RelationalNameSelf = 18
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

public enum Status
{
    Failure = 0,
    Success = 1
}

public enum TransactionTypeID
{
    CancelVoid = 1,
    FullRefund = 2,
    PartialRefund = 3,
    Resubmit = 4,
    Cancel = 10,
    Modify = 11,
    UpdateNotes = 20,
}

public enum TransactionType
{
    CreditSale = 12,
    DebitSale = 16,
    CheckSale = 22
}


public enum ModifyTransType
{
    ValidateCreditCard = 11,
    ProcessCreditCharge = 12,
    ProcessCreditReturn = 13,
    ProcessCreditVoid = 14,
    ValidateDebitCard = 15,
    ProcessDebitCharge = 16,
    ProcessDebitReturn = 17,
    ProcessDebitVoid = 18,
    ValidateCheck = 21,
    ProcessCheckCharge = 22,
    ProcessCheckReturn = 23,
    ProcessCheckVoid = 24

}

public enum SourceType
{
    PatientPortalWeb = 1,
    PatientPortalPublic = 2,
    Service = 3
}

public enum RoleType
{
    ReadOnly = 0,
    User = 1,
    Reporting = 2,
    Billing = 3,
    Manager = 4,
    Administrator = 5,
    SystemAdministrator = 10
}

public enum EmailCode
{
    Unknown = -1, //UnsubscribedEmailAddressException is a possible one from the documentation, but we should never get it.
    Succcess = 0,
    BouncedMail = 1,
    EmptyEmail = 2,
    InvalidEmailAddress = 3
}

public enum TUColorCodes
{
    Unknown = -1,
    Default = 0,
    Green = 1,
    Yellow = 2,
    Red = 3
}

public enum CreditCardTypeType
{
    MasterCard = 1,
    Visa = 2,
    [Description("American Express")]
    Amex = 3,
    [Description("Discover Card")]
    Discover = 5,
    Switch,
    Solo
}

public enum MessageStatusType
{
    UnRead = 1,
    Read = 2,
}


public enum PatientStatusCheck
{
    Unknown = 0,
    GoodPass = 1,
    Informational = 2,
    Warning = 3,
    Caution = 4,
    FailError = 5,
    Critical = 6
}

public enum EligibilityDestDateTime
{
    [Description("Dep_DOB")]
    DepDOB,

    [Description("Sub_DOB")]
    SubDOB,

    [Description("Resp_Date")]
    RespDate,

    [Description("Resp_Time")]
    RespTime,

    [Description("HBP_Start_Date")]
    HBPStartDate,
}


public enum EligibilityDestInteger
{
    [Description("Resp_PayerIDCode")]
    RespPayerIDCode,

    [Description("Resp_RefIdent")]
    RespRefIdent
}

public enum EligibilityDestAlphaNumeric
{
    [Description("Dep_Gender")]
    DepGender,

    [Description("Dep_Name_First")]
    DepNameFirst,

    [Description("Dep_Name_Last")]
    DepNameLast,

    [Description("Dep_Name_Mid")]
    DepNameMid,

    [Description("Dep_Relation")]
    DepRelation,

    [Description("Dep_Type")]
    DepType,

    [Description("HBP_Desc")]
    HBPDesc,

    [Description("HBP_Payer")]
    HBPPayer,

    [Description("HBP_PayerID")]
    HBPPayerID,

    [Description("HBP_Payer_Addr")]
    HBPPayerAddr,

    [Description("HBP_Payer_City")]
    HBPPayerCity,

    [Description("HBP_Payer_State")]
    HBPPayerState,

    [Description("HBP_Payer_Zip")]
    HBPPayerZip,

    [Description("HBP_Status_Chiro")]
    HBPStatusChiro,

    [Description("HBP_Status_Dent")]
    HBPStatusDent,

    [Description("HBP_Status_Emerg")]
    HBPStatusEmerg,

    [Description("HBP_Status_Gen")]
    HBPStatusGen,

    [Description("HBP_Status_Hos")]
    HBPStatusHos,

    [Description("HBP_Status_HosIP")]
    HBPStatusHosIP,

    [Description("HBP_Status_HosOP")]
    HBPStatusHosOP,

    [Description("HBP_Status_Med")]
    HBPStatusMed,

    [Description("HBP_Status_Prof")]
    HBPStatusProf,

    [Description("HBP_Status_Vis")]
    HBPStatusVis,

    [Description("HBP_Type")]
    HBPType,

    [Description("Resp_PayerIDCode")]
    RespPayerIDCode,

    [Description("Resp_RefIdent")]
    RespRefIdent,

    [Description("Resp_Result")]
    RespResult,

    [Description("Sub_Addr")]
    SubAddr,

    [Description("Sub_City")]
    SubCity,

    [Description("Sub_Gender")]
    SubGender,

    [Description("Sub_GroupID")]
    SubGroupID,

    [Description("Sub_MemberID")]
    SubMemberID,

    [Description("Sub_Name_First")]
    SubNameFirst,

    [Description("Sub_Name_Last")]
    SubNameLast,

    [Description("Sub_Name_Mid")]
    SubNameMid,

    [Description("Sub_State")]
    SubState,

    [Description("Sub_Zip")]
    SubZip,

}

public enum HousingType
{
    [Description("Not Specificed")]
    NotSpecificed = -1,
    Own = 1,
    Rent = 2,
    Other = 3
}