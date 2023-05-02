<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_applycredit_popup.aspx.cs"
    Inherits="bluecredit_applycredit_popup" %>

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
        <telerik:radscriptmanager id="RadScriptManager1" runat="server">
        </telerik:radscriptmanager>
        <asp:UpdatePanel runat="server">
            <ContentTemplate>
                <div>
                    <table class="CareBluePopup">
                        <tr>
                            <td>
                                <h2p>Activate BlueCredit Plan</h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>Review BlueCredit plan details</h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad">
                                <table width="100%">
                                    <tr>
                                        <td>
                                            <div style="margin-left: 20px; float: left; width: 450px;">
                                                <fieldset style="height: 175px;">
                                                    <legend>Plan Details</legend>
                                                    <div class="form-row" style="margin-left: -20px;" id="divCurrentBalance" runat="server" visible="False">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label13" runat="server">Current Balance:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Label ID="lblCurrentBalanace" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="form-row" style="margin-left: -20px;">
                                                        <div class="editor-label">
                                                            <asp:Label ID="lblFinancedAmountLabel" runat="server">Financed Amount:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Label ID="lblFinancedAmount" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="form-row" style="margin-left: -20px;">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label2" runat="server">BlueCredit Plan Type:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Label ID="lblPlanType" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <br />
                                                    <div class="form-row" style="margin-left: -20px;">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label15" runat="server">Responsible Party:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <telerik:radcombobox id="cmbResponsibleParty" enabled="False" runat="server" width="200" maxheight="200"
                                                                autopostback="true" allowcustomtext="false" markfirstmatch="True" datatextfield="CarrierName"
                                                                datavaluefield="CarrierID" onselectedindexchanged="cmbResponsibleParty_SelectedIndexChanged">
                                                                </telerik:radcombobox>
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="cmbResponsibleParty"
                                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Responsible Party is required."
                                                                ErrorMessage="Responsible Party is required." ValidationGroup="BlueCreditValidationGroup">*</asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                    <div class="form-row" style="margin: 0 0px 0 -82px;">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label1" runat="server">Notes:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:TextBox ID="txtNote" TextMode="MultiLine" Width="255px" Height="50px" CssClass="textarea" Style="margin-right: -50px;" runat="server" ForeColor="#333333" Font-Size="10pt" Font-Bold="False" BackColor="#FFFFEA" Font-Names="Tahoma; Arial"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                            </div>

                                            <div style="float: right; width: 500px;">
                                                <fieldset style="height: 175px;">
                                                    <legend>Borrower Details</legend>
                                                    <div class="form-row" style="margin-left: -50px;">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label16" runat="server">Borrower Name:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Label ID="lblBorrowerName" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="form-row" style="margin-left: -50px;">
                                                        <div class="editor-label" style="margin-top: 3px;">
                                                            <asp:Label ID="Label19" runat="server">Billing Address:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <telerik:radcombobox id="cmbBillingAddress" runat="server" emptymessage="Choose Address..."
                                                                autopostback="True" width="200" maxheight="200" allowcustomtext="False" markfirstmatch="True"
                                                                datatextfield="CarrierName" datavaluefield="CarrierID" onselectedindexchanged="cmbBillingAddress_SelectedIndexChanged">
                                                                </telerik:radcombobox>
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="cmbBillingAddress"
                                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Billing Address is required."
                                                                ErrorMessage="Billing Address is required." ValidationGroup="BlueCreditValidationGroup">*</asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                    <div class="form-row" style="margin-left: -50px;">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label14" runat="server">Address:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Label ID="lblPatientAddress" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="form-row" style="margin-left: -50px;">
                                                        <div class="editor-label" style="margin-top: 3px;">
                                                            <asp:Label ID="Label11" runat="server">Phone:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <telerik:radmaskedtextbox id="txtPhone" runat="server" mask="(###) ###-####" width="149">
                                                                </telerik:radmaskedtextbox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" Display="Dynamic"
                                                                runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                                                                SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtPhone"
                                                                ValidationGroup="BlueCreditValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtPhone"
                                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Phone is required."
                                                                ErrorMessage="Phone is required." ValidationGroup="BlueCreditValidationGroup">*</asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                    <div class="form-row" style="margin-left: -50px;">
                                                        <div class="editor-label" style="margin-top: 1px;">
                                                            <asp:Label ID="Label12" runat="server">Email Bills:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:CheckBox ID="chkEmailBills" onclick="enableDisableTextBox()" runat="server" />
                                                            &nbsp;
                                                            <asp:TextBox ID="txtEmail" PlaceHolder="Enter Email..." Enabled="False" runat="server" Width="230"></asp:TextBox>
                                                            <asp:CustomValidator ID="CustomValidator1" CssClass="failureNotification" runat="server"
                                                                ControlToValidate="txtEmail" ClientValidationFunction="validateEmail" ValidateEmptyText="True"
                                                                ValidationGroup="BlueCreditValidationGroup" Display="Dynamic" ErrorMessage="Email is required."
                                                                ToolTip="Email is required.">*</asp:CustomValidator>
                                                        </div>
                                                    </div>
                                                    <div class="form-row" style="margin-left: 60px;">
                                                        <pfs6 id="emailMessage" style="margin-left: 15px; color: darkred;">Emailing statements is preferred, please inquire with the borrower.</pfs6>
                                                    </div>
                                                </fieldset>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="margin-left: 20px; float: left; width: 450px;">
                                                <fieldset style="height: 220px;">
                                                    <legend>Down Payment Options</legend>
                                                    <!--<div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label20" runat="server">Statement Amount:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Label ID="lblOrignalAmount" runat="server"></asp:Label>
                                                        </div>
                                                </div>
                                                <hr style="width: 150px; margin-left: 97px; float: left;" />-->
                                                    <div class="form-row" style="margin-bottom: 5px;">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label7" runat="server">Down Payment:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Label ID="lblDownpay" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label10" runat="server">Form of Payment:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <telerik:radcombobox id="cmbDownPayment" runat="server" width="200" maxheight="200"
                                                                emptymessage="Choose Payment..." allowcustomtext="False" markfirstmatch="True"
                                                                datatextfield="AccountName" datavaluefield="PaymentCardID">
                                                            </telerik:radcombobox>
                                                            <asp:RequiredFieldValidator ID="rqdDownPayment" runat="server" ControlToValidate="cmbDownPayment"
                                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="First Payment is required."
                                                                ErrorMessage="First Payment is required." ValidationGroup="BlueCreditValidationGroup">*</asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label4" runat="server">Apply To Statement:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <telerik:radcombobox id="cmbApplyPaymentTo" runat="server" width="200px" emptymessage="Choose Apply Payment..."
                                                                allowcustomtext="False" markfirstmatch="True" maxheight="200">
                                                            </telerik:radcombobox>
                                                            <asp:RequiredFieldValidator ID="rqdApplyPayment" runat="server" ControlToValidate="cmbApplyPaymentTo"
                                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Apply Payment To is required."
                                                                ErrorMessage="Apply Payment To is required." ValidationGroup="BlueCreditValidationGroup">*</asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                    <br />
                                                    &nbsp;
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label17" runat="server">New Payment Type:</asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        &nbsp;
                                                        <asp:ImageButton ID="btnAddPaymentMethod" ImageUrl="../Content/Images/btn_addnew_small.gif" OnClick="OnClick_AddPaymentMethod" runat="server" />
                                                    </div>
                                                </div>
                                                </fieldset>
                                            </div>
                                            <div style="float: right; width: 500px;">
                                                <fieldset style="height: 220px;">
                                                    <legend>Recurring Payments Options</legend>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label18" runat="server">Monthly Payment:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <telerik:radnumerictextbox runat="server" id="txtRegularPayment" width="100px" maxlength="10"
                                                                onchange="updateFieldsValue()" type="Currency" numberformat-decimaldigits="2"
                                                                numberformat-groupseparator="">
                                                                </telerik:radnumerictextbox>
                                                            <asp:CustomValidator ID="cstmValidateRegularPayment" runat="server" ControlToValidate="txtRegularPayment"
                                                                ValidateEmptyText="True" Display="Dynamic"
                                                                SetFocusOnError="True" CssClass="failureNotification" ToolTip="Regular Payment is Invalid."
                                                                ErrorMessage="Regular Payment is Invalid." ValidationGroup="BlueCreditValidationGroup">*</asp:CustomValidator>
                                                            <span style="margin-left: 5px;"><b>(
                                                                <asp:Label ID="Label8" runat="server">Min Payment:</asp:Label></b>
                                                                <asp:Label ID="lblMinPayment" runat="server"></asp:Label>
                                                            </span><b>)</b>
                                                            <br />
                                                            <asp:Label ID="lblRecurringPayment" runat="server"></asp:Label>
                                                            <br />
                                                            <telerik:radslider id="sldRegularPayment" runat="server" onclientvaluechanged="handleValueChanged">
                                                                </telerik:radslider>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label9" runat="server">Due Date:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <telerik:raddatepicker id="dtFirstBillDate" runat="server" calendar-skin="Windows7"
                                                                width="150" skin="Windows7" maxdate="12/31/2020">
                                                                </telerik:raddatepicker>
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="dtFirstBillDate"
                                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="First Bill Date is required."
                                                                ErrorMessage="First Bill Date is required." ValidationGroup="BlueCreditValidationGroup">*</asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                    <!-- // the only option is monthly right now, so this is hidden 
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label6" runat="server">Billing Schedule:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            // replace radcombobox here if this is again used
                                                        </div>
                                                    </div>-->
                                                    <telerik:radcombobox id="cmbBillSchedule" runat="server" width="200px" emptymessage="Choose Bill Schedule..."
                                                        allowcustomtext="False" markfirstmatch="True" maxheight="200" datavaluefield="PaymentFreqTypeID"
                                                        datatextfield="Abbr" visible="false">
                                                                </telerik:radcombobox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="cmbBillSchedule"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Bill Schedule is required."
                                                        ErrorMessage="Bill Schedule is required." ValidationGroup="BlueCreditValidationGroup">*</asp:RequiredFieldValidator>

                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label3" runat="server">Preferred Payment Method:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <telerik:radcombobox id="cmbFundingSource" runat="server" width="200" maxheight="200" autopostback="True" onselectedindexchanged="cmbFundingSource_OnChanged"
                                                                emptymessage="Choose Preferred Method..." allowcustomtext="False" markfirstmatch="True"
                                                                datatextfield="AccountName" datavaluefield="PaymentCardID">
                                                                </telerik:radcombobox>
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="cmbFundingSource"
                                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Preferred Method is required."
                                                                ErrorMessage="Preferred Method is required." ValidationGroup="BlueCreditValidationGroup">*</asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label21" runat="server">Associated Bank Account:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <telerik:radcombobox id="cmbRegularACHPayments" runat="server" emptymessage="Choose Secured Backup Method..."
                                                                width="200" maxheight="200" allowcustomtext="False" markfirstmatch="True" datatextfield="AccountName"
                                                                datavaluefield="PaymentCardID">
                                                                </telerik:radcombobox>
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="cmbRegularACHPayments"
                                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Secured Backup Method is required."
                                                                ErrorMessage="Secured Backup Method is required." ValidationGroup="BlueCreditValidationGroup">*</asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                    <div id="divCardMessage" runat="server" visible="False" style="margin: 0 10px 0 50px; color: darkred;">NOTE: Credit cards are a non-standard payment form for lender-funded plans; a convenience fee of 2.75% will be applied to each credit card payment.</div>

                                                </fieldset>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" align="right">
                                <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="BlueCreditValidationGroup"
                                    ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                    CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                                <div class="success-message">
                                    <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                                </div>
                            </td>
                        </tr>
                    </table>
                    </td> 
                </tr>
                <tr>
                    <td>
                        <asp:HiddenField ID="hdnShowTruthInLending" runat="server" />
                        <asp:HiddenField ID="hdnValues" runat="server" />
                        <asp:HiddenField ID="hdnEmail" runat="server" />
                        <asp:HiddenField ID="hdnRequestedPopup" runat="server" />
                        <asp:HiddenField ID="hdnShowRequestedPopup" runat="server" />
                        <asp:HiddenField ID="hdnEnableCloseButton" runat="server" />
                        <asp:HiddenField ID="hdnShowPopupConfirmation" runat="server" />


                        <a href="javascript:;" onclick="showAddCreditPopup()">
                            <img src="../Content/Images/btn_previous.gif" class="btn-pop-cancel" alt="Close" style="margin: -20px 0 0 30px;" /></a>
                        <a href="javascript:;" onclick="showRadConfirm()">
                            <img src="../Content/Images/btn_cancel.gif" class="btn-pop-cancel" alt="Close" style="margin: -20px 0 0 180px;" /></a>
                        <asp:ImageButton ID="btnActivate" CssClass="btn-pop-submit" ImageUrl="../Content/Images/btn_activate.gif"
                            OnClientClick="return validateFields()" runat="server" Style="margin: -20px 50px 0 0px;" />
                        <asp:Button style="display: none" ID="btnActivateBlueCredit" OnClick="btnActivate_OnClick" runat="server"/>
                    </td>
                </tr>
                    </table>
                </div>
                <asp:Button ID="btnRebindFundingSource" OnClick="RebindFundingSource" Style="display: none;"
                    runat="server" />
                <telerik:radwindowmanager id="RadWindowManager1" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                    modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    behaviors="Pin,Reload,Close,Move,Resize" restrictionzoneid="divMainContent" skin="CareBlue"
                    style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupManageAccounts" Width="750px" Height="600px"
                            NavigateUrl="~/report/pc_add_popup.aspx?ShowPaymentMethods=1" DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupConfirmationPayment" Behaviors="Close"
                            VisibleOnPageLoad="False" Width="420px" Height="340px" NavigateUrl="~/report/paymentConfirmation_popup.aspx">
                        </telerik:RadWindow>
                    </Windows>
                </telerik:radwindowmanager>
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
                                <div style="margin-top: 15px; margin-left: 55px;">
                                    <a href="Javascript:;" onclick="$find('{0}').close(true);">
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
                            <div style="margin-top: 20px; margin-left: 76px;">
                                <a href="#" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            </div>
                        </div>
                    </AlertTemplate>
                </telerik:radwindowmanager>
                <telerik:radwindow runat="server" id="popupMessage" visibletitlebar="True" visiblestatusbar="false"
                    behaviors="None" restrictionzoneid="divMainContent" enableembeddedskins="False"
                    skin="CareBlueInf" borderstyle="None" borderwidth="0" modal="true" width="490" height="330px">
                    <ContentTemplate>
                        <div id="divMessage" align="center">
                            <br />
                            <h5>
                                <% if (!Convert.ToBoolean(ViewState["IsNewBluecreditPlan"]))
                                   { %>

                                <asp:Label ID="Label5" Text="<br>The selected statements have been assigned. <br>Please print an updated payment schedule for the patient."
                                    runat="server"></asp:Label>
                                <br />
                                <br />
                                <img style="margin-bottom:-2px;" id="imgps" runat="server" alt="UnRead" src="../Content/Images/icon_checkbox_open.gif"/> &nbsp; 
                                <a href="javascript:;" onclick="updateValuesForRequestedPopup('ps')">
                                    <img src="../Content/Images/btn_paymentschedule.gif" alt="Payment Schedule" /></a> 
                                &nbsp; <br />

                                <% }
                                   else
                                   { %>
                                   <asp:Label ID="lblPopupMessage" Text="<br><b>The BlueCredit account has been successfully created.</b><br><br>The borrower MUST SIGN EACH DOCUMENT to finalize the loan. <br>A copy of each document may be printed for review prior to signing."
                                    runat="server"></asp:Label>
                                <br />
                                <br />
                                <table>
                                    <tr valign="top">
                                        <td align="right">
                                            <asp:Label ID="docLA" Text="Credit Agreement:&nbsp; &nbsp;" runat="server"></asp:Label>
                                        </td>
                                        <td>
                                            <img id="imgla" style="margin-top:-6px;" runat="server" alt="UnRead" src="../Content/Images/icon_checkbox_open.gif"/> &nbsp;
                                        </td>
                                        <td>
                                            <a href="javascript:;" onclick="updateValuesForRequestedPopup('la')"><img src="../Content/Images/btn_bcla_sign.gif" alt="Account Agreement" /></a> &nbsp; 
                                        </td>
                                        <td>
                                            <a href="javascript:;" onclick="showPDfViewer('la')"><img src="../Content/Images/btn_print_small.gif" alt="Print" /></a> 
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                        <td align="right">
                                            <asp:Label ID="docPN" Text="Promissory Note:&nbsp; &nbsp;" runat="server"></asp:Label>
                                        </td>
                                        <td>
                                            <img id="imgpn" style="margin-top:-6px;" runat="server" alt="UnRead" src="../Content/Images/icon_checkbox_open.gif"/> &nbsp;
                                        </td>
                                        <td>
                                            <a href="javascript:;" onclick="updateValuesForRequestedPopup('pn')"><img src="../Content/Images/btn_bcpn_sign.gif" alt="Promissory Note" /></a> &nbsp;
                                        </td>
                                        <td>
                                            <a href="javascript:;" onclick="showPDfViewer('pn');"><img src="../Content/Images/btn_print_small.gif" alt="Print" /></a> 
                                        </td>
                                    </tr>
                                    <tr valign="top">
                                        <td align="right">
                                            <asp:Label ID="docTIL" Text="Truth In Lending:&nbsp; &nbsp;" runat="server"></asp:Label>
                                        </td>
                                        <td>
                                            <img id="imgtil" style="margin-top:-6px;" runat="server" alt="UnRead" src="../Content/Images/icon_checkbox_open.gif"/> &nbsp;
                                        </td>
                                        <td>
                                            <a href="javascript:;" onclick="updateValuesForRequestedPopup('til')"><img src="../Content/Images/btn_bctil_sign.gif" alt="Truth In Lending" /></a> &nbsp; 
                                        </td>
                                        <td>
                                            <a href="javascript:;" onclick="showPDfViewer('til');"><img src="../Content/Images/btn_print_small.gif" alt="Print" /></a> 
                                        </td>
                                    </tr>

                                <% }  %>
                              
                                <% if (DownPayment > 0)
                                   {  %>
                                    <tr valign="top">
                                        <td align="right">
                                            <asp:Label ID="receipt" Text="Down Payment:&nbsp; &nbsp;" runat="server"></asp:Label>
                                        </td>
                                        <td>
                                            <img id="imgSign" style="margin-top:-6px;" runat="server" alt="UnRead" src="../Content/Images/icon_checkbox_open.gif"/> &nbsp;
                                        </td>
                                        <td>
                                            <a href="javascript:;" onclick="updateValuesForRequestedPopup('sign')"><img src="../Content/Images/btn_bcpay_sign.gif" alt="Sign" /></a> &nbsp; 
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="btnPrintReceipt" ImageUrl="../Content/Images/btn_print_small.gif" OnClick="btnPrintReceipt_OnClick"  AlternateText="Print" runat="server"/>
                                        </td>
                                    </tr>
                                <%  } %>
                                </table>
                                  
                                <br />
                                <asp:ImageButton ID="btnClose" runat="server" ImageUrl="../Content/Images/btn_close_fade.gif"
                                    OnClientClick="return setValue()" />
                                
                                </h5>
                        </div>
                    </ContentTemplate>
                </telerik:radwindow>
                <asp:Button ID="btnSetValue" Style="display: none;" OnClick="btnClose_OnClick" runat="server" />
                <asp:Button ID="btnUpdateValues" Style="display: none;" OnClick="btnUpdateValues_OnClick"
                    runat="server" />
                <asp:Button ID="btnUpdateValuesShowPrintPopup" Style="display: none;" OnClick="btnUpdateValuesShowPrintPopup_OnClick"
                    runat="server" />
                <asp:Button ID="btnAssignValues" Style="display: none;" OnClick="btnAssignValues_Click"
                    runat="server" />

                <asp:HiddenField ID="hdnFileName" runat="server" />
                <asp:HiddenField ID="hdnIsShowPdfViewer" runat="server" />
                <asp:HiddenField ID="hdnClosePopup" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
        <script src="../Scripts/BigDecimal.js" type="text/javascript"></script>
        <script src="../Scripts/date.js" type="text/javascript"></script>
        <script type="text/javascript" language="javascript">

            $(document).ready(function () {
                showHideEmailMessage();
            });

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {
                $(function () {

                    if ($("#<%=hdnShowTruthInLending.ClientID %>").val() == "1") {
                        $find("<%=popupMessage.ClientID %>").show();
                    }


                    if ($("#<%=hdnClosePopup.ClientID %>").val() == "1") {
                        closePopup();
                        $("#<%=hdnClosePopup.ClientID %>").val("");
                    }

                    if ($("#<%=hdnShowRequestedPopup.ClientID %>").val() == "1") {
                        showRequestedPopup();
                        $("#<%=hdnShowRequestedPopup.ClientID %>").val("");
                    }

                    if ($("#<%=hdnEnableCloseButton.ClientID %>").val() == "1") {
                        $("#<%= btnClose.ClientID %>").removeAttr("disabled");
                        document.getElementById("<%= btnClose.ClientID %>").src = "../Content/Images/btn_close.gif";
                    }


                    if ($("#<%=hdnShowPopupConfirmation.ClientID %>").val() == "1") {
                        $find("<%=popupConfirmationPayment.ClientID %>").show();
                        $("#<%=hdnShowPopupConfirmation.ClientID %>").val("");
                    }

                    if ($("#<%=hdnIsShowPdfViewer.ClientID %>").val() == "1") {
                        GetRadWindow().BrowserWindow.viewPdfViewer($("#<%=hdnFileName.ClientID %>").val());
                        $("#<%=hdnIsShowPdfViewer.ClientID %>").val("");
                    }

                    if ($("#<%=hdnEnableCloseButton.ClientID %>").val() != "1")
                        $("#<%= btnClose.ClientID %>").attr("disabled", "disabled");

                    $("#<%=chkEmailBills.ClientID %>").click(function () {
                        enableDisableTextBox();
                    });

                    showHideEmailMessage();
                    GetRadWindow().BrowserWindow.unBlockUI();
                });
            });


            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
                else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

                return oWindow;
            }

            function closePopup() {
                GetRadWindow().BrowserWindow.showProgressPopup();
                GetRadWindow().close();
            }


            function showTruthInLendingPopup() {
                GetRadWindow().BrowserWindow.closeApplyCreditPopupandShowTruthInLending();
            }

            function showPromissoryNotePopup() {
                GetRadWindow().BrowserWindow.showPromissoryNotePopup();
            }

            function showBlueCreditTransactionHistory() {
                GetRadWindow().BrowserWindow.showBlueCreditTransactionHistory();
            }

            function updateFieldsValue() {
                calcRemainingPayments();
                setSliderValue();
            }


            function enableDisableTextBox() {
                var isChecked = $('#<%=chkEmailBills.ClientID %>').is(":checked");
                var email = $("#<%=txtEmail.ClientID %>");
                if (isChecked) {
                    email.removeAttr('disabled');
                }
                else {
                    email.attr('disabled', 'disabled');
                    $("#<%=txtEmail.ClientID %>").val($("#<%=hdnEmail.ClientID %>").val());
                }

                showHideEmailMessage();
            }

            function showHideEmailMessage() {
                var isChecked = $('#<%=chkEmailBills.ClientID %>').is(":checked");
                if (!isChecked) {
                    $("#emailMessage").show();
                } else {
                    $("#emailMessage").hide();
                }
            }

            function validateEmail(sender, args) {
                var isChecked = $('#<%=chkEmailBills.ClientID %>').is(":checked");
                if (isChecked && args.Value.trim().length < 5) {
                    args.IsValid = false;
                    return;
                }
                else {
                    args.IsValid = true;
                    return;
                }
            }

            function validateFields() {

                var isPageValid = false;
                var downPayment = parseFloat('<%=DownPayment %>'); // parseFloat($("#<%=lblDownpay.ClientID %>").text().replace('$', ''));
                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('BlueCreditValidationGroup');
                }
                
                if (isPageValid) {
                    if (downPayment > 0) {
                        $("#<%=btnAssignValues.ClientID %>").click();
                    } else {
                        GetRadWindow().BrowserWindow.blockUI();
                        return true;
                    }
                    return false;
                }
            }

            function setValue() {
                $("#<%=btnSetValue.ClientID%>").click();
                return false;
            }


            function openPaymentTerms() {
                GetRadWindow().BrowserWindow.gotoPrivacyTerms();
            }



            function genericFunction() {
                $("#<%=btnRebindFundingSource.ClientID %>").click();
            }

            function processPayment(isAllowProcess) {
                $find("<%=popupConfirmationPayment.ClientID%>").close();
                if (isAllowProcess) {
                    GetRadWindow().BrowserWindow.blockUI();
                    $("#<%=btnActivateBlueCredit.ClientID %>").click();
                }
            }


            function showRequestedPopup() {
                var value = $("#<%=hdnRequestedPopup.ClientID%>").val();
                if (value == 'la') {
                    GetRadWindow().BrowserWindow.showBluecreditApplicationPopup();
                }
                else if (value == 'pn') {
                    GetRadWindow().BrowserWindow.showPromissoryNotePopup();
                }
                else if (value == 'til') {
                    GetRadWindow().BrowserWindow.showTruthInLendingPopup();
                }
                else if (value == 'ps') {
                    showBlueCreditTransactionHistory();
                }
                else {
                    showPaymentReceiptPopup();
                }
            }


            function showPaymentReceiptPopup() {
                GetRadWindow().BrowserWindow.showPaymentPopup();
            }

            function updateValuesForRequestedPopup(fileToBeOpen) {
                $("#<%=hdnRequestedPopup.ClientID%>").val(fileToBeOpen);
                $("#<%=btnUpdateValues.ClientID %>").click();
            }



            function calcRemainingPayments() {

                //Default Values
                var oneDay = 24 * 60 * 60 * 1000; //necessary to get diffDays
                var APRDiv = new BigDecimal("36500");
                var BDOne = new BigDecimal("1"); //need all values to be in BigDecimal datatype
                var NumDays = new BigDecimal("31"); //Default, will set to actual Days Diff
                var remainingCycles = 0;

                //Convert to BigDecimal
                var values = $("#<%=hdnValues.ClientID %>").val().split(',');
                var financedAmount = new BigDecimal(values[0].toString());
                var ratepromo = new BigDecimal(values[1].toString());
                ratepromo = ratepromo.divide(APRDiv, new MathContext(20));
                ratepromo = ratepromo.add(BDOne);

                var ratestd = new BigDecimal(values[4].toString());
                ratestd = ratestd.divide(APRDiv, new MathContext(20));
                ratestd = ratestd.add(BDOne);
                var cycle = values[1];
                var termpromo = values[3];
                var termmax = values[5];

                var object = $find("<%=txtRegularPayment.ClientID %>");
                var minPayment = new BigDecimal(object.get_value().toString());

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

                $("#<%=lblRecurringPayment.ClientID %>").text("This plan will be paid off in " + remainingCycles + " payments");
            }

            function validateCancel(isCancel) {
                if (isCancel) {
                    closePopup();
                }
            }

            function showRadConfirm() {
                radconfirm('Are you sure you want to cancel? This will exit the BlueCredit process and progress will be lost.', validateCancel, 400, 150, null, '', "../Content/Images/warning.png");
                return false;
            }

            // For Slider use

            function setSliderValue() {
                var slider = $find("<%=sldRegularPayment.ClientID%>");
                var downPayment = $find("<%=txtRegularPayment.ClientID%>");
                var newValue = downPayment.get_value();
                if (isNaN(parseFloat(newValue))) return;
                if (slider.get_isSelectionRangeEnabled()) {
                    slider.set_selectionStart(newValue);
                }
                else {
                    slider.set_value(newValue);
                }
            }

            function handleValueChanged(sender, eventArgs) {
                var downPayment = $find("<%= txtRegularPayment.ClientID %>");
                downPayment.set_value(sender.get_value());
                calcRemainingPayments();
            }

            function showAddCreditPopup() {
                GetRadWindow().BrowserWindow.showAddCreditPopup();
            }

            function showPDfViewer(fileName) {
                $("#<%=hdnFileName.ClientID %>").val(fileName);
            $("#<%=btnUpdateValuesShowPrintPopup.ClientID %>").click();
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
