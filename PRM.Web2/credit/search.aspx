<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="search.aspx.cs"
    Inherits="search" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>BlueCredit Search</h1>
            </div>
            <div class="bodyMain">
                <h2>Use any combination of filters to search for current or past patient BlueCredit account. Note that lended funded plans can't be modified.
                    <asp:ImageButton ID="btnReport" ImageUrl="../Content/Images/btn_export.gif" CssClass="grd-search-align" Style="margin-top: 10px"
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
                                                            AllowCustomText="True" EnableLoadOnDemand="True" ItemRequestTimeout="500" OnItemsRequested="cmbPatients_ItemsRequested" MarkFirstMatch="True" DataTextField="ComboBoxAbbr" DataValueField="PatientID" MaxHeight="200">
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
                                                        <asp:Label ID="Label5" runat="server" Text="Types:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbTypes" runat="server" Width="200px" EmptyMessage="All Types"
                                                            onkeyup="validateEvent(event)" AllowCustomText="False" MarkFirstMatch="True"
                                                            DataTextField="PlanName" DataValueField="CreditTypeID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
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
                                                            ValidationGroup="Credit" Text="*" />
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label8" runat="server" Text="Outstanding Balance:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadNumericTextBox runat="server" ID="txtAmountMin" Type="Number" NumberFormat-DecimalDigits="2"
                                                            NumberFormat-GroupSeparator=",">
                                                        </telerik:RadNumericTextBox>
                                                        -
                                    <telerik:RadNumericTextBox runat="server" ID="txtAmountMax" Type="Number" NumberFormat-DecimalDigits="2"
                                        NumberFormat-GroupSeparator=",">
                                    </telerik:RadNumericTextBox>
                                                        <asp:CompareValidator ID="CompareValidator1" ControlToValidate="txtAmountMax" ControlToCompare="txtAmountMin"
                                                            Operator="GreaterThan" Display="dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                            ErrorMessage="Amount must be greater." ToolTip="Amount must be greater." runat="server"
                                                            ValidationGroup="Credit" Text="*" />
                                                    </div>
                                                </div>
                                                <div class="margin-left-search-buttons">
                                                    <asp:ImageButton ID="btnClear" ImageUrl="../Content/Images/btn_clear.gif" CssClass="btn-clear"
                                                        OnClick="btnClear_Click" runat="server" />
                                                    &nbsp;
                                <asp:ImageButton ID="btnSearch" CssClass="btn-search" ImageUrl="../Content/Images/btn_search.gif" OnClientClick="return showProgressPopup();"
                                    OnClick="btnSearch_Click" runat="server" ValidationGroup="Credit" />
                                                </div>
                                                <div>
                                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="Credit"
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
                            <telerik:RadGrid ID="grdBlueCreditHistory" runat="server" AllowSorting="True" AllowPaging="True" EnableLinqExpressions="False"
                                PageSize="20" OnNeedDataSource="grdBlueCreditHistory_NeedDataSource" OnItemCommand="grdBlueCreditHistory_OnItemCommand"
                                OnItemDataBound="grdBlueCreditHistory_ItemDataBound">
                                <MasterTableView ShowFooter="True" AutoGenerateColumns="False" DataKeyNames="BlueCreditID,TUPFSID,PatientID,AccountID" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No results match your search. If filters are in use, clear the values and try again.<br>&nbsp;">
                                    <Columns>
                                        <telerik:GridBoundColumn HeaderText="Loan ID" DataField="BlueCreditID">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Open Date" DataField="OpenDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Borrower" DataField="AccountHolder">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Plan" DataField="PlanName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Status" DataField="CreditStatusTypeAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Type" DataField="PlanType">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Max Term" DataField="TermMaxAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Balance" Aggregate="Sum" DataField="Balance" DataFormatString="{0:c}" SortExpression="Balance">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Scheduled" DataField="NextPayAmountAbbr" SortExpression="NextPayAmount">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Next Pay" DataField="NextPayDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Email" DataField="FlagEmailBillsAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridButtonColumn CommandName="ViewCreditAccountHistory" HeaderText="FICO"
                                            UniqueName="FICO" ButtonType="ImageButton" ImageUrl="~/Content/Images/view.png">
                                        </telerik:GridButtonColumn>
                                        <telerik:GridButtonColumn CommandName="ViewTransactionHistory" HeaderText="History"
                                            ButtonType="ImageButton" UniqueName="View" ImageUrl="~/Content/Images/view.png">
                                        </telerik:GridButtonColumn>
                                        <telerik:GridButtonColumn CommandName="EditCreditAccountHistory" HeaderText="Edit"
                                            ButtonType="ImageButton" UniqueName="Edit" ImageUrl="~/Content/Images/edit.png">
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
                        <telerik:RadWindow runat="server" ID="popupTransactionHistory" Width="850px" Height="710px"
                            NavigateUrl="~/report/CreditTransHistory_popup.aspx" DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupEditBlueCredit" Width="1050px" Height="780px"
                            NavigateUrl="~/report/bluecredit_editcredit_popup.aspx" DestroyOnClose="True">
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

        function showProgressPopup() {

            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('Credit');
            }

            if (isPageValid) {
                blockUI();
            }

            return isPageValid;
        }

    </script>
</asp:Content>