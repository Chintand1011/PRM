<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="payments.aspx.cs"
    Inherits="payments_statement" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script type="text/javascript" src="../Scripts/radwindowPrintButton.js"></script>
    <script type="text/javascript">
        function printWin(e) {
            var oWnd = $find("<%=popupEstimateView.ClientID%>");
            oWnd.close();
            createPDF();
        }

        function createPDF() {
            blockUI();
            $("#<%=btnCreatePDF.ClientID %>").click();
        }
    </script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <%--<telerik:RadAjaxPanel runat="server" ID="RadAjaxPanel">--%>
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>BlueCredit Scheduled Payments</h1>
            </div>
            <div class="bodyMain">
                <h2>Listed below are upcoming scheduled pending payments for BlueCredit plans and recently
                    completed payments.                      
                </h2>
                <div>
                    <br />
                    <h3>Pending Payments
                        
                         <asp:ImageButton ID="btnPaymentReport" ImageUrl="../Content/Images/btn_export.gif" CssClass="grd-search-align"
                             OnClick="btnPendingPaymentsReport_Click" runat="server" />
                    </h3>
                    <telerik:radgrid id="grdPendingPayments" runat="server" allowsorting="True" allowpaging="True"
                        pagesize="10" onneeddatasource="grdPendingPayments_NeedDataSource" onitemcommand="grdPendingPayments_OnItemCommand">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID, Balance, BlueCreditID, PaymentPlanID, PatientID, AccountID">
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Scheduled Date" DataField="NextPayDate" UniqueName="ScheduledDate" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Scheduled Amount" DataField="NextPayAmount$">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Account" DataField="AccountName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn CommandName="EditPayment" UniqueName="EditPayment" HeaderText="Manage" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/edit.PNG">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="ViewStatement" HeaderText="View" ButtonType="ImageButton"
                                    UniqueName="ViewStatement" ImageUrl="~/Content/Images/icon_view.png">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                         <ExportSettings>
                                    <Excel Format="Biff"></Excel>
                         </ExportSettings>
                    </telerik:radgrid>
                </div>
                <div>
                    <br />
                    <br />
                    <h3>Recent Payments
                            <asp:ImageButton ID="btnPaymentHistoryExport" ImageUrl="../Content/Images/btn_export.gif" CssClass="grd-search-align"
                                OnClick="btnPaymentHistoryReport_Click" runat="server" />

                    </h3>
                    <telerik:radgrid id="grdPaymentHistory" runat="server" allowsorting="True" allowpaging="True"
                        pagesize="10" onneeddatasource="grdPaymentHistory_NeedDataSource" onitemcommand="grdPaymentHistory_OnItemCommand">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="TransactionID, StatementID">
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Date" DataField="TransactionDate" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Amount" DataField="Amount$">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Result" DataField="ResultTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Type" DataField="StatusTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Method" DataField="MethodTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="State" DataField="TransStateTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn CommandName="Receipt" HeaderText="Receipt" ButtonType="ImageButton"
                                    UniqueName="Receipt" ImageUrl="~/Content/Images/icon_receipt.png">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="ViewStatement" HeaderText="View" ButtonType="ImageButton"
                                    UniqueName="ViewStatement" ImageUrl="~/Content/Images/icon_view.png">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                        <ExportSettings>
                                    <Excel Format="Biff"></Excel>
                        </ExportSettings>
                    </telerik:radgrid>
                </div>
            </div>
            <telerik:radwindowmanager id="RadWindowManager1" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                restrictionzoneid="divMainContent" skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize"
                style="z-index: 3000">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popupPaymentReceipt" NavigateUrl="~/report/paymentReceipt_popup.aspx"
                        Width="450" Height="670" CssClass="customprintbutton" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupPaymentPlan" Width="790px" Height="500px"
                        NavigateUrl="~/report/managePaymentPlan_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupEditBlueCredit" Width="1050px" Height="780px"
                        NavigateUrl="~/report/bluecredit_editcredit_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                      <telerik:RadWindow runat="server" ID="popupManageAccounts" Width="750px" Height="650px"
                        NavigateUrl="~/report/pc_add_popup.aspx?ShowPaymentMethods=1">
                    </telerik:RadWindow>
                </Windows>
            </telerik:radwindowmanager>
            <telerik:radwindow runat="server" id="popupEstimateView" cssclass="customprintbutton"
                onclientshow="OnClientShow" navigateurl="~/report/estimateview_popup.aspx" destroyonclose="True"
                showcontentduringload="True" visiblestatusbar="False" visibletitlebar="True"
                reloadonshow="True" width="850px" height="850px" modal="True" enableshadow="False"
                enableembeddedbasestylesheet="False" enableembeddedskins="False" behaviors="Pin,Reload,Close,Move,Resize"
                skin="CareBlueInv">
            </telerik:radwindow>
            <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
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
                        <div style="margin-top: 20px; margin-left: 51px;">
                            <a href="#" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:radwindowmanager>
            <asp:Button ID="btnCreatePDF" OnClick="btnCreatePDF_OnClick" runat="server" Style="display: none" />
            <asp:HiddenField ID="hdnIsShowPDFViewer" runat="server" />
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnPaymentReport" />
            <asp:PostBackTrigger ControlID="btnPaymentHistoryExport" />
        </Triggers>
    </asp:UpdatePanel>
    <script type="text/javascript" language="javascript">

        var isGridHasErrors = false;

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {

            if ($("#<%=hdnIsShowPDFViewer.ClientID %>").val() == "1") {
                viewPdfViewer();
                $("#<%=hdnIsShowPDFViewer.ClientID %>").val("");
            }

            unBlockUI();

        });

        function refreshGrid() {
            location.href = location.href;
        }


        function printReceiptPopup() {

            var content = $get("divPaymentReceipt").innerHTML;
            var pwin = window.open('', 'print_content', 'width=450,height=600');
            pwin.document.open();
            pwin.document.write('<html><body onload="window.print()">' + content + '</body></html>');
            pwin.document.close();
            setTimeout(function () { pwin.close(); }, 1000);

        }

        function closeRefresh() {
            location.href = location.href;
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

        //Edit Schedule Payment Scripts Start Here


        function openPaymentTerms() {
            GetRadWindow().BrowserWindow.gotoPaymentTerms();
        }

        function viewPdfViewer() {
            var popupName = "Estimate";
            var location = "<%=ClientSession.WebPathRootProvider %>" + "report/pdfviewer_popup.aspx";
             window.open(location, popupName, "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");
         }
    </script>
</asp:Content>
