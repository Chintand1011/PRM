<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="eligibility.aspx.cs"
    Inherits="eligibility" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Patient Insurance Eligibility</h1>
            </div>
            <div class="bodyMain">
                <h2>All previous patient insurance eligibilies are listed below. New eligibilities can
                    be run at any time as long as the patient's insurance information is current and
                    active.</h2>
                <table width="100%">
                    <tr>
                        <td>
                            <h3>Current Eligibility Listing</h3>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <telerik:radgrid id="grdEligibilityHistory" runat="server" allowsorting="True" allowpaging="True"
                                pagesize="10" onneeddatasource="grdEligibilityHistory_NeedDataSource" onitemcommand="grdEligibilityHistory_OnItemCommand">
                                <MasterTableView AutoGenerateColumns="False" DataKeyNames="EligibilityID">
                                    <Columns>
                                        <telerik:GridButtonColumn CommandName="ViewEligilityInfo" HeaderText="View" ButtonType="ImageButton"
                                            ImageUrl="~/Content/Images/view.png">
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
                                    </Columns>
                                </MasterTableView>
                            </telerik:radgrid>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;<br />
                            <asp:ImageButton ID="btnRunNew" runat="server" ImageUrl="../Content/Images/btn_runnew.gif"
                                CssClass="btn-run-new" Style="float: right; margin-right: 10px;" OnClick="btnRunNew_Click" />
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
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript">

        function openEligibilityDetail() {
            location.href = location.href;
        }

        function redirectEstimatePage() {
            location.href = "<%=ClientSession.WebPathRootProvider %>" + "admin/estimate.aspx";
        }

        function redirectToInsurances() {
            location.href = "<%=ClientSession.WebPathRootProvider %>" + "patient/insurances.aspx";
        }

    </script>
</asp:Content>
