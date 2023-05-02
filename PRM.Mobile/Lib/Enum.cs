using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


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

public enum EmailCode
{
    Succcess = 0,
    BouncedMail = 1,
    EmptyEmail = 2,
    InvalidEmailAddress = 3
}

public enum CreditCardTypeType
{
    MasterCard = 1,
    Visa = 2,
    Amex = 3,
    Discover = 5,
    Switch,
    Solo
}