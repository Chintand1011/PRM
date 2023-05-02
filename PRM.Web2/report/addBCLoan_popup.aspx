<%@ Page Language="C#" AutoEventWireup="true" CodeFile="addBCLoan_popup.aspx.cs"
    Inherits="addBCLoan_popup" %>

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
                                <h2p>Create BlueCredit Loan</h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>Enter treatment amount and, if required, the agreed upon down payment.</h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad">
                                <div>
                                    <div class="form-row">
                                        <div class="editor-field" style="font-size:1.1em; line-height:1.8em; color:#222222; margin:10px 20px 10px 0px;">
                                            <span id="pgBlueCreditQualAbbr" runat="server"></span><br />
                                            <span id="pgLenderQualAbbr" runat="server"></span>
                                        </div>
                                    </div>
                                    <div class="form-row" style="margin: 10px 0 0 -40px;">
                                        <div class="editor-label" style="margin-top:2px;">
                                            <asp:Label ID="Label6" runat="server">Treatment Description:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbQuickPick" runat="server" width="250px" emptymessage="Select description or enter your own..."
                                                allowcustomtext="True" maxlength="60" markfirstmatch="True" maxheight="80">
                                            </telerik:radcombobox>
                                        </div>
                                    </div>
                                    <div class="form-row" style="margin-left: -40px;">
                                        <div class="editor-label" style="margin-top:3px;">
                                            <asp:Label ID="Label10" runat="server">Treatment Amount:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtAmount" type="Currency" numberformat-decimaldigits="2" 
                                                numberformat-groupseparator="," width="100">
                                            </telerik:radnumerictextbox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtAmount"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Amount is required."
                                                ErrorMessage="Amount is required." ValidationGroup="Statement">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row" style="margin-left: -40px;">
                                        <div class="editor-label" style="margin-top:3px;">
                                            <asp:Label ID="Label1" runat="server">Down Payment:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtDownPayment" type="Currency" AllowOutOfRangeAutoCorrect="False" numberformat-decimaldigits="2" value="0"
                                                numberformat-groupseparator="," width="100">
                                            </telerik:radnumerictextbox>
                                            
                                        </div>
                                    </div>
                                    <div class="form-row" style="margin-left: -40px;">
                                        <div class="editor-label" style="margin-top:2px;">
                                            <asp:Label ID="Label2" runat="server">Total Financing:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            &nbsp;<label id="lblFinancedAmount" style="color:#222222; font-size:1.2em; font-weight:600;">$0.00</label>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <a href="javascript:;" onclick="closePopup();">
                                    <img src="../Content/Images/btn_close.gif" class="btn-pop-cancel" alt="Close" /></a>
                                &nbsp;
                            <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="../Content/Images/btn_next.gif"
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


            $(function () {
                registerOnChangeEvents();
            });

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {
                getFinancedAmount();
                registerOnChangeEvents();
            });

            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
                else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

                return oWindow;
            }

            function closePopup() {
                GetRadWindow().BrowserWindow.removeParamFromURL();
                GetRadWindow().close();
            }

            function goToBCApplyCredit() {
                GetRadWindow().BrowserWindow.goToBCApplyCredit();
                closePopup();
            }



            function enableDisableButton(obj) {
                var isPageValid = false;

                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('Statement');
                }
                if (isPageValid) {

                    obj.disabled = 'disabled';
                    obj.src = "../Content/Images/btn_next_fade.gif";
                    <%= ClientScript.GetPostBackEventReference(btnSubmit, string.Empty) %>;
                    return false;
                }

            }

            function registerOnChangeEvents() {
                $("#<%=txtAmount.ClientID%>, #<%=txtDownPayment.ClientID%>").change(getFinancedAmount);
            }

            function getFinancedAmount() {

                var textBoxAmount = $find("<%=txtAmount.ClientID%>");
                var textBoxDownPayment = $find("<%=txtDownPayment.ClientID%>");


                var amount = parseFloat(textBoxAmount.get_value());
                amount = isNaN(amount) ? 0 : amount;

                var downPayment = parseFloat(textBoxDownPayment.get_value());
                downPayment = isNaN(downPayment) ? 0 : downPayment;

                var financedAmount = amount - downPayment;

                var minValue = amount * parseFloat('<%=ViewState["BlueCreditMinDP"]%>');
                textBoxDownPayment.set_minValue(minValue);

                setTimeout(function () {
                    if (downPayment < minValue) {
                        textBoxDownPayment.set_value(minValue);
                    }
                  
                }, 10);

                
                var re = '\\d(?=(\\d{' + (3) + '})+' + (2 > 0 ? '\\.' : '$') + ')';
                var financedAmountFormatted = financedAmount.toFixed(Math.max(0, ~~2)).replace(new RegExp(re, 'g'), '$&,');

                $("#lblFinancedAmount").text("$" + financedAmountFormatted);

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
