<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="locations.aspx.cs"
    Inherits="locations" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updatePanelLocations" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Locations</h1>
            </div>
            <div class="bodyMain">
                <h2>Manage practice locations and details. Note that locations may not be deleted, but they may be made inactive.</h2>
                <table width="100%">
                    <tr>
                        <td width="35%"></td>
                        <td width="5%"></td>
                        <td width="60%"></td>
                    </tr>
                    <asp:Panel ID="pnlLocations" runat="server">
                        <tr>
                            <td colspan="3">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Locations:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbLocations" runat="server" Width="300px" EmptyMessage="Choose Location..."
                                            AllowCustomText="False" MarkFirstMatch="True" AutoPostBack="True" DataTextField="Abbr"
                                            DataValueField="LocationID" MaxHeight="200" OnSelectedIndexChanged="cmbLocations_SelectedIndexChanged">
                                        </telerik:RadComboBox>
                                    </div>
                                    <div class="editor-field" runat="server" id="divNew">
                                        &nbsp;or &nbsp;<asp:ImageButton ID="btnNew" runat="server" ImageUrl="../Content/Images/btn_new.gif"
                                            OnClick="btnNew_Click" />
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </asp:Panel>
                    <h3 id="hTitle" runat="server" visible="False" class="bolder">Add New Location.
                    </h3>
                    <asp:Panel ID="pnlProviderInformation" runat="server" Visible="False">
                        <tr>
                            <td colspan="3">
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <%-- <td colspan="3">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server">Primary Location:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbPrimaryLocations" runat="server" Width="200px" EmptyMessage="Choose Primary Location..."
                                        AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="LocationID"
                                        MaxHeight="200">
                                    </telerik:RadComboBox>
                                </div>
                            </div>
                        </td>--%>
                        </tr>
                        <tr>
                            <td colspan="3"></td>
                        </tr>
                        <tr>
                            <td width="35%">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label3" runat="server">Location Status:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbStatus" runat="server" Width="200px" EmptyMessage="Choose Status..."
                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="StatusTypeID"
                                            MaxHeight="200">
                                        </telerik:RadComboBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="cmbStatus"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Status is required."
                                            ErrorMessage="Status is required." ValidationGroup="Locations">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Location Name:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtLocationName" runat="server"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtLocationName"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Location Name is required."
                                            ErrorMessage="Location Name is required." ValidationGroup="Locations">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Name Abbreviation:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtNameAbbreviation" runat="server"></asp:TextBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNameAbbreviation"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Name Abbreviation is required."
                                            ErrorMessage="Name Abbreviation is required." ValidationGroup="Locations">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Office Manager:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtOfficeManager" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Address 1:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtAddress1" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Address 2:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtAddress2" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label1" runat="server">City:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtCity" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label2" runat="server">State:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadComboBox ID="cmbStates" runat="server" Width="200px" EmptyMessage="Choose Status..."
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
                                        <asp:TextBox ID="txtZipCode1" runat="server" CssClass="zip-code1" MaxLength="5"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtZipCode1"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                            ToolTip="Invalid Zip Code 1" ErrorMessage="Invalid Zip Code 1" ValidationGroup="Locations">*</asp:RegularExpressionValidator>
                                    </div>
                                    <div class="editor-field">
                                        <asp:Label ID="Label20" runat="server" Text="-"></asp:Label>
                                        <asp:TextBox ID="txtZipCode2" runat="server" CssClass="zip-code2" MaxLength="4"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtZipCode2"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{4}$"
                                            ToolTip="Invalid Zip Code 2" ErrorMessage="Invalid Zip Code 2" ValidationGroup="Locations">*</asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label4" runat="server" Text="Phone Primary:"></asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadMaskedTextBox ID="txtPhonePrimary" runat="server" Mask="(###) ###-####"
                                            Width="149">
                                        </telerik:RadMaskedTextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator3" Display="Dynamic"
                                            runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                                            SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtPhonePrimary"
                                            ValidationGroup="Locations" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label11" runat="server" Text="Phone Secondary:"></asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadMaskedTextBox ID="txtPhoneSecondary" runat="server" Mask="(###) ###-####"
                                            Width="149">
                                        </telerik:RadMaskedTextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator4" Display="Dynamic"
                                            runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                                            SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtPhoneSecondary"
                                            ValidationGroup="Locations" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label5" runat="server">Fax Number:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:RadMaskedTextBox ID="txtFaxNumber" runat="server" Mask="(###) ###-####"
                                            Width="149">
                                        </telerik:RadMaskedTextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator5" Display="Dynamic"
                                            runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                                            SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtFaxNumber"
                                            ValidationGroup="Locations" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label6" runat="server">Primary location:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:CheckBox ID="chkPrimaryLocation" runat="server" />
                                    </div>
                                </div>
                            </td>
                            <td width="5%">&nbsp;
                            </td>
                            <td valign="top" width="60%">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Internal Notes:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtNotes" CssClass="textarea" Rows="6" Columns="40" runat="server"
                                            TextMode="MultiLine">
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
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Locations"
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
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
     <script type="text/javascript" language="javascript">

         function enableDisableButton(obj) {
             var isPageValid = false;

             if (typeof (Page_ClientValidate) == 'function') {
                 isPageValid = Page_ClientValidate('Locations');
             }
             if (isPageValid) {
                 var combobox = $find("<%=cmbLocations.ClientID %>");
                var selectedValue = combobox == null ? 0 : combobox.get_value();
                obj.disabled = 'disabled';
                obj.src = selectedValue == 0 ? "../Content/Images/btn_submit_fade.gif" : "../Content/Images/btn_update_fade.gif";
                <%= ClientScript.GetPostBackEventReference(btnSubmit, string.Empty) %>;
                return false;
            }

        }

    </script>
</asp:Content>