<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="myinfo.aspx.cs"
    Inherits="myinfo" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="MyInfoUpdatePancel" runat="server">
        <ContentTemplate>
            <div class="pgColumn1">
                <h2 style="margin-right: 5px;">Explanation of Page</h2>
                <h4>This is the contact information registered with your provider.</h4>
                <h5>Please review your information for accuracy and update any data which is no longer correct. You may provide an alternate address if physical mail should not be sent to your billing address.
                    <br />
                    <br />
                    <b>Did you know? </b>
                    <br />
                    If you provide your email address you'll automatically get copies of updated statements and payment receipts, immediately after they are processed!</h5>
            </div>
            <div class="pgColumn2">
                <h1>Patient Profile</h1>
                <h3>Review and Update Your Information</h3>
                <hr />
                <table width="100%" border="0">
                    <tr>
                        <!----------------------------------------------------------------- COL 1 ---------------------------------------------------------------------->
                        <td width="30%" valign="top">
                            <h3 style="margin-left: 20px;">Primary Account Owner</h3>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label Text="First Name:" runat="server"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblFirstName" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Last Name:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblLastName" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Date of Birth:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblDateofBirth" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                &nbsp;
                            </div>
                            <h3 style="margin-left: 20px;">Primary Billing Address</h3>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Street:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblStreet" runat="server" Text="Street:"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Apt/Suite:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblAptSuite" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="City:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblCity" runat="server" Text="City:"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="State:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblState" runat="server" Text="State:"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Zip Code:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblZipCode" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                &nbsp;
                            </div>
                            <h3 style="margin-left: 20px;">Your Provider Information</h3>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Practice:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblPracticeName" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label ID="Label2" runat="server" Text="Provider:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblProviderName" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label ID="Label3" runat="server" Text="Location:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblLocName" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label ID="Label9" runat="server" Text="Phone:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblLocPhone" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label ID="Label10" runat="server" Text="Fax:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblLocFax" runat="server"></asp:Label>
                                </div>
                            </div>
                        </td>
                        <!----------------------------------------------------------------- COL 2 ---------------------------------------------------------------------->
                        <td width="35%" valign="top">
                            <h3 style="margin-left: 20px;">Contact Information</h3>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label Text="Home Phone:" runat="server"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblHomePhone" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Alt Phone:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblAltPhone" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Email:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblEmail" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                &nbsp;
                            </div>
                            <h3 style="margin-left: 20px;">Alternate Mailing Address</h3>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Street:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblAltStreet" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Apt/Suite:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblAltAptSuite" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="City:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblAltCity" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="State:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblAltState" runat="server" Text="State:"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Zip Code:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblAltZipCode" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                &nbsp;
                            </div>
                            <div class="form-row-nopad">
                                &nbsp;
                            </div>
                            <div class="form-row-nopad">
                                &nbsp;
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label ID="Label4" runat="server" Text="Address 1:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblLocAddr1" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label ID="Label5" runat="server" Text="Address 2:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblLocAddr2" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label ID="Label6" runat="server" Text="City:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblLocCity" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label ID="Label7" runat="server" Text="State:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblLocState" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                <div class="editor-label">
                                    <asp:Label ID="Label8" runat="server" Text="Zip Code:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblLocZip" runat="server"></asp:Label>
                                </div>
                            </div>
                        </td>
                        <!----------------------------------------------------------------- COL 3 ---------------------------------------------------------------------->
                        <td width="35%" valign="top">
                            <h3 style="margin-left: -30px;">Account Preferences</h3>
                            <div class="form-row-nopad" style="margin-left: -20px;">
                                <div class="editor-label">
                                    <asp:Label ID="Label27" runat="server" Text="Login PIN Code:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblPINCode" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad" style="margin-left: -20px;">
                                <div class="editor-label">
                                    <asp:Label ID="Label1" runat="server" Text="Statements To:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblStatements" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad" style="margin-left: -20px;">
                                <div class="editor-label">
                                    <asp:Label ID="Label15" runat="server" Text="Email Allowed:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblEmailStatements" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row-nopad">
                                &nbsp;
                            </div>
                            <div id="divSystemMessages" runat="server" visible="False">
                                <h3 style="margin-left: -30px;">Practice Notifications</h3>
                                <div class="form-row-nopad" style="margin-left: -20px; margin-top: -5px;">
                                    <div class="editor-field" style="padding-left: 20px;">
                                        <asp:Literal ID="litSystemMessage" runat="server"></asp:Literal>
                                    </div>
                                </div>
                            </div>

                            <div class="form-row-nopad" style="margin: 260px 0 0 40px;">
                                <div class="editor-field">
                                    <asp:ImageButton ID="btnUpdate" runat="server" ImageUrl="Content/Images/btn_update.gif"
                                        CssClass="btn-update" OnClick="btnUpdate_Click" />
                                </div>
                            </div>
                            <div id="divSuccessMessage" class="success-message">
                                <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <!-- ADD THE FOLLOWING TO RESTRICT POPUP WINDOW PLACEMENT: RestrictionZoneID="divMainContent" -->
            <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px" restrictionzoneid="divMainContent"
                modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize" style="z-index: 3000">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popupInputMyProfile" RegisterWithScriptManager="True"
                        MinWidth="730" MinHeight="500">
                        <ContentTemplate>
                            <%--<asp:UpdatePanel ID="popupInputMyProfileUpdatePanel" runat="server">
                                <ContentTemplate>--%>
                            <div>
                                <table class="CareBluePopup" width="100%">
                                    <tr>
                                        <td colspan="2">
                                            <h2p>Update Profile</h2p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <h3p>You may update your mailing address and change your preference for delivery of statements.</h3p>
                                        </td>
                                    </tr>
                                </table>
                                <div class="ExtraPad"></div>
        
                                <table class="CareBluePopup" width="100%" border="0">
                                    <tr>
                                        <td class="ExtraPad">
                                            <table class="align-popup-fields" border="0">
                                                <tr>
                                                    <td width="350" valign="top">
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label11" runat="server" Text="Primary Address:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                &nbsp;
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:Label ID="lblPatientName" runat="server"></asp:Label><br />
                                                                <asp:Label ID="lblAddress1" runat="server"></asp:Label><br />
                                                                <asp:Label ID="lblAddress2" runat="server"></asp:Label><br />
                                                                <asp:Label ID="lblPhone" runat="server"></asp:Label>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label17" runat="server" Text="Mailing Address:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <telerik:RadComboBox ID="cmbStatements" runat="server" Width="149px" DataTextField="Abbr"
                                                                    AllowCustomText="False" MarkFirstMatch="True" DataValueField="LocationID" MaxHeight="200">
                                                                </telerik:RadComboBox>
                                                                <asp:RequiredFieldValidator ID="rfvStatements" runat="server" ControlToValidate="cmbStatements"
                                                                    Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Mailing address is required."
                                                                    ErrorMessage="Mailing address is required" ValidationGroup="MyinfoValidationGroup">*</asp:RequiredFieldValidator>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label18" runat="server" Text="Email Address:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:TextBox ID="txtEmail" runat="server" Width="211" MaxLength="30" onchange="checkEmailStatements();"></asp:TextBox>
                                                                <asp:HiddenField ID="hdnEmail" runat="server"/>
                                                                <asp:RegularExpressionValidator ID="regEmail" runat="server" CssClass="failureNotification"
                                                                    ToolTip="Invalid Email address." ControlToValidate="txtEmail" Display="Dynamic" SetFocusOnError="true"
                                                                    ErrorMessage="Invalid Email address." ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                                                    ValidationGroup="MyinfoValidationGroup">*</asp:RegularExpressionValidator>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                &nbsp;
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:CheckBox ID="chkEmailMyStatements" runat="server" Text="Email My Statements" />
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td width="320" valign="top">
                                                        <div class="form-row">
                                                            <div class="editor-label" style="width:200px; text-align: left;">
                                                                <asp:Label ID="Label19" runat="server" Text="Secondary Mailing Address:"></asp:Label>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label25" runat="server" Text="Street:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:TextBox ID="txtAltStreet" runat="server" MaxLength="30"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label20" runat="server" Text="Apt/Suite:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:TextBox ID="txtAltAptSuite" runat="server" MaxLength="30"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label21" runat="server" Text="City:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:TextBox ID="txtAltCity" runat="server" MaxLength="30"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label22" runat="server" Text="State:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <telerik:RadComboBox ID="cmbAltStates" runat="server" Width="149px" EmptyMessage="Choose State..."
                                                                    AllowCustomText="False" MarkFirstMatch="True" DataTextField="Name" DataValueField="StateTypeID"
                                                                    MaxHeight="200">
                                                                </telerik:RadComboBox>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="lblZipCode1" runat="server" Text="Zip Code +4:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:TextBox ID="txtAltZipCode1" runat="server" CssClass="zip-code1"
                                                                    MaxLength="5"></asp:TextBox>
                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtAltZipCode1"
                                                                    Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                                                    ToolTip="Invalid Zip Code 1" ErrorMessage="Invalid Zip Code" ValidationGroup="MyinfoValidationGroup">*</asp:RegularExpressionValidator>
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:Label ID="Label23" runat="server" Text="-"></asp:Label>
                                                                <asp:TextBox ID="txtAltZipCode2" runat="server" CssClass="zip-code2" MaxLength="4"></asp:TextBox>
                                                                <asp:RegularExpressionValidator runat="server" ControlToValidate="txtAltZipCode2"
                                                                    Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{4}$"
                                                                    ToolTip="Invalid Zip Code 2" ErrorMessage="Invalid Zip Code" ValidationGroup="MyinfoValidationGroup">*</asp:RegularExpressionValidator>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label24" runat="server" Text="Alt Phone:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <telerik:RadMaskedTextBox ID="txtAltPhone" runat="server" Mask="(###) ###-####" Width="149">
                                                                </telerik:RadMaskedTextBox>
                                                                <asp:RegularExpressionValidator Display="Dynamic" runat="server" ToolTip="Format is (XXX) XXX-XXXX"
                                                                    ErrorMessage="Incomplete phone number" SetFocusOnError="True" CssClass="failureNotification"
                                                                    ControlToValidate="txtAltPhone" ValidationGroup="MyinfoValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                                            </div>
                                                        </div>
                                                        <div class="form-row-nopad">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label28" runat="server" Text="Login PIN Code:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <%--<telerik:RadMaskedTextBox  runat="server" Mask="########" RequireCompleteText="False"
                                                                    HideOnBlur="True" Width="150">
                                                                </telerik:RadMaskedTextBox>--%>
                                                                <telerik:RadTextBox runat="server" ID="txtPincode" Width="150" MaxLength="8">
                                                                </telerik:RadTextBox>
                                                                <asp:CustomValidator CssClass="failureNotification" runat="server" ControlToValidate="txtPincode"
                                                                    ClientValidationFunction="validatePincode" ValidateEmptyText="True" ValidationGroup="MyinfoValidationGroup"
                                                                    Display="Dynamic" ErrorMessage="Choose a more secure PIN number."
                                                                    ToolTip="Your PIN number must be more secure, please choose again.">*</asp:CustomValidator>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            &nbsp;
                                                        </div>
                                                        <asp:ValidationSummary ID="ValidationSummary3" runat="server" ValidationGroup="MyinfoValidationGroup"
                                                            ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                            CssClass="failureNotification" HeaderText="Please fix the following errors:" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <%--  <tr>
                                        <td>
                                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="MyinfoValidationGroup"
                                                ShowSummary="True" DisplayMode="BulletList" EnableClientScript="True" CssClass="failureNotification"
                                                HeaderText="Please fix the following errors:" />
                                        </td>
                                    </tr>--%>
                                    <tr>
                                        <td>
                                            <a href="javascript:;" onclick="radconfirm('Are you sure you want to cancel?', validateCancel, 350, 150, null, '', 'Content/Images/warning.png');">
                                                <img alt="Cancel" src="Content/Images/btn_cancel_small.gif" class="btn-pop-cancel" /></a>

                                            &nbsp;
                                            <asp:ImageButton runat="server" ImageUrl="Content/Images/btn_submit_small.gif" CssClass="btn-pop-next"
                                                OnClientClick="showProcessingImage()" ID="btnNext" OnClick="btnNext_Click" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <%--</ContentTemplate>
                            </asp:UpdatePanel>--%>
                        </ContentTemplate>
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="PopupShowInputInformation" MinWidth="730px"
                        MinHeight="500px">
                        <ContentTemplate>
                            <div>
                                <table class="CareBluePopup">
                                    <tr>
                                        <td>
                                            <h2p>Confirm Profile</h2p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <h3p>Please confirm your update before we save your changes.</h3p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="ExtraPad">
                                            <br /><br />
                                            <table width="100%">
                                                <tr>
                                                    <td width="350" valign="top">
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label12" runat="server" Text="Primary Address:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                &nbsp;
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:Label ID="lblShowPatientName" runat="server"></asp:Label><br />
                                                                <asp:Label ID="lblShowAddress1" runat="server"></asp:Label><br />
                                                                <asp:Label ID="lblShowAddress2" runat="server"></asp:Label><br />
                                                                <asp:Label ID="lblShowPhone" runat="server"></asp:Label>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label16" runat="server" Text="Mailing Address:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:Label ID="lblShowStatements" runat="server"></asp:Label>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label26" runat="server" Text="Email Address:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:Label ID="lblShowEmailAddress" runat="server"></asp:Label>
                                                            </div>
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label13" runat="server" Text="Email Statements:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:Label ID="lblShowEmailMyStatements" runat="server"></asp:Label>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td width="320" valign="top">

                                                        <div class="form-row">
                                                            <div class="editor-label" style="width:200px; text-align: left;">
                                                                <asp:Label ID="Label14" runat="server" Text="Secondary Mailing Address:"></asp:Label>
                                                            </div>
                                                        </div>
                                                        <div class="form-row" id="divPatientInformation" runat="server" visible="False">
                                                            <div class="editor-label">
                                                                &nbsp;
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:Label ID="lblShowSecPatientName" runat="server"></asp:Label><br />
                                                                <asp:Label ID="lblShowSecAddress1" runat="server"></asp:Label><br />
                                                                <asp:Label ID="lblShowSecAddress2" runat="server"></asp:Label><br />
                                                            </div>
                                                        </div>

                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label29" runat="server" Text="Alternate Phone:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:Label ID="lblShowSecPhone" runat="server"></asp:Label><br />
                                                            </div>
                                                        </div>

                                                        <div class="form-row">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label34" runat="server" Text="PIN Code:"></asp:Label>
                                                            </div>
                                                            <div class="editor-field">
                                                                <asp:Label ID="lblShowPincode" runat="server"></asp:Label>
                                                            </div>
                                                        </div>

                                                        <div class="form-row" style="height: 100px">
                                                            &nbsp;
                                                        </div>
                                                        <div class="form-row">
                                                            <div class="editor-field">
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <asp:Label ID="lblEmailMessage" Visible="False" runat="server">We highly encourage you to share an email address where we will send the electronic copies of your statement and payment receipts</asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;&nbsp;
                                            <a href="javascript:;" onclick="radconfirm('Are you sure you want to cancel?', validateCancel, 350, 150, null, '', 'Content/Images/warning.png');">
                                                <img alt="Cancel" src="Content/Images/btn_cancel_small.gif" class="btn-pop-cancel" /></a>
                                            &nbsp;&nbsp;
                                            <a href="#" onclick="ShowInputPopup()">
                                                <img src="Content/Images/btn_goback_small.gif" alt="Go Back" class="btn-pop-cancel" /></a>
                                            &nbsp;&nbsp;
                                            <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="Content/Images/btn_submit_small.gif"
                                                CssClass="btn-pop-submit" OnClientClick="showProcessingImage()" OnClick="btnSubmit_Click" />
                                            &nbsp;&nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </ContentTemplate>
                    </telerik:RadWindow>
                </Windows>
            </telerik:radwindowmanager>
            <telerik:radwindowmanager id="RadWindowDialog" showcontentduringload="True" visiblestatusbar="False"
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
                            <div style="margin-top: 20px; margin-left: 20px;">
                               <a href="Javascript:;"
                                        onclick="$find('{0}').close(true);">
                                        <img src="Content/Images/btn_yes_small.gif" alt="Yes" /></a>  &nbsp; &nbsp; 
                                
                                 <a href="javascript:;" onclick="$find('{0}').close(false);">
                                    <img src="Content/Images/btn_no_small.gif" alt="No" /></a>
                            </div>
                        </div>
                    </div>
                </ConfirmTemplate>
                <AlertTemplate>
                    <div class="rwDialogPopup radalert">
                        <div class="rwDialogText">
                            {1}
                        </div>
                        <div style="margin-top: 20px; margin-left: 51px;">
                            <a href="#" onclick="$find('{0}').close(true);">
                                <img src="Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:radwindowmanager>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">

        var glbIsFromUpdate = false;
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {

            $(function () {
                glbIsFromUpdate = false;
                //                setTimeout('$("#divSuccessMessage").html("");', 3000);
            });
        });

        function ShowInputPopup() {
            $find("<%=PopupShowInputInformation.ClientID%>").close();
             $find("<%=popupInputMyProfile.ClientID%>").show();
         }

         function closePopup() {
             doPostBack();
         }


         function checkEmailStatements() {
             var savedEmail = $("#<%=hdnEmail.ClientID%>").val();
            var enteredEmail = $("#<%=txtEmail.ClientID%>").val();
            var emailStatements = $("#<%=chkEmailMyStatements.ClientID%>");

            var email = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (email.test(enteredEmail) && savedEmail == "") {
                emailStatements.attr("checked", "checked");
            }

            if (email.test(enteredEmail)) {
                emailStatements.removeAttr("disabled");
            } else {
                emailStatements.attr("disabled", "disabled");
                emailStatements.removeAttr("checked");
            }

        }

        function showProcessingImage() {
            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('MyinfoValidationGroup');
            }

            if (isPageValid) {
                blockUI();
            }

        }

        function closeRefresh() {
            location.href = location.href;
        }

        function RadStatusText1() {
            var oWindow = $find("<%=popupInputMyProfile.ClientID%>");
            oWindow.set_status("Custom Text");
        }

        function validatePincode(sender, args) {

            if (isNaN(args.Value.trim())) {
                var pincode = $find("<%=txtPincode.ClientID %>");
                pincode.set_value("");
                args.IsValid = false;
                return;
            }

            if (args.Value.trim().length >= 4 && args.Value.trim().length <= 8) {
                var pincode = parseFloat(args.Value.trim());
                if (pincode < 1900 || pincode > 2020) {
                    var reversePincode = args.Value.trim().split("").reverse().join("");

                    if (reversePincode != args.Value.trim()) {
                        args.IsValid = !validateSequentialNumber(args.Value.trim());
                        return;
                    }

                } else {
                    args.IsValid = false;
                    return;
                }

            }
            args.IsValid = false;
        }


        function validateSequentialNumber(pincode) {
            var values = pincode.split("");
            var isSquentialNumber = false;
            var firstValue = values[0];

            // for 123456.....
            for (var i = 1; i < values.length; i++) {

                firstValue = parseFloat(firstValue) + 1;
                if (firstValue == parseFloat(values[i])) {
                    isSquentialNumber = true;
                } else {
                    isSquentialNumber = false;
                }
            }

            if (isSquentialNumber == true)
                return isSquentialNumber;

            // for 98765......

            firstValue = values[0];
            if (firstValue == "0") {
                firstValue = values[1];
                i = 2;
            } else {
                i = 1;
            }
            for (i; i < values.length; i++) {

                firstValue = parseFloat(firstValue) - 1;
                if (firstValue == parseFloat(values[i])) {
                    isSquentialNumber = true;
                } else {
                    isSquentialNumber = false;
                }
            }

            return isSquentialNumber;
        }

        function validateCancel(isCancel) {
            if (isCancel) {
                closePopup();
            }
        }


        function doPostBack() {
            __doPostBack('', '');
        }

    </script>
</asp:Content>
