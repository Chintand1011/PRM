<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="paymentplans.aspx.cs"
    Inherits="patient_paymentplans" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Payment Plan Manager</h1>
            </div>
            <div class="bodyMain">
                <h2>Review and update patient payment plans. All current statements eligible for a payment plan, including active payment plans, are shown below.</h2>
                <div>
                    <h3>Modify Existing Payment Plans</h3>
                    <telerik:radgrid id="grdPaymentPlanHistory" runat="server" allowsorting="True" allowpaging="True"
                        pagesize="10" onneeddatasource="grdPaymentPlanHistory_NeedDataSource" onitemcommand="grdPaymentPlanHistory_OnItemCommand">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="PaymentPlanID,StatementID,Balance">
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                </telerik:GridBoundColumn>
                                <%--
                                <telerik:GridBoundColumn HeaderText="Start Date" DataField="StartDate" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Provider" DataField="ProviderName">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn CommandName="DeletePlan" HeaderText="Delete" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/delete.PNG" ConfirmText="Do you want to remove selected payment ?\n This action is permanent and can't be undone.">
                                </telerik:GridButtonColumn>
                                --%>
                                <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Status" DataField="CreditStatusTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Next Payment" DataField="NextPayDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Amount" DataField="NextPayAmount$" SortExpression="NextPayAmount">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Account" DataField="AccountName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Frequency" DataField="PaymentFreqAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="End Date" DataField="EndDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn CommandName="ViewPaymentPlan" HeaderText="History" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/view.png">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="EditPlan" HeaderText="Edit" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/edit.PNG">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>

                </div>
                <div style="overflow-x: auto">
                    <br />
                    <br />
                    <h3>Create a New Payment Plan &nbsp; &nbsp;<asp:ImageButton ID="btnAddStatement" OnClick="btnAddStatement_OnClick" ImageUrl="../Content/Images/btn_addstatement.gif" Style="margin-bottom: -2px;" runat="server" />
                    </h3>
                    <h5 id="addStatementMessage" runat="server" visible="False" style="margin: -10px 0 10px 0; font-weight: 600; color: darkred;">No statements exist. Create one using the button above before assigning BlueCredit.</h5>
                    <telerik:radgrid id="grdCreateNewPlan" runat="server" allowsorting="True" allowpaging="True"
                        onneeddatasource="grdCreateNewPlan_NeedDataSource" pagesize="10" onitemcommand="grdCreateNewPlan_ItemCommand"
                        onitemdatabound="grdCreateNewPlan_ItemDataBound">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID, Balance,FlagCreditPlan,FlagPayPlanEligible,CreditPayAbbr,CreditPlanAbbr,PayPlanEligibleAbbr">
                            <Columns>
                                <%--
                                <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Provider" DataField="ProviderName">
                                </telerik:GridBoundColumn>
                                --%>
                                <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Last Payment" DataField="LastPaymentDateRaw"
                                    DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Amount" DataField="LastPayment$" SortExpression="LastPayment">
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
                                <telerik:GridTemplateColumn HeaderText="Eligible" AllowFiltering="False">
                                    <ItemTemplate>
                                        <asp:Image ID="imgPlanEligible" runat="server" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridButtonColumn CommandName="AddPlan" UniqueName="AddPlan" HeaderText="Add Plan"
                                    ButtonType="ImageButton" ImageUrl="~/Content/Images/icon_add_green.png">
                                </telerik:GridButtonColumn>
                                 <telerik:GridButtonColumn CommandName="View" HeaderText="View" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/view.png">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>
                </div>
            </div>
            <telerik:radwindow runat="server" id="popupEstimateView" cssclass="customprintbutton"
                navigateurl="~/report/estimateview_popup.aspx" destroyonclose="True"
                showcontentduringload="True" visiblestatusbar="False" visibletitlebar="True"
                reloadonshow="True" width="860px" height="850px" modal="True" enableshadow="False"
                enableembeddedbasestylesheet="False" enableembeddedskins="False" behaviors="Pin,Reload,Close,Move,Resize"
                skin="CareBlueInv">
            </telerik:radwindow>
            <telerik:radwindowmanager id="RadWindowManager1" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                restrictionzoneid="divMainContent" skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize"
                style="z-index: 3000">
                        <Windows>
                            <telerik:RadWindow runat="server" ID="popupPaymentPlan" Width="790px" Height="500px"
                                NavigateUrl="~/report/managePaymentPlan_popup.aspx" DestroyOnClose="True">
                            </telerik:RadWindow>
                            <telerik:RadWindow runat="server" ID="popupManageAccounts" Width="750px" Height="650px"
                                NavigateUrl="~/report/pc_add_popup.aspx?ShowPaymentMethods=1">
                            </telerik:RadWindow>
                            <telerik:RadWindow runat="server" ID="popupPayPanTransactionHistory" Width="850px" Height="700px"
                                NavigateUrl="~/report/payPlanTransHistory_popup.aspx" DestroyOnClose="True">
                            </telerik:RadWindow>
                            <telerik:RadWindow runat="server" ID="popupAddStatement"  Width="500" Height="270"
                               NavigateUrl="~/report/addStatement_popup.aspx"  CssClass="customprintbutton">
                           </telerik:RadWindow>
                        </Windows>
                    </telerik:radwindowmanager>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }

        function closePopup() {
            doPostBack();
        }

        function showAddPaymentPopup() {

            var popup = $find("<%=popupManageAccounts.ClientID%>");
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


        function printPopup() {

            var content = $(".ExtraPad").html();
            var pwin = window.open('', 'print_content', 'width=900,height=500');
            pwin.document.open();
            pwin.document.write('<html><head><link href="../Styles/Print.css" rel="stylesheet" type="text/css" /></head><body onload="window.print()"><div class="popup-styles"' + content + '</div></body></html>');
            pwin.document.close();
            setTimeout(function () { pwin.close(); }, 1000);
        }

        function closePaymentPlan() {
            doPostBack();
        }

        function doPostBack() {
            __doPostBack('', '');
        }

    </script>
</asp:Content>
