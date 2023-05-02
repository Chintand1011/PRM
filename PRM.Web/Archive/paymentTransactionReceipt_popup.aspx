<%@ Page Language="C#" AutoEventWireup="true" CodeFile="paymentTransactionReceipt_popup.aspx.cs"
    Inherits="paymentTransactionReceipt_popup" %>

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
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div>
                <table class="CareBluePopup">
                    <tr>
                        <td>
                            <h2p>
                                                         <b>RECEIPT</b>
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
                        <td class="ExtraPad">
                            <p id="receiptMessage" style="width: 400px;" runat="server">
                                <%=ReceiptMessage %>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <%--<a href="#" onclick="printReceiptPopup(this)">
                                <img src="Content/Images/btn_print_small.gif" alt="Print" class="btn-print" />
                            </a>--%>
                            <a href="#" onclick="closePopup()">
                                <img src="../Content/Images/btn_close.gif" alt="Close" class="btn-close" />
                            </a>
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript" language="javascript">

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }

        function closePopup() {
            GetRadWindow().close();
        }

    </script>
    </form>
</body>
</html>
