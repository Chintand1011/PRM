<%@ Page Title="Log In" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true"
    CodeFile="maintenance.aspx.cs" Inherits="maintenance" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="MainContent">
    <h1>
    </h1>
    <div class="form-row-login">
        <h1 style="margin: 10px 0px 15px 40px; font-size: 1.5em;">
            Patient Login</h1>
        <div class="editor-label-login" style="margin-top:1px;">
            <asp:Label ID="txtLastName" runat="server" AssociatedControlID="txtLastName">Last Name:</asp:Label>
        </div>
        <div class="editor-field-login">
            <telerik:RadTextBox ID="RadTextBox1" runat="server" MaxLength="30" Width="124px"
                InputType="Text" BorderColor="lightgrey" BorderStyle="Solid" BorderWidth="1" Enabled="False" DisabledStyle-BackColor="WhiteSmoke">
            </telerik:RadTextBox>
        </div>
        <div class="editor-label-login"  style="margin-top:4px;" BackColor="#EAEAEA">
            <asp:Label ID="dtDateofBirth" runat="server" AssociatedControlID="dtDateofBirth">Date of Birth:</asp:Label>
        </div>
        <div class="editor-field-login" style="margin: -4px 0px 2px 0px;">
            <telerik:RadDatePicker ID="RadDatePicker1" MinDate="1/1/1900" runat="server" CssClass="fldDate"
                Calendar-Skin="Windows7" Height="22" Width="150" MaxDate="12/31/2020"
                FocusedDate="1/1/1960" Enabled="False" DisabledStyle-BackColor="WhiteSmoke" DateInput-BackColor="WhiteSmoke">
            </telerik:RadDatePicker>
        </div>
        <div class="editor-label-login" style="margin-top:2px;">
            <asp:Label ID="txtAccountID" runat="server" AssociatedControlID="txtAccountID">Account ID:</asp:Label>
        </div>
        <div class="editor-field-login" style="margin-top: -6px;">
            <telerik:RadNumericTextBox runat="server" ID="RadNumericTextBox1" Width="124px" MaxLength="10"
                Height="21px" Type="Number" NumberFormat-DecimalDigits="0" NumberFormat-GroupSeparator=""
                ToolTip="Your Account ID can be found on any statement." Enabled="False" DisabledStyle-BackColor="WhiteSmoke">
            </telerik:RadNumericTextBox>
        </div>
        <div class="editor-section">
            AND</div>
        <div class="editor-label-login">
            <asp:Label ID="txtPinCode" runat="server" AssociatedControlID="txtPINCode">PIN Code:</asp:Label>
        </div>
        <div class="editor-field-login">
            <telerik:RadTextBox ID="RadTextBox2" Width="124px" Height="21px" onkeypress="clearFieldValues('PIN')"
                TextMode="Password" MaxLength="8" ToolTip="Your PIN is your billing zip code until you update it."
                runat="server" Enabled="False" DisabledStyle-BackColor="WhiteSmoke">
            </telerik:RadTextBox>
        </div>
        <div class="editor-section">
            OR</div>
        <div class="editor-label-login">
            <asp:Label ID="txtSSNCode" runat="server" AssociatedControlID="txtSSNCode">SSN Last 4:</asp:Label>
        </div>
        <div class="editor-field-login">
            <telerik:RadTextBox ID="RadTextBox3" TextMode="Password" Width="124px" Height="21px"
                MaxLength="4" onkeypress="clearFieldValues('SSN')" ToolTip="Last 4 digits of your social security number."
                runat="server" Enabled="False" DisabledStyle-BackColor="WhiteSmoke">
            </telerik:RadTextBox>
        </div>
        <div style="clear: both;">
        </div>
        <div style="margin: 15px 0px 0px 165px">
            <asp:ImageButton ID="btnLogin" runat="server" Enabled="False" CommandName="Login"
                src="Content/Images/btn_login_orange_fade.gif" ValidationGroup="LoginUserValidationGroup" />
        </div>
    </div>
    <div class="boxLogin">
        <img src="content/images/cbpp_welcome.jpg" style="margin-left: 0px;" /></div>
    <h5 style="margin: 10px 0px 0px 30px; color:red; font-weight:600;"> 
        The portal site is currently undergoing maintenance and will be available shortly. 
        <br>Please try again soon or call CareBlue support at (866) 220-2500. Thank you for your patience.
    </h5>
    <div class="failureNotification" style="margin: 15px 0px 0px 30px;">
        <asp:Literal ID="litMessage" runat="server"></asp:Literal>
    </div>
</asp:Content>
