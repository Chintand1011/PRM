<%@ Page Language="C#" AutoEventWireup="true" CodeFile="payplanTransHistory_popup.aspx.cs"
    Inherits="payPlanTransHistory_popup" %>

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
        <telerik:radscriptmanager id="RadScriptManager1" runat="server">
        </telerik:radscriptmanager>
        <div>
            <table class="CareBluePopup">
                <tr>
                    <td>
                        <h2p>
                        Payment Plan Detail
                    </h2p>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h4p>
                        Transaction history of payment plan and future scheduled payments and fees
                    </h4p>
                    </td>
                </tr>
                <tr>
                    <td class="ExtraPad">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" id="printContent"><tr><td>
    
                        <% if (IsShowPayplanInfo) { %>
                        <br />
                        <table style="margin: 0px auto;" border="0">
                            <tr>
                                <td style="width: 630px;">
                                    <img style="margin-top: 5px;" alt="Provider" src="../Content/Images/Providers/careblue_logo_bcagreement.gif" id="header_imgLogo" />
                                </td>
                                <td valign="top">
                                    <span>Revision 2016-02A</span>
                                    <%--=DateTime.Now.ToString("MM/dd/yyyy hh:mm tt")--%>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <% } %>

                        <table style="margin: 0px auto; color:#000000;">
                            <tr>
                                <td colspan="6" align="center" valign="top" height="30">
                                    <span style="font-size: 1.6em; font-weight: 600; color: #002897;">TRANSACTION HISTORY AND ESTIMATED PAYMENT SCHEDULE</span>
                                </td>
                            </tr>
                            <tr style="font-size: 1.1em;">
                                <td width="0"></td>
                                <td width="80">Name:</td>
                                <td width="230"><%=PatientName%></td>
                                <td width="20">&nbsp;</td>
                                <td width="80">Prepared:</td>
                                <td width="150"><%=OpenDate%></td>
                            </tr>
                            <tr style="font-size: 1.1em;">
                                <td></td>
                                <td>Statement:</td>
                                <td><%=StatementID%></td>
                                <td></td>
                                <td>Provider:</td>
                                <td><%=PracticeName%></td>
                            </tr>
                            <tr>
                                <td colspan="6" height="10"><img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                            </tr>
                           
                        </table>
                        <table width="100%">
                            <tr>
                                <td>
                                    <div>
                                        <telerik:radgrid id="grdPayplanTransactionHistory" runat="server" allowsorting="True" allowpaging="True"
                                            onneeddatasource="grdPayPlanTransactionHistory_NeedDataSource" pagesize="15">
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
                                                    <telerik:GridBoundColumn HeaderText="Fee" DataField="Fee$">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn HeaderText="End Balance" DataField="EndBalance$">
                                                    </telerik:GridBoundColumn>
                                                </Columns>
                                            </MasterTableView>
                                        </telerik:radgrid>
                                    </div>
                                </td>
                            </tr>
                        </table>

                    </td></tr></table>
                    </td>
                </tr>
                <tr height="50" valign="top">
                    <td>
                        <a href="javascript:;" onclick="closePopup()">
                            <img src="../Content/Images/btn_close.gif" alt="Close" class="btn-pop-cancel" /></a>
                        <asp:ImageButton ID="btnPrint" OnClick="btnPrint_OnClick" ImageUrl="../Content/Images/btn_print.gif" CssClass="btn-pop-submit" AlternateText="Print" runat="server"/>
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
                pwin.document.write('table th{text-align: left !important; color: black !important;} table tr td{font-size: 0.75em; } </style></head>');
                pwin.document.write('<body onload="window.print()"><div class="popup-styles"' + content + '</div></body></html>');
                pwin.document.close();
                setTimeout(function () { pwin.close(); }, 1000);
            }

        </script>
    </form>
</body>
</html>
