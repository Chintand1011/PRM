<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="eligibility.aspx.cs"
    Inherits="eligibility" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligibility" runat="server">
        <ContentTemplate>
            <%--<telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" >--%>
            <div class="hdrTitle">
                <h1>Eligibility (Ad-Hoc)</h1>
            </div>
            <div class="bodyMain">
                <h2>Description will be there...</h2>
                <table width="100%">
                    <tr>
                        <td width="49%">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Eligibility Payer:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbEligibilityPayer" runat="server" width="350px" emptymessage="Choose Payer..."
                                        allowcustomtext="False" markfirstmatch="True" datatextfield="CarrierName" datavaluefield="CarrierID"
                                        maxheight="200" onselectedindexchanged="cmbEligibilityPayer_SelectedIndexChanged"
                                        autopostback="True">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbEligibilityPayer"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Eligibility Payer is required."
                                        ErrorMessage="Eligibility Payer is required." ValidationGroup="EligibilityValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Payer Group:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPayerGroup" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Policy Type:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPolicyType" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                </div>
                            </div>
                        </td>
                        <td width="2%">&nbsp;
                        </td>
                        <td width="49%">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label1" runat="server" Text="Carrier Name:"></asp:Label>
                                </div>
                                <div class="editor-label">
                                    <asp:TextBox ID="txtCarrierName" runat="server" Enabled="False" Width="200px"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="EDI Required:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtEdiRequired" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Registered State:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtRegisteredState" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <hr />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Provider:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbProviders" runat="server" width="200" emptymessage="Choose Provider"
                                        allowcustomtext="False" markfirstmatch="True" datatextfield="ProviderAbbr" datavaluefield="ProviderID"
                                        maxheight="200" enabled="False" onselectedindexchanged="cmbProviders_SelectedIndexChanged"
                                        autopostback="True">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbProviders" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="Provider is required."
                                        ErrorMessage="Provider is required." ValidationGroup="EligibilityValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Provider ID:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPractice" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                </div>
                            </div>
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>
                            <div class="form-row">
                                <div class="editor-label">
                                    &nbsp;
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Schedule ID:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtProviderID" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <hr />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Subscriber:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbSubscriber" runat="server" width="200" emptymessage="Choose Subscriber or Enter Below..."
                                        allowcustomtext="False" markfirstmatch="True" datatextfield="PatientAbbr" datavaluefield="PatientID"
                                        maxheight="200" enabled="False" onselectedindexchanged="cmbSubscriber_SelectedIndexChanged"
                                        autopostback="True">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbSubscriber" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="Subscriber is required."
                                        ErrorMessage="Subscriber is required." ValidationGroup="EligibilityValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Last Name:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtLastName" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLastName" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="Last Name is required."
                                        ErrorMessage="Last Name is required." ValidationGroup="EligibilityValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="First Name:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtFirstName" runat="server" MaxLength="30"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Subscriber ID:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtSubscriberID" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtSubscriberID" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="Subscriber ID is required."
                                        ErrorMessage="Subscriber ID is required." ValidationGroup="EligibilityValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Group Number:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtGroupNumber" runat="server" MaxLength="30"></asp:TextBox>
                                </div>
                            </div>
                        </td>
                        <td>&nbsp;
                        </td>
                        <td>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Relation:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbRelation" runat="server" width="200" emptymessage="Choose Relation..."
                                        allowcustomtext="False" markfirstmatch="True" datatextfield="RelationAbbr" datavaluefield="RelTypeID"
                                        maxheight="200">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbRelation" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="Relation is required."
                                        ErrorMessage="Relation is required." ValidationGroup="EligibilityValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Gender:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbGender" runat="server" width="200" emptymessage="Choose Gender"
                                        allowcustomtext="False" markfirstmatch="True">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbGender" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="Gender is required."
                                        ErrorMessage="Gender is required." ValidationGroup="EligibilityValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Date of Birth:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:raddatepicker id="dtDateofBirth" mindate="1900/1/1" runat="server" cssclass="set-telerik-ctrl-width">
                                    </telerik:raddatepicker>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label2" runat="server" Text="Service Date:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:raddatepicker id="dtServiceDate" mindate="1900/1/1" runat="server" cssclass="set-telerik-ctrl-width">
                                    </telerik:raddatepicker>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="dtServiceDate" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="Service Date is required."
                                        ErrorMessage="Service Date is required." ValidationGroup="EligibilityValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <label>
                                        &nbsp;</label>
                                </div>
                                <div class="editor-field" style="padding-left: 8px;">
                                    <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="../Content/Images/btn_submit.gif"
                                         CssClass="btn-submit" OnClick="btnSubmit_Click"
                                        OnClientClick="showProgressBar()" />
                                    <%--<asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                                    PostBackUrl="ptsearch.aspx" onclick="btnCancel_Click" />--%>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    &nbsp;
                                </div>
                                <div class="editor-field">
                                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="EligibilityValidationGroup"
                                        ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                        CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="1100px" height="850px"
                    modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize" style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupEligibility" NavigateUrl="~/report/eligibility_popup.aspx"
                            DestroyOnClose="True">
                        </telerik:RadWindow>
                    </Windows>
                </telerik:radwindowmanager>
                <telerik:radwindowmanager id="radWindowDialog" showcontentduringload="True" visiblestatusbar="False"
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
                            <div style="margin-top: 20px; margin-left: 76px;">
                                <a href="#" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            </div>
                        </div>
                    </AlertTemplate>
                </telerik:radwindowmanager>

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script language="javascript" type="text/javascript">
        var isProgressShow = false;

        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endReq);


        function endReq() {
            //  hide progress Popup
            unBlockUI();

        }

        function showProgressBar() {

            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('EligibilityValidationGroup');
            }

            if (isPageValid) {
                blockUI();
            }
        }


        function redirectEstimatePage() {
            location.href = "<%=ClientSession.WebPathRootProvider %>" + "admin/estimate.aspx";
        }

    </script>
</asp:Content>
