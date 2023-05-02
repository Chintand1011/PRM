<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="estimates.aspx.cs"
    Inherits="estimates" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script type="text/javascript" src="../Scripts/radwindowPrintButton.js"></script>
    <script type="text/javascript">
        function printWin(e) {
            var oWnd = $find("<%=popupEstimateView.ClientID%>");
            oWnd.close();
            createPDF();
        }

        function createPDF() {
            blockUI();
            $("#<%=btnCreatePDF.ClientID %>").click();
        }
    </script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Patient Estimates</h1>
            </div>
            <div class="bodyMain">
                <h2>Create and review estimates associated with the patient account. After an estimate
                    has been created, it can be made into an active statement. If any transactions occur
                    on the statement, that statement is locked and can not be deleted unless any existing
                    balances are paid.</h2>
                <div>
                    <h3>Current Estimates</h3>
                    <telerik:radgrid id="grdCurrentEstimates" runat="server" allowsorting="True" allowpaging="True"
                        pagesize="10" onneeddatasource="grdCurrentEstimates_NeedDataSource" onitemcommand="grdCurrentEstimates_OnItemCommand" onitemdatabound="grdCurrentEstimates_ItemDataBound" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No estimates have been created.<br>&nbsp;">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="EstimateID, FlagFeeScheduleActive">
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Estimate" DataField="EstimateID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Date" DataField="EstimateDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Carrier" DataField="CarrierAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Fee Schedule" DataField="FeeScheduleAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Charges" DataField="Charges$" SortExpression="Charges">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn CommandName="EditEstimate" HeaderText="Edit" UniqueName="Edit" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/edit.png">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="DeleteEstimate" HeaderText="Delete" UniqueName="Delete" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/close.ico">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="ConvertEstimate" HeaderText="Convert" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/icon_add.png">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="ViewEstimates" HeaderText="View" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/view.png">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>
                </div>
                <div>
                    <asp:ImageButton ID="btnCreateNew" ImageUrl="../Content/Images/btn_createnew.gif"
                        CssClass="btn-create-new" OnClick="btnCreateNew_Click" Style="margin: 10px 10px 10px 0px; float: right;"
                        runat="server" />
                </div>
                <br />
                <br />
                <br />
                <h3>Recent Conversions to Statements</h3>
                <div>
                    <telerik:radgrid id="gridEstimatesConvertedStatements" runat="server" allowsorting="True"
                        allowpaging="True" pagesize="10" onneeddatasource="gridEstimatesConvertedStatements_NeedDataSource"
                        onitemcommand="gridEstimatesConvertedStatements_OnItemCommand" onitemdatabound="gridEstimatesConvertedStatements_OnItemDataBound" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No recent estimates have been converted to statements.<br>&nbsp;">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID,FlagLocked,EstimateID">
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Carrier" DataField="CarrierAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Fee Schedule" DataField="FeeScheduleAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Charges" DataField="Charges$" SortExpression="Charges">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn UniqueName="Cancel" CommandName="Cancel" HeaderText="Cancel"
                                    ButtonType="ImageButton" ImageUrl="~/Content/Images/icon_cancelx.gif">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="ViewEstimates" HeaderText="View" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/view.png">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>
                </div>
            </div>
            <asp:HiddenField ID="hdnEstimateID" runat="server" />
            <asp:HiddenField ID="hdnIsShowPDFViewer" runat="server" />
            <asp:Button ID="btnConvert" OnClick="btnConvert_OnClick" runat="server" Style="display: none" />
            <asp:Button ID="btnDeleteEstimate" OnClick="btnDeleteEstimate_OnClick" runat="server" Style="display: none" />
            <asp:Button ID="btnDeleteStatement" OnClick="btnDeleteStatement_OnClick" runat="server"
                Style="display: none" />
            <asp:Button ID="btnCreatePDF" OnClick="btnCreatePDF_OnClick" runat="server" Style="display: none" />
            <div>
                <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                    enableembeddedscripts="True" visibletitlebar="True" reloadonshow="True" runat="Server"
                    width="1150px" height="880px" modal="True" enableshadow="False" enableembeddedbasestylesheet="False"
                    enableembeddedskins="False" skin="CareBlue2" behaviors="Pin,Reload,Close,Move,Resize"
                    style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupEstimateUtility" NavigateUrl="~/report/estimate_popup.aspx"
                            DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupEstimateView" width="860px" height="850px" CssClass="customprintbutton"
                            OnClientShow="OnClientShow" NavigateUrl="~/report/estimateview_popup.aspx" DestroyOnClose="True"
                            Skin="CareBlueInv">
                        </telerik:RadWindow>
                    </Windows>
                </telerik:radwindowmanager>
            </div>
            <telerik:radwindowmanager id="windowManager" showcontentduringload="True" visiblestatusbar="False"
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
                            <div style="margin-top: 15px; margin-left: 50px;">
                                <a href="#" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_submit.gif" alt="Submit" /></a>  &nbsp; &nbsp;
                                <a href="#" onclick="$find('{0}').close(false);">
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
                        <div style="margin-top: 20px; margin-left: 51px;">
                            <a href="#" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:radwindowmanager>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    
     <script type="text/javascript">

         var prm = Sys.WebForms.PageRequestManager.getInstance();
         prm.add_endRequest(function () {

             if ($("#<%=hdnIsShowPDFViewer.ClientID %>").val() == "1") {
                viewPdfViewer();
                $("#<%=hdnIsShowPDFViewer.ClientID %>").val("");
             }

             unBlockUI();

         });

        function closeEstimateViewPopup() {
            $find("<%=popupEstimateView.ClientID%>").close();
        }


        function reloadPage(arg) {
            var url = location.href.replace("#", "");
            location.href = url;
        }

        function isConvert(isOk) {
            if (isOk) {
                $("#<%=btnConvert.ClientID%>").click();
            }
        }

        function isDelete(isOk) {
            if (isOk) {
                $("#<%=btnDeleteEstimate.ClientID%>").click();
            }
        }

        function removeStatement(isDelete) {
            if (isDelete) {
                $("#<%=btnDeleteStatement.ClientID%>").click();
            }
        }

        function viewPdfViewer() {
            var popupName = "Estimate";
            var location = "<%=ClientSession.WebPathRootProvider %>" + "report/pdfviewer_popup.aspx";
            window.open(location, popupName, "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");
        }

    </script>

</asp:Content>
