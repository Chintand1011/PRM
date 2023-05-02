<%@ Page Language="C#" AutoEventWireup="true" CodeFile="addTransactions_popup.aspx.cs"
    Inherits="addTransactions_popup" %>

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
        <asp:UpdatePanel ID="updPanelEligility" runat="server">
            <ContentTemplate>
                <div>
                    <table class="CareBluePopup">
                        <tr>
                            <td>
                                <h2p>Manage Statement Transactions</h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>Use this form to manually add charges, credits or discounts to the patient statement</h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad">
                                <div>
                                    <p style="margin-left: 60px; color:#002897;">
                                        <b>Statement ID: <asp:Label ID="lblStatementID" runat="server"></asp:Label></b>
                                        <br />
                                        To instead edit existing transactions for this statement:&nbsp; <img alt="SearchTransaction" onclick="redirectToPatientTransactionPage();" style="margin-bottom:-3px; cursor: pointer;" src="../Content/Images/btn_transactions.gif"/>
                                    </p>
                                    <br />
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label6" runat="server">Transaction Type:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:RadComboBox ID="cmbTransactionType" runat="server" Width="180px" EmptyMessage="Choose Type..."
                                                OnSelectedIndexChanged="cmbTransactionType_SelectedIndexChanged" AllowCustomText="False"
                                                AutoPostBack="True" MarkFirstMatch="True" DataTextField="ServiceName" DataValueField="TransactionTypeID"
                                                MaxHeight="200">
                                            </telerik:RadComboBox>
                                            <!-- This was removed and replaced with a 'close' column option on the current statement grid on the statement page; it can be removed after confirming no issues
                                            <span id="spanArchiveStatement" runat="server">
                                            &nbsp; &nbsp; <b>OR</b> &nbsp; &nbsp; <img alt="ArchiveStatement" onclick="redirectToPatientTransactionPage();" style="margin-bottom:-3px; cursor: pointer;" src="../Content/Images/btn_archivestatement.gif"/>    
                                            </span>
                                            -->

                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label10" runat="server">Amount:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:RadNumericTextBox runat="server" ID="txtAmount" Type="Currency" NumberFormat-DecimalDigits="2"
                                                NumberFormat-GroupSeparator="," Width="100">
                                            </telerik:RadNumericTextBox>
                                            <asp:CustomValidator CssClass="failureNotification" ValidateEmptyText="True" runat="server"
                                                ControlToValidate="txtAmount" ClientValidationFunction="validateAmount" ValidationGroup="Transactions"
                                                Display="Dynamic" ToolTip="Amount must be greater than $0.00."
                                                ErrorMessage="Amount must be greater than $0.00.">*</asp:CustomValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label11" runat="server">Statement Message:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtMessage" MaxLength="50" Width="350" runat="server"></asp:TextBox>
                                            <asp:CustomValidator ID="CustomValidator1" CssClass="failureNotification" ValidateEmptyText="True"
                                                runat="server" ControlToValidate="txtMessage" ClientValidationFunction="validateMessage"
                                                ValidationGroup="Transactions" Display="Dynamic" ToolTip="Statement message description should be longer."
                                                ErrorMessage="Statement message description should be longer.">*</asp:CustomValidator>
                                        </div>
                                    </div>
                                    <p style="margin-left: 200px;">
                                        <i>Please enter a message description which will be displayed on the statement.</i>
                                    </p>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label1" runat="server">Internal Note:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtNotes" TextMode="MultiLine" Width="350px" Height="90px" CssClass="textarea"
                                                MaxLength="255" runat="server"></asp:TextBox>
                                        </div>
                                    </div>
                                    <p style="margin-left: 200px;">
                                        <i>Entering an internal note is optional and will only be available for review by office
                                        staff.</i>
                                    </p>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label2" runat="server">Copy to Email:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:Label ID="lblEmail" Visible="False" runat="server"></asp:Label>
                                            <asp:TextBox ID="txtEmail" Visible="False" runat="server" Width="200"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div id="divSuccessMessage" class="success-message" style="text-align: right">
                                        <asp:Literal ID="litMessage" Text="" runat="server"></asp:Literal>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <a href="javascript:;" onclick="showRadConfirm()">
                                    <img src="../Content/Images/btn_cancel.gif" class="btn-pop-cancel" alt="Cancel" /></a>
                                &nbsp;
                            <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="../Content/Images/btn_submit_fade.gif"
                                Enabled="False" CssClass="btn-pop-submit" OnClick="btnSubmit_Click" OnClientClick="return enableDisableButton(this);" />
                            </td>
                        </tr>
                    </table>
                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="Transactions"
                        ShowMessageBox="True" ShowSummary="False" DisplayMode="BulletList" EnableClientScript="True"
                        CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                </div>
                <telerik:RadWindowManager ID="RadWindow" ShowContentDuringLoad="True" VisibleStatusbar="False"
                    VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="1100px" Height="850px"
                    Modal="True" EnableShadow="False" EnableEmbeddedBaseStylesheet="False" EnableEmbeddedSkins="False"
                    Skin="CareBlueInf">
                    <ConfirmTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div>
                                <div style="margin-top: 15px; margin-left: 55px;">
                                <a href="Javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_yes_small.gif" alt="Yes" /></a>   &nbsp; &nbsp;
                                  <a href="javascript:;" onclick="$find('{0}').close(false);">
                                        <img src="../Content/Images/btn_no_small.gif" alt="No" /></a>
                                </div>
                            </div>
                        </div>
                    </ConfirmTemplate>
                    <AlertTemplate>
                        <div class="rwDialogPopup radalert">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div style="margin-top: 20px; margin-left: 51px;">
                                <a href="#" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            </div>
                        </div>
                    </AlertTemplate>
                </telerik:RadWindowManager>
            </ContentTemplate>
        </asp:UpdatePanel>
        <script type="text/javascript" language="javascript">

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {
                
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

            function validateAmount(sender, arg) {
                var amount = arg.Value;
                if (amount > 0.0 && amount < 100000.0) {
                    arg.IsValid = true;
                    return;
                }

                arg.IsValid = false;
            }

            function validateMessage(sender, args) {
                if (args.Value.trim().length >= 3) {
                    args.IsValid = true;
                    return;
                }
                else {
                    args.IsValid = false;
                    return;
                }
            }

            function validateCancel(isCancel) {
                if (isCancel) {
                    closePopup();
                }
            }

            function showRadConfirm() {
                radconfirm('Are you sure you want to cancel?', validateCancel, 400, 150, null, '', "../Content/Images/warning.png");
                return false;
            }

            function enableDisableButton(obj) {
                var isPageValid = false;

                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('Transactions');
                }
                if (isPageValid) {
                    obj.disabled = 'disabled';
                    obj.src = "../Content/Images/btn_submit_fade.gif";
                    <%= ClientScript.GetPostBackEventReference(btnSubmit, string.Empty) %>;
                    return false;
                }

            }

            function redirectToPatientTransactionPage() {
                GetRadWindow().BrowserWindow.redirectToPatientTransactionPage();
                closePopup();
            }

        </script>
        <script type="text/javascript">
            window.alert = function (string) {
                var reg = new RegExp("\\-", "g");
                var messages = string.replace(reg, "<br />").replace("Please correct the following inputs before re-submitting your request:", "Please correct the following inputs before re-submitting your request: - <br />");
                var radWindow = $find("<%=RadWindow.ClientID %>");
                radWindow.radalert(messages, 400, 100, '', "", "../Content/Images/warning.png");
            }

        </script>
    </form>
</body>
</html>
