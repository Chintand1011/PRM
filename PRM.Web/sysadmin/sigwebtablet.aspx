<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="sigwebtablet.aspx.cs"
    Inherits="sigwebtablet" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" content="C# .NET 7.1">
    <meta name="vs_defaultClientScript" content="JavaScript">
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
    <script src="../Scripts/SigWebTablet.js"></script>
    <script language="Javascript">
        var tmr;
        
        function onSign() {
            var ctx = document.getElementById('cnv').getContext('2d');
            SetDisplayXSize(500);
            SetDisplayYSize(100);
            SetTabletState(0, tmr);
            SetJustifyMode(0);
            ClearTablet();
            if (tmr == null) {
                tmr = SetTabletState(1, ctx, 50);
            }
            else {
                SetTabletState(0, tmr);
                tmr = null;
                tmr = SetTabletState(1, ctx, 50);
            }
        }

        function onClear() {
            ClearTablet();
        }

        function onDone() {
            if (NumberOfTabletPoints() == 0) {
                alert("Please sign before continuing");
            }
            else {
                SetTabletState(0, tmr);
                //RETURN TOPAZ-FORMAT SIGSTRING
                SetSigCompressionMode(1);
                document.FORM1.bioSigData.value = GetSigString();
                document.FORM1.sigStringData.value += GetSigString();
                //this returns the signature in Topaz's own format, with biometric information


                //RETURN BMP BYTE ARRAY CONVERTED TO BASE64 STRING
                SetImageXSize(500);
                SetImageYSize(100);
                SetImagePenWidth(5);
                GetSigImageB64(SigImageCallback);
            }
        }

        function SigImageCallback(str) {
            document.FORM1.sigImageData.value = str;
        }

    </script>
    <script type="text/javascript">
        window.onunload = window.onbeforeunload = (function() {
            closingSigWeb();
        });

        function closingSigWeb() {
            ClearTablet();
            SetTabletState(0, tmr);
        }

</script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <table border="1" cellpadding="0"  width="500">
  <tr>
    <td height="100" width="500">
<canvas id="cnv" name="cnv" style="border:1px solid black" width="500" height="100"></canvas>
    </td>
  </tr>
</table>


<BR>
<canvas name="SigImg" id="SigImg" width="500" height="100"></canvas>



<form action="#" name=FORM1>
<p>
<input id="SignBtn" name="SignBtn" type="button" value="Sign"  onclick="javascript: onSign()"/>&nbsp;&nbsp;&nbsp;&nbsp;
<input id="button1" name="ClearBtn" type="button" value="Clear" onclick="javascript: onClear()"/>&nbsp;&nbsp;&nbsp;&nbsp

<input id="button2" name="DoneBtn" type="button" value="Done" onclick="javascript: onDone()"/>&nbsp;&nbsp;&nbsp;&nbsp

<INPUT TYPE=HIDDEN NAME="bioSigData">
<BR>
<BR>
<TEXTAREA NAME="sigStringData" ROWS="20" COLS="50">SigString: </TEXTAREA>
<TEXTAREA NAME="sigImageData" ROWS="20" COLS="50">Base64 String: </TEXTAREA>
</p>
</form>
 
<br /><br />
</asp:Content>

