<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_payments.aspx.cs"
    Inherits="Terms_bluecredit_payments" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
    <style type="text/css">
        table
        {
            
            border-spacing: 0;
            border-collapse: collapse;
        }
        
        table td, th
        {
            border: 1px solid black;
        }
        .col1
        {
            width: 230px;
        }
        .col2
        {
            width: 524px;
        }
        
        .header
        {
            background-color: darkblue;
            text-align: left;
        }
        body
        {
            font-size: 10px;
            font-family: sans-serif;
        }
        p
        {
            padding: 0;
            margin: 0;
        }
        
        .style1
        {
            background-color: darkblue;
            text-align: left;
            height: 2px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width: 768px;">
        <div id="divButtons" runat="server">
            <b style="padding-bottom: 5px;">Page 4 of 10</b> 
            <div style="float: right">
                <a href="javascript:;" onclick="showHidePopup('bluecreditSummary_popup','bluecredit_payments')">
                    <img src="../Content/Images/btn_goback.gif" alt="Go Back" /></a>
                &nbsp; &nbsp;
                <a href="javascript:;" onclick="showHidePopup('bluecredit_StandardProvisions','bluecredit_payments')">
                    <img src="../Content/Images/btn_next.gif" alt="Next" /></a>
            </div>
            <div style="float: right; display: none;">
                <a href="javascript:;">
                    <img src="../Content/Images/btn_save.gif" onclick="saveLendingAgreement()" alt="Save" />
                </a>
            </div>
        </div>
            <br />
            <br />
            <br />
        <h3 align="center">
            SECTION II: RATES, FEES AND PAYMENT INFORMATION OF THE BLUECREDIT CREDIT ACCOUNT
            AGREEMENT
        </h3>
        <table>
            <tr>
                <th colspan="2" class="header">
                    How Interest is Calculated
                </th>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        Your Interest Rate</h4>
                </td>
                <td class="col2">
                    <p>
                        We use a daily rate to calculate the interest on the balance on your account each
                        day. The daily rate for purchases is the APR times 1/365. The daily rate for purchases
                        is .07394% (APR 26.99%). Interest will be imposed in amounts or at rates not in
                        excess of those permitted by applicable law.</p>
                </td>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        When We Charge Interest</h4>
                </td>
                <td class="col2">
                    <p>
                        We charge interest on your purchases from the date you make the purchase until you
                        pay the purchase in full. See exceptions below.
                    </p>
                    We will not charge you interest during a billing cycle on any non-promotional purchases
                    if:
                    <ol>
                        <li>You had no "balance at the start of the biffing cycle; OR </li>
                        <li>You had a balance at the start of the billing cycle and you paid that balance in
                            full by the due date in that billing cycle. </li>
                    </ol>
                    We always charge interest on promotional purchases and their related fees from the
                    date you make the purchase.
                    <br />
                    <br />
                    We will credit, as of the start of the billing cycle, any payment you make by the
                    due date that we allocate to non-promotional purchases if:
                    <ol>
                        <li>You had no balance at the start of the previous billing cycle: OR </li>
                        <li>You had a balance at the start of the previous billing cycle and you paid that balance
                            in full by the due date in the previous billing cycle. </li>
                    </ol>
                </td>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        How We Calculate Interest</h4>
                </td>
                <td class="col2">
                    We figure the interest charge on your account separately for each balance type.
                    We do this by applying the daily rate to the daily balance for each day in the billing
                    cycle. A separate daily balance is calculated for the following balance types as
                    applicable: purchases and balances subject to different interest rates, plans or
                    special promotions. See below for more details on how this works.
                    <ol>
                        <li>. How to get the daily balance. We take the starting balance each day, add any new
                            charges and lees, and subtract any payments or credits. This gives us the daily
                            balance. Debt cancellation fees, if any, and late payment lees are treated as new
                            purchases. </li>
                        <li>How to get the daily interest amount. We multiply each daily balance by the daily
                            rate that applies. </li>
                        <li>How to get the starting balance for the next day. We add the daily interest amount
                            in step 2 to the daily balance from step 1. </li>
                        <li>How to get the interest charge for the billing cycle. We add all the daily interest
                            amounts that were charged during the billing cycle for each balance type. </li>
                    </ol>
                    We charge a minimum of S2.00 of interest in any billing cycle in which you owe interest.
                    Interest, as calculated above, is added as applicable to each balance type. Minimum
                    interest charges in excess of the calculated interest are treated as new purchases.
                </td>
            </tr>
        </table>
        <br />
        <table>
            <tr>
                <th colspan="2" class="style1">
                    How Fees Works
                </th>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        Late Payment Fee</h4>
                    <h4 style="padding: 0px 0 220px 0; height: 4px; width: 178px;">
                        <br />
                        <br />
                        <br />
                        <br />
                        Returned Payment Fee
                    </h4>
                    <br />
                </td>
                <td class="col2">
                    We will charge this lee if we do not receive the total minimum payment due on your
                    account by 11 p.m. (ET) on the due date.
                    <br />
                    This fee is equal to:
                    <ol>
                        <li>$25, if you have paid your total minimum payment due by the due date in each of
                            the prior six billing cycles. </li>
                        <br />
                        OR
                        <br />
                        <li>. $35, if you have failed to pay your total minimum payment due by the due date
                            in any one or more of the prior six billing cycles. </li>
                    </ol>
                    The late payment fee will not be more than the total minimum payment that was due.
                    <br />
                    <br />
                    We will charge this fee if any check, other instrument, or electronic payment authorization
                    you provide us in payment on your account, is not honored upon first presentment.
                    We will charge this lee even if the check, instrument or electronic authorization
                    is later honored. This fee is equal to:
                    <br />
                    <br />
                    This fee is equal to:
                    <ol>
                        <li>$25, if your payments have been honored in each of the prior six billing cycles.
                        </li>
                        <br />
                        OR
                        <br />
                        <li>$35, if any payment has been dishonored upon first presentment in any one or more
                            of the prior six billing cycles. The returned payment fee will not be more than
                            the total minimum payment that was due. </li>
                    </ol>
                    The late payment fee will not be more than the total minimum payment that was due.
                </td>
            </tr>
        </table>
        <h3 style="margin-bottom: 0">
            Minimum Payment Calculation</h3>
        <h4>
            Your total minimum payment is calculated as follows.</h4>
        <ol>
            <li>The Sum of:
                <ol style="list-style-type: lower-alpha;">
                    <li>The greater of the either
                        <ol style="list-style-type: lower-roman">
                            <li>$25 or </li>
                            <li>3.25% of the new balance shown on your billing statement (excluding any balance
                                attributable to any special promotional purchase with a unique payment calculation);
                                or</li>
                            <li>The sum of 1% of your new balance shown on your billing statement (excluding any
                                balance attributable to any special promotional purchase with a unique payment calculation)
                                plus interest, late payment fees and returned payment fees charged in the current
                                billing cycle; PLUS</li>
                        </ol>
                    </li>
                    <li>Any past due amounts; PLUS</li>
                    <li>Any payment due in connection with a special promotional purchase with a unique
                        payment calculation.</li>
                </ol>
            </li>
        </ol>
        <p>
            We round up to the next highest whole dollar in figuring your total minimum payment.
            Your total minimum payment will never be more than your new balance.
        </p>
        <h3>
            Special Promotional Financing Offer Information</h3>
        <br />
        <p style="margin-top: -20px;">
            At times, we may offer you special financing promotions for certain transactions
            (“special promotions”). The terms of this Agreement apply to any special promotions.
            However, any special promotional terms that are different than the terms in this
            Agreement Will be explained on promotional advertising or other disclosures provided
            to you. Below is a description of certain special promotions that may be offered:
        </p>
        <br/>
        <br/>
        <br/>
        <br/>
        <table>
            <tr>
                <td class="col1">
                    No Interest if Paid in Full Within 6 Months
                </td>
                <td class="col2" rowspan="4">
                    For each promotion, if the promotional purchase is not paid in full within the promotional
                    period, interest will be imposed from the date of purchase at the APR that applies
                    to your account when the promotional purchase is made.
                    <br />
                    <br />
                    At the time your account is opened, this is an APR of 26.99%.
                </td>
            </tr>
            <tr>
                <td class="col1">
                    No Interest if Paid in Full Within 12 Months
                </td>
            </tr>
            <tr>
                <td class="col1">
                    No Interest If Paid in Full Within 18 Months
                </td>
            </tr>
            <tr>
                <td>
                    No Interest if Paid in Full Within 24 Months
                </td>
            </tr>
        </table>
        <p>
            When you make a qualifying purchase under one of these promotions, no interest will
            be charged on the purchase if you pay the promotional purchase in full within the
            applicable promotional period. If you do not, interest will be charged on the promotional
            purchase from the date of the purchase. A minimum purchase amount may be required
            for promotional offers longer than 6 months Regular account terms apply to non-promotional
            purchases and, after promotion ends, to promotional balance. Offers are subject
            to credit approval. These promotional offers may not be available at all providers
            or at all times for all purchases. Please see any special promotion advertising
            or other disclosures provided to you for the full terms of any special promotion
            offered.
        </p>
    </div>
    </form>
</body>
</html>
<script type="text/javascript">

    function GetRadWindow() {
        var oWindow = null;
        if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
        else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

        return oWindow;
    }

    function showHidePopup(popupToBeOpen, popupToBeClose) {
        GetRadWindow().BrowserWindow.showHideRequestedPopups(popupToBeOpen, popupToBeClose);
    }

    function saveLendingAgreement() {
        GetRadWindow().BrowserWindow.saveLendingAgreement();
    }
</script>
