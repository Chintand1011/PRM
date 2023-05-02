<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_section4.aspx.cs"
    Inherits="Terms_bluecredit_Section4" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
    <style type="text/css">
        body
        {
            font-family: sans-serif;
        }
        p
        {
            margin: 0;
            padding: 0;
        }
        li
        {
            font-size: 11px;
        }
        h3
        {
            padding: 0;
            margin: 0;
        }
        ul
        {
            margin: 5px 0 5px 30px;
        }
        h5
        {
            padding: 0;
            margin: 0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width: 768px;">
        <div id="divButtons" runat="server">
            <b style="padding-bottom: 5px;">Page 7 of 10</b>
            <div style="float: right">
                <a href="javascript:;" onclick="showHidePopup('bluecredit_StandardProvisions1','bluecredit_Section4')">
                    <img src="../Content/Images/btn_goback.gif" alt="Go Back" /></a>
                &nbsp; &nbsp;
                <a href="javascript:;" onclick="showHidePopup('bluecredit_privacy','bluecredit_Section4')">
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
            SECTION IV: OTHER IMPORTANT INFORMATION OF THE BLUECREDIT CREDIT ACCOUNT AGREEMENT
        </h3>
        <h5 style="background-color: lightcyan; font-size: 14px; margin-bottom: 5px;">
            STATE NOTICES</h5>
        <p style="font-size: 11px; margin-bottom: 5px;">
            <b style="font-size: 12px">CALIFORNIA RESIDENTS:</b> If you are married, you may
            apply for a separate account. NEW JERSEY RESIDENTS: Certain provisions of this Agreement
            are subject to applicable law. As a result, they may be void, unenforceable or inapplicable
            in some jurisdictions. None of these provisions, however, is void, unenforceable
            or inapplicable in New Jersey.
        </p>
        <p style="font-size: 11px; margin-bottom: 5px;">
            <b style="font-size: 12px">NEW YORK RESIDENTS:</b> A consumer credit report may
            be obtained in connection with evaluating your application and subsequently in connection
            with updates, renewals, or extensions of credit for which this application is made.
            Upon your request, you will be informed whether a report was obtained, and if so,
            of the name and address of the consumer reporting agency. This Agreement will not
            become effective unless and until you or an authorized user signs a sales slip or
            memorandum evidencing a purchase or lease of property or services or the payment
            of a fine by use of your credit card and prior thereto you will not be responsible
            for any purchase or lease of property or services by use of your credit card after
            its loss or theft.
        </p>
        <p style="font-size: 11px; margin-bottom: 5px;">
            <b style="font-size: 12px">OHIO RESIDENTS:</b> The Ohio laws against discrimination
            require that all creditors make credit equally available to all credit worthy customers,
            and that credit reporting agencies maintain separate credit histories on each individual
            upon request. The Ohio civil rights commission administers compliance with this
            law.
        </p>
        <p style="font-size: 11px; margin-bottom: 5px;">
            <b style="font-size: 12px">TENNESSEE RESIDENTS:</b> This Agreement will not become
            effective unless and until we have (1) provided the disclosures required pursuant
            to the federal Truth in Lending Act, (2) you or an authorized user uses the account,
            and (3) we extend credit to you for that transaction on your account.
        </p>
        <p style="font-size: 11px; margin-bottom: 5px;">
            <b style="font-size: 12px">WISCONSIN RESIDENTS:</b> No provision or a marital property
            agreement, a unilateral statement under sec. 766.59, Wis. Stats., or a court decree
            under sec. 766.70, Wis. Stats., adversely affects the interest or the creditor unless
            the creditor, prior to the time credit is granted, is furnished a copy of the agreement,
            statement or decree or has actual knowledge of the adverse provision when the obligation
            to the creditor is incurred. <b style="font-size: 12px">Married residents of Wisconsin
                applying for an individual account must give us the name and address of their spouse
                If the spouse also is a Wisconsin resident, regardless of whether the spouse may
                use the card. Please provide this information to us at 115 River Rd, Suite 424,
                Edgewater, NJ 07020.</b>
        </p>
        <b style="font-size: 12px;">Your signature on the application or sales slip (or online
            screen) for the Initial purchase approved on this account represents your signature
            on this Agreement. It is incorporated here by reference. </b>
        <br />
        <br />
        <b style="font-size: 12px">We have signed this Agreement as follows: </b>
        <p style="font-size: 11px; margin-bottom: 5px;">
            Mark Sapnar
            <br />
            Managing Officer
            <br />
            CareBlue Patient Finance
        </p>
        <b style="font-size: 12px">YOUR BILLING RIGHTS SUMMARY</b>
        <p style="font-size: 11px; margin-bottom: 5px;">
            <i>Your Billing Rights: Keep this Document for Future Use</i>
            <br />
            <br />
            <span style="margin-left: 30px;">This notice tells you about your rights and our responsibilities
                under the Fair Credit Billing Act.</span>
        </p>
        <p style="font-size: 11px">
            <i>What To Do If You Find A Mistake On Your Statement</i>
            <br />
            <br />
            <span style="margin-left: 30px;">If you think there is an error on your statement, write
                to us at:.</span><br />
            <span style="margin-left: 30px;">CareBlue Patient Finance</span><br />
            <span style="margin-left: 30px;">115 River Rd, Suite 424, Edgewater, NJ 07020</span><br />
            <span style="margin-left: 30px;">In your letter, give us the following information:</span>
        </p>
        <ul>
            <li>Account information: Your name and account number.</li>
            <li>Dollar amount: The dollar amount of the suspected error.</li>
            <li>Description of problem: II you think there is an error on your bill, describe what
                you believe is wrong and why you believe it is a mistake.</li>
        </ul>
        <p style="font-size: 11px">
            <span style="margin-left: 30px;">You must contact us:</span>
        </p>
        <ul>
            <li>Within 60 days after the error appeared on your statement. </li>
            <li>At least 3 business days before an automated payment is scheduled, if you want to
                stop payment on the amount you think is wrong. </li>
            <li>You must notify us of any potential errors in writing. You may call us, but if you
                do we are not required to investigate any potential errors and you may have to pay
                the amount in question. </li>
        </ul>
        <p style="font-size: 11px">
            <i>What Will Happen After We Receive Your Lett </i>
            <br />
            When we receive your letter, we must do two things:
        </p>
        <ol>
            <li>Within 30 days of receiving your letter, we must tell you that we received your
                letter. We will also tell you if we have already corrected the error.</li>
            <li>Within 90 days of receiving your letter, we must either correct the error or explain
                to you why we believe the bill is correct.</li>
        </ol>
        <p style="font-size: 11px">
            While we investigate whether or not there has been an error:</p>
        <ul>
            <li>We cannot try to collect the amount in question, or report you as delinquent on
                that amount.</li>
            <li>The charge in question may remain on your statement, and we may continue to charge
                you interest on that amount.</li>
            <li>While you do not have to pay the amount in question, you are responsible for the
                remainder of your balance.</li>
            <li>We can apply any unpaid amount against your credit limit.</li>
        </ul>
        <p style="font-size: 11px">
            After we finish our investigation, one of two things will happen:</p>
        <ul>
            <li>If we made a mistake: You will not have to pay the amount in question or any interest
                or other fees related to that amount.</li>
            <li>If we do not believe there was a mistake: You will have to pay the amount in question,
                along with applicable interest and lees. We will send you a statement of the amount
                you owe and the date payment is due. We may then report you as delinquent if you
                do not pay the amount we think you owe.
                <br />
                II you receive our explanation but still believe your bill is wrong, you must write
                to us within 10 days telling us that you still refuse to pay. If you do so, we cannot
                report you as delinquent without also reporting that you are questioning your bill.
                We must tell you the name of anyone to whom we reported you as delinquent, and we
                must let those organizations know when the manner has been settled between us. If
                we do not follow all or the rules above, you do not have to pay the first $50 of
                the amount you question even if your bill is correct. </li>
        </ul>
        <p style="font-size: 11px">
            <i>Your Rights If You Are Dissatisfied With Your Credit Purchases</i>
            <br />
        </p>
        <div style="margin-left: 30px">
            <p style="font-size: 11px">
                If you are dissatisfied with the goods or services that you have purchased with
                your credit account, and you have tried in good faith to correct the problem with
                the provider, you man have the right not to pay the remaining amount due on the
                purchase.
                <br />
                To use this right, all of the following must be true:</p>
            <ol>
                <li>The purchase must have been made in your home state or within 100 miles of your
                    current mailing address, and the purchase price must have been more than $50. (Note:
                    Neither of these are necessary if your purchase was based on an advertisement we
                    mailed to you, or if we own the company that sold you the goods or services.)</li>
                <li>. You must have used your credit account for the purchase. Purchases made with cash
                    advances from an ATM or with a check that accesses your credit card account do not
                    qualify.</li>
                <li>You must not yet have fully paid for the purchase. </li>
            </ol>
            <p style="font-size: 11px">
                If all of the criteria above are met and you are still dissatisfied with the purchase,
                contact us in writing at:
                <br />
                CareBlue Patient Finance
                <br />
                115 River Rd, Suite 424, Edgewater, NJ 07020
                <br />
                While we investigate, the same rules apply to the disputed amount as discussed above.
                After we finish our investigation, we will tell you our decision. At that point,
                if we think you owe an amount and you do not pay, we may report you as delinquent.
            </p>
        </div>
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
