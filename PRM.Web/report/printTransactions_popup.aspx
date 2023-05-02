<%@ Page Language="C#" AutoEventWireup="true" CodeFile="printTransactions_popup.aspx.cs" Inherits="report_printTransactions_popup" %>

<!DOCTYPE html>

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
                        Transaction Print View
                    </h2p>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h4p>
                        Transaction results are displayed according to the filters as indicated.
                    </h4p>
                    </td>
                </tr>
                <tr>
                    <td class="ExtraPad">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" id="printContent">
                            <tr>
                                <td>
                                    <br />
                                    <table style="margin: 0px auto;" border="0">
                                        <tr>
                                            <td colspan="2" valign="top" height="30" width="500">
                                                <span style="font-size: 2.0em; font-weight: 600; color: #002897;">Transaction Report for <%=PracticeAbbr%></span>
                                            </td>
                                            <td>
                                                <img style="margin-top: -5px;" height="<%=LogoHeight%>" alt="Provider" src="../Content/Images/Providers/<%=LogoName%>" id="header_imgLogo" />
                                            </td>
                                        </tr>
                                        <tr style="font-size: 1.2em;">
                                            <td width="80">Date Range:</td>
                                            <td width="300"><asp:Label ID="lblDate" runat="server"></asp:Label></td>
                                        </tr>
                                        <tr style="font-size: 1.2em;">
                                            <td>Amount Range:</td>
                                            <td><asp:Label ID="lblAmount" runat="server"></asp:Label></td>
                                        </tr>
                                        <tr style="font-size: 1.2em;">
                                            <td>Prepared by:</td>
                                            <td><%=FirstName%> <%=LastName%></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" height="10">
                                                <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                                        </tr>
                                    </table>

                                    <!--
                                    <asp:Label ID="lblPatientId" runat="server"></asp:Label>
                                    <asp:Label ID="lblCategory" runat="server"></asp:Label>
                                    <asp:Label ID="lblStatementId" runat="server"></asp:Label>
                                    <asp:Label ID="lblPatientStatus" runat="server"></asp:Label>
                                    <asp:Label ID="lblTypes" runat="server"></asp:Label>
                                    <asp:Label ID="lblLocation" runat="server"></asp:Label>
                                    <asp:Label ID="lblStatus" runat="server"></asp:Label>
                                    <asp:Label ID="lblProvider" runat="server"></asp:Label>
                                    <asp:Label ID="lblState" runat="server"></asp:Label>
                                    -->

                                    <table width="100%" style="margin: 0px auto; font-size:0.6em;" border="0">
                                        <tr>
                                            <td>
                                                    <telerik:radgrid id="grdTransactions" runat="server" allowsorting="True" allowpaging="True" onneeddatasource="grdTransactions_NeedDataSource">
                                                        <MasterTableView  AllowPaging="False" AutoGenerateColumns="False">
                                                            <Columns>
                                                                <telerik:GridBoundColumn HeaderText="Date" UniqueName="TransactionDateTime"  DataField="TransactionDateTime"  DataType="System.DateTime" DataFormatString="{0:MM/dd/yyyy}">
                                                                </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn HeaderText="TransID" DataField="TransactionID">
                                                                </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn HeaderText="Stmnt" DataField="StatementID">
                                                                </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                                                </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn HeaderText="User" DataField="UserName">
                                                                </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn HeaderText="Method" DataField="MethodTypeAbbr">
                                                                </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn HeaderText="Type" DataField="StatusTypeAbbr">
                                                                </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn HeaderText="Amount" DataField="Amount$" SortExpression="Amount">
                                                                </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn HeaderText="Result" DataField="ResultTypeAbbr">
                                                                </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn HeaderText="Status" DataField="TransStateTypeAbbr">
                                                                </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn HeaderText="Description" DataField="FSPMessage">
                                                                </telerik:GridBoundColumn>
                                                            </Columns>
                                                        </MasterTableView>
                                                    </telerik:radgrid>
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>

        </div>
    </form>
    <script type="text/javascript" language="javascript">

        $(document).ready(function () {
            printPopup();
        });

        function printPopup() {

            var content = $("#printContent").html();
            var pwin = window.open('', 'print_content', 'width=1100,height=500');
            pwin.document.open();
            pwin.document.write('<html><head><link href="~/Styles/Print.css" rel="stylesheet" type="text/css" />');
            pwin.document.write('<style type="text/css"> body { font-family: Calibri, Helvetica Neue; color: black; } .rgPager{ display: none!important;} .rgHeader a {text-decoration: none; color: #000000; font-size: 0.8em;font-weight: bold;} ');
            pwin.document.write('table th{text-align: left !important; color: black !important;} table tr td{font-size: 0.6em; } </style></head>');
            pwin.document.write('<body onload="window.print()"><div class="popup-styles"' + content + '</div></body></html>');
            pwin.document.close();
            setTimeout(function () { pwin.close(); window.close(); }, 1500);
        }
    </script>
</body>
</html>
