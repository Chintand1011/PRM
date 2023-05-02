<%@ Page Language="C#" AutoEventWireup="true" CodeFile="importFeeSchedules_popup.aspx.cs"
    Inherits="importFeeSchedules_popup" %>

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
                       Import Fee Schedule
                                        </h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>
                                            Description need to be add
                                        </h4p>
                            </td>
                        </tr>
                        <tr>
                            <td class="ExtraPad" width="50%">
                                <div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label6" runat="server">&nbsp;</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radasyncupload runat="server" id="rauExcel" maxfileinputscount="1"
                                                maxfilesize="5242880" multiplefileselection="Disabled" allowedfileextensions=".xls,.xlsx" />
                                            <asp:CheckBox ID="chkHeaders" runat="server" />
                                            Check this, if file contains header. &nbsp;  
                                            <img src="../Content/Images/icon_help.png" alt="help" title="Select this option if your excel file contains header, if not then you can leave this. If you choose this option and your excel file don't have any header then system will mark your file as corrupted." />
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td width="50%">
                                <asp:ImageButton ID="btnSubmit" OnClientClick="showLoadingPopup();" OnClick="btnSubmit_OnClick" ImageUrl="../Content/Images/btn_submit.gif" runat="server" />
                                <asp:ImageButton ID="btnCancel" ImageUrl="../Content/Images/btn_cancel.gif" OnClientClick="closePopup(); return false;" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div runat="server" id="divInvalidRecords" visible="False">

                                    <h2><%=TotalSuccessfulRecords %> <%= TotalSuccessfulRecords > 1 ? "rows" : "row" %> have been successfully processed.</h2>

                                    <div style="color: red">
                                        The following entries have not been processed - please correct any errors and resubmit. You may also use the Manage Fee Schedule tool to add these codes individually.
                                    </div>
                                    <br />
                                    <br />
                                    <telerik:radgrid id="grdInvalidRecords" runat="server" allowsorting="True" allowpaging="True"
                                        pagesize="20">
                                        <MasterTableView AutoGenerateColumns="False">
                                            <Columns>
                                                <telerik:GridBoundColumn HeaderText="CPT Code" DataField="CPTCode">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Category" DataField="Category">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="CPT Name" DataField="CPTName">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Provider Charge" DataField="ProviderCharge$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Allowable" DataField="Allowable$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Service Type" DataField="ServiceTypeCode">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="CPT Type" DataField="CPTType">
                                                </telerik:GridBoundColumn>
                                                </Columns>
                                        </MasterTableView>
                                    </telerik:radgrid>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>

                <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="1100px" height="850px"
                    modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    skin="CareBlueInf">
                    <ConfirmTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div>
                                <div style="margin-top: 15px; margin-left: 55px;">
                                <a href="Javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_yes_small.gif" alt="Yes" /></a>   &nbsp; &nbsp;
                                  <a href="javascript:;" onclick="$find('{0}').close(false);">
                                        <img src="../Content/Images/btn_no_small.gif" alt="No" /></a>
                                </div>
                            </div>
                        </div>
                    </ConfirmTemplate>
                    <AlertTemplate>
                        <div class="rwDialogPopup radalert">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div style="margin-top: 20px; margin-left: 51px;">
                                <a href="#" onclick="$find('{0}').close(true);">
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
                GetRadWindow().BrowserWindowunBlockUI();

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

            function reloadPage() {
                GetRadWindow().BrowserWindow.refreshPage();
                closePopup();
            }

            function showLoadingPopup() {
                GetRadWindow().BrowserWindow.blockUI();
            }




        </script>

    </form>
</body>
</html>
