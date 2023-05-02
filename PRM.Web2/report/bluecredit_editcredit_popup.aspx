<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_editcredit_popup.aspx.cs"
    Inherits="bluecredit_editcredit_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <telerik:radscriptmanager id="RadScriptManager1" runat="server">
        </telerik:radscriptmanager>
        <asp:UpdatePanel ID="updPanelEligility" runat="server">
            <ContentTemplate>
                <div>
                    <table class="CareBluePopup">
                        <tr>
                            <td>
                                <h2p>Manage BlueCredit Plan</h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>BlueCredit #<asp:Label ID="lblBlueCreditID" runat="server"></asp:Label> | <asp:Label ID="lblAccountHolder" runat="server"></asp:Label> | <asp:Label ID="lblAccountholderType" runat="server"></asp:Label>
                                </h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad">
                                <table width="100%">
                                    <tr>
                                        <td>
                                            <table width="100%">
                                                <tr>
                                                    <td>
                                                        <h6p><div style="font-size:1.2em; color:black;margin-bottom:10px;">
                                                            Active Assigned Statements
                                                        </h6p>
                </div>
                <div style="overflow: auto;">
                    <telerik:radgrid id="grdActiveStatements" runat="server" allowsorting="True" allowpaging="True"
                        onprerender="grdActiveStatements_OnPreRender" onneeddatasource="grdActiveStatements_NeedDataSource"
                        pagesize="10" onitemcommand="grdActiveStatements_ItemCommand" onitemdatabound="grdActiveStatements_ItemDataBound">
                                                                <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID">
                                                                    <Columns>
                                                                        <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                                                        </telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn HeaderText="Date" DataField="InvoiceDate">
                                                                        </telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                                                        </telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderName">
                                                                        </telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                                                        </telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$">
                                                                        </telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn HeaderText="Last Payment" DataField="LastPayment$">
                                                                        </telerik:GridBoundColumn>
                                                                        <telerik:GridBoundColumn HeaderText="Last Pay Date" DataField="LastPaymentDate">
                                                                        </telerik:GridBoundColumn>
                                                                        <telerik:GridTemplateColumn UniqueName="RemoveStatements" HeaderText="Remove">
                                                                            <ItemTemplate>
                                                                                <asp:ImageButton ID="btnSelectedRemoveStatement" ImageUrl="../Content/Images/icon_cancelx.gif" OnClientClick="return removeStatement(this)" runat="server" />
                                                                                <asp:Label ID="lblStatementID" Text='<%#Bind("StatementID")%>' runat="server" Style="display: none;"></asp:Label>
                                                                            </ItemTemplate>
                                                                        </telerik:GridTemplateColumn>
                                                                        <telerik:GridButtonColumn CommandName="ViewActiveStatement" HeaderText="View" ButtonType="ImageButton"
                                                                            ImageUrl="~/Content/Images/view.png">
                                                                        </telerik:GridButtonColumn>
                                                                    </Columns>
                                                                </MasterTableView>
                                                            </telerik:radgrid>
                </div>
                </td>
                                                </tr>
                                            </table>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <h6p><div style="font-size:1.2em; color:black;margin-bottom:10px;">
                                                Credit Plan Status
                                            </h6p>
                                            </div>
                                            <div>
                                                <telerik:radgrid id="grdBlueCredit" runat="server" allowsorting="False" allowpaging="True" pagesize="10">
                                                    <MasterTableView AutoGenerateColumns="False">
                                                        <Columns>
                                                            <telerik:GridBoundColumn HeaderText="Open Date" DataField="OpenDate">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn HeaderText="Plan" DataField="PlanName">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn HeaderText="Status" DataField="CreditStatusTypeAbbr">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn HeaderText="Current Cycle" DataField="LastCycle">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn HeaderText="Credit Limit" DataField="CreditLimit">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn HeaderText="In Use" DataField="Balance">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn HeaderText="Promo Left" DataField="PromoRemainAbbr">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn HeaderText="Max Terms" DataField="TermRemainAbbr">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn HeaderText="Min Payment" DataField="MinPayAmount">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn HeaderText="Next Bill Due" DataFormatString="{0:MM/dd/yyyy}" DataField="NextDueDate">
                                                            </telerik:GridBoundColumn>
                                                        </Columns>
                                                    </MasterTableView>
                                                </telerik:radgrid>
                                            </div>
                                        </td>
                                    </tr>
                </table>
                &nbsp;
                                <table width="100%" border="0" class="align-popup-fields">
                                    <tr>
                                        <td width="40%" valign="top">
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label18" runat="server">Extent Max Term:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radcombobox id="cmbExtentMaxTerm" runat="server" width="50px" emptymessage="Extent Max Term..."
                                                        allowcustomtext="False" markfirstmatch="True" maxheight="200" datatextfield="Text"
                                                        onselectedindexchanged="cmbExtentMaxTerm_OnSelectedIndexChanged" autopostback="True"
                                                        datavaluefield="Value">
                                                    </telerik:radcombobox>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label19" runat="server">Recurring Payment:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radnumerictextbox runat="server" id="txtRecurringPayment" width="100px"
                                                        onchange="setSliderValue('recurring', this)"
                                                        maxlength="10" enabled="True" type="Currency" numberformat-decimaldigits="2"
                                                        numberformat-groupseparator=",">
                                                    </telerik:radnumerictextbox>
                                                    <asp:RangeValidator ID="rngRecurringPayment" ControlToValidate="txtRecurringPayment"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationGroup="BlueCredit"
                                                        Type="Double" runat="server">*</asp:RangeValidator>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" Display="Dynamic"
                                                        SetFocusOnError="True" ValidationGroup="BlueCredit" ToolTip="Recurring Payment is required"
                                                        ErrorMessage="Recurring Payment is required" CssClass="failureNotification" ControlToValidate="txtRecurringPayment">*</asp:RequiredFieldValidator>
                                                    <div style="float: right;">
                                                        <telerik:radslider id="sldRecurringPayment" runat="server" width="160" onclientvaluechanged="recurringPaymentValueChanged">
                                                        </telerik:radslider>
                                                    </div>
                                                    <br />
                                                    <asp:Label ID="lblRecurringPayment" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label4" runat="server">Credit Limit:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radnumerictextbox runat="server" id="txtCreditLimit" width="100px" maxlength="10"
                                                        onchange="setSliderValue('creditLimit', this)" onkeypress="validateEnterEvent(event)"
                                                        enabled="True" type="Currency" numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                                    </telerik:radnumerictextbox>
                                                    <asp:RangeValidator ID="rngCrediLimit" ControlToValidate="txtCreditLimit" Display="Dynamic"
                                                        Type="Double" SetFocusOnError="True" CssClass="failureNotification" ValidationGroup="BlueCredit"
                                                        runat="server">*</asp:RangeValidator>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Display="Dynamic"
                                                        SetFocusOnError="True" ValidationGroup="BlueCredit" ToolTip="Credit Limit is required"
                                                        ErrorMessage="Credit Limit is required" CssClass="failureNotification" ControlToValidate="txtCreditLimit">*</asp:RequiredFieldValidator>
                                                    <div style="float: right;">
                                                        <telerik:radslider id="sldBalance" runat="server" width="160" onclientvaluechanged="HandleValueChanged">
                                                        </telerik:radslider>
                                                    </div>
                                                    <br />
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label6" runat="server">Preferred Funding:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radcombobox id="cmbFundingSource" runat="server" width="200px" emptymessage="Choose Funding Source..."
                                                        allowcustomtext="False" markfirstmatch="True" maxheight="200" datatextfield="AccountName"
                                                        onselectedindexchanged="EnableAutoPayButton" autopostback="True" datavaluefield="PaymentCardID">
                                                    </telerik:radcombobox>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label15" runat="server">Bill Schedule:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radcombobox id="cmbBillSchedule" runat="server" width="200px" emptymessage="Choose Bill Schedule..."
                                                        allowcustomtext="False" markfirstmatch="True" maxheight="200" datavaluefield="PaymentFreqTypeID"
                                                        datatextfield="Abbr">
                                                    </telerik:radcombobox>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label22" runat="server">Linked Checking:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radcombobox id="cmbBackupFundingSource" runat="server" width="200px" emptymessage="Choose Funding Source..."
                                                        allowcustomtext="False" markfirstmatch="True" maxheight="200" datatextfield="AccountName"
                                                        onselectedindexchanged="EnableAutoPayButton" autopostback="True" datavaluefield="PaymentCardID">
                                                    </telerik:radcombobox>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label8" runat="server">Next Payment:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:raddatepicker id="dtNextPayment" mindate="1900/1/1" runat="server" cssclass="set-telerik-ctrl-width">
                                                    </telerik:raddatepicker>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="dtNextPayment"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Next Payment is required."
                                                        ErrorMessage="Next Payment is required." ValidationGroup="BlueCredit">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label1" runat="server">Linked Payments:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    &nbsp;
                                                    <asp:ImageButton ID="btnAddNew" ImageUrl="../Content/Images/btn_addnew_small.gif" OnClientClick="return showPaymentCardPopup();" runat="server" style="margin-top:2px;"/>&nbsp;
                                                    <asp:ImageButton ID="btnDisableAutoPay" ImageUrl="../Content/Images/btn_disableautopay.gif" OnClientClick="confirmDisableAutoPay(); return false;" runat="server" />
                                                </div>
                                            </div>
                                            <div id="divCardMessage" runat="server" Visible="False" style="margin:0px -15px 10px 27px; color:darkred;">NOTE: Credit cards are a non-standard payment form for this plan; a convenience fee of 2.75% will be applied to each credit card payment.</div>
                                        </td>

                                        <td width="31%" valign="top">
                                            <div class="form-row-tight">
                                                <div class="editor-label-tight">
                                                    <asp:Label ID="Label10" runat="server">Borrower:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblBorrower" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row-tight">
                                                <div class="editor-label-tight">
                                                    <asp:Label ID="Label20" runat="server">Phone:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radmaskedtextbox id="txtPhone" runat="server" mask="(###) ###-####" width="142">
                                                    </telerik:radmaskedtextbox>
                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" Display="Dynamic"
                                                        runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtPhone"
                                                        ValidationGroup="BlueCreditValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtPhone"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Phone is required."
                                                        ErrorMessage="Phone is required." ValidationGroup="BlueCreditValidationGroup">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="form-row-tight">
                                                <div class="editor-label-tight">
                                                    <asp:Label ID="Label2" runat="server">Alt Phone:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radmaskedtextbox id="txtAltPhone" runat="server" mask="(###) ###-####" width="142">
                                                    </telerik:radmaskedtextbox>
                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" Display="Dynamic"
                                                        runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtAltPhone"
                                                        ValidationGroup="BlueCreditValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtAltPhone"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Phone is required."
                                                        ErrorMessage="Phone is required." ValidationGroup="BlueCreditValidationGroup">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="form-row-tight">
                                                <div class="editor-label-tight">
                                                    <asp:Label ID="Label12" runat="server">Address 1:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox ID="txtBillingAddress1" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic"
                                                        SetFocusOnError="True" ValidationGroup="BlueCredit" ToolTip="Billing Address 1 is required"
                                                        ErrorMessage="Billing Address 1 is required" CssClass="failureNotification" ControlToValidate="txtBillingAddress1">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="form-row-tight">
                                                <div class="editor-label-tight">
                                                    <asp:Label ID="Label9" runat="server">Address 2:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox ID="txtAddress2" MaxLength="99" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="form-row-tight">
                                                <div class="editor-label-tight">
                                                    <asp:Label ID="Label13" runat="server">City:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox ID="txtCity" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic"
                                                        SetFocusOnError="True" ToolTip="City is required" ErrorMessage="City is required"
                                                        CssClass="failureNotification" ValidationGroup="BlueCredit" ControlToValidate="txtCity">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="form-row-tight">
                                                <div class="editor-label-tight">
                                                    <asp:Label ID="Label14" runat="server">State:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radcombobox id="cmbStateType" runat="server" width="150px" emptymessage="Choose State..."
                                                        allowcustomtext="False" markfirstmatch="True" maxheight="200" datatextfield="Name"
                                                        datavaluefield="StateTypeID">
                                                    </telerik:radcombobox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator" runat="server" Display="Dynamic"
                                                        SetFocusOnError="True" ToolTip="State is required" ErrorMessage="State is required"
                                                        CssClass="failureNotification" ValidationGroup="BlueCredit" ControlToValidate="cmbStateType">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="form-row-tight">
                                                <div class="editor-label-tight">
                                                    <asp:Label ID="Label17" runat="server">Zip Code:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox ID="txtZip" MaxLength="5" Width="50" runat="server">
                                                    </asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtZip"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Zip Code 1 is required."
                                                        ErrorMessage="Zip Code 1 is required." ValidationGroup="BlueCredit">*</asp:RequiredFieldValidator>
                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtZip"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                                        ToolTip="Invalid Zip Code 1" ErrorMessage="Invalid Zip Code 1" ValidationGroup="BlueCredit">*</asp:RegularExpressionValidator>
                                                    -
                                                    <asp:TextBox ID="txtZip4" MaxLength="4" Width="40" runat="server">
                                                    </asp:TextBox>
                                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtZip4"
                                                    Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Zip Code  is required."
                                                    ErrorMessage="Zip Code  is required." ValidationGroup="BlueCredit">*</asp:RequiredFieldValidator>--%>
                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtZip4"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{4}$"
                                                        ToolTip="Invalid Zip Code " ErrorMessage="Invalid Zip Code " ValidationGroup="BlueCredit">*</asp:RegularExpressionValidator>
                                                </div>
                                            </div>
                                            <div class="form-row-tight">
                                                <div class="editor-label-tight">
                                                    <asp:Label ID="Label21" runat="server">Email:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox ID="txtEmailAddress" MaxLength="50" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="form-row-tight">
                                                <div class="editor-label-tight">&nbsp;
                                                </div>
                                                <div class="editor-field" style="color:black; margin:-2px 0 0 -3px;">
                                                    <asp:CheckBox ID="chkEmailBills" runat="server" style="margin-top:5px;"/><asp:Label ID="Label5" runat="server">Paperless Statements</asp:Label>
                                                </div>
                                            </div>
                                        </td>

                                        <td valign="top">
                                            <table>
                                                <tr>
                                                    <td style="color: #4D6231; font-weight: bold;">Agreement: </td>
                                                    <td><a href="javascript:;" onclick="showPDfViewer('la')" style=""> <img src="../Content/Images/btn_view_small.gif" alt="View PDF" /></a>&nbsp;</td>
                                                    <td><asp:ImageButton ID="btnLendingAgreement" Visible="False" ImageUrl="../Content/Images/btn_resign.gif" OnClick="btnLendingAgreement_OnClick" runat="server" /></td>
                                                </tr>
                                                <tr>
                                                    <td style="color: #4D6231; font-weight: bold;">Promissory: &nbsp;</td>
                                                    <td><asp:ImageButton ID="btnShowPromissoryNotePopup" ImageUrl="../Content/Images/btn_view_small.gif" OnClientClick="showPDfViewer('pn'); return false;" runat="server" />&nbsp;</td>
                                                    <td><asp:ImageButton ID="btnPromissoryNoteResign" Visible="False" ImageUrl="../Content/Images/btn_resign.gif" OnClick="btnUpdatePromissoryNote_OnClick" runat="server" /></td>
                                                </tr>
                                                <tr>
                                                    <td style="color: #4D6231; font-weight: bold;">TIL Disclosure: &nbsp;</td>
                                                    <td><asp:ImageButton ID="btnShowTruthInLendingPopup" ImageUrl="../Content/Images/btn_view_small.gif" OnClientClick="showPDfViewer('til'); return false;" runat="server" />&nbsp;</td>
                                                    <td><asp:ImageButton ID="btnTruthInLendingResign" Visible="False" ImageUrl="../Content/Images/btn_resign.gif" OnClick="btnUpdateTruthInLending_OnClick" runat="server" /></td>
                                                </tr>
                                                <tr>
                                                    <td style="color: #4D6231; font-weight: bold;">Pay Schedule: </td>
                                                    <td><asp:ImageButton ID="btnUpdateTruthInLending" ImageUrl="../Content/Images/btn_view_small.gif" OnClientClick="showBlueCreditTransactionHistory(); return false;" runat="server" />&nbsp;</td>
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                            <div class="form-row" style="margin: 10px 0px 0px 0px; color: #4D6231; font-weight: bold;">
                                                Notes:
                                            </div>
                                            <asp:TextBox ID="txtNotes" TextMode="MultiLine" Width="270px" Height="100px" runat="server"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:HiddenField ID="hdnIstruthInLending" runat="server" />
                                <asp:HiddenField ID="hdnStatementID" runat="server" />
                                <asp:HiddenField ID="hdnShowInvoice" runat="server" />
                                <asp:HiddenField ID="hdnIsGridHasOneRow" runat="server" />
                                <asp:HiddenField ID="hdnIsTerminate" runat="server" />
                                <asp:HiddenField ID="hdnIsFlagEmails" runat="server" />
                                <asp:HiddenField ID="hdnValues" runat="server" />
                                <asp:HiddenField ID="hdnFileName" runat="server" />
                                <asp:HiddenField ID="hdnIsShowPdfViewer" runat="server" />
                                <asp:HiddenField ID="hdnIsUpdateTruthInLending" runat="server" />
                                <asp:HiddenField ID="hdnIsShowLendingAgreement" runat="server" />
                                <asp:HiddenField ID="hdnIsUpdatePromissoryNote" runat="server" />
                                <asp:Button ID="btnRemoveStatement" Style="display: none" OnClick="btnRemoveStatement_Click" runat="server" />
                                <asp:Button ID="btnAutoPayDisable" Style="display: none" OnClick="btnDisableAutoPay_OnClick" runat="server" />
                                <asp:Button ID="btnUpdate" Style="display: none" OnClick="btnSubmit_Click" runat="server" />


                                <div style="margin-left: 10px;">
                                    <asp:ImageButton ID="btnTerminate" ImageUrl="../Content/Images/btn_terminate_fade.gif" Enabled="False" Style="margin-top: 0px;" runat="server" OnClientClick="return setTerminateValue()" />
                                    <div id="pMessage" style="text-align: left; color: darkred; margin: 5px 10px 0 0;" runat="server"></div>
                                </div>
                                <a href="javascript:;" onclick="closePopup()">
                                    <img src="../Content/Images/btn_cancel.gif" class="btn-pop-cancel" alt="Close" /></a>
                                <asp:ImageButton ID="btnSubmit" ImageUrl="../Content/Images/btn_update.gif" CssClass="btn-pop-submit" runat="server" OnClientClick="return validateFlagBillEmails()" OnClick="btnSubmit_Click" />

                            </td>
                        </tr>
                <tr>
                    <td colspan="3" align="right">
                        <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="BlueCredit"
                            ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                            CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                        <div id="divSuccessMessage" class="success-message" style="text-align: right">
                            <asp:Literal ID="litMessage" Text="" runat="server"></asp:Literal>
                        </div>
                    </td>
                </tr>
                </table>
                </div>

                <telerik:radwindowmanager id="windowManager" behaviors="Move" style="z-index: 200001"
                    showcontentduringload="False" visiblestatusbar="False" visibletitlebar="True"
                    reloadonshow="True" runat="Server" modal="True" enableembeddedbasestylesheet="True"
                    enableembeddedskins="False" skin="CareBlueInf">
                    <ConfirmTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div>
                                <div style="margin-top: 15px; margin-left: 55px;">
                                  <a href="#" onclick="$find('{0}').close(true);">
                                        <img src="../Content/Images/btn_ok.gif" alt="Ok" /></a>    &nbsp; &nbsp; 
                                    
                                    <a href="javascript:;" onclick="$find('{0}').close(false);"> <img src="../Content/Images/btn_cancel.gif" alt="Cancel" /></a>
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
                </telerik:radwindowmanager>

                <telerik:radwindowmanager id="RadWindowManager1" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                    modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    restrictionzoneid="divMainContent" skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize"
                    style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupPaymentMethods" Width="750px" Height="600px"
                            NavigateUrl="~/report/pc_add_popup.aspx?ShowPaymentMethods=1">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupInvoice" Width="1100px" Height="850px"
                            NavigateUrl="~/report/estimateview_popup.aspx" DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupTruthInLending" Width="850px" Height="710px" NavigateUrl="~/report/truthInLending_popup.aspx?IsShowBlueCreditAmortsched=0">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupPromissoryNote" Width="850px" Height="710px" NavigateUrl="~/report/promissoryNote_popup.aspx?IsShowFullTerms=0">
                        </telerik:RadWindow>
                         <telerik:RadWindow runat="server" ID="popupBlueCreditApplication" Width="800px" Height="710px" VisibleOnPageLoad="False" NavigateUrl="~/report/bluecreditApplication_popup.aspx?IsShowLenderInformation=0">
                        </telerik:RadWindow>
                         <telerik:RadWindow runat="server" ID="popupTransactionHistory" Width="850px" Height="710px" NavigateUrl="~/report/CreditTransHistory_popup.aspx">
                        </telerik:RadWindow>
                        </Windows>
                </telerik:radwindowmanager>
                <asp:Button runat="server" ID="btnSubmitTerminate" Style="display: none;" OnClick="btnSubmit_Click" />
                <asp:Button ID="btnUpdateValues" Style="display: none;" OnClick="btnUpdateValues_OnClick"
                    runat="server" />
                <asp:Button ID="btnRebindFundingSource" Style="display: none;" OnClick="btnRebindFundingSource_OnClick"
                    runat="server" />

            </ContentTemplate>
        </asp:UpdatePanel>
        <script src="../Scripts/BigDecimal.js" type="text/javascript"></script>
        <script src="../Scripts/date.js" type="text/javascript"></script>
        <script type="text/javascript" language="javascript">

            $(document).ready(function () {
                setTimeout(function () {
                    var radNumericText = $find('<%=txtRecurringPayment.ClientID%>');
                    radNumericText.set_value('<%= ViewState["RecurringBalance"].ToString() %>');

                    radNumericText = $find('<%=txtCreditLimit.ClientID%>'); 
                    radNumericText.set_value('<%= ViewState["CreditLimit"].ToString() %>');

                }, 1);
            });

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {

                $(function () {
                    setTimeout('$("#divSuccessMessage").html("");', 4000);
                });

                if ($("#<%=hdnShowInvoice.ClientID %>").val() == "True") {
                    showInvoicePopUp();
                    $("#<%=hdnShowInvoice.ClientID %>").val("False");
                }

                if ($("#<%=hdnIsUpdatePromissoryNote.ClientID %>").val() == "1") {
                    showPromissoryNotePopup();
                    $("#<%=hdnIsUpdatePromissoryNote.ClientID %>").val("");
                }

                if ($("#<%=hdnIsUpdateTruthInLending.ClientID %>").val() == "1") {
                    showTruthInLendingPopup();
                    $("#<%=hdnIsUpdateTruthInLending.ClientID %>").val("");
                }

                if ($("#<%=hdnIsShowPdfViewer.ClientID %>").val() == "1") {
                    viewPdfViewer($("#<%=hdnFileName.ClientID %>").val());
                    $("#<%=hdnIsShowPdfViewer.ClientID %>").val("");
                }

                if ($("#<%=hdnIsShowLendingAgreement.ClientID %>").val() == "1") {
                    showLendingAgreementPopup();
                    $("#<%=hdnIsShowLendingAgreement.ClientID %>").val("");
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

            function HandleValueChanged(sender, eventArgs) {
                var creditLimit = $find("<%=txtCreditLimit.ClientID%>");
                creditLimit.set_value((sender.get_value()));
            }

            function recurringPaymentValueChanged(sender, eventArgs) {
                var recurringPayment = $find("<%=txtRecurringPayment.ClientID%>");
                recurringPayment.set_value((sender.get_value()));
                var values = $("#<%=hdnValues.ClientID%>").val().split(",");
                $("#<%=lblRecurringPayment.ClientID %>").text(CalcRemainingPayments(values[0], values[1], values[2], values[3], values[4], values[5], sender.get_value()));
            }


            function showBlueCreditTransactionHistory() {
                var popup = $find("<%=popupTransactionHistory.ClientID%>");
                popup.show();

                window.setTimeout(function () {
                    popup.setActive(true);
                    popup.set_modal(true);
                }, 0);
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

            function showPaymentCardPopup() {
                $find("<%=popupPaymentMethods.ClientID%>").show();
                return false;
            }


            function setTerminateValue() {
                $("#<%=hdnIsTerminate.ClientID%>").val(true);
                radconfirm('Please confirm termination of BlueCredit account. <br>Once complete, this cannot be undone.', terminatePlan, 480, 100, null, 'Confirmation', '../Content/Images/warning.png');
                return false;
            }

            function terminatePlan(isTerminate) {
                if (isTerminate) {
                    $("#<%=btnSubmitTerminate.ClientID %>").click();
            }
        }


        function validateFlagBillEmails() {
            if ($("#<%=hdnIsFlagEmails.ClientID%>").val() == "True") {
                    var isFlagBillEmails = $("#<%=chkEmailBills.ClientID%>").is(":checked");
                    if (!isFlagBillEmails) {
                        radAlert('Email Bills is required', '', 400, 140, null, '', 'Content/Images/warning.png');
                        return false;
                    }

                }

                var isPageValid = false;

                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('BlueCredit');
                }

                var extendCombobox = $find("<%=cmbExtentMaxTerm.ClientID %>");

                if (extendCombobox.get_value() > 0 && isPageValid) {
                    radconfirm('You are about to change the terms of the BlueCredit plan by modifying the total number of cycles. This may have an impact on minimum payment, total interest charged and the end date of the BlueCredit plan. Are you sure you want to continue?', validateExtentCycleConfirmation, 520, 100, null, '');
                    return false;
                }

                return isPageValid;
            }

            function validateExtentCycleConfirmation(isConfirmed) {
                if (isConfirmed) {
                    $("#<%=btnUpdate.ClientID %>").click();
                }
            }

            function validateEnterEvent(e) {
                if (e.keyCode == 13) {
                    $("#<%=btnSubmit.ClientID%>").click();
                }
            }

            function setSliderValue(sliderName, obj) {
                var radNumericText = $find(obj.id);
                var slider = sliderName == "recurring" ? $find("<%=sldRecurringPayment.ClientID%>") : $find("<%=sldBalance.ClientID%>");
                var newValue = radNumericText.get_value();
                if (isNaN(parseFloat(newValue))) return;
                if (slider.get_isSelectionRangeEnabled()) {
                    slider.set_selectionStart(newValue);
                }
                else {
                    slider.set_value(newValue);
                }
            }



            function removeStatement(obj) {
                var id = obj.id.replace("btnSelectedRemoveStatement", "lblStatementID");
                var statementID = $("#" + id).text();
                $("#<%=hdnStatementID.ClientID %>").val(statementID);
                radconfirm('Are you sure you want to remove the selected statement? <br>Any balance will be due in full by the statement due date.', removeSelectedStatement, 500, 100, null, 'Confirmation', '../Content/Images/warning.png');
                return false;
            }

            function removeSelectedStatement(isConfirm) {
                if (isConfirm) {
                    $("#<%=btnRemoveStatement.ClientID %>").click();
            }

        }


        function viewPdfViewer(fileTobeOpen) {

            var location = "<%=ClientSession.WebPathRootProvider %>" + "report/pdfviewer_popup.aspx";
                window.open(location, fileTobeOpen, "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");

            }


            function showTruthInLendingPopup() {
                var popup = $find("<%=popupTruthInLending.ClientID%>");
                popup.show();

                window.setTimeout(function () {
                    popup.setActive(true);
                    popup.set_modal(true);
                }, 0);
            }

            function showPromissoryNotePopup() {
                var popup = $find("<%=popupPromissoryNote.ClientID%>");
                popup.show();

                window.setTimeout(function () {
                    popup.setActive(true);
                    popup.set_modal(true);
                }, 0);
            }

            function showPDfViewer(fileName) {
                $("#<%=hdnFileName.ClientID %>").val(fileName);
                $("#<%=btnUpdateValues.ClientID %>").click();
            }

            function showLendingAgreementPopup() {
                var popup = $find("<%=popupBlueCreditApplication.ClientID%>");
                popup.show();

                window.setTimeout(function () {
                    popup.setActive(true);
                    popup.set_modal(true);
                }, 0);
            }

            function genericFunction() {
                $("#<%=btnRebindFundingSource.ClientID %>").click();
            }

            function showInvoicePopUp() {

                var location = "<%=ClientSession.WebPathRootProvider %>" + "report/estimateview_popup.aspx";
                window.open(location, "Estimate", "location=0,status=0,scrollbars=1, width=850,height=700,titlebar=1,titlebar=0");


            }
            //        function showTruthInLendingPopup() {
            //            //            GetRadWindow().BrowserWindow.showTruthInLendingpopup();
            //            GetRadWindow().BrowserWindow.viewPdfViewer('<%=ClientSession.ObjectID %>', 'til');
            //        }


            function confirmDisableAutoPay() {
                radconfirm('This will clear the linked payment methods from this BlueCredit account and require the patient to make manual payments in order to keep the account in good standing. You must update the plan by selecting the “Update” button to save changes. Are you sure you want to proceed?', disableAutoPay, 600, 100, null, 'Confirm Auto Pay','../Content/Images/warning.png');
            }

            function disableAutoPay(isConfirmed) {
                if (isConfirmed) {
                    $("#<%=btnAutoPayDisable.ClientID %>").click();
                }
            }

        </script>
        <script type="text/javascript">
            window.alert = function (string) {
                var reg = new RegExp("\\-", "g");
                var messages = string.replace(reg, "<br />").replace("Please correct the following inputs before re-submitting your request:", "Please correct the following inputs before re-submitting your request: - <br />");
                var radWindow = $find("<%=windowManager.ClientID %>");
                radWindow.radalert(messages, 400, 100, '', "", "../Content/Images/warning.png");
            }

        </script>
        <script type="text/javascript" src="../Scripts/blockEnterEvent.js"></script>
    </form>
</body>
</html>
