<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_addcredit_popup.aspx.cs"
    Inherits="bluecredit_addcredit_popup" %>

<%@ Register Src="~/Controls/Bluecredit/BCCreditScore.ascx" TagName="CreditScore" TagPrefix="BC" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="../Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
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
                                <h2p>Select BlueCredit Plan</h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>Available BlueCredit plans are listed below. Patients are limited to one active Lender Funded plan at a time.</h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad">
                                <table>
                                    <tr>
                                        <td width="700">
                                            <table width="100%" border="0">
                                                <tr>
                                                    <td colspan="1">
                                                        <div class="form-row" style="margin: 10px 0px 0px 0px;">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label1" runat="server" Text="Statement(s) Balance:"></asp:Label>
                                                            </div>
                                                            <b style="font-size: 13px;">
                                                                <asp:Label ID="lblStatementBalance" runat="server"></asp:Label></b>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="300">
                                                        <div class="form-row" style="margin-left: 0px;">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label2" runat="server" Text="Down Payment:"></asp:Label>
                                                            </div>
                                                            <telerik:radnumerictextbox runat="server" id="txtDownPayment" width="100px" maxlength="10"
                                                                enabled="False" type="Currency" numberformat-decimaldigits="2" numberformat-groupseparator="," autopostback="True" onkeydown="downpaymentOnKeyDown(event);" ontextchanged="txtDownPayment_OnChange">
                                                            </telerik:radnumerictextbox>
                                                            <asp:RequiredFieldValidator ID="rqdDownPayment" runat="server" ControlToValidate="txtDownPayment"
                                                                CssClass="failureNotification" Display="Dynamic" SetFocusOnError="True" ToolTip="Down Payment is required."
                                                                ErrorMessage="Down Payment is required." ValidationGroup="DownPayment">*</asp:RequiredFieldValidator>
                                                            <asp:RangeValidator ID="rngDownPayment" ControlToValidate="txtDownPayment" CssClass="failureNotification"
                                                                Type="Double" Display="Dynamic" SetFocusOnError="True" ValidationGroup="DownPayment"
                                                                Text="*" runat="server"></asp:RangeValidator>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div id="trOverideMimimumDownPayment" runat="server" visible="False" class="form-row" style="margin: 0px 0px 3px 0px;">
                                                            <asp:CheckBox ID="chkOverideMinimumDownpayment" OnCheckedChanged="chkOverideMinimumDownpayment_OnCheckChanged"
                                                                AutoPostBack="True" runat="server" />
                                                            Override Practice Minimum 
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="1">
                                                        <div class="form-row" style="margin-left: 0;">
                                                            <div class="editor-label">
                                                                <asp:Label ID="Label3" runat="server" Text="Financed Amount:"></asp:Label>
                                                            </div>
                                                            <telerik:radnumerictextbox runat="server" id="txtFinancedAmount" enabled="False"
                                                                width="100" type="Currency" numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                                            </telerik:radnumerictextbox>
                                                        </div>
                                                    </td>
                                                    <td valign="top" >
                                                        <div class="form-row" style="margin: 0px 0px 0px 0px; display:none">
                                                            <asp:CheckBox ID="chkRecalculateLoan" AutoPostBack="True" Checked="True" OnCheckedChanged="chkRecalculateLoan_OnCheckChanged" runat="server" />
                                                            Reprocess available loan options based on updates to financed amount
                                                        </div>
                                                        <span style="margin: 0px 10px 0px 0px;" id="spanFailureNotification" class="failureNotification" runat="server"></span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td>
                                              <div style="color:#333333; font-size:1.2em; font-weight:600; margin:0px 0px 5px 0px;">Active Patient Credit Profile -</div>
                                              <div style="margin:0px 0px -20px 0px;"><BC:CreditScore runat="server" /></div>
                                        </td>
                                    </tr>
                                </table>
                                <br />
                                <% if (ClientSession.BCLenderFlagLive)
                                   { %>

                                <h3 style="margin: -10px 0 3px 0;">Pre-Qualified BlueCredit (Lender Funded)</h3>
                                <div>
                                    <telerik:radgrid id="grdBlueCreditLenderFunded" runat="server" allowsorting="True" allowpaging="True" onneeddatasource="grdBlueCreditLenderFunded_NeedDataSource"
                                        pagesize="10">
                                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="CreditTypeID,LenderID,PlanName,MinDownPay,MaxDownPay,MinPayRate,MinPayDollar,RatePromo,TermPromo,RateStd,TermStd,RateAPR,TermMax,BlueCreditID,AgreementPDFFile,PrivacyPDFFile,LenderID" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No plans are available for this loan configuration, or the patient already has an active lender agreement.<br>&nbsp;">
                                            <Columns>
                                                <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderText="Select" AllowFiltering="False">
                                                    <HeaderStyle Width="30px" />
                                                    <ItemTemplate>
                                                        <asp:RadioButton ID="rdbChoose" CssClass="rdChoose" GroupName="Plan" AutoPostBack="True"
                                                            onclick='isExistingCreditPlan(false, this)' OnCheckedChanged="rdb_OnCheckedChanged"
                                                            runat="server"></asp:RadioButton>
                                                        <asp:Label ID="lblCreditTypeID" Style="display: none;" Text='<%#Bind("CreditTypeID")%>' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn HeaderText="Plan Name" DataField="PlanName">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Base APR" DataField="RateAPRAbbr">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Default" DataField="RateDefaultAbbr">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Term" DataField="TermMaxAbbr">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn HeaderText="Payment">
                                                    <HeaderStyle Width="90px" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblMinPayments" Text='' runat="server"></asp:Label> /mo
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Interest">
                                                    <HeaderStyle Width="90px" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbltotalInterest" Text='' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Total Due">
                                                    <HeaderStyle Width="100px" />
                                                     <ItemTemplate>
                                                        <asp:Label ID="lblTotalPayments" Text='' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn HeaderText="Lender Fee" DataField="OriginationFeeAbbr">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Reimbursement" DataField="ReimbursementAbbr">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Funding" DataField="AvgDaysToFund">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn HeaderText="Y1 Return" Display="false" Visible="False">
                                                    <HeaderStyle Width="90px" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblEffectiveAPR" Text='' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:radgrid>
                                </div>
                                <br />
                                <div id="divLenderFundingWarning" runat="server" style="margin:-10px 0px 15px 20px;">
                                    <img alt="Warning" src="../Content/Images/warning.png" height="20" style="margin-bottom:-5px;"/>&nbsp;
                                    <span style="color:#333333; margin-top:25px;">Lender funded plans may also be limited because the required down payment is not met or the total financed amount exceeds the maximum for the credit profile.</span>
                                </div>
                                <% } %>

                                <br />
                                <h3 style="margin: -10px 0 3px 0;">Practice Originated Loans (Self Funded)</h3>
                                <div>
                                    <telerik:radgrid id="grdBlueCredit" runat="server" allowsorting="True" allowpaging="True" onneeddatasource="grdBlueCredit_NeedDataSource"
                                        pagesize="10">
                                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="CreditTypeID,PlanName,MinDownPay,MaxDownPay,MinPayRate,MinPayDollar,RatePromo,TermPromo,RateStd,TermStd,RateAPR,TermMax,BlueCreditID,AgreementPDFFile,PrivacyPDFFile" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No practice plans have been configured which match this patient's credit profile.<br>&nbsp;">
                                            <Columns>
                                                <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderText="Select" AllowFiltering="False">
                                                    <HeaderStyle Width="30px" />
                                                    <ItemTemplate>
                                                        <asp:RadioButton ID="rdbChoose" CssClass="rdChoose" GroupName="Plan" AutoPostBack="True"
                                                            onclick='isExistingCreditPlan(false, this)' OnCheckedChanged="rdb_OnCheckedChanged"
                                                            runat="server"></asp:RadioButton>
                                                        <asp:Label ID="lblCreditTypeID" Style="display: none;" Text='<%#Bind("CreditTypeID")%>' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn HeaderText="Plan Name" DataField="PlanName">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Promo" DataField="RatePromoAbbr">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Promo Term" DataField="TermPromoAbbr">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Standard" DataField="RateStdAbbr">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Standard Term" DataField="TermStdAbbr">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Loan APR" DataField="RateAPRAbbr">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Total Term" DataField="TermMaxAbbr">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn HeaderText="Payment">
                                                    <HeaderStyle Width="90px" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblMinPayments" Text='' runat="server"></asp:Label> /mo
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Interest">
                                                    <HeaderStyle Width="90px" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbltotalInterest" Text='' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Total Due">
                                                    <HeaderStyle Width="100px" />
                                                     <ItemTemplate>
                                                        <asp:Label ID="lblTotalPayments" Text='' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Y1 Return" Visible="false">
                                                    <HeaderStyle Width="90px" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblEffectiveAPR" Text='' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:radgrid>
                                </div>
                                <p id="divMessage" runat="server" style="color: red" visible="False">
                                </p>

                                <br />
                                <h3 style="margin: 5px 0px 3px 0px;">Add to Existing Loan</h3>
                                <div>
                                    <telerik:radgrid id="grdExistingCreditPlan" runat="server" allowsorting="True" allowpaging="True"
                                        onitemdatabound="grdExistingCreditPlan_ItemDataBound" onneeddatasource="grdExistingCreditPlan_NeedDataSource"
                                        pagesize="10">
                                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="PlanName, MinDownPay,MaxDownPay,CreditTypeID,BlueCreditID,FlagCreditEligible,RatePromo,TermPromo,RateStd,TermStd,TermMax,MinPayDollar,MinPayRate, Balance, CreditAvail, LastCycle, AgreementPDFFile,PrivacyPDFFile" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; This patient has no currently active loans with the practice.<br>&nbsp;">
                                            <Columns>
                                                <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderText="Select" DataField="BlueCreditID"
                                                    AllowFiltering="False">
                                                    <HeaderStyle Width="30px" />
                                                    <ItemTemplate>
                                                        <asp:RadioButton ID="rdbChooseExistingCreditPlan" GroupName="Choose" AutoPostBack="True"
                                                            CssClass="rdbChooseExistingPlan" onclick='isExistingCreditPlan(true, this)' OnCheckedChanged="rdb_OnCheckedChanged"
                                                            runat="server"></asp:RadioButton>
                                                        <asp:Label ID="lblBlueCredit" Style="display: none;" Text='<%#Bind("BlueCreditID")%>' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn HeaderText="Plan Name" DataField="PlanName">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Open Date" DataField="OpenDate">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Remaining" DataField="TermRemainAbbr">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Credit Limit" DataField="CreditLimit$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Balance" UniqueName="ExistingBalance" DataField="Balance$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Avail Credit" DataField="CreditAvail$" ItemStyle-BackColor="#D5FFD5" >
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Min Down" DataField="MinDownPay$" ItemStyle-BackColor="#FFEFEC" >
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn HeaderText="New Payment" UniqueName="MinAmount">
                                                    <HeaderStyle Width="90px" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblMinPayments" Text='' runat="server"></asp:Label> /mo
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Interest">
                                                    <HeaderStyle Width="100px" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="lbltotalInterest" Text='' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Total Due">
                                                    <HeaderStyle Width="90px" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblTotalPayments" Text='' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Y1 Return" Visible="false">
                                                    <HeaderStyle Width="90px" />
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblEffectiveAPR" Text='' runat="server"></asp:Label>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:radgrid>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:HiddenField ID="hdnID" runat="server" />
                                <asp:HiddenField ID="hdnIsExistingCreditplan" runat="server" />
                                <asp:HiddenField ID="hdnCreditTypeID" runat="server" />
                                <asp:HiddenField ID="hdnBlueCreditID" runat="server" />
                                <asp:HiddenField ID="hdnPlanType" runat="server" />
                                <asp:HiddenField ID="hdnValues" runat="server" />
                                <asp:HiddenField ID="hdnFinancedAmount" runat="server" />
                                <asp:ImageButton ID="btnClose" ImageUrl="../Content/Images/btn_cancel.gif" CssClass="btn-pop-cancel"
                                    OnClientClick="return showRadConfirm()" runat="server" />
                                <asp:ImageButton ID="btnActivateCredit" ImageUrl="../Content/Images/btn_next.gif"
                                    OnClientClick="return validatePage()" CssClass="btn-pop-submit" Enabled="False"
                                    runat="server" OnClick="btnActivateCredit_Click" />
                            </td>
                        </tr>
                    </table>
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="DownPayment"
                        ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                        CssClass="failureNotification" HeaderText="Please fix the following before submitting: <br>" />
                </div>
                <telerik:radwindowmanager id="RadWindowManager1" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                    modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    restrictionzoneid="divMainContent" skin="CareBlue"
                    style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupBlueCreditAccountValidation" Behaviors="None"
                            VisibleOnPageLoad="False" Width="600px" Height="630px" NavigateUrl="~/report/bluecredtAccountValidation_popup.aspx">
                        </telerik:RadWindow>
                    </Windows>
                </telerik:radwindowmanager>
                <telerik:radwindowmanager id="RadAlertManager" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px" Behaviors="None"
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
                                    <a href="Javascript:;"
                                            onclick="$find('{0}').close(true);">
                                            <img src="../Content/Images/btn_yes_small.gif" alt="Yes" /></a>  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
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
                            <div style="margin-top: 20px; margin-left: 90px;">
                                <a href="javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            </div>
                        </div>
                    </AlertTemplate>
                </telerik:radwindowmanager>
            </ContentTemplate>
        </asp:UpdatePanel>
        <script src="../Scripts/date.js" type="text/javascript"></script>
        <script src="../Scripts/BigDecimal.js" type="text/javascript"></script>
        <script src="../Scripts/accounting.min.js" type="text/javascript"></script>
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
                GetRadWindow().BrowserWindow.showProgressPopup();
                GetRadWindow().close();
            }


            function calculateFinancedAmount(enteredDownPayment) {
                var statementBalance = parseFloat('<%= ClientSession.SelectedStatementBalance %>');
                var balance = statementBalance - enteredDownPayment;
                var financedAmount = $find("<%= txtFinancedAmount.ClientID %>");
                financedAmount.set_value(balance);
            }

            function isExistingCreditPlan(isExisitngGrid, obj) {

                var ID = obj.id.replace(isExisitngGrid ? "rdbChooseExistingCreditPlan" : "rdbChoose", isExisitngGrid ? "lblBlueCredit" : "lblCreditTypeID");
                var hdnIdObj = $("#<%=hdnID.ClientID %>");
                var newIdObj = $("#" + ID);

                if (parseInt(hdnIdObj.val()) != parseInt(newIdObj.text())) {
                    $("#<%=hdnIsExistingCreditplan.ClientID%>").val(isExisitngGrid);
                    hdnIdObj.val(newIdObj.text());
                    GetRadWindow().BrowserWindow.blockUI();
                }

            }
            

            function downpaymentOnKeyDown(e) {
                console.log(e.keyCode);
                if (e.keyCode == 13) {
                    $("#<%=txtDownPayment.ClientID%>").blur();
                }
            }

            function closeApplyBlueCreditPopup() {

            }

            function validatePage() {
                var isPageValid = false;

                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('DownPayment');
                }

                return isPageValid;
            }

            function validateCancel(isCancel) {
                if (isCancel) {
                    closePopup();
                }
            }

            function showRadConfirm() {
                radconfirm('Are you sure you want to cancel? This will exit the BlueCredit process and all changes will be lost.', validateCancel, 450, 150, null, '', "../Content/Images/warning.png");
                return false;
            }

            function redirectToRequestedPage(page) {
                GetRadWindow().BrowserWindow.redirectToRequestedPage(page);
                GetRadWindow().close();
            }
            
            function showApplyCreditPopup() {
                GetRadWindow().BrowserWindow.showApplyCreditPopup();
            }


        </script>
        <script type="text/javascript" src="../Scripts/blockEnterEvent.js"></script>
        <script type="text/javascript">
            window.alert = function (string) {
                var reg = new RegExp("\\-", "g");
                var messages = string.replace(reg, "<br />").replace("Please correct the following inputs before re-submitting your request:", "Please correct the following inputs before re-submitting your request: - <br />");
                var radWindow = $find("<%=RadAlertManager.ClientID %>");
                radWindow.radalert(messages, 400, 100, '', "", "../Content/Images/warning.png");
            }

        </script>
    </form>
</body>
</html>
