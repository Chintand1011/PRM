<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="useraudit.aspx.cs"
    Inherits="search" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>User Action Audit Log</h1>
            </div>
            <div class="bodyMain">
                <h2>Use any combination of filters to search for user actions. Results can be exported to Excel using the link to the right.
                </h2>

                <div style="margin:-30px 5px 0px 0px;">
                        <asp:ImageButton ID="btnReport" ImageUrl="../Content/Images/btn_export_small.gif" CssClass="grd-search-align" OnClick="btnReport_Click" runat="server" ToolTip="Export search results to Excel file." />
                        <img src="../Content/Images/btn_print_small.gif" style="cursor: pointer; margin-right:10px;" alt="Print results." onclick="showPrintUserAuditPopup()" class="grd-search-align" />
                    <br />
                    <br />
                </div>

                <div>
                    <telerik:radpanelbar runat="server" id="RadPanelBar1" width="1161">
                        <Items>
                            <telerik:RadPanelItem Expanded="False" Text="Filters">
                                <ContentTemplate>
                                    <table style="margin-top: 15px">
                                        <tr>
                                            <td width="180" valign="top">
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label4" runat="server" Text="Practice:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbPractices" runat="server" Width="200px" EmptyMessage="All Practices..." OnSelectedIndexChanged="cmbPractice_OnSelectedIndexChanged" AutoPostBack="True"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="PracticeID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label3" runat="server" Text="Location:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbLocations" runat="server" Width="200px" EmptyMessage="All Locations..."
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="LocationID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label1" runat="server" Text="Patient:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbPatients" runat="server" Width="300px" EmptyMessage="All Patients..."
                                                            AllowCustomText="True" EnableLoadOnDemand="True" ItemRequestTimeout="500"
                                                            OnItemsRequested="cmbPatients_ItemsRequested" MarkFirstMatch="True" DataTextField="ComboBoxAbbr" DataValueField="PatientID" MaxHeight="200">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                            </td>
                                            <td width="50%" valign="top">
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label5" runat="server" Text="System User:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbSysUsers" runat="server" Width="200px" EmptyMessage="All Users..."
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="NameAbbr" DataValueField="SysUserID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label2" runat="server" Text="Audit Type:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbAuditTypes" runat="server" Width="200px" EmptyMessage="All Types..."
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="AuditTypeID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label7" runat="server" Text="Action Date:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadDatePicker ID="dtDateMin" runat="server" MinDate="1/1/2010" CssClass="set-telerik-ctrl-width" Width="120">
                                                        </telerik:RadDatePicker>
                                                        -
                                                        <telerik:RadDatePicker ID="dtDateMax" runat="server" MinDate="1/1/2010" CssClass="set-telerik-ctrl-width" Width="120">
                                                        </telerik:RadDatePicker>
                                                        <asp:CompareValidator ID="CompareValidator2" ControlToValidate="dtDateMax" ControlToCompare="dtDateMin"
                                                            Operator="GreaterThan" Display="dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                            ErrorMessage="Date must be greater." ToolTip="Date must be greater." runat="server"
                                                            ValidationGroup="UserActions" Text="*" />
                                                    </div>
                                                </div>
                                                <div class="margin-left-search-buttons">
                                                    <asp:ImageButton ID="btnClear" ImageUrl="../Content/Images/btn_clear.gif" CssClass="btn-clear"
                                                        OnClick="btnClear_Click" runat="server" />
                                                    &nbsp;
                                                    <asp:ImageButton ID="btnSearch" CssClass="btn-search" ImageUrl="../Content/Images/btn_search.gif"
                                                        OnClick="btnSearch_Click" OnClientClick="showProgressPopup();" runat="server" ValidationGroup="UserActions" />
                                                </div>
                                                <div>
                                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="UserActions"
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
                            <telerik:radgrid id="grdUserActions" runat="server" allowsorting="True" allowpaging="True"
                                allowfilteringbycolumn="false" pagesize="20" onneeddatasource="grdUserActions_NeedDataSource">
                                <MasterTableView AutoGenerateColumns="False" DataKeyNames="AuditID">
                                    <Columns>
                                        <telerik:GridBoundColumn HeaderText="ID" DataField="AuditID">
                                        </telerik:GridBoundColumn>                                      
                                        <telerik:GridBoundColumn HeaderText="Date" DataField="DateCreated" DataFormatString="{0:MM/dd/yyyy} {0:T}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Type" DataField="AuditTypeAbbr">
                                        </telerik:GridBoundColumn>                                      
                                        <telerik:GridBoundColumn HeaderText="Action" DataField="ProcName">
                                        </telerik:GridBoundColumn>                                      
                                        <telerik:GridBoundColumn HeaderText="User" DataField="UserNameAbbr">
                                        </telerik:GridBoundColumn>                                      
                                        <telerik:GridBoundColumn HeaderText="Practice" DataField="PracticeAbbr">
                                        </telerik:GridBoundColumn>                                      
                                        <telerik:GridBoundColumn HeaderText="Location" DataField="LocationAbbr">
                                        </telerik:GridBoundColumn>                                      
                                    </Columns>
                                </MasterTableView>
                                <ExportSettings>
                                    <Excel Format="Biff"></Excel>
                                </ExportSettings>
                            </telerik:radgrid>
                        </td>
                    </tr>
                </table>
                <telerik:radwindow runat="server" id="popupProgress" visibletitlebar="False" visiblestatusbar="False" autosize="False"
                    restrictionzoneid="divMainContent" enableembeddedskins="False" skin="Sunset" borderstyle="None"
                    borderwidth="0" modal="true" width="316px" height="166px">
                    <ContentTemplate>
                        <div align="center" style="vertical-align: middle; width: 100%; height: 100%">
                            <img src="../Content/Images/poptimer_pleasewait.gif" alt="Processing">
                        </div>
                    </ContentTemplate>
                </telerik:radwindow>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnReport" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript">

        var prm = Sys.WebForms.PageRequestManager.getInstance();

        function showProgressPopup() {
            $find("<%=popupProgress.ClientID%>").show();
        }

        function showPrintUserAuditPopup() {
            var location = "<%=ClientSession.WebPathRootProvider %>" + "report/printUserAudit_popup.aspx";
            window.open(location, "Print Statements", "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");
        }

    </script>
</asp:Content>