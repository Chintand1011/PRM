<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="sysclientsign.aspx.cs"
    Inherits="sysclientsign" %>

<asp:content id="HeaderContent" runat="server" contentplaceholderid="HeadContent">
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" content="C# .NET 7.1">
    <meta name="vs_defaultClientScript" content="JavaScript">
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
    <script language="Javascript">

        var Index;

        function pluginLoaded() {
            //alert("Plugin loaded!");
        }

        function onClear() {
            document.getElementById('sigplus').clearSignature();
        }

        function onSign() {
            document.getElementById('sigplus').tabletState = 1;
            document.getElementById('sigplus').captureMode = 1;
            Index = setInterval(Refresh, 50);

            document.getElementById('sigplus').antiAliasSpotSize = .85;
            document.getElementById('sigplus').antiAliasLineScale = .55;
        }


        function onDone() {
            if (document.getElementById('sigplus').totalPoints == 0) {
                alert("Please sign before continuing");
                return false;
            }
            else {
                document.getElementById('sigplus').tabletState = 0;
                clearInterval(Index);
                //RETURN TOPAZ-FORMAT SIGSTRING
                document.getElementById('sigplus').compressionMode = 1;
                //alert(document.getElementById('sigplus').sigString);
                //this returns the signature in Topaz's own format, with biometric information
                var hiddenControl = '<%= hdnSigData.ClientID %>';
                document.getElementById(hiddenControl).value = document.getElementById('sigplus').sigString;
            }

        }

        function Refresh() {
            document.getElementById('sigplus').refreshEvent();
        }

        //-->
    </script>
</asp:content>
<asp:content id="BodyContent" runat="server" contentplaceholderid="MainContent">
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>System Client Sign</h1>
            </div>
            <div class="bodyMain">
                <h2>Add Patient Sign.</h2>
                
                        <asp:HiddenField ID="hdnSigData" runat="server" />

        
                <p>
                    This demo shows how to use Topaz's SigPlusWeb NPAPI plugin to easily capture signatures using Internet Explorer, Firefox, and Chrome. 
            Press 'SIGN' to capture a signature, 'CLEAR' to clear it, and 'DONE' to get back a signature in Topaz's biometric 'SigString' format, or as an image converted to a hexadecimal string for easy imaging of the signature back at the server.

                </p>
        <asp:ImageButton ID="btnSubmit" OnClick="btnSubmit_Click" runat="server" ImageUrl="../Content/Images/btn_submit.gif" CssClass="btn-pop-submit" />

        <table border="1" cellpadding="0" width="500">
            <tr>
                <td height="10" width="500">
                    <object id="sigplus" type="application/sigplus" width="500" height="100">
                        <param name="onload" value="pluginLoaded" />
                    </object>
                </td>
            </tr>
        </table>
        <p>
            <input type="file" id="file1" style="display: none" />
            <input id="SignBtn" name="SignBtn" type="button" value="Sign" onclick="javascript: onSign()" />&nbsp;&nbsp;&nbsp;&nbsp;
            <input id="button1" name="ClearBtn" type="button" value="Clear" onclick="javascript: onClear()" />&nbsp;&nbsp;&nbsp;&nbsp

            <input id="button2" name="DoneBtn" type="button" value="Done" onclick="javascript: onDone()" />&nbsp;&nbsp;&nbsp;&nbsp

        </p>
                    </div>
                </div>

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    </asp:content>

