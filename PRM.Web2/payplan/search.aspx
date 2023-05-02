<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="search.aspx.cs"
    Inherits="search" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>PaymentPlan Search
                </h1>
            </div>
            <div class="bodyMain">
                <h2>Description text will be there...
                    <asp:ImageButton ID="btnReport" ImageUrl="../Content/Images/btn_export.gif" CssClass="grd-search-align" Style="margin-top: 10px;"
                        OnClick="btnReport_Click" runat="server" />
                </h2>
                <div>
                    <telerik:RadPanelBar runat="server" ID="RadPanelBar1" Width="1161">
                        <Items>
                            <telerik:RadPanelItem Expanded="False" Text="Filters">
                                <ContentTemplate>
                                    <table style="margin-top: 15px">
                                        <tr>
                                            <td width="28%" valign="top">
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label1" runat="server" Text="Patient:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbPatients" runat="server" Width="200px" EmptyMessage="All Patients..."
                                                            AllowCustomText="True" EnableLoadOnDemand="True" ItemRequestTimeout="500"
                                                             OnItemsRequested="cmbPatients_ItemsRequested" MarkFirstMatch="True" DataTextField="ComboBoxAbbr" DataValueField="PatientID" MaxHeight="200">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label4" runat="server" Text="Patient Status:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbPublicStatus" runat="server" Width="200px" EmptyMessage="Patient Status"
                                                            onkeyup="validateEvent(event)" DataTextField="Abbr" DataValueField="StatusTypeID"
                                                            AllowCustomText="False" MarkFirstMatch="True" MaxHeight="200">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label2" runat="server" Text="Location:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbLocations" runat="server" Width="200px" EmptyMessage="All Locations"
                                                            onkeyup="validateEvent(event)" AllowCustomText="False" MarkFirstMatch="True"
                                                            DataTextField="Abbr" DataValueField="LocationID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label3" runat="server" Text="Provider:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbProviders" runat="server" Width="200px" EmptyMessage="All Providers"
                                                            onkeyup="validateEvent(event)" AllowCustomText="False" MarkFirstMatch="True"
                                                            DataTextField="ProviderAbbr" DataValueField="ProviderID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                            </td>
                                            <td width="50%" valign="top">
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label6" runat="server" Text="Status:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbStatus" runat="server" Width="200px" EmptyMessage="All Statuses"
                                                            onkeyup="validateEvent(event)" DataTextField="Abbr" DataValueField="CreditStatusTypeID"
                                                            AllowCustomText="False" MarkFirstMatch="True">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label7" runat="server" Text="Open Date:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadDatePicker ID="dtDateMin" runat="server" MinDate="1/1/2010" onkeyup="validateEvent(event)"
                                                            CssClass="set-telerik-ctrl-width">
                                                        </telerik:RadDatePicker>
                                                        -
                                    <telerik:RadDatePicker ID="dtDateMax" runat="server" MinDate="1/1/2010" onkeyup="validateEvent(event)"
                                        CssClass="set-telerik-ctrl-width">
                                    </telerik:RadDatePicker>
                                                        <asp:CompareValidator ID="CompareValidator2" ControlToValidate="dtDateMax" ControlToCompare="dtDateMin"
                                                            Operator="GreaterThan" Display="dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                            ErrorMessage="Date must be greater." ToolTip="Date must be greater." runat="server"
                                                            ValidationGroup="PayPlan" Text="*" />
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label8" runat="server" Text="Outstanding Balance:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadNumericTextBox runat="server" ID="txtAmountMin" onkeyup="validateEvent(event)"
                                                            Type="Number" NumberFormat-DecimalDigits="2" NumberFormat-GroupSeparator=",">
                                                        </telerik:RadNumericTextBox>
                                                        -
                                    <telerik:RadNumericTextBox runat="server" ID="txtAmountMax" onkeyup="validateEvent(event)"
                                        Type="Number" NumberFormat-DecimalDigits="2" NumberFormat-GroupSeparator=",">
                                    </telerik:RadNumericTextBox>
                                                        <asp:CompareValidator ID="CompareValidator1" ControlToValidate="txtAmountMax" ControlToCompare="txtAmountMin"
                                                            Operator="GreaterThan" Display="dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                            ToolTip="Amount must be greater." ErrorMessage="Amount must be greater." runat="server"
                                                            ValidationGroup="PayPlan" Text="*" />
                                                    </div>
                                                </div>
                                                <div class="margin-left-search-buttons">
                                                    <asp:ImageButton ID="btnClear" ImageUrl="../Content/Images/btn_clear.gif" CssClass="btn-clear"
                                                        OnClick="btnClear_Click" runat="server" />
                                                    &nbsp;
                                <asp:ImageButton ID="btnSearch" CssClass="btn-search" ImageUrl="../Content/Images/btn_search.gif" OnClientClick="return showProgressPopup();"
                                    OnClick="btnSearch_Click" runat="server" ValidationGroup="PayPlan" />
                                                </div>
                                                <div>
                                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="PayPlan"
                                                        ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                        CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:RadPanelBar>
                </div>
                <table width="100%">
                    <tr>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <telerik:RadGrid ID="grdViewPlanHistory" runat="server" AllowSorting="True" AllowPaging="True" EnableLinqExpressions="False"
                                PageSize="20" OnNeedDataSource="grdViewPlanHistory_NeedDataSource" OnItemCommand="grdBlueCreditHistory_OnItemCommand">
                                <MasterTableView ShowFooter="True" AutoGenerateColumns="False" DataKeyNames="PaymentPlanID,Balance,StatementID,PatientID,AccountID" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No results match your search. If filters are in use, clear the values and try again.<br>&nbsp;">
                                    <Columns>
                                        <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Provider" DataField="ProviderName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance" Aggregate="Sum" DataFormatString="{0:c}" SortExpression="Balance">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Next Pay Date" DataField="NextPayDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Next Pay Amount" DataField="NextPayAmount" Aggregate="Sum" DataFormatString="{0:c}" SortExpression="NextPayAmount">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Frequency" DataField="PaymentFreqAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="End Date" DataField="EndDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Account" DataField="AccountName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Status" DataField="CreditStatusTypeAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridButtonColumn CommandName="EditPlan" HeaderText="Edit" UniqueName="Edit"
                                            ButtonType="ImageButton" ImageUrl="~/Content/Images/edit.PNG">
                                        </telerik:GridButtonColumn>
                                    </Columns>
                                </MasterTableView>
                                <ExportSettings>
                                    <Excel Format="Biff"></Excel>
                                </ExportSettings>
                            </telerik:RadGrid>
                        </td>
                    </tr>
                </table>
                <telerik:RadWindowManager ID="RadWindow" ShowContentDuringLoad="True" VisibleStatusbar="False"
                    VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="810px" Height="850px"
                    Modal="True" EnableShadow="False" EnableEmbeddedBaseStylesheet="False" EnableEmbeddedSkins="False"
                    Skin="CareBlue" Behaviors="Pin,Reload,Close,Move,Resize" Style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupCreditReport" NavigateUrl="~/report/pfs_viewpro_popup.aspx"
                            DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupPaymentPlan" Width="790px" Height="500px"
                            NavigateUrl="~/report/managePaymentPlan_popup.aspx" DestroyOnClose="True">
                        </telerik:RadWindow>
                    </Windows>
                </telerik:RadWindowManager>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnReport" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
       <script type="text/javascript">

           var prm = Sys.WebForms.PageRequestManager.getInstance();
           prm.add_endRequest(function () {
               unBlockUI();
           });

           function showProgressPopup() {

               var isPageValid = false;

               if (typeof (Page_ClientValidate) == 'function') {
                   isPageValid = Page_ClientValidate('Payplan');
               }

               if (isPageValid) {
                   blockUI();
               }

               return isPageValid;
           }


           function gridRequestStart(grid, eventArgs) {
               if ((eventArgs.EventTarget.indexOf("gridBtnExcel") != -1) || (eventArgs.EventTarget.indexOf("gridBtnWord") != -1)) {
                   eventArgs.EnableAjax = false;
               }
           }
           function validateEvent(e) {
               if (e.keyCode == 13) {
                   $("#<%=btnSearch.ClientID %>").click();
            }
        }
    </script>
</asp:Content>