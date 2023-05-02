<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="carriers.aspx.cs"
    Inherits="carriers" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelCarrier" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Practice Management/Carriers</h1>
            </div>
            <div class="bodyMain">
                <h2>Manage carriers which have contracted with the practice or individual providers. Note that global carriers may not be modified.</h2>
                <table width="100%">
                    <asp:Panel ID="pnlExistingCarrier" runat="server">
                        <tr>
                            <td colspan="2">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label1" runat="server">Existing Carrier:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbExistingCarriers" runat="server" Width="400px" EmptyMessage="Choose Carrier..."
                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="CarrierName" DataValueField="CarrierID"
                                            MaxHeight="200" AutoPostBack="True" OnSelectedIndexChanged="cmbExistingCarriers_SelectedIndexChanged">
                                        </telerik:RadComboBox>
                                    </div>
                                    <div id="divTopButtons" runat="server">
                                        <div class="editor-field">
                                            &nbsp; &nbsp; or &nbsp; &nbsp;
                                            <%--<asp:Button ID="btnSearch" Text="Search" runat="server" />--%>
                                            <asp:ImageButton ID="btnSearch" CssClass="btn-search" ImageUrl="../Content/Images/btn_search.gif"
                                                OnClick="btnSearch_OnClick" runat="server" />
                                        </div>
                                        <div class="editor-field">
                                            &nbsp; &nbsp; or &nbsp; &nbsp;
                                            <asp:ImageButton CssClass="btn-new" ID="btnNew" ImageUrl="../Content/Images/btn_new.gif"
                                                runat="server" OnClick="btnNew_Click" />
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </asp:Panel>
                    <h3 id="hTitle" runat="server" visible="False" class="bolder">Add New Carrier</h3>
                    <asp:Panel ID="pnlCarrierInfo" runat="server" Visible="False">
                        <tr>
                            <td colspan="2">
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <td width="50%" valign="top">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label2" runat="server">Carrier Name:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtCarrierName" runat="server" MaxLength="50"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtCarrierName"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Carrier Name is required."
                                            ErrorMessage="Carrier Name is required." ValidationGroup="CarrierInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label3" runat="server">Policy Type:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbPolicyTypes" runat="server" Width="200px" EmptyMessage="Choose Type..."
                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="CarrierTypeID"
                                            MaxHeight="200">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbPolicyTypes" Display="Dynamic"
                                            SetFocusOnError="True" CssClass="failureNotification" ToolTip="Policy Type is required."
                                            ErrorMessage="Policy Type is required." ValidationGroup="CarrierInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label4" runat="server">Primary State:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbPrimaryStates" runat="server" Width="200px" EmptyMessage="Choose State..."
                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Name" DataValueField="StateTypeID"
                                            MaxHeight="200">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="cmbPrimaryStates"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Primary State is required."
                                            ErrorMessage="Primary State is required." ValidationGroup="CarrierInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label5" runat="server">Display Name:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtDisplayName" runat="server" MaxLength="50"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtDisplayName"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Display Name is required."
                                            ErrorMessage="Display Name is required." ValidationGroup="CarrierInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label6" runat="server">Payer ID:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtPayerID" runat="server" MaxLength="50"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label7" runat="server">Claim Office ID:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtClaimOfficeID" runat="server" MaxLength="50"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label8" runat="server">NAICS Code:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtNaicsCode" runat="server" MaxLength="50"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label9" runat="server">TaxPayer ID:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadMaskedTextBox ID="txtTaxPayerID" runat="server" Mask="##-#######" Width="155"
                                            EmptyMessage="TaxPayer ID" ValidationGroup="ProviderValidationGroup">
                                        </telerik:RadMaskedTextBox>
                                        <asp:CustomValidator runat="server" ControlToValidate="txtTaxPayerID"
                                            ClientValidationFunction="validateTaxPayerID" Display="Dynamic" SetFocusOnError="True"
                                            CssClass="failureNotification" ToolTip="Invalid TaxPayerID." ErrorMessage="Invalid TaxPayerID."
                                            ValidationGroup="CarrierInfo">*</asp:CustomValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label10" runat="server">Notes:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtNotes" TextMode="MultiLine" Width="350px" Height="90px" CssClass="textarea"
                                            MaxLength="500" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </td>
                            <td width="50%" valign="top">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label11" runat="server">Carrier Status:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbCarrierStatus" runat="server" Width="200px" EmptyMessage="Choose Status..."
                                            AllowCustomText="False" MarkFirstMatch="True" MaxHeight="200">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="cmbCarrierStatus"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Carrier Status is required."
                                            ErrorMessage="Carrier Status is required." ValidationGroup="CarrierInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label12" runat="server">Auth Phone:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtAuthPhone" runat="server" MaxLength="20"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label13" runat="server">Elig Phone:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtEligPhone" runat="server" MaxLength="20"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label14" runat="server">Fax Number:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtFaxNumber" runat="server" MaxLength="20"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label15" runat="server">Street 1:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtStreet1" runat="server" MaxLength="50"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label16" runat="server">Street 2:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtStreet2" runat="server" MaxLength="50"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label17" runat="server">City:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtCity" runat="server" MaxLength="50"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label18" runat="server">State:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbStates" runat="server" Width="200px" EmptyMessage="Choose State..."
                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Name" DataValueField="StateTypeID"
                                            MaxHeight="200">
                                        </telerik:RadComboBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label19" runat="server" Text="Zip Code +4:"></asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtPrimaryZipCode1" runat="server" CssClass="zip-code1" MaxLength="5"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtPrimaryZipCode1"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                            ToolTip="Invalid Zip Code 1" ErrorMessage="Invalid Zip Code 1" ValidationGroup="CarrierInfo">*</asp:RegularExpressionValidator>
                                    </div>
                                    <div class="editor-field">
                                        <asp:Label ID="Label20" runat="server" Text="-"></asp:Label>
                                        <asp:TextBox ID="txtPrimaryZipCode2" runat="server" CssClass="zip-code2" MaxLength="4"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtPrimaryZipCode2"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{4}$"
                                            ToolTip="Invalid Zip Code 2" ErrorMessage="Invalid Zip Code 2" ValidationGroup="CarrierInfo">*</asp:RegularExpressionValidator>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td align="left">
                                <div id="divUpdateCancelbuttons" runat="server">
                                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
                                    <asp:ImageButton ImageUrl="../Content/Images/btn_cancel.gif" CssClass="btn-cancel" OnClientClick="refreshPage()" runat="server" />
                                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
                                    <asp:ImageButton ID="btnSubmit" ImageUrl="../Content/Images/btn_submit.gif" Text="Submit" CssClass="btn-submit" runat="server" ValidationGroup="CarrierInfo" OnClick="btnSubmit_Click" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="CarrierInfo"
                                    ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                    CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                                <div id="divSuccessMessage" class="success-message" style="text-align: right">
                                    <asp:Literal ID="litMessage" Text="" runat="server"></asp:Literal>
                                </div>
                            </td>
                        </tr>
                    </asp:Panel>
                </table>
                <telerik:RadWindowManager ID="RadWindow" ShowContentDuringLoad="True" VisibleStatusbar="False"
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
                <telerik:RadWindow runat="server" ID="popupCreditSearch" NavigateUrl="~/report/carrierSearch_popup.aspx"
                    DestroyOnClose="True" ShowContentDuringLoad="True" VisibleStatusbar="False" VisibleTitlebar="True"
                    ReloadOnShow="True" Width="700px" Height="500px" Modal="True" EnableEmbeddedBaseStylesheet="False"
                    EnableEmbeddedSkins="False" RestrictionZoneID="divMainContent" Skin="CareBlue" Behaviors="Pin,Reload,Close,Move,Resize"
                    Style="z-index: 3000">
                </telerik:RadWindow>
                <div runat="server" id="divIndividualPractice" visible="False">
                    <asp:Label ID="lblIndividualPractices" Style="font-size: 14px; float: left; margin-left: 150px;"
                        ForeColor="red" runat="server">Global Carriers may not be modified by individual practices</asp:Label>
                    &nbsp; &nbsp; &nbsp; 
                    <a href="#" onclick="refreshPage()">
                        <img src="../Content/Images/btn_close.gif" alt="Ok" style="float: right; margin-right: 350px;" class="btn-ok" /></a>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>    
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">
        function validateTaxPayerID(events, args) {
            var taxPayerIdLength = args.Value.length - 1;
            if (taxPayerIdLength == 9) {
                args.IsValid = true;
                return;
            }
            args.IsValid = false;
        }
    </script>
</asp:Content>
