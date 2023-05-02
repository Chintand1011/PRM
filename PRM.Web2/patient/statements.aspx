<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="statements.aspx.cs"
    Inherits="patient_statements" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script type="text/javascript" src="../Scripts/radwindowPrintButton.js"></script>
    <script type="text/javascript">
        function printWin(e) {
            var oWnd = $find("<%=popupEstimateView.ClientID%>");
            oWnd.close();
            createPDF();
        }

        function createPDF() {
            $find("<%=popupProgress.ClientID%>").show();
            $("#<%=btnCreatePDF.ClientID %>").click();
        }
    </script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnDownload" />
        </Triggers>
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Patient Statements</h1>
            </div>
            <div class="bodyMain">
                <h2>Statements below are always immediately current. The most recent mailed copy can be viewed by selecting the "Download" link.
                    <h3>Current Statements</h3>
                    <telerik:radgrid id="grdPatientStatements" runat="server" allowsorting="True" allowpaging="True"
                        pagesize="10" onneeddatasource="grdPatientStatements_NeedDataSource" onitemcommand="grdPatientStatements_OnItemCommand" onitemdatabound="grdPatientStatements_ItemDataBound" ondetailtabledatabind="grd_OnDetailTableDataBind">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID, FilePathStatements, FileName, Balance,FlagCreditPlan,FlagCreditEligible,CreditPayAbbr,CreditPlanAbbr, FlagPayPlan, FlagPayPlanEligible,FlagCreditPlan,FlagCreditEligible, paymentPlanID, BlueCreditID,FlagAllowClose" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No active statements exist on this account.<br>&nbsp;">
                            <DetailTables>
                                       <telerik:GridTableView DataKeyNames="StatementID,FilePathStatements, FileName, InvoiceDateRaw"  Name="SummaryDetails" AutoGenerateColumns="False" Width="100%">
                                           <Columns>
                                               <telerik:GridBoundColumn HeaderText="Cycle ID" DataField="CycleID">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Due Date" DataField="DueDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Charges" DataField="Charges$" SortExpression="Charges">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Insurance" DataField="Insurance$" SortExpression="Insurance">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Min Payment" DataField="MinPayAmount$" SortExpression="MinPayAmount">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Payments" DataField="Payments$" SortExpression="Payments">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Adjustments" DataField="Adjustments$" SortExpression="Adjustments">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridButtonColumn CommandName="View" HeaderText="View" ButtonType="ImageButton" ImageUrl="~/Content/Images/view.png">
                                               </telerik:GridButtonColumn> 
                                               <telerik:GridButtonColumn CommandName="Download" HeaderText="Download" ButtonType="ImageButton"
                                                   UniqueName="downloadPDF" ImageUrl="~/Content/Images/icon_pdfblue.gif">
                                               </telerik:GridButtonColumn>
                                           </Columns>
                                       </telerik:GridTableView>
                            </DetailTables>
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Due Date" DataFormatString="{0:MM/dd/yyyy}" DataField="DueDateRaw">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Charges" DataField="Charges$" SortExpression="Charges">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Payments" DataField="Payments$" SortExpression="Payments">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Last Payment" DataField="LastPayment$" SortExpression="LastPayment">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn CommandName="Pay" UniqueName="Pay" HeaderText="Payment" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_paynow.png" Text="Process a payment from the patient.">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="Adjust" HeaderText="Adjust" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_adjust.gif" Text="Adjust charges or credits on the statement.">
                                </telerik:GridButtonColumn>
                                <telerik:GridTemplateColumn HeaderText="PayPlan" AllowFiltering="False" >
                                    <ItemTemplate >
                                        <asp:ImageButton ID="imgPayPlan" OnClick="btnPayPlan_OnClick" runat="server"  ToolTip="Create a payment plan for this statement." />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridTemplateColumn HeaderText="BlueCredit" AllowFiltering="False">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="imgCreditPlan"  OnClick="btnCreditPlan_OnClick" runat="server" ToolTip="Add this statement to a new or existing BlueCredit plan." />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridButtonColumn UniqueName="CloseStatement" CommandName="CloseStatement" HeaderText="Close" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_cancelx.gif" Text="Close immediately (zero balance statements are closed automatically every night).">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="View" HeaderText="View" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/view.png" Text="View a copy of the most recent statement.">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="Download" HeaderText="Download" ButtonType="ImageButton"
                                    UniqueName="downloadPDF" ImageUrl="~/Content/Images/icon_pdfblue.gif" Text="Download a PDF of the most recent statement.">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>
                    <br />
                    <br />
                    <h3>Closed Statements</h3>
                    <div>
                        <telerik:radgrid id="gridPatientClosedStatements" runat="server" allowsorting="True"
                            allowpaging="True" pagesize="10" onneeddatasource="gridPatientClosedStatements_NeedDataSource" onitemdatabound="gridPatientClosedStatements_ItemDataBound" ondetailtabledatabind="grd_OnDetailTableDataBind"
                            onitemcommand="gridPatientClosedStatements_OnItemCommand">
                            <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID, FilePathStatements, FileName, FlagRestrictView" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No closed statements exist on this account.<br>&nbsp;">
                                <DetailTables>
                                       <telerik:GridTableView DataKeyNames="StatementID,FilePathStatements, FileName, InvoiceDateRaw"  Name="ClosedStatementDetails" AutoGenerateColumns="False" Width="100%">
                                           <Columns>
                                               <telerik:GridBoundColumn HeaderText="Cycle ID" DataField="CycleID">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Due Date" DataField="DueDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Charges" DataField="Charges$" SortExpression="Charges">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Insurance" DataField="Insurance$" SortExpression="Insurance">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Min Payment" DataField="MinPayAmount$" SortExpression="MinPayAmount">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Payments" DataField="Payments$" SortExpression="Payments">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Adjustments" DataField="Adjustments$" SortExpression="Adjustments">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                               </telerik:GridBoundColumn>
                                               <telerik:GridButtonColumn CommandName="View" HeaderText="View" ButtonType="ImageButton" ImageUrl="~/Content/Images/view.png">
                                               </telerik:GridButtonColumn> 
                                               <telerik:GridButtonColumn CommandName="Download" HeaderText="Download" ButtonType="ImageButton"
                                                   UniqueName="downloadPDF" ImageUrl="~/Content/Images/icon_pdfblue.gif">
                                               </telerik:GridButtonColumn>
                                           </Columns>
                                       </telerik:GridTableView>
                            </DetailTables>
                                <Columns>
                                     <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Last Invoice" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Charges" DataField="Charges$" SortExpression="Charges">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Insurance" DataField="Insurance$" SortExpression="Insurance">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Payments" DataField="Payments$" SortExpression="Payments">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Adjustments" DataField="Adjustments$" SortExpression="Adjustments">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Last Payment" DataField="LastPayment$" SortExpression="LastPayment">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn CommandName="RestrictView" UniqueName="RestrictView" HeaderText="Hide" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_show.png" Text="Indicates if the statement is restricted from being viewed on the Patient Portal.">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="View" HeaderText="View" ButtonType="ImageButton" ImageUrl="~/Content/Images/view.png" Text="View a copy of the most recent statement.">
                                </telerik:GridButtonColumn> 
                                <telerik:GridButtonColumn CommandName="Download" HeaderText="Download" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_pdfblue.gif" Text="Download a PDF of the most recent statement.">
                                </telerik:GridButtonColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:radgrid>
                    </div>
                    <asp:Button ID="btnDownload" runat="server" OnClick="btnDownload_Click" Style="display: none" />
                    <asp:HiddenField ID="hdnDownload" runat="server" />
                    <asp:HiddenField ID="hdnIsRedirect" runat="server" />
                    <asp:HiddenField ID="hdnIsShowPDFViewer" runat="server" />
            </div>
            <telerik:radwindowmanager id="RadWidowManager" showcontentduringload="True" visiblestatusbar="False"
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
                        <div style="margin-top: 20px; margin-left: 76px;">
                            <a href="#" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:radwindowmanager>
            <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="650px"
                modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                restrictionzoneid="divMainContent" skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize"
                style="z-index: 3000">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popupAddTransactions" NavigateUrl="~/report/addTransactions_popup.aspx"
                        width="700px" height="520px" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupPayStatement" Width="720" Height="675"
                        NavigateUrl="~/report/pc_add_popup_lite.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupPaymentReceipt" NavigateUrl="~/report/paymentReceipt_popup.aspx"
                        Width="450" Height="670" CssClass="customprintbutton" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupActiveStatements" Width="1200px" Height="800px"
                        NavigateUrl="~/report/bluecredit_addcredit_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupPaymentPlan" Width="790px" Height="500px"
                        NavigateUrl="~/report/managePaymentPlan_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                      <telerik:RadWindow runat="server" ID="popupEditBlueCredit" Width="1050px" Height="780px"
                            NavigateUrl="~/report/bluecredit_editcredit_popup.aspx" DestroyOnClose="True">
                        </telerik:RadWindow>
                </Windows>
            </telerik:radwindowmanager>
            <telerik:radwindow runat="server" id="popupEstimateView" cssclass="customprintbutton"
                onclientshow="OnClientShow" navigateurl="~/report/estimateview_popup.aspx" destroyonclose="True"
                showcontentduringload="True" visiblestatusbar="False" visibletitlebar="True"
                reloadonshow="True" width="860px" height="850px" modal="True" enableshadow="False"
                enableembeddedbasestylesheet="False" enableembeddedskins="False" behaviors="Pin,Reload,Close,Move,Resize"
                skin="CareBlueInv">
            </telerik:radwindow>
            <telerik:radwindow runat="server" id="popupProgress" visibletitlebar="False" visiblestatusbar="False"
                restrictionzoneid="divMainContent" enableembeddedskins="False" skin="Sunset" borderstyle="None"
                borderwidth="0" modal="true" width="316px" height="166px">
                <ContentTemplate>
                    <div align="center" style="vertical-align: middle; width: 100%; height: 100%">
                        <img src="../Content/Images/poptimer_pleasewait.gif" alt="Processing">
                    </div>
                </ContentTemplate>
            </telerik:radwindow>
            <asp:Button ID="btnCreatePDF" OnClick="btnCreatePDF_OnClick" runat="server" Style="display: none" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
 <script type="text/javascript" language="javascript">
     var prm = Sys.WebForms.PageRequestManager.getInstance();
     prm.add_endRequest(function () {
         $(function () {
             
             var hdnDownload = $("#<%=hdnDownload.ClientID %>");

                if (hdnDownload.val() != "") {
                    hdnDownload.val("");
                    $("#<%=btnDownload.ClientID %>").click();
                }

                if ($("#<%=hdnIsShowPDFViewer.ClientID %>").val() == "1") {
                    viewPdfViewer();
                    $("#<%=hdnIsShowPDFViewer.ClientID %>").val("");
                }

                if ($("#<%=hdnIsRedirect.ClientID %>").val() == "1") {
                    location.href = "<%=ClientSession.WebPathRootProvider %>" + 'patient/bluecredit.aspx';
                }

                if ($("#<%=hdnIsRedirect.ClientID %>").val() == "2") {
                    location.href = "<%=ClientSession.WebPathRootProvider %>" + 'patient/paymentplans.aspx';
                }


            });
        });


        function viewPdfViewer() {
            var popupName = "Estimate";
            var location = "<%=ClientSession.WebPathRootProvider %>" + "report/pdfviewer_popup.aspx";
            window.open(location, popupName, "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");
        }

        function redirectToPatientTransactionPage() {
            var url = "<%=ClientSession.WebPathRootProvider %>" + 'patient/transactions.aspx?StatementID=<%=ClientSession.ObjectID %>';
            location.href = url;
        }

    </script>
</asp:Content>