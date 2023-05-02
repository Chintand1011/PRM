<%@ Page Title="Log In" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="maintenance.aspx.cs" Inherits="maintenance" %>

<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="HeadContent">
    <link href="Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <%--<link href="Styles/Popup.css" rel="stylesheet" type="text/css" />--%>
</asp:Content>
<asp:Content ID="Content2" runat="server" ContentPlaceHolderID="MainContent">
    <div class="form-row-login">
        <h1 style="margin: 5px 0px 20px 40px; font-size: 1.5em;">
            Provider Login</h1>
        <div class="editor-label-login">
            <asp:Label ID="lblPracticeID" runat="server">Practice ID:</asp:Label>
        </div>
        <div class="editor-field-login">
            <asp:TextBox ID="txtPracticeID" runat="server" Enabled="False" CssClass="textEntry-login"></asp:TextBox>
        </div>
        <div class="editor-label-login" style="margin-top: 3px;">
            <asp:Label ID="lblUserName" runat="server">Username:</asp:Label>
        </div>
        <div class="editor-field-login" style="margin-top: -3px;">
            <asp:TextBox ID="txtUserName" runat="server" Enabled="False" CssClass="textEntry-login"></asp:TextBox>
        </div>
        <div class="editor-label-login" style="margin-top: 3px;">
            <asp:Label ID="lblPassword" runat="server">Password:</asp:Label>
        </div>
        <div class="editor-field-login" style="margin-top: -3px;">
            <asp:TextBox ID="txtPassword" runat="server" Enabled="False" CssClass="passwordEntry-login"
                TextMode="Password"></asp:TextBox>
        </div>
        <div style="clear: both;">
        </div>
        <div style="margin: 15px 0px 0px 140px">
            <asp:ImageButton ID="btnLogin" runat="server" CommandName="Login" Enabled="False"
                ImageUrl="Content/Images/btn_login_orange_fade.gif" ValidationGroup="LoginUserValidationGroup" />
        </div>
    </div>
    <div class="boxLogin">
        <img src="Content/Images/cbpp_welcome.jpg" alt="Welcome" style="margin-left: 0px;" /></div>
    <h5 style="margin: 10px 0px 0px 30px; color:red; font-weight:600;"> 
        The portal site is currently undergoing maintenance and will be available shortly. 
        <br>Please try again soon or call CareBlue support at (866) 220-2500. Thank you for your patience.
    </h5>
    <div class="failureNotification" style="margin: 15px 0px 0px 40px;">
        <asp:Literal ID="litMessage" runat="server"></asp:Literal>
        <div style="text-align: right; margin-top: -10px;">
            <p id="pErrorMessage" runat="server">
            </p>
        </div>
        <asp:Literal ID="litResetPassword" runat="server"></asp:Literal>
    </div>
</asp:Content>
