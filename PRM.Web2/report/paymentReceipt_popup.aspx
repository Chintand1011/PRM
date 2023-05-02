<%@ Page Language="C#" AutoEventWireup="true" CodeFile="paymentReceipt_popup.aspx.cs"
    Inherits="paymentReceipt_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" content="C# .NET 7.1">
    <meta name="vs_defaultClientScript" content="JavaScript">
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
    <script src="../Scripts/SigWebTablet.js"></script>
    <script type="text/javascript">
        var tmr;
        
        $(document).ready(onSign);

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
                var hiddenControl = '<%= hdnSigData.ClientID %>';
                document.getElementById(hiddenControl).value = GetSigString();
                
                $("#<%=btnSubmit.ClientID%>").click();

            }
        }

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }

        function closePopup() {
            GetRadWindow().close();
        }

        function printPopup() {

            var content = $get("divReceipt").innerHTML;
            var pwin = window.open('', 'print_content', 'width=450,height=620');
            pwin.document.open();
            pwin.document.write('<html><head> <link href="../Styles/pfsHtml.css" rel="stylesheet" type="text/css" />');
            pwin.document.write('<style type="text/css"> table th{text-align: left !important; color: black !important;} table tr td{font-size: 0.8em; }  .buttons { display: none; } body { font-family: Calibri, Helvetica Neue; color: black; } a { text-decoration: none; color: #000000; font-weight: bold; } </style></head>');
            pwin.document.write('<body onload="window.print()"><div class="popup-styles"><br/>' + content + '</div></body></html>'); //div class style added new
            pwin.document.close();

            setTimeout(function () { pwin.close(); }, 1000);
        }

        function printAndCloseParentPopup() {
            $("#<%=btnPrintPopup.ClientID%>").click();
        }

    </script>
</head>
<body <%=OnPageLoad %>>
    <form id="form1" runat="server">
        <telerik:radscriptmanager id="RadScriptManager1" runat="server">
        </telerik:radscriptmanager>
        <table class="CareBluePopup" width="100%">
            <tr>
                <td colspan="2">
                    <h2p>Transaction Confirmation</h2p>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <h4p><%=TransTypeAbbr%> Receipt</h4p>
                </td>
            </tr>
        </table>
        <div id="divReceipt">
            <table class="CareBlueReceipt" width="100%">
                <tr>
                    <td class="ExtraPad">
                        <table width="100%" border="0">
                            <tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td>
                                                <!--<img src="<%=PracticeLogo%>" width="<%=PracticeLogoWidth%>px" height="<%=PracticeLogoHeight%>px" alt="Provider" />-->
                                                <img src="<%=PracticeReceiptLogo%>" alt="Provider Image" style="margin: -8px 0 5px 0;"/>
                                            </td>

                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" id="ReceiptContent">
                                    <table id="receipt">
                                        <tr>
                                            <td height="5px">
                                                <b><%=PracticeName %></b>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="5px">
                                                <%=PracticeAddr1%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td height="5px">
                                                <%=PracticeAddr2%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Phone: 
                                                <%=PracticePhone%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                        </tr>
                                        <tr>
                                            <td>- - - - - - - - - - - - - - - - - - - - - - - - 
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <%=TransTypeAbbr%> Receipt
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <%=PatientName%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Account <%=AccountID%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><b>Amount:
                                                <%=Amount%></b>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><b>Status:
                                                <%=TransStateTypeAbbr%></b>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>- - - - - - - - - - - - - - - - - - - - - - - - 
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <%=PaymentCardAbbr%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Transaction:
                                                <%=StatementID%>-<%=TransactionID%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Date:
                                                <%=TransDateTime%>
                                            </td>
                                        </tr>
                                        <div id="divFields" runat="server">
                                            <tr>
                                                <td>Reference:
                                                <%=FSPPNRef%>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Auth:
                                                <%=AuthRef%>
                                                </td>
                                            </tr>
                                        </div>
                                        <asp:Panel ID="pnlSignData" Enabled="False" Visible="False" runat="server">
                                            <tr>
                                                <td>
                                                    <table border="1" cellpadding="0">
                                                        <tr>
                                                            <td>
                                                               <canvas id="cnv" name="cnv" style="border:1px thin solid black" width="300" height="70"></canvas>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <p class="buttons">
                                                        <input type="file" id="file1" style="display: none" />
                                                        <%-- <input id="SignBtn" name="SignBtn" type="button" value="Sign" onclick="javascript: onSign()" />&nbsp;&nbsp;&nbsp;&nbsp;--%>
                                                        <a href="javascript:;" onclick="javascript: onClear();">
                                                            <img alt="Clear" src="../Content/Images/btn_clear_small.gif" /></a>  &nbsp;&nbsp;&nbsp;&nbsp
                                                        <a href="javascript:;" onclick="javascript: onDone();">
                                                            <img alt="Done" src="../Content/Images/btn_done_small.gif" /></a> &nbsp;&nbsp;&nbsp;&nbsp
                                                        <asp:ImageButton ID="btnPrint" OnClick="btnPrint_Click" runat="server" ImageUrl="../Content/Images/btn_printsign.gif" />
                                                        <asp:ImageButton ID="btnSubmit" OnClick="btnSubmit_Click" runat="server" Style="display: none" ImageUrl="../Content/Images/btn_submit.gif" CssClass="btn-pop-submit" />
                                                        <asp:HiddenField ID="hdnSigData" runat="server" />
                                                    </p>
                                                </td>
                                            </tr>
                                        </asp:Panel>
                                        <asp:Panel runat="server" ID="pnlClientSignImage" Enabled="False" Visible="False">
                                            <tr>
                                                <td>
                                                    <asp:Image ID="imgClientSign" Width="200" runat="server" Style="margin: 10px 0 -30px 0;" />
                                                    <asp:Literal ID="lthtml" Visible="False" Text="<br /> <br /> <br />" runat="server"></asp:Literal>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>_______________________________________________
                                                </td>
                                            </tr>
                                        </asp:Panel>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td valign="top" align="right">
                        <br />
                        <div id="divButtons" class="buttons" runat="server" visible="False" style="float: right;">
                            <asp:ImageButton ID="btnPrintAndClose" ImageUrl="../Content/Images/btn_print_small.gif" OnClick="btnPrint_Click" runat="server" />
                            &nbsp;
                            <a href="javascript:;" onclick="javascript: closePopup();">
                                <img alt="Close" src="../Content/Images/btn_close_small.gif" /></a>
                            &nbsp;
                            <asp:ImageButton ID="btnResign" ImageUrl="../Content/Images/btn_resign.gif" Style="margin-right: 5px;" OnClick="btnResign_Click" runat="server" />
                            <asp:Button ID="btnPrintPopup" OnClick="btnPrint_Click" Style="display: none;" runat="server" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div id="sigBlock" style="width:400px; margin:10px 0 0 5px;"><%=SignatureText%></div>

                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
