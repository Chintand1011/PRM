<%@ Page Title="" Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true"
    CodeFile="dashboard.aspx.cs" Inherits="transaction_dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div style="margin-bottom: 15px;">
                Providers:
                <telerik:RadComboBox ID="cmbProviders" runat="server" Width="200px" EmptyMessage="All Providers"
                    AllowCustomText="False" MarkFirstMatch="True" DataTextField="ProviderAbbr" DataValueField="ProviderID"
                    OnSelectedIndexChanged="cmbprovider_SelectedIndexChanged" AutoPostBack="True"
                    MaxHeight="200">
                </telerik:RadComboBox>
            </div>
            <telerik:RadChart ID="transactionChart" runat="server" Width="700px" Height="700px"
                DataGroupColumn="TypeName" AutoTextWrap="true" Skin="LightBlue">
                <PlotArea>
                    <XAxis DataLabelsColumn="CategoryName">
                    </XAxis>
                    <YAxis Appearance-ValueFormat="Currency">
                    </YAxis>
                </PlotArea>
            </telerik:RadChart>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
