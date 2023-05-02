<%@ Page Language="C#" AutoEventWireup="true" CodeFile="survey_detail_popup.aspx.cs"
    Inherits="survey_detail_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title />
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/Print.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/CareBlue.InvWindow.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <asp:UpdatePanel ID="updPanelEligility" runat="server">
            <ContentTemplate>
                <telerik:RadScriptManager runat="server" ID="RadScriptManager1" />
                <div>
                    <table class="SurveyPopup">
                        <tr style="height: 2.2in;">
                            <td align="left">
                                <table id="tbl-cc">
                                    <tr style="height: 0.15in">
                                        <td width="325" style="text-align: center; vertical-align: middle; font-size: 0.7em; background-color: #fbeded;">Patient Information
                                        </td>
                                    </tr>
                                    <tr style="height: 0.3in;">
                                        <td>PROVIDER: <%=DoctorName%>
                                        </td>
                                    </tr>
                                    <tr style="height: 0.3in;">
                                        <td>PATIENT NAME: <%=PatientName%>
                                        </td>
                                    </tr>
                                    <tr style="height: 0.3in;">
                                        <td>DATE OF BIRTH: <%=PatientDoB%>
                                        </td>
                                    </tr>
                                    <tr style="height: 0.3in;">
                                        <td>RECORD NUMBER: <%=SurveyID%>
                                        </td>
                                    </tr>
                                    <tr style="height: 0.3in;">
                                        <td>REPORT DATE: <%=SurveyDate%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td align="right">
                                <table id="tbl-cc">
                                    <tr style="height: 0.15in">
                                        <td width="325" style="text-align: center; vertical-align: middle; font-size: 0.7em; background-color: #fbeded;">ASSESSMENT SCORING
                                        </td>
                                    </tr>
                                    <tr style="height: 0.3in;">
                                        <td>SCORE: <%=SurveyScore%>
                                        </td>
                                    </tr>
                                    <tr style="height: 0.3in;">
                                        <td>DIAGNOSIS: <%=SurveyScoreRating%>
                                        </td>
                                    </tr>
                                    <tr style="height: 0.3in;">
                                        <td>ACTION: <%=SurveyAction%>
                                        </td>
                                    </tr>
                                    <tr style="height: 0.3in;">
                                        <td>IMPAIRMENT: <%=SurveyScoreDescription%>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr style="height: 0.3in; text-align: center;">
                            <td colspan="2">ASSESSMENT RESULTS
                            </td>
                        </tr>
                        <%ShowSurveyDetails();%>
                    </table>
                </div>
                </div>
           <telerik:RadWindowManager ID="radWindowDialog" ShowContentDuringLoad="True" VisibleStatusbar="False"
               VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="700px" Height="500px"
               Modal="True" EnableEmbeddedBaseStylesheet="False" EnableEmbeddedSkins="False"
               RestrictionZoneID="divMainContent" Skin="CareBlueInf" Style="z-index: 3000">
               <AlertTemplate>
                   <div class="rwDialogPopup radalert">
                       <h5>
                           <div class="rwDialogText">
                               {1}
                           </div>
                       </h5>
                       <div style="margin-top: 20px; margin-left: 51px;">
                           <a href="javascript:;" onclick="$find('{0}').close(true);">
                               <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                       </div>
                   </div>
               </AlertTemplate>
           </telerik:RadWindowManager>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
    <script type="text/javascript">

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

        function closeRadWindow() {
            GetRadWindow().BrowserWindow.closeEstimateViewPopup();
        }
    </script>
</body>
</html>
