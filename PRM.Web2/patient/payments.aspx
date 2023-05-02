<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="payments.aspx.cs"
    Inherits="payments_statement" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script type="text/javascript" src="../Scripts/radwindowPrintButton.js"></script>
    <script type="text/javascript">
        function printWin(e) {
            var oWnd = $find("<%=popupPaymentReceipt.ClientID%>");
            var content = oWnd.GetContentFrame().contentWindow;
            var printDocument = content.document;
            if (document.all) {
                printDocument.execCommand("Print");
            }
            else {
                content.print();
            }
            //Cancel event!
            if (!e) e = window.event;

            return $telerik.cancelRawEvent(e);
        }
    </script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <%--<telerik:RadAjaxPanel runat="server" ID="RadAjaxPanel">--%>
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnDownload" />
        </Triggers>
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Patient Payment Center</h1>
            </div>
            <div class="bodyMain">
                <h2>Listed below are all outstanding patient statements with current balances. Payments
                    are immediately reflected so the status of each statement is up to date.
                <br />
                    <b><font color="#cc4444">CARDHOLDER PERMISSION IS REQUIRED BEFORE MAKING ANY PAYMENT NOT ALREADY SCHEDULED AS PART OF A RECURRING CHARGE PLAN.</font></b></h2>
                <div>
                    <h3>Outstanding Balances</h3>
                    <p style="margin: -14px 0 5px 10px; font-size: 1.2em; color: #444444;"><i>"Pay Over Time" statements are automatically paid to keep status in good standing, however additional payments may be made by the patient at anytime.</i></p>
                    <telerik:radgrid id="grdMakePayments" runat="server" allowsorting="True" allowpaging="True"
                        pagesize="10" onneeddatasource="grdMakePayments_NeedDataSource" allowmultirowselection="true"
                        onitemcommand="grdMakePayments_OnItemCommand" onitemdatabound="grdMakePayments_ItemDataBound">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID,FlagAcceptPtPay, Balance, FilePathStatements, FileName, FlagAutoPay" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; You have no current statements with a balance. Please check with your provider if you are expecting a payment due after your visit or procedure.<br>&nbsp;">
                            <SortExpressions>
                                <telerik:GridSortExpression FieldName="DueDate" SortOrder="Ascending" />
                            </SortExpressions>
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                </telerik:GridBoundColumn>
                               <telerik:GridBoundColumn HeaderText="Charges" DataField="Charges$" SortExpression="Charges">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Insurance" DataField="Insurance$" SortExpression="Insurance">
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
                                <telerik:GridTemplateColumn HeaderText="Pay Over Time" AllowFiltering="False">
                                    <ItemTemplate>
                                        <asp:Image ID="imgAutoPay" runat="server" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                </telerik:GridBoundColumn>
                                  <telerik:GridButtonColumn CommandName="View" HeaderText="View" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/view.png">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="Download" HeaderText="PDF" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_pdfblue.gif">
                                </telerik:GridButtonColumn>
                                <telerik:GridTemplateColumn UniqueName="Amount" HeaderText="Amount" AllowFiltering="False">
                                    <ItemTemplate>
                                        <telerik:RadNumericTextBox runat="server" ID="txtAmount" Width="80px" Height="20"
                                            onchange="return validatePaymentAmount(event);"  CssClass="sumamount"
                                            Type="Currency" NumberFormat-DecimalDigits="2" NumberFormat-GroupSeparator=",">
                                        </telerik:RadNumericTextBox>
                                        <asp:Label ID="lblError" CssClass="label-errors" title="Please enter your amount less than or equal to balance"
                                            Text="" Style="color: red;" runat="server"></asp:Label>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>

                    <div style="margin-top: 10px" id="divPaymentMethods" runat="server" visible="False">
                        <div class="form-row">
                            <div class="editor-label" style="margin-top: 3px;">
                                <asp:Label runat="server">Payment Method:</asp:Label>
                            </div>
                            <div class="editor-field">
                                <telerik:radcombobox id="cmbPaymentMethods" runat="server" width="200px" datatextfield="AccountName"
                                    onselectedindexchanged="cmbPaymentMethods_OnSelectedIndexChanged" allowcustomtext="False"
                                    markfirstmatch="True" datavaluefield="PaymentCardID" autopostback="True" maxheight="200">
                                </telerik:radcombobox>
                                &nbsp; <a href="javascript:;" onclick="redirectToCardOnFile()" style="text-decoration: none;">
                                    <img style="top: 4px; position: relative;" src="../Content/Images/icon_add.png" alt="New" class="btn-new" />
                                    <div style="margin: -20px 0 0 230px; font-size: 1.2em;">Add New</div>
                                </a>
                            </div>
                            <div style="float: right; margin-right: 12px;">
                                <div class="editor-label" style="margin-top: 3px;">
                                    <asp:Label runat="server">Total Amount:</asp:Label>
                                </div>
                                <div class="editor-field" style="margin-right: 25px;">
                                    <asp:HiddenField ID="hdnPaymentMethodsCount" runat="server" />
                                    <telerik:radnumerictextbox runat="server" id="txtTotalAmount" width="80px" readonly="True"
                                        type="Currency" numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                    </telerik:radnumerictextbox>
                                </div>
                            </div>
                        </div>

                        <div class="form-row" style="margin: -5px 12px -5px 0;">
                            <div style="float: right; padding-right: 12px;">
                                <asp:ImageButton ID="btnConfirmPayment" ImageUrl="../Content/Images/btn_confirmpay_orange_fade.gif" OnClientClick="return validateAndSubmitPayment();"
                                    Style="margin-top: 3px; padding-right: 0px" OnClick="btnConfirmPayment_OnClick" runat="server" />

                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <br />
                    <h3>Pending Payments <font style="font-size: 0.8em; color: #444444;"><i>(Next 3 Months)</i></font></h3>
                    <telerik:radgrid id="grdPendingPayments" runat="server" allowsorting="True" allowpaging="True"
                        pagesize="10" onneeddatasource="grdPendingPayments_NeedDataSource" onitemcommand="grdPendingPayments_OnItemCommand">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID, Balance, BlueCreditID, PaymentPlanID">
                                <SortExpressions>
                                    <telerik:GridSortExpression FieldName="NextPayDate" SortOrder="Ascending" />
                                </SortExpressions>
                            <Columns>
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
                                        ImageUrl="~/Content/Images/edit.PNG">
                                    </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>
                </div>
                <div>
                    <br />
                    <br />
                    <h3>Recent Payments <font style="font-size: 0.8em; color: #444444;"><i>(Last 3 Months)</i></font></h3>
                    <telerik:radgrid id="grdPaymentHistory" runat="server" allowsorting="True" allowpaging="True"
                        pagesize="10" onneeddatasource="grdPaymentHistory_NeedDataSource" onitemcommand="grdPaymentHistory_OnItemCommand">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="TransactionID">
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
                                <telerik:GridBoundColumn HeaderText="Result" DataField="ResultTypeAbbr">
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
            <telerik:radwindowmanager id="RadWindowManager1" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="650px"
                modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                restrictionzoneid="divMainContent" skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize"
                style="z-index: 3000">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popupPaymentPlan" Width="790px" Height="500px"
                        NavigateUrl="~/report/managePaymentPlan_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupEditBlueCredit" Width="1050px" Height="780px"
                        NavigateUrl="~/report/bluecredit_editcredit_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupConfirmationPayment" Behaviors="Close"
                        Width="420px" Height="340px" NavigateUrl="~/report/paymentConfirmation_popup.aspx"
                        DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupPaymentReceipt" NavigateUrl="~/report/paymentReceipt_popup.aspx"
                        Width="450" Height="670" CssClass="customprintbutton" DestroyOnClose="True">
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
                        <div style="margin-top: 20px; margin-left: 30px;">
                            <a href="#" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            &nbsp;&nbsp;
                                <a href="javascript:;" onclick="$('#<%=btnSignature.ClientID %>').click();">
                                    <img src="../Content/Images/btn_sign_small.gif" alt="Sign" /></a>
                            &nbsp;&nbsp;
                                <a id="btnReceipt" href="javascript:;" class="confirm-popup" onclick="$find('{0}').close(false);">
                                    <img src="../Content/Images/btn_print_small.gif" alt="Print" /></a>
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
                        <div style="margin-top: 20px; margin-left: <%=Margin%>">
                            <a href="#" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:radwindowmanager>
            <telerik:radwindow runat="server" id="popupEstimateView" cssclass="customprintbutton"
                onclientshow="OnClientShow" navigateurl="~/report/estimateview_popup.aspx" destroyonclose="True"
                showcontentduringload="True" visiblestatusbar="False" visibletitlebar="True"
                reloadonshow="True" width="860px" height="850px" modal="True" enableshadow="False"
                enableembeddedbasestylesheet="False" enableembeddedskins="False" behaviors="Pin,Reload,Close,Move,Resize"
                skin="CareBlueInv">
            </telerik:radwindow>
            <asp:Button ID="btnDownload" runat="server" OnClick="btnDownload_Click" Style="display: none" />
            <asp:Button ID="btnSignature" OnClick="btnSignature_Click" Style="display: none;" runat="server" />
            <asp:ImageButton ID="btnProcessPayment" Style="display: none;" runat="server" ImageUrl="../Content/Images/btn_submit.gif"
                OnClick="btnYes_Click" />
            <asp:HiddenField ID="hdnDownload" runat="server" />
            <asp:HiddenField ID="hdnIsReceipt" runat="server" />
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>


</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" src="../Scripts/accounting.min.js"></script>
    <script type="text/javascript" language="javascript">

        var isGridHasErrors = false;

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


        function closeReceiptPopup() {
            $find("<%=popupPaymentReceipt.ClientID%>").close();
        }


        function printReceiptPopup() {

            var content = $get("divPaymentReceipt").innerHTML;
            var pwin = window.open('', 'print_content', 'width=450,height=600');
            pwin.document.open();
            pwin.document.write('<html><body onload="window.print()">' + content + '</body></html>');
            pwin.document.close();
            setTimeout(function () { pwin.close(); }, 1000);

        }


        //Edit Schedule Payment Scripts Start Here


        function openPaymentTerms() {
            GetRadWindow().BrowserWindow.gotoPaymentTerms();
        }

        function validatePaymentAmount(e) {

            if (e != undefined && e.keyCode == 13) {
                $("#<%=btnConfirmPayment.ClientID %>").focus();
                $("#<%=btnConfirmPayment.ClientID %>").click();
            }

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
                submitButton.attr("src", "../Content/Images/btn_confirmpay_orange.gif");

            } else {
                totalAmount.set_value("");
                submitButton.attr("disabled", "disabled");
                submitButton.attr("src", "../Content/Images/btn_confirmpay_orange_fade.gif");
            }


        }





        function processPayment(isAllowPayment) {
            $find("<%=popupConfirmationPayment.ClientID%>").close();
            if (isAllowPayment) {
                blockUI();
                $("#<%=btnProcessPayment.ClientID %>").click();
            }
        }

        function redirectToCardOnFile() {
            location.href = "<%=ClientSession.WebPathRootProvider %>" + "patient/cardonfile.aspx";
        }

        function showPaymentReceiptByOption() {

            if ($("#<%=hdnIsReceipt.ClientID %>").val() == "0") {
                showPaymentReceipt(true);
            } else {
                showPaymentReceipt();
            }

            $("#<%=hdnIsReceipt.ClientID %>").val("");
        }

        function reloadPage(isOk) {
            if (!isOk) {
                showPaymentReceiptByOption();
            }

            refreshPage();
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
