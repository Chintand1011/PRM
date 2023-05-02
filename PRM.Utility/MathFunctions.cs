using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PatientPortal.Utility
{
    public static class MathFunctions
    {
        public static decimal CalcTotalPay(decimal financedAmount, decimal ratePromo, decimal termPromo, decimal rateStd, decimal termMax, decimal minPayment)
        {
            int cycle = 1;
            decimal totalPayments = 0;
            int diffDays = 31;

            while (cycle <= termPromo && financedAmount > 0)
            {
                diffDays = Convert.ToInt32((DateTime.Now.AddMonths(cycle) - DateTime.Now.AddMonths(cycle - 1)).TotalDays);
                financedAmount = Math.Ceiling(financedAmount * Convert.ToDecimal(Math.Pow(1 + Convert.ToDouble(ratePromo) / 36500, diffDays)) * 100) / 100; //Add interest for period
                if (financedAmount < minPayment + 1) { minPayment = financedAmount; } //the last payment may be different by a few pennies, so it checks to see if it's within a dollar
                financedAmount -= minPayment; //Subtract from financedAmount
                totalPayments += minPayment; //Keep adding Total Actual Payments
                cycle++;
            }
            while (cycle <= termMax && financedAmount > 0)
            {
                diffDays = Convert.ToInt32((DateTime.Now.AddMonths(cycle) - DateTime.Now.AddMonths(cycle - 1)).TotalDays);
                financedAmount = Math.Ceiling(financedAmount * Convert.ToDecimal(Math.Pow(1 + Convert.ToDouble(rateStd) / 36500, diffDays)) * 100) / 100; //Add interest for period
                if (financedAmount < minPayment + 1) { minPayment = financedAmount; } //the last payment may be different by a few pennies, so it checks to see if it's within a dollar
                financedAmount -= minPayment; //Subtract from financedAmount
                totalPayments += minPayment; //Keep adding Total Actual Payments
                cycle++;
            }
            return totalPayments;
        }

        // CALC FIRST YEAR Value
        public static decimal CalcY1Value(decimal financedAmount, decimal ratePromo, decimal termPromo, decimal rateStd, decimal termMax, decimal minPayment)
        {
            int cycle = 1;
            decimal totalPayments = 0;
            decimal totalInterest = 0;
            int diffDays = 31;
            if (termMax > 12) { termMax = 12; }//Cap number of months at 12 to identify first year value
            while (cycle <= termPromo && financedAmount > 0)
            {
                diffDays = Convert.ToInt32((DateTime.Now.AddMonths(cycle) - DateTime.Now.AddMonths(cycle - 1)).TotalDays);
                totalInterest += Math.Ceiling(financedAmount * Convert.ToDecimal(Math.Pow(1 + Convert.ToDouble(ratePromo) / 36500, diffDays)) * 100) / 100 - financedAmount;
                financedAmount = Math.Ceiling(financedAmount * Convert.ToDecimal(Math.Pow(1 + Convert.ToDouble(ratePromo) / 36500, diffDays)) * 100) / 100; //Add interest for period

                if (financedAmount < minPayment + 1) { minPayment = financedAmount; } //the last payment may be different by a few pennies, so it checks to see if it's within a dollar
                financedAmount -= minPayment; //Subtract from financedAmount
                totalPayments += minPayment; //Keep adding Total Actual Payments
                cycle++;
            }
            while (cycle <= termMax && financedAmount > 0)
            {
                diffDays = Convert.ToInt32((DateTime.Now.AddMonths(cycle) - DateTime.Now.AddMonths(cycle - 1)).TotalDays);
                totalInterest += Math.Ceiling(financedAmount * Convert.ToDecimal(Math.Pow(1 + Convert.ToDouble(rateStd) / 36500, diffDays)) * 100) / 100 - financedAmount;
                financedAmount = Math.Ceiling(financedAmount * Convert.ToDecimal(Math.Pow(1 + Convert.ToDouble(rateStd) / 36500, diffDays)) * 100) / 100; //Add interest for period
                if (financedAmount < minPayment + 1) { minPayment = financedAmount; } //the last payment may be different by a few pennies, so it checks to see if it's within a dollar
                financedAmount -= minPayment; //Subtract from financedAmounƒt
                totalPayments += minPayment; //Keep adding Total Actual Payments
                cycle++;
            }
            return totalInterest;
        }

        public static decimal CalculateEffectiveAPR(decimal financedamount, decimal totalpayments, decimal term)
        {
            if (financedamount == 0) return 0; //don't divide by 0!
            return Convert.ToDecimal((Math.Pow(Convert.ToDouble(totalpayments) / Convert.ToDouble(financedamount), 1 / Convert.ToDouble(term / 12)) - 1) * 100);
        }


        //The fixed monthly payment for a fixed rate mortgage is the amount paid by the borrower every month that ensures that the loan is paid off in full with interest at the end of its term. 
        //This monthly payment c depends upon the monthly interest rate r (expressed as a fraction, not a percentage, i.e., divide the quoted yearly percentage rate by 100 and by 12 to obtain the 
        //monthly interest rate), the number of monthly payments N called the loan's term, and the amount borrowed P known as the loan's principal; c is given by the formula:
        //c = (r / (1 - (1 + r)^-N))P   
        public static decimal CalcPMT(decimal APR, decimal term, decimal financedamount)
        {
            decimal MonthlyPayment;
            MonthlyPayment = Math.Ceiling(CalcMinPayRate(APR, term) * financedamount * 100) / 100;
            return MonthlyPayment;
        }

        public static decimal CalcMinPayRate(decimal APR, decimal term)
        {
            decimal MinPayRate;
            //http://money.stackexchange.com/questions/48775/what-is-the-formula-for-loan-payoff-with-daily-compounded-interest-and-monthly-p
            decimal EffectiveMonthlyInterest = Convert.ToDecimal(Math.Pow(1 + Convert.ToDouble(APR) / 36500, 30.416) - 1);
            MinPayRate = (EffectiveMonthlyInterest / (1 - Convert.ToDecimal(Math.Pow(1 + Convert.ToDouble(EffectiveMonthlyInterest), Convert.ToDouble(-term)))));
            return MinPayRate;
        }
    }
}
