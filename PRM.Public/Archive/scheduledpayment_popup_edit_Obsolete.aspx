<%@ Page Language="C#" AutoEventWireup="true" CodeFile="scheduledpayment_popup_edit_Obsolete.aspx.cs"
    Inherits="scheduledpayment_popup_edit" %>

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

        //        $(document).ready(function () {
        //            $("#divClose").hide();
        //        });

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

        function closeRefresh() {
            GetRadWindow().BrowserWindow.refreshGrid();
            GetRadWindow().close();
        }

        function closePopup() {
            GetRadWindow().close();
        }
        
    </script>
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
    </telerik:RadScriptManager>
    <div align="center" style="padding-bottom: 30px">
        <h2>
            EDIT SCHEDULED PAYMENT</h2>
        for &nbsp;<asp:Label ID="lblStatementFullName" runat="server"></asp:Label>
    </div>
    <div class="form-row">
        <div class="editor-label">
            <asp:Label runat="server">Existing Account:</asp:Label>
        </div>
        <div class="editor-field">
            <telerik:RadComboBox ID="cmbPaymentMethods" runat="server" Width="300px" AllowCustomText="False"
                MarkFirstMatch="True" DataTextField="AccountName" DataValueField="PaymentCardID"
                MaxHeight="200">
            </telerik:RadComboBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbPaymentMethods"
                Display="Dynamic" CssClass="failureNotification" SetFocusOnError="True" ToolTip="Payment method is required."
                ValidationGroup="PaymentValidationGroup">*</asp:RequiredFieldValidator>
        </div>
    </div>
    <div class="form-row">
        <div class="editor-label">
            <asp:Label runat="server" Text="Payment Date:"></asp:Label>
        </div>
        <div class="editor-field">
            <telerik:RadDatePicker ID="dtPaymentDate" MinDate="1900/1/1" runat="server">
            </telerik:RadDatePicker>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="dtPaymentDate" CssClass="failureNotification"
                Display="Dynamic" SetFocusOnError="True" ToolTip="Payment Date is required."
                ValidationGroup="PaymentValidationGroup">*</asp:RequiredFieldValidator>
        </div>
        <div class="editor-field">
            <asp:Label ID="lblPaymentDatetMax" runat="server"></asp:Label>
        </div>
    </div>
    <div class="form-row">
        <div class="editor-label">
            <asp:Label runat="server" Text="Payment:"></asp:Label>
        </div>
        <div class="editor-field">
            $<telerik:RadNumericTextBox runat="server" ID="txtPayment" Width="120px" MaxLength="30"
                Type="Number" NumberFormat-DecimalDigits="2" NumberFormat-GroupSeparator=",">
            </telerik:RadNumericTextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPayment" CssClass="failureNotification"
                Display="Dynamic" SetFocusOnError="True" ToolTip="Payment is required." ValidationGroup="PaymentValidationGroup">*</asp:RequiredFieldValidator>
            <asp:RangeValidator ID="rngPayment" runat="server" ControlToValidate="txtPayment"
                Type="Double" CssClass="failureNotification" Display="Dynamic" SetFocusOnError="True"
                ToolTip="Invalid Payment." ValidationGroup="PaymentValidationGroup">*</asp:RangeValidator>
        </div>
        <div class="editor-field">
            <asp:Label ID="lblPaymentInterval" runat="server"></asp:Label>
        </div>
    </div>
    <div class="form-row">
        <div class="editor-label">
            &nbsp;
        </div>
        <div class="editor-field" style="padding-left: 100px">
            Changes made to individual payments may affect the end date and
            <br />
            number of payments associated with your payment plan. Changes
            <br />
            made here will only affect this payment - to modify your entire
            <br />
            payment plan, please select "Payment Plans" from the menu and
            <br />
            edit your schedule from this screen.
        </div>
    </div>
    <div class="form-row">
        <div class="editor-label">
            &nbsp;
        </div>
        <div class="editor-field">
            <div>
                <asp:CheckBox ID="chkPaymentTerms" runat="server" Text="I agree to payment terms." />&nbsp;<img
                    onclick="openPaymentTerms()" src="~/Content/Images/help.png" runat="server" alt="help" />
                <asp:CustomValidator ValidationGroup="PaymentValidationGroup" ClientValidationFunction="validatePaymentTerms"
                    Display="Dynamic" CssClass="failureNotification" SetFocusOnError="True" runat="server"
                    ToolTip="Please accept the payment terms.">*</asp:CustomValidator>
            </div>
        </div>
    </div>
    <div style="float: left; padding-left: 50px">
        <div class="editor-label">
            &nbsp;
        </div>
        <div id="divSubmit" class="editor-field">
            <asp:Button ID="btnUpdate" Text="Update" runat="server" OnClick="btnUpdate_Click"
                ValidationGroup="PaymentValidationGroup" />&nbsp;<asp:Button ID="btnCancel" Text="Cancel"
                    runat="server" OnClientClick="closePopup();return false;" />
        </div>
        <div id="divClose" style="display: none; padding-left: 35px" class="editor-field">
            <asp:Button Text="Close" runat="server" OnClientClick="closeRefresh();return false;" />
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
            <asp:ValidationSummary runat="server" ValidationGroup="PaymentValidationGroup" ShowSummary="True"
                CssClass="failureNotification" HeaderText="Please fix the errors highlighted above." />
        </div>
        <div id="divSuccessMessage" class="success-message" style="text-align: center">
            <asp:Literal ID="litMessage" Text="" runat="server"></asp:Literal>
        </div>
    </div>
    </form>
    <script type="text/javascript" language="javascript">

        function validatePaymentTerms(source, args) {
            args.IsValid = document.getElementById('<%= chkPaymentTerms.ClientID %>').checked;
        }

        function openPaymentTerms() {
            GetRadWindow().BrowserWindow.gotoPaymentTerms();
        }

    </script>
</body>
</html>
