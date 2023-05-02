<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_standardprovisions.aspx.cs"
    Inherits="bluecredit_StandardProvisions" %>

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
        p {
            margin: 0;
            padding: 0
        }
        h5 {
             display:inline; 
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width: 768px;">
        <div id="divButtons" runat="server">
            <b style="padding-bottom: 5px;">Page 5 of 10</b>
            <div style="float: right">
                <a href="javascript:;" onclick="showHidePopup('bluecredit_payments','bluecredit_StandardProvisions')">
                    <img src="../Content/Images/btn_goback.gif" alt="Go Back" /></a>
                &nbsp; &nbsp;
                <a href="javascript:;" onclick="showHidePopup('bluecredit_StandardProvisions1','bluecredit_StandardProvisions')">
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
            SECTION III: STANDARD PROVISIONS OF THE BLUECREDIT CREDIT ACCOUNT AGREEMENT
        </h3>
        <h5 style="background-color: lightcyan">
            ABOUT THE CREDIT CARD ACCOUNT AGREEMENT</h5><br/>
        <p>
            <b>This agreement:</b> This Agreement. This is an Agreement between you and CareBlue
            Patient Finance, 115 River Rd, Suite 424 Edgewater, NJ 07020, for your credit account.
            By opening or using your account you agree to the terms of the entire Agreement.
            The entire Agreement includes the four sections of this document and the application
            you submitted to us in connection with the account. These documents replace any
            other agreement relating to your account that you or we made earlier or at the same
            time.
        </p><br/>
        <p>
            <b>Parties to this agreement</b>. This Agreement applies to each accountholder approved
            on the account and each of you is responsible for paying the full amount due, no
            matter which one uses the account. We may treat each of you as one accountholder
            and may refer lo each of you as “you” or “your”. CareBlue Patient Finance may be
            referred to as “we”, “us” or “our”.
        </p><br/>
        <p>
            <b>Changes to this agreement.</b> We may change, add or delete terms of this Agreement,
            including interest rates, fees and charges.
        </p><br/>
        <p>
            <b>Special Promotions.</b> The terms of this Agreement apply to any special promotion.
            However, any special promotional terms that are different than the terms in this
            Agreement will be explained on promotional advertising or other disclosures provided
            to you.
        </p><br/>
        <h5 style="background-color: lightcyan">
            HOW TO USE YOUR ACCOUNT/CARD</h5><br/>
        <p>
            <b>Use Of Your Account:</b> Use Of Your Account. You may use your account only for
            lawful personal, family or household purposes. You may use your account for purchases
            from provider that accept the card.
        </p><br/>
        <p >
            <b>You Promise To Pay.</b> You promise to pay us for all amounts owed to us under
            this Agreement
        </p><br/>
        <p>
            <b>Your Responsibility.</b> Each account holder may receive a card. You may not
            allow anyone else to use your account. If you do, or if you ask us to send a card
            to someone else, you will be responsible for paying for all charges resulting from
            their transactions.
        </p><br/>
        <p>
            <b>Purchase limits.</b> To prevent fraud, we may limit the number or dollar amount
            of purchases you can make in any particular amount of time. We also may decline
            any particular charge on your account for any reason.
        </p><br/>
        <p style="font-size: 13px;">
            <b>Credit limit.</b> You will be assigned a credit limit that we may increase or
            decrease from time to time. If we approve a purchase that makes you go over your
            credit limit, we do not give up any rights under I his Agreement and we do not treat
            it as an increase in your credit limit.
        </p><br/>
        <h5 style="background-color: lightcyan">
            HOW AND WHEN YOU MAKE PAYMENTS</h5><br/>
        <p>
            <b>When Payments Are Due.</b> You must pay at least the total minimum payment due
            on your account by 11 pm (ET) on the due date of each billing cycle. Payments received
            after 11 pm (ET) will be credited as of the next day. You may at any time pay, in
            whole or in part, the total unpaid balance without any additional charge for prepayment.
            If you have a balance subject to Interest, earlier payment may reduce the amount
            of interest you will pay. We may delay making credit available on your account in
            the amount of your payment even though we will credit your payment when we receive
            it.
        </p><br/>
        <p>
            <b>Payment Options.</b> You can pay by mail or online. We may allow you to make
            payments over the phone but we will charge you a fee to make expedited phone payments.
            Your payment must be made in U S. dollars by physical or electronic check, money
            order or a Similar Instrument from a bank located in the United States.
        </p><br/>
        <p>
            <b>Payment Allocation.</b> We will apply the required total minimum payment to balances
            on your account using any method we choose. Any payment you make in excess of the
            required total minimum payment will be applied to higher APR balances before lower
            APR balances. Applicable law may require or permit us to apply excess payments in
            a different manner in certain situations, such as when your account has a certain
            type of special promotion.
        </p><br/>
        <h5 style="background-color: lightcyan">
            INFORMATION ABOUT YOU</h5><br/>
        <p>
            <b>Using and Sharing Your Information.</b> When you applied for an account, you
            gave us, providers that accept the card and program sponsors information about yourself
            that we could share with each other. Providers that accept the card and program
            sponsors (and their respective affiliates) will use the information In connection
            with the credit program and for things like creating and updating their records
            and offering you special benefits. More information about how we use and share information
            is set forth in the privacy policy for your account.
        </p><br/>
        <p>
            <b>Address/Phone Change.</b> You agree to tell us right away if you change your
            address or phone number(s). We will contact you at the address or phone number in
            our records until we update our records with your new address or phone number.
        </p><br/>
        <p>
            <b>Consent to Communications.</b> You consent to us contacting you using all channels
            of communication and for all purposes. We will use the contact information you provide
            to us. You also consent to us and any other owner or servicer of your account contacting
            you using any communication channel. This may include text messages, automatic telephone
            dialing systems and/or an artificial or prerecorded voice. This consent applies
            even if you are charged for the call under your phone plan. You are responsible
            for any charges that may be billed to you by your communications carriers when we
            contact you.
        </p><br/>
        <p>
            <b>Telephone Monitoring.</b> For quality control, you allow us to listen to or record
            telephone conversations between you and us.
        </p><br/>
        <h5 style="background-color: lightcyan">
            IMPORTAND INFORMATION ABOUT YOUR ACCOUNT</h5><br/>
        <p>
            <b>Closing Your Account.</b> You may close your account at any time by sending a
            letter to the address shown on your billing statement or calling customer service.
            We may close your account at any time, for any reason. If your account is closed,
            you must stop using it. You must still pay the full amount you owe and this Agreement
            will remain in effect until you do.
        </p><br/>
        <p>
            <b>Collection Costs.</b> If we ask an attorney who is not our salaried employee
            to collect your account, we may charge you our collection costs. These include court
            costs and reasonable attorneys’ fees.
        </p><br/>
        <p>
            <b>Credit Bureau Reporting.</b> We may report information about your account to
            credit bureaus. Late payments, missed payments, or other defaults on your account
            may be shown in your credit report. Tell us if you think we reported wrong information
            about you to a credit bureau. Write to us at CareBlue Patient Finance, 115 River
            Rd, Suite 424, Edgewater, NJ 07020. Tell us what information is wrong and why you
            think it is wrong. If you have a copy of the credit report that includes the wrong
            information, send us a copy.
        </p><br/>
        <p>
            <b>Default.</b> You are in default you make a late payment, do not follow any other
            term of this Agreement or become bankrupt or insolvent. If you default or upon your
            death, we may (a) request that you pay the full amount due right away, (b) take
            legal action to collect the amounts owed, and/or (c) take any other action allowed.
        </p><br/>
        <p>
            <b>Disputed Amounts.</b> The billing rights summary in section IV of this Agreement
            describes what to do If you think there is a mistake on your bill. If you send us
            correspondence about a disputed amount or payment, you must send it to the address
            for billing inquiries. We do not give up any rights under this Agreement if we accept
            a payment marked "payment in full" or given with any other conditions or limitations.
        </p><br/>
        <p>
            <b>Unauthorized Use.</b> If your card is lost, stolen or used without your consent,
            call us immediately at 866-220•2500. You will not be liable for unauthorized use
            on your account, but you will be responsible for all use by anyone you give your
            card to or allow to use your account.
        </p><br/>
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
</script>
