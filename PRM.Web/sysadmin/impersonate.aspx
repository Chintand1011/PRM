<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="impersonate.aspx.cs"
    Inherits="impersonate" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Impersonate</h1>
            </div>
            <div class="bodyMain">
                <h2>Select a practice user to impersonate.</h2>
                <div style="float: right; width: 100%">
                    <h3>Current Users</h3>
                    <telerik:radgrid id="grdUsers" runat="server" allowsorting="True" allowpaging="True"
                        onneeddatasource="grdUsers_NeedDataSource" pagesize="10" onitemcommand="grdUsers_ItemCommand">
                                    <ClientSettings EnableRowHoverStyle="true" EnablePostBackOnRowClick="true">
                                       <Selecting AllowRowSelect="True"></Selecting>
                                    </ClientSettings>
                                    <MasterTableView AutoGenerateColumns="False" DataKeyNames="SysUserID">
                                        <Columns>
                                            <telerik:GridBoundColumn HeaderText="LastName" DataField="NameLast">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="FirstName" DataField="NameFirst">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Role Type" DataField="RoleType">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Username" DataField="UserName">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Email" DataField="Email">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Last Login" DataField="LastLogin" DataFormatString="{0:MM/dd/yyyy}">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Last IP Address" DataField="LastLoginIPAddress">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="State" DataField="LockoutAbbr">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Status" DataField="FlagActiveAbbr">
                                            </telerik:GridBoundColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:radgrid>
                </div>

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
