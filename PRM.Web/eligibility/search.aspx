<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="search.aspx.cs"
    Inherits="search" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1><%= FlagManageEligibility ? "Eligibilty Flag is ON" : "Eligibility Search" %> </h1>
            </div>
            <div class="bodyMain">
                <h2><%= FlagManageEligibility ? "Eligibilty Flag is ON, you can now add some description here" : "Description will be there..." %>
                    <asp:ImageButton ID="btnReport" ImageUrl="../Content/Images/btn_export.gif" CssClass="grd-search-align"
                        OnClick="btnReport_Click" runat="server" />
                </h2>

                <div>
                    <telerik:radpanelbar runat="server" id="RadPanelBar1" width="1161">
                        <Items>
                            <telerik:RadPanelItem Expanded="False" Text="Filters">
                                <ContentTemplate>
                                    <table class="align-label" style="margin-top: 15px">
                                        <tr>
                                            <td width="28%" valign="top">
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label1" runat="server" Text="Patient:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbPatients" runat="server" Width="200px" EmptyMessage="All Patients..."
                                                            AllowCustomText="True" EnableLoadOnDemand="True" ItemRequestTimeout="500" OnItemsRequested="cmbPatients_ItemsRequested" MarkFirstMatch="True" DataTextField="ComboBoxAbbr" DataValueField="PatientID"
                                                            MaxHeight="200">
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
                                                        <asp:Label ID="Label5" runat="server" Text="Carrier:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbCarrier" runat="server" Width="200px" EmptyMessage="All Carriers"
                                                            MaxHeight="200" AllowCustomText="False" MarkFirstMatch="True" DataTextField="CarrierName"
                                                            DataValueField="CarrierID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label6" runat="server" Text="Status:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbStatus" runat="server" Width="200px" EmptyMessage="All Statuses"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="EligibilityStatusTypeID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label7" runat="server" Text="Date:"></asp:Label>
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
                                                            ValidationGroup="Eligibility" Text="*" />
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label8" runat="server" Text="Coverage Type:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbCoverageType" runat="server" Width="200px" EmptyMessage="All Coverage Types..."
                                                            AllowCustomText="False" MarkFirstMatch="True" MaxHeight="200">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="margin-left-search-buttons">
                                                    <asp:ImageButton ID="btnClear" ImageUrl="../Content/Images/btn_clear.gif" CssClass="btn-clear"
                                                        OnClick="btnClear_Click" runat="server" />
                                                    &nbsp;
                                <asp:ImageButton ID="btnSearch" CssClass="btn-search" ImageUrl="../Content/Images/btn_search.gif" OnClientClick="return showProgressPopup();"
                                    OnClick="btnSearch_Click" runat="server" ValidationGroup="Eligibility" />
                                                </div>
                                                <div>
                                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="Eligibility"
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
                            <telerik:radgrid id="grdEligibilityHistory" runat="server" allowsorting="True" allowpaging="True"
                                pagesize="20" onneeddatasource="grdEligibilityHistory_NeedDataSource" onprerender="grdEligibilityHistory_PreRender" onitemcommand="grdEligibilityHistory_OnItemCommand">
                                <MasterTableView AutoGenerateColumns="False" DataKeyNames="EligibilityID,PayerIDCode" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No results match your search. If filters are in use, clear the values and try again.<br>&nbsp;">
                                    <Columns>
                                        <telerik:GridButtonColumn CommandName="ViewEligilityInfo" HeaderText="View" ButtonType="ImageButton"
                                            UniqueName="View" ImageUrl="~/Content/Images/view.png">
                                        </telerik:GridButtonColumn>
                                        <telerik:GridBoundColumn HeaderText="Submit Date" DataField="SubmitDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Request ID" DataField="EligibilityID">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Date of Birth" DataField="PatientDOBRaw" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Status" DataField="HBPStatus">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Subscriber" DataField="SubscriberName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Relation" DataField="RelationshipType">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Carrier" DataField="CarrierName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridButtonColumn CommandName="ManageEligibility" HeaderText="Manage" Visible="False" ButtonType="ImageButton"
                                            UniqueName="Manage" ImageUrl="~/Content/Images/icon_expand.gif">
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
                <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="1100px" height="850px"
                    modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize" style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupEligibility" NavigateUrl="~/report/eligibility_popup.aspx"
                            DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupRequestBenefit" NavigateUrl="~/report/requestpatientbenefit_popup.aspx"
                            DestroyOnClose="True">
                        </telerik:RadWindow>
                    </Windows>
                </telerik:radwindowmanager>
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
                isPageValid = Page_ClientValidate('Eligibility');
            }

            if (isPageValid) {
                blockUI();
            }

            return isPageValid;
        }

        function openEligibilityDetail() {
            location.href = location.href;
        }

        function redirectEstimatePage() {
            location.href = "<%=ClientSession.WebPathRootProvider %>" + "admin/estimate.aspx";
        }

    </script>
</asp:Content>