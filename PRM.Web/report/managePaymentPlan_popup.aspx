<%@ Page Language="C#" AutoEventWireup="true" CodeFile="managePaymentPlan_popup.aspx.cs"
    Inherits="managePaymentPlan_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        </telerik:RadScriptManager>
        <asp:UpdatePanel ID="updPanelEligility" runat="server">
            <ContentTemplate>
                <div>
                    <table class="CareBluePopup">
                        <tr>
                            <td>
                                <h2p>Manage Payment Plan</h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p><asp:Label ID="lblStatementFullName" runat="server"></asp:Label></h4p>
                                <br />
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label10" runat="server" Text="Patient Balance:"></asp:Label>
                                    </div>
                                    <div class="editor-field" style="font-size: 1.1em; color: #000000;">
                                        <b>
                                            <asp:Label ID="lblOutstandingBalance" runat="server" Text=""></asp:Label></b>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="lblStartDate" runat="server" Text="Start Date:"></asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadDatePicker ID="dtStartDate" EnableTyping="False" OnSelectedDateChanged="dtStartDate_OnChanged"
                                            AutoPostBack="True" runat="server" Width="126px">
                                        </telerik:RadDatePicker>
                                        <asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="dtStartDate"
                                            Display="Dynamic" CssClass="failureNotification" SetFocusOnError="True" ToolTip="Start Date is required."
                                            ErrorMessage="Start Date is required." ValidationGroup="PayPlanValidationGroup">*</asp:RequiredFieldValidator>
                                    </div>
                                    <div class="editor-field">
                                        <asp:Label ID="lblDateStartMax" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="divInitialPayment" runat="server" Text="Initital Payment:"></asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadNumericTextBox runat="server" ID="txtInitialPayment" Width="100px" MaxLength="30"
                                            AllowOutOfRangeAutoCorrect="False" Type="Currency" NumberFormat-DecimalDigits="2"
                                            AutoPostBack="True" OnTextChanged="txtInitialPayment_OnTextChanged" NumberFormat-GroupSeparator=",">
                                        </telerik:RadNumericTextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtInitialPayment"
                                            Display="Dynamic" CssClass="failureNotification" SetFocusOnError="True" ToolTip="Initital Payment is required."
                                            ErrorMessage="Initital Payment is required." ValidationGroup="PayPlanValidationGroup">*</asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="rngInititalPayment" runat="server" ControlToValidate="txtInitialPayment"
                                            Display="Dynamic" Type="Double" CssClass="failureNotification" SetFocusOnError="True"
                                            ToolTip="Invalid Initial Payment." ErrorMessage="Invalid Initial Payment." ValidationGroup="PayPlanValidationGroup">*</asp:RangeValidator>
                                    </div>
                                    <div class="editor-field">
                                        &nbsp;
                                    <asp:Label ID="lblInitialPaymentInterval" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label3" runat="server" Text="Recurring Payment:"></asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadNumericTextBox runat="server" ID="txtRecurringPayment" Width="100px"
                                            MaxLength="30" Type="Currency" NumberFormat-DecimalDigits="2" AutoPostBack="True"
                                            OnTextChanged="txtRecurringPayment_OnTextChanged" NumberFormat-GroupSeparator=","
                                            AllowOutOfRangeAutoCorrect="False">
                                        </telerik:RadNumericTextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtRecurringPayment"
                                            CssClass="failureNotification" SetFocusOnError="True" ToolTip="Recurring Payment is required."
                                            ErrorMessage="Recurring Payment is required." Display="Dynamic" ValidationGroup="PayPlanValidationGroup">*</asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="rngRecurringPayment" runat="server" ControlToValidate="txtRecurringPayment"
                                            Type="Double" Display="Dynamic" CssClass="failureNotification" SetFocusOnError="True"
                                            ToolTip="Invalid Recurring Payment." ErrorMessage="Invalid Recurring Payment."
                                            ValidationGroup="PayPlanValidationGroup">*</asp:RangeValidator>
                                    </div>
                                    <div class="editor-field">
                                        &nbsp;
                                    <asp:Label ID="lblRecurringPaymentInterval" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label1" runat="server" Text="Payment Method:"></asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbPaymentMethods" runat="server" Width="180px" AllowCustomText="False"
                                            MarkFirstMatch="True" DataTextField="AccountName" DataValueField="PaymentCardID"
                                            MaxHeight="200">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="cmbPaymentMethods"
                                            Display="Dynamic" CssClass="failureNotification" SetFocusOnError="True" ToolTip="Payment method is required."
                                            ErrorMessage="Payment method is required." ValidationGroup="PayPlanValidationGroup">*</asp:RequiredFieldValidator>

                                        &nbsp; &nbsp;
                                        <asp:ImageButton ID="btnAddPaymentCard" ImageUrl="../Content/Images/icon_add.png" OnClick="btnAddPaymentCard_OnClick" runat="server" />
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label4" runat="server" Text="Pay Frequency:"></asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbPayFrequency" runat="server" Width="100px" AllowCustomText="False"
                                            MarkFirstMatch="True" DataTextField="Abbr" DataValueField="PaymentFreqTypeID"
                                            OnClientSelectedIndexChanged="OnClientSelectedIndexChanged" MaxHeight="200">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="cmbPayFrequency"
                                            CssClass="failureNotification" SetFocusOnError="True" ToolTip="Recurring Payment is required."
                                            ErrorMessage="Recurring Payment is required." ValidationGroup="PayPlanValidationGroup">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="boxInputL" style="margin: 10px 0px 0px 50px;">
                                    <b>This payment plan will end on&nbsp;<asp:Label ID="lblEndDate" runat="server"></asp:Label>&nbsp;after&nbsp;<asp:Label
                                        ID="lblNumberofPayments" runat="server"></asp:Label>&nbsp;payments.</b>
                                    <p>
                                        <asp:Literal ID="litDisclaimer" runat="server"></asp:Literal>
                                </div>
                                <div class="boxInputL" style="margin: 0px 0px -10px 50px;">
                                    <img id="Img1" src="~/Content/Images/help.png" height="14" width="14" runat="server" alt="help" onclick="gotoPayPlan()" />
                                    <asp:CheckBox ID="chkAgreeTerms" runat="server" Text=" I agree to the payment terms." Style="line-height: 0.1em;" />
                                    <asp:CustomValidator ID="CustomValidator1" ValidationGroup="PayPlanValidationGroup"
                                        ClientValidationFunction="validatePaymentTerms" CssClass="failureNotification"
                                        SetFocusOnError="True" runat="server" ToolTip="Please accept the payment terms."
                                        ErrorMessage="Please accept the payment terms.">*</asp:CustomValidator>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        &nbsp;
                                    </div>
                                    <div class="editor-field">
                                        <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="PayPlanValidationGroup"
                                            ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                            CssClass="failureNotification" HeaderText="Please fix the following before submission:<br>" />
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:HiddenField ID="hdnBalance" runat="server" />
                                <asp:HiddenField ID="hdnPayPlanMaxTerm" runat="server" />
                                <asp:HiddenField ID="hdnPayPlanMinAmt" runat="server" />
                                <asp:HiddenField ID="hdnStatementBalance" runat="server" />
                                <asp:HiddenField ID="hdnPayFrequency" runat="server" />
                                <asp:HiddenField ID="hdnPayPlanFee" runat="server" />
                                <asp:HiddenField ID="hdnIsDeletePaymentPlan" runat="server" />
                                <asp:HiddenField ID="hdnValues" runat="server" />
                                <asp:HiddenField ID="hdnShowAddPaymentCardPopup" runat="server" />
                                <a href="javascript:;" onclick="closePopup()">
                                    <img src="../Content/Images/btn_cancel.gif" alt="Cancel" class="btn-pop-cancel" /></a>
                                <a href="javascript:;" onclick="ConfirmDelete()" id="btnDeletePaymentPlan" runat="server" visible="False">
                                    <img src="../content/Images/btn_cancel_payplan.gif" alt="Delete" class="btn-pop-cancel" /></a>
                                <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="../Content/Images/btn_submit.gif"
                                    CssClass="btn-pop-submit" OnClientClick="return enableDisableButton(this);" OnClick="btnSubmit_Click" />
                            </td>
                        </tr>
                    </table>
                </div>
                <telerik:RadWindowManager ID="RadWindow" ShowContentDuringLoad="True" VisibleStatusbar="False"
                    VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="1150px" Height="850px"
                    Modal="True" EnableShadow="False" EnableEmbeddedBaseStylesheet="False" EnableEmbeddedSkins="False"
                    Skin="CareBlueInf">
                    <ConfirmTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div>
                                <div style="margin-top: 20px; margin-left: 30px;">
                                    <a href="#" onclick="$find('{0}').close(true);">
                                            <img src="../content/Images/btn_yes_small.gif" alt="Ok" /></a> &nbsp; &nbsp; &nbsp;
                                    &nbsp; <a href="#" onclick="$find('{0}').close(false);">
                                        <img src="../content/Images/btn_goback_small.gif" alt="Cancel" /></a>
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
                </telerik:RadWindowManager>
                <asp:Button ID="btnConfirmedDeletePaymentPlan" Style="display: none;" OnClick="btnSubmit_Click"
                    runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
        <script type="text/javascript" language="javascript">

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {

                $(function () {

                    $("#<%=dtStartDate.ClientID %>").change(function () {
                        CalculateFields();
                    });

                    $("#<%=txtInitialPayment.ClientID %>").change(function () {
                        CalculateFields();
                    });

                    $("#<%=txtRecurringPayment.ClientID %>").change(function () {
                        CalculateFields();
                    });

                    if ($("#<%= hdnShowAddPaymentCardPopup.ClientID%>").val() == "1") {
                        showAddPaymentPopup();
                        $("#<%= hdnShowAddPaymentCardPopup.ClientID%>").val(0);
                    }

                });
            });

            $(function () {

                $("#<%=dtStartDate.ClientID %>").change(function () {
                    CalculateFields();
                });

                $("#<%=txtInitialPayment.ClientID %>").change(function () {
                    CalculateFields();
                });

                $("#<%=txtRecurringPayment.ClientID %>").change(function () {
                    CalculateFields();
                });
            });

            function validatePaymentTerms(source, args) {
                args.IsValid = document.getElementById('<%= chkAgreeTerms.ClientID %>').checked;
            }

            function CalculateFields() {
                //            var initialPayment = $find("<%= txtInitialPayment.ClientID %>");
            //            var balance = parseFloat($("#<%=hdnBalance.ClientID %>").val());
            //            var recurringPayment = $find("<%= txtRecurringPayment.ClientID %>");

            //            var PayPlanMinAmt = parseFloat($("#<%=hdnPayPlanMinAmt.ClientID %>").val());
            //            var PayPlanMaxTerm = parseFloat($("#<%=hdnPayPlanMaxTerm.ClientID %>").val());
            //            var PayPlanFee = parseFloat($("#<%=hdnPayPlanFee.ClientID %>").val());

            //            var MinPayment = Math.min(Math.max(PayPlanMinAmt, Math.ceil((balance - parseFloat(initialPayment.get_value())) / (PayPlanMaxTerm - 1) * 100) / 100 + PayPlanFee), balance - parseFloat(initialPayment.get_value()) + PayPlanFee);

            //            var MaxPayment = balance - parseFloat(initialPayment.get_value()) + PayPlanFee;

            //            var numberPayments = parseInt(Math.ceil(((balance - parseFloat(initialPayment.get_value())) / parseFloat(recurringPayment.get_value())) + 1)); //Calculate NumberPayments once
            //            numberPayments = parseInt(Math.ceil(((balance - parseFloat(initialPayment.get_value()) + PayPlanFee * numberPayments) / parseFloat(recurringPayment.get_value())) + 1)); //Then Confirm that it doesn't change, once you factor in fee.
            //            numberPayments = numberPayments < 1 ? 1 : numberPayments;

            //            var endDate = new Date($("#<%=dtStartDate.ClientID %>").val());
            //            endDate.setDate(endDate.getDate() + numberPayments);
            //            var dated = endDate.getMonth() + 1 + "/" + endDate.getDate() + "/" + endDate.getFullYear();
            //            if (recurringPayment.get_value() > MaxPayment) { recurringPayment.set_value(MaxPayment); }
            //            if (recurringPayment.get_value() < MinPayment) { recurringPayment.set_value(MinPayment); }


            //            $("#<%=lblNumberofPayments.ClientID %>").html(numberPayments);
            //            $("#<%=lblEndDate.ClientID %>").html(dated);

            //not working. needs to be fixed.
            //            var lblRecurringPayments = document.getElementById("lblminPayments");
            //            lblRecurringPayments = "Enter between $" + MinPayment.toString("0.00") + " and $" + MaxPayment.toString("0.00");

            //            var rngRecurringPayment = document.getElementById("rngRecurringPayment");
            //            rngRecurringPayment.MinimumValue = MinPayment.toString("0.00");
            //            rngRecurringPayment.MaximumValue = MaxPayment.toString("0.00");

        }

            function OnClientSelectedIndexChanged(sender, eventArgs) {
                var item = eventArgs.get_item();
                var value = item.get_value();
                $("#<%=hdnPayFrequency.ClientID %>").val(value);
                CalculateFields();
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

            function reloadPage(arg) {
                GetRadWindow().BrowserWindow.refreshPage();
                closePopup();
            }

            function gotoPayPlan() {
                GetRadWindow().BrowserWindow.gotoPayPlan();
            }

            function showAddPaymentPopup() {
                GetRadWindow().BrowserWindow.showAddPaymentPopup();
            }

            function validateAmount(sender, arg) {
                var amount = parseInt(arg.Value);
                if (amount > 0 && amount < 100000) {
                    arg.IsValid = true;
                    return;
                }

                arg.IsValid = false;
            }

            function validateMessage(sender, args) {
                if (args.Value.trim().length >= 2) {
                    args.IsValid = true;
                    return;
                }
                else {
                    args.IsValid = false;
                    return;
                }
            }

            function validateRequest(isDelete) {
                if (isDelete) {
                    $("#<%=hdnIsDeletePaymentPlan.ClientID %>").val(1);
                    $("#<%=btnConfirmedDeletePaymentPlan.ClientID %>").click();
                }

            }

            function ConfirmDelete() {
                radconfirm('Are you sure you want to cancel? <br/>Without creating a new plan, the outstanding balance will be due in full by the due date.', validateRequest, 400, 150, null, '', '../Content/Images/warning.png');
            }


            function enableDisableButton(obj) {
                var isPageValid = false;

                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('PayPlanValidationGroup');
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

