<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="paymentplans.aspx.cs"
    Inherits="patient_paymentplans" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnDownload" />
        </Triggers>
        <ContentTemplate>
            <div class="pgColumn1">
                <h2>Explanation of Page</h2>
                <h4>View and manage your payment plans here.</h4>
                <h5>Your provider understands that unplanned medical expenses can be a hardship, and offers the option to split payments up over several months on eligible balances. 
                    <br />
                    <br />
                    To create a new payment plan, find your statement below and click on "Add Plan". If your statement is not eligible for a payment plan, inquire with your provider about signing up for BlueCredit, which provides longer-term financing on large balances.
                </h5>
            </div>
            <div class="pgColumn2">
                <h1>Manage Payment Plans</h1>
                <div>
                    <h3>Active Payment Plans
                    </h3>
                    <telerik:radgrid id="grdPaymentPlanHistory" runat="server" allowsorting="True" allowpaging="True"
                        pagesize="10" onneeddatasource="grdPaymentPlanHistory_NeedDataSource" onitemcommand="grdPaymentPlanHistory_OnItemCommand" onitemdatabound="grdPaymentPlanHistory_ItemDataBound">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="PaymentPlanID,StatementID,Balance,FilePathStatements, FileName" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; You have no current payment plans. Statements which qualify for a payment plan are shown below.<br>&nbsp;">
                            <Columns>
                                <%--
                                <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn CommandName="DeletePlan" HeaderText="Delete" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/delete.PNG" ConfirmText="Do you want to remove selected payment ?\n This action is permanent and can't be undone.">
                                </telerik:GridButtonColumn>
                                <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Start Date" DataField="StartDate" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                --%>
                                <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Status" DataField="CreditStatusTypeabbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Next Payment" DataField="NextPayDate" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Amount" DataField="NextPayAmount$" SortExpression="NextPayAmount">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Account" DataField="AccountName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Frequency" DataField="PaymentFreqAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="End Date" DataField="EndDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn CommandName="ViewPayPlanTransactionHistory" HeaderText="History"
                                    ButtonType="ImageButton" ImageUrl="~/Content/Images/view.png">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="EditPlan" UniqueName="EditPlan" HeaderText="Edit" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_edit.png">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="Download" HeaderText="View" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_pdfblue.gif">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>

                </div>
                <div>
                    <h3>Create a New Plan <font style="font-size: 0.8em; color: #444444;"><i>(Plans May Only be Added to Eligible Statements)</i></font></h3>
                    </h3>
                    <telerik:radgrid id="grdMakePayments" runat="server" allowsorting="True" allowpaging="True"
                        pagesize="10" onneeddatasource="grdMakePayments_NeedDataSource" onitemcommand="grdMakePayments_OnItemCommand"
                        onitemdatabound="grdMakePayments_ItemDataBound">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="FilePathStatements, StatementID, Balance, FlagCreditPlan, FlagPayPlanEligible, CreditPayAbbr, CreditPlanAbbr, PayPlanEligibleAbbr" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; You have no outstanding statements which qualify for a payment plan. Contact your provider for alternate payment options on large balances.<br>&nbsp;">
                            <Columns>
                                <%--
                                <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Insurance" DataField="Insurance$" SortExpression="Insurance">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Payments" DataField="Payments$" SortExpression="Payments">
                                </telerik:GridBoundColumn>
                                <telerik:GridTemplateColumn HeaderText="Pay Plan" AllowFiltering="False">
                                    <ItemTemplate>
                                        <asp:Image ID="imgPayPlan" runat="server" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridTemplateColumn HeaderText="BlueCredit" AllowFiltering="False">
                                    <ItemTemplate>
                                        <asp:Image ID="imgCreditPlan" runat="server" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                    --%>
                                <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Charges" DataField="Charges$" SortExpression="Charges">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Last Payment" DataField="LastPaymentDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Amount" DataField="LastPayment$">
                                </telerik:GridBoundColumn>
                                <telerik:GridTemplateColumn HeaderText="Eligible" AllowFiltering="False">
                                    <ItemTemplate>
                                        <asp:Image ID="imgPlanEligible" runat="server" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridButtonColumn CommandName="AddPlan" UniqueName="AddPlan" HeaderText="Add Plan"
                                    ButtonType="ImageButton" ImageUrl="~/Content/Images/icon_add.png">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="Download" HeaderText="View" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_pdfblue.gif">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>
                </div>
                <asp:Button ID="btnDownload" runat="server" OnClick="btnDownload_Click" Style="display: none" />
                <asp:HiddenField ID="hdnDownload" runat="server" />
            </div>
            <telerik:radwindowmanager id="RadWindowManager1" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                restrictionzoneid="divMainContent" skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize"
                style="z-index: 3000">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popupPaymentPlan" Width="706" Height="526px"
                        NavigateUrl="~/report/managePaymentPlan_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupAddPaymentCard" Width="750px" Height="600px"
                        NavigateUrl="~/report/pc_add_popup.aspx?ShowPaymentMethods=1">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupPayPanTransactionHistory" Width="850px" Height="700px"
                        NavigateUrl="~/report/payPlanTransHistory_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                </Windows>
            </telerik:radwindowmanager>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            var hdnDownload = $("#<%=hdnDownload.ClientID %>");

            if (hdnDownload.val() != "") {
                $("#<%=btnDownload.ClientID %>").click();
                hdnDownload.val("");
            }
            
            unBlockUI();


        });

        function closeRefresh() {
            location.href = location.href;
        }


        function closePaymentPlan() {
            doPostBack();
        }


        function doPostBack() {
            __doPostBack('', '');
        }

        function showBankAccountProcessing() {
            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('PayPlanValidationGroup');
            }

            if (isPageValid) {
                blockUI();
                return true;
            }
            else {
                return false;
            }
        }

        function showAddPaymentPopup() {

            var popup = $find("<%=popupAddPaymentCard.ClientID%>");
            popup.show();

            window.setTimeout(function () {
                popup.setActive(true);
                popup.set_modal(true);
            }, 0);

        }

        function genericFunction() {
            var popup = $find("<%=popupPaymentPlan.ClientID%>");
            popup.reload();
        }

    </script>
</asp:Content>
