<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="search.aspx.cs"
    Inherits="search" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script type="text/javascript" src="../Scripts/radwindowPrintButton.js"></script>
    <script type="text/javascript">
        function printWin(e) {
            var oWnd = $find("<%=popupEstimateView.ClientID%>");
            var content = oWnd.GetContentFrame().contentWindow;
            var printDocument = content.document;
            if (document.all) {
                printDocument.execCommand("Print");
            }
            else {
                content.print();
            }
            //Cancel event!
            if (!e) e = window.event;

            return $telerik.cancelRawEvent(e);
        }
    </script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Transaction Search</h1>
            </div>
            <div class="bodyMain">
                <div style="margin-top: 15px;">
                    <div style="position: absolute; top: 10px; font-weight: 700;">
                        <table>
                            <tr>
                                <td>&nbsp;</td>
                                <td valign="bottom">
                                    <asp:Label ID="lblShowGridState" runat="server"></asp:Label></td>
                                <td>&nbsp;</td>
                                <td>
                                    <asp:ImageButton ID="btnSwitch" Visible="False" Style="margin-top: 5px;" OnClientClick="return  validateGridRows()" OnClick="btnShowHideGrouping_OnClick" runat="server" /></td>
                            </tr>
                        </table>
                    </div>
                    <asp:ImageButton ID="btnReport" ImageUrl="../Content/Images/btn_export_small.gif" CssClass="grd-search-align" OnClick="btnReport_Click" runat="server" />
                    <img src="../Content/Images/btn_print_small.gif" style="cursor: pointer; margin-right: 10px;" alt="Print" onclick="showPrintTransactionPopup()" class="grd-search-align" />
                    <br />
                    <br />
                </div>

                <div>
                    <telerik:radpanelbar runat="server" id="RadPanelBar1" width="1161">
                        <Items>
                            <telerik:RadPanelItem Expanded="False" Text="Filters">
                                <ContentTemplate>
                                    <table class="align-label" style="margin-top: 15px">
                                        <tr>
                                            <td width="30%" valign="top">
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label1" runat="server" Text="Patient:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbPatients" runat="server" Width="200px" EmptyMessage="All Patients" AutoPostBack="True" ItemRequestTimeout="500"
                                                            AllowCustomText="True" EnableLoadOnDemand="True" OnItemsRequested="cmbPatients_ItemsRequested" MarkFirstMatch="True" DataTextField="ComboBoxAbbr" DataValueField="PatientID"
                                                            MaxHeight="200">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label4" runat="server" Text="Patient Status:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbPublicStatus" runat="server" Width="200px" EmptyMessage="All Statuses"
                                                            AllowCustomText="False" MarkFirstMatch="True" MaxHeight="200">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label2" runat="server" Text="Location:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbLocations" runat="server" Width="200px" EmptyMessage="All Locations"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="LocationID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label3" runat="server" Text="Provider:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbProviders" runat="server" Width="200px" EmptyMessage="All Providers"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="ProviderAbbr" DataValueField="ProviderID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                            </td>
                                            <td width="30%" valign="top">
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label9" runat="server" Text="Category:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbCategoryTypes" runat="server" Width="200px" EmptyMessage="All Categories" AutoPostBack="True" OnSelectedIndexChanged="cmbCategoryTypes_OnClientSelectedIndexChanged"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="TransCategoryTypeID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label15" runat="server" Text="Types:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbTypes" runat="server" Width="200px" EmptyMessage="All Types"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="ServiceAbbr" DataValueField="TransactionTypeID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label6" runat="server" Text="Status:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbStatus" runat="server" Width="200px" EmptyMessage="All Statuses"
                                                            AllowCustomText="False" MarkFirstMatch="True">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label30" runat="server" Text="State:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbStates" runat="server" Width="200px" EmptyMessage="All States"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="StateAbbr" DataValueField="TransactionStateTypeID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                            </td>
                                            <td valign="top">
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label25" runat="server" Text="Statement ID:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadNumericTextBox runat="server" ID="txtStatementID" Type="Number" NumberFormat-DecimalDigits="0"
                                                            Width="100" NumberFormat-GroupSeparator="">
                                                        </telerik:RadNumericTextBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label7" runat="server" Text="Date:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadDatePicker ID="dtDateMin" runat="server" MinDate="1/1/2010" Width="100"
                                                            CssClass="set-telerik-ctrl-width">
                                                        </telerik:RadDatePicker>
                                                        -
                                                        <telerik:RadDatePicker ID="dtDateMax" runat="server" MinDate="1/1/2010" Width="100"
                                                            CssClass="set-telerik-ctrl-width">
                                                        </telerik:RadDatePicker>
                                                        <asp:CompareValidator ID="CompareValidator2" ControlToValidate="dtDateMax" ControlToCompare="dtDateMin"
                                                            Operator="GreaterThanEqual" Display="dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                            ErrorMessage="End date must be greater than start." ToolTip="End date must be greater than start." runat="server"
                                                            ValidationGroup="Transaction" Text="*" />
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label-tight">
                                                        <asp:Label ID="Label8" runat="server" Text="Amount:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadNumericTextBox runat="server" ID="txtAmountMin" Type="Number" NumberFormat-DecimalDigits="2"
                                                            Width="100" NumberFormat-GroupSeparator=",">
                                                        </telerik:RadNumericTextBox>
                                                        -
                                                        <telerik:RadNumericTextBox runat="server" ID="txtAmountMax" Type="Number" NumberFormat-DecimalDigits="2"
                                                            Width="100" NumberFormat-GroupSeparator=",">
                                                        </telerik:RadNumericTextBox>
                                                        <asp:CompareValidator ID="CompareValidator1" ControlToValidate="txtAmountMax" ControlToCompare="txtAmountMin"
                                                            Operator="GreaterThan" Display="dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                            ErrorMessage="Amount must be greater." ToolTip="Amount must be greater." runat="server"
                                                            ValidationGroup="Transaction" Text="*" />
                                                    </div>
                                                </div>
                                                <div class="margin-left-search-buttons-tight">
                                                    <asp:ImageButton ID="btnClear" ImageUrl="../Content/Images/btn_clear.gif" CssClass="btn-clear"
                                                        OnClick="btnClear_OnClick" runat="server" />
                                                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
                                                <asp:ImageButton ID="btnSearch" CssClass="btn-search" ImageUrl="../Content/Images/btn_search.gif" OnClientClick="return  showProgressPopup();"
                                                    OnClick="btnSearch_Click" runat="server" ValidationGroup="Transaction" />
                                                </div>
                                                <div>
                                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="Transaction"
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

                <table width="100%" border="0">
                    <tr>
                        <td colspan="3">
                            <asp:HiddenField ID="hdnNotes" runat="server" />
                            <asp:HiddenField ID="hdnTransactionID" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <telerik:radgrid id="grdTransactions" runat="server" allowsorting="True" allowpaging="True"
                                pagesize="20" onneeddatasource="grdTransactions_NeedDataSource"
                                onprerender="grdTransactions_OnPreRender" onitemcommand="grdTransactions_OnItemCommand"
                                onitemdatabound="grdTransactions_ItemDataBound">
                                <MasterTableView AutoGenerateColumns="False" DataKeyNames="TransactionID, StatementID, PatientID, AccountID, FlagLocked, GroupID, FlagPending, FlagVeryOld, FlagModify, PendingTypeAbbr" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No results match your search. If filters are in use, clear the values and try again.<br>&nbsp;">
                                    <PagerStyle Mode="NextPrevAndNumeric" />
                                    <Columns>
                                        <telerik:GridTemplateColumn UniqueName="Transaction" HeaderText="Transaction" AllowFiltering="False">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkLoadPatientIntoSession" Style="color:black" OnClick="lnkLoadPatientIntoSession_OnClick" Text='<%#Bind("TransactionRef")%>' runat="server"></asp:LinkButton>
                                        </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                       <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID" Display="False">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Date" UniqueName="TransactionDateTime"  DataField="TransactionDateTime"  DataType="System.DateTime" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                       <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="User" DataField="UserName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Method" DataField="MethodTypeAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Type" DataField="StatusTypeAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Amount" DataField="Amount$" SortExpression="Amount">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Result" DataField="ResultTypeAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="State" DataField="TransStateTypeAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Description" DataField="FSPMessage">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridButtonColumn CommandName="Modify" HeaderText="Edit" ButtonType="ImageButton"
                                            UniqueName="Modify" ImageUrl="~/Content/Images/edit.png">
                                        </telerik:GridButtonColumn>
                                        <telerik:GridButtonColumn CommandName="ViewTransaction" HeaderText="View" ButtonType="ImageButton"
                                            UniqueName="View" ImageUrl="~/Content/Images/view.png">
                                        </telerik:GridButtonColumn>
                                        <telerik:GridButtonColumn CommandName="ViewReceipt" HeaderText="Receipt" ButtonType="ImageButton"
                                            UniqueName="Receipt" ImageUrl="~/Content/Images/icon_receipt.png">
                                        </telerik:GridButtonColumn>
                                    </Columns>
                                    <NestedViewSettings>
                                        <ParentTableRelation>
                                            <telerik:GridRelationFields DetailKeyField="GroupID" MasterKeyField="GroupID" />
                                        </ParentTableRelation>
                                    </NestedViewSettings>
                                    <NestedViewTemplate>
                                        <asp:Panel ID="NestedViewPanel" runat="server" CssClass="viewWrap">
                                            <div class="contactWrap">
                                                <fieldset style="margin: 0px 10px 10px 10px; padding: 10px;">
                                                    <legend style="padding: 5px;"><b>Record Details</b></legend>
                                                    <div style="margin: -15px 0px -10px 0px;">
                                                        <table width="100%">
                                                            <tr valign="top">
                                                                <td width="260">
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td>
                                                                                <fieldset style="margin: 0px 10px 10px 10px; padding: 5px 0px 10px 15px;">
                                                                                    <legend style="padding: 5px;">Patient
                                                                                        <asp:Label ID="Label9" Text='<%#Bind("PatientID")%>' runat="server"></asp:Label></legend>
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td width="60">
                                                                                                <div class="lblInputR">
                                                                                                    <asp:Label ID="Label37" runat="server">Patient:</asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="boxInputL">
                                                                                                    <asp:Label ID="Label2" Text='<%#Bind("PatientName")%>' runat="server"></asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <div class="lblInputR">
                                                                                                    <asp:Label ID="Label38" runat="server">DOB:</asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="boxInputL">
                                                                                                    <asp:Label ID="Label3" Text='<%#Bind("DateofBirth") %>' runat="server"></asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <div class="lblInputR">
                                                                                                    <asp:Label ID="Label40" runat="server">Provider:</asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="boxInputL">
                                                                                                    <asp:Label ID="Label4" Text='<%#Bind("ProviderName")%>' runat="server"></asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <div class="lblInputR">
                                                                                                    <asp:Label ID="lblLastName" runat="server">Account:</asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="boxInputL">
                                                                                                    <asp:Label ID="Label5" Text='<%#Bind("AccountID") %>' runat="server"></asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </fieldset>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td width="260">
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td>
                                                                                <fieldset style="margin: 0px 10px 10px 10px; padding: 5px 0px 10px 15px;">
                                                                                    <legend style="padding: 5px;">Statement
                                                                                        <asp:Label ID="Label36" Text='<%#Bind("StatementID")%>' runat="server"></asp:Label></legend>
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td width="60">
                                                                                                <div class="lblInputR">
                                                                                                    <asp:Label ID="Label35" runat="server">Status:</asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="boxInputL">
                                                                                                    <asp:Label ID="Label10" Text='<%#Bind("CreditStatusTypeAbbr") %>' runat="server"></asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <div class="lblInputR">
                                                                                                    <asp:Label ID="Label41" runat="server">Balance:</asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="boxInputL">
                                                                                                    <asp:Label ID="Label19" Text='<%#Bind("BalanceAbbr")%>' runat="server"></asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <div class="lblInputR">
                                                                                                    <asp:Label ID="Label20" runat="server">PayPlan:</asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="boxInputL">
                                                                                                    <asp:Label ID="Label21" Text='<%#Bind("PaymentPlanAbbr")%>' runat="server"></asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <div class="lblInputR">
                                                                                                    <asp:Label ID="Label22" runat="server">BlueCredit:</asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="boxInputL">
                                                                                                    <asp:Label ID="Label23" Text='<%#Bind("BlueCreditAbbr")%>' runat="server"></asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </fieldset>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td width="260">
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td>
                                                                                <fieldset style="margin: 0px 10px 10px 10px; padding: 5px 0px 10px 15px;">
                                                                                    <legend style="padding: 5px;">Transaction
                                                                                        <asp:Label ID="cityLabel" Text='<%#Bind("TransactionID") %>' runat="server"></asp:Label></legend>
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td width="60">
                                                                                                <div class="lblInputR">
                                                                                                    <asp:Label ID="Label11" runat="server">Amount:</asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="boxInputL">
                                                                                                    <asp:Label ID="Label12" Text='<%#Bind("AmountAbbr") %>' runat="server"></asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <div class="lblInputR">
                                                                                                    <asp:Label ID="Label13" runat="server">Date:</asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="boxInputL">
                                                                                                    <asp:Label ID="Label43" Text='<%#Bind("TransactionDate") %>' runat="server"></asp:Label>
                                                                                                    ,
                                                                                                    <asp:Label ID="Label14" Text='<%#Bind("TransactionTime") %>' runat="server"></asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr  <%# Eval("TransCategoryTypeID").ParseBool() ? "" : "style='display: none;'" %>>
                                                                                            <td>
                                                                                                <div class="lblInputR">
                                                                                                    <asp:Label ID="Label39" runat="server">Card:</asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="boxInputL">
                                                                                                    <asp:Label ID="Label16" Text='<%#Bind("PaymentCardDesc") %>' runat="server"></asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td valign="top">
                                                                                                <div class="lblInputR">
                                                                                                    <asp:Label ID="Label18" runat="server">Message:</asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td>
                                                                                                <div class="boxInputL">
                                                                                                    <asp:Label ID="Label27" Text='<%#Bind("StatementMsg") %>' runat="server"></asp:Label>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </fieldset>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td width="10">&nbsp;
                                                                </td>
                                                                <td>
                                                                    <div class="lblInputL">
                                                                        <asp:Label ID="Label6" runat="server" Text="Notes:"></asp:Label>
                                                                        <a href="javascript:;" onclick="showMessagePopup(<%#Eval("TransactionID")%>, '<%#Eval("Notes")%>')">
                                                                            <img src="../Content/Images/icon_open.png" alt="Open Notes" style="margin: 0px 0px -2px 8px;" /></a>
                                                                    </div>
                                                                    <div class="boxInputL">
                                                                        <asp:TextBox ID="txtNotes" Text='<%#Bind("Notes") %>' ReadOnly="True" TextMode="MultiLine"
                                                                            Height="86" Width="220" CssClass="textarea" runat="server"></asp:TextBox>
                                                                        <br>
                                                                        <b>System User:</b>
                                                                        <asp:Label ID="Label24" Text='<%#Bind("UserName") %>' runat="server"></asp:Label>
                                                                    </div>
                                                                    <div class="boxInputL" style="margin: 76px 0px 0px 10px;">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </fieldset>
                                            </div>
                                        </asp:Panel>
                                    </NestedViewTemplate>
                                </MasterTableView>
                                <ExportSettings>
                                    <Excel Format="Biff"></Excel>
                                </ExportSettings>
                            </telerik:radgrid>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:HiddenField ID="hdnRedirectToTransactions" runat="server" />
            <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                behaviors="Pin,Reload,Close,Move,Resize" visibletitlebar="True" reloadonshow="True"
                runat="Server" width="1100px" height="850px" modal="True" enableshadow="False"
                enableembeddedbasestylesheet="False" enableembeddedskins="False" skin="CareBlue">
                <Windows>
                   <telerik:RadWindow runat="server" ID="popupModifyTransaction" Width="800px" Height="470px" NavigateUrl="~/report/modifyTransaction_popup.aspx"
                        DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupPaymentReceipt" NavigateUrl="~/report/paymentReceipt_popup.aspx"
                        Width="450" Height="670" CssClass="customprintbutton" DestroyOnClose="True">
                    </telerik:RadWindow>
                </Windows>
            </telerik:radwindowmanager>
            <telerik:radwindow runat="server" id="popupEstimateView" cssclass="customprintbutton"
                onclientshow="OnClientShow" navigateurl="~/report/estimateview_popup.aspx" destroyonclose="True"
                showcontentduringload="True" visiblestatusbar="False" visibletitlebar="True"
                reloadonshow="True" width="860px" height="850px" modal="True" enableshadow="False"
                enableembeddedbasestylesheet="False" enableembeddedskins="False" behaviors="Pin,Reload,Close,Move,Resize"
                skin="CareBlueInv">
            </telerik:radwindow>
            <telerik:radwindowmanager id="RadWindowManager1" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="1100px" height="850px"
                modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                skin="CareBlueInf">
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
            <telerik:radwindow runat="server" id="popupMessage" behaviors="Move" style="z-index: 200001"
                width="500px" height="160px" showcontentduringload="False" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" modal="True" enableembeddedbasestylesheet="True"
                enableembeddedskins="False" skin="CareBlueInf">
                <ContentTemplate>
                    <div id="divMessage" align="center">
                        <br />
                        <h5>A positive adjustment will increase the overall charge of the CPT. If a reduction
                            in base charge was intended, please make this adjustment negative.
                            <br />
                            <br />
                            <a href="javascript:;" onclick="resetAdjustment(false)">
                                <img src="../Content/Images/btn_ignore.gif" class="btn-ignore" alt="Ignore" /></a>
                            &nbsp; &nbsp; <a href="#" onclick="resetAdjustment(true)">
                                <img src="../Content/Images/btn_reset.gif" class="btn-reset" alt="Reset" /></a>
                        </h5>
                    </div>
                </ContentTemplate>
            </telerik:radwindow>
            <telerik:radwindow id="popupNotes" showcontentduringload="True" visiblestatusbar="False"
                title="" behaviors="Pin,Reload,Close,Move,Resize" visibletitlebar="True"
                reloadonshow="True" runat="Server" width="455px" height="290px" modal="True"
                enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                skin="CareBlue">
                <ContentTemplate>
                    <div id="div1" align="center">
                    <table class="CareBluePopup">
                        <tr>
                            <td>
                                <h2p>Update Transaction Notes</h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>Notes explain fee modifications and are only visible to the practice.</h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad">

                                    <table class="align-fields" width="100%" style="margin: 15px 0 0 15px;">
                                        <tr>
                                            <td valign="top">
                                                <div>
                                                    <asp:Label ID="Label31" runat="server" Text="Notes:"></asp:Label>&nbsp; &nbsp; 
                                                </div>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtNotes" TextMode="MultiLine" Width="300" Height="81" onchange="saveNotes()"
                                                    Style="resize: none;" runat="server"></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="image" src="../Content/Images/btn_cancel.gif" alt="Cancel" class="btn-pop-cancel"
                                        onclick="closePopup();" />
                                    <asp:ImageButton ID="btnUpdate" src="../Content/Images/btn_update.gif" alt="Update"
                                        class="btn-pop-submit" runat="server" OnClick="btnUpdate_OnClick" />
                                </td>
                            </tr>
                        </table>
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
        prm.add_endRequest(function () {

            var isRedirectToStatement = $("#<%=hdnRedirectToTransactions.ClientID%>").val();
           if (isRedirectToStatement == "1") {
               var location = '<%=ClientSession.WebPathRootProvider %>' + "patient/transactions.aspx";
               window.location.href = location;
           }
            
            unBlockUI();
       });


       function closePaymentReceiptWindow() {
           $find("<%=popupPaymentReceipt.ClientID%>").close();
        }

        var transactionID = 0;
        function showMessagePopup(transactionId, notes) {
            transactionID = transactionId;
            $("#<%=txtNotes.ClientID %>").val(notes);
            $find("<%=popupNotes.ClientID%>").show();
            return false;
        }

        function saveNotes() {
            var notes = $("#<%=txtNotes.ClientID %>").val();
            $("#<%=hdnNotes.ClientID %>").val(notes);
            $("#<%=hdnTransactionID.ClientID %>").val(transactionID);
        }


        function validateGridRows() {
            var rows = $find("<%= grdTransactions.ClientID %>").get_masterTableView().get_dataItems().length;
            if (rows == 0)
                alert("Please complete a transaction search before attempting to group records.");

            if (rows > 0) {
                blockUI();
            }

            return rows > 0;
        }


        function showProgressPopup() {

            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('Transaction');
            }

            if (isPageValid) {
                blockUI();
            }

            return isPageValid;
        }
        

        function closePopup() {
            GetRadWindow().close();
        }

        function refreshGrid() {
            refreshPage();
        }

        function showPrintTransactionPopup() {
            var location = "<%=ClientSession.WebPathRootProvider %>" + "report/printTransactions_popup.aspx";
            window.open(location, "Print Transactions", "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");
        }

    </script>
</asp:Content>
