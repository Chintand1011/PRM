<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="preferences.aspx.cs"
    Inherits="preferences" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelConfiguartion" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Account Preferences</h1>
            </div>
            <div class="bodyMain">
                <h2>Manage preferences on this patients account through the options below. These will
                    affect changes immediately.</h2>
                <table width="100%">
                    <tr>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td width="50%" valign="top">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label1" runat="server">Suspend Account:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbSuspendAccount" runat="server" width="150px" emptymessage="Choose Suspended Account..."
                                        allowcustomtext="False" markfirstmatch="True" maxheight="200">
                                    </telerik:radcombobox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label8" runat="server">Reasone For Suspension:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtReasonForSuspention" MaxLength="200" TextMode="MultiLine" Width="350px"
                                        Height="90px" CssClass="textarea" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                &nbsp;
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label2" runat="server">Allow Web Access:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbAllowWebAccess" runat="server" width="150px" emptymessage="Choose Allow Web Access..."
                                        allowcustomtext="False" markfirstmatch="True" maxheight="200">
                                    </telerik:radcombobox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label3" runat="server">Ok To Leave Messages:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbOkToLeaveMessages" runat="server" width="150px" emptymessage="Choose Ok To Leave Messages..."
                                        allowcustomtext="False" markfirstmatch="True" maxheight="200">
                                    </telerik:radcombobox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label7" runat="server">Other Authorized Parties:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtOtherAuthorizedParties" runat="server" Width="350px"></asp:TextBox>
                                </div>
                            </div>
                        </td>
                        <td width="50%" valign="top">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label6" runat="server">Suspend Paper Billing:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbSuspendPaperBilling" autopostback="True" onselectedindexchanged="cmbSuspendPaperBilling_OnSelectedIndexChanged"
                                        runat="server" width="150px" emptymessage="Choose Suspend Paper Billing..." allowcustomtext="False"
                                        markfirstmatch="True" maxheight="200">
                                    </telerik:radcombobox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label10" runat="server">Email Address:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtEmailAddress" runat="server" Width="250px" ReadOnly="True"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rqdEmailAddress" Enabled="False" runat="server" ControlToValidate="txtEmailAddress"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Email Address is required."
                                        ValidationGroup="PatientPreference">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label11" runat="server">Expiration For Suspention:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:raddatepicker id="dtExipratioForSuspention" mindate="1/1/1900" runat="server"
                                        calendar-skin="Windows7" width="150" skin="Windows7" maxdate="12/31/2020">
                                    </telerik:raddatepicker>
                                </div>
                            </div>
                            <div class="form-row">
                                &nbsp;
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label4" runat="server">Signed Financials On File:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbSignedFinancialsOnFile" runat="server" width="150px"
                                        emptymessage="Choose Signed Financials On File..." allowcustomtext="False" markfirstmatch="True"
                                        maxheight="200">
                                    </telerik:radcombobox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label9" runat="server">Date Signed:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:raddatepicker id="dtDateOfFilling" mindate="1/1/1900" runat="server" calendar-skin="Windows7"
                                        width="150" skin="Windows7" maxdate="12/31/2020">
                                    </telerik:raddatepicker>
                                </div>
                            </div>
                            <div class="form-row">
                                &nbsp;
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label5" runat="server">Auto Assign BlueCredit:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbAutoAssignBlueCredit" runat="server" width="150px" emptymessage="Choose Auto Assign BlueCredit..."
                                        allowcustomtext="False" markfirstmatch="True" maxheight="200">
                                    </telerik:radcombobox>
                                    <br />
                                    Note: Automatically increases Patient credit as needed when
                                    <br />
                                    assigning new statements to an existing credit account
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right">
                            <asp:ImageButton ImageUrl="../Content/Images/btn_cancel.gif" OnClientClick="refreshPage()"
                                runat="server" CssClass="btn-cancel" />&nbsp; &nbsp; 
                            <asp:ImageButton ID="btnUpdate" ImageUrl="../Content/Images/btn_update.gif" runat="server"
                                OnClick="btnUpdate_Click" CssClass="btn-update" ValidationGroup="PatientPreference" Style="margin: 20px 120px 0 0;" />
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Statements"
                                ShowSummary="True" CssClass="failureNotification" HeaderText="Please fix the errors highlighted above." />
                        </td>
                    </tr>
                </table>
                <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                    modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    restrictionzoneid="divMainContent" skin="CareBlueInf" style="z-index: 3000">
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
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">

        function redirectToDashboard() {

        }

    </script>
</asp:Content>
