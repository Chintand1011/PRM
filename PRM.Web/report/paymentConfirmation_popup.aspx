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
                                <h2p>Confirmation</h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>Please review payment details before submission.</h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad">
                                <div id="divPopupInformation" align="center">
                                    <br />
                                    Payment is ready to be applied in the amount of:
                                        <div style="margin: 5px 0 5px 0;">
                                            <asp:Label ID="lblTotalAmount" runat="server" Style="color: black; font-size: 14pt; font-weight: bold"></asp:Label>
                                        </div>
                                    This will be processed using the patient's account:<br />
                                    <div style="margin: 5px 0 5px 0;">
                                        <asp:Label ID="lblSelectedPaymentMethod" runat="server" Style="color: black; font-size: 10pt; font-weight: bold"></asp:Label>
                                    </div>
                                </div>
                                <div align="center">
                                    <asp:CheckBox ID="chkAgreementTerms" runat="server" Checked="True" />Patient has provided permission to process charge.
                                    <!--<a href="#" onclick="openPaymentTerms()">
                                        <img id="imgHelp" src="~/Content/Images/icon_help.png" runat="server" alt="help" /></a>-->

                                 <br/>   <span id="spnConfirm">Please confirm submission or cancel.</span>                                  <br/>
                                </div>
                                <div style="margin-top: -10px;" align="center">
                                    <p id="pShowErrorMessage" style="color: red">
                                    </p>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ImageButton ID="btnYes" runat="server" ImageUrl="../Content/Images/btn_submit.gif"
                                    CssClass="btn-pop-submit" OnClientClick="return showMakePaymentProcessing()" />
                                &nbsp;<a href="#" onclick="closePopup()"><img src="../Content/Images/btn_cancel.gif"
                                    class="btn-pop-cancel" alt="Cancel" /></a>
                                <asp:HiddenField ID="hdnIsDisableCheckBox" runat="server" />
                                <asp:HiddenField ID="hdnAmount" runat="server" />
                            </td>
                        </tr>
                    </table>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <script type="text/javascript" language="javascript">

            $(function () {
                if ($("#<%=hdnIsDisableCheckBox.ClientID %>").val() == "1") {
                    $("#<%=chkAgreementTerms.ClientID %>").attr("checked", "checked");
                    $("#<%=chkAgreementTerms.ClientID %>").hide();
                    $("#<%=chkAgreementTerms.ClientID %>").next().hide();
                    $("#imgHelp").hide();
                }
            });

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
            var totalAmount = parseFloat($("#<%=hdnAmount.ClientID %>").val());
            if (agreementTerms) {

                if (totalAmount > 0) {
                    $("#pShowErrorMessage").html("");
                    $("#spnConfirm").show();
                    GetRadWindow().BrowserWindow.processPayment(true);
                } else {
                    $("#pShowErrorMessage").html("Amount should be greater than 0.");
                    return false;
                }

            } else {
                $("#pShowErrorMessage").html("Patient authorization must be obtained before submitting payment.");
                $("#spnConfirm").hide();
                return false;
            }

        }

        function openPaymentTerms() {
            var location = "<%=ClientSession.WebPathRootProvider %>" + "Terms/payments.htm";
            window.open(location, "WindowPopup", "width=700px, height=960px, scrollbars=yes");
        }

        </script>
    </form>
</body>
</html>
