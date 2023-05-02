<%@ Page Language="C#" AutoEventWireup="true" CodeFile="addStatement_popup.aspx.cs"
    Inherits="addStatement_popup" %>

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
                                <h2p>Add Statement</h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>Add a new statement to setup BlueCredit or a Payment Plan.</h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad">
                                <div>
                                    <br />&nbsp;
                                    <div class="form-row" style="margin:10px 0 0 -60px ;">
                                        <div class="editor-label">
                                            <asp:Label ID="Label6" runat="server">Charge Description:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbQuickPick" runat="server" width="250px" emptymessage="Select description or enter your own..." 
                                                 allowcustomtext="True" MaxLength="60" markfirstmatch="True" maxheight="80">
                                            </telerik:radcombobox>
                                        </div>
                                    </div>
                                    <div class="form-row" style="margin-left:-60px;">
                                        <div class="editor-label">
                                            <asp:Label ID="Label10" runat="server">Charge Amount:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtAmount" type="Currency" numberformat-decimaldigits="2" MaxValue="100000.00"
                                                numberformat-groupseparator="," Width="100">
                                            </telerik:radnumerictextbox>
                                            <asp:CustomValidator CssClass="failureNotification" ValidateEmptyText="True" runat="server"
                                                ControlToValidate="txtAmount" ClientValidationFunction="validateAmount" ValidationGroup="Statement"
                                                Display="Dynamic" ToolTip="Amount must be a positive value up to $100,000.00"
                                                ErrorMessage="Amount must be greater than $0 and up to $100,000.00">*</asp:CustomValidator>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                    <br />&nbsp;
                                <a href="javascript:;" onclick="closePopup();">
                                    <img src="../Content/Images/btn_cancel.gif" class="btn-pop-cancel" alt="Cancel" /></a>
                                &nbsp;
                            <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="../Content/Images/btn_submit.gif"
                                 CssClass="btn-pop-submit" OnClick="btnSubmit_Click" OnClientClick="return enableDisableButton(this);" />
                            </td>
                        </tr>
                    </table>
                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="Statement"
                        ShowMessageBox="True" ShowSummary="False" DisplayMode="BulletList" EnableClientScript="True"
                        CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                </div>
                <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="1100px" height="850px"
                    modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    skin="CareBlueInf">
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
                                    <img src="../Content/Images/btn_yes_small.gif" alt="Yes" /></a>    &nbsp; &nbsp;
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
                </telerik:radwindowmanager>
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
                var amount = parseInt(arg.Value);
                if (amount > 0 && amount < 100000.01) {
                    arg.IsValid = true;
                    return;
                }

                arg.IsValid = false;
            }
            
          
            function enableDisableButton(obj) {
                var isPageValid = false;

                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('Statement');
                }
                if (isPageValid) {
                    obj.disabled = 'disabled';
                    obj.src = "../Content/Images/btn_submit_fade.gif";
                    <%= ClientScript.GetPostBackEventReference(btnSubmit, string.Empty) %>;
                    return false;
                }

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
