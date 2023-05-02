<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="pfsreport.aspx.cs"
    Inherits="pfsreport" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Patient Credit Reporting</h1>
            </div>
            <div class="bodyMain">
                <h2>Previous patient credit reports are displayed below. Note that credit may only be requested once per 30 days.</h2>
                <table width="100%">
                    <tr>
                        <td>
                            <h3>Credit Inquiry History</h3>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <telerik:radgrid id="grdPastCreditReports" runat="server" allowsorting="True" allowpaging="True"
                                pagesize="10" onneeddatasource="grdPastCreditReports_NeedDataSource" onitemcommand="grdPastCreditReports_OnItemCommand" onitemdatabound="grdPastCreditReports_ItemDataBound">
                                <MasterTableView AutoGenerateColumns="False" DataKeyNames="PFSID, TUResultTypeID">
                                    <Columns>
                                        <telerik:GridBoundColumn HeaderText="PFS ID" DataField="PFSID">
                                        </telerik:GridBoundColumn>
                                        <telerik:GridBoundColumn HeaderText="Submit Date" DataField="SubmitDateRaw" DataFormatString="{0:MM/dd/yyyy}">
                                        </telerik:GridBoundColumn>
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
                                        <telerik:GridButtonColumn CommandName="ViewHistory" UniqueName="ViewHistory" HeaderText="View" ButtonType="ImageButton"
                                            ImageUrl="~/Content/Images/view.png">
                                        </telerik:GridButtonColumn>
                                    </Columns>
                                </MasterTableView>
                            </telerik:radgrid>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;<br />
                            <asp:ImageButton ID="btnRunNew" ImageUrl="../Content/Images/btn_runnew.gif" OnClick="BtnRunNew_Click"
                                CssClass="btn-run-new" Style="float: right; margin-right: 10px;" runat="server" />
                        </td>
                    </tr>
                </table>

            </div>
            <telerik:radwindowmanager id="RadWindowManager1" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="525px" height="450px"
                modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                restrictionzoneid="divMainContent" skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize"
                style="z-index: 3000">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popupCreditReport" Width="810px" Height="850px"
                        NavigateUrl="~/report/pfs_viewpro_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" Title="" ID="popupRunNew" NavigateUrl="~/report/pfs_submit_popup.aspx"
                        DestroyOnClose="True">
                    </telerik:RadWindow>
                </Windows>
            </telerik:radwindowmanager>
            <telerik:radwindowmanager id="radWindowManagerDialog" showcontentduringload="True" visiblestatusbar="False"
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
                        <div style="margin-top: 20px; margin-left: 120px;">
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
    <script type="text/javascript" language="javascript">

        $(function () {
            showCreditReportPopup();
        });

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {

            unBlockUI();

        });


        function showProcessing() {

            var isPageValid = false;
            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('CreditValidationGroup');
            }

            if (isPageValid) {
                blockUI();
            }
            else {
                return false;
            }
        }


        function redirectManagePatient() {
            location.href = "../patient/manage.aspx";
        }


        function redirectToPFSReport() {
            location.href = "../patient/pfsreport.aspx";
        }
        function ShowCreditReportPopup() {
            $find("<%=popupCreditReport.ClientID%>").show();
        }


        function submitPfs() {
            $("#<%=btnRunNew.ClientID%>").click();
        }

        var params = (function (a) {
            if (a == "") return {};
            var b = {};
            for (var i = 0; i < a.length; ++i) {
                var p = a[i].split('=', 2);
                if (p.length == 1)
                    b[p[0]] = "";
                else
                    b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "));
            }
            return b;
        })(window.location.search.substr(1).split('&'));

        function showCreditReportPopup() {
            var param = params["rn"];
            if (param == "1") {
                $("#<%=btnRunNew.ClientID%>").click();
        }
    }

    function reloadPage() {
        refreshPage();
    }

    </script>
</asp:Content>
