<%@ Page Language="C#" AutoEventWireup="true" CodeFile="payplan_popup_add_edit_Obsolete.aspx.cs"
    Inherits="patient_payplan_popup_add_edit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title />
    <script src="Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <script type="text/javascript" language="javascript">
        function CloseAndRebind() {
            alert(0);
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
    </script>
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
    </telerik:RadScriptManager>
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div align="center" style="padding-bottom: 30px">
                <h2>
                    MANAGE PAYMENT PLAN</h2>
                <br />
                for &nbsp;<asp:Label ID="lblStatementFullName" runat="server"></asp:Label><br />
            </div>
            <div class="form-row">
                <div class="editor-label">
                    <asp:Label runat="server" Text="Payment Method:"></asp:Label>
                </div>
                <div class="editor-field">
                    <telerik:RadComboBox ID="cmbPaymentMethods" runat="server" Width="300px" AllowCustomText="False"
                        MarkFirstMatch="True" DataTextField="AccountName" DataValueField="PaymentCardID"
                        MaxHeight="200">
                    </telerik:RadComboBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbPaymentMethods"
                        Display="Dynamic" CssClass="failureNotification" SetFocusOnError="True" ToolTip="Payment method is required."
                        ValidationGroup="PayPlanValidationGroup">*</asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="form-row">
                <div class="editor-label">
                    <asp:Label ID="lblStartDate" runat="server" Text="Start Date:"></asp:Label>
                </div>
                <div class="editor-field">
                    <telerik:RadDatePicker ID="dtStartDate" MinDate="1900/1/1" runat="server">
                    </telerik:RadDatePicker>
                    <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="dtStartDate"
                        Display="Dynamic" CssClass="failureNotification" SetFocusOnError="True" ToolTip="Start Date is required."
                        ValidationGroup="PayPlanValidationGroup">*</asp:RequiredFieldValidator>
                </div>
                <div class="editor-field">
                    <asp:Label ID="lblDateStartMax" runat="server"></asp:Label>
                </div>
            </div>
            <div class="form-row">
                <div class="editor-label">
                    <asp:Label ID="lblInitialPayment" runat="server" Text="Initital Payment:"></asp:Label>
                </div>
                <div class="editor-field">
                    $<telerik:RadNumericTextBox runat="server" ID="txtInitialPayment" Width="120px" MaxLength="30"
                        Type="Number" NumberFormat-DecimalDigits="2" NumberFormat-GroupSeparator=",">
                    </telerik:RadNumericTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtInitialPayment"
                        Display="Dynamic" CssClass="failureNotification" SetFocusOnError="True" ToolTip="Initital Payment is required."
                        ValidationGroup="PayPlanValidationGroup">*</asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="rngInititalPayment" runat="server" ControlToValidate="txtInitialPayment"
                        Display="Dynamic" Type="Double" CssClass="failureNotification" SetFocusOnError="True"
                        ToolTip="Invalid Initial Payment." ValidationGroup="PayPlanValidationGroup">*</asp:RangeValidator>
                </div>
                <div class="editor-field">
                    &nbsp;
                    <asp:Label ID="lblInitialPaymentInterval" runat="server"></asp:Label>
                </div>
            </div>
            <div class="form-row">
                <div class="editor-label">
                    <asp:Label runat="server" Text="Recurring Payment:"></asp:Label>
                </div>
                <div class="editor-field">
                    $<telerik:RadNumericTextBox runat="server" ID="txtRecurringPayment" Width="120px"
                        MaxLength="30" Type="Number" NumberFormat-DecimalDigits="2" NumberFormat-GroupSeparator=",">
                    </telerik:RadNumericTextBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtRecurringPayment"
                        CssClass="failureNotification" SetFocusOnError="True" ToolTip="Recurring Payment is required."
                        Display="Dynamic" ValidationGroup="PayPlanValidationGroup">*</asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="rngRecurringPayment" runat="server" ControlToValidate="txtRecurringPayment"
                        Type="Double" Display="Dynamic" CssClass="failureNotification" SetFocusOnError="True"
                        ToolTip="Invalid Recurring Payment." ValidationGroup="PayPlanValidationGroup">*</asp:RangeValidator>
                </div>
                <div class="editor-field">
                    &nbsp;
                    <asp:Label ID="lblRecurringPaymentInterval" runat="server"></asp:Label>
                </div>
            </div>
            <div class="form-row">
                <div class="editor-label">
                    <asp:Label runat="server" Text="Pay Frequency:"></asp:Label>
                </div>
                <div class="editor-field">
                    <telerik:RadComboBox ID="cmbPayFrequency" runat="server" Width="300px" AllowCustomText="False"
                        MarkFirstMatch="True" DataTextField="Abbr" DataValueField="PaymentFreqTypeID"
                        OnClientSelectedIndexChanged="OnClientSelectedIndexChanged" MaxHeight="200">
                    </telerik:RadComboBox>
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbPayFrequency" CssClass="failureNotification"
                        SetFocusOnError="True" ToolTip="Recurring Payment is required." ValidationGroup="PayPlanValidationGroup">*</asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="form-row">
                This payment plan will end on&nbsp;<asp:Label ID="lblEndDate" runat="server"></asp:Label>&nbsp;after&nbsp;<asp:Label
                    ID="lblNumberofPayments" runat="server"></asp:Label>&nbsp;payments.
                <asp:Literal ID="litDisclaimer" runat="server"></asp:Literal>
            </div>
            <div class="form-row">
                <div class="editor-label">
                    &nbsp;
                </div>
                <div class="editor-field">
                    <asp:CheckBox ID="chkAgreeTerms" runat="server" Text="I agree to the payment terms" />
                    &nbsp;<img src="~/Content/Images/help.png" runat="server" alt="help" onclick="openPaymentTerms()" />
                    <asp:CustomValidator ValidationGroup="PayPlanValidationGroup" ClientValidationFunction="validatePaymentTerms"
                        CssClass="failureNotification" SetFocusOnError="True" runat="server" ToolTip="Please accept the payment terms.">*</asp:CustomValidator>
                </div>
            </div>
            <div class="form-row">
                <div class="editor-label">
                    &nbsp;
                </div>
                <div class="editor-field">
                    <div id="divSubmit">
                        <asp:HiddenField ID="hdnBalance" runat="server" />
                        <asp:HiddenField ID="hdnPayFrequency" runat="server" />
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" ValidationGroup="PayPlanValidationGroup"
                            OnClick="btnSubmit_Click" />
                        <input id="btnCancel" type="button" value="Cancel" onclick="javascript: window.close();" />
                    </div>
                    <div id="divClose" style="display: none; padding-left: 70px">
                        <asp:Button ID="Button1" Text="Close" runat="server" OnClientClick="closeRefresh();return false;" />
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
                <div class="editor-label">
                    &nbsp;
                </div>
                <div class="editor-field">
                    <asp:ValidationSummary runat="server" ValidationGroup="PayPlanValidationGroup" ShowSummary="True"
                        CssClass="failureNotification" HeaderText="Please fix the errors highlighted above." />
                    <div class="success-message" style="text-align: center">
                        <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <telerik:RadWindow runat="server" ID="popupPaymentTerms" VisibleTitlebar="False"
        KeepInScreenBounds="True" VisibleStatusbar="False" Width="500px" Height="600px"
        Modal="true" NavigateUrl="~/paymentterms.aspx">
    </telerik:RadWindow>
    </form>
    <script type="text/javascript" language="javascript">

        $(function () {

            $("#<%=dtStartDate.ClientID %>").change(function () {
                calculateNumberPaymentsEndDate();
            });

            $("#<%=txtInitialPayment.ClientID %>").change(function () {
                calculateNumberPaymentsEndDate();
            });

            $("#<%=txtRecurringPayment.ClientID %>").change(function () {
                calculateNumberPaymentsEndDate();
            });
        });


        function validatePaymentTerms(source, args) {
            args.IsValid = document.getElementById('<%= chkAgreeTerms.ClientID %>').checked;
        }

        function calculateNumberPaymentsEndDate() {
            var paymentFrequency = $("#<%=hdnPayFrequency.ClientID %>").val();
            var jsonText = JSON.stringify({ selectedFreqValue: paymentFrequency });
            var length = location.href.indexOf("?");
            var path = location.href.substring(0, length) + "/ElapsedDays";
            $.ajax({
                type: "POST",
                url: path,
                data: jsonText,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: success
            });
        }

        function success(response) {

            var elapseDays = parseInt(response.d);
            var balance = parseFloat($("#<%=hdnBalance.ClientID %>").val());
            var initialPayment = parseFloat($("#<%=txtInitialPayment.ClientID %>").val().replace(/,/gi, ""));
            var recurringPayment = parseFloat($("#<%=txtRecurringPayment.ClientID %>").val().replace(/,/gi, ""));

            var numberPayments = parseInt(Math.ceil(((balance - initialPayment) / recurringPayment) + 1));
            numberPayments = numberPayments < 1 ? 1 : numberPayments;
            var endDate = new Date($("#<%=dtStartDate.ClientID %>").val());
            endDate.setDate(endDate.getDate() + ((numberPayments - 1) * elapseDays) + 1);
            var dated = endDate.getMonth() + 1 + "/" + endDate.getDate() + "/" + endDate.getFullYear();

            $("#<%=lblNumberofPayments.ClientID %>").html(numberPayments);
            $("#<%=lblEndDate.ClientID %>").html(dated);
        }

        function OnClientSelectedIndexChanged(sender, eventArgs) {
            var item = eventArgs.get_item();
            var value = item.get_value();
            $("#<%=hdnPayFrequency.ClientID %>").val(value);
            calculateNumberPaymentsEndDate();
        }

        //        function GetRadWindow() {
        //            var oWindow = null;
        //            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
        //            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

        //            return oWindow;

        //        }
        function openPaymentTerms() {
            GetRadWindow().BrowserWindow.gotoPaymentTerms();
            //            var location = window.location.protocol + '//' + window.location.host + "/PatientPortal.Public/paymentterms.aspx";
            //            radopen(location, "popupPaymentTerms");
            //            window.open(location);
        }
    </script>
</body>
</html>
