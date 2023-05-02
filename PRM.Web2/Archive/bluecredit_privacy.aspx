<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_privacy.aspx.cs"
    Inherits="Terms_bluecredit_privacy" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
            padding: 0;
        }
        
        table
        {
            border-spacing: 0;
        }
        
        table td
        {
            border: 1px solid black;
        }
        
        
        .header
        {
            height: 47px;
        }
        .col1
        {
            width: 200px;
            background-color: darkblue;
        }
        
        
        .col2
        {
            width: 700px;
        }
        
        .grid-col1
        {
            width: 195px;
        }
        .grid-col2
        {
            width: 536px;
        }
        .grid-col3
        {
            width: 170px;
        }
        h2 {
            font-size: 14px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width: 768px;">
        <div id="divButtons" runat="server">
            <b style="padding-bottom: 5px;">Page 8 of 10</b> 
            <div style="float: right">
                <a href="javascript:;" onclick="showHidePopup('bluecredit_Section4','bluecredit_privacy')">
                    <img src="../Content/Images/btn_goback.gif" alt="Go Back" /></a>
                &nbsp; &nbsp;
                <a href="javascript:;" onclick="showHidePopup('bluecredit_privacy1','bluecredit_privacy')">
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
        <table style="height: 79px">
            <tr>
                <th colspan="2" class="header">
                    <h3 align="center">
                        Privacy Policy</h3>
                </th>
            </tr>
            <tr>
                <td class="col1">
                    <h2 align="center">
                        Facts</h2>
                </td>
                <td class="col2" rowspan="2">
                    <h4 align="center">
                        WHAT DOES CAREBLUE PATIENT FINANCE DO WITH YOUR PERSONAL INFORMATION?</h4>
                </td>
            </tr>
        </table>
        <br />
        <table style="height: 79px">
            <tr>
                <td class="col1">
                    <h2 align="center">
                        Why</h2>
                </td>
                <td class="col2" rowspan="2">
                    Financial companies choose how they share your personal information. Federal law
                    gives consumers the right to limit some but not all sharing. Federal law also requires
                    us to tell you how we collect, share, and protect your personal information. Please
                    read this notice carefully to understand what we do.
                </td>
            </tr>
        </table>
        <br />
        <table style="height: 79px">
            <tr>
                <td class="col1">
                    <h2 align="center">
                        What</h2>
                </td>
                <td class="col2" rowspan="2">
                    The types of personal information we collect and share depend on the product or
                    service you have with us. This information can include:
                    <ul>
                        <li>Social Security number and income. </li>
                        <li>Account balances and payment history. </li>
                        <li>Credit history and credit scores. </li>
                    </ul>
                </td>
            </tr>
        </table>
        <br />
        <table style="height: 79px">
            <tr>
                <td class="col1">
                    <h2 align="center">
                        How</h2>
                </td>
                <td class="col2" rowspan="2">
                    All financial companies need to share customers' personal information to run their
                    everyday business. In the section below, we list the reasons financial companies
                    can share their customers' personal information; the reasons CareBlue Patient Finance
                    chooses to share; and whether you can limit this sharing.
                </td>
            </tr>
        </table>
        <br />
        <table style="height: 79px; border-collapse: collapse;">
            <tr style="background-color: darkblue;">
                <th class="grid-col2" style="border: 1px solid black; text-align: left;">
                    Reason we can share your personal Information
                </th>
                <th class="grid-col1" style="border: 1px solid black;">
                    Does GE Capital.....?
                </th>
                <th class="grid-col3" style="border: 1px solid black;">
                    Can you limit this sharing?
                </th>
            </tr>
            <tr>
                <td class="grid-col2">
                    Does CBPF share?
                </td>
                <td class="grid-col1">
                    <p align="center">
                        Yes</p>
                </td>
                <td class="grid-col3">
                    <p align="center">
                        No</p>
                </td>
            </tr>
            <tr>
                <td class="grid-col2">
                    Can you limit this sharing?
                </td>
                <td class="grid-col1">
                    <p align="center">
                        Yes</p>
                </td>
                <td class="grid-col3">
                    <p align="center">
                        No</p>
                </td>
            </tr>
            <tr>
                <td class="grid-col2">
                    For our everyday business purposes- such as to process your transactions, maintain
                    your account(s), respond to court orders and legal investigations, or report to
                    credit bureaus
                </td>
                <td class="grid-col1">
                    <p align="center">
                        Yes</p>
                </td>
                <td class="grid-col3">
                    <p align="center">
                        No</p>
                </td>
            </tr>
            <tr>
                <td class="grid-col2">
                    For our marketing purposes- to offer our products and services to you
                </td>
                <td class="grid-col1">
                    <p align="center">
                        Yes</p>
                </td>
                <td class="grid-col3">
                    <p align="center">
                        No</p>
                </td>
            </tr>
            <tr>
                <td class="grid-col2">
                    For joint marketing with other financial companies.
                </td>
                <td class="grid-col1">
                    <p align="center">
                        Yes</p>
                </td>
                <td class="grid-col3">
                    <p align="center">
                        No</p>
                </td>
            </tr>
            <tr>
                <td class="grid-col2">
                    For our affiliates' everyday business purposes- information about your transactions
                    and experiences
                </td>
                <td class="grid-col1">
                    <p align="center">
                        Yes</p>
                </td>
                <td class="grid-col3">
                    <p align="center">
                        No</p>
                </td>
            </tr>
            <tr>
                <td class="grid-col2">
                    For our affiliates to market to you
                </td>
                <td class="grid-col1">
                    <p align="center">
                        Yes</p>
                </td>
                <td class="grid-col3">
                    <p align="center">
                        No</p>
                </td>
            </tr>
            <tr>
                <td class="grid-col2">
                    For non affiliates to market to you
                </td>
                <td class="grid-col1">
                    <p align="center">
                        Yes</p>
                </td>
                <td class="grid-col3">
                    <p align="center">
                        No</p>
                </td>
            </tr>
        </table>
        <br />
        <table style="height: 79px">
            <tr>
                <td class="col1">
                    <h2 align="center">
                        To limit our sharing</h2>
                </td>
                <td class="col2" rowspan="2">
                    <p>
                        Call 866-220-2500- our menu will prompt you through your choice(s)
                        <br />
                        <br />
                        <b>Please note:</b> If you are a new customer, we can begin sharing your information
                        30 days from the date we sent this notice. When you are no longer our customer,
                        we continue to share your information as described in this notice. However, you
                        can contact us at any time to limit our sharing.
                    </p>
                </td>
            </tr>
        </table>
        <br />
        <table style="height: 79px">
            <tr>
                <td class="col1">
                    <h2 align="center">
                        Questions?</h2>
                </td>
                <td class="col2" rowspan="2">
                    <p>
                        Call 866-220-2500</p>
                </td>
            </tr>
        </table>
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
