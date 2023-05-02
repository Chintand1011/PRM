<%@ Page Language="C#" AutoEventWireup="true" CodeFile="creditTransHistory_popup.aspx.cs"
    Inherits="CreditTransHistory_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
    <style media="screen" type="text/css">
        body {
            color: #222222 !important;
        }
        .CareBluePopup td {
            padding-bottom: 0em;
        }
    </style>
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
                        BlueCredit Detail
                    </h2p>
                </td>
            </tr>
            <tr>
                <td>
                    <h4p>
                        Transaction history of credit plan and future scheduled payments and interest
                    </h4p>
                </td>
            </tr>
            <tr>
                <td class="ExtraPad">
                <table width="100%" border="0" cellpadding="0" cellspacing="0" id="printContent"><tr><td>

                        <% if (IsShowTransactionHistory) { %>
                    <br />
                    <table style="margin: 0px auto;" border="0">
                        <tr>
                            <td style="width: 630px;">
                                <img style="margin-top: 5px;" alt="Provider" src="../Content/Images/Providers/careblue_logo_bcagreement.gif" id="header_imgLogo" />
                            </td>
                            <td valign="top">
                                <span>Revision 2016-04A</span>
                                <%--=DateTime.Now.ToString("MM/dd/yyyy hh:mm tt")--%>
                            </td>
                        </tr>
                    </table>
                    <br />
                        <% } %>

                    <table style="margin: 0px auto;">
                        <tr>
                            <td colspan="6" align="center" valign="top" height="30">
                                <span style="font-size: 1.6em; font-weight: 600; color: #002897;">TRANSACTION HISTORY AND ESTIMATED PAYMENT SCHEDULE</span>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" valign="bottom">
                                <span style="font-size: 1.2em; font-weight: 600; color: #e97824;">BORROWER INFORMATION</span>
                            </td>
                            <td colspan="3" valign="bottom">
                                <span style="font-size: 1.2em; font-weight: 600; color: #e97824;">AGREEMENT INFORMATION</span>
                            </td>
                        </tr>
                        <tr style="font-size: 1.1em;">
                            <td width="20">&nbsp;</td>
                            <td width="50">Name:</td>
                            <td width="230"><%=BorrowerName%></td>
                            <td width="20">&nbsp;</td>
                            <td width="80">Account ID:</td>
                            <td width="150"><%=AccountName%></td>
                        </tr>

                        <% if (IsShowTransactionHistory) { %>

                        <tr style="font-size: 1.1em;">
                            <td></td>
                            <td>SSN:</td>
                            <td><%=BorrowerSSN%></td>
                            <td></td>
                            <td>Prepared By:</td>
                            <td><%=PracticeName%></td>
                        </tr>
                        <tr style="font-size: 1.1em;">
                            <td></td>
                            <td>DOB:</td>
                            <td><%=BorrowerDOB%></td>
                            <td></td>
                            <td>Prepared:</td>
                            <td><%=OpenDate%></td>
                        </tr>
                        <% } %>
                        <tr>
                            <td colspan="6" height="10"><img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                        </tr>
                        <tr>
                            <td colspan="6" valign="top" align="center" height="30"><span style="font-size: 1.25em; font-weight: 600;">THIS IS A REVISED STATEMENT BASED ON CURRENT BALANCE AND LOAN TERMS
                                </span></td>
                        </tr>
                    </table>
                    <table width="760" align="center">
                        <tr>
                            <td>
                                <div>
                                    <telerik:RadGrid ID="grdTransactionHistory" runat="server" AllowSorting="True" AllowPaging="True"
                                        OnNeedDataSource="grdTransactionHistory_NeedDataSource" PageSize="15">
                                        <MasterTableView AutoGenerateColumns="False">
                                            <Columns>
                                                <telerik:GridBoundColumn HeaderText="Cycle" DataField="Cycle" AllowSorting="False">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Date" DataField="Date">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Description" DataField="Desc">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Adjustment" DataField="NewAdditions$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Start Balance" DataField="BeginBalance$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Payment" DataField="Payment$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Principal" DataField="Principal$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Interest" DataField="Interest$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="End Balance" DataField="EndBalance$">
                                                </telerik:GridBoundColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                </div>
                            </td>
                        </tr>
                    </table>

                        <% if (IsShowTransactionHistory) { %>
                    <br />
                    <table width="700" border="0" align="center" style="font-size:0.9em;">
                        <tr>
                            <td height="1"><img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                        </tr>
                        <tr>
                            <td><b><u>DISCLOSURE: THIS IS A LOAN, IT MUST BE REPAID.</u></b> Loans are reported to credit bureaus, which may affect your credit rating. In the event of default, the entire unpaid loan, including interest, late charges and collections costs, shall, at the option of the Practice become immediately due and payable. All late charges, collection costs and attorney fees will be paid by the borrower. See your lending agreement documents for any additional information about nonpayment, default, and term. </td>
                        </tr>
                    </table>

                        <% } %>

                </td></tr></table>
                </td>
            </tr>
            <tr height="50" valign="top">
                <td>
                    <a href="javascript:;" onclick="closePopup()">
                        <img src="../Content/Images/btn_close.gif" alt="Close" class="btn-pop-cancel" /></a>
                    <asp:ImageButton ID="btnPrint" ImageUrl="../Content/Images/btn_print.gif" CssClass="btn-pop-submit" OnClick="btnPrint_OnClick" AlternateText="Print" runat="server"/>
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


        function printPopup() {

            var content = $("#printContent").html();
            var pwin = window.open('', 'print_content', 'width=800,height=500');
            pwin.document.open();
            pwin.document.write('<html><head><link href="~/Styles/Print.css" rel="stylesheet" type="text/css" />');
            pwin.document.write('<style type="text/css"> body { font-family: Calibri, Helvetica Neue; color: black; } .rgPager{ display: none!important;} .rgHeader a {text-decoration: none; color: #000000; font-weight: bold;} ');
            pwin.document.write('table th{text-align: left !important; color: black !important;} table tr td{font-size: 0.8em; } </style></head>');
            pwin.document.write('<body onload="window.print()"><div class="popup-styles"' + content + '</div></body></html>');
            pwin.document.close();
            setTimeout(function () { pwin.close(); }, 1000);
        }

    </script>
    </form>
</body>
</html>
