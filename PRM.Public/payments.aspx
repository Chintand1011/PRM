<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="payments.aspx.cs"
    Inherits="payments_statement" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <%--<telerik:RadAjaxPanel runat="server" ID="RadAjaxPanel">--%>
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnDownload" />
        </Triggers>
        <ContentTemplate>
            <div class="pgColumn1">
                <h2>Explanation of Page</h2>
                <h4>See outstanding balances and recent payments here.</h4>
                <h5>Insurance reimbursements and web payments are reflected in the patient portal immediately. If you have questions about statement charges, contact your provider. The number for billing support can be found on the welcome page or on any statement.
                    <br />
                    <br />
                    <b>Did you know?</b>
                    <% if (ClientSession.IsAllowBlueCredit)
                       { %>
                    <br />
                    Your provider offers financing options! Pay over several months using the Payment Plan option, or ask your provider about a BlueCredit account for larger balances.
            <% }
                       else if (ClientSession.IsAllowPaymentPlans)
                       { %>
                    <br />
                    Your provider offers the option to pay large balances over several months! Click on Payment Plans in the menu to see if any statements qualify for this feature.
            <% }
                       else
                       { %>
                    <br />
                    By adding your email address, you'll automatically get copies of statements and payment receipts electronically!
            <% }  %>
            </div>
            <div class="pgColumn2">
                <h1>Payment Center
                </h1>
                <div id="paymentGrids">
                    <h3>Outstanding Balances</h3>
                    <p style="margin-top: -5px; font-size: 1.2em; color: #444444;"><i>"Pay Over Time" statements are automatically paid to keep your status in good standing, however additional payments may be made at anytime.</i></p>
                    <telerik:radgrid id="grdMakePayments" runat="server" allowsorting="True" allowpaging="True"
                        onitemdatabound="grdMakePayments_ItemDataBound" pagesize="10" onneeddatasource="grdMakePayments_NeedDataSource"
                        allowmultirowselection="true" onitemcommand="grdMakePayments_OnItemCommand">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID, Balance, FlagAcceptPtPay, FilePathStatements, FileName,FlagAutoPay" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; You have no current statements with a balance. Please check with your provider if you are expecting a payment due after your visit or procedure.<br>&nbsp;">
                                <SortExpressions>
                                    <telerik:GridSortExpression FieldName="DueDate" SortOrder="Ascending" />
                                </SortExpressions>
                            <Columns>
                                <%--
                                <telerik:GridBoundColumn HeaderText="Payment Date" DataField="LastPaymentDate">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Next Payment" DataField="NextPayAmount">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderAbbr">
                                </telerik:GridBoundColumn>
                                --%>
                                <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Charges" DataField="Charges$" SortExpression="Charges">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Insurance" DataField="Insurance$">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Payments" DataField="Payments$" SortExpression="Payments">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                </telerik:GridBoundColumn>
                                <telerik:GridTemplateColumn>
                                    <ItemTemplate>
                                        <asp:Label ID="lblBalance" Text='<%# Bind("Balance") %>' Style="display: none;" runat="server"></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn HeaderText="Due Date" DataField="DueDate">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Last Payment" DataField="LastPayment$">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridTemplateColumn HeaderText="Pay Over Time" AllowFiltering="False">
                                    <ItemTemplate>
                                        <asp:Image ID="imgAutoPay" runat="server" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridTemplateColumn UniqueName="Amount" HeaderText="Amount" AllowFiltering="False">
                                    <ItemTemplate>
                                        <telerik:RadNumericTextBox runat="server" ID="txtAmount" Width="80px" Height="20"
                                            onchange="return validatePaymentAmount()" CssClass="sumamount"
                                            Type="Currency" NumberFormat-DecimalDigits="2" NumberFormat-GroupSeparator=",">
                                        </telerik:RadNumericTextBox>
                                        <asp:Label ID="lblError" CssClass="label-errors" title="Please enter your amount less than or equal to balance"
                                            Text="" Style="color: red;" runat="server"></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridButtonColumn CommandName="Download" HeaderText="View" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_pdfblue.gif">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>
                    <asp:HiddenField ID="hdnGridRowsCount" runat="server" />
                    <asp:HiddenField ID="hdnActiveMakePaymentsRows" runat="server" />
                    <div id="divPaymentMethods" runat="server" style="padding-top: 10px" visible="False">
                        <div class="form-row">
                            <div class="editor-label" style="margin-top: 3px;">
                                <asp:Label runat="server">Payment Method:</asp:Label>
                            </div>
                            <div class="editor-field">
                                <telerik:radcombobox id="cmbPaymentMethods" runat="server" width="200px" datatextfield="AccountName"
                                    allowcustomtext="False" markfirstmatch="True" datavaluefield="PaymentCardID"
                                    autopostback="True" maxheight="200">
                                </telerik:radcombobox>
                                &nbsp;
                            </div>
                            <div style="float: left; margin-top: 3px;">
                                <a href="javascript:;" onclick="showManageAccountPopup()" style="text-decoration: none;">
                                    <img src="Content/Images/icon_add.png" alt="New" class="btn-new" />
                                    <div style="margin: -20px 0 0 22px; font-size: 1.2em;">Add New</div>
                                </a>
                            </div>
                            <div style="float: right; margin-right: 25px;">
                                <div class="editor-label" style="margin-top: 3px;">
                                    <asp:Label runat="server">Total Amount:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:HiddenField ID="hdnPaymentMethodsCount" runat="server" />
                                    <telerik:radnumerictextbox runat="server" id="txtTotalAmount" width="80px" readonly="True"
                                        type="Currency" numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                    </telerik:radnumerictextbox>
                                    <br />
                                    <asp:ImageButton ID="btnConfirmPayment" ImageUrl="Content/Images/btn_confirmpay_orange_fade.gif" OnClientClick="return validateAndSubmitPayment();"
                                        Style="margin-top: 6px;" runat="server" OnClick="btnConfirmPayment_OnClick" />
                                </div>
                                <%--<div id="divSuccessMessage" class="success-message" style="text-align: center">
                                    <asp:Literal ID="litPaymentConfirmationMessage" Text="" runat="server"></asp:Literal>
                                </div>--%>
                            </div>
                        </div>
                    </div>
                    <%-- <div class="failureNotification" align="center">
                        <ul>
                            <li>Please enter a positive amount up to the statement balance.
                            </li>
                        </ul>
                    </div>--%>
                    <div id="divPendingPaymentsGrid" runat="server">
                        <h3>Pending Payments <font style="font-size: 0.8em; color: #444444;"><i>(Next 3 Months)</i></font></h3>
                        <telerik:radgrid id="grdPendingPayments" runat="server" allowsorting="True" allowpaging="True"
                            pagesize="10" onneeddatasource="grdPendingPayments_NeedDataSource" onitemcommand="grdPendingPayments_OnItemCommand">
                            <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID, Balance, BlueCreditID, PaymentPlanID" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; You have no scheduled payments pending. Automatic payments as part of a pay over time plan will show here prior to processing.<br>&nbsp;">
                                <SortExpressions>
                                    <telerik:GridSortExpression FieldName="NextPayDate" SortOrder="Ascending" />
                                </SortExpressions>
                                <Columns>
                                    <%--
                                    <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderAbbr">
                                    </telerik:GridBoundColumn>
                                    --%>
                                    <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Due Date" DataField="DueDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Pay Date" DataField="NextPayDate" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Amount" DataField="NextPayAmount$" SortExpression="NextPayAmount">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Plan Type" DataField="PPorBC">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Payment Account" DataField="AccountName">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridButtonColumn CommandName="EditPayment" HeaderText="Manage" ButtonType="ImageButton"
                                        ImageUrl="~/Content/Images/icon_edit.png">
                                    </telerik:GridButtonColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:radgrid>
                    </div>
                    <div>
                        <h3>Recent Payments <font style="font-size: 0.8em; color: #444444;"><i>(Last 3 Months)</i></font></h3>
                        <telerik:radgrid id="grdPaymentHistory" runat="server" allowsorting="True" allowpaging="True"
                            onitemdatabound="grdPaymentHistory_ItemDataBound" pagesize="10" onneeddatasource="grdPaymentHistory_NeedDataSource"
                            onitemcommand="grdPaymentHistory_OnItemCommand">
                            <MasterTableView AutoGenerateColumns="False" DataKeyNames="TransactionID,FlagReceipt" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; There are no recent payments to display. Payments from the last 90 days will show here.<br>&nbsp;">
                                <SortExpressions>
                                    <telerik:GridSortExpression FieldName="TransactionDate" SortOrder="Descending" />
                                </SortExpressions>
                                <Columns>
                                    <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Payment Date" DataField="TransactionDate" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Origin" DataField="PaymentOriginAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Type" DataField="StatusTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Method" DataField="MethodTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Payment Account" DataField="PaymentCardDesc">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Amount" DataField="Amount$" SortExpression="Amount">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Status" DataField="TransStateTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridButtonColumn CommandName="Receipt" HeaderText="Receipt" ButtonType="ImageButton"
                                        UniqueName="Receipt" ImageUrl="~/Content/Images/icon_view.png">
                                    </telerik:GridButtonColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:radgrid>
                    </div>
                </div>
                <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                    modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    behaviors="Pin,Reload,Close,Move,Resize" skin="CareBlue">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupPaymentPlan" Width="790px" Height="500px"
                            EnableViewState="False" NavigateUrl="~/report/managePaymentPlan_popup.aspx" DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupEditBlueCredit" Width="1200px" Height="800px"
                            EnableViewState="False" NavigateUrl="~/report/bluecredit_editcredit_popup.aspx"
                            DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupConfirmationPayment" Behaviors="Close"
                            Width="420px" Height="340px" NavigateUrl="~/report/paymentConfirmation_popup.aspx"
                            DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupManageAccounts" Width="850px" Height="550px"
                            NavigateUrl="~/report/pc_add_popup.aspx?ShowPaymentMethods=1">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupPaymentReceipt" NavigateUrl="~/report/paymentReceipt_popup.aspx" Width="450" Height="670" CssClass="customprintbutton" DestroyOnClose="True">
                        </telerik:RadWindow>
                    </Windows>
                </telerik:radwindowmanager>
                <telerik:radwindowmanager id="RadWindowManager" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                    modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    restrictionzoneid="tblMain" skin="CareBlueInf" style="z-index: 3000">
                    <ConfirmTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div style="margin-top: 20px; margin-left: 51px;">
                                <a href="javascript:;" onclick="$find('{0}').close(false);">
                                    <img src="Content/Images/btn_close_small.gif" alt="Close" /></a>
                                &nbsp;&nbsp;
                                <a href="javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="Content/Images/btn_printreceipt.gif" alt="Print Receipt" /></a>
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
                            <div id="divAlertButton" style="margin-top: 20px; margin-left: 135px;">
                                <a href="javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            </div>
                        </div>
                    </AlertTemplate>
                </telerik:radwindowmanager>
                <asp:ImageButton ID="btnDownload" runat="server" OnClick="btnDownload_Click" Style="display: none" />
                <asp:ImageButton ID="btnYes" runat="server" ImageUrl="Content/Images/btn_submit_small.gif"
                    Style="display: none" CssClass="btn-pop-submit" OnClick="btnYes_Click" />
                <asp:HiddenField ID="hdnDownload" runat="server" />
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" src="Scripts/accounting.min.js"></script>
    <script type="text/javascript" language="javascript">

        $(".failureNotification").hide();

        $(document).ready(function () {
            $("#<%=btnConfirmPayment.ClientID %>").attr("disabled", true);
        });

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {

            // Download PDF
            var hdnDownload = $("#<%=hdnDownload.ClientID %>");

            if (hdnDownload.val() != "") {
                $("#<%=btnDownload.ClientID %>").click();
                    hdnDownload.val("");
                }

            // Re validate payment amount
            validatePaymentAmount();

            unBlockUI();

        });

        function showPaymentReceipt() {
            var location = "<%= ClientSession.WebPathRootPatient %>" + "report/paymentReceipt_popup.aspx?IsHtmlPopup=1";
            var popup = window.open(location, "Payment Receipt", "location=0,status=0,scrollbars=1, width=450,height=670,titlebar=1,titlebar=0");
            reloadPage();
        }


        function closeReceiptPopup() {
            $find("<%=popupPaymentReceipt.ClientID%>").close();
        }

        function refreshGrid() {
            location.href = location.href;
        }


        function printReceiptPopup() {

            var content = $(".ExtraPad").html();
            var pwin = window.open('', 'print_content', 'width=450,height=600');
            pwin.document.open();
            pwin.document.write('<html><body onload="window.print()">' + content + '</body></html>');
            pwin.document.close();
            setTimeout(function () { pwin.close(); }, 1000);

        }


        function closePopup() {
            doPostBack();
        }

        function closeEditScheduledPaymentPopup() {
            doPostBack();
        }


        function closeRefresh() {
            location.href = location.href;
        }


        //closing request from bluecredit popup

        function refreshPage() {
            reloadPage();
        }

        //Edit Schedule Payment Scripts Start Here


        function openPaymentTerms() {
            GetRadWindow().BrowserWindow.gotoPaymentTerms();
        }


        function doPostBack() {
            __doPostBack('', '');
        }

        function validatePaymentAmount() {

            var paymentMethodCount = parseFloat($("#<%=hdnPaymentMethodsCount.ClientID %>").val());
            if (paymentMethodCount == 0)
                return;

            var payAmount = 0;
            $(".sumamount").each(function () {

                // Calculating the sum of amount
                var amount = parseFloat(accounting.unformat($(this).val()));
                if (amount > 0) {

                    payAmount = payAmount + amount;

                    // Displaying asterisk sign
                    var balance = $("#" + this.id.replace("txtAmount", "lblBalance")).text();
                    var lblError = $("#" + this.id.replace("txtAmount", "lblError"));

                    if (parseFloat(amount) > parseFloat(balance)) {
                        lblError.text("*");
                    } else {
                        lblError.text("");
                    }

                } else {
                    $(this).val("");
                }
            });


            var totalAmount = $find("<%=txtTotalAmount.ClientID%>");
            var submitButton = $("#<%= btnConfirmPayment.ClientID %>");

            if (payAmount > 0) {

                totalAmount.set_value(payAmount);

                // Enabling the button
                submitButton.removeAttr("disabled");
                submitButton.attr("src", "Content/Images/btn_confirmpay_orange.gif");

            } else {
                totalAmount.set_value("");
                submitButton.attr("disabled", "disabled");
                submitButton.attr("src", "Content/Images/btn_confirmpay_orange_fade.gif");
            }


        }

        function processPayment(isAllowPayment) {
            $find("<%=popupConfirmationPayment.ClientID%>").close();
            if (isAllowPayment) {
                blockUI();
                $("#<%=btnYes.ClientID %>").click();
            }
        }

        function showManageAccountPopup() {
            $find("<%=popupManageAccounts.ClientID%>").show();
        }

        function genericFunction() {
            closeRefresh();
        }

        function showPaymentPopup(isShow) {
            if (isShow) {
                showPaymentReceipt();
                //   $find("<%=popupPaymentReceipt.ClientID%>").show();
            } else {
                reloadPage();
            }
        }

        function validateAndSubmitPayment() {

            var hasAnyError = true;

            $(".label-errors").each(function () {
                if ($(this).text() == "*") {
                    alert("Please correct the following: <br /> <br />  1.  Please enter a positive amount up to the statement balance.");
                    hasAnyError = false;

                    return false;
                }
            });

            return hasAnyError;

        }
    </script>
</asp:Content>
