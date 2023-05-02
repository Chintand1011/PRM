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
    <script type="text/javascript">


        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }

        function closePopup() {
            var isHtmlPopup = $("#<%=hdnIsHtmlPopup.ClientID%>").val();
            if (isHtmlPopup == "1") {
                window.close();
            } else {
                GetRadWindow().close();
            }
        }

        function printPopup() {

            var content = $get("divReceipt").innerHTML;
            var pwin = window.open('', 'print_content', 'width=450,height=650');
            pwin.document.open();
            pwin.document.write('<html><head> <link href="../Styles/pfsHtml.css" rel="stylesheet" type="text/css" />');
            pwin.document.write('<style type="text/css"> table th{text-align: left !important; color: black !important;} table tr td{font-size: 0.8em; }  .buttons { display: none; } body { font-family: Calibri, Helvetica Neue; color: black; } a { text-decoration: none; color: #000000; font-weight: bold; } </style></head>');
            pwin.document.write('<body onload="window.print()"><div class="popup-styles"><br/>' + content + '</div></body></html>'); //div class style added new
            pwin.document.close();

            setTimeout(function () { pwin.close(); }, 1000);
        }


    </script>
</head>

<body <%=OnLoad %>>
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
                                                <img src="<%=PracticeReceiptLogo%>" alt="Provider Image" style="margin: -8px 0 5px 0;"/>
                                            </td>

                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td id="ReceiptContent">
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
                        <div id="divButtons" class="buttons" runat="server" style="float: right;">
                            <a style="margin-left: 5px;" href="javascript:;" onclick="javascript: printPopup();">
                                <img alt="Close" src="../Content/Images/btn_print_small.gif" /></a>
                            <br />
                            <a href="javascript:;" onclick="javascript: closePopup();">
                                <img alt="Close" src="../Content/Images/btn_close_small.gif" /></a>
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
        <asp:HiddenField ID="hdnIsHtmlPopup" runat="server" />
    </form>
</body>
</html>
