<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_privacy1.aspx.cs"
    Inherits="Terms_bluecredit_payments" %>

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
            width: 260px;
        }
        .col2
        {
            width: 524px;
        }
        p {
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width: 768px;">
        <div id="divButtons" runat="server">
            <b style="padding-bottom: 5px;">Page 9 of 10</b> 
            <div style="float: right">
                <a href="javascript:;" onclick="showHidePopup('bluecredit_privacy','bluecredit_privacy1')">
                    <img src="../Content/Images/btn_goback.gif" alt="Go Back" /></a>
                &nbsp; &nbsp;
                <a href="javascript:;" onclick="showHidePopup('bluecredit_approval','bluecredit_privacy1')">
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
        <table>
            <tr>
                <th colspan="2" style="background-color: darkblue">
                    What we do
                </th>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        How does CareBlue Patient Finance protect my personal information?</h4>
                </td>
                <td class="col2">
                    <p>
                        To protect your personal information from unauthorized access and use, we use security
                        measures that comply with federal law. These measures include computer safeguards
                        and secured files and buildings.</p>
                </td>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        How does CareBlue Patient Finance collect my personal information?</h4>
                </td>
                <td class="col2">
                    <p>
                        We collect your personal information, for example, when you</p>
                    <ul>
                        <li>open an account or give us your contact information </li>
                        <li>provide account information or pay your bills </li>
                        <li>use your credit account </li>
                    </ul>
                    <p>
                        We also collect your personal information from others, such as credit bureaus, affiliates,
                        or other companies.</p>
                </td>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        Why can't I limit all sharing?</h4>
                </td>
                <td class="col2">
                    <p>
                        Federal law gives you the right to limit only</p>
                    <ul>
                        <li>sharing for affiliates' everyday business purposes-information about your creditworthiness</li>
                        <li>affiliates from using your information to market to you </li>
                        <li>sharing for nonaffiliates to market to you</li>
                    </ul>
                    <p>
                        State laws and individual companies may give you additional rights to limit sharing.
                        See below for more on your rights under state law.</p>
                </td>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        What happens when I limit sharing for an account I hold jointly with someone else?</h4>
                </td>
                <td class="col2">
                    <p>
                        Your choices will apply to everyone on your account.</p>
                </td>
            </tr>
        </table>
        <br />
        <table>
            <tr>
                <th colspan="2" style="background-color: darkblue">
                    Definitions
                </th>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        Affiliates</h4>
                </td>
                <td class="col2">
                    <p>
                        Companies related by common ownership or control. They can be financial and nonfinancial
                        companies. Our affiliates include companies with a CareBlue or the BlueCredit name;
                        financial companies such as CareBlue Patient Finance and CareBlue Credit Services;
                        and nonfinancial companies, such as IT Mobility, Inc</p>
                </td>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        Nonaffiliates</h4>
                </td>
                <td class="col2">
                    <p>
                        Companies not related by common ownership or control. They can be financial and
                        nonfinancial companies.</p>
                    <ul>
                        <li>Nonaffiliates we share with can include direct marketing companies and the providers
                            who accept the BlueCredit credit account. </li>
                    </ul>
                </td>
            </tr>
            <tr>
                <td class="col1">
                    <h4>
                        Joint Marketing</h4>
                </td>
                <td class="col2">
                    <p>
                        A formal agreement between nonaffiliated financial companies that together market
                        financial products or services to you. Our joint marketing partners include insurance
                        companies, credit data companies and other financial services organizations.</p>
                </td>
            </tr>
        </table>
        <br />
        <table>
            <tr>
                <th style="background-color: darkblue">
                    Other important information
                </th>
            </tr>
            <tr>
                <td>
                    <p>
                        We follow state law if state law provides you with additional privacy protections.
                        For instance, if (and while) your billing address is in Vermont, we will treat your
                        account as if you had exercised the opt-out choice described above and you do not
                        need to contact us to opt out. If you move from Vermont and you wish to restrict
                        us from sharing information about you as provided in this notice, you must then
                        contact us to exercise your opt-out choice.</p>
                </td>
            </tr>
        </table>
        <div>
            <br/>
            <p>
                *Please keep in mind that, as permitted by federal law, we share information about
                you with BlueCredit, providers that accept the BlueCredit credit account and program
                sponsors in connection with maintaining and servicing the CareBlue Patient Finance
                credit card program, including for BlueCredit providers that accept the card and
                program sponsors to market to you. If you opt out of sharing with nonaffifiates,
                your opt out will not prohibit us from sharing your information with BlueCredit
                providers that accept the card and program sponsors.
            </p>
            <p>
                &nbsp;</p>
            <p>
                The above notice applies only to the BlueCredit credit account covered by the attached
                CareBlue Patient Finance Credit Card Account Agreement and does not apply to any
                other accounts you have with us. It replaces our previous privacy notice disclosures
                to you. We can change our privacy policy at any time and will let you know if we
                do if/as required by applicable law.
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
