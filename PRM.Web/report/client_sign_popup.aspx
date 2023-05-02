<%@ Page Language="C#" AutoEventWireup="true" CodeFile="client_sign_popup.aspx.cs" Inherits="report_client_sign_popup" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
     <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="../Styles/BlueCredit.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
     <table style="margin: 0px auto;">
                                <tr>
                                    <td>&nbsp;</td>
                                    <td align="left" valign="top">
                                        <table width="400">
                                            <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                                            <tr>
                                                <td height="15">
                                                    <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                                            </tr>
                                            <!-- ENDSECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                                            <tr>
                                                <td>
                                                    <h1>PRIOR TO SIGNING THIS PROMISSORY NOTE</h1>
                                                    <div>Please read this entire disclosure carefully. Unless you agree to the terms of this agreement, you should not sign or accept the loan.</div>
                                                </td>
                                            </tr>
                                            <tr class="ExtraPadTbl2">
                                                <td>
                                                    <asp:CheckBox ID="chkAgreementTerms" runat="server" Checked="False" />
                                                    <div style="margin: -20px 0 -0px 25px;"><h3>I have read and understand the fees and conditions of the loan as<br/>disclosed, and agree to comply with all terms of this loan agreement.</h3></div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="30">&nbsp;</td>
                                    <td align="left" valign="top">
                                        &nbsp;<br />
                                        <asp:Panel runat="server" ID="pnlClientSignImage" Enabled="False" Visible="False" HorizontalAlign="Left">
                                            <table width="100%">
                                                <tr class="ExtraPadTbl2">
                                                    <td><span>Signature of Borrower</span><br />
                                                        <asp:Image ID="imgClientSign" Width="200" runat="server" Style="margin: 10px 0 -30px 0;" />
                                                        <p>________________________________________________________________<br />&nbsp;</p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>                        

                                        <asp:Panel ID="pnlSign" Visible="False" runat="server">
                                            <span>
                                                <br /><br /><br />
                                                X _________________________________________ 
                                                <br />Signature of Borrower</span>
                                                <br />&nbsp;
                                                <br />Date ___________________
                                                <br />&nbsp;
                                        </asp:Panel>

                                    </td>
                                </tr>
                            </table>
    </div>
    </form>
</body>
</html>
