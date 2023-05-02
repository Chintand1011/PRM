<%@ Page Title="Log In" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="login.aspx.cs" Inherits="login" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="HeadContent">
    <link href="Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="Styles/Popup.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" runat="server" ContentPlaceHolderID="MainContent">
    <h1>
        <%-- <asp:ValidationSummary ID="LoginUserValidationSummary" runat="server" CssClass="failureNotification"
            ValidationGroup="LoginUserValidationGroup" />--%>
    </h1>
    <div class="form-row-login">
        <h1 style="margin: 5px 0px 20px 40px; font-size: 1.5em;">Provider Login</h1>
        <div class="editor-label-login">
            <asp:Label ID="lblPracticeID" runat="server">Practice ID:</asp:Label>
        </div>
        <div class="editor-field-login">
            <asp:TextBox ID="txtPracticeID" runat="server" CssClass="textEntry-login"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPracticeID" runat="server" ControlToValidate="txtPracticeID"
                CssClass="failureNotification" ErrorMessage="PracticeID is required." ToolTip="PracticeID is required."
                ValidationGroup="LoginUserValidationGroup">*</asp:RequiredFieldValidator>
        </div>
        <div class="editor-label-login" style="margin-top: 3px;">
            <asp:Label ID="lblUserName" runat="server">Username:</asp:Label>
        </div>
        <div class="editor-field-login" style="margin-top: -3px;">
            <asp:TextBox ID="txtUserName" runat="server" CssClass="textEntry-login"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvUserName" runat="server" ControlToValidate="txtUserName"
                CssClass="failureNotification" ErrorMessage="User Name is required." ToolTip="User Name is required."
                ValidationGroup="LoginUserValidationGroup">*</asp:RequiredFieldValidator>
        </div>
        <div class="editor-label-login" style="margin-top: 3px;">
            <asp:Label ID="lblPassword" runat="server">Password:</asp:Label>
        </div>
        <div class="editor-field-login" style="margin-top: -3px;">
            <asp:TextBox ID="txtPassword" runat="server" CssClass="passwordEntry-login" TextMode="Password"
                onkeyup="loginForm(event)"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                CssClass="failureNotification" ErrorMessage="Password is required." ToolTip="Password is required."
                ValidationGroup="LoginUserValidationGroup">*</asp:RequiredFieldValidator>
        </div>
        <div style="clear: both;">
        </div>
        <div style="margin: 15px 0px 0px 140px">
            <asp:ImageButton ID="btnLogin" runat="server" CommandName="Login" ImageUrl="Content/Images/btn_login.gif"
                ValidationGroup="LoginUserValidationGroup" OnClick="LoginButton_Click" />
        </div>
    </div>
    <div class="boxLogin">
        <img src="Content/Images/cbpp_welcome.jpg" alt="Welcome" style="margin-left: 0px;" />
    </div>
    <h5 style='margin: 10px 0px 0px 30px;'>Please login with the credentials you have been provided.</h5>
    <div class="failureNotification" style="margin: 15px 0px 0px 40px;">
        <asp:Literal ID="litMessage" runat="server"></asp:Literal>
        <div style="text-align: right; margin-top: -10px;">
            <p id="pErrorMessage" runat="server">
            </p>
        </div>
        <asp:Literal ID="litResetPassword" runat="server"></asp:Literal>
    </div>
    <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
        visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
        modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
        restrictionzoneid="divMainContent" skin="CareBlueInf" style="z-index: 3000">
        <AlertTemplate>
            <div class="rwDialogPopup radalert">
                <h5>
                    <div class="rwDialogText">
                        {1}
                    </div>
                </h5>
                <div style="margin-top: 20px; margin-left: 135px;">
                    <a href="#" onclick="$find('{0}').close(true);">
                        <img src="~/Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                </div>
            </div>
        </AlertTemplate>
    </telerik:radwindowmanager>
    <telerik:radwindowmanager id="RadWindowManager1" showcontentduringload="True" visiblestatusbar="False"
        behaviors="Close" visibletitlebar="True" reloadonshow="True" runat="Server" width="700px"
        height="500px" modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
        restrictionzoneid="divMainContent" skin="CareBlue" style="z-index: 3000">
        <Windows>
            <telerik:RadWindow runat="server" Title="" ID="popupPractices" Width="350px" Height="200px">
                <ContentTemplate>
                    <div style="margin-top: -2px;">
                        <table class="CareBluePopup" width="100%">
                            <tr>
                                <td>
                                    <h2p>Administrator Login</h2p>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <h5p>Please select a practice to work with.</h5p>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table class="align-password-fields" width="100%">
                                        <tr>
                                            <td>
                                                <br />
                                                <div class="form-row" style="margin: 0px; align: center;">
                                                    <div class="editor-label-login" style="margin-left: -20px;">
                                                        <asp:Label ID="Label6" runat="server" Text="Practice:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field-login">
                                                        <telerik:RadComboBox ID="cmbPractices" runat="server" Width="200" MaxHeight="200"
                                                            EmptyMessage="Select Practice" AllowCustomText="False" MarkFirstMatch="True"
                                                            DataTextField="Abbr" DataValueField="PracticeID">
                                                        </telerik:RadComboBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="cmbPractices"
                                                            CssClass="failureNotification" ErrorMessage="" ToolTip="Practice is required."
                                                            ValidationGroup="Practice">*</asp:RequiredFieldValidator>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:ValidationSummary ID="ValidationSummary3" runat="server" ValidationGroup="Practice"
                                                    ShowSummary="True" DisplayMode="BulletList" EnableClientScript="True" CssClass="failureNotification" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: right;">
                                                <asp:ImageButton ID="ImageButton2" Style="margin-right: 20px;" runat="server" ImageUrl="Content/Images/btn_ok.gif"
                                                    ValidationGroup="Practice" OnClick="btnPractice_OnClick" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </ContentTemplate>
            </telerik:RadWindow>
        </Windows>
    </telerik:radwindowmanager>
    <telerik:radwindow id="popupResetPassword" showcontentduringload="True" visiblestatusbar="False"
        title="Sign-In Help" behaviors="Reload,Close" visibletitlebar="True" reloadonshow="True"
        runat="Server" width="500px" height="300px" modal="True" enableshadow="False"
        enableembeddedbasestylesheet="False" enableembeddedskins="False" skin="CareBlue">
        <ContentTemplate>
            <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
                <div>
                    <table class="CareBluePopup" width="100%">
                        <tr>
                            <td>
                                <h1p>Reset your Password</h1p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>Please confirm the answer to your security question.</h4p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table class="align-password-fields">
                                    <tr>
                                        <td>
                                            <br />
                                            <div class="form-row">
                                                <div class="editor-label-login">
                                                    <asp:Label ID="Label31" runat="server" Text="Question:"></asp:Label>
                                                </div>
                                                <div class="editor-field-login">
                                                    <asp:Label ID="lblSecurityQuestion" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label-login">
                                                    <asp:Label ID="Label1" runat="server" Text="Answer:"></asp:Label>
                                                </div>
                                                <div class="editor-field-login">
                                                    <asp:TextBox ID="txtSecurityAnswer" runat="server" onkeyup="return validateEvent(event);"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtSecurityAnswer"
                                                        CssClass="failureNotification" ErrorMessage="Security Answer is required." ToolTip="Security Answer is required."
                                                        ValidationGroup="PasswordValidationGroup">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="PasswordValidationGroup"
                                                ShowSummary="True" DisplayMode="BulletList" EnableClientScript="True" CssClass="failureNotification" />
                                            <p style="color: red; margin: -5px 0px -10px 0px;" id="pShowError" runat="server">
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input id="btnCancel" runat="server" type="image" src="Content/Images/btn_cancel.gif"
                                                alt="Cancel" class="btn-pop-cancel" style="float: left;" onclick="closePopup();" />
                                            <asp:ImageButton ID="btnResetPassword" runat="server" ImageUrl="Content/Images/btn_reset.gif"
                                                CssClass="btn-pop-submit" ValidationGroup="PasswordValidationGroup" OnClick="btnResetPassword_OnClick" OnClientClick="return  disableButton(this)" />
                                            <a id="btnClosePopup" runat="server" visible="False" href="javascript:;" onclick="closePopup()">
                                                <img src="Content/Images/btn_close.gif" alt="Close" class="btn-pop-submit" /></a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <asp:HiddenField ID="hdnHideResetPopup" runat="server" />
                <asp:HiddenField ID="hdnResetMessage" runat="server" />
            </telerik:RadAjaxPanel>
        </ContentTemplate>
    </telerik:radwindow>
    <telerik:radwindow id="popupConfirmPassword" showcontentduringload="True" visiblestatusbar="False"
        title="Sign-In Help" behaviors="Reload,Close" visibletitlebar="True" reloadonshow="True"
        runat="Server" width="500px" height="300px" modal="True" enableshadow="False"
        enableembeddedbasestylesheet="False" enableembeddedskins="False" skin="CareBlue">
        <ContentTemplate>
            <telerik:RadAjaxPanel ID="RadAjaxPanel2" runat="server">
                <div>
                    <table class="CareBluePopup" width="100%">
                        <tr>
                            <td>
                                <h1p>Confirm Password Reset</h1p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>Please re-confirm the answer to your security question.</h4p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table class="align-password-fields" width="100%">
                                    <tr>
                                        <td>
                                            <br />
                                            <div class="form-row">
                                                <div class="editor-label-login">
                                                    <asp:Label ID="Label2" runat="server" Text="Question:"></asp:Label>
                                                </div>
                                                <div class="editor-field-login">
                                                    <asp:Label ID="lblConfirmQuestion" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label-login">
                                                    <asp:Label ID="Label4" runat="server" Text="Answer:"></asp:Label>
                                                </div>
                                                <div class="editor-field-login">
                                                    <asp:TextBox ID="txtConfirmAnswer" runat="server" onkeyup="return validateEvent(event);"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtConfirmAnswer"
                                                        CssClass="failureNotification" ErrorMessage="Security Answer is required." ToolTip="Security Answer is required."
                                                        ValidationGroup="PasswordConfirmValidationGroup">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="PasswordConfirmValidationGroup"
                                                ShowSummary="True" DisplayMode="BulletList" EnableClientScript="True" CssClass="failureNotification" />
                                            <p style="color: red;" id="pshowConfirmPopupError" runat="server">
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <input id="Image1" runat="server" type="image" src="Content/Images/btn_cancel.gif"
                                                alt="Cancel" class="btn-pop-cancel" style="float: left;" onclick="redirectPage()" />
                                            <asp:ImageButton ID="ImageButton1" runat="server" CommandName="Login" ImageUrl="Content/Images/btn_submit.gif"
                                                CssClass="btn-pop-submit" ValidationGroup="PasswordConfirmValidationGroup" OnClick="btnConfirmPassword_OnClick" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </div>
                <asp:HiddenField ID="hdnIsClosePopup" runat="server" />
                <asp:HiddenField ID="hdnHideConfirmPopup" runat="server" />
                <asp:HiddenField ID="hdnConfirmMessage" runat="server" />
            </telerik:RadAjaxPanel>
        </ContentTemplate>
    </telerik:radwindow>
    <telerik:radwindowmanager id="windowManager" behaviors="Move" style="z-index: 200001"
        showcontentduringload="False" visiblestatusbar="False" visibletitlebar="True"
        reloadonshow="True" runat="Server" modal="True" enableembeddedbasestylesheet="True"
        enableembeddedskins="False" skin="CareBlueInf">
                <AlertTemplate>
                    <div class="rwDialogPopup radalert">
                        <h5>
                            <div class="rwDialogText">
                                {1}
                            </div>
                        </h5>
                        <div style="margin-top: 20px; margin-left: 51px;">
                            <a href="javascript:;" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:radwindowmanager>
    <script src="Scripts/jquery-1.10.1.js" type="text/javascript"></script>
    <script type="text/javascript">

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {

            $(function () {
                if ($("#<%=hdnHideResetPopup.ClientID %>").val() == "1") {
                    $find("<%=popupResetPassword.ClientID %>").close();

                    var radWindow = $find("<%=windowManager.ClientID %>");
                    radWindow.radalert($("#<%=hdnResetMessage.ClientID %>").val(), 350, 150, "", redirectPage, "../Content/Images/warning.png");
                    
                    $("#<%=hdnHideResetPopup.ClientID %>").val("0");
                }

                if ($("#<%=hdnHideConfirmPopup.ClientID %>").val() == "1") {
                    $find("<%=popupConfirmPassword.ClientID %>").close();
                    
                    var radWindow = $find("<%=windowManager.ClientID %>");
                    radWindow.radalert($("#<%=hdnConfirmMessage.ClientID %>").val(), 350, 150, "", redirectPage, "");

                    $("#<%=hdnHideConfirmPopup.ClientID %>").val("0");
                }

                if ($("#<%=hdnHideResetPopup.ClientID %>").val() == "true") {
                    $find("<%=popupResetPassword.ClientID %>").close();
                }

                if ($("#<%=hdnIsClosePopup.ClientID %>").val() == "1") {
                    closeConfirmPassword();
                }

            });
        });

        function resetPassword() {
            $("#<%=txtSecurityAnswer.ClientID %>").val("");
            $find("<%=popupResetPassword.ClientID %>").show();
        }

        function closePopup() {
            $find("<%=popupResetPassword.ClientID %>").close();
        }

        function loginForm(e) {
            if (e.keyCode == 13) {
                $("#<%=btnLogin.ClientID %>").click();
            }
        }

        function validateEvent(e) {
            if (e.keyCode == 13) {
                $("#<%=btnResetPassword.ClientID %>").click();
            }
            return false;
        }

        function closeConfirmPassword() {
            $find("<%=popupConfirmPassword.ClientID %>").close();
        }

        function redirectPage() {
            location.href = "<%=ClientSession.WebPathRootProvider %>" + "login.aspx";
        }

        function redirectToUsers() {
            location.href = "<%=ClientSession.WebPathRootProvider %>" + "admin/users.aspx";
        }

    </script>
    <script type="text/javascript">
        var nav = window.Event ? true : false;
        if (nav) {
            window.onkeydown = NetscapeEventHandler_KeyDown;
        } else {
            document.onkeydown = MicrosoftEventHandler_KeyDown;
        }

        function NetscapeEventHandler_KeyDown(e) {
            if (e.which == 13 && e.target.type != 'textarea' && e.target.type != 'submit') {
                return false;
            }
            return true;
        }

        function MicrosoftEventHandler_KeyDown() {
            if (event.keyCode == 13 && event.srcElement.type != 'textarea' &&
            event.srcElement.type != 'submit')
                return false;
            return true;
        }

        function disableButton(obj) {

            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('PasswordValidationGroup');
            }


            if (isPageValid) {
                obj.disabled = 'disabled';
                obj.src = "/Content/Images/btn_reset_fade.gif";
                <%= ClientScript.GetPostBackEventReference(btnResetPassword, string.Empty) %>;
            }

        }

    </script>
</asp:Content>
