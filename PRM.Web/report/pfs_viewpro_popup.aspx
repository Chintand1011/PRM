<%@ Page Language="C#" AutoEventWireup="true" CodeFile="pfs_viewpro_popup.aspx.cs" Inherits="pfs_view_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
    <style>
        ul {
            list-style-type: circle;
            padding: 0px;
            margin: 0px 0px 0px 15px;
        }

            ul li {
                padding-left: 0px;
            }

        .bold {
            font-weight: bold;
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
                        <h2p>Patient Financial Summary Report</h2p>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h4p>Summary information is displayed below; click on "View" below for full details and credit history.</h4p>
                    </td>
                </tr>
                <tr class="pfsMain">
                    <td class="ExtraPad">
                        <table class="pfsReport">
                        <% if (!FlagFullReport)
                            {  %>
                            <tr>
                                <td align="middle" valign="middle" colspan="2" height="30">
                                    <pfs6 style="color:darkred; font-weight:600;">Your practice is configured to view the credit score first. BlueCredit options will be available after retrieving the full report.</pfs6>
                                </td>
                            </tr>
                        <%  } %>
                            <tr>
                                <td align="left" valign="bottom">
                                    <pfs4>PFS #<%=PFSID%> [<%=ResultTypeAbbr%>] - <%=RespReptPullDate%></pfs4>
                                </td>
                                <td align="right">
                                    <table>
                                        <tr>
                                            <td>
                                                <% if (FlagFullReport)
                                                   {  %>
                                                <img src="../Content/Images/btn_print_small.gif" onclick="window.print();" alt="Print" style="cursor: pointer;" />
                                                &nbsp; &nbsp;
                                                <%  }
                                                   else
                                                   { %>

                                                <a href="javascript:;">
                                                    <img src="../Content/Images/btn_getfullreport.gif" onclick="showFullReport()" alt="Show Full Report" /></a>
                                                &nbsp; &nbsp; 

                                                <%  }  %>


                                                <% if (FlagFullReport && ClientSession.BCLenderFlagLive)
                                                   { %>
                                                <asp:ImageButton ID="btnGetRates" ImageUrl="../Content/Images/btn_checkrates.gif" OnClick="btnGetRates_OnClick" runat="server" />
                                                &nbsp; &nbsp;
                                              <% } %>


                                                <% if (ClientSession.FlagBCModify && ClientSession.FlagBlueCredit && PatientID > 0)
                                                   { %>
                                                <asp:ImageButton ID="btnGoToBluecredit" ImageUrl="../Content/Images/btn_gobluecredit.gif" OnClick="btnGoToBluecredit_OnClick" runat="server" />
                                                &nbsp; &nbsp;
                                              <% } %>


                                                <% if (PatientID <= 0)
                                                   {%>
                                                <asp:ImageButton ID="btnClearPatient" ImageUrl="../Content/Images/btn_addpatient.gif" OnClientClick="addPatient(); return false;" runat="server" />
                                                <% } %>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table class="pfsHtmlTable" style="width: 100%;">
                                        <tr>
                                            <td class="sectionTitle" style="background-color: #99bae9" colspan="2">
                                                <pfs1>Patient Financial Summary Report</pfs1>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="sectionTitle" style="min-width: 500px;">
                                                <pfs2>IDENTIFICATION SUMMARY</pfs2>
                                            </td>
                                            <td class="sectionTitle" style="min-width: 270px;">
                                                <pfs2>CREDIT PROFILE</pfs2>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="sectionBody" style="vertical-align: top;">
                                                <table border="0" cellspacing="0">
                                                    <tr>
                                                        <td style="min-width: 65px;">
                                                            <div style="margin-bottom: 5px;">&nbsp;</div>
                                                        </td>
                                                        <td style="min-width: 150px;">
                                                            <pfs3><b>PATIENT SUPPLIED INFO</b></pfs3>
                                                        </td>
                                                        <td style="min-width: 160px;">
                                                            <pfs3><b>PUBLIC RECORD DATA</b></pfs3>
                                                        </td>
                                                        <td>
                                                            <pfs3><b>RESULT</b></pfs3>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4">
                                                            <hr />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>NAME:
                                                        </td>
                                                        <td>
                                                            <%=InputNameFirst%>
                                                            <%=InputNameMiddle%>
                                                            <%=InputNameLast%>
                                                        </td>
                                                        <td>
                                                            <%=RespNameFirst%>
                                                            <%=RespNameMiddle%>
                                                            <%=RespNameLast%>
                                                        </td>
                                                        <td>
                                                            <%=RespFlagName%>
                                                        </td>
                                                    </tr>
                                                    <tr style="padding-left: 10px;">
                                                        <td>DOB:
                                                        </td>
                                                        <td>
                                                            <%=InputDOB%>
                                                        </td>
                                                        <td>
                                                            <%=RespDOB%>
                                                        </td>
                                                        <td>
                                                            <%=RespFlagDoB%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>SSN:
                                                        </td>
                                                        <td>
                                                            <%=InputSSNenc%> 
                                                        </td>
                                                        <td>
                                                            <%=RespSSNenc%> 
                                                        </td>
                                                        <td>
                                                            <%=RespFlagSSN%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td valign="top">ADDRESS:
                                                        </td>
                                                        <td valign="top">
                                                            <%=InputAddrStreet%>
                                                            <br />
                                                            <%=InputAddrCityAbbr%>
                                                            <%=InputAddrState%>
                                                            <%=InputAddrZip%>
                                                                            
                                                        </td>
                                                        <td valign="top">
                                                            <%=RespAddrunParsed%>
                                                            <br />
                                                            <%=RespAddrCityAbbr%>
                                                            <%=RespAddrState%>
                                                            <%=RespAddrZip%>
                                                                            
                                                        </td>
                                                        <td valign="top">
                                                            <%=RespFlagAddr%>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <table border="0" cellspacing="0">
                                                    <tr>
                                                        <td colspan="2">
                                                            <!-- risk: <%=RespStatusRiskTxt%><br /> //doesn't appear to be returned by TU -->
                                                            <br />
                                                            <pfs3><b>IDENTIFICATION ISSUES TO BE RECONCILED:</b></pfs3>
                                                            <ul>
                                                                <li class="bold"><%=RespStatusRedFlagTxt%></li>
                                                                <li><%=RespWarning1%></li>
                                                                <li><%=RespWarning2%></li>
                                                                <li><%=RespWarning3%></li>
                                                                <li><%=RespWarning4%></li>
                                                                <li><%=RespWarning5%></li>
                                                            </ul>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class="sectionBody" style="vertical-align: top;">
                                                <table>
                                                    <tr>
                                                        <td style="min-width: 110px;">FICO SCORE: 
                                                        </td>
                                                        <td>
                                                            <pfs5><%=RespScoreBCResult%></pfs5>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>MEDICAL SCORE: 
                                                        </td>
                                                        <td>
                                                            <pfs6><%=RespScoreNAResult%></pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>ID ACCURACY: 
                                                        </td>
                                                        <td>
                                                            <pfs6><%=RespStatusAccuracyTxt%></pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <!--//appears to not be a valid returned number from TU-->
                                                        <td>DEBT TO INCOME: 
                                                        </td>
                                                        <td>
                                                            <pfs6><%=RespCalcDTI%></pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>POVERTY RATIO: 
                                                        </td>
                                                        <td>
                                                            <pfs6><%=RespCalcFPL%></pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>RESIDUAL INCOME:  
                                                        </td>
                                                        <td>
                                                            <pfs6><%=RespCalcRI%></pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>AVAILABLE CREDIT: 
                                                        </td>
                                                        <td>
                                                            <pfs6><%=RespCalcAC%>&nbsp;<%=RespRevAvail%></pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>PAST DUE: 
                                                        </td>
                                                        <td>
                                                            <pfs6><%=RespTotalsPastDue%></pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>IN COLLECTION: 
                                                        </td>
                                                        <td>
                                                            <pfs6><%=RespCollectionsDue%></pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>STATED INCOME: 
                                                        </td>
                                                        <td>
                                                            <pfs6><%=InputStatedIncome%></pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>STATED HOUSING: 
                                                        </td>
                                                        <td>
                                                            <pfs6><%=InputHousingType%></pfs6>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="sectionTitle">
                                                <pfs2>PRIMARY FACTORS FOR CREDIT RATING</pfs2>
                                            </td>
                                            <td class="sectionTitle">
                                                <pfs2>LOAN QUALIFICATION</pfs2>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="sectionBody">
                                                <ul>
                                                    <li><%=RespScoreNAFactor1Abbr%></li>
                                                    <li><%=RespScoreNAFactor2Abbr%></li>
                                                    <li><%=RespScoreNAFactor3Abbr%></li>
                                                    <li><%=RespScoreNAFactor4Abbr%></li>
                                                    <li><%=RespScoreNAFactor5Abbr%></li>
                                                </ul>
                                            </td>
                                            <td class="sectionBody">
                                                <table>
                                                    <tr>
                                                        <td style="min-width: 80px;">AMOUNT: 
                                                        </td>
                                                        <td>
                                                            <pfs5><%=BCRecAmountAdj%></pfs5>
                                                        </td>
                                                    </tr>
                                                </table>
                                                <table style="margin-top: 2px;">
                                                    <tr>
                                                        <td style="min-width: 80px;">LOAN TYPE:</td>
                                                        <td>
                                                            <pfs6><b><%=LoanTypeAbbr%></b></pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><%=RateLabel%></td>
                                                        <td>
                                                            <pfs6><%=RateAPRAbbr%></pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>RISK RATING:</td>
                                                        <td>
                                                            <% if (FlagFullReport) { %>
                                                            <pfs6><b><%=RespScoreBCRisk%></b> [<%=RespScoreBCPRiskNumber%>]</pfs6>
                                                            <% } %>
                                                        </td>
                                                    </tr>

                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="sectionTitle">
                                                <pfs2>CREDIT UTILIZATION</pfs2>
                                            </td>
                                            <td class="sectionTitle">
                                                <pfs2>COLLECTIONS</pfs2>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="sectionBody">
                                                <table>
                                                    <tr>
                                                        <td width="120">
                                                            <pfs6>REVOLVING</pfs6>
                                                        </td>
                                                        <td width="120">
                                                            <pfs6>OPEN LINE</pfs6>
                                                        </td>
                                                        <td width="120">
                                                            <pfs6>INSTALLMENT</pfs6>
                                                        </td>
                                                        <td width="120">
                                                            <pfs6>MORTGAGE</pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <%=RespRevCreditLimit%>
                                                        </td>
                                                        <td>
                                                            <%=RespOpenHighCredit%>
                                                        </td>
                                                        <td>
                                                            <%=RespInstHighCredit%>
                                                        </td>
                                                        <td>
                                                            <%=RespMortHighCredit%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <%=RespRevBalance%>
                                                        </td>
                                                        <td>
                                                            <%=RespOpenBalance%>
                                                        </td>
                                                        <td>
                                                            <%=RespInstBalance%>
                                                        </td>
                                                        <td>
                                                            <%=RespMortBalance%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <%=RespRevMonthlyPay%>
                                                        </td>
                                                        <td>
                                                            <%=RespOpenMonthlyPay%>
                                                        </td>
                                                        <td>
                                                            <%=RespInstMonthlyPay%>
                                                        </td>
                                                        <td>
                                                            <%=RespMortMonthlyPay%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <%=RespRevPastDue%>
                                                        </td>
                                                        <td>
                                                            <%=RespOpenPastDue%>
                                                        </td>
                                                        <td>
                                                            <%=RespInstPastDue%>
                                                        </td>
                                                        <td>
                                                            <%=RespMortPastDue%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <%=RespRevAvailable%>
                                                        </td>
                                                        <td>
                                                            <%=RespOpenAvailable%>
                                                        </td>
                                                        <td>
                                                            <%=RespInstAvailable%>
                                                        </td>
                                                        <td>
                                                            <%=RespMortAvailable%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class="sectionBody">
                                                <table>
                                                    <tr>
                                                        <td width="40">
                                                            <pfs6>DATE</pfs6>
                                                        </td>
                                                        <td width="140">
                                                            <pfs6>CREDITOR</pfs6>
                                                        </td>
                                                        <td>
                                                            <pfs6>BALANCE</pfs6>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <%=RespOpened1%>
                                                        </td>
                                                        <td>
                                                            <%=RespCreditor1%>
                                                        </td>
                                                        <td>
                                                            <%=RespBalance1%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <%=RespOpened2%> 
                                                        </td>
                                                        <td>
                                                            <%=RespCreditor2%>
                                                        </td>
                                                        <td>
                                                            <%=RespBalance2%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <%=RespOpened3%> 
                                                        </td>
                                                        <td>
                                                            <%=RespCreditor3%>
                                                        </td>
                                                        <td>
                                                            <%=RespBalance3%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <%=RespOpened4%> 
                                                        </td>
                                                        <td>
                                                            <%=RespCreditor4%>
                                                        </td>
                                                        <td>
                                                            <%=RespBalance4%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <%=RespOpened5%> 
                                                        </td>
                                                        <td>
                                                            <%=RespCreditor5%>
                                                        </td>
                                                        <td>
                                                            <%=RespBalance5%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="sectionTitle" style="background-color: #99bae9; text-align: left;">
                                                <pfs3>&nbsp; Credit data provided by TransUnion LLC</pfs3>
                                            </td>
                                            <td class="sectionTitle" style="background-color: #99bae9; text-align: right;">
                                                <pfs3>Disputes: 800-916-8800 &nbsp;</pfs3>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br />

                        <div id="divButtons">

                            <% if (!FlagFullReport)
                               {  %>

                            <pfs2 style="line-height: 2.0em;">GET FULL CREDIT REPORT:</pfs2>
                            <br />
                            <a href="javascript:;">
                                <img src="../Content/Images/btn_getfullreport.gif" onclick="showFullReport()" alt="Show Full Report" /></a>
                            &nbsp; &nbsp; 
                            
                            <%  } %>


                            <% if (FlagFullReport)
                               {  %>

                            <pfs2 style="line-height: 2.0em;">VIEW DETAILED CONSUMER CREDIT REPORT:</pfs2>
                            <br />
                            <a href="javascript:;">
                                <img src="../Content/Images/btn_view_small.gif" onclick="showMessagePopup()" alt="ShowMessagePopup" /></a>
                            &nbsp; &nbsp; 

                            <a href="javascript:;" onclick="printPopup();">
                                <img src="../Content/Images/btn_print_small.gif" class="btn-print" alt="Print" /></a>
                            <%  } %>


                            <a href="#" onclick="closePopup()" style="float: right;">
                                <img src="../Content/Images/btn_close_small.gif" class="btn-close" alt="Close" /></a>

                        </div>
                        <div style="display: none; margin-top: -10px;" id="divTransUnionReport">
                            <table>
                                <tr>
                                    <center>
                                        <td class="printImage">
                                            <pre>
                                        <div class="printImageText" style="border:double; margin-top:0; padding:0 20px;">
                                        <%=ClientSession.ObjectValue%>                    
                                        </div>
                                    </pre>
                                        </td>
                                    </center>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
            <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="600px" height="360px" restrictionzoneid="divMainContent"
                modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                skin="CareBlue" behaviors="Reload,Close,Move,Resize">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popup_Rates">
                        <ContentTemplate>
                               <table>
                                     <tr>
                                         <td><div style="margin-top:5px;">
                                             <h2p>Verified Financing Options</h2p>
                                             </div>
                                         </td>
                                     </tr>
                                     <tr>
                                         <td>
                                             <h4p>Loan options are based on the last credit check, and may change if new credit data is obtained.</h4p>
                                         </td>
                                     </tr>
                                   </table>
                            <br/>
                                <div id="divRates" runat="server" style="color:#444444;">
                                </div>
                            <div style="color:#444444; margin:7px 0 20px 20px;">
                                <% if(FlagPFSExpired) { %>
                                <img alt="Warning" src="../Content/Images/warning.png" height="20" style="margin-bottom:-4px;"/> &nbsp;
                                The last credit check is more than 30 days old. These rates should be used for guidance only. 
                                <br />A new credit check will be required before issuing BlueCredit. 
                                <% } %>
                            </div>
                                <div id="divMessage" runat="server" style="color:#444444; margin:7px 0 20px 20px;">
                                    *Minimum monthly payment assuming the minimum borrowed amount per plan type.
                                </div>
                            <div align="right">
                            <img alt="Close" style="cursor: pointer" src="../Content/Images/btn_close.gif" onclick="$find('<%=popup_Rates.ClientID%>').close();"/>&nbsp; &nbsp; &nbsp; &nbsp;
                            </div>
                            
                        </ContentTemplate>
                    </telerik:RadWindow>
                </Windows>
            </telerik:radwindowmanager>
        </div>
        <script type="text/javascript" language="javascript">

            $(document).ready(function () {
                $("li").each(function () {
                    var text = $(this).text();
                    if (text == '') {
                        $(this).remove();
                    }
                });
            });

            var isShow = false;

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


            function hideShowMoreButtons() {
                $("#divButtons").css("display", "none");
            }

            function printPopup() {

                var content = $get("divTransUnionReport").innerHTML;
                var pwin = window.open('', 'print_content', 'width=650,height=600');
                pwin.document.open();
                pwin.document.write('<html><head> <link href="../Styles/pfsHtml.css" rel="stylesheet" type="text/css" /><style type="text/css">#divButtons{display:none;} </style></head><body onload="window.print()">' + content + '</body></html>');
                pwin.document.close();
                setTimeout(function () { pwin.close(); }, 1000);
            }


            function showMessagePopup() {
                var location = '<%=ClientSession.WebPathRootProvider %>' + "report/consumerCreditReport_popup.aspx";
                window.open(location, "WindowPopup", "width=700px, height=960px, scrollbars=yes");
            }

            function showFullReport() {
                __doPostBack('ShowFullReport');
            }

            function goToBluecreditPage() {
                var params = "?BCLoan=1";
                GetRadWindow().BrowserWindow.redirectToBluecreditPage(params);
                GetRadWindow().close();
            }

            function addPatient() {
                GetRadWindow().BrowserWindow.addPatient();
                GetRadWindow().close();
            }

            function closeRatePopup() {
                confirm("why pop?");

            }

        </script>
    </form>
</body>
</html>
