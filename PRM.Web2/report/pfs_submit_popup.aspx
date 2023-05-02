<%@ Page Language="C#" AutoEventWireup="true" CodeFile="pfs_submit_popup.aspx.cs"
    Inherits="pfs_submit_popup" %>

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
        <telerik:radscriptmanager id="RadScriptManager1" runat="server">
        </telerik:radscriptmanager>
        <asp:UpdatePanel ID="updPanelEligility" runat="server">
            <ContentTemplate>
                <div>
                    <table class="CareBluePopup">
                        <tr>
                            <td>
                                <h2p>
                                Patient Financial Report
                            </h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>
                                Request Patient Credit Report
                            </h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad">
                                <div>
                                    <h2 align="center">Process Patient Financial Report</h2>
                                </div>
                                <table border="0">
                                    <tr>
                                        <td colspan="2">
                                            <div class="form-row">
                                                <div class="editor-label" style="margin-left: -90px;">
                                                    <input type="hidden" id="hdnIsEditProcess" runat="server" />
                                                    <input type="hidden" id="hdnIsShowCreditReportPopup" runat="server" />
                                                    <asp:Label ID="Label8" runat="server" Text="Borrower:"></asp:Label>
                                                </div>
                                                <div class="editor-field" style="margin-top: -3px;">
                                                    <telerik:radcombobox id="cmbIndividuals" autopostback="True" onselectedindexchanged="cmbIndividuals_OnSelectedIndexChanged"
                                                        runat="server" width="155px" emptymessage="Choose Borrrower..." maxheight="200"
                                                        allowcustomtext="False" markfirstmatch="True">
                                                    </telerik:radcombobox>
                                                </div>
                                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                                <asp:ImageButton ID="btnEditDetails" ImageUrl="../Content/Images/btn_edit.gif"
                                                    OnClick="btnEditDetails_Click" runat="server" />
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="45%" valign="top">
                                            <div class="form-row" id="divLoginStates" runat="server">
                                                <div class="editor-label" style="margin-left: -90px;">
                                                    <asp:Label ID="Label4" runat="server">First Name:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblFirstName" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row" id="div1" runat="server">
                                                <div class="editor-label" style="margin-left: -90px;">
                                                    <asp:Label ID="Label1" runat="server">Middle Name:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblMiddleName" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row" id="div2" runat="server">
                                                <div class="editor-label" style="margin-left: -90px;">
                                                    <asp:Label ID="Label2" runat="server">Last Name:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblLastName" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row" id="div3" runat="server">
                                                <div class="editor-label" style="margin-left: -90px;">
                                                    <asp:Label ID="Label3" runat="server">Date Of Birth:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblDOB" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row" id="div4" runat="server">
                                                <div class="editor-label" style="margin-left: -90px;">
                                                    <asp:Label ID="Label5" runat="server">Social Security:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblSocialSecurity" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row" id="div10" runat="server">
                                                <div class="editor-label" style="margin-left: -90px;">
                                                    <asp:Label ID="Label12" runat="server">*Stated Income:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radnumerictextbox Type="Currency" Width="115" id="txtIncone" Value="0" minvalue="0" maxvalue="999999" runat="server" ClientEvents-OnKeyPress="disableEnterKey"></telerik:radnumerictextbox>
                                                </div>
                                            </div>
                                        </td>
                                        <td valign="top">
                                            <div class="form-row" id="div5" runat="server">
                                                <div class="editor-label" style="margin-left: -100px;">
                                                    <asp:Label ID="Label7" runat="server">Address:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblAddress" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row" id="div6" runat="server">
                                                <div class="editor-label" style="margin-left: -100px;">
                                                    <asp:Label ID="Label9" runat="server">App/Suite:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblAppSuit" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row" id="div7" runat="server">
                                                <div class="editor-label" style="margin-left: -100px;">
                                                    <asp:Label ID="Label11" runat="server">City:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblCity" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row" id="div8" runat="server">
                                                <div class="editor-label" style="margin-left: -100px;">
                                                    <asp:Label ID="Label6" runat="server">State:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblState" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row" id="div9" runat="server">
                                                <div class="editor-label" style="margin-left: -100px;">
                                                    <asp:Label ID="Label10" runat="server">Zip Code:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:Label ID="lblZipCode" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                            <div class="form-row" id="div11" runat="server">
                                                <div class="editor-label" style="margin-left: -100px;">
                                                    <asp:Label ID="Label13" runat="server">Housing:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radcombobox id="cmbHousingType"  DataTextField="Text" DataValueField="Value"
                                                        runat="server" width="155px" emptymessage="Choose Housing..." maxheight="200"
                                                        allowcustomtext="False" markfirstmatch="True">
                                                    </telerik:radcombobox>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="editor-field" style="margin-left: 10px;">
                                    *Stated income is not mandatory but assists in credit worthiness. Alimony, child support or other maintenance income need not be included unless relied upon for credit.
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <a href="javascript:;" onclick="closePopup()">
                                    <img src="../Content/Images/btn_close.gif" class="btn-pop-cancel" alt="Close" /></a>
                                <asp:ImageButton ID="btnProcess" ImageUrl="../Content/Images/btn_submit.gif" CssClass="btn-pop-submit"
                                    OnClientClick="showProgressPopup()" OnClick="btnProcess_click" runat="server" />
                                <asp:HiddenField ID="hdnIsError" runat="server" />
                            </td>
                        </tr>
                    </table>
                </div>
                <telerik:radwindowmanager id="windowManager" behaviors="Move" style="z-index: 200001"
                    showcontentduringload="False" visiblestatusbar="False" visibletitlebar="True"
                    reloadonshow="True" runat="Server" modal="True" enableembeddedbasestylesheet="True"
                    enableembeddedskins="False" skin="CareBlueInf">
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
                </telerik:radwindowmanager>
            </ContentTemplate>
        </asp:UpdatePanel>
        <script type="text/javascript" language="javascript">

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {
                
                var isEditProcess = $("#<%=hdnIsEditProcess.ClientID %>").val();
                if (isEditProcess == "True") redirectToManagePatient();

                //For Show Credit Reports
                showCreditReports();
                
                GetRadWindow().BrowserWindow.unBlockUI();
            });

            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
                else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

                return oWindow;
            }

            function redirectToManagePatient() {
                GetRadWindow().BrowserWindow.redirectManagePatient();
                GetRadWindow().close();
            }


            function closePopup() {
                GetRadWindow().BrowserWindow.reloadPage();
                GetRadWindow().close();
            }

            function showCreditReportPopup() {
                GetRadWindow().BrowserWindow.ShowCreditReportPopup();
                GetRadWindow().close();
            }

            function showCreditReports() {
                var isShowCreditReport = $("#<%=hdnIsShowCreditReportPopup.ClientID %>").val();
                if (isShowCreditReport == "True") showCreditReportPopup();
            }

            function showProgressPopup() {
                GetRadWindow().BrowserWindow.blockUI();
            }


        function refreshPage() {

            if ($("#<%=hdnIsError.ClientID %>").val() == "1") {
                location.href = location.href;
                return;
            }

            GetRadWindow().BrowserWindow.refreshPage();
            closePopup();
        }
        
            function disableEnterKey(sender, args) {
                if (args.get_keyCode() == '13')
                    args.set_cancel(true);
            }
        </script>
    </form>
</body>
</html>
