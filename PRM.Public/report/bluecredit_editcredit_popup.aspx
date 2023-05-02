<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_editcredit_popup.aspx.cs"
    Inherits="bluecredit_editcredit_popup" %>

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
        <asp:UpdatePanel ID="updPanelEligility" runat="server">
            <ContentTemplate>
                <table class="CareBluePopup" width="100%">
                    <tr>
                        <td colspan="2">
                            <h2p>BlueCredit</h2p>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <h3p>Modify Existing BlueCredit Plan</h3p>
                        </td>
                    </tr>
                </table>
                <div class="ExtraPad"></div>
                <div class="CareBluePopup">
                    <table width="100%">
                        <tr>
                            <td width="20">&nbsp;
                            </td>
                            <td width="200">
                                <asp:Label ID="Label4" runat="server">BlueCredit ID:</asp:Label>
                                <asp:Label ID="lblBlueCreditID" runat="server"></asp:Label>
                                <br />
                                <asp:Label ID="Label1" runat="server">Borrower:</asp:Label>
                                <asp:Label ID="lblAccountHolder" runat="server"></asp:Label>
                            </td>
                            <td>
                                <asp:Label ID="Label3" runat="server">Phone:</asp:Label>
                                <asp:Label ID="lblPhonePri" runat="server"></asp:Label>
                                <br />
                                <asp:Label ID="Label16" runat="server">Email:</asp:Label>
                                <asp:Label ID="lblEmail" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <h5 style="margin-bottom: 5px;">Active Assigned Statements</h5>
                    <div style="overflow-x: auto">
                        <telerik:RadGrid ID="grdActiveStatements" runat="server" AllowSorting="True" AllowPaging="True"
                            OnPreRender="grdActiveStatements_OnPreRender" OnNeedDataSource="grdActiveStatements_NeedDataSource"
                            PageSize="10">
                            <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID">
                                <Columns>
                                    <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Date" DataField="InvoiceDate">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Provider" DataField="ProviderName">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Last Payment" DataField="LastPayment$">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Last Payment Date" DataField="LastPaymentDate">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="PayPlan" DataField="CreditPayAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="CreditPlan" DataField="CreditPlanAbbr">
                                    </telerik:GridBoundColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                    </div>
                    <h5 style="margin-bottom: 5px;">Credit Plan Options</h5>
                    <div>
                        <telerik:RadGrid ID="grdBlueCredit" runat="server" AllowSorting="True" AllowPaging="True"
                            PageSize="10">
                            <MasterTableView AutoGenerateColumns="False">
                                <Columns>
                                    <telerik:GridBoundColumn HeaderText="Plan" DataField="PlanName">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Open Date" DataField="OpenDate">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Limit" DataField="CreditLimit">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Remaining Promo" DataField="PromoRemainAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Remaining Team" DataField="TermRemainAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Period Minimum" DataField="MinPayAmount">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Next Bill Due" DataField="NextPayDate" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:RadGrid>
                    </div>
                    <div class="ExtraPad">
                        &nbsp;
                    </div>
                    <div style="float: right; position: relative; top: 43px;">
                        <h5>Please contact your provider to modify billing information.</h5>
                    </div>
                    <table width="100%">
                        <tr>
                            <td width="200" valign="top">
                                <div class="lblInputR">
                                    <asp:Label ID="Label19" runat="server">Recurring Payment:</asp:Label>
                                </div>
                            </td>
                            <td width="320">
                                <div class="boxInputL">
                                    <telerik:RadNumericTextBox runat="server" ID="txtRecurringPayment" Width="100px"
                                        onchange="setSliderValue()" MaxLength="10" Enabled="True" Type="Currency" NumberFormat-DecimalDigits="2"
                                        NumberFormat-GroupSeparator="">
                                    </telerik:RadNumericTextBox>
                                    <asp:RangeValidator ID="rngRecurringPayment" ControlToValidate="txtRecurringPayment"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationGroup="BlueCredit"
                                        Type="Currency" runat="server">*</asp:RangeValidator>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" Display="Dynamic"
                                        SetFocusOnError="True" ValidationGroup="BlueCredit" ToolTip="Recurring Payment is required"
                                        ErrorMessage="Recurring Payment is required" CssClass="failureNotification" ControlToValidate="txtRecurringPayment">*
                                    </asp:RequiredFieldValidator>
                                </div>
                                <div class="boxInputR">
                                    <telerik:RadSlider ID="sldRecurringPayment" runat="server" OnClientValueChanged="recurringPaymentValueChanged">
                                    </telerik:RadSlider>
                                </div>
                                <div class="boxInputL">
                                    <asp:Label ID="lblPendingPayments" runat="server"></asp:Label>
                                </div>
                                <p>
                                &nbsp;
                            </td>
                            <td width="200" valign="bottom">
                                <div class="lblInputR">
                                    <asp:Label ID="Label10" runat="server">Borrower:</asp:Label>
                                </div>
                            </td>
                            <td valign="bottom">
                                <div class="boxInputL">
                                    <asp:Label ID="lblBorrower" runat="server"></asp:Label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="lblInputR">
                                    <asp:Label ID="Label6" runat="server">Preferred Funding:</asp:Label>
                                </div>
                            </td>
                            <td>
                                <div class="boxInputL">
                                    <telerik:RadComboBox ID="cmbFundingSource" runat="server" Width="200px" EmptyMessage="Choose Funding Source..."
                                        AllowCustomText="False" MarkFirstMatch="True" MaxHeight="200" DataTextField="AccountName"
                                        DataValueField="PaymentCardID">
                                    </telerik:RadComboBox>
                                    &nbsp;
                                    <asp:Image ID="btnAddCard" ImageUrl="../content/Images/icon_add.png" onclick="showPaymentCardPopup();" Style="cursor: pointer" ToolTip="Add New Payment Card" runat="server" />
                                </div>

                            </td>

                            <td>
                                <div class="lblInputR">
                                    <asp:Label ID="Label12" runat="server">Billing Address 1:</asp:Label>
                                </div>
                            </td>
                            <td>
                                <div class="boxInputL">
                                    <asp:TextBox ID="txtBillingAddress1" Enabled="False" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic"
                                        SetFocusOnError="True" ValidationGroup="BlueCredit" ToolTip="Billing Address 1 is required"
                                        ErrorMessage="Billing Address 1 is required" CssClass="failureNotification" ControlToValidate="txtBillingAddress1">*
                                    </asp:RequiredFieldValidator>
                                </div>
                            </td>
                        </tr>
                        <tr>

                            <td>
                                <div class="lblInputR">
                                    <asp:Label ID="Label15" runat="server">Bill Schedule:</asp:Label>
                                </div>
                            </td>
                            <td>
                                <div class="boxInputL">
                                    <telerik:RadComboBox ID="cmbBillSchedule" runat="server" Width="155px" EmptyMessage="Choose Bill Schedule..."
                                        Enabled="False" AllowCustomText="False" MarkFirstMatch="True" MaxHeight="200"
                                        DataValueField="PaymentFreqTypeID" DataTextField="Abbr">
                                    </telerik:RadComboBox>
                                </div>
                            </td>

                            <td>
                                <div class="lblInputR">
                                    <asp:Label ID="Label9" runat="server">Address 2:</asp:Label>
                                </div>
                            </td>
                            <td>
                                <div class="boxInputL">
                                    <asp:TextBox ID="txtAddress2" Enabled="False" MaxLength="99" runat="server"></asp:TextBox>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="lblInputR">
                                    <asp:Label ID="Label22" runat="server">Linked Checking:</asp:Label>
                                </div>
                            </td>
                            <td>
                                <div class="boxInputL">
                                    <telerik:RadComboBox ID="cmbBackupFundingSource" runat="server" Width="200px" EmptyMessage="Choose Funding Source..."
                                        AllowCustomText="False" MarkFirstMatch="True" MaxHeight="200" DataTextField="AccountName"
                                        DataValueField="PaymentCardID">
                                    </telerik:RadComboBox>
                                </div>
                            </td>
                            <td>
                                <div class="lblInputR">
                                    <asp:Label ID="Label13" runat="server">City:</asp:Label>
                                </div>
                            </td>
                            <td>
                                <div class="boxInputL">
                                    <asp:TextBox ID="txtCity" Enabled="False" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic"
                                        SetFocusOnError="True" ToolTip="City is required" ErrorMessage="City is required"
                                        CssClass="failureNotification" ValidationGroup="BlueCredit" ControlToValidate="txtCity">*
                                    </asp:RequiredFieldValidator>
                                </div>
                            </td>
                        </tr>
                        <tr>

                            <td>
                                <div class="lblInputR">
                                    <asp:Label ID="Label8" runat="server">Next Payment Date:</asp:Label>
                                </div>
                            </td>
                            <td>
                                <div class="boxInputL">
                                    <telerik:RadDatePicker ID="dtNextPayment" MinDate="1900/1/1" runat="server" CssClass="set-telerik-ctrl-width">
                                    </telerik:RadDatePicker>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="dtNextPayment"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Next Payment is required."
                                        ErrorMessage="Next Payment is required." ValidationGroup="BlueCredit">*
                                    </asp:RequiredFieldValidator>
                                </div>
                            </td>


                            <td>
                                <div class="lblInputR">
                                    <asp:Label ID="Label14" runat="server">State:</asp:Label>
                                </div>
                            </td>
                            <td>
                                <div class="boxInputL">
                                    <telerik:RadComboBox ID="cmbStateType" Enabled="False" runat="server" Width="150px"
                                        EmptyMessage="Choose State..." AllowCustomText="False" MarkFirstMatch="True"
                                        MaxHeight="200" DataTextField="Name" DataValueField="StateTypeID">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator" runat="server" Display="Dynamic"
                                        SetFocusOnError="True" ToolTip="State is required" ErrorMessage="State is required"
                                        CssClass="failureNotification" ValidationGroup="BlueCredit" ControlToValidate="cmbStateType">*
                                    </asp:RequiredFieldValidator>
                                </div>
                            </td>
                        </tr>
                        <tr>

                            <td>
                                <div class="lblInputR">
                                    <asp:Label ID="Label21" runat="server">Email Address:</asp:Label>
                                </div>
                            </td>
                            <td>
                                <div class="boxInputL">
                                    <asp:TextBox ID="txtEmailAddress" MaxLength="50" Width="200px" runat="server"></asp:TextBox>
                                </div>
                            </td>
                            <td>
                                <div class="lblInputR">
                                    <asp:Label ID="Label17" runat="server">Zip Code + 4::</asp:Label>
                            </td>
                            <td>
                                <div class="boxInputL">
                                    <asp:TextBox ID="txtZip" MaxLength="5" Enabled="False" Width="50" runat="server">
                                    </asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtZip"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Zip Code 1 is required."
                                        ErrorMessage="Zip Code 1 is required." ValidationGroup="BlueCredit">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtZip"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                        ToolTip="Invalid Zip Code 1" ErrorMessage="Invalid Zip Code 1" ValidationGroup="BlueCredit">*
                                    </asp:RegularExpressionValidator>
                                    -
                                <asp:TextBox ID="txtZip4" Enabled="False" MaxLength="4" Width="40" runat="server">
                                </asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtZip4"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{4}$"
                                        ToolTip="Invalid Zip Code " ErrorMessage="Invalid Zip Code " ValidationGroup="BlueCredit">*
                                    </asp:RegularExpressionValidator>
                                </div>
                </div>
                </td> </tr>
            <tr>
                <td>
                    <div class="lblInputR">
                        <asp:Label ID="Label5" runat="server">Email Bills:</asp:Label>
                    </div>
                </td>
                <td>
                    <div class="boxInputL" style="margin-left: -4px;">
                        <asp:CheckBox ID="chkEmailBills" runat="server" />
                    </div>
                </td>
                <td>
                    <div class="lblInputR">
                        <asp:Label ID="Label20" runat="server">Phone:</asp:Label>
                    </div>
                </td>
                <td>
                    <div class="boxInputL">
                        <telerik:RadMaskedTextBox ID="txtPhone" Enabled="False" runat="server" Mask="(###) ###-####"
                            Width="115">
                        </telerik:RadMaskedTextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator3" Display="Dynamic"
                            runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                            SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtPhone"
                            ValidationGroup="BlueCreditValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*
                        </asp:RegularExpressionValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtPhone"
                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Phone is required."
                            ErrorMessage="Phone is required." ValidationGroup="BlueCreditValidationGroup">*
                        </asp:RequiredFieldValidator>
                    </div>
                </td>
            </tr>
                </table>
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="BlueCredit"
                ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                CssClass="failureNotification" HeaderText="Please fix the following errors:" />
                <div id="divSuccessMessage" class="success-message" style="text-align: right">
                    <asp:Literal ID="litMessage" Text="" runat="server"></asp:Literal>
                </div>
                <asp:HiddenField ID="hdnIstruthInLending" runat="server" />
                <asp:HiddenField ID="hdnStatementID" runat="server" />
                <%--<asp:HiddenField ID="hdnShowInvoice" runat="server" />--%>
                <asp:HiddenField ID="hdnIsGridHasOneRow" runat="server" />
                <asp:HiddenField ID="hdnIsTerminate" runat="server" />
                <asp:HiddenField ID="hdnIsFlagEmails" runat="server" />
                <asp:HiddenField ID="hdnValues" runat="server" />
                <a href="#" onclick="closePopup()">
                    <img src="../content/Images/btn_close.gif" class="btn-pop-cancel" alt="Close" /></a>&nbsp;
            <asp:ImageButton ID="btnSubmit" ImageUrl="../content/Images/btn_update.gif" CssClass="btn-pop-submit"
                runat="server" OnClientClick="return validateFlagBillEmails()" OnClick="btnSubmit_Click"
                ValidationGroup="BlueCredit" />
                <asp:Button ID="btnRemoveStatement" Style="display: none" OnClick="btnRemoveStatement_Click"
                    runat="server" />
                <asp:Button ID="btnRebindFundingSource" Style="display: none" OnClick="btnRebindFundingSource_Click"
                    runat="server" />
                </div>
                <telerik:RadWindowManager ID="RadWindow" ShowContentDuringLoad="True" VisibleStatusbar="False"
                    VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="1100px" Height="850px"
                    Behaviors="Pin,Reload,Close,Move,Resize" Modal="True" EnableShadow="False" EnableEmbeddedBaseStylesheet="False"
                    EnableEmbeddedSkins="False" Skin="CareBlue" Style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupAddPaymentCard" Width="750px" Height="550px"
                            NavigateUrl="~/report/pc_add_popup.aspx?ShowPaymentMethods=1">
                        </telerik:RadWindow>
                    </Windows>
                </telerik:RadWindowManager>
                <telerik:RadWindowManager ID="windowManager" Behaviors="Move" Style="z-index: 200001"
                    ShowContentDuringLoad="False" VisibleStatusbar="False" VisibleTitlebar="True"
                    ReloadOnShow="True" runat="Server" Modal="True" EnableEmbeddedBaseStylesheet="True"
                    EnableEmbeddedSkins="False" Skin="CareBlueInf">
                    <ConfirmTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <h5>
                                <div class="rwDialogText">
                                    {1} Are you sure, you want to remove the selected Active Statment?
                                </div>
                            </h5>
                            <div>
                                <div style="margin-top: 15px; margin-left: 55px;">
                                    <a href="#" onclick="$find('{0}').close(true);">
                                        <img src="../content/Images/btn_ok_small.gif" alt="Ok" /></a> &nbsp; &nbsp; <a href="#"
                                            onclick="$find('{0}').close(false);">
                                            <img src="../content/Images/btn_cancel_small.gif" alt="Cancel" /></a>
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
                                    <img src="../content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            </div>
                        </div>
                    </AlertTemplate>
                </telerik:RadWindowManager>
            </ContentTemplate>
        </asp:UpdatePanel>
        <script src="../Scripts/BigDecimal.js" type="text/javascript"></script>
        <script src="../Scripts/date.js" type="text/javascript"></script>
        <script type="text/javascript" language="javascript">
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {

                $(function () {
                    setTimeout('$("#divSuccessMessage").html("");', 4000);
                });

           <%-- if ($("#<%=hdnShowInvoice.ClientID %>").val() == "True") {
                showInvoicePopUp();
            }--%>
                if ($("#<%=hdnIstruthInLending.ClientID %>").val() == "1") {
                    showTruthInLendingPopup();
                }
            });
            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
                else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

                return oWindow;
            }

            function closePopup() {
                GetRadWindow().BrowserWindow.refreshPage();
                GetRadWindow().close();
            }


            function recurringPaymentValueChanged(sender, eventArgs) {
                var recurringPayment = $find("<%=txtRecurringPayment.ClientID%>");
                recurringPayment.set_value((sender.get_value()));
                var values = $("#<%=hdnValues.ClientID%>").val().split(",");
                $("#<%=lblPendingPayments.ClientID %>").text(CalcRemainingPayments(values[0], values[1], values[2], values[3], values[4], values[5], sender.get_value()));
            }


            function CalcRemainingPayments(a, cycle, b, termpromo, d, termmax, f) {

                //Default Values
                var oneDay = 24 * 60 * 60 * 1000; //necessary to get diffDays
                var APRDiv = new BigDecimal("36500");
                var BDOne = new BigDecimal("1"); //need all values to be in BigDecimal datatype
                var NumDays = new BigDecimal("31"); //Default, will set to actual Days Diff
                var remainingCycles = 0;

                //Convert to BigDecimal
                var financedAmount = new BigDecimal(a.toString());
                var ratepromo = new BigDecimal(b.toString());
                ratepromo = ratepromo.divide(APRDiv, new MathContext(20));
                ratepromo = ratepromo.add(BDOne);

                var ratestd = new BigDecimal(d.toString());
                ratestd = ratestd.divide(APRDiv, new MathContext(20));
                ratestd = ratestd.add(BDOne);

                var minPayment = new BigDecimal(f.toString());

                var cycle = 1;
                var TotalPayments = new BigDecimal("0");

                while (cycle <= termpromo && financedAmount > 0) {
                    var diffDays = Math.floor(Math.abs((Date.today().add(cycle - 1).months().getTime() - Date.today().add(cycle).months().getTime()) / oneDay)); //Calculate the number of days in the period
                    NumDays = new BigDecimal(diffDays.toString()); //Convert value to BigDecimal
                    //console.log(NumDays.toString());
                    financedAmount = financedAmount.multiply(ratepromo.pow(NumDays, new MathContext(20))).setScale(2, BigDecimal.ROUND_UP); //Add interest for period
                    if (parseFloat(financedAmount.toString()) < parseFloat(minPayment.toString()) + 1) { minPayment = new BigDecimal(financedAmount.toString()); } //the last payment may be different by a few pennies, so it checks to see if it's within a dollar
                    financedAmount = financedAmount.subtract(minPayment); //Subtract from financedAmount
                    TotalPayments = TotalPayments.add(minPayment); //Keep adding Total Actual Payments
                    cycle++;
                    remainingCycles++;
                }
                while (cycle <= termmax && financedAmount > 0) {
                    var diffDays = Math.floor(Math.abs((Date.today().add(cycle - 1).months().getTime() - Date.today().add(cycle).months().getTime()) / oneDay)); //Calculate the number of days in the period
                    NumDays = new BigDecimal(diffDays.toString()); //Convert value to BigDecimal
                    //console.log(NumDays.toString());
                    financedAmount = financedAmount.multiply(ratestd.pow(NumDays, new MathContext(20))).setScale(2, BigDecimal.ROUND_UP);
                    if (parseFloat(financedAmount.toString()) < parseFloat(minPayment.toString()) + 1) { minPayment = new BigDecimal(financedAmount.toString()); } //the last payment may be different by a few pennies, so it checks to see if it's within a dollar
                    financedAmount = financedAmount.subtract(minPayment); //Subtract from financedAmount
                    TotalPayments = TotalPayments.add(minPayment); //Keep adding Total Actual Payments
                    cycle++;
                    remainingCycles++;
                }
                return "This plan will be paid off in " + parseFloat(remainingCycles) + " payments.";
            }


            function setTerminateValue() {
                $("#<%=hdnIsTerminate.ClientID%>").val(true);
            }

            function setSliderValue() {
                var recurringPayment = $find("<%=txtRecurringPayment.ClientID %>");
                var slider = $find("<%=sldRecurringPayment.ClientID%>");
                var newValue = recurringPayment.get_value();
                if (isNaN(parseFloat(newValue))) return;
                if (slider.get_isSelectionRangeEnabled()) {
                    slider.set_selectionStart(newValue);
                }
                else {
                    slider.set_value(newValue);
                }
            }

            function validateFlagBillEmails() {
                if ($("#<%=hdnIsFlagEmails.ClientID%>").val() == "True") {
                    var isFlagBillEmails = $("#<%=chkEmailBills.ClientID%>").is(":checked");
                    if (!isFlagBillEmails) {
                        radconfirm('Email Bills is required', '', 400, 140, null, '', 'Content/Images/warning.png');
                        return false;
                    }

                    return true;
                }

                var isPageValid = false;

                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('BlueCredit');
                }

                return isPageValid;
            }

            function confirmCallBackFn(isConfirm) {
                if (isConfirm) {
                    $("#<%=btnRemoveStatement.ClientID %>").click();
                }
            }

            function showLendingAgreementPopup() {
                GetRadWindow().BrowserWindow.showLendingTermsPopup();
            }

            function showInvoicePopUp() {
                GetRadWindow().BrowserWindow.closeBlueCreditEditPopupandShowInvoice();
            }
            function showTruthInLendingPopup() {
                GetRadWindow().BrowserWindow.showTruthInLendingpopup();
            }

            function showPaymentCardPopup() {
                $find("<%=popupAddPaymentCard.ClientID %>").show();
            }

            function genericFunction() {
                $("#<%=btnRebindFundingSource.ClientID %>").click();
            }

        </script>
        <script type="text/javascript">
            window.alert = function (string) {
                var reg = new RegExp("\\-", "g");
                var messages = string.replace(reg, "<br />").replace("Please fix the following errors:", "Please fix the following errors:<br />");
                var radWindow = $find("<%=windowManager.ClientID %>");
                radWindow.radalert(messages, 400, 100, '', "", '../content/Images/warning.png');
            }

        </script>
        <script type="text/javascript" src="../Scripts/blockEnterEvent.js"></script>
    </form>
</body>
</html>
