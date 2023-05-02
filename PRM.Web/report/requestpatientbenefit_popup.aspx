<%@ Page Language="C#" AutoEventWireup="true" CodeFile="requestpatientbenefit_popup.aspx.cs"
    Inherits="requestpatientbenefit_popup" %>

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
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
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
                            <table width="100%">
                                <tr>
                                    <td colspan="3" align="center" width="100%">
                                        <h2>
                                            REQUEST PATIENT BENEFITS</h2>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3" align="center" width="100%">
                                        Eligibility for coverage will be submitted using the information on file as listed
                                        above. If this information is inaccurate, please update the patient record and resubmit
                                        the request for benefit information. Ad-hoc eligibility request may also be made
                                        through the administrative option.
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td width="49%">
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label1" runat="server" Text="Last Name:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtLastName" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label2" runat="server" Text="First Name:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtFirstName" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label3" runat="server" Text="Date of Birth:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:RadDatePicker ID="dtDateofBirth" Enabled="False" MinDate="1900/1/1" runat="server"
                                                    CssClass="set-telerik-ctrl-width">
                                                </telerik:RadDatePicker>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label4" runat="server" Text="Gender:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtGender" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label5" runat="server" Text="SSN:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtSSN" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                            </div>
                                        </div>
                                    </td>
                                    <td width="2%">
                                        &nbsp;
                                    </td>
                                    <td width="49%">
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label6" runat="server" Text="Carrier:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtCarrier" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label7" runat="server" Text="Provider:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtProvider" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label8" runat="server" Text="Subscriber ID:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtSubscriberID" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label9" runat="server" Text="Group Number:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtGroupNumber" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label10" runat="server" Text="Relationship:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtRelationship" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        &nbsp; &nbsp;
                                    </td>
                                    <td>
                                        <div class="success-message">
                                            <asp:Literal ID="litMessage" runat="server"></asp:Literal></div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div style="color: red; text-align: center; font-size: 13px;" id="divMessage" visible="False"
                                runat="server">
                                Please update the patient's Insurance information before submitting the eligibility
                                request.
                            </div>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <%--<asp:HiddenField ID="hdnServiceDate" runat="server" />--%>
                            <asp:HiddenField ID="hdnSubscriberIDCode" runat="server" />
                            <asp:HiddenField ID="hdnProviderIDCode" runat="server" />
                            <asp:HiddenField ID="hdnPayerID" runat="server" />
                            <asp:HiddenField ID="hdnPayerIDCode" runat="server" />
                            <asp:HiddenField ID="hdnRelationShipTypeID" runat="server" />
                            <asp:ImageButton ID="ImageButton1" OnClientClick="closePopup()" ImageUrl="../Content/Images/btn_cancel.gif"
                                CssClass="btn-pop-cancel" runat="server" />
                            <input type="image" src="../Content/Images/btn_edit.gif" onclick="redirect()" class="btn-largepop-edit" />
                            <asp:ImageButton ID="btnSubmit" ImageUrl="../Content/Images/btn_submit.gif" CssClass="btn-pop-submit"
                                runat="server" OnClick="btnSubmit_Click" OnClientClick="showProgress()" />
                        </td>
                    </tr>
                </table>
            </div>
            <telerik:RadWindowManager ID="RadWindow" ShowContentDuringLoad="True" VisibleStatusbar="False"
                VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="1100px" Height="850px"
                Modal="True" EnableShadow="False" EnableEmbeddedBaseStylesheet="False" EnableEmbeddedSkins="False"
                Skin="CareBlue" Behaviors="Pin,Reload,Close,Move,Resize" Style="z-index: 3000">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popupEligibility" NavigateUrl="~/report/eligibility_popup.aspx"
                        DestroyOnClose="True">
                    </telerik:RadWindow>
                </Windows>
            </telerik:RadWindowManager>
            <telerik:RadWindowManager ID="windowManager" ShowContentDuringLoad="True" VisibleStatusbar="False"
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
                            <a href="#" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:RadWindowManager>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript" language="javascript">

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
           
            GetRadWindow().BrowserWindow.unBlockUI();
        });

        function showProgress() {
            // shows progress Popup
            GetRadWindow().BrowserWindow.blockUI();
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

        function openEligibilityDetailPopup() {
            GetRadWindow().BrowserWindow.openEligibilityDetail();
        }

        function redirect() {
            GetRadWindow().BrowserWindow.redirectToInsurances();
            GetRadWindow().close();
        }
        
    </script>
    </form>
</body>
</html>
