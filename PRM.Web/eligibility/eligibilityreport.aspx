<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="eligibilityreport.aspx.cs"
    Inherits="pfsreports" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnReport" />
        </Triggers>
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Eligibility Inquiry Report</h1>
            </div>
            <div class="bodyMain">
                <h2>THIS IS BORROWED FROM BLUECREDIT AND NEEDS TO BE MODIFIED FOR ELIGIBILITY...</h2>
                <br />
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
                    </telerik:RadPanelBar>
                </div>
                <table width="100%">

                    <tr>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:ImageButton ID="btnReport" ImageUrl="../Content/Images/btn_export.gif" CssClass="grd-search-align"
                                runat="server" OnClick="btnReport_OnClick" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <telerik:RadGrid ID="grdPastCreditReports" runat="server" AllowSorting="True" AllowPaging="True"
                                PageSize="15" OnNeedDataSource="grdPastCreditReports_NeedDataSource" OnItemCommand="grdPastCreditReports_OnItemCommand"
                                OnItemDataBound="grdPastCreditReports_ItemDataBound">
                                <MasterTableView AutoGenerateColumns="False" DataKeyNames="PFSID, respPrintImage,PatientID,InputNameFirst, InputNameLast,InputDOB, InputSSNenc, InputAddrStreet, InputAddrCity, InputAddrZip, InputAddrState">
                                    <Columns>
                                        <telerik:GridBoundColumn HeaderText="PFS ID" DataField="PFSID">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Submit Date" DataField="SubmitDate" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn UniqueName="AddPatient" HeaderText="AddPatient" AllowFiltering="False">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="btnCreatePatient" ImageUrl="~/Content/Images/check.png" OnClick="btnCreatePatient_OnClick" runat="server" />
                                                <asp:Label ID="lblCreatePatient" Visible="False" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn HeaderText="Patient Name" DataField="rptName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Date of Birth" DataField="rptDOB" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="SSN" DataField="rptSSN4">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Result" DataField="ResultTypeAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="FICO" DataField="respScoreBCResult">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Residual" DataField="respCalcRI">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="DTI%" DataField="respCalcDTI">
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
                            </telerik:RadGrid>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;<br />
                            <asp:HiddenField ID="hdnLastDayCount" runat="server" />
                            <asp:ImageButton ID="btnRunNew" runat="server" ImageUrl="../Content/Images/btn_runnew.gif"
                                 OnClientClick="showProgressPopup()" OnClick="btnRunNew_Click" style="float: right;"
                                Visible="False" />
                            
                        </td>
                    </tr>
                </table>
                <telerik:RadWindowManager ID="RadWindow" ShowContentDuringLoad="True" VisibleStatusbar="False"
                    VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="810px" Height="850px"
                    Behaviors="Pin,Reload,Close,Move,Resize" Modal="True" EnableShadow="False" EnableEmbeddedBaseStylesheet="False"
                    EnableEmbeddedSkins="False" Skin="CareBlue" Style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupCreditReport" NavigateUrl="~/report/pfs_viewpro_popup.aspx"
                            DestroyOnClose="True">
                        </telerik:RadWindow>
                        <%--<telerik:RadWindow runat="server" ID="popupRequestBenefit" VisibleTitlebar="False"
                        VisibleStatusbar="False" Width="800px" Height="500px" Modal="true" NavigateUrl="~/report/requestpatientbenefit_popup.aspx"
                        DestroyOnClose="True">
                    </telerik:RadWindow>--%>
                    </Windows>
                </telerik:RadWindowManager>
                <telerik:RadWindow runat="server" ID="popupProgress" VisibleTitlebar="False" VisibleStatusbar="False"
                    RestrictionZoneID="divMainContent" EnableEmbeddedSkins="False" Skin="Sunset" BorderStyle="None"
                    BorderWidth="0" Modal="true" Width="316px" Height="166px">
                    <ContentTemplate>
                        <div align="center" style="vertical-align: middle; width: 100%; height: 100%">
                            <img src="../Content/Images/poptimer_pleasewait.gif" alt="Processing">
                        </div>
                    </ContentTemplate>
                </telerik:RadWindow>
                <telerik:RadWindowManager ID="radWindowDialog" ShowContentDuringLoad="True" VisibleStatusbar="False"
                    VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="700px" Height="500px"
                    Modal="True" EnableEmbeddedBaseStylesheet="False" EnableEmbeddedSkins="False"
                    RestrictionZoneID="divMainContent" Skin="CareBlueInf" Style="z-index: 3000">
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
                </telerik:RadWindowManager>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnRunNew"/>
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript">
        function redirectToPFSReport() {

        }

        function showProgressPopup() {
            $('#<%=popupProgress.ClientID %>').show();
            return true;
        }

    </script>
</asp:Content>