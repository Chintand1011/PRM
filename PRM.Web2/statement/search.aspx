<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="search.aspx.cs"
    Inherits="search" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Statement Search</h1>
            </div>
            <div class="bodyMain">
                <h2>Use any combination of filters to search for patient statements. Results can be exported to Excel using the link to the right.
                </h2>

                <div style="margin:-30px 5px 0px 0px;">
                        <asp:ImageButton ID="btnReport" ImageUrl="../Content/Images/btn_export_small.gif" CssClass="grd-search-align" OnClick="btnReport_Click" runat="server" ToolTip="Export search results to Excel file." />
                        <img src="../Content/Images/btn_print_small.gif" style="cursor: pointer; margin-right:10px;" alt="Print results." onclick="showPrintStatementPopup()" class="grd-search-align" />
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
                                                        <telerik:RadComboBox ID="cmbPatientStatus" runat="server" Width="200px" EmptyMessage="All Statuses"
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
                                                        <asp:Label ID="Label25" runat="server" Text="Statement ID:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadNumericTextBox runat="server" ID="txtStatementID" Type="Number" NumberFormat-DecimalDigits="0"
                                                            Width="100" NumberFormat-GroupSeparator="">
                                                        </telerik:RadNumericTextBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label6" runat="server" Text="Status:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbStatus" runat="server" Width="200px" EmptyMessage="All Statuses"
                                                            AllowCustomText="False" DataTextField="Abbr" DataValueField="CreditStatusTypeID"
                                                            MarkFirstMatch="True">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label7" runat="server" Text="Invoice Date:"></asp:Label>
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
                                                            ValidationGroup="Statement" Text="*" />
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label8" runat="server" Text="Outstanding Balance:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadNumericTextBox runat="server" ID="txtAmountMin" Type="Number" NumberFormat-DecimalDigits="2"
                                                            NumberFormat-GroupSeparator="," Width="120">
                                                        </telerik:RadNumericTextBox>
                                                        -
                                                        <telerik:RadNumericTextBox runat="server" ID="txtAmountMax" Type="Number" NumberFormat-DecimalDigits="2"
                                                            NumberFormat-GroupSeparator="," Width="120">
                                                        </telerik:RadNumericTextBox>
                                                        <asp:CompareValidator ID="CompareValidator1" ControlToValidate="txtAmountMax" ControlToCompare="txtAmountMin"
                                                            Operator="GreaterThan" Display="dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                            ErrorMessage="Amount must be greater." ToolTip="Amount must be greater." runat="server"
                                                            ValidationGroup="Statement" Text="*" />
                                                    </div>
                                                </div>
                                                <div class="margin-left-search-buttons">
                                                    <asp:ImageButton ID="btnClear" ImageUrl="../Content/Images/btn_clear.gif" CssClass="btn-clear"
                                                        OnClick="btnClear_Click" runat="server" />
                                                    &nbsp;
                                <asp:ImageButton ID="btnSearch" CssClass="btn-search" ImageUrl="../Content/Images/btn_search.gif"
                                    OnClick="btnSearch_Click" OnClientClick="return  showProgressPopup();" runat="server" ValidationGroup="Statement" />
                                                </div>
                                                <div>
                                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="Statement"
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
                            <telerik:radgrid id="grdStatements" runat="server" allowsorting="True" allowpaging="True" EnableLinqExpressions="False"
                                allowfilteringbycolumn="false" pagesize="20" onneeddatasource="grdStatements_NeedDataSource" onitemcommand="grdStatements_OnItemCommand"
                                onitemdatabound="grdStatements_OnItemDataBound">
                                <MasterTableView ShowFooter="True" AutoGenerateColumns="False" DataKeyNames="StatementID,FlagAutoPay,FilePathStatements,FileName, PatientID, AccountID" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No results match your search. If filters are in use, clear the values and try again.<br>&nbsp;">
                                    <Columns>
                                        <telerik:GridTemplateColumn UniqueName="PatientID" HeaderText="PatientID" AllowFiltering="False">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkLoadPatientIntoSession" Style="color:black" OnClick="lnkLoadPatientIntoSession_OnClick" Text='<%#Bind("PatientID")%>' runat="server"></asp:LinkButton>
                                        </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                        </telerik:GridBoundColumn>                                      
                                        <telerik:GridBoundColumn HeaderText="Invoice Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderName">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Charges" Aggregate="Sum" DataField="Charges" DataFormatString="{0:c}" SortExpression="Charges">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Insurance" Aggregate="Sum" DataField="Insurance" DataFormatString="{0:c}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Payments" Aggregate="Sum" DataField="Payments" DataFormatString="{0:c}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Balance" Aggregate="Sum" DataField="Balance" DataFormatString="{0:c}">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridTemplateColumn HeaderText="Auto Pay" AllowFiltering="False">
                                            <ItemTemplate>
                                                <asp:Image ID="imgAutoPay" runat="server" />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        <telerik:GridBoundColumn HeaderText="Due Date" DataField="DueDate">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridButtonColumn CommandName="View" UniqueName="View" HeaderText="View" ButtonType="ImageButton"
                                            ImageUrl="~/Content/Images/view.png">
                                        </telerik:GridButtonColumn>
                                        <telerik:GridButtonColumn CommandName="Download" HeaderText="Download" ButtonType="ImageButton"
                                            UniqueName="DownloadPdf" ImageUrl="~/Content/Images/icon_pdfblue.gif">
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
                <asp:Button ID="btnDownload" runat="server" OnClick="btnDownload_Click" Style="display: none" />
                <asp:HiddenField ID="hdnDownload" runat="server" />
                <asp:HiddenField ID="hdnRedirectToStatement" runat="server" />
                <telerik:radwindow runat="server" id="popupEstimateView" cssclass="customprintbutton"
                    navigateurl="~/report/estimateview_popup.aspx" destroyonclose="True"
                    showcontentduringload="True" visiblestatusbar="False" visibletitlebar="True"
                    reloadonshow="True" width="860px" height="850px" modal="True" enableshadow="False"
                    enableembeddedbasestylesheet="False" enableembeddedskins="False" behaviors="Pin,Reload,Close,Move,Resize"
                    skin="CareBlueInv">
                </telerik:radwindow>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnReport" />
            <asp:PostBackTrigger ControlID="btnDownload" />
        </Triggers>
    </asp:UpdatePanel>
    <script type="text/javascript">

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            
            var hdnDownload = $("#<%=hdnDownload.ClientID %>");

            if (hdnDownload.val() == "1") {
                hdnDownload.val("0");
                $("#<%=btnDownload.ClientID %>").click();
                }

            var isRedirectToStatement = $("#<%=hdnRedirectToStatement.ClientID%>").val();
            if (isRedirectToStatement == "1") {
                redirectToStatemet();
            }

            unBlockUI();

        });

        function redirectToStatemet() {
            var location = '<%=ClientSession.WebPathRootProvider %>' + "patient/statements.aspx";
            window.location.href = location;
        }

        function showProgressPopup() {
            
            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('Statement');
            }
            
            if (isPageValid) {
                blockUI();
            }

            return isPageValid;
        }
        

        function showPrintStatementPopup() {
            var location = "<%=ClientSession.WebPathRootProvider %>" + "report/printStatements_popup.aspx";
             window.open(location, "Print Statements", "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");
         }
        
    </script>
</asp:Content>
