<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bankaccount_popup_add_edit_Obsolete.aspx.cs"
    Inherits="bankaccount_popup_add_edit" %>

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
            //            GetRadWindow().BrowserWindow.refreshGrid(args);
            //            GetRadWindow().close();
            $("#divClose").show();
            $("#divSubmit").hide();
        }

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }

        function closeRefresh() {
            GetRadWindow().BrowserWindow.refreshGrid();
            GetRadWindow().close();
        }

        function closePopup() {
            GetRadWindow().close();
        }

        function closeMessagePopup() {
            $find("<%=popupMessage.ClientID%>").close();
        }
    </script>
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
    </telerik:RadScriptManager>
    <h2>
        Linked Bank Account Manager
    </h2>
    <div id="divExistingBank" runat="server" class="form-row">
        <div class="editor-label">
            <asp:Label ID="Label1" runat="server">Existing Account:</asp:Label>
        </div>
        <div class="editor-field">
            <telerik:RadComboBox ID="cmbExistingBanks" runat="server" Width="300px" EmptyMessage="Choose Saved Accounts..."
                AllowCustomText="False" MarkFirstMatch="True" DataTextField="AccountName"
                DataValueField="PaymentCardID" AutoPostBack="True" OnSelectedIndexChanged="cmbExistingBanks_SelectedIndexChanged"
                MaxHeight="200">
            </telerik:RadComboBox>
        </div>
    </div>
    <div style="padding-top: 20px">
        <div class="form-row">
            <div class="editor-label">
                <asp:Label runat="server">Last Name:</asp:Label>
            </div>
            <div class="editor-field">
                <asp:TextBox ID="txtLastName" runat="server" MaxLength="30"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLastName" SetFocusOnError="True"
                    Display="Dynamic" CssClass="failureNotification" ToolTip="Last Name is required."
                    ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="form-row">
            <div class="editor-label">
                <asp:Label runat="server">First Name:</asp:Label>
            </div>
            <div class="editor-field">
                <asp:TextBox ID="txtFirstName" runat="server" MaxLength="30"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFirstName" SetFocusOnError="True"
                    Display="Dynamic" CssClass="failureNotification" ToolTip="First Name is required."
                    ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="form-row">
            <div class="editor-label">
                <asp:Label runat="server">Bank Name:</asp:Label>
            </div>
            <div class="editor-field">
                <asp:TextBox ID="txtBankName" runat="server" MaxLength="30"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtBankName" SetFocusOnError="True"
                    CssClass="failureNotification" ToolTip="Bank Name is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="form-row">
            <div class="editor-label">
                <asp:Label runat="server">Branch City:</asp:Label>
            </div>
            <div class="editor-field">
                <asp:TextBox ID="txtBranchCity" runat="server" MaxLength="30"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtBranchCity" SetFocusOnError="True"
                    Display="Dynamic" CssClass="failureNotification" ToolTip="Branch city is required."
                    ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="form-row">
            <div class="editor-label">
                <asp:Label runat="server">Branch State:</asp:Label>
            </div>
            <div class="editor-field">
                <telerik:RadComboBox ID="cmbStates" runat="server" Width="155px" EmptyMessage="Choose State..."
                    AllowCustomText="False" MarkFirstMatch="True" DataTextField="Name" DataValueField="StateTypeID"
                    MaxHeight="200">
                </telerik:RadComboBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbStates" SetFocusOnError="True"
                    Display="Dynamic" CssClass="failureNotification" ToolTip="Branch state is required."
                    ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="form-row">
            <div class="editor-label">
                <asp:Label runat="server">Account Type:</asp:Label>
            </div>
            <div class="editor-field">
                <telerik:RadComboBox ID="cmbAccountType" runat="server" EmptyMessage="Choose Type..."
                    AllowCustomText="False" MarkFirstMatch="True" Width="155px" DataTextField="AccountName"
                    DataValueField="PaymentCardID" MaxHeight="200">
                </telerik:RadComboBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbAccountType" SetFocusOnError="True"
                    Display="Dynamic" CssClass="failureNotification" ToolTip="Account type is required."
                    ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="form-row">
            <div class="editor-label">
                <asp:Label runat="server">Routing Number:</asp:Label>
            </div>
            <div class="editor-field">
                <telerik:RadMaskedTextBox ID="txtRoutingNumber" runat="server" Mask="###-###-###"
                    Width="155" ValidationGroup="CreditCardValidationGroup">
                </telerik:RadMaskedTextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtRoutingNumber" SetFocusOnError="True"
                    Display="Dynamic" CssClass="failureNotification" ToolTip="Routing number is required."
                    ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator Display="Dynamic" runat="server" ControlToValidate="txtRoutingNumber"
                    ToolTip="Invalid Routing Number." SetFocusOnError="True" CssClass="failureNotification"
                    ValidationGroup="BankAccountValidationGroup" ValidationExpression="\d{3}\-\d{3}\-\d{3}">*</asp:RegularExpressionValidator>
            </div>
        </div>
        <div class="form-row">
            <div class="editor-label">
                <asp:Label runat="server">Account Number:</asp:Label>
            </div>
            <div class="editor-field">
                <asp:TextBox ID="txtAccountNumber" runat="server" MaxLength="20"></asp:TextBox>
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAccountNumber" SetFocusOnError="True"
                    Display="Dynamic" CssClass="failureNotification" ToolTip="Account number is required."
                    ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator Display="Dynamic" runat="server" ControlToValidate="txtAccountNumber"
                    ToolTip="Invalid Account Number." SetFocusOnError="True" CssClass="failureNotification"
                    ValidationGroup="BankAccountValidationGroup" ValidationExpression="^.{8,20}$">*</asp:RegularExpressionValidator>
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
        <div class="form-row">
            <div class="editor-label">
                &nbsp;
            </div>
            <div class="editor-field">
                <div id="divSubmit">
                    <input type="button" value="Cancel" onclick="closePopup()" />
                    &nbsp;
                    <asp:Button ID="btnNext" runat="server" Text="Next" OnClick="btnNext_Click" ValidationGroup="BankAccountValidationGroup" />
                    <%--<asp:Button ID="btnSubmit" runat="server" Text="Submit" Visible="False" OnClick="btnSubmit_Click"
                        ValidationGroup="BankAccountValidationGroup" />
                    <asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="False" OnClick="btnUpdate_Click"
                        ValidationGroup="BankAccountValidationGroup" />--%>
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
                <asp:ValidationSummary runat="server" ValidationGroup="BankAccountValidationGroup"
                    ShowSummary="True" CssClass="failureNotification" HeaderText="Please fix the errors highlighted above." />
                <div id="divSuccessMessage" class="success-message" style="text-align: center">
                    <asp:Literal ID="litMessage" Text="" runat="server"></asp:Literal>
                </div>
            </div>
        </div>
    </div>
    <telerik:RadWindowManager ID="RadWindow" ShowContentDuringLoad="false" VisibleStatusbar="false"
        RestrictionZoneID="divMainContent" ReloadOnShow="true" runat="server" Width="700px"
        Height="500px" Modal="true" EnableEmbeddedSkins="False" Skin="Sunset" Style="z-index: 3000">
        <Windows>
            <telerik:RadWindow runat="server" ID="popupShowInputInformation" VisibleTitlebar="False"
                VisibleStatusbar="False" Modal="true" Height="160px">
                <ContentTemplate>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="Label2" runat="server">Last Name:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:Label ID="lblLastName" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="Label3" runat="server">First Name:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:Label ID="lblFirstName" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="Label4" runat="server">Bank Name:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:Label ID="lblBankName" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="Label5" runat="server">Branch City:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:Label ID="lblBranchCity" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="Label6" runat="server">Branch State:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:Label ID="lblBranchState" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="Label7" runat="server">Account Type:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:Label ID="lblAccountType" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="Label8" runat="server">Routing Number:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:Label ID="lblRoutingNumber" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="Label9" runat="server">Account Number:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:Label ID="lblAccountNumber" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Primary Account:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:Label ID="lblPrimaryAccount" runat="server"></asp:Label>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            &nbsp;
                        </div>
                        <div class="editor-field">
                            <input type="button" value="Edit" onclick="" />
                            &nbsp;
                            <input type="button" value="Cancel" onclick="closePopup()" />
                            &nbsp;
                            <asp:Button ID="btnSubmit" runat="server" Text="Submit" Visible="False" OnClick="btnSubmit_Click"
                                ValidationGroup="BankAccountValidationGroup" />
                            <asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="False" OnClick="btnUpdate_Click"
                                ValidationGroup="BankAccountValidationGroup" />
                        </div>
                    </div>
                </ContentTemplate>
            </telerik:RadWindow>
        </Windows>
    </telerik:RadWindowManager>
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
</body>
</html>
