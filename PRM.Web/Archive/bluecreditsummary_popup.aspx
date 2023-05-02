<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecreditsummary_popup.aspx.cs"
    Inherits="bluecreditSummary_popup" %>

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
        
        table th
        {
            height: 10px;
        }
        
        .col1
        {
            width: 260px;
        }
        .col2
        {
            width: 524px;
        }
        .OneColumn
        {
            width: 784px;
        }
        body
        {
            font-size: 12px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width: 768px;">
        <div id="divButtons" runat="server">
            <b style="padding-bottom: 5px;">Page 3 of 10</b>
            <div style="float: right">
                <a href="javascript:;" onclick="showHidePopup('bluecredit_application','bluecreditSummary_popup')">
                    <img src="../Content/Images/btn_goback.gif" alt="Go Back" /></a>
                &nbsp; &nbsp;
                <a href="javascript:;" onclick="showHidePopup('bluecredit_payments','bluecreditSummary_popup')">
                    <img src="../Content/Images/btn_next.gif" alt="Next" /></a>
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
        <h3 align="center">
            CAREBLUE PATIENT FINANCE
            <br />
            Keep for your records
            <br />
            SECTION 1: RATES AND FEES TABLE
            <br />
            BLUECREDIT ACCOUNT AGREEMENT
        </h3>
        <table>
            <tr>
                <th colspan="2" style="background-color: darkblue; text-align: left;">
                    Interest Rates and Interest Charges
                </th>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        Annual Percentage Rate
                        <br />
                        (APR) for Purchases</h4>
                </td>
                <td class="col2">
                    <h1>
                        26.99%
                    </h1>
                    <br />
                </td>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        Paying Interest</h4>
                </td>
                <td class="col2">
                    <p>
                        Your due date is at least 21 days after the close of each billing cycle. We will
                        not charge you any interest on non-promotional purchases if you pay your entire
                        balance by the due date each month. We will begin charging interest on promotional
                        purchases on the purchase date.</p>
                </td>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        Minimum Interest Charge</h4>
                </td>
                <td class="col2">
                    <p>
                        If you are charged interest, the charge will be no less than $2.</p>
                </td>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        For Credit Card Tips from the Consumer Financial Protection Bureau</h4>
                </td>
                <td class="col2">
                    <p>
                        To learn more about factors to consider when applying for or using a credit card,
                        visit the website of the Consumer Financial Protection Bureau at http://www.consumerfinance.gov/learnmore.</p>
                </td>
            </tr>
        </table>
        <br />
        <table>
            <tr>
                <th colspan="2" style="background-color: darkblue; text-align: left;">
                    Fees
                </th>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        Penalty Fees
                    </h4>
                    <ul>
                        <li>Late Payment </li>
                        <li>Returned Payment Up to $35</li>
                    </ul>
                </td>
                <td class="col2">
                    <br />
                    <br />
                    <p>
                        Up to $35<br />
                        Up to $35</p>
                </td>
            </tr>
        </table>
        <br />
        <p>
            <b>How we will calculate your balance:</b> We use a method called "daily balance".
            See your credit card account agreement for more details.
        </p>
        <p>
            <b>Billing Rigths:</b> Information on your rights to dispute transactions and how
            to exercise those rights is provided in your credit card account agreement.
        </p>
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <table>
            <tr>
                <th style="border: 0px;" class="OneColumn">
                    <h3 align="center">
                        Please read the following disclosure if you have received a pre-approval for a credit
                        account</h3>
                </th>
            </tr>
            <tr>
                <td>
                    <p style="font-size: 16px;">
                        You can choose to stop receiving "prescreened" offers of credit from this and other
                        companies by calling toll-free 1-866-220-2500. See PRE SCREEN & OPT-OUT NOTICE below
                        for more information about prescreened offers.
                    </p>
                </td>
            </tr>
        </table>
        <br />
        <table>
            <tr>
                <td>
                    <p style="font-size: 16px;">
                        PRESCREEN & OPT-OUT NOTICE: This "prescreened" offer of credit is based on information
                        in your credit report indicating that you meet certain criteria. This offer is not
                        guaranteed if you do not meet our criteria. If you do not want to receive prescreened
                        offers of credit from this and other companies, call the consumer reporting agencies
                        toll-free, at 1-888-567-8688, write to: Trans Union LLC, Attn: Marketing Opt-Out,
                        P.O. Box 505, Woodlyn, PA 19094-0505; Equifax Options, P.O. Box 740123, Atlanta,
                        GA 30374-0123; or Experian Opt-Out, P.O. Box 919, Allen, TX 75013.
                    </p>
                </td>
            </tr>
        </table>
        <%= PlanName%>
        <%= PromoRemainAbbr%>
        <%= TermRemainAbbr%>
        <%= RateStd%>
        <%= TermStd%>
        <%= TermMax%>
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
