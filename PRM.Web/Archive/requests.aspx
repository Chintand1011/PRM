<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="requests.aspx.cs"
    Inherits="search" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>
                    BlueCredit Account Requests</h1>
            </div>
            <div class="bodyMain">
                <h2>
                    Below are outstanding patient requests for BlueCredit accounts. </h2>
                <table width="100%">

                <tr>
                    <td width="28%" valign="top">
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label1" runat="server" Text="Patient:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <telerik:RadComboBox ID="cmbPatients" runat="server" Width="200px" EmptyMessage="All Patients..."
                                    onkeyup="validateEvent(event)" AllowCustomText="False" MarkFirstMatch="True"
                                    DataTextField="PatientAbbr" DataValueField="PatientID" MaxHeight="200">
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
                                    DataTextField="Abbr" DataValueField="CreditTypeID">
                                </telerik:RadComboBox>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label6" runat="server" Text="Status:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <telerik:RadComboBox ID="cmbStatus" runat="server" Width="200px" EmptyMessage="All status"
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
                            <asp:ImageButton ID="btnSearch" CssClass="btn-search" ImageUrl="../Content/Images/btn_search.gif"
                                OnClick="btnSearch_Click" runat="server" ValidationGroup="Credit" />
                        </div>
                        <div>
                            <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="Credit"
                                ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <hr />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:ImageButton ID="btnReport" ImageUrl="../Content/Images/btn_export.gif" CssClass="grd-search-align"
                            OnClick="btnReport_Click" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <telerik:RadGrid ID="grdBlueCreditHistory" runat="server" AllowSorting="True" AllowPaging="True"
                            PageSize="25" OnNeedDataSource="grdBlueCreditHistory_NeedDataSource" OnItemCommand="grdBlueCreditHistory_OnItemCommand"
                            OnItemDataBound="grdBlueCreditHistory_ItemDataBound">
                            <MasterTableView AutoGenerateColumns="False" DataKeyNames="BlueCreditID,TUPFSID">
                                <Columns>
                                    <telerik:GridBoundColumn HeaderText="Account ID" DataField="BlueCreditID">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Opened" DataField="OpenDate">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Responsible Party" DataField="AccountHolder">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Status" DataField="CreditStatusTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Type" DataField="PlanName">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Class" DataField="PFSClass">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="PFS" DataField="PFSScore">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridButtonColumn CommandName="ViewCreditAccountHistory" HeaderText="FICO"
                                        UniqueName="FICO" ButtonType="ImageButton" ImageUrl="~/Content/Images/view.png">
                                    </telerik:GridButtonColumn>
                                    <telerik:GridBoundColumn HeaderText="Grade" DataField="PFSGrade">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Limit" DataField="CreditLimit$">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="In Use" DataField="Balance$">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridButtonColumn CommandName="ViewTransactionHistory" HeaderText="History"
                                        ButtonType="ImageButton" ImageUrl="~/Content/Images/view.png">
                                    </telerik:GridButtonColumn>
                                    <telerik:GridButtonColumn CommandName="EditCreditAccountHistory" HeaderText="Edit"
                                        ButtonType="ImageButton" ImageUrl="~/Content/Images/edit.png">
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
                VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="1100px" Height="900px"
                Modal="True" EnableShadow="False" EnableEmbeddedBaseStylesheet="False" EnableEmbeddedSkins="False"
                Skin="CareBlue" Behaviors="Pin,Reload,Close,Move,Resize" Style="z-index: 3000">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popupCreditReport" Width="810px" Height="850px"
                        NavigateUrl="~/report/pfs_viewpro_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupTransactionHistory" Width="1000px" Height="800px"
                        NavigateUrl="~/report/CreditTransHistory_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupEditBlueCredit" Width="1050px" Height="780px"
                        NavigateUrl="~/report/bluecredit_editcredit_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                </Windows>
            </telerik:RadWindowManager>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnReport" />
        </Triggers>
    </asp:UpdatePanel>
    <script type="text/javascript">
        
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
    <script type="text/javascript" src="../Scripts/blockEnterEvent.js"></script>
</asp:Content>
