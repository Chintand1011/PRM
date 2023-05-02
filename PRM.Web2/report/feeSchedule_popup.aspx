<%@ Page Language="C#" AutoEventWireup="true" CodeFile="feeSchedule_popup.aspx.cs"
    Inherits="feeSchedule_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />

</head>
<body>
    <form id="form1" runat="server">
        <telerik:radscriptmanager id="RadScriptManager1" runat="server">
        </telerik:radscriptmanager>
        <asp:UpdatePanel ID="updPanelEligility" runat="server">
            <ContentTemplate>
                <div>
                    <table class="CareBluePopup">
                        <tr>
                            <td>
                                <h2p>
                        Fee Schedule Manager
                    </h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>
                        Use this form to manage provider or practice fee schedule codes, charges and reimbursement rates. Note that CPT codes must be unique within each fee schedule.
                    </h4p>
                            </td>
                        </tr>
                        <td>&nbsp;
                                <table width="100%" border="0">
                                    <tr>
                                        <td>
                                            <div align="right">
                                                <a href="#" onclick="closePopup()">
                                                    <img src="../Content/Images/btn_close.gif" class="btn-close" alt="Close" /></a>
                                                &nbsp; <a href="#" onclick="printPopup(this)">
                                                    <img src="../Content/Images/btn_print.gif" class="btn-print" alt="Print" /></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div>
                                                <telerik:radpanelbar runat="server" id="RadPanelBar1" width="100%" style="overflow: hidden;">
                                                    <Items>
                                                        <telerik:RadPanelItem Expanded="False" Text="Fee Schedule Details">
                                                            <ContentTemplate>
                                                                <table width="100%" id="tblFeeSchedulePopup">
                                                                    <tr>
                                                                        <td>
                                                                            <table id="tblFeeShcedule" width="100%">
                                                                                <tr>
                                                                                    <td width="31%" class="ExtraPad align-popup-fields">
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label">
                                                                                                <asp:Label ID="Label4" runat="server">Fee Schedule ID:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblFeeScheduleID" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label">
                                                                                                <asp:Label ID="Label1" runat="server">Schedule Name:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblScheduleName" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label">
                                                                                                <asp:Label ID="Label2" runat="server">Carrier Name:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblCarrierName" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label">
                                                                                                <asp:Label ID="Label5" runat="server">Service Class:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblServiceClass" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td width="37%">
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label">
                                                                                                <asp:Label ID="Label7" runat="server">Provider:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblProvider" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label">
                                                                                                <asp:Label ID="Label9" runat="server">NPI:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblNPI" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label">
                                                                                                <asp:Label ID="Label3" runat="server">Reference ID:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblReferenceID" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label">
                                                                                                <asp:Label ID="Label11" runat="server">Contract Status:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblContractStatus" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td width="32%">
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label">
                                                                                                <asp:Label ID="Label6" runat="server">Schedule Status:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblScheduleStatus" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label">
                                                                                                <asp:Label ID="lbl12" runat="server">Request Date:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblRequestDate" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label">
                                                                                                <asp:Label ID="Label13" runat="server">Expiration:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblExpiration" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label">
                                                                                                <asp:Label ID="Label15" runat="server">ReimBursement:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblReimBursement" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td colspan="3">
                                                                                        <div class="form-row">
                                                                                            <div class="editor-label-left">
                                                                                                <asp:Label ID="Label8" runat="server">Notes:</asp:Label>
                                                                                            </div>
                                                                                            <div class="editor-field">
                                                                                                <asp:Label ID="lblNotes" runat="server"></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </ContentTemplate>
                                                        </telerik:RadPanelItem>
                                                    </Items>
                                                </telerik:radpanelbar>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div align="left">
                                                <br />
                                                <h3p><b>&nbsp;Search, Filter or Edit Procedures and Charges Using the Table Below</b></h3p>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table width="100%">
                                                <tr>
                                                    <td>
                                                        <div class="editor-label-left">
                                                            <asp:Label ID="Label10" runat="server">Search:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:TextBox runat="server" ID="txtSearch" Width="250px"></asp:TextBox>
                                                        </div>
                                                        <div align="left">
                                                            &nbsp; &nbsp; &nbsp;
                                                            <asp:ImageButton runat="server" ID="btnSearch" ImageUrl="../Content/Images/btn_search.gif" OnClick="btnSearch_OnClick" Style="margin-top: 2px;" />
                                                            &nbsp;
                                                            <asp:ImageButton runat="server" ID="btnClearResults" ImageUrl="../Content/Images/btn_clear.gif" OnClick="btnClearResult_OnClick" />
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div align="right">
                                                            <asp:ImageButton ID="btnReport" ImageUrl="../Content/Images/btn_export.gif" OnClick="btnReport_Click" runat="server" />
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="float: right; width: 100%" id="divSchedules">
                                                <telerik:radgrid id="grdSchedules" runat="server" allowsorting="True" allowpaging="True" allowautomaticupdates="False" allowautomaticinserts="False" allowmultirowedit="False"
                                                    onitemcommand="grdSchedules_OnItemCommand" allowfilteringbycolumn="True" onitemdatabound="grdSchedules_OnItemDataBound"
                                                    onneeddatasource="grdSchedules_NeedDataSource" pagesize="10">
                                                    <MasterTableView InsertItemPageIndexAction="ShowItemOnCurrentPage" AutoGenerateColumns="False" DataKeyNames="CPTCode, ServiceTypeID" EditMode="InPlace" CommandItemDisplay="Top">
                                                        <Columns>
                                                            <telerik:GridTemplateColumn HeaderText="CPT Code" DataField="CPTCode" SortExpression="CPTCode">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "CPTCode") %>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:Label ID="lblCpt" runat="server" Visible='<%# (Container is GridEditableItem) %>' Text='<%# Bind("CPTCode")%>'>
                                                                    </asp:Label>
                                                                    <telerik:RadTextBox ID="txtCptCode" Visible='<%# IsShowTextbox %>' MaxLength="5" runat="server" Width="60px" Text='<%# Bind("CPTCode")%>' onkeyup="addUpdateCptInformation(event)">
                                                                    </telerik:RadTextBox>

                                                                </EditItemTemplate>
                                                            </telerik:GridTemplateColumn>

                                                            <telerik:GridTemplateColumn HeaderText="Category" DataField="CPTCategory" SortExpression="CPTCategory">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "CPTCategory") %>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <telerik:RadTextBox ID="txtCategory" runat="server" Width="100px" Text='<%# Bind("CPTCategory")%>' onkeyup="addUpdateCptInformation(event)">
                                                                    </telerik:RadTextBox>
                                                                </EditItemTemplate>
                                                            </telerik:GridTemplateColumn>

                                                            <telerik:GridTemplateColumn HeaderText="CPT Name" DataField="CPTName" SortExpression="CPTName">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "CPTName") %>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <telerik:RadTextBox ID="txtCptName" runat="server" MaxLength="50" Width="150px" Text='<%# Bind("CPTName")%>' onkeyup="addUpdateCptInformation(event)">
                                                                    </telerik:RadTextBox>
                                                                </EditItemTemplate>
                                                            </telerik:GridTemplateColumn>

                                                            <telerik:GridTemplateColumn HeaderText="Provider Charge" DataField="ProviderCharge" SortExpression="ProviderCharge">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "ProviderCharge$") %>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <telerik:RadNumericTextBox Width="60px" ID="txtProviderCharge" runat="server" MinValue="1" onkeyup="addUpdateCptInformation(event)"
                                                                        MaxValue="100000" DbValue='<%# Bind("ProviderCharge")%>' Type="Currency">
                                                                        <NumberFormat DecimalDigits="2" />
                                                                    </telerik:RadNumericTextBox>
                                                                </EditItemTemplate>
                                                            </telerik:GridTemplateColumn>

                                                            <telerik:GridTemplateColumn HeaderText="Allowable" DataField="Allowable" SortExpression="Allowable">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "Allowable$") %>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <telerik:RadNumericTextBox Width="60px" ID="txtAllowable" runat="server" MinValue="1" onkeyup="addUpdateCptInformation(event)"
                                                                        MaxValue="100000" DbValue='<%# Bind("Allowable")%>' Type="Currency">
                                                                        <NumberFormat DecimalDigits="2" />
                                                                    </telerik:RadNumericTextBox>
                                                                </EditItemTemplate>
                                                            </telerik:GridTemplateColumn>
                                                            <telerik:GridEditCommandColumn UniqueName="EditCptCode" ButtonType="ImageButton" UpdateText="Update" CancelText="Cancel"
                                                                EditText="Edit">
                                                            </telerik:GridEditCommandColumn>
                                                            <telerik:GridButtonColumn Text="Delete" UniqueName="DeleteCptCode" CommandName="Delete" ButtonType="ImageButton" />
                                                            <telerik:GridBoundColumn  Display="false" HeaderText="Invoice Name" UniqueName="CPTAbbr" DataField="CPTAbbr">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn  Display="false" HeaderText="Service Type" UniqueName="ServiceTypeAbbr" DataField="ServiceTypeAbbr">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn  Display="false" HeaderText="CPT Type" UniqueName="CPTType" DataField="CPTType">
                                                            </telerik:GridBoundColumn>
                                                            <telerik:GridBoundColumn  Display="false" HeaderText="Description" UniqueName="CPTDesc" DataField="CPTDesc">
                                                            </telerik:GridBoundColumn>
                                                        </Columns>
                                                        <NestedViewSettings>
                                                            <ParentTableRelation>
                                                                <telerik:GridRelationFields DetailKeyField="CPTCode" MasterKeyField="CPTCode" />
                                                            </ParentTableRelation>
                                                        </NestedViewSettings>
                                                        <NestedViewTemplate>
                                                            <asp:Panel ID="NestedViewPanel" runat="server">
                                                                <div>
                                                                    <table class="align-popup-fields">
                                                                        <tr>
                                                                            <td width="50%">
                                                                                <div class="form-row">
                                                                                    <div class="editor-label">
                                                                                        <asp:Label ID="lbl12" runat="server">Invoice Name:</asp:Label>
                                                                                    </div>
                                                                                    <div class="editor-field">
                                                                                        <asp:TextBox ID="txtInvoiceName" Text='<%#Bind("CPTAbbr") %>' runat="server"></asp:TextBox>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="form-row">
                                                                                    <div class="editor-label">
                                                                                        <asp:Label ID="Label16" runat="server">Service Type:</asp:Label>
                                                                                    </div>
                                                                                    <div class="editor-field">
                                                                                        <telerik:RadComboBox ID="cmbServiceTypes" runat="server" Width="200px" EmptyMessage="Choose Service Type..."
                                                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="ServiceAbbr" DataValueField="ServiceTypeID"
                                                                                            MaxHeight="200">
                                                                                        </telerik:RadComboBox>
                                                                                    </div>
                                                                                </div>
                                                                                 <div class="form-row">
                                                                                    <div class="editor-label">
                                                                                        <asp:Label ID="Label12" runat="server">CPT Type:</asp:Label>
                                                                                    </div>
                                                                                    <div class="editor-field">
                                                                                        <asp:TextBox ID="txtCPTType" Text='<%#Bind("CPTType") %>' runat="server"></asp:TextBox>
                                                                                    </div>
                                                                                </div>
                                                                            </td>
                                                                            <td width="50%">
                                                                               <div class="form-row">
                                                                                    <div class="editor-label">
                                                                                        <asp:Label ID="Label18" runat="server">Description:</asp:Label>
                                                                                    </div>
                                                                                    <div class="editor-field">
                                                                                        <asp:TextBox ID="txtDescription" TextMode="MultiLine" Text='<%#Bind("CPTDesc") %>' Width="242px" Height="75px" CssClass="textarea"
                                                                                            runat="server"></asp:TextBox>
                                                                                    </div>
                                                                                </div>

                                                                            </td>

                                                                        </tr>
                                                                        <tr>
                                                                            <td colspan="2">
                                                                                <div align="right">
                                                                                <asp:ImageButton ToolTip="Save" OnClick="btnUpdateOptionalFields_OnClick" ImageUrl="../Content/Images/icon_save.png" runat="server"></asp:ImageButton> &nbsp;
                                                                                        <asp:Literal ID="litCollapseButton" runat="server"></asp:Literal>  
                                                                                </div>
                                                                                </td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                            </asp:Panel>
                                                        </NestedViewTemplate>
                                                    </MasterTableView>
                                                    <ExportSettings>
                                                        <Excel Format="Biff"></Excel>
                                                    </ExportSettings>
                                                </telerik:radgrid>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                        </td>
                        </tr>
                    </table>

                    <telerik:radwindowmanager id="radWindow" showcontentduringload="True" visiblestatusbar="False"
                        visibletitlebar="True" reloadonshow="True" runat="Server" width="1100px" height="850px"
                        modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                        skin="CareBlueInf">
                        <ConfirmTemplate>
                            <div class="rwDialogPopup radconfirm">
                                <h5>
                                    <div class="rwDialogText">
                                        {1}
                                    </div>
                                </h5>
                                <div>
                                    <div style="margin-top: 15px; margin-left: 30px;">
                                        <a href="javascript:;" onclick="$find('{0}').close(true);">
                                            <img src="../Content/Images/btn_ok.gif" alt="No" /></a> &nbsp; &nbsp; <a href="Javascript:;" onclick="$find('{0}').close(false);">
                                                <img src="../Content/Images/btn_cancel.gif" alt="Yes" /></a>
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
                                <div style="margin-top: 20px; margin-left: 51px;">
                                    <a href="#" onclick="$find('{0}').close(true);">
                                        <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                                </div>
                            </div>
                        </AlertTemplate>
                    </telerik:radwindowmanager>
                </div>
                <telerik:radbutton id="btnDeleteCPTCode" style="display: none;" onclick="btnDeleteCPTCode_OnDelete" runat="server" />
                <asp:HiddenField ID="hdnIndex" runat="server" />
            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="btnReport" />
            </Triggers>
        </asp:UpdatePanel>
        <script type="text/javascript" language="javascript">

            function printPopup() {
                var location = "<%=Extension.ClientSession.WebPathRootProvider %>" + "report/feeSchedulePrint_popup.aspx";
                window.open(location, "WindowPopup", "width=700px, height=860px, scrollbars=yes");
            }

            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
                else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

                return oWindow;
            }

            function deleteCptCode(isDelete) {
                if (isDelete) {
                    <%= ClientScript.GetPostBackEventReference(btnDeleteCPTCode, string.Empty) %>;
                }
            }

            function closePopup() {
                GetRadWindow().close();
            }

            function redirectEstimatePage() {
                GetRadWindow().BrowserWindow.redirectEstimatePage();
                GetRadWindow().close();
            }



            function addUpdateCptInformation(e) {
                if (e.keyCode == 13) {

                    var masterTable = $find("<%= grdSchedules.ClientID %>").get_masterTableView();
                    var index = getCurrentRowIndex();
                    
                    if (index == "") {
                        masterTable.fireCommand("PerformInsert");
                    } else {
                        masterTable.fireCommand("Update", index);
                    }
                }
            }

            function collapseRow(index) {
                var masterTable = $find("<%= grdSchedules.ClientID %>").get_masterTableView();
                masterTable.fireCommand("ExpandCollapse", index);
            }


            function getCurrentRowIndex() {
                var index = $("#<%=hdnIndex.ClientID%>").val();
                return index;
            }


        </script>
    </form>
</body>
</html>
