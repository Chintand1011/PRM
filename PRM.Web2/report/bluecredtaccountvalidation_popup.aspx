<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredtaccountvalidation_popup.aspx.cs"
    Inherits="report_bluecredtaccountvalidation_popup" %>

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
                                <h2p>BlueCredit Account Validation</h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>Verify the following requirements before creating a BlueCredit account</h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad">
                                <div style="margin:10px 0 -15px 20px;">
                                    <table width="100%" border="0">
                                        <tr>
                                            <td valign="top" width="40">
                                                <asp:Image ID="imgBlueCredit" runat="server" style="margin:3px 0px 10px 0px;"/>
                                            </td>
                                            <td valign="top" width="350">
                                                <p style="font-size:1.3em; color:#002897; font-weight:400; margin:0px 0px 0px 0px;">BlueCredit plans configured and active</p>
                                                <asp:Label ID="lblBlueCredit" Style="" Visible="False" Text="The practice must be setup to accept new BlueCredit account prior to opening an account for a patient." runat="server"></asp:Label>
                                            </td>
                                            <td width="50">
                                                &nbsp;
                                            </td>
                                            <td valign="top">
                                                <asp:Image ID="imgFixBlueCredit" Visible="False" ImageUrl="../Content/Images/icon_fix_sm.png" Style="margin-top:15px; cursor: pointer;" onclick="redirect('../admin/config.aspx')" runat="server" /></td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <asp:Image ID="imgAge" runat="server" style="margin:3px 0px 10px 0px;"/>
                                            </td>
                                            <td valign="top">
                                                <p style="font-size:1.3em; color:#002897; font-weight:400; margin:0px 0px 0px 0px;">Patient or guardian age verified</p>
                                                <asp:Label ID="lblAge" Style="" Visible="False" Text="The patient or guardian listed on the account must be at least 18 years old in order to open a BlueCredit account." runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td valign="top">
                                                <asp:Image ID="imgFixAge" Visible="False" ImageUrl="../Content/Images/icon_fix_sm.png" Style="margin-top:15px; cursor: pointer;" onclick="redirect('../patient/manage.aspx')" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <asp:Image ID="imgIdent" runat="server" style="margin:3px 0px 10px 0px;"/>
                                            </td>
                                            <td valign="top">
                                                <p style="font-size:1.3em; color:#002897; font-weight:400; margin:0px 0px 0px 0px;">Valid identification reviewed</p>
                                                <asp:Label ID="lblIdent" Style="" Visible="False" Text="The patient or guardian must have valid government issued ID verified and saved on file." runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td valign="top">
                                                <asp:Image ID="imgFixIdent" Visible="False" ImageUrl="../Content/Images/icon_fix_sm.png" Style="margin-top:15px; cursor: pointer;" onclick="redirect('../patient/identification.aspx')" runat="server" /></td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <asp:Image ID="imgTUPFS" runat="server" style="margin:3px 0px 10px 0px;"/>
                                            </td>
                                            <td valign="top">
                                                <p style="font-size:1.3em; color:#002897; font-weight:400; margin:0px 0px 0px 0px;">Credit and address check performed</p>
                                                <asp:Label ID="lblTUPFS_fail" Style="" Visible="False" Text="A valid credit check within the last 90 days must be made with a verified SSN prior to opening a BlueCredit account." runat="server"></asp:Label>
                                                <asp:Label ID="lblTUPFS_warn" Style="" Visible="False" Text="CAUTION - The last credit check is out of date or positive identification could not be verified. Another attempt should be made or lender-funded BlueCredit will not be available." runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td valign="top">
                                                <asp:Image ID="imgFixTUPFS" Visible="False" ImageUrl="../Content/Images/icon_fix_sm.png" Style="margin-top:15px; cursor: pointer;" onclick="redirect('../patient/pfsreport.aspx')" runat="server" /></td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <asp:Image ID="imgSsn" runat="server" style="margin:3px 0px 10px 0px;"/>
                                            </td>
                                            <td valign="top">
                                                <p style="font-size:1.3em; color:#002897; font-weight:400; margin:0px 0px 0px 0px;">Valid SSN for borrower</p>
                                                <asp:Label ID="lblSsn_fail" Style="" Visible="False" Text="The patient or guardian must have a full social security number saved to the profile and it should be verified electronically." runat="server"></asp:Label>
                                                <asp:Label ID="lblSsn_warn" Style="" Visible="False" Text="WARNING - The borrower should have a SSN saved to the profile, however their identification has been verified by credit check." runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td valign="top">
                                                <asp:Image ID="imgFixSsn" Visible="False" ImageUrl="../Content/Images/icon_fix_sm.png" Style="margin-top:15px; cursor: pointer;" onclick="redirect('../patient/manage.aspx')" runat="server" /></td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <asp:Image ID="imgCheckCard" runat="server" style="margin:3px 0px 10px 0px;"/>
                                            </td>
                                            <td valign="top">
                                                <p style="font-size:1.3em; color:#002897; font-weight:400; margin:0px 0px 0px 0px;">Checking account verified and on file</p>
                                                <asp:Label ID="lblCheckCard" Style="" Visible="False" Text="A valid checking or savings account should be saved on the profile even if it will not be used for payments." runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td valign="top">
                                                <asp:Image ID="imgFixCheckCard" Visible="False" ImageUrl="../Content/Images/icon_fix_sm.png" Style="margin-top:15px; cursor: pointer;" onclick="redirect('../patient/cardonfile.aspx')" runat="server" /></td>
                                        </tr>
                                        <tr>
                                            <td valign="top">
                                                <asp:Image ID="imgEligState" runat="server" style="margin:3px 0px 10px 0px;"/>
                                            </td>
                                            <td valign="top">
                                                <p style="font-size:1.3em; color:#002897; font-weight:400; margin:0px 0px 0px 0px;">Eligible statement available</p>
                                                <asp:Label ID="lblEligState" Style="" Visible="False" Text="BlueCredit accounts must be immediately applied to an existing statement with an outstanding balance." runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                &nbsp;
                                            </td>
                                            <td valign="top">
                                                <asp:Image ID="imgFixEligState" Visible="False" ImageUrl="../Content/Images/icon_fix_sm.png" Style="margin-top:15px; cursor: pointer;" onclick="redirect('../patient/estimates.aspx')" runat="server" /></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <p align="center" style="color:DarkBlue" runat="server" id="pError" visible="False">
                                                    Any errors must be fixed before creating a new BlueCredit account.
                                                    <br />
                                                    Please select the (FIX) link for problems that are noted.
                                                </p>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Image ID="imgCancel" onclick="reloadPage();" Style="cursor: pointer" CssClass="btn-pop-cancel" ImageUrl="../Content/Images/btn_close.gif" AlternateText="Cancel" runat="server" />
                                &nbsp;
                                <asp:ImageButton ID="btnNext" runat="server" ImageUrl="../Content/Images/btn_next_fade.gif" Enabled="False" CssClass="btn-pop-submit" OnClientClick="closePopup();" />
                            </td>
                        </tr>
                    </table>
                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="Transactions"
                        ShowMessageBox="True" ShowSummary="False" DisplayMode="BulletList" EnableClientScript="True"
                        CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />

                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
        <script type="text/javascript" language="javascript">

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {


            });

            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
                else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

                return oWindow;
            }

            function closePopup() {
                GetRadWindow().close();
            }

            function reloadPage(arg) {
                GetRadWindow().BrowserWindow.closePopup();
                closePopup();
            }

            function redirect(page) {
                assignClientSessionValues(page);
            }


            function assignClientSessionValues(page) {

                var dataToSend = { IsRedirect: '1' };
                var options =
                    {
                        url: '<%=ResolveUrl("~/report/bluecredtaccountvalidation_popup.aspx") %>',
                        data: dataToSend,
                        dataType: 'JSON',
                        type: 'POST',
                        success: function (response) {
                            GetRadWindow().BrowserWindow.redirectToRequestedPage(page);
                            closePopup();
                        }
                    };
                $.ajax(options);
            }


        </script>
    </form>
</body>
</html>
