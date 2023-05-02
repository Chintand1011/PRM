<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="claims.aspx.cs"
    Inherits="claims" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Patient Insurance Claims</h1>
            </div>
            <div class="bodyMain">
                <h2>All received electronic claims are listed below. You may sort the data by clicking on a column
                header. The View icon may be selected to see details about any specific claim.</h2>

                <h3>Received Patient Claims</h3>
                <table width="100%">
                    <tr>
                        <td colspan="2">
                            <telerik:radgrid id="grdClaims" runat="server" allowsorting="True" allowpaging="True"
                                pagesize="10" onneeddatasource="grdClaims_NeedDataSource" onitemcommand="grdClaims_OnItemCommand">
                            <MasterTableView AutoGenerateColumns="False" DataKeyNames="ClaimID">
                                <Columns>
                                    <telerik:GridBoundColumn HeaderText="Date" DataField="DateReceivedRaw" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="ClaimID" DataField="RefClaimID">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderName">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Carrier" DataField="CarrierName">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Adjudicated" DataField="FlagAdjudicatedAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Reconciled" DataField="FlagReconciledAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="PostBack Date" DataField="DateReconciled">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Balance" DataField="ChargesSum$" SortExpression="ChargesSum">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridButtonColumn CommandName="ViewTransaction" HeaderText="View" ButtonType="ImageButton"
                                        UniqueName="View" ImageUrl="~/Content/Images/view.png">
                                    </telerik:GridButtonColumn>
                                </Columns>
                            </MasterTableView>
                        </telerik:radgrid>
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript">
        function refreshPage() {
            location.href = location.href;
        }
    </script>
</asp:Content>
