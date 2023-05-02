<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="pfsreports.aspx.cs"
    Inherits="pfscharges" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnReport" />
        </Triggers>
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Credit Inquiry Report</h1>
            </div>
            <div class="bodyMain">
                <h2>Search all past credit inquiries. Use the filter to refine the results as needed. 
                     <asp:ImageButton ID="btnReport" ImageUrl="../Content/Images/btn_export.gif" CssClass="grd-search-align" Style="margin-top: 10px;"
                         runat="server" OnClick="btnReport_OnClick" />
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
                                                        <telerik:RadComboBox ID="cmbPatients" runat="server" Width="200px" EmptyMessage="All Patients..." AutoPostBack="True"
                                                            onkeyup="validateEvent(event)" AllowCustomText="False" MarkFirstMatch="True" OnSelectedIndexChanged="cmbPatients_SelectedIndexChanged"
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
                                                        <asp:Label ID="Label6" runat="server" Text="Result Type:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbResultType" runat="server" Width="200px" EmptyMessage="Result Type"
                                                            onkeyup="validateEvent(event)" DataTextField="Abbr" DataValueField="TUResultTypeID"
                                                            AllowCustomText="False" MarkFirstMatch="True">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label7" runat="server" Text="Reason Type:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbReasonType" runat="server" Width="200px" EmptyMessage="Reason Type"
                                                            onkeyup="validateEvent(event)" DataTextField="Abbr" DataValueField="TUReasonTypeID"
                                                            AllowCustomText="False" MarkFirstMatch="True">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="margin-left-search-buttons">
                                                    <asp:ImageButton ID="btnClear" ImageUrl="../Content/Images/btn_clear.gif" CssClass="btn-clear"
                                                        OnClick="btnClear_Click" runat="server" />
                                                    &nbsp;
                                <asp:ImageButton ID="btnSearch" CssClass="btn-search" ImageUrl="../Content/Images/btn_search.gif"
                                    OnClick="btnSearch_Click" runat="server" ValidationGroup="Transaction" />
                                                </div>
                                                <%--<div class="form-row">
                            <div class="editor-label">
                                <asp:Label runat="server" Text="Patient:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <telerik:RadComboBox ID="cmbPatients" runat="server" Width="350px" EmptyMessage="Choose Patient..."
                                    AllowCustomText="False" MarkFirstMatch="True" DataTextField="PatientAbbr" DataValueField="PatientID"
                                    MaxHeight="200" OnSelectedIndexChanged="cmbPatients_SelectedIndexChanged" AutoPostBack="True">
                                </telerik:RadComboBox>
                            </div>
                        </div>--%>
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
                            <telerik:radgrid id="grdPastCreditReports" runat="server" allowsorting="True" allowpaging="True"
                                pagesize="15" onneeddatasource="grdPastCreditReports_NeedDataSource" onitemcommand="grdPastCreditReports_OnItemCommand"
                                onitemdatabound="grdPastCreditReports_ItemDataBound">
                                <MasterTableView AutoGenerateColumns="False" DataKeyNames="PFSID, PatientID, InputNameFirst, InputNameLast, InputDOB, InputSSNenc, InputAddrStreet, InputAddrCity, InputAddrState, InputAddrZip, TUResultTypeID">
                                    <Columns>
                                        <telerik:GridBoundColumn HeaderText="PFS ID" DataField="PFSID">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Submit Date" DataField="SubmitDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn UniqueName="AddPatient" HeaderText="Patient" AllowFiltering="False">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="btnCreatePatient" ImageUrl="~/Content/Images/check.png" OnClick="btnCreatePatient_OnClick" runat="server" />
                                                <asp:Label ID="lblCreatePatient" Visible="False" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn HeaderText="Borrower Name" DataField="rptName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Date of Birth" DataField="rptDOB" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Provider" DataField="ProviderName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Result" DataField="ResultTypeAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="SSN" DataField="respSSN4">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Score" DataField="respScoreBCResult">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="FPL%" DataField="respCalcFPL">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Requestor" DataField="SysUserName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridButtonColumn CommandName="ViewHistory" HeaderText="View" UniqueName="View" ButtonType="ImageButton"
                                            ImageUrl="~/Content/Images/view.png">
                                        </telerik:GridButtonColumn>
                                    </Columns>
                                </MasterTableView>
                                <ExportSettings>
                                    <Excel Format="Biff"></Excel>
                                </ExportSettings>
                            </telerik:radgrid>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;<br />
                            <asp:HiddenField ID="hdnLastDayCount" runat="server" />
                            <asp:ImageButton ID="btnRunNew" runat="server" ImageUrl="../Content/Images/btn_runnew.gif"
                                OnClick="btnRunNew_Click" Style="float: right;"
                                Visible="False" />
                        </td>
                    </tr>
                </table>
                <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="810px" height="850px"
                    behaviors="Pin,Reload,Close,Move,Resize" modal="True" enableshadow="False" enableembeddedbasestylesheet="False"
                    enableembeddedskins="False" skin="CareBlue" style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupCreditReport" NavigateUrl="~/report/pfs_viewpro_popup.aspx"
                            DestroyOnClose="True">
                        </telerik:RadWindow>
                        <%--<telerik:RadWindow runat="server" ID="popupRequestBenefit" VisibleTitlebar="False"
                        VisibleStatusbar="False" Width="800px" Height="500px" Modal="true" NavigateUrl="~/report/requestpatientbenefit_popup.aspx"
                        DestroyOnClose="True">
                    </telerik:RadWindow>--%>
                    </Windows>
                </telerik:radwindowmanager>
                <telerik:radwindowmanager id="radWindowDialog" showcontentduringload="True" visiblestatusbar="False"
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
                <asp:HiddenField ID="hdnPatientButtonClientID" runat="server"/>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnRunNew" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
  <script type="text/javascript">

      function redirectToPFSReport() {

      }
      
      // Being used from pfs_viewpro_popup
      function addPatient() {
          var clientID = $("#<%=hdnPatientButtonClientID.ClientID%>").val();
            if (clientID != '') {
                $("#" + clientID).click();
            }
        }

    </script>
</asp:Content>