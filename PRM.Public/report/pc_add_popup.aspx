<%@ Page Language="C#" AutoEventWireup="true" CodeFile="pc_add_popup.aspx.cs" Inherits="pc_add_popup" %>

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
                <table class="CareBluePopup" width="100%">
                    <tr>
                        <td colspan="2">
                            <h2p><%=PopupTitle%></h2p>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <h3p><%=PopupDescription %></h3p>
                        </td>
                    </tr>
                </table>
                <div class="ExtraPad"></div>
                <div class="CareBluePopup">
                            <div class="align-popup-fields">
                                <div id="divPaymentMethods" runat="server" visible="False">
                                    <h4p>Select the type of payment method to add:</h4p>
                                    <table>
                                        <tr>
                                                <td></td>
                                            <td>
                                                <asp:RadioButton ID="rdCreditCard" runat="server" GroupName="Account" AutoPostBack="True"
                                                    Text="Credit Card" Checked="True" OnCheckedChanged="rdCreditCard_CheckedChanged" />&nbsp;<asp:RadioButton
                                                        AutoPostBack="True" Text="Checking Account" ID="rdBankAccount" runat="server" GroupName="Account"
                                                        OnCheckedChanged="rdBankAccount_CheckedChanged" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <asp:Panel ID="pnlCreditCard" Visible="False" runat="server">
                                    <div>
                                        <table class="CareBluePopup">
                                            <tr>
                                                <td class="ExtraPad align-editor-labels">
                                                    <div id="divExistingCard" runat="server" class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label19" runat="server">Existing Card:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <telerik:RadComboBox ID="cmbExistingCards" runat="server" Width="300px" EmptyMessage="Choose Saved Accounts..."
                                                                AllowCustomText="False" MarkFirstMatch="True" DataTextField="AccountName" DataValueField="PaymentCardID"
                                                                MaxHeight="200">
                                                            </telerik:RadComboBox>
                                                        </div>
                                                    </div>
                                                    <div style="padding-top: 0px;">
                                                        <table width="100%">
                                                            <tr>
                                                                <td width="50%" valign="top">
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="Label1" Text="First Name:" runat="server"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <asp:TextBox ID="txtCreditCardFirstName" runat="server" MaxLength="30"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtCreditCardFirstName"
                                                                                SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="First Name is required."
                                                                                ErrorMessage="First Name is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="Label20" runat="server" Text="Last Name:"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <asp:TextBox ID="txtCreditCardLastName" runat="server" MaxLength="30"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtCreditCardLastName"
                                                                                SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Last Name is required."
                                                                                ErrorMessage="Last Name is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="lblStreet" runat="server" Text="Street:"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <asp:TextBox ID="txtStreet" runat="server" MaxLength="30"></asp:TextBox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="lblAptSuite" runat="server" Text="Apt/Suite:"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <asp:TextBox ID="txtAptSuite" runat="server" MaxLength="30"></asp:TextBox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="Label21" runat="server" Text="City:"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <asp:TextBox ID="txtCity" runat="server" MaxLength="30"></asp:TextBox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="lblState" runat="server" Text="State:"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <telerik:RadComboBox ID="cmbCreditCardStates" runat="server" Width="155px" EmptyMessage="Choose State..."
                                                                                AllowCustomText="False" MarkFirstMatch="True" DataTextField="Name" DataValueField="StateTypeID"
                                                                                MaxHeight="200">
                                                                            </telerik:RadComboBox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="lblZipCode" runat="server" Text="Zip Code:"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <asp:TextBox ID="txtZipCode" runat="server" CssClass="zip-code1" MaxLength="5"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" ControlToValidate="txtZipCode"
                                                                                SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="ZipCode is required."
                                                                                ErrorMessage="ZipCode is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtZipCode"
                                                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                                                                ToolTip="Invalid Zip Code " ErrorMessage="Invalid Zip Code " ValidationGroup="CreditCardValidationGroup">*</asp:RegularExpressionValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            &nbsp;
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <asp:CheckBox ID="chkCreditPrimarySeconday" runat="server" Text="Make Card Primary" />
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td width="50%" valign="top">
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="Label22" runat="server">Card Type:</asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <telerik:RadComboBox ID="cmbCardType" runat="server" EmptyMessage="Choose Type..."
                                                                                AllowCustomText="False" MarkFirstMatch="True" AutoPostBack="True" Width="155px"
                                                                                DataTextField="Abbr" DataValueField="PaymentCardTypeID" MaxHeight="200" OnSelectedIndexChanged="cmbCardType_OnSelectedIndexChanged">
                                                                            </telerik:RadComboBox>
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ControlToValidate="cmbCardType"
                                                                                SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Card Type is required."
                                                                                ErrorMessage="Card Type is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="Label23" runat="server" Text="Issuing Bank:"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <asp:TextBox ID="txtIssuingBank" runat="server" MaxLength="30"></asp:TextBox>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="Label24" runat="server" Text="Bank Phone:"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <telerik:RadMaskedTextBox ID="txtBankPhone" runat="server" Mask="(###) ###-####"
                                                                                Width="155" ValidationGroup="CreditCardValidationGroup">
                                                                            </telerik:RadMaskedTextBox>
                                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" Display="Dynamic"
                                                                                runat="server" ControlToValidate="txtBankPhone" ToolTip="Invalid Bank Phone."
                                                                                ErrorMessage="Invalid Bank Phone." SetFocusOnError="True" CssClass="failureNotification"
                                                                                ValidationGroup="CreditCardValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="Label25" runat="server" Text="Card Number:"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <telerik:RadMaskedTextBox ID="txtCardNumber" runat="server" Mask="####-####-####-####"
                                                                                ValidationGroup="CreditCardValidationGroup" Width="155">
                                                                            </telerik:RadMaskedTextBox>
                                                                            <telerik:RadTextBox ID="txtShowCardNumber" runat="server" ValidationGroup="CreditCardValidationGroup"
                                                                                Enabled="False" Visible="False" Width="155">
                                                                            </telerik:RadTextBox>
                                                                            <asp:RequiredFieldValidator ID="rqdCardNumber" runat="server" ControlToValidate="txtCardNumber"
                                                                                SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Card Number is required."
                                                                                ErrorMessage="Card Number is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                            <asp:RegularExpressionValidator ID="regexpCardNumber" Display="Dynamic" runat="server"
                                                                                ToolTip="Invalid Card Number" ErrorMessage="Invalid Card Number" CssClass="failureNotification"
                                                                                ControlToValidate="txtCardNumber" SetFocusOnError="True" ValidationGroup="CreditCardValidationGroup"
                                                                                ValidationExpression="\d{4}\-\d{4}\-\d{4}\-\d{4}">*</asp:RegularExpressionValidator>
                                                                            <asp:CustomValidator ID="cstVldCardNumber" ValidationGroup="CreditCardValidationGroup"
                                                                                ClientValidationFunction="validateCardNumber" ToolTip="Invalid Card Number" ErrorMessage="Invalid Card Number"
                                                                                CssClass="failureNotification" SetFocusOnError="True" runat="server">*</asp:CustomValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="Label26" runat="server" Text="Expiration:"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <telerik:RadTextBox ID="txtMonth" runat="server" MaxLength="2" EnableSingleInputRendering="true"
                                                                                EmptyMessage="MM" Width="40px">
                                                                            </telerik:RadTextBox>
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator18" runat="server" ControlToValidate="txtMonth"
                                                                                SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Expiration month is required."
                                                                                ErrorMessage="Expiration month is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                            <asp:RangeValidator ID="RangeValidator1" runat="server" ToolTip="Invalid Expiration Month"
                                                                                Type="Integer" Display="Dynamic" ControlToValidate="txtMonth" SetFocusOnError="True"
                                                                                MinimumValue="1" MaximumValue="12" CssClass="failureNotification" ValidationGroup="CreditCardValidationGroup">*</asp:RangeValidator>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            &nbsp;/
                                                                            <telerik:RadTextBox ID="txtYear" MaxLength="2" runat="server" EnableSingleInputRendering="true" EmptyMessage="YYYY" onchange="validateYear(this);"
                                                                                 Width="60px">
                                                                            </telerik:RadTextBox>
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator" runat="server" ControlToValidate="txtYear"
                                                                                SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Expiration year is required."
                                                                                ErrorMessage="Expiration year is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                            <asp:RangeValidator ID="rngValidatorYear" runat="server" ToolTip="Invalid Expiration Year"
                                                                                ErrorMessage="Invalid Expiration Year" Display="Dynamic" ControlToValidate="txtYear"
                                                                                SetFocusOnError="True" Type="Integer" CssClass="failureNotification" ValidationGroup="CreditCardValidationGroup">*</asp:RangeValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="Label27" runat="server" Text="CVV Security ID:"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <asp:TextBox ID="txtCVVSecurityID" runat="server" MaxLength="4"></asp:TextBox>
                                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtCVVSecurityID"
                                                                                SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="CVV Security ID is required."
                                                                                ErrorMessage="CVV Security ID is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                            <asp:RegularExpressionValidator ID="rglExprrCVVSecurityID" Display="Dynamic" runat="server"
                                                                                ToolTip="Invalid CVV Security ID" ErrorMessage="Invalid CVV Security ID" ControlToValidate="txtCVVSecurityID"
                                                                                CssClass="failureNotification" ValidationGroup="CreditCardValidationGroup">*</asp:RegularExpressionValidator>
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            <asp:Label ID="Label42" runat="server" Text="Card Class:"></asp:Label>
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            <asp:RadioButton ID="rdPersonal" Text="Personal" runat="server" Checked="True" GroupName="CardClass" />&nbsp;<asp:RadioButton
                                                                                ID="rdCorporate" Text="Corporate" runat="server" GroupName="CardClass" />
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-label">
                                                                            &nbsp;
                                                                        </div>
                                                                        <div class="editor-field">
                                                                            &nbsp;
                                                                        </div>
                                                                    </div>
                                                                    <div class="form-row">
                                                                        <div class="editor-field">
                                                                            <asp:ValidationSummary ID="validationSummary" runat="server" ValidationGroup="CreditCardValidationGroup"
                                                                                ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                                                CssClass="failureNotification" HeaderText="Please fix the following errors:" />
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:HiddenField ID="hdnIsDisableProcessingPopup" runat="server" />
                                                    <asp:HiddenField ID="HiddenField1" runat="server" />
                                                    <asp:HiddenField ID="HiddenField2" runat="server" />
                                                    <asp:HiddenField ID="HiddenField3" runat="server" />
                                                    <asp:HiddenField ID="hdnPref" runat="server" />
                                                    <a href="javascript:;" onclick="confirmCancel();">
                                                        <img alt="Cancel" src="../content/Images/btn_cancel.gif" class="btn-pop-cancel" /></a>
                                                    &nbsp;
                                                    <asp:ImageButton ID="btnCreditCardSubmit" runat="server" ImageUrl="../content/Images/btn_submit.gif"
                                                        OnClientClick="return showCreditCardProcessing();" CssClass="btn-pop-submit" Visible="False"
                                                        OnClick="btnCreditCardSubmit_Click" />
                                                    <asp:ImageButton ID="btnCreditCardUpdate" runat="server" ImageUrl="../content/Images/btn_update.gif"
                                                        OnClientClick="return showCreditCardProcessing();" CssClass="btn-pop-submit" Visible="False"
                                                        OnClick="btnCreditCardUpdate_Click" />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </asp:Panel>
                                <asp:Panel ID="pnlBankAccount" runat="server" Visible="False">
                                    <div>
                                        <table class="CareBluePopup">
                                            <tr>
                                                <td class="ExtraPad align-editor-labels">
                                                    <table width="100%" class="align-fields">
                                                        <tr>
                                                            <td colspan="3">
                                                                <div id="divExistingBank" runat="server" class="form-row">
                                                                    <div class="editor-label" style="width: 108px; margin-left: 80px;">
                                                                        <asp:Label ID="Label2" runat="server">Existing Account:</asp:Label>
                                                                    </div>
                                                                    <div class="editor-field">
                                                                        <telerik:RadComboBox ID="cmbExistingBanks" runat="server" Width="300px" EmptyMessage="Choose Saved Accounts..."
                                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="AccountName" DataValueField="PaymentCardID"
                                                                            AutoPostBack="True" OnSelectedIndexChanged="cmbExistingBanks_SelectedIndexChanged"
                                                                            MaxHeight="200">
                                                                        </telerik:RadComboBox>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td with="48%" valign="top">
                                                                <div class="form-row">
                                                                    <div class="editor-label">
                                                                        <asp:Label ID="Label3" runat="server">First Name:</asp:Label>
                                                                    </div>
                                                                    <div class="editor-field">
                                                                        <asp:TextBox ID="txtFirstName" runat="server" MaxLength="30"></asp:TextBox>
                                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtFirstName"
                                                                            SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="First Name is required."
                                                                            ErrorMessage="First Name is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                                                                    </div>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="editor-label">
                                                                        <asp:Label ID="Label10" runat="server">Last Name:</asp:Label>
                                                                    </div>
                                                                    <div class="editor-field">
                                                                        <asp:TextBox ID="txtLastName" runat="server" MaxLength="30"></asp:TextBox>
                                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtLastName"
                                                                            SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Last Name is required."
                                                                            ErrorMessage="Last Name is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                                                                    </div>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="editor-label">
                                                                        <asp:Label ID="Label8" runat="server">Routing Number:</asp:Label>
                                                                    </div>
                                                                    <div class="editor-field">
                                                                        <telerik:RadMaskedTextBox ID="txtRoutingNumber" runat="server" Mask="###-###-###" AutoPostBack="True" OnTextChanged="txtRoutingNumber_OnTextChanged"
                                                                            Width="155" ValidationGroup="CreditCardValidationGroup">
                                                                        </telerik:RadMaskedTextBox>
                                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="txtRoutingNumber"
                                                                            SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Routing number is required."
                                                                            ErrorMessage="Routing number is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                                                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" Display="Dynamic"
                                                                            runat="server" ControlToValidate="txtRoutingNumber" ToolTip="Invalid Routing Number."
                                                                            ErrorMessage="Invalid Routing Number." SetFocusOnError="True" CssClass="failureNotification"
                                                                            ValidationGroup="BankAccountValidationGroup" ValidationExpression="\d{3}\-\d{3}\-\d{3}">*</asp:RegularExpressionValidator>
                                                                    </div>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="editor-label">
                                                                        <asp:Label ID="Label41" runat="server">Account Number:</asp:Label>
                                                                    </div>
                                                                    <div class="editor-field">
                                                                        <asp:TextBox ID="txtAccountNumber" runat="server" MaxLength="20"></asp:TextBox>
                                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txtAccountNumber"
                                                                            SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Account number is required."
                                                                            ErrorMessage="Account number is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                                                                        <asp:RegularExpressionValidator ID="RgrExpnAccountNumber" Display="Dynamic" runat="server"
                                                                            ControlToValidate="txtAccountNumber" ToolTip="Invalid Account Number." ErrorMessage="Invalid Account Number."
                                                                            SetFocusOnError="True" CssClass="failureNotification" ValidationGroup="BankAccountValidationGroup"
                                                                            ValidationExpression="^.{8,20}$">*</asp:RegularExpressionValidator>
                                                                    </div>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="editor-label">
                                                                        &nbsp;
                                                                    </div>
                                                                    <div class="editor-field">
                                                                        <asp:CheckBox ID="chkBankPrimarySeconday" runat="server" Text="Make Account Primary" />
                                                                    </div>
                                                                </div>
                                                            </td>
                                                                <td width="4%"></td>
                                                            <td width="48%" valign="top">
                                                                <div class="form-row">
                                                                    <div class="editor-label">
                                                                        <asp:Label ID="Label4" runat="server">Bank Name:</asp:Label>
                                                                    </div>
                                                                    <div class="editor-field">
                                                                            <asp:TextBox ID="txtBankName" runat="server" MaxLength="30"></asp:TextBox>
                                                                       </div>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="editor-label">
                                                                        <asp:Label ID="Label5" runat="server">Branch City:</asp:Label>
                                                                    </div>
                                                                    <div class="editor-field">
                                                                            <asp:TextBox ID="txtBranchCity" runat="server" MaxLength="30"></asp:TextBox>
                                                                    </div>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="editor-label">
                                                                        <asp:Label ID="Label6" runat="server">Branch State:</asp:Label>
                                                                    </div>
                                                                    <div class="editor-field">
                                                                            <telerik:RadComboBox ID="cmbStates" runat="server" Width="155px" EmptyMessage="Choose State..."
                                                                                AllowCustomText="False" MarkFirstMatch="True" DataTextField="Name" DataValueField="StateTypeID"
                                                                                MaxHeight="200">
                                                                            </telerik:RadComboBox>
                                                                    </div>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="editor-label">
                                                                        <asp:Label ID="Label7" runat="server">Account Type:</asp:Label>
                                                                    </div>
                                                                    <div class="editor-field">
                                                                        <telerik:RadComboBox ID="cmbAccountType" runat="server" EmptyMessage="Choose Type..."
                                                                            AllowCustomText="False" MarkFirstMatch="True" Width="155px" DataTextField="AccountName"
                                                                            DataValueField="PaymentCardID" MaxHeight="200">
                                                                        </telerik:RadComboBox>
                                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="cmbAccountType"
                                                                            SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Account type is required."
                                                                            ErrorMessage="Account type is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                                                                    </div>
                                                                </div>
                                                                <div class="form-row">
                                                                    <div class="editor-field">
                                                                        <asp:ValidationSummary ID="ValidationSummary3" runat="server" ValidationGroup="BankAccountValidationGroup"
                                                                            ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                                            CssClass="failureNotification" HeaderText="Please fix the following errors:" />
                                                                        <div id="divSuccessMessage" class="success-message" style="text-align: center">
                                                                            <asp:Literal ID="litMessage" Text="" runat="server"></asp:Literal>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:HiddenField ID="hdnBankPNRef" runat="server" />
                                                    <div id="divSubmit">
                                                        <a href="javascript:;" onclick="confirmCancel();">
                                                            <img src="../content/Images/btn_cancel.gif" class="btn-pop-cancel" alt="Cancel" /></a>
                                                        &nbsp;
                                                        <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="../content/Images/btn_submit.gif"
                                                            OnClientClick="return showBankAccountProcessing()" CssClass="btn-pop-submit"
                                                            Visible="False" OnClick="btnSubmit_Click" ValidationGroup="BankAccountValidationGroup" />
                                                        <asp:ImageButton ID="btnUpdate" runat="server" ImageUrl="../content/Images/btn_update.gif"
                                                          OnClientClick="return showBankAccountProcessing()"   CssClass="btn-pop-submit" 
                                                            Visible="False" OnClick="btnUpdate_Click" ValidationGroup="BankAccountValidationGroup" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </asp:Panel>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:HiddenField ID="hdnStatementBalance" runat="server" />
                            <asp:HiddenField ID="hdnCardType" runat="server" />
                            <asp:HiddenField ID="hdnIsSuccess" runat="server" />
                            <asp:HiddenField ID="hdnMessage" runat="server" />
                            <asp:HiddenField ID="hdnIsFailure" runat="server" />
                        </td>
                    </tr>
                </table>
            </div>
            <asp:HiddenField ID="hdnIsRebind" runat="server" />
            <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                restrictionzoneid="divMainContent" skin="CareBlueInf" style="z-index: 3000">
                <ConfirmTemplate>
                    <div class="rwDialogPopup radconfirm">
                        <h5>
                            <div class="rwDialogText">
                                {1}
                            </div>
                        </h5>
                        <div>
                            <div style="margin-top: 15px; margin-left: 50px;">
                                <a href="Javascript:;"
                                            onclick="$find('{0}').close(true);">
                                            <img src="../Content/Images/btn_yes_small.gif" alt="Yes" /></a>  &nbsp; &nbsp; 
                                <a href="#" onclick="$find('{0}').close(false);">
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
                            <a href="javascript:;" onclick="$find('{0}').close(true);">
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
            GetRadWindow().BrowserWindow.unBlockUI();
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
            var isReload = $("#<%=hdnIsRebind.ClientID %>").val();
            if (isReload == "1") {
                GetRadWindow().BrowserWindow.genericFunction();
            } else {
                GetRadWindow().BrowserWindow.refreshPage();
            }
            closePopup();
        }

        function showBankAccountProcessing() {
            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('BankAccountValidationGroup');
            }

            if (isPageValid) {
                GetRadWindow().BrowserWindow.blockUI();
            }

        }

        function showCreditCardProcessing() {
            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('CreditCardValidationGroup');
            }

            if (isPageValid) {
                GetRadWindow().BrowserWindow.blockUI();
            }
        }

        function validateCardNumber(source, args) {
            var creditCardNumber = $('#<%=txtCardNumber.ClientID %>').val();
            var result = checkCC(creditCardNumber);
            if (result == -1) {
                args.IsValid = false;
            } else {
                $('#<%=hdnCardType.ClientID%>').val(result);
                args.IsValid = true;
            }
        }

        function validateCancel(isCancel) {
            if (isCancel) {
                closePopup();
            }
        }


        /**
        * checks a given string for a valid credit card
        * @returns:
        *   -1   invalid
        *        1        mastercard
        *        2        visa
        *        3        amex
        *        4        diners club
        *        5        discover
        *        6        enRoute
        *        7        jcb
        */
        function checkCC(val) {

            String.prototype.startsWith = function (str) {
                return (this.match("^" + str) == str);
            }

            Array.prototype.has = function (v, i) {
                for (var j = 0; j < this.length; j++) {
                    if (this[j] == v) return (!i ? true : j);
                }
                return false;
            }

            // get rid of all non-numbers (space etc)
            val = val.replace(/[^0-9]/g, "");

            // now get digits
            var d = new Array();
            var a = 0;
            var len = 0;
            var cval = val;
            while (cval != 0) {
                d[a] = cval % 10;
                cval -= d[a];
                cval /= 10;
                a++;
                len++;
            }

            if (len < 13)
                return -1;

            var cType = -1;

            // mastercard
            if (val.startsWith("5")) {
                if (len != 16)
                    return -1;
                cType = 1;
            } else
            // visa
                if (val.startsWith("4")) {
                    if (len != 16 && len != 13)
                        return -1;
                    cType = 2;
                } else
                // amex
                    if (val.startsWith("34") || val.startsWith("37")) {
                        if (len != 15)
                            return -1;
                        cType = 3;
                    } else
                    // diners
                        if (val.startsWith("36") || val.startsWith("38") || val.startsWith("300") || val.startsWith("301") || val.startsWith("302") || val.startsWith("303") || val.startsWith("304") || val.startsWith("305")) {
                            if (len != 14)
                                return -1;
                            cType = 4;
                        } else
                        // discover
                            if (val.startsWith("6011")) {
                                if (len != 15 && len != 16)
                                    return -1;
                                cType = 5;
                            } else
                            // enRoute
                                if (val.startsWith("2014") || val.startsWith("2149")) {
                                    if (len != 15 && len != 16)
                                        return -1;
                                    // any digit check
                                    return 6;
                                } else
                                // jcb
                                    if (val.startsWith("3")) {
                                        if (len != 16)
                                            return -1;
                                        cType = 7;
                                    } else
                                    // jcb
                                        if (val.startsWith("2131") || val.startsWith("1800")) {

                                            if (len != 15)
                                                return -1;
                                            cType = 7;
                                        } else
                                            return -1;
            // invalid cc company

            // lets do some calculation
            var sum = 0;
            var i;
            for (i = 1; i < len; i += 2) {
                var s = d[i] * 2;
                sum += s % 10;
                sum += (s - s % 10) / 10;
            }

            for (i = 0; i < len; i += 2)
                sum += d[i];

            // musst be %10
            if (sum % 10 != 0)
                return -1;

            return cType;
        }


        function validateYear(obj) {
            var value = $(obj).val();
            if (value.length == 2) {
                var year = (new Date).getFullYear();
                var yearStartWith = year.toString().substr(0, 2);
                $(obj).val(yearStartWith + "" + value);
            }
        }

        function confirmCancel() {
            radconfirm('Are you sure you want to cancel? <br>Any changes you made will be lost.', validateCancel, 400, 100, null, '', '../content/Images/warning.png');
        }


    </script>
    <script type="text/javascript">
        window.alert = function (string) {
            var reg = new RegExp("\\-", "g");
            var messages = string.replace(reg, "<br />").replace("Please fix the following errors:", "Please fix the following errors:<br />");
            var radWindow = $find("<%=RadWindow.ClientID %>");
            radWindow.radalert(messages, 400, 100, '', "", '../content/Images/warning.png');
        }

    </script>
    </form>
</body>
</html>
