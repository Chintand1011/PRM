<%@ Page Language="C#" AutoEventWireup="true" CodeFile="creditcardaccount_popup_add_edit__Obsolete.aspx.cs"
    Inherits="creditcardaccount_popup_add_edit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title />
    <script src="Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <script type="text/javascript" language="javascript">

        function CloseAndRebind() {
            $("#divClose").show();
            $("#divSubmit").hide();
        }

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }

        function closePopup() {
            GetRadWindow().close();
        }

        function closeRefresh() {
            GetRadWindow().BrowserWindow.refreshGrid();
            GetRadWindow().close();
        }
    </script>
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
    </telerik:RadScriptManager>
    <h2>
        Linked Credit Card Manager
    </h2>
    <div id="divExistingCard" runat="server" class="form-row">
        <div class="editor-label">
            <asp:Label ID="Label1" runat="server">Existing Card:</asp:Label>
        </div>
        <div class="editor-field">
            <telerik:RadComboBox ID="cmbExistingCards" runat="server" Width="300px" EmptyMessage="Choose Saved Accounts..."
                AllowCustomText="False" MarkFirstMatch="True" DataTextField="AccountName"
                DataValueField="PaymentCardID" AutoPostBack="True" OnSelectedIndexChanged="cmbExistingCards_SelectedIndexChanged"
                MaxHeight="200">
            </telerik:RadComboBox>
        </div>
    </div>
    <div style="padding-top: 20px">
        <table width="100%">
            <tr>
                <td width="48%" valign="top">
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="lblLastName" runat="server" Text="Last Name:"></asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtLastName" runat="server" MaxLength="30"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLastName" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="Last Name is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="lblFirstName" Text="First Name:" runat="server"></asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtFirstName" runat="server" MaxLength="30"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFirstName" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="First Name is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="lblStreet" runat="server" Text="Street:"></asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtStreet" runat="server" MaxLength="30"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtStreet" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="Street is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="lblAptSuite" runat="server" Text="Apt/Suite:"></asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtAptSuite" runat="server" MaxLength="30"></asp:TextBox>
                            <%--<asp:RequiredFieldValidator runat="server" ControlToValidate="txtAptSuite" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="Apt/Suite is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>--%>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="lblCity" runat="server" Text="City:"></asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtCity" runat="server" MaxLength="30"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCity" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="City is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="lblState" runat="server" Text="State:"></asp:Label>
                        </div>
                        <div class="editor-field">
                            <telerik:RadComboBox ID="cmbStates" runat="server" Width="155px" EmptyMessage="Choose State..."
                                AllowCustomText="False" MarkFirstMatch="True" DataTextField="Name" DataValueField="StateTypeID"
                                MaxHeight="200">
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbStates" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="State is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="lblZipCode" runat="server" Text="Zip Code:"></asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtZipCode" runat="server" CssClass="zip-code1" MaxLength="5"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtZipCode" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="ZipCode is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtZipCode" Display="Dynamic"
                                SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                ToolTip="Invalid Zip Code " ValidationGroup="CreditCardValidationGroup">*</asp:RegularExpressionValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            &nbsp;
                        </div>
                        <div class="editor-field">
                            <asp:CheckBox ID="chkPrimarySeconday" runat="server" Text="Make Primary" />
                        </div>
                    </div>
                </td>
                <td width="4%">
                    &nbsp;
                </td>
                <td width="48%" valign="top">
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Card Type:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <telerik:RadComboBox ID="cmbCardType" runat="server" EmptyMessage="Choose Type..."
                                AllowCustomText="False" MarkFirstMatch="True" AutoPostBack="True" Width="155px"
                                DataTextField="Abbr" DataValueField="PaymentCardTypeID" MaxHeight="200" OnSelectedIndexChanged="cmbCardType_OnSelectedIndexChanged">
                            </telerik:RadComboBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbCardType" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="Card Type is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server" Text="Issuing Bank:"></asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtIssuingBank" runat="server" MaxLength="30"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtIssuingBank" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="Issuing Bank is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server" Text="Bank Phone:"></asp:Label>
                        </div>
                        <div class="editor-field">
                            <telerik:RadMaskedTextBox ID="txtBankPhone" runat="server" Mask="(###) ###-####"
                                Width="155" ValidationGroup="CreditCardValidationGroup">
                            </telerik:RadMaskedTextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtBankPhone" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="Bank Phone is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator Display="Dynamic" runat="server" ControlToValidate="txtBankPhone"
                                ToolTip="Invalid Bank Phone." SetFocusOnError="True" CssClass="failureNotification"
                                ValidationGroup="CreditCardValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server" Text="Card Number:"></asp:Label>
                        </div>
                        <div class="editor-field">
                            <telerik:RadMaskedTextBox ID="txtCardNumber" runat="server" Mask="####-####-####-####"
                                ValidationGroup="CreditCardValidationGroup" Width="155">
                            </telerik:RadMaskedTextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCardNumber" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="Card Number is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="regexpCardNumber" Display="Dynamic" runat="server"
                                ToolTip="Invalid Card Number" CssClass="failureNotification" ControlToValidate="txtCardNumber"
                                SetFocusOnError="True" ValidationGroup="CreditCardValidationGroup" ValidationExpression="\d{4}\-\d{4}\-\d{4}\-\d{4}">*</asp:RegularExpressionValidator>
                            <asp:CustomValidator ValidationGroup="CreditCardValidationGroup" ClientValidationFunction="validateCardNumber"
                                ToolTip="Invalid Card Number" CssClass="failureNotification" SetFocusOnError="True"
                                runat="server">*</asp:CustomValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server" Text="Expiration:"></asp:Label>
                        </div>
                        <div class="editor-field">
                            <telerik:RadTextBox ID="txtMonth" runat="server" MaxLength="2" EnableSingleInputRendering="true"
                                EmptyMessage="MM" Width="40px">
                            </telerik:RadTextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtMonth" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="Expiration month is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                            <asp:RangeValidator runat="server" ToolTip="Invalid Expiration Month" Type="Integer"
                                Display="Dynamic" ControlToValidate="txtMonth" SetFocusOnError="True" MinimumValue="1"
                                MaximumValue="12" CssClass="failureNotification" ValidationGroup="CreditCardValidationGroup">*</asp:RangeValidator>
                        </div>
                        <div class="editor-field">
                            &nbsp;/
                            <telerik:RadTextBox ID="txtYear" MaxLength="4" runat="server" EnableSingleInputRendering="true"
                                EmptyMessage="YYYY" Width="60px">
                            </telerik:RadTextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtYear" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="Expiration year is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="rngValidatorYear" runat="server" ToolTip="Invalid Expiration Year"
                                Display="Dynamic" ControlToValidate="txtYear" SetFocusOnError="True" Type="Integer"
                                CssClass="failureNotification" ValidationGroup="CreditCardValidationGroup">*</asp:RangeValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server" Text="CVV Security ID:"></asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtCVVSecurityID" runat="server" MaxLength="4"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCVVSecurityID" SetFocusOnError="True"
                                Display="Dynamic" CssClass="failureNotification" ToolTip="CVV Security ID is required."
                                ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator Display="Dynamic" runat="server" ToolTip="Invalid CVV Security ID"
                                ControlToValidate="txtCVVSecurityID" CssClass="failureNotification" ValidationGroup="CreditCardValidationGroup"
                                ValidationExpression="^[0-9]{3,4}$">*</asp:RegularExpressionValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server" Text="Card Class:"></asp:Label>
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
                            <div id="divSubmit">
                                <%--<asp:HiddenField ID="hdnCardType" runat="server" />--%>
                                <asp:Button runat="server" Text="Cancel" PostBackUrl="~/bankinfo.aspx" OnClientClick="javascript:window.close();" />&nbsp;
                                <asp:Button ID="btnSubmit" runat="server" Text="Submit" Visible="False" ValidationGroup="CreditCardValidationGroup"
                                    OnClick="btnSubmit_Click" />
                                <asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="False" OnClick="btnUpdate_Click"
                                    ValidationGroup="CreditCardValidationGroup" />
                            </div>
                            <div id="divClose" style="display: none; padding-left: 70px">
                                <asp:Button Text="Close" runat="server" OnClientClick="closeRefresh();return false;" />
                            </div>
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
                            <asp:ValidationSummary runat="server" ValidationGroup="CreditCardValidationGroup"
                                ShowSummary="True" CssClass="failureNotification" HeaderText="Please fix the errors highlighted above." />
                            <div id="divSuccessMessage" class="success-message" style="text-align: center">
                                <asp:Literal ID="litMessage" Text="" runat="server"></asp:Literal>
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <telerik:RadWindow runat="server" ID="popupMessage" VisibleTitlebar="False" VisibleStatusbar="False"
        Modal="true" Height="160px">
        <ContentTemplate>
            <div id="divMessage" align="center">
                <br />
                <p>
                    <asp:Label ID="lblPopupMessage" runat="server"></asp:Label>
                    <br />
                    <br />
                    <input type="button" onclick="closeMessagePopup(this)" value="OK" />
                </p>
            </div>
        </ContentTemplate>
    </telerik:RadWindow>
    </form>
    <script type="text/javascript" language="javascript">

        function validateCardNumber(source, args) {
            var creditCardNumber = $('#<%=txtCardNumber.ClientID %>').val();
            var result = checkCC(creditCardNumber);

            if ($find('<%=cmbCardType.ClientID %>').get_selectedItem() != null) {
                var cardType = $find('<%=cmbCardType.ClientID %>').get_selectedItem().get_value();

                if (cardType != result) {
                    args.IsValid = false;
                } else {
                    args.IsValid = true;
                }
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

        function closeMessagePopup() {
            $find("<%=popupMessage.ClientID%>").close();
        }
    </script>
</body>
</html>
