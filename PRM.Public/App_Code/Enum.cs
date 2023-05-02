using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public enum UserType
{
    Patient,
    Provider
}

public enum ObjectType
{
    Bank,
    CreditCard,
    BlueCredit,
    AddPaymentPlan,
    EditPaymentPlan,
    EditPendingPayment,
    PaymentReceipt,
    ManageBankAccount,
    ManageCreditCard,
    Payment,
    Estimate,
    Statement
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

public enum Statements
{
    Primary = 1,
    Secondary = 2
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

public enum YesNo
{
    No = 0,
    Yes = 1
}

public enum ResponsibilityType
{
    Patient = 0,
    Guardian = 1
}

public enum SourceType
{
    PatientPortalWeb = 1,
    PatientPortalPublic = 2,
    Service = 3
}

public enum EmailCode
{
    Succcess = 0,
    BouncedMail = 1,
    EmptyEmail = 2,
    InvalidEmailAddress = 3
}

public enum AddMessageTypes
{
    Unknown = -1,
    Default = 0,
    BCGeneral = 20,
    BCStatus = 21,
    BCLimitIncrease = 22,
    BCNewAccount = 23,
    BCAssignment = 24,
}
