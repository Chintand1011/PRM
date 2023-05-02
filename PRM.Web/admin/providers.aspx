<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="providers.aspx.cs"
    Inherits="admin_providers" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligibility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Practice Providers</h1>
            </div>
            <div class="bodyMain">
                <h2>Manage practice providers and details. Note that providers may not be deleted, but they may be made inactive.</h2>
                <table width="100%">
                    <tr>
                        <td width="35%"></td>
                        <td width="5%"></td>
                        <td width="60%"></td>
                    </tr>
                    <asp:Panel ID="pnlExistingProvider" runat="server">
                        <tr>
                            <td colspan="3">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Existing Provider:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbExistingProvider" runat="server" Width="200px" EmptyMessage="Choose Provider..."
                                            AllowCustomText="False" MarkFirstMatch="True" AutoPostBack="True" DataTextField="ProviderAbbr"
                                            DataValueField="ProviderID" MaxHeight="200" OnSelectedIndexChanged="cmbExistingProvider_SelectedIndexChanged">
                                        </telerik:RadComboBox>
                                    </div>
                                    <div class="editor-field" runat="server" id="divRunNew">
                                        &nbsp; &nbsp; or &nbsp; &nbsp;<asp:ImageButton CssClass="btn-new" ID="btnNew" runat="server" ImageUrl="../Content/Images/btn_new.gif"
                                            OnClick="btnNew_Click" />
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </asp:Panel>
                    <h3 id="hTitle" runat="server" visible="False" class="bolder">Add New Provider
                    </h3>
                    <asp:Panel ID="pnlProviderInformation" runat="server" Visible="False">
                        <tr>
                            <td colspan="3">
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Primary Location:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbPrimaryLocations" runat="server" Width="200px" EmptyMessage="Choose Primary Location..."
                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="LocationID"
                                            MaxHeight="200">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbPrimaryLocations"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Primary Location is required."
                                            ErrorMessage="Primary Location is required" ValidationGroup="ProviderValidationGroup">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Place of Service:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbServicePlaces" runat="server" Width="300px" EmptyMessage="Choose Default Service..."
                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="PlaceAbbr" DataValueField="PlaceofServiceTypeID"
                                            MaxHeight="200">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbServicePlaces" Display="Dynamic"
                                            ErrorMessage="Place of Service is required" SetFocusOnError="True" CssClass="failureNotification"
                                            ToolTip="Place of Service is required." ValidationGroup="ProviderValidationGroup">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Service Class:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbServiceClass" runat="server" Width="200px" EmptyMessage="Choose Default Class..."
                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="ServiceAbbr" DataValueField="ServiceClassTypeID"
                                            MaxHeight="200">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="cmbServiceClass"
                                            ErrorMessage="Service Class is required" Display="Dynamic" SetFocusOnError="True"
                                            CssClass="failureNotification" ToolTip="Service Class is required." ValidationGroup="ProviderValidationGroup">*</asp:RequiredFieldValidator>
                                    </div>

                                    <div id="divDisplayName" style="float: right;">
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server">Display Name:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:TextBox ID="txtDisplayName" runat="server" Enabled="False"></asp:TextBox>
                                            </div>
                                        </div>
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
                            <td width="35%">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Status:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbStatus" runat="server" Width="200px" EmptyMessage="Choose Status..."
                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="StatusTypeID"
                                            MaxHeight="200">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbStatus" Display="Dynamic"
                                            ErrorMessage="Status is required" SetFocusOnError="True" CssClass="failureNotification"
                                            ToolTip="Status is required." ValidationGroup="ProviderValidationGroup">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">First Name:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtFirstName" runat="server" onkeydown="showDisplayName()"></asp:TextBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFirstName" Display="Dynamic"
                                            ErrorMessage="First Name is required" SetFocusOnError="True" CssClass="failureNotification"
                                            ToolTip="First Name is required." ValidationGroup="ProviderValidationGroup">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Middle Name:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtMiddleName" runat="server" onkeydown="showDisplayName()"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Last Name:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtLastName" runat="server" onkeydown="showDisplayName()"></asp:TextBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLastName" Display="Dynamic"
                                            ErrorMessage="Last Name is required" SetFocusOnError="True" CssClass="failureNotification"
                                            ToolTip="Last Name is required." ValidationGroup="ProviderValidationGroup">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Degree Type:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbDegreeType" runat="server" Width="200px" EmptyMessage="Choose Degree..."
                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="ProviderTypeID"
                                            MaxHeight="200">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbDegreeType" Display="Dynamic"
                                            ErrorMessage="Degree Type is required" SetFocusOnError="True" CssClass="failureNotification"
                                            ToolTip="Degree Type is required." ValidationGroup="ProviderValidationGroup">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">NPI Number:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadMaskedTextBox ID="txtNPINumber" runat="server" Mask="##########" Width="155"
                                            ValidationGroup="ProviderValidationGroup">
                                        </telerik:RadMaskedTextBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNPINumber" Display="Dynamic"
                                            ErrorMessage="NPI Number is required" SetFocusOnError="True" CssClass="failureNotification"
                                            ToolTip="NPI Number is required." ValidationGroup="ProviderValidationGroup">*</asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator Display="Dynamic" runat="server" ControlToValidate="txtNPINumber"
                                            ToolTip="Invalid NPI Number." SetFocusOnError="True" CssClass="failureNotification"
                                            ErrorMessage="Invalid NPI Number." ValidationGroup="ProviderValidationGroup"
                                            ValidationExpression="\d{10}">*</asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">CMS Multiplier:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadNumericTextBox runat="server" ID="txtCMSMultiplier" Type="Number" NumberFormat-DecimalDigits="2"
                                            NumberFormat-GroupSeparator=",">
                                        </telerik:RadNumericTextBox>
                                        <img src="../Content/Images/icon_help.png" alt="help" title="This multiplier is used to calculate procedure cost when the provider does not have a specific fee schedule covering the CPT line item on an estimate. The default is 1.50." />
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtCMSMultiplier"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="CMS Multiplier is required."
                                            ErrorMessage="CMS Multiplier is required." ValidationGroup="ProviderValidationGroup">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                            </td>
                            <td width="5%">&nbsp;
                            </td>
                            <td valign="top" width="60%">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Notes:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtNotes" Rows="6" Columns="40" runat="server" TextMode="MultiLine">
                                        </asp:TextBox>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"></td>
                            <td align="left">
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                <asp:ImageButton ID="btnCancel" ImageUrl="../Content/Images/btn_cancel.gif" CssClass="btn-cancel" runat="server" OnClick="btnCancel_Click" />
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                <asp:ImageButton ID="btnSubmit" ImageUrl="../Content/Images/btn_submit.gif" runat="server" OnClick="btnSubmit_Click" CssClass="btn-submit" OnClientClick="return enableDisableButton(this);" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2"></td>
                            <td>
                                <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="ProviderValidationGroup"
                                    ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                    CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                                <div id="divSuccessMessage" class="success-message" style="text-align: center">
                                    <asp:Literal ID="litPaymentConfirmationMessage" Text="" runat="server"></asp:Literal>
                                </div>
                            </td>
                        </tr>
                    </asp:Panel>
                </table>
                <telerik:RadWindowManager ID="RadWindow" ShowContentDuringLoad="True" VisibleStatusbar="False"
                    VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="700px" Height="500px"
                    Modal="True" EnableEmbeddedBaseStylesheet="False" EnableEmbeddedSkins="False"
                    RestrictionZoneID="divMainContent" Skin="CareBlueInf" Style="z-index: 3000">
                    <Windows>
                    </Windows>
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
                <telerik:RadWindow runat="server" ID="popupCreditSearch" NavigateUrl="~/report/carrierSearch_popup.aspx"
                    DestroyOnClose="True" ShowContentDuringLoad="True" VisibleStatusbar="False" VisibleTitlebar="True"
                    ReloadOnShow="True" Width="700px" Height="500px" Modal="True" EnableEmbeddedBaseStylesheet="False"
                    Behaviors="Pin,Reload,Close,Move,Resize" EnableEmbeddedSkins="False" RestrictionZoneID="divMainContent"
                    Skin="CareBlue" Style="z-index: 3000">
                </telerik:RadWindow>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {

            $(function () {
                addCcsRulesAccordingToBrowsers();
            });
        });

        $(document).ready(function () {
            addCcsRulesAccordingToBrowsers();
        });

        function addCcsRulesAccordingToBrowsers() {
            var browserName = '<%=Request.Browser.Browser%>';
            var obj = $("#divDisplayName");

            if (browserName == "Chrome") {
                obj.css("margin-right", "347px");
            } else if (browserName == "Firefox") {
                obj.css("margin-right", "357px");
            } else {
                obj.css("margin-right", "352px");
            }
        }

        function showDisplayName() {
            var firstName = $("#<%=txtFirstName.ClientID %>").val();
            var middleName = $("#<%=txtMiddleName.ClientID %>").val();
            var lastName = $("#<%=txtLastName.ClientID %>").val();

            var displayName = $("#<%=txtDisplayName.ClientID %>");
            displayName.val(lastName + ", " + firstName + " " + middleName);
        }

        function enableDisableButton(obj) {
            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('ProviderValidationGroup');
            }
            if (isPageValid) {
                var combobox = $find("<%=cmbExistingProvider.ClientID %>");
                var selectedValue = combobox == null ? 0 : combobox.get_value();
                obj.disabled = 'disabled';
                obj.src = selectedValue == 0 ? "../Content/Images/btn_submit_fade.gif" : "../Content/Images/btn_update_fade.gif";
                <%= ClientScript.GetPostBackEventReference(btnSubmit, string.Empty) %>;
                return false;
            }

        }


    </script>
</asp:Content>