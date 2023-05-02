<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="search.aspx.cs"
    Inherits="search" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Account Search</h1>
            </div>
            <div class="bodyMain">
                <h2>Description text will be there...
                    <asp:ImageButton ID="btnReport" ImageUrl="../Content/Images/btn_export.gif" CssClass="grd-search-align" Style="margin-top: 10px;"
                        OnClick="btnReport_Click" runat="server" />
                </h2>

                <div>
                    <telerik:radpanelbar runat="server" id="RadPanelBar1" width="1161">
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
                                                        <telerik:RadComboBox ID="cmbPublicStatus" runat="server" Width="200px" EmptyMessage="All Patients"
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
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="LocationID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label3" runat="server" Text="Provider:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbProviders" runat="server" Width="200px" EmptyMessage="All Providers"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="ProviderAbbr" DataValueField="ProviderID">
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
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="AccountTypeID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label6" runat="server" Text="Status:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbStatus" runat="server" Width="200px" EmptyMessage="All status"
                                                            DataTextField="Abbr" DataValueField="AccountStatusTypeID" AllowCustomText="False"
                                                            MarkFirstMatch="True">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label7" runat="server" Text="Open Date:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadDatePicker ID="dtDateMin" runat="server" MinDate="1/1/2010" CssClass="set-telerik-ctrl-width">
                                                        </telerik:RadDatePicker>
                                                        -
                                    <telerik:RadDatePicker ID="dtDateMax" runat="server" MinDate="1/1/2010" CssClass="set-telerik-ctrl-width">
                                    </telerik:RadDatePicker>
                                                        <asp:CompareValidator ID="CompareValidator2" ControlToValidate="dtDateMax" ControlToCompare="dtDateMin"
                                                            Operator="GreaterThan" Display="dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                            ErrorMessage="Date must be greater." ToolTip="Date must be greater." runat="server"
                                                            ValidationGroup="Account" Text="*" />
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
                                                            ValidationGroup="Account" Text="*" />
                                                    </div>
                                                </div>
                                                <div class="margin-left-search-buttons">
                                                    <asp:ImageButton ID="btnClear" ImageUrl="../Content/Images/btn_clear.gif" CssClass="btn-clear"
                                                        OnClick="btnClear_Click" runat="server" />
                                                    &nbsp;
                                <asp:ImageButton ID="btnSearch" CssClass="btn-search" ImageUrl="../Content/Images/btn_search.gif" OnClientClick="showProgressPopup();"
                                    OnClick="btnSearch_Click" runat="server" ValidationGroup="Account" />
                                                </div>
                                                <div>
                                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="Account"
                                                        ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                        CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                                                </div>
                                            </td>
                                        </tr>

                                    </table>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:radpanelbar>
                </div>
                <table width="100%">
                    <tr>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <telerik:radgrid id="grdAccount" runat="server" allowsorting="True" allowpaging="True"
                                pagesize="20" onneeddatasource="grdAccount_NeedDataSource" onitemdatabound="grdAccount_OnItemDataBound">
                                <MasterTableView AutoGenerateColumns="False" DataKeyNames="AccountID,FlagBlueCreditAbbr,FlagPayPlanAbbr" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No results match your search. If filters are in use, clear the values and try again.<br>&nbsp;">
                                    <Columns>
                                        <telerik:GridBoundColumn HeaderText="Date" DataField="DateLastUpdateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="AccountID" DataField="AccountID">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Statements" DataField="TotalStatements">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Charges" DataField="ChargesSum$" SortExpression="ChargesSum">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Allowed" DataField="AllowedSum$" SortExpression="AllowedSum">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Ins Estimate" DataField="InsEstSum$">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Ins Actual" DataField="InsActualSum$">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Patient Due" DataField="PatientDueSum$">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Patient Paid" DataField="PatientPaySum$">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Patient Balance" DataField="PatientBalSum$">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn HeaderText="PayPlan" UniqueName="PlayPlan" AllowFiltering="False">
                                            <ItemTemplate>
                                                <asp:Image ID="imgPayPlan" runat="server" />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridTemplateColumn HeaderText="BlueCredit" UniqueName="Bluecredit" AllowFiltering="False">
                                            <ItemTemplate>
                                                <asp:Image ID="imgBlueCredit" runat="server" />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridButtonColumn CommandName="ViewTransaction" HeaderText="View" ButtonType="ImageButton"
                                            UniqueName="View" ImageUrl="~/Content/Images/view.png">
                                        </telerik:GridButtonColumn>
                                    </Columns>
                                </MasterTableView>
                                <ExportSettings>
                                    <Excel Format="Biff"></Excel>
                                </ExportSettings>
                            </telerik:radgrid>
                        </td>
                    </tr>
                </table>
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
            blockUI();
        }


    </script>
</asp:Content>
