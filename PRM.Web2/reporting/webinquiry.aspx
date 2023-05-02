<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="webinquiry.aspx.cs"
    Inherits="webinquiry" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnReport" />
        </Triggers>
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Web Inquiry Report</h1>
            </div>
            <div class="bodyMain">
                <h2>Search and filter web inquiries to respond to patient leads. Click on the [+] icon to perform a credit check.   
                     <asp:ImageButton ID="btnReport" ImageUrl="../Content/Images/btn_export.gif" CssClass="grd-search-align" Style="margin-top: 10px; margin-right: 10px;"
                         runat="server" OnClick="btnReport_OnClick" />
                </h2>
                <div>
                    <telerik:radpanelbar runat="server" id="RadPanelBar1" width="1161">
                        <Items>
                            <telerik:RadPanelItem Expanded="False" Text="Filters">
                                <ContentTemplate>
                                    <table style="margin-top: 15px">
                                        <tr>
                                            <td width="30%" valign="top">
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
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
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label3" runat="server" Text="Service:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbReasonType" runat="server" Width="200px" EmptyMessage="All Services"
                                                            onkeyup="validateEvent(event)" AllowCustomText="False" MarkFirstMatch="True"
                                                            DataTextField="Abbr" DataValueField="CreditServiceTypeID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                            </td>
                                            <td width="30%" valign="top">
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label5" runat="server" Text="Read Status:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbReadTypes" runat="server" Width="200px" EmptyMessage="All Statuses"
                                                            onkeyup="validateEvent(event)" AllowCustomText="False" MarkFirstMatch="True"
                                                            DataTextField="Abbr" DataValueField="FlagRead">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label6" runat="server" Text="Archive Status:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbArchiveTypes" runat="server" Width="200px" EmptyMessage="All Statuses"
                                                            onkeyup="validateEvent(event)" AllowCustomText="False" MarkFirstMatch="True"
                                                            DataTextField="Abbr" DataValueField="FlagArchive">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                            </td>
                                            <td valign="top">
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label25" runat="server" Text="Last Name:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <asp:TextBox ID="txtName" field="txtName" CssClass="searchTxt" runat="server" width="200"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label7" runat="server" Text="Inquiry Date:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadDatePicker ID="dtDateMin" runat="server" MinDate="1/1/2010" Width="120" CssClass="set-telerik-ctrl-width">
                                                        </telerik:RadDatePicker>
                                                        -
                                                        <telerik:RadDatePicker ID="dtDateMax" runat="server" MinDate="1/1/2010" Width="120"
                                                            CssClass="set-telerik-ctrl-width">
                                                        </telerik:RadDatePicker>
                                                        <asp:CompareValidator ID="CompareValidator2" ControlToValidate="dtDateMax" ControlToCompare="dtDateMin"
                                                            Operator="GreaterThanEqual" Display="dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                            ErrorMessage="End date must be greater than start." ToolTip="End date must be greater than start." runat="server"
                                                            ValidationGroup="Transaction" Text="*" />
                                                    </div>
                                                </div>
                                                <div class="margin-left-search-buttons-tight">
                                                    <asp:ImageButton ID="btnClear" ImageUrl="../Content/Images/btn_clear.gif" CssClass="btn-clear"
                                                        OnClick="btnClear_Click" runat="server" />
                                                    &nbsp;
                                                    <asp:ImageButton ID="btnSearch" CssClass="btn-search" ImageUrl="../Content/Images/btn_search.gif"
                                                        OnClick="btnSearch_Click" runat="server" ValidationGroup="Transaction" />
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
                            <telerik:radgrid id="grdPastInquiries" runat="server" allowsorting="True" allowpaging="True" pagesize="20" onneeddatasource="grdPastInquiries_NeedDataSource" onitemcommand="grdPastInquiries_OnItemCommand" onitemdatabound="grdPastInquiries_ItemDataBound" ondetailtabledatabind="grd_OnDetailTableDataBind">
                                <MasterTableView AutoGenerateColumns="False" DataKeyNames="CreditApplicationID,TUResultTypeIDBool, TUPFSID, NameFirst,NameLast, DateOfBirth,Address1, Address2,City,StateAbbr,ZipCode,Phone,FlagNew,FlagArchive,FlagMessage">
                                    <DetailTables>
                                       <telerik:GridTableView Name="InquiryDetails" AutoGenerateColumns="False" Width="100%">
                                           <Columns>
                                              <telerik:GridBoundColumn HeaderText="Inquiry Details" FilterControlWidth="100%" DataField="Html">
                                               </telerik:GridBoundColumn>
                                           </Columns>
                                       </telerik:GridTableView>
                                    </DetailTables>
                                    <Columns>
                                        <telerik:GridBoundColumn HeaderText="ID" DataField="CreditApplicationID">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridButtonColumn HeaderText="" UniqueName="FlagNew" ButtonType="ImageButton"
                                            ImageUrl="~/Content/images/spacer_transparent.gif">
                                        </telerik:GridButtonColumn>
                                        <telerik:GridBoundColumn HeaderText="Submit Date" DataField="DateCreated" DataFormatString="{0:MM/dd/yyyy hh:mm tt}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Patient Name" DataField="FullName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Date of Birth" DataField="DateofBirth" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="City, State" DataField="CityStateAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Location" DataField="LocationAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Patient" DataField="FlagCurrentPatientAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="IP Address" DataField="IPAddress">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn UniqueName="AddTUPFS" HeaderText="Credit Report" AllowFiltering="False">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="btnCreateTUPFS" FlagShowReport="0" OnClick="btnCreateTUPFS_OnClick" runat="server" />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridButtonColumn CommandName="FlagMessage" HeaderText="Flag" UniqueName="FlagMessage" ButtonType="ImageButton">
                                        </telerik:GridButtonColumn>
                                         <telerik:GridButtonColumn CommandName="Archive" UniqueName="ArchiveView" HeaderText="Archive" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_archive.png">
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
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="810px" height="850px"
                    behaviors="Pin,Reload,Close,Move,Resize" modal="True" enableshadow="False" enableembeddedbasestylesheet="False"
                    enableembeddedskins="False" skin="CareBlue" style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupCreditReport" NavigateUrl="~/report/pfs_viewpro_popup.aspx"
                            DestroyOnClose="True">
                        </telerik:RadWindow>
                    </Windows>
                </telerik:radwindowmanager>
                <telerik:radwindowmanager id="radWindowDialog" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                    modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    restrictionzoneid="divMainContent" skin="CareBlueInf" style="z-index: 3000">
                     <ConfirmTemplate>
                    <div class="rwDialogPopup radconfirm">
                        <h5>
                            <div class="rwDialogText">
                                {1}
                            </div>
                        </h5>
                        <div>
                            <div style="margin-top: 15px; margin-left: 55px;">
                               <a href="javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_ok.gif" alt="Ok" /></a>  &nbsp; &nbsp; 
                                 <a href="Javascript:;" onclick="$find('{0}').close(false);">
                                        <img src="../Content/Images/btn_cancel.gif" alt="Cancel" /></a>
                            </div>
                        </div>
                    </div>
                </ConfirmTemplate>
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
                <asp:HiddenField ID="hdnNotes" runat="server" />
                <asp:HiddenField ID="hdnCreditApplicationID" runat="server" />
                <asp:Button ID="btnSaveNotes" OnClick="btnSaveNotes_OnClick" Style="display: none;" runat="server" />
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript">

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            unBlockUI();
        });

        function redirectToPFSReport() {

        }

        function showProgressPopup() {
            blockUI();
            return true;
        }

        function saveNotes(id) {

            $("#btn_" + id).addClass("disable-button");

            var notes = getNotesTextArea(id).val();

            $("#<%=hdnNotes.ClientID%>").val(notes);
            $("#<%=hdnCreditApplicationID.ClientID%>").val(id);

            $("#<%=btnSaveNotes.ClientID%>").click();

        }

        function updatedMessageAndShowSuccessMessage(id) {
            var spanMessage = $("#spnMessage_" + id);
            spanMessage.text("Internal Notes Updated...");

            setTimeout(function () {
                spanMessage.hide();
            }, 4000);


            getNotesTextArea(id).val($("#<%=hdnNotes.ClientID%>").val());

        }

        function getNotesTextArea(id) {
            return $("#txtArea_" + id);
        }

        function reloadGrid() {
            $("#<%=btnSearch.ClientID%>").click();
        }


        function removeReadImage(imageClientId) {
            $("#" + imageClientId).remove();
        }

        function validateandArchiveLead(isConfirmed) {
            if (isConfirmed) {
                __doPostBack('ArchiveLead');
            }
        }

    </script>
</asp:Content>
