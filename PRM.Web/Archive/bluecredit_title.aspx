<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_title.aspx.cs"
    Inherits="Terms_bluecredit_title" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
    <link href="../Styles/BlueCredit.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="title-div">
        <div id="divButtons" runat="server">
            <b style="padding-bottom: 5px;">Page 1 of 10</b> 
            <div style="float: right">
                <a href="javascript:;" onclick="showHidePopup()"><img src="../Content/Images/btn_next.gif" alt="Next" /></a>
            </div>
            <div style="float: right; display: none;">
                <a href="javascript:;"><img src="../Content/Images/btn_save.gif" onclick="saveLendingAgreement()" alt="Save" /></a>
            </div>
            <br />
            <br />
        </div>
        <p align="center">
            <img style="height: 65px;" alt="Provider" src="../Content/Images/Providers/careblue_logo.jpg" id="header_imgLogo" />
        </p>
            <br />
        <h1>
            A BlueCredit Account Means . . .
        </h1>
        <ul style="list-style-type: square">
            <li>
                <h3>An ability to start you care immediately</h3>
            </li>
            <li>
                <h3>Pay over time with low monthly payments</h3>
            </li>
            <li>
                <h3>Coverage for yourself and your family</h3>
            </li>
            <li>
                <h3>Flexible payment plan options available:</h3>
            </li>
                <br />
                <ul style="list-style-type: circle">
                    <li style="font-size: larger"><b>No Interest if Paid in Full within the Promotional Period*</b>
                        <br />Promotional period varies by minimum balance and may be 3, 6, 9, 12, 18 or 24 Months. Interest will be charged to your account 
                        on your existing balance starting in the first period following the end of your promotion if the purchase is not paid in full.</li>
                    <br />
                    <b>OR </b>
                    <br />
                    <li style="font-size: larger"><b>Low Introductory APR and Minimum Monthly Payments Required Until Paid in Full*</b>
                        <br />Introductory rate period varies by minimum balance and may be 3, 6, 9, 12, 15 or 18 Months. Minimum monthly payment amount is 
                        calculated from a credit term length determined by initial account balance. Standard APR rates apply after the promotional period 
                        ends. </li>
                    <br />
                    <b>OR </b>
                    <br />
                    <li style="font-size: larger"><b>14.9% Fixed APR and Fixed Monthly Payments Required Until Paid in Full*</b>
                        <br />Fixed monthly payment amount based on repayment over a 3, 6, 9, 12, 18, 24, 36, 48 or 60 month period. Minimum balance
                        qualification is applicable to plan type.
                        </li>
                </ul>
                <br /><b>
                *Subject to qualifying purchases made with your BlueCredit credit account. Not all promotional options are available at all providers or 
                to all consumers. Plan availability may vary by balance and credit worthiness. Default rate applies after maximum term is reached or 
                multiple missed payments. Minimum monthly payments required to avoid default. Minimum and fixed monthly payments may be recalculated if 
                account balance increases. Full balance may be paid at any time. See Page 10 for details.</b>
        </ul>

        <div style="border: 1px solid black; border-radius: 5px; background-color: darkblue; height: 25px; padding: 10px 0 5px 10px; color: #FFFFFF; font-size:14pt;">
            <i>Step 1 &nbsp;</i> Please follow these guidelines when completing your application:</div>
        <br />
        <div style="border: 1px solid black; border-radius: 20px;">
            <ul style="list-style-type: square;">
                <li>Please have available two forms of ID that can be verified: one primary ID and one
                    secondary ID or two primary IDs. If using a joint applicant, the joint applicant
                    must be present and also provide two forms of ID. Acceptable primary ID are State
                    issued driver's license (preferred), government issued ID, Non Driver State issued
                    ID, Passport, Military ID or Government issued Green/Resident Alien card. Acceptable
                    secondary ID are Visa, MasterCard, American Express, Discover, department store
                    or an oil company credit card with an expiration date.</li>
                <li style="margin-top: 10px;">Please include all forms of income from all full and part-time
                    jobs, bonuses, commissions, and investments. You need only include child support,
                    alimony, or separate maintenance income if you wish this income to be considered
                    in your application. </li>
                <li style="margin-top: 10px;">Please note that you must reside in the United States
                    and be 18 years or older to apply.</li>
            </ul>
        </div>
        <br />
        <div style="border: 1px solid black; border-radius: 5px; background-color: darkblue; height: 25px; padding: 10px 0 5px 10px; color: #FFFFFF; font-size:14pt;">
            <i>Step 2 &nbsp;</i> Please complete the rest of the application on the reverse side.</div>
    </div>
    <p>
        182-077-00 <br/>
        Revision Date: 6/19/2012 <br/>
        DATE OF PRINTING: 5/12
    </p>
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
        GetRadWindow().BrowserWindow.showHideRequestedPopups("bluecredit_application", "bluecredit_title");
    }

    function saveLendingAgreement() {
        GetRadWindow().BrowserWindow.saveLendingAgreement();
    }

</script>
