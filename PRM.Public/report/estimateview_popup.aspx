<%@ Page Language="C#" AutoEventWireup="true" CodeFile="estimateview_popup.aspx.cs"
    Inherits="estimateview_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title />
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/Print.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/CareBlue.InvWindow.css" rel="stylesheet" type="text/css" />
</head>
<style>
    @font-face
    {
        font-family: uspsBarCode;
        font-style: normal;
        src: local('USPSIMBCompact'), url(../Styles/Fonts/USPSIMBCompact.ttf), local('USPSIMBStandard'), url(../Styles/Fonts/USPSIMBStandard.ttf);
    }
</style>
<body>
    <form id="form1" runat="server">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <telerik:RadScriptManager runat="server" ID="RadScriptManager1" />
            <div>
            <table class="StatementPopup">
                <tr style="height: 2.2in;">
                    <td width="380">
                        <table>
                            <tr style="height: 0.9in;">
                                <td>
                                    <img src="../content/images/providers/<%=PracticeLogo%>" alt="image" width="<%=PracticeLogoWidth%>" height="60" id="<%=PracticeLogoHeight%>" />
                                    <div style="padding: 0px 0px 0px 10px; font-size: 1.2em;">
                                        <%=PracticeAddr1%>&nbsp;&nbsp;<%=PracticeAddr2%>
                                        <br />
                                        <%=PracticeAddr3%>&nbsp;&nbsp;<%=PracticeAddr4%>
                                    </div>
                                </td>
                            </tr>
                            <tr style="height: 0.0in;">
                                <td style="padding: 10px 10px 0px 0px; font-size: 0.85em;">
                                    <div style="font-weight: bold; color: #8B0000;">
                                        <%=PracticeNote1%>
                                    </div>
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
                        <table width="100%" style="text-align: left; vertical-align: top; font-size: 1.2em; margin: 16px 0px 0px 30px;">
                            <tr style="line-height: 0.9em;">
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
                            <tr style="line-height: 0.9em;">
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
                            <tr style="line-height: 0.9em;">
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
                        <div style="text-align: center; padding: 10px 0px 0px 0px; font-size: 0.90em;">
                            Coverage was confirmed by your insurance at the time of billing:
                        </div>
                    </td>
                </tr>
                <tr style="height: 1.1in;">
                    <td style="padding-left: 50px;">
                        <div style="font-family: uspsBarCode; font-size: 1.4em;">
                            <%=BillingBarcodeID%></div>
                        <div style="font-size: 1.1em;">
                            <%=PatientName%>
                            <br />
                            <%=BillingAddr1%>&nbsp;<%=BillingAddr2%>
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
                                    <%=PatientName%>
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
                                <td class="t2">
                                    <b><%=PatientName%>
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        <%=DoctorName%></b>
                                </td>
                                <td class="t3">
                                    &nbsp;
                                </td>
                                <td class="t4">
                                    &nbsp;
                                </td>
                                <td class="t5">
                                    &nbsp;
                                </td>
                                <td class="t6">
                                    &nbsp;
                                </td>
                            </tr>
                            <%ShowStatementDetails();%>
                            <tr>
                                <td></td><td class="t0">
                                    <b><%=ServiceNote%></b><br />&nbsp;
                                </td><td></td><td></td><td></td><td></td>
                            </tr>
                            <tr class="tr-ftr" style="height: 0.2in; font-size: 1.2em; font-weight: bold;">
                                <td class="td-hdr" colspan="2" style="border: 0px; text-align: left; font-weight: normal;">
                                    <div style="margin: 2px 0px -2px 10px;">
                                        <telerik:RadBarcode runat="server" ID="barCode" Type="code11" Font-Size="10px" ShowText="false"
                                            ShortLinesLengthPercentage="50" Width="120px" Height="12px">
                                        </telerik:RadBarcode>
                                        <%=InvoiceID%>
                                    </div>
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
                            <%=FooterNote%>
                        </div>
                    </td>
                </tr>
            </table>
<%--
            <div style="margin-top: 10px; font-size: 12px; color: black;">
                --EXTRA LABLES:<br /><br />
                PatientID Pri= <%=PatientIDPri%>,<br />
                PatientID= <%=PatientID%>,<br />
                Patient RelTypeID= <%=PatientRelTypeID%>,<br />
                Barcode= <%=StatementBarcodeImg%>,<br />
                QRcode= <%=StatementQRImg%>,<br />
                Background= <%=BackgroundImg%>,<br />
                ServiceClr= <%=ServiceColor%>,<br />
                ServiceImg= <%=ServiceImg%>,<br />
                TableClr= <%=CCTableColor%>,<br />
                SvcLinesTot= <%=SrvLinesTotal%><br />
                SvcTableClr= <%=ServiceTableColor%>,<br />
                SvcHeaderClr= <%=ServiceHeaderColor%>,<br />
                SvcHeaderTxt= <%=ServiceHeaderTextColor%>,<br />
                SvcBodyTxt= <%=ServiceBodyTextColor%>,<br />
                PaymentImg= <%=PaymentCreditImg%>,<br />
                EOB Note= <%=EOBNote%>,<br />
                EOB Date= <%=EOBDate%>,<br />
                EOB DedRem= <%=EOBDeductRemain%>,<br />
                EOB LimitMax= <%=EOBLimitMax%>,<br />
                EOB StopLossRem= <%=EOBStopLossRemain%>,<br />
                EOB CoPay= <%=EOBCoPay%><br />
                EOB CoIns= <%=EOBCoIns%><br />
                Patient DeductDue= <%=PTDeductResp%><br />
                Patient CoIns= <%=PTCoIns%><br />
                Patient DeductTot= <%=PTDedTot %><br />
                Patient CoInsTot= <%=PTCoInsTot%><br />
                PP Active= <%=PaymentPlanActive%>,<br />
                PP Next Amt= <%=PaymentPlanNextAmt%>,<br />
                PP Next Date= <%=PaymentPlanNextDate%>,<br />
                PP Next Src= <%=PaymentPlanNextSource%>,<br />
                PP Note= <%=PaymentPlanNote%>,<br />
            <br />
            <img onclick="closePopup()" src="../content/Images/btn_close.gif" class="btn-close" alt="Close" /> 
--%>

                                <asp:HiddenField ID="hdnShowMessagePopup" runat="server" />
                            </div>
            </div>
            <telerik:RadWindowManager ID="RadWindow" runat="server" EnableShadow="true">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popupMessage" VisibleTitlebar="False" VisibleStatusbar="False"
                        Modal="true" Height="160px">
                        <ContentTemplate>
                            <div id="divMessage" align="center">
                                <br />
                                <p>
                                    <asp:Label ID="lblPopupMessage" Text="Error Message need to be pass here" runat="server"></asp:Label>
                                    <br />
                                    <br />
                                    <img src="../content/Images/btn_ok_small.gif" alt="Ok" onclick="closeRadWindow()" class="btn-ok" />
                                </p>
                            </div>
                        </ContentTemplate>
                    </telerik:RadWindow>
                </Windows>
            </telerik:RadWindowManager>
        </ContentTemplate>
    </asp:UpdatePanel>
    </form>
    <script type="text/javascript">

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            $(function () {

                if ($("#<%=hdnShowMessagePopup.ClientID %>").val() == "1") {
                    $find("<%=popupMessage.ClientID %>").show();
                }

            });
        });

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }

        function closePopup() {
            GetRadWindow().close();
        }

        function closeRadWindow() {
            GetRadWindow().BrowserWindow.closeEstimateViewPopup();
        }
    </script>
</body>
</html>
