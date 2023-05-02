<%@ Page Language="C#" AutoEventWireup="true" CodeFile="eligibility_popup.aspx.cs"
    Inherits="report_eligibility_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="~/Scripts/jquery-1.4.1.js" type="text/javascript"></script>
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
                    <table id="tblEligibilityPopup" width="100%">
                        <tr>
                            <td>
                                <table width="100%">
                                    <tr>
                                        <td colspan="3">
                                            <h2>
                                                Eligibility Response</h2>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="48%">
                                            <asp:Label ID="lblPracticeName" runat="server"></asp:Label>
                                        </td>
                                        <td width="4%">
                                            &nbsp;
                                        </td>
                                        <td width="48%" valign="top" align="right">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <a href="#" onclick="redirectEstimatePage()">
                                                            <img src="../Content/Images/btn_estimate.gif" class="btn-estimate" alt="Estimate" /></a>
                                                    </td>
                                                    <td>
                                                        <a href="#" onclick="printPopup(this)">
                                                            <img src="../Content/Images/btn_print.gif" class="btn-print" alt="Print" /></a>
                                                    </td>
                                                    <td>
                                                        <a href="#">
                                                            <img src="../Content/Images/btn_download.gif" alt="Download" class="btn-download" /></a>
                                                    </td>
                                                    <td>
                                                        <a href="#" onclick="closePopup()">
                                                            <img src="../Content/Images/btn_close.gif" class="btn-close" alt="Close" /></a>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="100%">
                                    <tr>
                                        <td colspan="3">
                                            <h2>
                                                Transaction Details</h2>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="48%">
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label1" runat="server">Submit Date:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblSubmitDate" runat="server" Text="Date"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label2" runat="server">Submit ID:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblSubmitID" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label3" runat="server">Trace Number:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblTraceNumber" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </td>
                                        <td width="4%">
                                            &nbsp;
                                        </td>
                                        <td width="48%" valign="top">
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label4" runat="server">Carrier:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblCarrier" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label5" runat="server">Provider:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblProvider" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label6" runat="server">NPI:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblProviderNPI" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="100%">
                                    <tr>
                                        <td colspan="3">
                                            <h2>
                                                Subscriber Information</h2>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="48%">
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label7" runat="server">Subscriber:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblSubscriber" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label8" runat="server">Date of Birth:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblDateofBirth" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label9" runat="server">Gender:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblGender" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label10" runat="server">Address:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblAddress1" runat="server"></asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblAddress2" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label11" runat="server">Member ID:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblMemberID" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label12" runat="server">Group Number:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblGroupNumber" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label13" runat="server">SSN:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblSSN" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </td>
                                        <td width="4%">
                                            &nbsp;
                                        </td>
                                        <td width="48%" valign="top">
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label14" runat="server">Relationship:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblRelationship" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label15" runat="server">Coverage Class:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblCoverageClass" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label16" runat="server">Dependent Type:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblDependentType" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label17" runat="server">Dependent Name:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblDependentName" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label18" runat="server">Date of Birth:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblDependentDateofBirth" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label19" runat="server">Gender:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblDependentGender" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="100%">
                                    <tr>
                                        <td colspan="3">
                                            <h2>
                                                Benefit Coverage</h2>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="48%">
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label20" runat="server">Plan Begin Date:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblPlanBeginDate" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label21" runat="server">Plan Type:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblPlanType" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </td>
                                        <td width="4%">
                                            &nbsp;
                                        </td>
                                        <td width="48%" valign="top">
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label22" runat="server">Benefit Status:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblBenefitStatus" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label23" runat="server">Network Status:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblNetworkStatus" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" align="center">
                                            <asp:Label ID="lblResDateTime" runat="server"></asp:Label><br />
                                            Professional (Physician) Visit - Office Services
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <table width="100%">
                                                <tr>
                                                    <td colspan="3">
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="10%">
                                                    </td>
                                                    <td class="lightgreen-40">
                                                        <table width="100%">
                                                            <tr>
                                                                <td colspan="2" align="center">
                                                                    In Network
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="40%" align="center">
                                                                    Individual
                                                                </td>
                                                                <td width="40%" align="center">
                                                                    Family
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td class="mistyrose-40">
                                                        <table width="100%">
                                                            <tr>
                                                                <td colspan="2" align="center">
                                                                    Out of Network
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td width="40%" align="center">
                                                                    Individual
                                                                </td>
                                                                <td width="40%" align="center">
                                                                    Family
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="10%">
                                                        Co-Payment<br />
                                                        Co-Insurance
                                                    </td>
                                                    <td class="lightgreen-40">
                                                        <table width="100%">
                                                            <tr>
                                                                <td width="40%" align="center">
                                                                    <%=Elig_Prof_CoPay_Ind_IN_Visit%>
                                                                    <br />
                                                                    <%=Elig_Prof_CoIns_Ind_IN_Visit%>
                                                                </td>
                                                                <td width="40%" align="center">
                                                                    -<br />
                                                                    -
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td class="mistyrose-40">
                                                        <table width="100%">
                                                            <tr>
                                                                <td width="40%" align="center">
                                                                    <%=Elig_Prof_CoPay_Ind_OoN_Visit%>
                                                                    <br />
                                                                    <%=Elig_Prof_CoIns_Ind_OoN_Visit%>
                                                                </td>
                                                                <td width="40%" align="center">
                                                                    -<br />
                                                                    -
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="10%">
                                                        Deductible<br />
                                                        Ded TD<br />
                                                        Ded Remain
                                                    </td>
                                                    <td class="lightgreen-40">
                                                        <table width="100%">
                                                            <tr>
                                                                <td width="40%" align="center">
                                                                    <%=Elig_HBP_Ded_Ind_IN_CY%>
                                                                    <br />
                                                                    <%=Elig_HBP_Ded_Ind_IN_YTD%>
                                                                    <br />
                                                                    <%=Elig_HBP_Ded_Ind_IN_Rem%>
                                                                </td>
                                                                <td width="40%" align="center">
                                                                    <%=Elig_HBP_Ded_Fam_IN_CY%>
                                                                    <br />
                                                                    <%=Elig_HBP_Ded_Fam_IN_YTD%>
                                                                    <br />
                                                                    <%=Elig_HBP_Ded_Fam_IN_Rem%>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td class="mistyrose-40">
                                                        <table width="100%">
                                                            <tr>
                                                                <td width="40%" align="center">
                                                                    <%=Elig_HBP_Ded_Ind_OoN_CY%>
                                                                    <br />
                                                                    <%=Elig_HBP_Ded_Ind_OoN_YTD%>
                                                                    <br />
                                                                    <%=Elig_HBP_Ded_Ind_OoN_Rem%>
                                                                </td>
                                                                <td width="40%" align="center">
                                                                    <%=Elig_HBP_Ded_Fam_OoN_CY%>
                                                                    <br />
                                                                    <%=Elig_HBP_Ded_Fam_OoN_YTD%>
                                                                    <br />
                                                                    <%=Elig_HBP_Ded_Fam_OoN_Rem%>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="10%">
                                                        Out of Pocket<br />
                                                        OOP YTD<br />
                                                        OOP Remain
                                                    </td>
                                                    <td class="lightgreen-40">
                                                        <table width="100%">
                                                            <tr>
                                                                <td width="40%" align="center">
                                                                    <%=Elig_HBP_OoP_Ind_IN_CY%>
                                                                    <br />
                                                                    <%=Elig_HBP_OoP_Ind_IN_YTD%>
                                                                    <br />
                                                                    <%=Elig_HBP_OoP_Ind_IN_Rem%>
                                                                </td>
                                                                <td width="40%" align="center">
                                                                    <%=Elig_HBP_OoP_Fam_IN_CY%>
                                                                    <br />
                                                                    <%=Elig_HBP_OoP_Fam_IN_YTD%>
                                                                    <br />
                                                                    <%=Elig_HBP_OoP_Fam_IN_Rem%>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td class="mistyrose-40">
                                                        <table width="100%">
                                                            <tr>
                                                                <td width="40%" align="center">
                                                                    <%=Elig_HBP_OoP_Ind_OoN_CY%>
                                                                    <br />
                                                                    <%=Elig_HBP_OoP_Ind_OoN_YTD%>
                                                                    <br />
                                                                    <%=Elig_HBP_OoP_Ind_OoN_Rem%>
                                                                </td>
                                                                <td width="40%" align="center">
                                                                    <%=Elig_HBP_OoP_Fam_OoN_CY%>
                                                                    <br />
                                                                    <%=Elig_HBP_OoP_Fam_OoN_YTD%>
                                                                    <br />
                                                                    <%=Elig_HBP_OoP_Fam_OoN_Rem%>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label24" runat="server">Plan Description:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox ID="txtPlanDescription" Rows="6" Columns="80" runat="server" TextMode="MultiLine">
                                                    </asp:TextBox>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width="100%">
                                    <tr>
                                        <td>
                                            <h2>
                                                Coverage Detail</h2>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <telerik:RadPanelBar runat="server" ID="panelCoverage" Height="300" Width="100%">
                                            </telerik:RadPanelBar>
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
    <script type="text/javascript" language="javascript">

        function printPopup() {

            var content = $get("tblEligibilityPopup").innerHTML;
            var pwin = window.open('', 'print_content', 'width=450,height=600');
            pwin.document.open();
            pwin.document.write('<html><body onload="window.print()">' + content + '</body></html>');
            pwin.document.close();
            setTimeout(function () { pwin.close(); }, 1000);
        }

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }

        function closePopup() {
            GetRadWindow().close();
        }

        function redirectEstimatePage() {
            GetRadWindow().BrowserWindow.redirectEstimatePage();
            GetRadWindow().close();
        }
        
    </script>
    </form>
</body>
</html>
