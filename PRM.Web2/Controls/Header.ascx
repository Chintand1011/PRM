<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Header.ascx.cs" Inherits="Controls_Header" %>
<%@ Register Src="~/Controls/TopMenu.ascx" TagName="TopMenu" TagPrefix="uc1" %>
<asp:Image width="180" style="margin: 7px 0px 7px 10px;" ID="imgLogo" runat="server" />
<img alt="spacer" src="../Content/Images/spacer.gif" height="65" width="1" />
<div id="divCurrentDateTime" class="txtDateTime">
</div>
<div class="txtLogout-ppw">
    You are logged in as:<br />
    <b>
        <%=Extension.ClientSession.LastName %>,&nbsp;<%=Extension.ClientSession.FirstName %>
        &nbsp;|&nbsp; <a id="helpTicket" href="javascript:;">Help Ticket</a> &nbsp;|&nbsp;
        <asp:ImageButton ID="ImageButton1" runat="server" Style="margin-bottom: -3px;" ImageUrl="../Content/Images/btn_logout_orange.gif"
            AlternateText="Log Out" OnClientClick="return redirect()" />
    </b>
</div>
<uc1:TopMenu runat="server" />
<div class="txtProviderNote" id="pNoteProviderSite" runat="server">
</div>
<%--<div class="txtActivePtName" id="divPatient" runat="server">
        <asp:ImageButton ID="imgBtnClose" ImageUrl="~/Content/Images/close.ico" runat="server" OnClick="imgBtnClose_Click"/>
        <div style="padding:1px 0 0 20px;"><asp:Literal ID="litPatientName" runat="server"></asp:Literal></div>
    </div>
--%>
<script type="text/javascript">
    function setDateAndTime() {
        window.setTimeout("setDateAndTime()", 1000);
        $("#divCurrentDateTime").text(new Date().format("MMMM dd, yyyy h:mm tt"));
    }

    $(function () {
        setDateAndTime();
        $("#divCurrentDateTime").text(new Date().format("MMMM dd, yyyy h:mm tt"));
    });

    function redirect() {
        location.href = "<%=ClientSession.WebPathRootProvider %>" + "login.aspx";
        return false;
    }
</script>
