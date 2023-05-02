<%@ Page Language="C#" AutoEventWireup="true" CodeFile="carrierSearch_popup.aspx.cs"
    Inherits="carrierSearch_popup" %>

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
                        Title
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
                    <table width="100%">
                        <tr>
                            <td>
                                <table width="100%">
                                    <tr>
                                        <td colspan="3">
                                            <h2 align="center">
                                                Carrier Search</h2>
                                            <p align="center">
                                                Please enter any or all fields below and select search</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="48%">
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label1" runat="server">Policy Type:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:RadComboBox ID="cmbPolicyTypes" runat="server" Width="300px" EmptyMessage="Choose Type..."
                                                        AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="CarrierTypeID"
                                                        MaxHeight="200">
                                                    </telerik:RadComboBox>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label2" runat="server">State:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:RadComboBox ID="cmbStates" runat="server" Width="300px" EmptyMessage="Choose State..."
                                                        AllowCustomText="False" MarkFirstMatch="True" DataTextField="Name" DataValueField="StateTypeID"
                                                        MaxHeight="200">
                                                    </telerik:RadComboBox>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label3" runat="server">Carrier Name:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox runat="server" ID="txtCarrierName"></asp:TextBox>
                                                </div>
                                            </div>
                                        </td>
                                        <td width="4%">
                                            &nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3"> 
                                <a href="#" onclick="closePopup()">
                                    <img src="../Content/Images/btn_close.gif" class="btn-pop-cancel" alt="Close" /></a>
                                <asp:ImageButton ID="btnSearch" ImageUrl="../Content/Images/btn_search.gif" CssClass="btn-pop-next"
                                    OnClick="btnSearch_OnClick" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Panel ID="pnlSearch" Visible="False" runat="server">
                                    <hr />
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label4" runat="server">Search Results:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:RadComboBox ID="cmbCarrierTypes" runat="server" Width="300px" EmptyMessage="Choose Type..."
                                                AllowCustomText="False" MarkFirstMatch="True" DataTextField="CarrierName" DataValueField="CarrierID"
                                                MaxHeight="200" AutoPostBack="True" OnSelectedIndexChanged="cmbCarrierTypes_OnSelectedIndexChanged">
                                            </telerik:RadComboBox>
                                        </div>
                                    </div>
                                    <a href="#" onclick="closePopup()">
                                        <img src="../Content/Images/btn_close.gif" class="btn-pop-cancel" alt="Close" /></a>
                                    <asp:ImageButton ID="btnSelect" Enabled="False" ImageUrl="../Content/Images/btn_select.gif"
                                        CssClass="btn-pop-submit" OnClick="btnSelect_OnClick" runat="server" />
                                </asp:Panel>
                            </td>
                        </tr>
                    </table>
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
            GetRadWindow().close();
        }

        function CloseAndRebind() {
            GetRadWindow().BrowserWindow.refreshPage();
            closePopup();
        }
    </script>
    </form>
</body>
</html>
