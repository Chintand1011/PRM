<%@ Page Language="C#" AutoEventWireup="true" CodeFile="invoice_popup.aspx.cs" Inherits="invoice_popup" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title />
    <script src="~/Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
<style> 
@font-face
{
  font-family: uspsBarCode;
  font-style: normal;
  src: local('USPSIMBCompact'), url(../Styles/Fonts/USPSIMBCompact.ttf), local('USPSIMBStandard'), url(../Styles/Fonts/USPSIMBStandard.ttf);
}
</style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table class="CareBluePopup">
            <tr>
                <td>
                    <h1p>
                        Title
                    </h1p>
                </td>
            </tr>
            <tr>
                <td>
                    <h3p>
                        Description
                    </h3p>
                </td>
            </tr>
            <tr>
                <td class="ExtraPad">
                    <table style="width: 7.94in; height: 10.5in; border-collapse: collapse; border: 0px solid red;">
                        <tr style="height: 2.2in;">
                            <td width="380">
                                <table>
                                    <tr style="height: 0.9in;">
                                        <td>
                                            <img src="images/<%=PracticeLogo%>" alt="image" width="<%=PracticeLogoWidth%>" height="<%=PracticeLogoHeight%>" />
                                            <div style="padding: 0px 0px 0px 10px; font-size: 1.2em;">
                                                <%=PracticeAddr1%>&nbsp;&nbsp;<%=PracticeAddr2%>
                                                <br />
                                                <%=PracticeAddr3%>&nbsp;&nbsp;<%=PracticeAddr4%>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr style="height: 0.0in;">
                                        <td style="padding: 20px 10px 0px 0px; font-size: 0.85em;">
                                            <div style="font-weight: bold; color: #8B0000;">
                                                <%=PracticeNote1%></div>
                                            <br />
                                            <%=PracticeNote2%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td align="right">
                                <table id="tbl-cc">
                                    <tr style="height: 0.15in">
                                        <td colspan="4" width="325" style="text-align: center; vertical-align: middle; font-size: 0.7em;
                                            background-color: #fbeded;">
                                            IF PAYING BY CREDIT CARD, PLEASE FILL OUT THE FORM BELOW
                                        </td>
                                    </tr>
                                    <tr style="height: 0.3in;">
                                        <td colspan="3" width="">
                                            CARD NUMBER
                                        </td>
                                        <td>
                                            SECURITY ID
                                        </td>
                                    </tr>
                                    <tr style="height: 0.3in;">
                                        <td colspan="3">
                                            SIGNATURE
                                        </td>
                                        <td>
                                            EXP DATE
                                        </td>
                                    </tr>
                                    <tr style="height: 0.3in;">
                                        <td width="65">
                                            ACCOUNT NUM<div style="padding: 2px 0px 2px 0px; text-align: center; font-size: 1.8em;">
                                                <%=AccountID%></div>
                                        </td>
                                        <td width="85">
                                            STATEMENT DATE<div style="padding: 2px 0px 2px 0px; text-align: center; font-size: 1.8em;">
                                                <%=StatementDate%></div>
                                        </td>
                                        <td width="85">
                                            TOTAL DUE<div style="padding: 2px 0px 2px 0px; text-align: center; font-size: 1.8em;">
                                                <%=TotalDue%></div>
                                        </td>
                                        <td>
                                            TOTAL PAID
                                        </td>
                                    </tr>
                                </table>
                                <table width="100%" style="text-align: left; vertical-align: top; font-size: 1.2em;
                                    margin: 16px 0px 0px 30px;">
                                    <tr style="line-height: 1.1em;">
                                        <td style="text-align: right;">
                                            MAKE CHECKS PAYABLE:
                                        </td>
                                        <td>
                                            &nbsp;&nbsp;
                                        </td>
                                        <td width="180">
                                            <%=PaymentCheckName%>
                                        </td>
                                    </tr>
                                    <tr style="line-height: 1.1em;">
                                        <td style="text-align: right;">
                                            SECURE ONLINE PAYMENTS:
                                        </td>
                                        <td>
                                            &nbsp;&nbsp;
                                        </td>
                                        <td>
                                            <%=PaymentWebURL%>
                                        </td>
                                    </tr>
                                    <tr style="line-height: 1.1em;">
                                        <td style="text-align: right;">
                                            PAY-BY-PHONE SERVICE:
                                        </td>
                                        <td>
                                            &nbsp;&nbsp;
                                        </td>
                                        <td>
                                            <%=PaymentPhone%>
                                        </td>
                                    </tr>
                                </table>
                                <div style="text-align: center; padding: 12px 0px 0px 0px; font-size: 0.90em;">
                                    Coverage was confirmed by your insurance at the time of billing:
                                </div>
                            </td>
                        </tr>
                        <tr style="height: 1.1in;">
                            <td style="padding-left: 50px;">
                                <div style="font-family:uspsBarCode; font-size:1.6em;">
                                    <%=BillingBarcodeID%></div>
                                <div style="font-size: 1.1em;">
                                    <%=PatientNamePri%>
                                    <br />
                                    <%=BillingAddr1%><%=BillingAddr2%>
                                    <br />
                                    <%=BillingAddr3%>&nbsp;<%=BillingAddr4%></div>
                            </td>
                            <td>
                                <table id="tbl-eob" style="margin-top: -8px; font-size: 1.1em;">
                                    <tr style="text-align: center; font-weight: bold; background-color: #fbeded;">
                                        <td colspan="4" style="border: 1px solid darkred;">
                                            Subscriber
                                            <%=EOBSubscriberID%>, &nbsp;<%=EOBCarrier%>
                                            -
                                            <%=EOBPlanName%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="60">
                                            Service:
                                        </td>
                                        <td width="95">
                                            <%=EOBServiceType%>
                                        </td>
                                        <td width="85" style="border-left: 1px solid darkred;">
                                            Co-Pay/Co-Ins:
                                        </td>
                                        <td>
                                            <%=EOBCoPay%>
                                            Visit /
                                            <%=EOBCoIns%>
                                            Fees
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Status:
                                        </td>
                                        <td>
                                            <%=EOBStatus%>
                                            /
                                            <%=EOBPatientRelation%>
                                        </td>
                                        <td style="border-left: 1px solid darkred;">
                                            Deductible:
                                        </td>
                                        <td>
                                            <%=EOBDeductMet%>
                                            /
                                            <%=EOBDeduct%>
                                            CYD
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Provider:
                                        </td>
                                        <td>
                                            <%=EOBPreferred%>
                                        </td>
                                        <td style="border-left: 1px solid darkred;">
                                            Out-of-Pocket:
                                        </td>
                                        <td>
                                            <%=EOBStopLossYTD%>
                                            /
                                            <%=EOBStopLoss%>
                                            CYD
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Reimburse:
                                        </td>
                                        <td>
                                            <%=EOBPatientIssuedReimb%>
                                        </td>
                                        <td style="border-left: 1px solid darkred;">
                                            Visit Limits:
                                        </td>
                                        <td>
                                            <%=EOBVisitsCurrent%>
                                            /
                                            <%=EOBVisitsMax%>
                                            Remaining
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr style="height: 0.3in; text-align: center;">
                            <td colspan="2">
                                - - - - - - - - - - - - - - - - PLEASE DETACH HERE AND RETURN THIS TOP PORTION WITH
                                YOUR PAYMENT - - - - - - - - - - - - - - - -
                            </td>
                        </tr>
                        <tr style="height: 0.5in;">
                            <td colspan="2">
                                <table id="tbl-hdr">
                                    <tr style="text-align: center; font-weight: bold; background-color: #d4e0f2;">
                                        <td width="75">
                                            ACCOUNT
                                        </td>
                                        <td>
                                            PRIMARY INSURED
                                        </td>
                                        <td width="100">
                                            INVOICE DATE
                                        </td>
                                        <td width="100">
                                            DUE DATE
                                        </td>
                                        <td width="141">
                                            STATUS
                                        </td>
                                        <td width="80">
                                            TOTAL DUE
                                        </td>
                                    </tr>
                                    <tr style="font-size: 1.2em;">
                                        <td>
                                            <%=AccountID%>
                                        </td>
                                        <td>
                                            <%=PatientNamePri%>
                                        </td>
                                        <td>
                                            <%=StatementDate%>
                                        </td>
                                        <td>
                                            <%=StatementDueDate%>
                                        </td>
                                        <td>
                                            <%=StatementStatus%>
                                        </td>
                                        <td>
                                            <%=TotalDue%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <table id="tbl-desc">
                                    <tr class="tr-hdr" style="height: 0.1in; text-align: center; font-weight: bold; background-color: #d4e0f2;">
                                        <td class="td-hdr" width="75">
                                            DATE
                                        </td>
                                        <td class="td-hdr">
                                            DESCRIPTION OF SERVICE
                                        </td>
                                        <td class="td-hdr" width="70">
                                            CHARGES
                                        </td>
                                        <td class="td-hdr" width="70">
                                            INS PAY
                                        </td>
                                        <td class="td-hdr" width="70">
                                            PATIENT
                                        </td>
                                        <td class="td-hdr" width="80">
                                            BALANCE
                                        </td>
                                    </tr>
                                    <tr style="height: 22px;">
                                        <td class="t1">
                                            &nbsp;
                                        </td>
                                        <td style="text-align: left; vertical-align: top; padding-left: 5px; padding-top: 3px;
                                            line-height: 1.4em;">
                                            <b>
                                                <%=PatientName%>
                                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                                <%=DoctorName%></b>
                                        </td>
                                        <td class="t3">
                                            &nbsp;
                                        </td>
                                        <td class="t3">
                                            &nbsp;
                                        </td>
                                        <td class="t3">
                                            &nbsp;
                                        </td>
                                        <td class="t3">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <%=Srv01%>
                                    <%=Srv02%>
                                    <%=Srv03%>
                                    <%=Srv04%>
                                    <%=Srv05%>
                                    <%=Srv06%>
                                    <%=Srv07%>
                                    <%=Srv08%>
                                    <%=Srv09%>
                                    <%=Srv10%>
                                    <%=Srv11%>
                                    <%=Srv12%>
                                    <%=Srv13%>
                                    <%=Srv14%>
                                    <%=Srv15%>
                                    <%=Srv16%>
                                    <%=Srv17%>
                                    <%=Srv18%>
                                    <%=Srv19%>
                                    <%=Srv20%>
                                    <%=Srv21%>
                                    <%=Srv22%>
                                    <%=Srv23%>
                                    <%=Srv24%>
                                    <%=Srv25%>
                                    <%=Srv26%>
                                    <%=Srv27%>
                                    <%=Srv28%>
                                    <%=Srv29%>
                                    <%=Srv30%>
                                    <%=Srv31%>
                                    <%=Srv32%>
                                    <tr>
                                        <td>
                                        </td>
                                        <td class="t0">
                                            <b>
                                                <%=ServiceNote1%><br />
                                                <%=ServiceNote2%></b>
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr class="tr-ftr" style="height: 0.2in; font-size: 1.2em; font-weight: bold;">
                                        <td class="td-hdr" colspan="2" style="border: 0px; text-align: left; font-weight: normal;">
                                            <div style="margin: 2px 0px -2px 10px;">
                                                <%--<telerik:RadBarcode runat="server" ID="barCode" Type="code11" Font-Size="10px" ShowText="false"
                                    ShortLinesLengthPercentage="50" Width="120px" Height="12px">
                                </telerik:RadBarcode>--%>
                                                <%=StatementID%></div>
                                        </td>
                                        <td class="td-hdr" colspan="3" style="border: 0px; text-align: right;">
                                            YOUR RESPONSIBILITY &nbsp; &nbsp;
                                        </td>
                                        <td class="td-hdr" style="border: 1px solid #000099; text-align: right; padding-right: 7px;">
                                            <%=TotalDue%>
                                        </td>
                                    </tr>
                                </table>
                                <div style="margin: 3px 0px 0px 5px;">
                                    <%=FooterNote1%>
                                    <%=FooterNote2%></div>
                            </td>
                        </tr>
                    </table>
                    <div style="margin-top: 10px; font-size: 12px; color: black;">
                        EXTRA LABLES:
                        <%=PatientIDPri%>,
                        <%=PatientID%>,
                        <%=PatientRelTypeID%>,
                        <%=StatementRefCode%>,
                        <%=StatementBarcodeImg%>,
                        <%=StatementQRImg%>,
                        <%=BackgroundImg%>,
                        <%=ServiceColor%>,
                        <%=ServiceImg%>,
                        <%=CCTableColor%>,
                        <%=ServiceTableColor%>,
                        <%=ServiceHeaderColor%>,
                        <%=ServiceHeaderTextColor%>,
                        <%=ServiceBodyTextColor%>,
                        <%=PracticeNote3%>,
                        <%=PracticeNote4%>,
                        <%=PaymentCreditImg%>,
                        <%=EOBNote1%>,
                        <%=EOBNote2%>,
                        <%=EOBNote3%>,
                        <%=EOBNote4%>,
                        <%=EOBDate%>,
                        <%=EOBDeductRemain%>,
                        <%=EOBLimitMax%>,
                        <%=EOBStopLossRemain%>,
                        <%=ServiceNote3%>,
                        <%=ServiceNote4%>,
                        <%=FooterNote2%>,
                        <%=FooterNote3%>,
                        <%=FooterNote4%>,
                        <%=PaymentPlanActive%>,
                        <%=PaymentPlanNextAmt%>,
                        <%=PaymentPlanNextDate%>,
                        <%=PaymentPlanNextSource%>,
                        <%=PaymentPlanNote1%>,
                        <%=PaymentPlanNote2%>,
                        <%=SrvLinesTotal%>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <a href="#" onclick="closePopup()">
                        <img src="../Content/Images/btn_close.gif" class="btn-close" alt="Close" /></a>
                </td>
            </tr>
        </table>
    </div>
    </form>
    <script type="text/javascript">

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }

        function closePopup() {
            GetRadWindow().close();
        }

    </script>
</body>
</html>
