<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="collections.aspx.cs"
    Inherits="collections" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Account Collections</h1>
            </div>
            <div class="bodyMain">
                <h2>Any collection activity for this patient is listed below</h2>
                <h2>This is a header H3 example. And this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on. </h2>
                <h3>This is a header H3 example. And this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on. </h3>
                <h4>This is a header H4 example. And this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on. </h4>
                <h5>This is a header H5 example. And this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on. </h5>
                <h6>This is a header H6 example. And this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on; this is what happens if the sentence just runs on and on and all the way on. </h6>
                <table width="100%">
                    <tr>
                        <td>
                            <h3>Resulting Matches</h3>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <hr />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <telerik:radgrid id="grdCollections" runat="server" allowsorting="True" allowpaging="True"
                                pagesize="10" onneeddatasource="grdCollections_NeedDataSource" onitemcommand="grdCollections_OnItemCommand">
                            <MasterTableView AutoGenerateColumns="False" DataKeyNames="AccountID">
                                <Columns>
                                    <telerik:GridBoundColumn HeaderText="Date" DataField="DateLastUpdate" DataFormatString="{0:MM/dd/yyyy}">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="AccountID" DataField="AccountID">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Doctor" DataField="ProviderName">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Last Payment" DataField="LastPaymentDays">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Reason" DataField="CollectionReasonTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="State" DataField="CollectionStatusTypeAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Last Update" DataField="DateCollectionUpdate">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Charges" DataField="ChargesSum$">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Patient Paid" DataField="PatientPaySum$">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Patient Balance" DataField="PatientBalSum$">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="Collected" DataField="CollectionRecdSum$">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="PayPlan" DataField="FlagPayPlanAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridBoundColumn HeaderText="BlueCredit" DataField="FlagBlueCreditAbbr">
                                    </telerik:GridBoundColumn>
                                    <telerik:GridButtonColumn CommandName="ViewTransaction" HeaderText="View" ButtonType="ImageButton"
                                        ImageUrl="~/Content/Images/view.png">
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
