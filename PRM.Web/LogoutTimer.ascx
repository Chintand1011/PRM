<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LogoutTimer.ascx.cs" Inherits="LogoutTimer" %>
<script type="text/javascript" language="javascript">
    
    function sm_timer(sessionLength, redirectUrl) {

        var timeleft = sessionLength;
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm != null) {
            prm.add_endRequest(function () {
                timeleft = sessionLength;
            });
        }
        var modalVisible = false;
        var displayElements = $('.sm_logoutTimer');
        function updateDisplay() {
            if (displayElements != null) {
                var m = Math.floor(timeleft / 60);
                var s = timeleft % 60;
                document.getElementById("sm_logoutTimer").innerHTML = "Are you still working? To protect patient privacy, your session will expire soon.<br /> Time until logged out: " + m.toString() + ':' + (s <= 9 ? '0' : '') + s.toString();
            }
        }
        function logout_callback(arg) {
            $.get(location.href);
            modalVisible = false;
            timeleft = sessionLength;
        }
        function checkPrompt() {
            if (timeleft <= 120 && !modalVisible) {
                modalVisible = true;
                radconfirm('', logout_callback, 400, 140, null, '', '../Content/Images/warning.png');
                displayElements = $('u');
            }
        }
        function logout() {
            document.location.href = redirectUrl;
        }
        function tick() {
            if (timeleft <= 0) {
                logout();
            } else {
                updateDisplay();
                checkPrompt();
                setTimeout(tick, 1000);
            }
            timeleft--;
        }
        setTimeout(tick, 1000);
    }

    function logout() {
        $("#<%=btnLogOut.ClientID %>").click();
    }
</script>
<telerik:RadWindowManager ID="windowManagerLogout" Behaviors="Move" Style="z-index: 200001"
    ShowContentDuringLoad="False" VisibleStatusbar="False" VisibleTitlebar="True"
    ReloadOnShow="True" runat="Server" Width="700px" Height="500px" Modal="True"
    EnableEmbeddedBaseStylesheet="False" EnableEmbeddedSkins="False" Skin="CareBlueInf">
    <ConfirmTemplate>
        <div class="rwDialogPopup radconfirm" style="width: 300px;">
            <div class="rwDialogText">
                <h5>
                    <div id="sm_logoutTimer" style="margin-left: 30px; width: 100%;">
                    </div>
                </h5>
            </div>
            <div style="margin: 15px 0 0 30px;">
                <a href="javascript:;" onclick="$find('{0}').close(true);">
                    <img src="../Content/Images/btn_continue.gif" alt="Continue" /></a> &nbsp; &nbsp;
                <a href="javascript:;" onclick="logout()">
                    <img src="../Content/Images/btn_logout_orange.gif" alt="Log Out" /></a>
            </div>
        </div>
    </ConfirmTemplate>
</telerik:RadWindowManager>
<asp:Button ID="btnLogOut" style="display: none;" Text="Log Out" OnClick="btnLogout_Click" runat="server" />
