<%@ Page Language="C#" AutoEventWireup="true" CodeFile="pfs_view_popup.aspx.cs" Inherits="pfs_view_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/pfsHtml.css" rel="stylesheet" type="text/css" />
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
                        Patient Financial Summary Report
                    </h2p>
                </td>
            </tr>
            <tr>
                <td>
                    <h4p>
                        Summary information is displayed below; click on "Show More" for full details and credit history.
                    </h4p>
                </td>
            </tr>
            <tr>
                <td class="ExtraPad">
                    <table>
                        <tr>
                            <td align="right">
                                <table>
                                    <tr>
                                        <td>
                                            <a href="#" onclick="printPopup(this)">
                                                <img src="../Content/Images/btn_print.gif" class="btn-print" alt="Print" /></a>
                                            &nbsp; &nbsp;
                                        </td>
                                        <td>
                                            <a href="#" onclick="closePopup()">
                                                <img src="../Content/Images/btn_close.gif" class="btn-close" alt="Close" /></a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td id="pfsReport">
                                <div class="pfsHtml">
                                    <table class="pfsHtmlTable">
                                        <tr>
                                            <td colspan="2" class="identificationSection">
                                                <div class="identificationAcuracySection">
                                                    <div class="sectionTitle">
                                                        <table class="identificationAcuracySectionTable">
                                                            <tr>
                                                                <td class="sectionTitle">
                                                                    <span class="sectionTitle">IDENTIFICATION ACCURACY</span>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="identificationBodySection">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <div class="identificationAcuracySection">
                                                                <table border="0" class="messageSectionTable">
                                                                    <tr>
                                                                        <td class="messageSubSection">
                                                                            <span class="messageSubSection">MESSAGES:</span>
                                                                        </td>
                                                                        <td class="messageStatusIcon">
                                                                            <span class="messageStatusIcon">
                                                                                <img src="../Content/Images/msg_icon_warning.gif"> </img>
                                                                            </span>
                                                                        </td>
                                                                        <td class="statusMessage">
                                                                            <span class="statusMessageWarningIA">
                                                                                <%=RespStatusAccuracyTxt%>
                                                                            </span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="messageSubSection">
                                                                            <span class="messageSubSection" />
                                                                        </td>
                                                                        <td class="messageStatusIcon">
                                                                            <span class="messageStatusIcon" />
                                                                        </td>
                                                                        <td class="statusMessageWarning">
                                                                            <span class="statusMessageWarningIA">
                                                                                <%=RespWarning1%></span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="messageSubSection">
                                                                            <span class="messageSubSection" />
                                                                        </td>
                                                                        <td class="messageStatusIcon">
                                                                            <span class="messageStatusIcon" />
                                                                        </td>
                                                                        <td class="statusMessageWarning">
                                                                            <span class="statusMessageWarningIA">
                                                                                <%=RespWarning2%></span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="messageSubSection">
                                                                            <span class="messageSubSection" />
                                                                        </td>
                                                                        <td class="messageStatusIcon">
                                                                            <span class="messageStatusIcon" />
                                                                        </td>
                                                                        <td class="statusMessageWarning">
                                                                            <span class="statusMessageWarningIA">
                                                                                <%=RespWarning3%></span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="messageSubSection">
                                                                            <span class="messageSubSection" />
                                                                        </td>
                                                                        <td class="messageStatusIcon">
                                                                            <span class="messageStatusIcon" />
                                                                        </td>
                                                                        <td class="statusMessageWarning">
                                                                            <span class="statusMessageWarningIA">
                                                                                <%=RespWarning4%></span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="messageSubSection">
                                                                            <span class="messageSubSection" />
                                                                        </td>
                                                                        <td class="messageStatusIcon">
                                                                            <span class="messageStatusIcon" />
                                                                        </td>
                                                                        <td class="statusMessageWarning">
                                                                            <span class="statusMessageWarningIA">
                                                                                <%=RespWarning5%></span>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table border="0" cellspacing="0" class="identificationTable">
                                                                    <tr>
                                                                        <td>
                                                                            <span class="inputOutputResultHeaderSubSectionTitle" />
                                                                        </td>
                                                                        <td>
                                                                            <span class="inputOutputResultHeaderTitleSection">Input Subject Data</span>
                                                                        </td>
                                                                        <td>
                                                                            <span class="inputOutputResultHeaderTitleSection">Returned Subject Data</span>
                                                                        </td>
                                                                        <td>
                                                                            <span class="inputOutputResultHeaderTitleSection">Results</span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <span class="inputOutputResultHeaderSubSectionTitle">Name:</span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="inputSubjectDataSection">
                                                                                <%=InputNameFirst%>
                                                                                <%=InputNameMiddle%>
                                                                                <%=InputNameLast%>
                                                                            </span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="returnedSubjectDataSection">
                                                                                <%=RespNameFirst%>
                                                                                <%=RespNameMiddle%>
                                                                                <%=RespNameLast%>
                                                                            </span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <%=RespFlagName%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <span class="inputOutputResultHeaderSubSectionTitle">Date of Birth:</span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="inputSubjectDataSection">
                                                                                <%=InputDOB%></span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="returnedWarnSubjectDataSection">
                                                                                <%=RespDOB%></span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <%=RespFlagDoB%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <span class="inputOutputResultHeaderSubSectionTitle">SSN:</span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="inputSubjectDataSection">
                                                                                <%=InputSSN4%></span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="returnedWarnSubjectDataSection">
                                                                                <%=RespSSN4%></span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <%=RespFlagSSN%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>
                                                                            <span class="inputOutputResultHeaderSubSectionTitle">Address:</span>
                                                                        </td>
                                                                        <td class="inputOutputAddressResultSection">
                                                                            <span class="inputSubjectDataSection">
                                                                                <%=InputAddrStreet%>
                                                                                <br />
                                                                                <%=InputAddrCityAbbr%>
                                                                                <%=InputAddrState%>
                                                                                <%=InputAddrZip%>
                                                                            </span>
                                                                        </td>
                                                                        <td class="inputOutputAddressResultSection">
                                                                            <span class="returnedWarnSubjectDataSection">
                                                                                <%=RespAddrunParsed%>
                                                                                <br />
                                                                                <%=RespAddrCityAbbr%>
                                                                                <%=RespAddrState%>
                                                                                <%=RespAddrZip%>
                                                                            </span>
                                                                        </td>
                                                                        <td class="inputOutputAddressResultSection">
                                                                            <%=RespFlagAddr%>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4" class="grey">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="likelyhoodSection">
                                                <div class="likelyhoodCollectionSection">
                                                    <div class="sectionTitle">
                                                        <table class="likelyhoodCollectionTable">
                                                            <tr>
                                                                <td class="sectionTitle">
                                                                    <span class="sectionTitle">LIKELIHOOD OF COLLECTION</span>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="financialSection">
                                                <div class="probabilityFinanceAidSection">
                                                    <div class="sectionTitle">
                                                        <table class="probabilityFinanceAidTable">
                                                            <tr>
                                                                <td class="sectionTitle">
                                                                    <span class="sectionTitle">PROBABILITY OF FINANCIAL AID</span>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="likelyhoodBodySection">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <div class="likelyhoodCollectionSection">
                                                                <table class="messageSectionTable">
                                                                    <tr>
                                                                        <td class="messageSubSection">
                                                                            <span class="messageSubSection">MESSAGES: </span>
                                                                        </td>
                                                                        <td class="messageStatusIcon">
                                                                            <span class="messageStatusIcon">
                                                                                <img src="../Content/Images/msg_icon_warning.gif"> </img>
                                                                            </span>
                                                                        </td>
                                                                        <td class="statusMessage">
                                                                            <span class="statusMessageWarning">
                                                                                <%=RespStatusCollectTxt%></span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="messageSubSection">
                                                                            <span class="messageSubSection" />
                                                                        </td>
                                                                        <td class="messageStatusIcon">
                                                                            <span class="messageStatusIcon" />
                                                                        </td>
                                                                        <td class="statusMessage">
                                                                            <span class="statusMessage">AVAILABLE CREDIT:
                                                                                <%=RespCalcAC%></span>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table class="likelyhoodTable">
                                                                    <tr>
                                                                        <td class="typeSubSection">
                                                                            <span class="typeSubSection">Type</span>
                                                                        </td>
                                                                        <td class="valueSection">
                                                                            <span class="valueSection">Value</span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="typeColumnValueSection">TRANSUNION NEW ACCOUNT</span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="valueColumnValueSection">
                                                                                <%=RespScoreNAResult%></span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="typeColumnValueSection">TRANSUNION RECOVERY SCORE</span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="valueColumnValueSection">
                                                                                <%=RespScoreRResult%></span>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td class="financialBodySection">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <div class="probabilityFinanceAidSection">
                                                                <table class="messageSectionTable">
                                                                    <tr>
                                                                        <td class="messageSubSection">
                                                                            <span class="messageSubSection">MESSAGES: </span>
                                                                        </td>
                                                                        <td class="messageStatusIcon">
                                                                            <span class="messageStatusIcon">
                                                                                <img src="../Content/Images/msg_icon_warning.gif"> </img>
                                                                            </span>
                                                                        </td>
                                                                        <td class="statusMessage">
                                                                            <span class="statusMessageWarning">
                                                                                <%=RespStatusFinAidTxt%></span>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <table class="financialTable">
                                                                    <tr>
                                                                        <td class="typeSubSection">
                                                                            <span class="typeSubSection">Type</span>
                                                                        </td>
                                                                        <td class="valueSection">
                                                                            <span class="valueSection">Value</span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="typeColumnValueSection">RESIDUAL INCOME</span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="valueColumnValueSection">
                                                                                <%=RespCalcRI%></span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="typeColumnValueSection">DEBT TO INCOME RATIO (DTI)</span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="valueColumnValueSection">
                                                                                <%=RespCalcDTI%></span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="typeColumnValueSection">PERCENT FEDERAL POVERTY GUIDELINE (FPG)</span>
                                                                        </td>
                                                                        <td class="inputOutputResultSection">
                                                                            <span class="valueColumnValueSection">
                                                                                <%=RespCalcFPL%></span>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <div class="transUnionReportSection">
                                                                <div class="sectionTitle">
                                                                    <table>
                                                                        <tr>
                                                                            <td class="sectionTitle">
                                                                                <span class="sectionTitle">TRANSUNION REPORT</span>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <%=RespScoreNAFactor1Abbr%>
                                                                                <br />
                                                                                <%=RespScoreNAFactor2Abbr%>
                                                                                <br />
                                                                                <%=RespScoreNAFactor3Abbr%>
                                                                                <br />
                                                                                <%=RespScoreNAFactor4Abbr%>
                                                                                <br />
                                                                                <%=RespScoreNAFactor5Abbr%>
                                                                                <br />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                    <div id="divButtons">
                                                                        <a href="javascript:;">
                                                                            <img src="../Content/Images/btn_showmore.gif" onclick="hideShowMessage(this)" alt="Hide/Show" /></a>
                                                                        <a href="javascript:;" onclick="printMessage(this)">
                                                                            <img src="../Content/Images/btn_print.gif" class="btn-print" alt="Print" /></a>
                                                                    </div>
                                                                    <div style="display: none;" id="expandTransUnionReport"> 
                                                                        <table>
                                                                            <tr>
                                                                                <td class="callout_bullet">
                                                                                    <%--<span class="expandLink"><a onclick="hideReport();" href="#hideReport" name="expandReport">
                                                                                        Click here to show or hide the complete TransUnion Report</a> </span>--%>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td />
                                                                            </tr>
                                                                            <tr>
                                                                                <center>
                                                                                <td class="printImage">
                                                                                    <pre>
                                                                                        <div class="printImageText">
                                                                                        <%=RespPrintImage%>                       
                                                                                        </div>
                                                                                    </pre>
                                                                                </td>
                                                                                </center>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <div class="horizontalSepeartionLine">
                                                    <hr class="defaultHr"></hr>
                                                </div>
                                                <div class="footer">
                                                    <div class="sectionTitle">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <span class="sectionTitle">Powered by <b>TransUnion</b> </span>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4">
                                <%--      <%=PFSID %>
                                <br />
                                <%=ResultTypeAbbr%>
                                <br />
                                <%=ReasonTypeAbbr%>
                                <br />
                                <%=PatientName%>
                                <br />
                                <%=ProviderName%>
                                <br />
                                <%=ServiceDate%>
                                <br />
                                <%=ServiceTime%>
                                <br />
                                <%=SubmitDate%>
                                <br />
                                <%=BCCount%>
                                <br />
                                <%=SysUserName%>
                                <br />
                                <%=RespAddr2unParsed%>
                                <br />
                                <%=RespAddr2City%>
                                <br />
                                <%=RespAddr2State%>
                                <br />
                                <%=RespAddr2Zip%>
                                <br />
                                <%=RespPhone%>
                                <br />--%>
                                <%--              <%=RespScoreNAFactor1%>
                                <br />
                                <%=RespScoreNAFactor2%>
                                <br />
                                <%=RespScoreNAFactor3%>
                                <br />
                                <%=RespScoreNAFactor4%>
                                <br />
                                <%=RespScoreNAFactor5%>
                                <br />--%>
                                <%--<%=RespScoreNAFactor1Abbr%>
                                <br />
                                <%=RespScoreNAFactor2Abbr%>
                                <br />
                                <%=RespScoreNAFactor3Abbr%>
                                <br />
                                <%=RespScoreNAFactor4Abbr%>
                                <br />
                                <%=RespScoreNAFactor5Abbr%>
                                <br />--%>
                                <%-- <%=RespScoreNACard%>
                                <br />
                                <%=RespScoreNAFlagAlert%>
                                <br />
                                <%=RespScoreNAFlagImpact%>
                                <br />
                                <%=RespScoreRResult%>
                                <br />
                                <%=RespScoreRFactor1%>
                                <br />
                                <%=RespScoreRFactor2%>
                                <br />
                                <%=RespScoreRFactor3%>
                                <br />
                                <%=RespScoreRFactor4%>
                                <br />
                                <%=RespScoreRFactor5%>
                                <br />
                                <%=RespScoreRFactor1Abbr%>
                                <br />
                                <%=RespScoreRFactor2Abbr%>
                                <br />
                                <%=RespScoreRFactor3Abbr%>
                                <br />
                                <%=RespScoreRFactor4Abbr%>
                                <br />
                                <%=RespScoreRFactor5Abbr%>
                                <br />
                                <%=RespScoreRCard%>
                                <br />
                                <%=RespScoreRFlagAlert%>
                                <br />
                                <%=RespScoreRFlagImpact%>
                                <br />
                                <%=RespStatusRiskTxt%>
                                <br />
                                <%=RespStatusRedFlagTxt%>
                                <br />
                                <%=RespReptPullDate%>--%>
                                <br />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <script type="text/javascript" language="javascript">

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
            $("#divButtons").css("display","none");
        }

        function printPopup() {

            var content = $get("pfsReport").innerHTML;
            var pwin = window.open('', 'print_content', 'width=450,height=600');
            pwin.document.open();
            pwin.document.write('<html><head> <link href="../Styles/pfsHtml.css" rel="stylesheet" type="text/css" /><style type="text/css">#divButtons{display:none;} #expandTransUnionReport{display:none;}</style></head><body onload="window.print()">' + content + '</body></html>');
            pwin.document.close();
            setTimeout(function () { pwin.close(); }, 1000);
        }

        function printMessage() {

            var content = $(".printImageText").html(); ;
            var pwin = window.open('', 'print_content', 'width=450,height=600');
            pwin.document.open();
            pwin.document.write('<html><body onload="window.print()">' + content + '</body></html>');
            pwin.document.close();
            setTimeout(function () { pwin.close(); }, 1000);

        }

        function hideShowMessage(obj) {

            if (!isShow) {
                obj.src = "../Content/Images/btn_showless.gif";
                $("#expandTransUnionReport").show();
                isShow = true;
            } else {
                obj.src = "../Content/Images/btn_showmore.gif";
                $("#expandTransUnionReport").hide();
                isShow = false;
            }

        }

      
    </script>
    </form>
</body>
</html>
