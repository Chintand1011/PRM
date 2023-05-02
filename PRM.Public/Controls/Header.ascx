<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Header.ascx.cs" Inherits="Controls_Header" %>
<%@ Register Src="~/Controls/TopMenu.ascx" TagName="TopMenu" TagPrefix="uc1" %>
<asp:Image width="180" style="margin: 7px 0px 7px 10px;" ID="imgLogo" runat="server" />
<img alt="spacer" src="content/images/spacer.gif" height="65" width="1" />
<div class="txtLogout-ppp">
    You are logged in as:<br />
    <b>
        <%=Extension.ClientSession.LastName %>,&nbsp;<%=Extension.ClientSession.FirstName %>
        &nbsp;|&nbsp; <a href="myinfo.aspx">Update Profile</a> &nbsp;|&nbsp;
        <%--<asp:LoginStatus ID="HeadLoginStatus" runat="server" LogoutAction="Redirect" LogoutImageUrl="~/Content/Images/btn_logout_orange.gif"
            Style="margin-bottom: -3px;" LogoutText="Log Out" LogoutPageUrl="" />--%>
    </b>
    <asp:ImageButton ID="ImageButton1" runat="server" Style="margin-bottom: -3px;"  ImageUrl="~/Content/Images/btn_logout_orange.gif"
        AlternateText="Log Out" PostBackUrl="~/login.aspx" />
</div>
<uc1:TopMenu runat="server" />
