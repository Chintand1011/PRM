<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="users.aspx.cs"
    Inherits="users" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Manage Portal Users</h1>
            </div>
            <div class="bodyMain">
                <h2>Use this form to add new users to the application or modify existing users. Existing
                    users cannot be deleted, but they can be made inactive.</h2>
                <table width="100%">
                    <tr>
                        <td>
                                <div style="float: left;">
                                    <h3>Practice User Listing</h3>
                                </div>
                                <div style="float: right;">
                                    <h5>
                                        <asp:CheckBox ID="chkShowInActiveUsers" Checked="false" AutoPostBack="True" OnCheckedChanged="chkShowInActiveUsers_OnCheckChanged" runat="server"/> 
                                        Also show inactive users &nbsp;&nbsp;
                                    </h5>
                                </div>
                            <div style="float: left; width: 100%; margin-top:-10px;">
                                <telerik:radgrid id="grdUsers" runat="server" allowsorting="True" allowpaging="True"
                                    onneeddatasource="grdUsers_NeedDataSource" pagesize="10" onitemcommand="grdUsers_ItemCommand"
                                    onitemdatabound="grdUsers_ItemDataBound">
                                    <MasterTableView AutoGenerateColumns="False" DataKeyNames="SysUserID,RoleTypeID">
                                        <Columns>
                                            <telerik:GridBoundColumn HeaderText="LastName" DataField="NameLast">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="FirstName" DataField="NameFirst">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Role Type" DataField="RoleType">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Username" DataField="UserName">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Email" DataField="Email">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Last Login" DataField="LastLogin" DataFormatString="{0:MM/dd/yyyy}">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Last IP Address" DataField="LastLoginIPAddress">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="State" DataField="LockoutAbbr">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Status" DataField="FlagActiveAbbr">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridButtonColumn CommandName="EditUser" UniqueName="Modify" HeaderText="Modify"
                                                ButtonType="ImageButton" ImageUrl="~/Content/Images/edit.png">
                                            </telerik:GridButtonColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:radgrid>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ImageButton ID="btnAddNew" ImageUrl="../Content/Images/btn_add.gif" OnClick="btnAddNew_OnClick" CssClass="btn-add" runat="server" Style="margin-right: 10px; float: right;" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Panel ID="pnlUser" Visible="False" runat="server">
                                <hr />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <h2 id="h2MainHeading" runat="server">Edit or Create New User</h2>
                            <table>
                                <tr>
                                    <td width="48%" valign="top">
                                        <div class="form-row">
                                            <input type="hidden" runat="server" id="hdnSysUserID" />
                                            <div class="editor-label">
                                                <asp:Label ID="lblLastName" runat="server">Last Name:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtLastName" runat="server"></asp:TextBox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtLastName"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Last Name is required."
                                                ErrorMessage="Last Name is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="lblFirstName" runat="server">First Name:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtFirstName" runat="server"></asp:TextBox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtFirstName"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="First Name is required."
                                                ErrorMessage="First Name is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="lblUsers" runat="server">UserName:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtUserName" MaxLength="20" AutoPostBack="True" OnTextChanged="txtUserName_OnTextChanged"
                                                    runat="server"></asp:TextBox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtUserName"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="UserName is required."
                                                ErrorMessage="Username is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtUserName" CssClass="failureNotification"
                                                ToolTip="Invalid UserName" Display="Dynamic" SetFocusOnError="True" ValidationGroup="Users"
                                                ErrorMessage="Invalid Username." ValidationExpression="^[a-zA-Z0-9_.]+$">*</asp:RegularExpressionValidator>
                                            <asp:CustomValidator ID="cstmUserName" runat="server" ControlToValidate="txtUserName"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationGroup="Users">*</asp:CustomValidator>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label7" runat="server" Text="Phone:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:radmaskedtextbox id="txtPhone" runat="server" mask="(###) ###-####" width="142">
                                                </telerik:radmaskedtextbox>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" Display="Dynamic"
                                                    runat="server" ToolTip="Format is (XXX) XXX-XXXX" SetFocusOnError="True" CssClass="failureNotification"
                                                    ErrorMessage="Phone's Format is (XXX) XXX-XXXX." ControlToValidate="txtPhone"
                                                    ValidationGroup="Users" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label8" runat="server" Text="Email:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:radcombobox id="txtEmail" runat="server" width="200" emptymessage="Choose Status..."
                                                    allowcustomtext="False" markfirstmatch="True">
                                                </telerik:radcombobox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="cmbStatusTypes"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Status is required."
                                                ErrorMessage="Status is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label15" runat="server" Text="Landing Page:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:radcombobox id="cmbLandingPages" runat="server" width="200" emptymessage="Choose Landing Page..."
                                                    allowcustomtext="False" markfirstmatch="True" datatextfield="MenuName" datavaluefield="LandingPage">
                                                </telerik:radcombobox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="cmbLandingPages"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ErrorMessage="Landing Page is required."
                                                ToolTip="Landing Page is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label11" runat="server">Payments:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:CheckBox ID="chkPayment" runat="server" />
                                                Print Receipt by Default
                                                <img src="../Content/Images/icon_help.png" title="By selecting this option, payment receipts will be prompted for printing after signature. Users who routinely process payments where the patient requires a printed receipt should choose this option." alt="Help" />
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label12" runat="server">&nbsp;</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:CheckBox ID="chkSignature" runat="server" />
                                                Prompt for Signature by Default
                                                <img src="../Content/Images/icon_help.png" title="By selecting this option, payment receipts will be prompted signature after being processed. Users who routinely process payments in-person with the patient should choose this option." alt="Help" />
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label1" runat="server">Notes:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox TextMode="MultiLine" ID="txtNotes" Width="350px" Height="90px" CssClass="textarea"
                                                    runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </td>
                                    <td width="4%" valign="top">&nbsp;
                                    </td>
                                    <td width="48%" valign="top">
                                        <div class="form-row" id="divLoginStates" runat="server">
                                            <div class="editor-label">
                                                <asp:Label ID="Label4" runat="server">Login State:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblLoginState" runat="server"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                &nbsp;&nbsp;&nbsp;
                                                <asp:LinkButton ID="lnkReset" Text="Reset" OnClick="lnkReset_OnClick" runat="server"></asp:LinkButton>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label2" runat="server">Status:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:radcombobox id="cmbStatusTypes" runat="server" width="200" emptymessage="Choose Status..."
                                                    allowcustomtext="False" markfirstmatch="True">
                                                </telerik:radcombobox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="cmbStatusTypes"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Status is required."
                                                ErrorMessage="Status is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label3" runat="server">Account Type:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:radcombobox id="cmbAccountTypes" runat="server" width="200" emptymessage="Choose Types..."
                                                    allowcustomtext="False" markfirstmatch="True" datatextfield="Abbr" datavaluefield="RoleTypeID">
                                                </telerik:radcombobox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="cmbAccountTypes"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ErrorMessage="Account Type is required."
                                                ToolTip="Account Type is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>

                                            &nbsp; &nbsp;<img src="../Content/Images/icon_help.png" title="Read only users may report on anything but not modify data. &#13;Standard users may manage patient accounts and process payments. &#13;Power users may run credit and manage BlueCredit accounts. &#13;Billing managers may over-ride down payments. &#13;Administrators may manager all functions and users." alt="Help" />
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label13" runat="server">Default Location:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:radcombobox id="cmbPrimaryLocations" runat="server" width="200" emptymessage="Choose Location..."
                                                    allowcustomtext="False" markfirstmatch="True" datatextfield="Abbr" datavaluefield="LocationID">
                                                </telerik:radcombobox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="cmbPrimaryLocations"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ErrorMessage="Default location is required."
                                                ToolTip="Default location is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label14" runat="server">Default Provider:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:radcombobox id="cmbExistingProvider" runat="server" width="200" emptymessage="Choose Provider..."
                                                    allowcustomtext="False" markfirstmatch="True" datatextfield="ProviderAbbr" datavaluefield="ProviderID">
                                                </telerik:radcombobox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="cmbExistingProvider"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ErrorMessage="Default provider is required."
                                                ToolTip="Default provider is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>
                                        </div>
                                        <p style="color: red; font-size: 14px; text-align: right; margin-right: 50px;" id="pMessage" runat="server" visible="False">
                                            Fields below don't need to be re-entered if they are not being updated.
                                        </p>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label5" runat="server">Password:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtPassword" TextMode="Password" runat="server" onkeyup="return passwordChanged();"></asp:TextBox>
                                                <span id="strength"></span>
                                            </div>
                                            <asp:RequiredFieldValidator ID="rqrFieldPassword" runat="server" ControlToValidate="txtPassword"
                                                ErrorMessage="Password is required." Display="Dynamic" SetFocusOnError="True"
                                                CssClass="failureNotification" ToolTip="Password is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>
                                            <asp:CustomValidator ID="cstmValidatorDescription" CssClass="failureNotification"
                                                ValidateEmptyText="True" runat="server" ControlToValidate="txtPassword" ClientValidationFunction="validatePassword"
                                                ErrorMessage="Password must be strong" ValidationGroup="Users" Display="Dynamic"
                                                ToolTip="Password must be strong">*</asp:CustomValidator>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label6" runat="server">Confirm:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtConfirmPassword" TextMode="Password" runat="server"></asp:TextBox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="rqrFieldConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Confirm Password is required."
                                                ErrorMessage="Confirm Password is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>
                                            <asp:CompareValidator ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword"
                                                CssClass="failureNotification" ValidationGroup="Users" ErrorMessage="Password not matched"
                                                runat="server" SetFocusOnError="True"></asp:CompareValidator>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label9" runat="server">Security Question:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:radcombobox id="cmbSecurityQuestion" runat="server" width="300" emptymessage="Choose Security Question..."
                                                    allowcustomtext="False" markfirstmatch="True" datatextfield="Abbr" datavaluefield="SecurityQuestionTypeID">
                                                </telerik:radcombobox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="cmbSecurityQuestion"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ErrorMessage="Security Question is required."
                                                ToolTip="Security Question is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label10" runat="server">Security Answer:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtSecurityAnswer" TextMode="Password" runat="server"></asp:TextBox>
                                            </div>
                                            <asp:RequiredFieldValidator ID="rqdSecurityAnswer" runat="server" ControlToValidate="txtSecurityAnswer"
                                                ErrorMessage="Security Answer is required." Display="Dynamic" SetFocusOnError="True"
                                                CssClass="failureNotification" ToolTip="Security Answer is required." ValidationGroup="Users">*</asp:RequiredFieldValidator>
                                            <asp:CustomValidator CssClass="failureNotification" ValidateEmptyText="True" runat="server" ControlToValidate="txtSecurityAnswer" ClientValidationFunction="validateSecurityAnswerMinLength"
                                                ErrorMessage="Minimum 3 chars are required" ValidationGroup="Users" Display="Dynamic"
                                                ToolTip="Minimum 3 chars are required">*</asp:CustomValidator>
                                        </div>
                                        &nbsp;
                                        <div style="margin-left: 198px; margin-top: 10px;">
                                            <asp:ImageButton ID="ImageButton1" ImageUrl="../Content/Images/btn_cancel.gif" OnClientClick="refreshPage()"
                                                CssClass="btn-cancel" runat="server" />
                                            &nbsp;<asp:ImageButton ID="btnSubmit" OnClientClick="return enableDisableButton(this);" ImageUrl="../Content/Images/btn_submit.gif"
                                                runat="server" CssClass="btn-submit" OnClick="btnSubmit_Click" />
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                &nbsp; &nbsp;
                                            </div>
                                            <div class="editor-field">
                                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Users"
                                                    ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                    CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                                                <div id="Message" class="success-message" align="right">
                                                    <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
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
                        <div style="margin-top: 20px; margin-left: 51px;">
                            <a href="#" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:radwindowmanager>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            unCheckPaymentOptions();
        });

        var isStrongPassword = false;

        function passwordChanged() {
            var strength = document.getElementById('strength');
            var strongRegex = new RegExp("^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
            var mediumRegex = new RegExp("^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");
            var enoughRegex = new RegExp("(?=.{6,}).*", "g");
            var pwd = document.getElementById('<%=txtPassword.ClientID%>');
            if (pwd.value.length == 0) {
                strength.innerHTML = 'Type Password';
                isStrongPassword = false;
            } else if (false == enoughRegex.test(pwd.value)) {
                strength.innerHTML = 'More Characters';
                isStrongPassword = false;
            } else if (strongRegex.test(pwd.value)) {
                strength.innerHTML = '<span style="color:green">Strong!</span>';
                isStrongPassword = true;
            } else if (mediumRegex.test(pwd.value)) {
                strength.innerHTML = '<span style="color:orange">Medium!</span>';
                isStrongPassword = false;
            } else {
                strength.innerHTML = '<span style="color:red">Weak!</span>';
                isStrongPassword = false;
            }
        }

        function enableDisableButton(obj) {
            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('Users');
            }
            if (isPageValid) {
                obj.disabled = 'disabled';
                obj.src = $("#<%=hdnSysUserID.ClientID %>").val() == "" ? "../Content/Images/btn_submit_fade.gif" : "../Content/Images/btn_update_fade.gif";
                <%= ClientScript.GetPostBackEventReference(btnSubmit, string.Empty) %>;
                return false;
            }

        }


        function validatePassword(sender, args) {
            var password = $("#<%=txtPassword.ClientID %>").val();
            if (password.length > 0) {
                if (isStrongPassword) {
                    args.IsValid = true;
                    return;
                } else {
                    args.IsValid = false;
                    return;
                }
            }
        }

        function validateSecurityAnswerMinLength(sender, args) {
            var answer = $("#<%=txtSecurityAnswer.ClientID %>").val();
            var id = parseInt($("#<%=hdnSysUserID.ClientID %>").val());
            var isValid = answer.length >= 3;

            if (id > 0) {
                if (answer != '') {
                    args.IsValid = isValid;
                }
            } else {
                args.IsValid = isValid;
            }
        }
        
        function unCheckPaymentOptions() {
            var printReceipt = $("#<%=chkPayment.ClientID%>");
            var promptSignature = $("#<%=chkSignature.ClientID%>");

            printReceipt.click(function() {
                promptSignature.removeAttr("checked");
            });
            
            promptSignature.click(function () {
                printReceipt.removeAttr("checked");
            });
        }

    </script>
</asp:Content>