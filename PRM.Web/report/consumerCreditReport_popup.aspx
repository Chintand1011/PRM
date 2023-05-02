<%@ Page Language="C#" AutoEventWireup="true" CodeFile="consumerCreditReport_popup.aspx.cs"
    Inherits="consumerCreditReport_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Consumer Credit Report</title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/Print.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <telerik:radscriptmanager id="RadScriptManager1" runat="server">
        </telerik:radscriptmanager>
        <div>
            <table class="CareBluePopup" width="100%">
                <tr>
                    <td>
                        <!--                        <h6 style="font-size:0.8em; text-align:center; margin: 3px 0 3px 0;">
                            A copy of the full consumer credit report is available below.
                        </h6>-->
                        <h6 style="color: darkred; font-size: 0.8em; text-align: center; margin: 3px 0 3px 0;">THIS REPORT IS PROVIDED FOR INTERNAL PROVIDER USE ONLY. 
                            <br />
                            DO NOT PRINT FOR THE PATIENT - SEE DISCLAIMER AT BOTTOM.
                        </h6>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div id="divButtons" runat="server" align="center">
                            <a href="#" onclick="printPopup()">
                                <img src="../Content/Images/btn_print.gif" class="btn-print" alt="Print" /></a>
                            &nbsp; <a href="#" onclick="closePopup()">
                                <img src="../Content/Images/btn_close.gif" class="btn-close" alt="Close" /></a>
                        </div>
                        <div id="divPrintImage">
                            <table>
                                <tr>
                                    <center>
                                        <td class="printImage">
                                            <pre>
                                                <div class="printImageText" style="border:double; margin-top:0; width:100%">
                                                <%=RespPrintImage%>                       
                                                </div>
                                            </pre>
                                        </td>
                                    </center>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <center>
                        <td class="printImage">
                            <h6 style="font-size: 0.8em; margin: -40px 30px 30px 3px;">
                                <br />
                                The specific reporting agency name, address and telephone number which was used for this credit application is available at the bottom of the report and may be provided to the patient.
                                <br />
                                &nbsp;
                                <br />
                                Provider Disclaimer to the patient: 
                                <br />
                                "We obtained information from a consumer reporting agency as part of our consideration of your application. The reporting agency plays no part in our decision and is unable to supply specific reasons why credit was or was not extended to you. You have a right under the Fair Credit Reporting Act to know the information contained in your credit file at the consumer reporting agency. In some cases, you also have a right to a free copy of your report from the credit reporting agency, if you request it no later than 60 days after you receive this notice. In addition, if you find any information contained in the report you receive is inaccurate or incomplete, you have the right to dispute the matter with the credit reporting agency. Please contact them directly if any of these conditions apply to you."
                            </h6>
                        </td>
                    </center>
                </tr>
            </table>
        </div>
    </form>
    <script type="text/javascript">

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }


        function printPopup() {

            var content = $get("divPrintImage").innerHTML;
            var pwin = window.open('', 'print_content', 'width=650,height=600');
            pwin.document.open();
            pwin.document.write('<html><head> <link href="../Styles/pfsHtml.css" rel="stylesheet" type="text/css" /><style type="text/css">#divButtons{display:none;} </style></head><body onload="window.print()">' + content + '</body></html>');
            pwin.document.close();
            setTimeout(function () { pwin.close(); }, 1000);
        }

        window.onunload = function (e) {
            opener.refresh();
        };

        function closePopup() {
            //            opener.refresh();
            window.close();
        }

    </script>
</body>
</html>
