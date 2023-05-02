<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="bluecredit.aspx.cs"
    Inherits="patient_bluecredit" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnDownload" />
        </Triggers>
        <ContentTemplate>
            <div class="pgColumn1">
                <h2>Explanation of Page</h2>
                <h4>View and manage your BlueCredit plans here.</h4>
                <h5>BlueCredit accounts provide long term financing to help alleviate the burden of paying for large procedures all at once. You can change your payment amount and date by editing your account.
                    <br />
                    <br />
                    <b>Did you know?</b>
                    <br />
                    If you are interested in financing options and don't already have a BlueCredit account, click on "Apply Now", or contact your provider.
                </h5>

            </div>
            <div class="pgColumn2">
                <h1>BlueCredit Manager</h1>
                <asp:Panel ID="pnlAccountStatus" Visible="False" runat="server">
                    <h3>BlueCredit Account Status</h3>
                    <div id="divNoCreditAccount" runat="server" visible="False">
                        <p style="font-size: 1.2em; margin-top: -5px;">You have no active BlueCredit loan accounts to manage.</p>

                        <div id="divApplyNow" runat="server" visible="False" style="font-size: 1.2em;">
                            However, you have outstanding balances which may qualify for long-term financing options. Would you like to learn more?
                        </div>
                        <div style="margin: 10px 0px 20px 0px;" />
                        <asp:ImageButton ID="btnApplynow" runat="server" ImageUrl="Content/Images/btn_requestinfo_orange.gif"
                            CssClass="btn-applynow" OnClick="btnApplynow_Click" />
                    </div>
            </div>
            <p id="pStatus" runat="server" visible="False" style="font-size: 1.2em; margin: -5px 160px 20px 0px;">
            </p>

            <hr />
            </asp:Panel>
                <asp:Panel ID="pnlOutstandingStatementsUnassigned" runat="server">
                    <div>
                        <h3>Outstanding Statements</h3>
                        <p style="font-size: 1.2em; margin-top: -5px;">
                            Your request for BlueCredit financing will be evaluated against the total remaining balance of the statements shown below.
                        </p>
                        <telerik:radgrid id="grdCreditsApplied" runat="server" allowsorting="True" allowpaging="True"
                            pagesize="10" onneeddatasource="grdCreditsApplied_NeedDataSource" onitemdatabound="grdCreditsApplied_ItemDataBound" onitemcommand="grdCreditsApplied_OnItemCommand">
                            <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID, FilePathStatements, FileName,CreditPayAbbr,CreditPlanAbbr">
                                <Columns>
                                  <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Charges" DataField="Charges$" SortExpression="Charges">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Payments" DataField="Payments$" SortExpression="Payments">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Due Date" DataFormatString="{0:MM/dd/yyyy}" DataField="DueDateRaw">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridTemplateColumn HeaderText="PayPlan" AllowFiltering="False">
                                        <ItemTemplate>
                                            <asp:Image ID="imgPayPlan" runat="server" />
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridTemplateColumn HeaderText="BlueCredit" AllowFiltering="False">
                                        <ItemTemplate>
                                            <asp:Image ID="imgCreditPlan" runat="server" />
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridButtonColumn CommandName="Download" HeaderText="View" ButtonType="ImageButton"
                                        UniqueName="downloadPDF" ImageUrl="~/Content/Images/icon_pdfblue.gif">
                                    </telerik:GridButtonColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:radgrid>

                    </div>
                </asp:Panel>
            <asp:Panel ID="pnlActiveAccounts" Visible="False" runat="server">
                <h3>Active BlueCredit Accounts</h3>
                <telerik:radgrid id="grdActiveAccounts" runat="server" allowsorting="True" allowpaging="True"
                    pagesize="10" onneeddatasource="grdActiveAccounts_NeedDataSource" onitemcommand="grdActiveAccounts_ItemCommand">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="BlueCreditID">
                            <Columns>
                                <%-- 
                                <telerik:GridBoundColumn HeaderText="Credit Limit" DataField="CreditLimit$" SortExpression="CreditLimit">
                                </telerik:GridBoundColumn>
                                --%>
                                <telerik:GridBoundColumn HeaderText="Account ID" DataField="BlueCreditID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Borrower" DataField="AccountHolder">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Plan Name" DataField="PlanName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Opened" DataField="OpenDate">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Status" DataField="CreditStatusTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Next Payment" DataField="NextPayAmount$" SortExpression="NextPayAmount">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Pay Date" DataField="NextPayDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn CommandName="ViewTransactionHistory" HeaderText="History"
                                    ButtonType="ImageButton" ImageUrl="~/Content/Images/view.png">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="EditAccountStatus" HeaderText="Edit" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_edit.png">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>
                <div id="divHistoryAppliedCreditsGrid" runat="server">
                    <h3>Assigned BlueCredit Statements</h3>
                    <p style="font-size: 1.2em; margin-top: -5px;">
                        These statements are part of an active BlueCredit finance plan. They will automatically be paid and no separate payment is due.
                    </p>
                    <telerik:radgrid id="grdHistoryAppliedCredits" runat="server" allowsorting="True"
                        allowpaging="True" pagesize="10" onneeddatasource="grdHistoryAppliedCredits_NeedDataSource"
                        onitemcommand="grdHistoryAppliedCredits_OnItemCommand">
                            <MasterTableView AutoGenerateColumns="False" DataKeyNames="BlueCreditID, StatementID, FilePathStatements, FileName">
                                <Columns>
                                    <telerik:GridBoundColumn HeaderText="Account ID" DataField="BlueCreditID">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Last Payment" DataField="LastPaymentDate" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Amount" DataField="LastPayment$" SortExpression="LastPayment">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Due Date" DataField="DueDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridButtonColumn CommandName="Download" HeaderText="View" ButtonType="ImageButton"
                                        ImageUrl="~/Content/Images/icon_pdfblue.gif">
                                    </telerik:GridButtonColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:radgrid>
                </div>
                <div style="margin-top: 20px;">
                    <h3>Unassigned Statements </h3>
                    <p style="font-size: 1.2em; margin-top: -5px;">
                        It may be possible to add the statements below to your existing account. Select and submit any statement to make this request. Please note that adding additional balances may increase your BlueCredit minimum monthly payment. You provider will discuss these details before any changes are made.
                    </p>
                    <telerik:radgrid id="gridOutstandingStatementsUnassigned" runat="server" allowsorting="True"
                        onitemcommand="gridOutstandingStatementsUnassigned_OnItemCommand" allowpaging="True"
                        pagesize="10" onneeddatasource="gridOutstandingStatementsUnassigned_NeedDataSource">
                            <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID, FilePathStatements, FileName">
                                <Columns>
                                    <telerik:GridTemplateColumn HeaderText="Choose" AllowFiltering="False">
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkStatement" AutoPostBack="True" OnCheckedChanged="chk_OnChanged"
                                                runat="server"></asp:CheckBox>
                                        </ItemTemplate>
                                    </telerik:GridTemplateColumn>
                                    <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Charges" DataField="Charges$" SortExpression="Charges">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Payments" DataField="Payments$" SortExpression="Payments">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Last Pay Date" DataField="LastPaymentDate" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Due Date" DataFormatString="{0:MM/dd/yyyy}" DataField="DueDateRaw">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridButtonColumn CommandName="View" HeaderText="View" ButtonType="ImageButton"
                                        ImageUrl="~/Content/Images/icon_pdfblue.gif">
                                    </telerik:GridButtonColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:radgrid>
                </div>
                &nbsp;<br />
                <asp:ImageButton ID="btnRequestAssignment" ImageUrl="Content/Images/btn_submit_fade.gif"
                    Enabled="False" OnClick="btnRequestAssignment_OnClick" runat="server" />
            </asp:Panel>
            <asp:Button ID="btnDownload" runat="server" OnClick="btnDownload_Click" Style="display: none" />
            <asp:HiddenField ID="hdnDownload" runat="server" />
            <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="1100px" height="850px"
                behaviors="Pin,Reload,Close,Move,Resize" modal="True" enableshadow="False" enableembeddedbasestylesheet="False"
                enableembeddedskins="False" skin="CareBlue" style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupEditBlueCredit" Width="1000px" Height="700px"
                            EnableViewState="False" NavigateUrl="~/report/bluecredit_editcredit_popup.aspx"
                            DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupTransactionHistory" Width="850px" Height="710px"  
                            NavigateUrl="~/report/CreditTransHistory_popup.aspx" DestroyOnClose="True">
                        </telerik:RadWindow>
                    </Windows>
                </telerik:radwindowmanager>

            </div>
            <telerik:radwindowmanager id="radWindowDialog" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                restrictionzoneid="divMainContent" skin="CareBlueInf" style="z-index: 3000">
                <AlertTemplate>
                        <div class="rwDialogPopup radalert">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div id="divAlertButton" style="margin-top: 20px; margin-left: 140px;">
                                <a href="javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            </div>
                        </div>
                    </AlertTemplate>
            </telerik:radwindowmanager>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">
        var isFromSubmit = false;
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            var hdnDownload = $("#<%=hdnDownload.ClientID %>");

            if (hdnDownload.val() != "") {
                $("#<%=btnDownload.ClientID %>").click();
                hdnDownload.val("");
            }

            isFromSubmit = false;
        });
        
        function checkboxClicked(e, idFragment) {
            var currentCheckBox = e.srcElement || e.target;
            var inputs = document.getElementsByTagName("input");
            for (var i = 0; i < inputs.length; i++) {
                var input = inputs[i];
                if (input.id == currentCheckBox.id)
                    continue;
                if (input.id.indexOf(idFragment) < 0)
                    continue;
                //clear out the rest of the checkboxes 
                if (input.type && input.type == "checkbox") {
                    input.checked = false;
                }
            }
        }


        $(".rbChoose").each(function () {
            var checkbox = $("#" + $(this).find(':input').attr('id'));
            checkbox.attr("checked", "checked");
            return false;
        });

        function isStatementSelected() {

            var checking = false;

            var inputs = document.getElementsByTagName("input");
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].checked == true) {
                    checking = true;
                    break;
                }

            }
            if (!checking) {
                return false;
            }


            return true;
        }

        function refreshGrid() {
            location.href = location.href;
        }

        function refreshPage() {
            location.href = location.href;
        }


        function closeRefresh() {
            location.href = location.href;
        }

    </script>
</asp:Content>
