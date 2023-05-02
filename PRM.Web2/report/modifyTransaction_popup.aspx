<%@ Page Language="C#" AutoEventWireup="true" CodeFile="modifyTransaction_popup.aspx.cs"
    Inherits="modifyTransaction_popup" %>

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
        <telerik:radscriptmanager id="RadScriptManager1" runat="server">
        </telerik:radscriptmanager>
        <asp:UpdatePanel ID="updPanelEligility" runat="server">
            <ContentTemplate>
                <div>
                    <table class="CareBluePopup">
                        <tr>
                            <td>
                                <h2p>Modify Transaction</h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>This utility allows you to cancel, refund or resubmit transactions. </h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad2">

                                <!--
                                        <br />DOB <asp:Label ID="lblTitleDOB" runat="server"></asp:Label>
                                        <br />Provider <asp:Label ID="lblTitleProvider" runat="server"></asp:Label>
                                        -->

                                <table class="align-popup-fields" border="0">
                                    <tr>
                                        <td width="20">&nbsp;
                                        </td>
                                        <td width="280">
                                            <div class="form-row">
                                                <pfs4>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; STATEMENT DETAIL</pfs4>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label2" runat="server" Text="Patient:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblbTitlePatient" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label24" runat="server" Text="Statement ID:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblStatementID" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label44" runat="server" Text="Balance:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblBalance" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label4" runat="server" Text="Statement Status:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    </asp:Label><asp:Label ID="lblStatementType" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <br />
                                            &nbsp;                                                
                                                <div class="form-row">
                                                    <pfs4>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; TRANSACTION DETAILS</pfs4>
                                                </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label18" runat="server" Text="Transaction ID:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblTransactionID" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label32" runat="server" Text="Transaction Date:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblTransactionDate" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label34" runat="server" Text="Transaction Type:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblTransactionType" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label38" runat="server" Text="Payment Card:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblPaymentCardType" runat="server"></asp:Label>
                                                    ending in
                                                    <asp:Label ID="lblCardLast4" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label48" runat="server" Text="Message:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblMessage" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </td>
                                        <td width="425">
                                            <div class="form-row">
                                                <pfs4>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ORIGINAL CHARGE</pfs4>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label42" runat="server" Text="Amount:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblAmount" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label36" runat="server" Text="Transaction Status:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblTransactionStatus" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <br />
                                            &nbsp;
                                                <div class="form-row">
                                                    <pfs4>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; MODIFY TRANSACTION</pfs4>
                                                </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label3" runat="server" Text="Type:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblTroubleShooting" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label1" runat="server" Text="Reason:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radcombobox id="cmbReasonType" runat="server" width="200px" emptymessage="Choose Reason Type..."
                                                        allowcustomtext="False" markfirstmatch="True" datatextfield="Abbr" datavaluefield="ReasonTypeID"
                                                        maxheight="200">
                                                        </telerik:radcombobox>
                                                    <asp:RequiredFieldValidator ID="rqdReasonType" runat="server" ControlToValidate="cmbReasonType"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Reason Type is required."
                                                        ErrorMessage="Reason Type is required." ValidationGroup="Transactions">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="lblUpdatedAmount" runat="server" Text="Refund Amount:"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radnumerictextbox runat="server" id="txtAmount" width="90" type="Currency" MinValue="1"
                                                        autopostback="True" numberformat-decimaldigits="2"
                                                        numberformat-groupseparator=",">
                                                        </telerik:radnumerictextbox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtAmount" AllowOutOfRangeAutoCorrect="False"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Amount is required."
                                                        ErrorMessage="Amount is required." ValidationGroup="Transactions">*</asp:RequiredFieldValidator>
                                                    
                                                    
                                                    <span id="spanAmountContainer" runat="server">&nbsp; &nbsp; &nbsp; <b>Refund Allowable to</b> <span id="spanFormatedAmount" runat="server" style="text-decoration: underline;"></span>
                                                    </span>

                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label10" runat="server">Internal Note:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox ID="txtUpdateNotes" TextMode="MultiLine" Width="250px" Height="62px"
                                                        CssClass="textarea" runat="server" Font-Names="arial" Font-Size="10"></asp:TextBox>
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUpdateNotes" Display="Dynamic"
                                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="Internal note for reason is required."
                                                        ErrorMessage="Internal note for reason is required." ValidationGroup="Transactions">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div id="pTransactionMessage" runat="server" visible="False" style="margin:0px 0 -15px 45px; font-size: 13px; color: red;">
                                                This transaction will be deleted; this action cannot be undone.
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <asp:HiddenField ID="hdnInvoiceID" runat="server" />
                                            <asp:HiddenField ID="hdnAccountID" runat="server" />
                                            <asp:HiddenField ID="hdnPatientID" runat="server" />
                                            <asp:HiddenField ID="hdnStatementID" runat="server" />
                                            <asp:HiddenField ID="hdnPNRef" runat="server" />
                                            <asp:HiddenField ID="hdnPaymentCardID" runat="server" />
                                            <asp:HiddenField ID="hdnModifyTransTypeID" runat="server" />
                                            <asp:HiddenField ID="hdnTransactionTypeID" runat="server" />
                                            <asp:HiddenField ID="hdnMaxRefundAmount" runat="server" />
                                            <asp:HiddenField ID="hdnAmount" runat="server" />
                                            <asp:HiddenField ID="hdnPaymentPlanID" runat="server" />
                                            <asp:HiddenField ID="hdnBlueCreditID" runat="server" />
                                            <asp:HiddenField ID="hdnIsTransactionDelete" runat="server" />
                                            <a href="#" onclick="GetRadWindow().close();">
                                                <img src="../Content/Images/btn_cancel.gif" alt="Cancel" class="btn-pop-cancel" /></a>
                                            <asp:ImageButton ID="btnSubmit" CssClass="btn-pop-submit" ImageUrl="../Content/Images/btn_submit.gif"
                                                OnClientClick="showProgressPopup()" OnClick="btnSubmit_OnClick" AlternateText="Submit"
                                                runat="server" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <div style="margin-left: 650px;">
                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Transactions"
                            ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                            CssClass="failureNotification" HeaderText="Please adjust the following and resubmit:" />
                    </div>
                    <telerik:radwindowmanager id="radWindowDialog" showcontentduringload="True" visiblestatusbar="False"
                        visibletitlebar="True" reloadonshow="True" runat="Server" width="800px" height="450px"
                        modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                        skin="CareBlueInf">
                        <AlertTemplate>
                            <div class="rwDialogPopup radalert">
                                <h5>
                                    <div class="rwDialogText">
                                        {1}
                                    </div>
                                </h5>
                                <div style="margin-top: 20px; <%= Style%>">
                                    <a href="#" onclick="$find('{0}').close(true);">
                                        <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                                </div>
                            </div>
                        </AlertTemplate>
                    </telerik:radwindowmanager>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <script type="text/javascript" language="javascript">

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {
                GetRadWindow().BrowserWindow.unBlockUI();
            });

            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
                else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

                return oWindow;
            }

            function refreshGrid() {
                GetRadWindow().BrowserWindow.refreshGrid();
                GetRadWindow().close();
            }


            function closePopup() {
                GetRadWindow().BrowserWindow.refreshPage();
                GetRadWindow().close();
            }

            function showProgressPopup() {

                var isPageValid = false;

                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('Transactions');
                }

                if (isPageValid) {
                    blockUI();
                    return isPageValid;
                }
                else {
                    return isPageValid;
                }

            }


        </script>
        <script type="text/javascript">
            window.alert = function (string) {
                <% Style = "Margin-left: 51px;";%>
                var reg = new RegExp("\\-", "g");
                var messages = string.replace(reg, "<br />").replace("Please correct the following inputs before re-submitting your request:", "Please correct the following inputs before re-submitting your request: - <br />");
                var radWindow = $find("<%=radWindowDialog.ClientID %>");
                radWindow.radalert(messages, 400, 100, '', "", "../Content/Images/warning.png");
            }

        </script>
    </form>
</body>
</html>
