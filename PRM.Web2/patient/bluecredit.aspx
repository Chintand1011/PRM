<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="bluecredit.aspx.cs"
    Inherits="bluecredit" %>

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
        <Triggers>
            <asp:PostBackTrigger ControlID="btnDownloadPdf" />
        </Triggers>
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>BlueCredit Manager</h1>
            </div>
            <div class="bodyMain">
                <h2>Accounts may only be opened against eligible statements, however any statement with a balance may be assigned to an existing account if there is suffient credit available.</h2>
                <h3>Notes On Patient Credit (<%= FlagGuardianPay ? "Guardian" : "Patient" %>)</h3>
                <table width="100%">
                    <tr>
                        <td>&nbsp;
                        </td>
                        <td width="705">
                            <asp:TextBox TextMode="MultiLine" Width="700px" Height="55px" ID="txtNote" CssClass="textarea"
                                runat="server" ForeColor="black" Font-Size="10pt" Font-Bold="False" BackColor="#FFFFEA" Font-Names="Tahoma; Arial"></asp:TextBox>
                            <br />
                            <div style="float: right; margin: 10px 0px -15px 0;">
                                <asp:ImageButton ID="btnNote" ImageUrl="../Content/Images/btn_update.gif" OnClick="btnSavePatientNote_Click"
                                    CssClass="btn-update" runat="server" />
                            </div>
                        </td>
                        <td align="center" valign="top">
                            <div id="divPatientCreditCheck1" runat="server" visible="False" style="float: none; margin: -30px 0px -25px 0;">
                                <table>
                                    <tr>
                                        <td width="100">
                                            <pfs2>CREDIT SCORE:</pfs2>
                                        </td>
                                        <td>
                                            <pfs5><%=respScoreBCResult%></pfs5>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <pfs2>RISK PROFILE:</pfs2>
                                        </td>
                                        <td>
                                            <pfs6><b><%=RespScoreBCRisk%></b> [<%=RespScoreBCRiskNumber%> RISK]</pfs6>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <pfs2>MAXIMUM:</pfs2>
                                        </td>
                                        <td>
                                            <pfs6><%=BCRecAmountAdj%></pfs6>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <pfs2>ACTUAL ISSUED:</pfs2>
                                        </td>
                                        <td>
                                            <pfs6><%=BCLimitSum%>&nbsp; (<%=BCUsedPercentage%>  Used)</pfs6>
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <pfs2>VIEW FILE:</pfs2>
                                        </td>
                                        <td valign="middle">
                                            <asp:ImageButton ID="btnShowCreditHistory" ImageUrl="../Content/Images/view.png" OnClick="btnShowCreditHistory_Click" Style="margin: 3px 0px -3px 0px;" runat="server" />
                                            <pfs7><%=ServiceDate%> (#<%=PFSID%>)</pfs7>
                                            &nbsp; [
                                            <img alt="Add New" src="../Content/Images/icon_add.png" onclick="redirectToPatientPfsReport();" style="margin: 3px 0px -3px 0px; cursor: pointer;" />
                                            ]
                                        </td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <% if (FlagPFSExpired)
                                               { %>
                                            <img alt="Warning" src="../Content/Images/warning.png" height="20" style="margin-bottom:-5px;"/>&nbsp;
                                            <span style="color:#333333;">Warning: Credit check is more than 30 days old.</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div id="divPatientCreditCheck2" runat="server" visible="False" style="float: none; margin: 0px 0px 0px 0;">
                                <h5 style="margin: 5px 0 0px 0; font-weight: 600; color: darkred; float: none;">This patient does not yet have a valid credit report.
                                    <br />
                                    <img src="../Content/Images/btn_runnew.gif" alt="Run New" onclick="redirectToPatientPfsReport();" style="cursor: pointer; margin-top: 10px;" />
                                </h5>
                            </div>
                        </td>
                        <td>&nbsp;
                        </td>
                    </tr>
                </table>
                <br />
                <h3>BlueCredit Accounts&nbsp; &nbsp; 
                    <% if (ClientSession.FlagBCModify && ClientSession.FlagBlueCredit)
                       { %>
                    <img src="../Content/Images/btn_gobluecredit.gif" alt="Add Bluecredit" onclick="$find('<%=popupBCLoan.ClientID%>').show();" style="cursor: pointer; margin-top: 5px; margin-bottom: -2px;" />
                    <% } %>
                </h3>
                <div style="overflow-x: auto">
                    <telerik:radgrid id="grdCreditAccounts" runat="server" allowsorting="True" allowpaging="True"
                        onneeddatasource="grdCreditAccounts_NeedDataSource" pagesize="10" onitemcommand="grdCreditAccounts_ItemCommand" onitemdatabound="grdCreditAccounts_ItemDataBound">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="BlueCreditID, TUResultTypeID, TUPFSID, FlagActive" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; This patient has no active or completed loan accounts.<br>&nbsp;">
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Loan ID" DataField="BlueCreditID">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Open Date" DataField="OpenDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Plan" DataField="PlanName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Status" DataField="CreditStatusTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Type" DataField="PlanType">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Max Term" DataField="TermMaxAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Next Payment" DataField="NextPayAmountAbbr" SortExpression="NextPayAmount">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Pay Date" DataField="NextPayDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Email" DataField="FlagEmailBillsAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn CommandName="ViewTransactionHistory" HeaderText="History"
                                    ButtonType="ImageButton" ImageUrl="~/Content/Images/view.png">
                                </telerik:GridButtonColumn>
                                <telerik:GridButtonColumn CommandName="EditCreditAccountHistory" HeaderText="Edit" UniqueName="EditCreditAccountHistory"
                                    ButtonType="ImageButton" ImageUrl="~/Content/Images/edit.png">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>
                    <!--
                                <telerik:GridBoundColumn HeaderText="Responsible Party" DataField="AccountHolder">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Class" DataField="PFSClass">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="PFS" DataField="PFSScore">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Grade" DataField="PFSGrade">
                                </telerik:GridBoundColumn>
-->
                </div>
                <br />
                <br />
                <h3>Active Statements &nbsp; &nbsp;<asp:ImageButton ID="btnAddStatement" OnClick="btnAddStatement_OnClick" ImageUrl="../Content/Images/btn_addstatement.gif" Style="margin-bottom: -2px;" runat="server"  Visible="False" />
                </h3>
                <h5 id="addStatementMessage" runat="server" visible="False" style="margin: -10px 0 10px 0; font-weight: 600; color: darkred;">No statements exist. Use the "Add BlueCredit" button above or create a statement before assigning new BlueCredit.</h5>
                <div style="overflow-x: auto">
                    <telerik:radgrid id="grdActiveStatements" runat="server" allowsorting="True" allowpaging="True"
                        onneeddatasource="grdActiveStatements_NeedDataSource" pagesize="10" onitemcommand="grdActiveStatements_ItemCommand"
                        onitemdatabound="grdActiveStatements_ItemDataBound">
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="StatementID, Balance,FlagCreditPlan,FlagCreditEligible,CreditPayAbbr,CreditPlanAbbr,CreditEligibleAbbr"  NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No active statements exist on this account.<br>&nbsp;">
                            <Columns>
                                <telerik:GridTemplateColumn UniqueName="TemplateColumn" HeaderText="Select" AllowFiltering="False">
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkSelect" OnCheckedChanged="chk_OnChanged" AutoPostBack="True"
                                            runat="server"></asp:CheckBox>
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridBoundColumn HeaderText="Statement" DataField="StatementID" ShowSortIcon="False"  >
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Date" DataField="InvoiceDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Provider" DataField="ProviderName">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Balance" DataField="Balance$" SortExpression="Balance">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Last Payment" DataField="LastPayment$" SortExpression="LastPayment">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Pay Date" DataField="LastPaymentDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridTemplateColumn HeaderText="PayPlan" AllowFiltering="False">
                                    <ItemTemplate>
                                        <asp:Image ID="imgPayPlan" runat="server" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridTemplateColumn HeaderText="CreditPlan" AllowFiltering="False">
                                    <ItemTemplate>
                                        <asp:Image ID="imgCreditPlan" runat="server" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridTemplateColumn HeaderText="Credit Eligible" AllowFiltering="False">
                                    <ItemTemplate>
                                        <asp:Image ID="imgCreditEligible" runat="server" />
                                    </ItemTemplate>
                                </telerik:GridTemplateColumn>
                                <telerik:GridButtonColumn CommandName="ViewActiveStatement" HeaderText="View" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/view.png">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>
                </div>
                <div style="float: right; margin-top: 10px">
                    <asp:ImageButton ID="btnAssign" ImageUrl="../Content/Images/btn_assign_fade.gif"
                        Enabled="False" OnClick="btnAssign_Click" CssClass="btn-assign" runat="server" />
                </div>
                <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="800px" height="850px"
                    behaviors="Pin,Reload,Close,Move,Resize" modal="True" enableshadow="False" enableembeddedbasestylesheet="False"
                    enableembeddedskins="False" skin="CareBlue" style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupActiveStatements" Width="1100px" Height="850px" NavigateUrl="~/report/bluecredit_addcredit_popup.aspx" Behaviors="Reload">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupApplyCredit" Width="1100px" Height="670" NavigateUrl="~/report/bluecredit_applycredit_popup.aspx" Behaviors="Pin,Move,Resize">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupCreditReport" Width="810px" Height="850px" NavigateUrl="~/report/pfs_viewpro_popup.aspx" DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupTransactionHistory" Width="850px" Height="710px" NavigateUrl="~/report/CreditTransHistory_popup.aspx">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupEditBlueCredit" OnClientClose="showProgressPopup" Width="1050px" Height="780px" NavigateUrl="~/report/bluecredit_editcredit_popup.aspx" DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupInvoice" Width="900px" Height="850px" NavigateUrl="~/report/invoice_popup.aspx" DestroyOnClose="True">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupEstimateView" Width="900px" Height="850px" CssClass="customprintbutton" OnClientShow="OnClientShow" NavigateUrl="~/report/estimateview_popup.aspx" DestroyOnClose="True" Skin="CareBlueInv">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupTruthInLending" behaviors="None" Width="850px" Height="710px" NavigateUrl="~/report/truthInLending_popup.aspx?IsShowBlueCreditAmortsched=0">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupPromissoryNote" behaviors="None" Width="850px" Height="710px" NavigateUrl="~/report/promissoryNote_popup.aspx?IsShowFullTerms=0">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupBlueCreditApplication" behaviors="None"  Width="800px" Height="710px" VisibleOnPageLoad="False" NavigateUrl="~/report/bluecreditApplication_popup.aspx?IsShowLenderInformation=0">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupPaymentReceipt"  NavigateUrl="~/report/paymentReceipt_popup.aspx" Width="450" Height="670" CssClass="customprintbutton">
                        </telerik:RadWindow>
                        <telerik:RadWindow runat="server" ID="popupBCLoan" NavigateUrl="~/report/addBCLoan_popup.aspx" Behaviors="Pin" Width="500" Height="370">
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
                                <a href="javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_submit_small.gif" alt="Submit" /></a> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                <a href="javascript:;" onclick="$find('{0}').close(false);">
                                    <img src="../Content/Images/btn_cancel_small.gif" alt="Cancel" /></a>
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
                            <a href="javascript:;" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:radwindowmanager>
            <asp:Button ID="btnDownloadPdf" Style="display: none;" OnClick="btnDownloadPdf_OnClick"
                runat="server" />
            <asp:Button ID="btnCreatePDF" OnClick="btnCreatePDF_OnClick" runat="server" Style="display: none" />
            <asp:HiddenField ID="hdnIsShowPDFViewer" runat="server" />
            <asp:HiddenField ID="hdnHasConfirmed" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">


        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {

            if ($("#<%=hdnIsShowPDFViewer.ClientID %>").val() == "1") {
                viewPdfViewer();
                $("#<%=hdnIsShowPDFViewer.ClientID %>").val("");
            }

            unBlockUI();

        });

        function showInvoicePopup() {
            $find("<%=popupEstimateView.ClientID%>").show();
        }

        function showTruthInLendingpopup() {
            $find("<%=popupEditBlueCredit.ClientID%>").close();
            //            $find("<%=popupTruthInLending.ClientID%>").show();
            showTruthInLendingPopup();
        }

        function showPromissoryNotepopup() {
            $find("<%=popupEditBlueCredit.ClientID%>").close();
            //            $find("<%=popupPromissoryNote.ClientID%>").show();
            showPromissoryNotePopup();
        }

        function closeApplyCreditPopupandShowTruthInLending() {
            $find("<%=popupApplyCredit.ClientID%>").close();
            //            $find("<%=popupTruthInLending.ClientID%>").show();
            showTruthInLendingPopup();
        }


        function viewPdfViewer(fileTobeOpen) {
            //            var location = window.location.protocol + '//' + window.location.host + "/PatientPortal.Web/report/pdfviewer_popup.aspx?FileName=" + fileTobeOpen + "_" + bluecreditId + ".pdf" + "&PopupTitle=" + popupName + "&ID=" + bluecreditId + "&BC=1";
            var location = "<%=ClientSession.WebPathRootProvider %>" + "report/pdfviewer_popup.aspx";
            window.open(location, fileTobeOpen, "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");

        }

        function showBluecreditApplicationPopup() {
            var popup = $find("<%=popupBlueCreditApplication.ClientID%>");
            popup.show();

            window.setTimeout(function () {
                popup.setActive(true);
                popup.set_modal(true);
            }, 0);
        }

        function showPaymentPopup() {
            var popup = $find("<%=popupPaymentReceipt.ClientID%>");
            popup.show();

            window.setTimeout(function () {
                popup.setActive(true);
                popup.set_modal(true);
            }, 0);
        }

        function showTruthInLendingPopup() {

            var popup = $find("<%=popupTruthInLending.ClientID%>");
            popup.show();

            window.setTimeout(function () {
                popup.setActive(true);
                popup.set_modal(true);
            }, 0);
        }

        function showPromissoryNotePopup() {

            var popup = $find("<%=popupPromissoryNote.ClientID%>");
            popup.show();

            window.setTimeout(function () {
                popup.setActive(true);
                popup.set_modal(true);
            }, 0);
        }

        function showBlueCreditTransactionHistory() {
            var popup = $find("<%=popupTransactionHistory.ClientID%>");
            popup.show();

            window.setTimeout(function () {
                popup.setActive(true);
                popup.set_modal(true);
            }, 0);
        }

        function redirectToPFSReport() {
            refreshPage();
        }

        function viewPdfViewer() {
            var popupName = "Estimate";
            var location = "<%=ClientSession.WebPathRootProvider %>" + "report/pdfviewer_popup.aspx";
            window.open(location, popupName, "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");
        }

        function showAddCreditPopup() {
            $find("<%=popupActiveStatements.ClientID%>").show();
            $find("<%=popupApplyCredit.ClientID %>").close();
        }

        function showApplyCreditPopup() {
            $find("<%=popupActiveStatements.ClientID%>").close();
            $find("<%=popupApplyCredit.ClientID %>").show();
        }

        function redirectToRequestedPage(page) {
            location.href = page;
        }

        <%--function showStatementPopup() {
            var havePermission = '<%=ClientSession.FlagBCCreate%>';
           if (havePermission == "True") {
               $find("<%=popupBCLoan.ClientID%>").show();
            } else {
                var radWindow = $find("<%=RadWindow.ClientID %>");
                radWindow.radalert('', 400, 100, '', "", "../Content/Images/warning.png");
            }

        }--%>

        function redirectToPatientPfsReport() {
            var location = '<%=ClientSession.WebPathRootProvider %>' + "patient/pfsreport.aspx?rn=1";
            window.location.href = location;
        }

        function isConfirmed(isOk) {
            if (isOk) {
                $("#<%=hdnHasConfirmed.ClientID%>").val("true");
                goToBCApplyCredit();
            } else {
                __doPostBack('DeleteOrphanStatements');
            }
        }

        function showProgressPopup() {
            blockUI();
            refreshPage();
        }

        function goToBCApplyCredit() {
            __doPostBack('BCApplyCredit');
        }

        function removeParamFromURL() {
            history.pushState(null, "", location.href.split("?")[0]);
        }

    </script>
</asp:Content>
