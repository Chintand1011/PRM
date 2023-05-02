<%@ Page Language="C#" AutoEventWireup="true" CodeFile="paymentConfirmation_popup.aspx.cs"
    Inherits="paymentConfirmation_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        </telerik:RadScriptManager>
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <div>
                    <table class="CareBluePopup">
                        <tr>
                            <td>
                                <h2p>
                                    Confirmation
                                </h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>
                                    Please review payment details before submission
                                </h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad">
                                <div id="divPopupInformation" align="center">
                                    <b style="font-size: medium"></b>
                                    <p>
                                        Payment is ready to be applied in the amount of:
                                    <div style="margin: -5px 0 5px 0;">
                                        <asp:Label ID="lblTotalAmount" runat="server" Style="color: black; font-size: 14pt; font-weight: bold"></asp:Label>
                                    </div>
                                        This will be processed using the following account:<br />
                                        <div style="margin: 5px 0 5px 0;">
                                            <asp:Label ID="lblSelectedPaymentMethod" runat="server" Style="color: black; font-size: 10pt; font-weight: bold"></asp:Label>
                                        </div>
                                    </p>
                                </div>
                                <div align="center">
                                    <asp:CheckBox ID="chkAgreementTerms" runat="server" Checked="False" Text="I agree to the payment terms." />
                                    <a href="#" onclick="openPaymentTerms()">
                                        <img id="Img2" src="../content/Images/icon_help.png" runat="server" alt="help" /></a>
                                </div>
                                <div style="margin-top: -10px; margin-bottom:-10px;" align="center">
                                    &nbsp; <span id="spnConfirm"><br />Please confirm submission or cancel.</span>
                                    <p id="pShowErrorMessage" style="color: red"></p>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:HiddenField ID="hdnAmount" runat="server" />
                                <asp:ImageButton ID="btnYes" runat="server" ImageUrl="../content/Images/btn_submit_small.gif"
                                    CssClass="btn-pop-submit" OnClientClick="return showMakePaymentProcessing()" />
                                &nbsp;<a href="#" onclick="closePopup()"><img src="../content/Images/btn_cancel_small.gif"
                                    class="btn-pop-cancel" alt="Cancel" /></a>
                            </td>
                        </tr>
                    </table>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <script type="text/javascript" language="javascript">

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {

                $(function () {
                    setTimeout('$("#divSuccessMessage").html("");', 4000);
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

            function reloadPage(arg) {
                GetRadWindow().BrowserWindow.refreshPage();
                closePopup();
            }

            function showMakePaymentProcessing() {
                var agreementTerms = $("#<%=chkAgreementTerms.ClientID %>").is(":checked");
                var totalAmount = parseFloat('<%=hdnAmount.Value %>');
                if (agreementTerms) {
                    if (totalAmount > 0) {
                        $("#pShowErrorMessage").html("");
                        $("#spnConfirm").show();
                        GetRadWindow().BrowserWindow.processPayment(true);
                    } else {
                        $("#pShowErrorMessage").html("Amount should be greater than 0");
                        return false;
                    }
                } else {
                    $("#pShowErrorMessage").html("Payment terms must be agreed to before a payment can be made.");
                    $("#spnConfirm").hide();
                    return false;
                }

            }

            function openPaymentTerms() {
                var location = "<%=ClientSession.WebPathRootPatient %>" + "Terms/payments.htm";
                window.open(location, "WindowPopup", "width=700px, height=890px, scrollbars=yes");
            }

        </script>
    </form>
</body>
</html>
