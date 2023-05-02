<%@ Page Language="C#" AutoEventWireup="true" CodeFile="transaction_popup.aspx.cs"
    Inherits="transaction_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        </telerik:RadScriptManager>
        <div>
            <table class="CareBluePopup">
                <tr>
                    <td>
                        <h2p>
                        Transaction Details
                    </h2p>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h4p>
                        Description
                    </h4p>
                    </td>
                </tr>
                <tr>
                    <td id="tdTransaction" class="ExtraPad">
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label18" runat="server" Text="TransactionID:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblTransactionID" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label20" runat="server" Text="Patient:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblPatient" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label23" runat="server" Text="Date of Birth:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblDOB" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label27" runat="server" Text="Provider Name:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblProviderName" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label22" runat="server" Text="AccountID:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblAccountID" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label24" runat="server" Text="StatementID:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblStatementID" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label26" runat="server" Text="Statement Type:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblStatementType" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label28" runat="server" Text="Payment Plan Account:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblPaymentPlanAccount" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label30" runat="server" Text="BlueCredit Account:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblBlueCreditAccount" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label32" runat="server" Text="Transaction Date:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblTransactionDate" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label34" runat="server" Text="Transaction Type:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblTransactionType" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label36" runat="server" Text="Transaction Status:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblTransactionStatus" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label38" runat="server" Text="Payment Card Type:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblPaymentCardType" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label40" runat="server" Text="Card Last 4:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblCardLast4" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label42" runat="server" Text="Amount:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblAmount" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label44" runat="server" Text="Balance:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblBalance" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label48" runat="server" Text="Message:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblMessage" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label21" runat="server" Text="Authorization Reference:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblAuthorizationReference" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label25" runat="server" Text="System User"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblSystemUser" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label29" runat="server" Text="Transaction Notes:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblTransactionNotes" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label37" runat="server" Text="Source IP:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblSourceIP" runat="server"></asp:Label>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="editor-label">
                                <asp:Label ID="Label41" runat="server" Text="Record Date:"></asp:Label>
                            </div>
                            <div class="editor-field">
                                <asp:Label ID="lblRecordDate" runat="server"></asp:Label>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div style="margin-top: 20px;" align="center">
                            <a href="javascript:;" onclick="printPopup()">
                                <img src="../Content/Images/btn_print.gif" alt="Print" /></a> &nbsp; &nbsp; <a href="javascript:;" onclick="GetRadWindow().close();">
                                    <img src="../Content/Images/btn_close.gif" alt="Cancel" /></a>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <script type="text/javascript" language="javascript">


            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
                else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

                return oWindow;
            }

            function closePopup() {
                GetRadWindow().BrowserWindow.redirectToPFSReport();
                GetRadWindow().close();
            }

            function printPopup() {

                var content = $get("tdTransaction").innerHTML;
                var pwin = window.open('', 'print_content', 'width=400,height=550');
                pwin.document.open();
                pwin.document.write('<html><head> <link href="../Styles/Popup.css" rel="stylesheet" type="text/css" /><style type="text/css"> .buttons{display:none;}</style></head><body onload="window.print()">' + content + '</body></html>');
                pwin.document.close();
                setTimeout(function () { pwin.close(); }, 1000);
            }

        </script>
    </form>
</body>
</html>
