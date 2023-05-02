<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_approval.aspx.cs"
    Inherits="Terms_bluecredit_approval" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
    <style type="text/css">
        body
        {
            font-family: sans-serif;
            font-size: 11px;
        }
        p
        {
            margin: 0;
            padding: 0;
        }
        h2
        {
            margin: 0;
            padding: 0;
        }
        .main-div
        {
            width: 768px;
            padding: 15px;
            border: 1px solid black;
            font-family: Arial, Helvetica, sans-serif;
        }
        .col1
        {
            width: 270px;
        }
        .col2
        {
            width: 480px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="main-div">
        <div id="divButtons" runat="server">
            <b style="padding-bottom: 5px;">Page 10 of 10</b>
            <div style="float: right">
                <a href="javascript:;" onclick="showHidePopup()">
                    <img src="../Content/Images/btn_goback.gif" alt="Back" /></a>
            </div>
            <div style="float: right; display: none;">
                <a href="javascript:;">
                    <img src="../Content/Images/btn_save.gif" onclick="saveLendingAgreement()" alt="Save" />
                </a>
            </div>
            <br />
            <br />
            <br />
        </div>
        <p align="center">
            <img style="height: 47px; width: 238px;" alt="Provider" src="../Content/Images/Providers/logo_pr_113_anewudental.jpg"
                id="header_imgLogo" />
        </p>
        <h2 align="center">
            Important Information for Approved Cardholders</h2>
        <p>
            If you are approved for BlueCredit&reg;, please note your 16-digit account number
            and credit limit.</p>
        <br />
        <table>
            <tr>
                <td class="col1">
                    <b>Account Number:</b>
                    <br />
                    <br />
                    <b>Credit Limit:</b>
                    <br />
                    <div style="border: 1px solid black; border-radius: 20px; height: 150px; width: 200px">
                    </div>
                    <br />
                </td>
                <td class="col2">
                    _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _<br />
                    <br />
                    <b>$</b>______________________<b>Date</b>___________________
                    <br />
                    <p>
                        <b>Your BlueCredit Card:</b> If you are eligible and have elected to receive an
                        identification card, it should arrive within 14 days. You can use your account before
                        your card arrives with your account number and your ID.
                    </p>
                    <p>
                        <b>CareBlue BlueCredit Inquiry Center (866) 893-7864</b>
                        <br />
                        The CareBlue Inquiry Center can answer all questions regarding your BlueCredit account.
                    </p>
                    <p>
                        &nbsp;</p>
                    <p>
                        &nbsp;</p>
                    <p>
                        &nbsp;</p>
                    <p>
                        &nbsp;</p>
                    <p>
                        &nbsp;</p>
                    <p>
                        &nbsp;</p>
                    <p>
                        &nbsp;</p>
                </td>
            </tr>
        </table>
        <hr style="color: black;" />
        <br />
        <h4 align="center">
            IMPORTANT PROMOTIONAL OPTION INFORMATION</h4>
        <p>
            See Sales Slip for Additional Details about the options applicable to your purchase.</p>
        <p>
            <b>No Interest if paid in full within 6,12,18 or 24 Months *</b>
            <br />
            On qualifying purchases made with your BlueCredit credit account. Interest will
            be charged to your account from the purchase date if the promotional purchase is
            not paid in full within the promotional period. Not all promotional options are
            available at all providers. Minimum Monthly Payments Required and may pay off purchase
            before end of promotional period.</p>
        <ul>
            <li style="margin-top: 10px"><b>Minimum monthly payments shown on your billing statement
                are required to keep your account current.</b></li>
            <li style="margin-top: 10px"><b>The Promotional Purchase Summary in your billing statement
                will show the amount of Deferred Interest Charges accumulated to date.</b> </li>
            <li style="margin-top: 10px"><b>To avoid paying the Deferred Interest Charges on the
                promotional purchase, you must pay the promotional purchase balance in full within
                the promotional period.</b> </li>
        </ul>
        <p>
            <b>14.90% APR and Fixed Monthly Payments Required Until Paid in Full**</b>
            <br />
            On qualifying purchases made with your BlueCredit credit account. Not all promotional
            options are available at all providers. Fixed monthly payment amount based on repayment
            over 24, 36, 48 or 60 month period. Purchases of $1000 or more are eligible for
            a 24, 36 or 48 month offer and purchases of $2500 or more are eligible for a 60
            month offer.</p>
        <ul>
            <li style="margin-top: 10px"><b>The minimum monthly payment shown on your billing statement
                will include the fixed monthly payment.</b></li>
            <li style="margin-top: 10px"><b>You must make the minimum monthly payment shown on your
                billing statement to keep your account current.</b></li>
            <li style="margin-top: 10px"><b>You have the option of paying more than the required
                minimum monthly payment.</b></li>
        </ul>
    </div>
    <br />
    <div class="main-div">
        <h2 align="center">
            Promotional Options</h2>
        <p>
            <b>No Interest if paid in full within 6,12,18 or 24 Months *</b>
            <br />
            A minimum purchase amount may be required for promotional offers longer than 6 months.
            No interest will be charged on the promotional purchase if you pay the promotional
            purchase amount in full within the promotional period which may be 6, 12, 18 or
            24 months. If you do not, interest will be charged on the promotional purchase from
            the purchase date. Regular account terms apply to non-promotional purchases and,
            after promotion ends, to promotional balance, except the fixed monthly payment will
            apply until the promotion is paid in full. For new accounts: Purchase APR is 26.99%;
            Minimum Interest Charge is S2. Existing cardholders should see their credit card
            agreement for their applicable terms. Subject to credit approval.
        </p>
        <br />
        <p>
            <b>** 14.90% APR and Fixed Monthly Payments Required Until Paid in Full</b>
            <br />
            Interest will be charged on promotional purchases from the purchase date at a reduced
            14.90% APR, and fixed monthly payments are required until promotion is paid in full
            and will be calculated as follows: on 24 month promotions • 4.8439% of initial promotional
            purchase amount; on 36 month promotions - 3.4616% of initial promotional purchase
            amount: on 48 month promotions- 2.7780% of initial promotional purchase amount:
            and on 60 month promotions- 2.3737% of initial promotional purchase amount. The
            fixed monthly payment may be higher than the minimum payment that would be required
            if the purchase was a non-promotional purchase. Regular account terms apply to non-promotional
            purchases. For new accounts: Purchase APR is 26.99%; Minimum Interest Charge is
            $2. Existing cardholders should see their credit card agreement for their applicable
            terms. Subject to credit approval.
        </p>
        <%= OpenDate%>
        <%= CreditLimit%>
        <%= Balance%>
        <%= AccountName%>
        <%= AccountHolder%>
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

    function showHidePopup() {
        GetRadWindow().BrowserWindow.showHideRequestedPopups("bluecredit_privacy1", "bluecredit_approval");
    }

    function saveLendingAgreement() {
        GetRadWindow().BrowserWindow.saveLendingAgreement();
    }
</script>
