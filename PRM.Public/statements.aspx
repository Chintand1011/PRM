<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="statements.aspx.cs"
    Inherits="patient_statements" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <telerik:radajaxmanager id="RadAjaxManager1" runat="server">
    </telerik:radajaxmanager>
    <div class="pgColumn1">
        <h2>Explanation of Page</h2>
        <h4>Access your current and past statements on this page.</h4>
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
            Your provider offers no pay over time options!!!
            <% }  %>
        </h5>
    </div>
    <div class="pgColumn2">
        <h1>Statements</h1>
        <h3>Current Statements</h3>
        <div>
            <telerik:radgrid id="grdPatientStatements" runat="server" allowsorting="True" allowpaging="True"
                pagesize="10" onneeddatasource="grdPatientStatements_NeedDataSource" onitemcommand="grdPatientStatements_OnItemCommand" onitemdatabound="grdPatientStatements_ItemDataBound">
                <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID, Balance, FilePathStatements, FileName,CreditPayAbbr,CreditPlanAbbr" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; You have no current statements. Please check with your provider if you are expecting a statement copy after your visit or procedure.<br>&nbsp;">
                    <Columns>
                    <%-- 
                        <telerik:GridBoundColumn HeaderText="Last Payment" DataField="LastPayment$">
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
                        <telerik:GridButtonColumn CommandName="Pay" UniqueName="Pay" HeaderText="" ButtonType="ImageButton"
                            ImageUrl="~/Content/Images/icon_paynow.PNG">
                        </telerik:GridButtonColumn>
                    </Columns>
                </MasterTableView>
            </telerik:radgrid>
            <asp:HiddenField ID="hdnIsFirstTime" runat="server" />
        </div>
        <h3>Past Statements</h3>
        <div>
            <telerik:radgrid id="gridPatientPreviousHistory" runat="server" allowsorting="True"
                allowpaging="True" pagesize="10" onneeddatasource="gridPatientPreviousHistory_NeedDataSource"
                onitemcommand="gridPatientPreviousHistory_OnItemCommand">
                <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID, FileName, FilePathStatements" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; You have no past statements. Statements will appear here after they are paid and closed.<br>&nbsp;">
                    <Columns>
                    <%--
                        <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                        </telerik:GridBoundColumn>
                        --%>
                        <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderAbbr">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Service Date" DataFormatString="{0:MM/dd/yyyy}" DataField="ServiceDateRaw">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Invoiced" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Charges" DataField="Charges$" SortExpression="Charges">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Payments" DataField="Payments$" SortExpression="Payments">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
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
    </div>
    <asp:HiddenField ID="hdnPaymentMethodsCount" runat="server" />
    <telerik:radwindowmanager id="RadWindowManager" showcontentduringload="True" visiblestatusbar="False"
        visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
        modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
        restrictionzoneid="tblMain" skin="CareBlueInf" style="z-index: 3000">
        <AlertTemplate>
            <div class="rwDialogPopup radalert">
                <h5>
                    <div class="rwDialogText">
                        {1}
                    </div>
                </h5>
                <div style="margin-top: 20px; margin-left: 135px;">
                    <a href="#" onclick="$find('{0}').close(true);">
                        <img src="Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                </div>
            </div>
        </AlertTemplate>
    </telerik:radwindowmanager>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            $(function () {

            });
        });

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }


        function openPaymentTerms() {
            GetRadWindow().BrowserWindow.gotoPaymentTerms();
        }


        function reloadPage() {
            location.href = location.href.replace("#", "");
        }

    </script>
</asp:Content>
