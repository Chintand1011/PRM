<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="statements.aspx.cs"
    Inherits="statements" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelConfiguartion" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Update Statements</h1>
            </div>
            <div class="bodyMain">
                <h2>Modify practice address, contact information and messages which are set on patient statements.</h2>
                <table width="100%">
                    <tr>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td width="50%" valign="top">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label2" runat="server">Logo Name:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtLogoName" MaxLength="250" Width="194" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtLogoName"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Logo Name is required."
                                        ErrorMessage="Logo Name is required." ValidationGroup="Statements">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label3" runat="server">Height * Width:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtHeight" Width="58px" runat="server"></asp:TextBox>
                                    <asp:RangeValidator ID="RangeValidator1" ControlToValidate="txtHeight" Display="Dynamic"
                                        Type="Integer" ToolTip="Height should between 40 to 80" ErrorMessage="Height should between 40 to 80"
                                        SetFocusOnError="True" MinimumValue="40" MaximumValue="80" ValidationGroup="Statements"
                                        CssClass="failureNotification" runat="server">*</asp:RangeValidator>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtHeight"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Height is required."
                                        ErrorMessage="Height is required." ValidationGroup="Statements">*</asp:RequiredFieldValidator>
                                    *
                                    <asp:TextBox ID="txtWidth" Width="58px" runat="server"></asp:TextBox>
                                    <asp:RangeValidator ID="RangeValidator2" ControlToValidate="txtWidth" Display="Dynamic"
                                        Type="Integer" ToolTip="Width should between 40 to 400" ErrorMessage="Width should between 40 to 400"
                                        SetFocusOnError="True" MinimumValue="40" MaximumValue="400" ValidationGroup="Statements"
                                        CssClass="failureNotification" runat="server">*</asp:RangeValidator>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtWidth"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Width is required."
                                        ErrorMessage="Width is required." ValidationGroup="Statements">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label1" runat="server">Logo Left Placement:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbLogoLeftPlacement" runat="server" Width="200px" EmptyMessage="Choose Logo Left Placement..."
                                        AllowCustomText="False" MarkFirstMatch="True" MaxHeight="200">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbLogoLeftPlacement"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Logo Placement is required."
                                        ErrorMessage="Logo Placement is required." ValidationGroup="Statements">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label15" runat="server">Street Address:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtAddress1" MaxLength="50" Width="194" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtAddress1"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Street Address is required."
                                        ErrorMessage="Street Address is required." ValidationGroup="Statements">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label16" runat="server">Building or Suite:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtAddress2" MaxLength="50" Width="194" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label5" runat="server">City, State:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtAddress3" MaxLength="50" Width="194" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtAddress3"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="City, State is required."
                                        ErrorMessage="City, State is required." ValidationGroup="Statements">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label21" runat="server">Zip Code:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtAddress4" MaxLength="50" Width="194" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtAddress4"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Zip Code is required."
                                        ErrorMessage="Zip Code is required." ValidationGroup="Statements">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label17" runat="server">Check Payable To:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtCheckPayableTo" MaxLength="30" Width="194" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtCheckPayableTo"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Check Payable To is required."
                                        ErrorMessage="Check Payable To is required." ValidationGroup="Statements">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label10" runat="server">Invoice Payment Text:<br /><i>(top of statement)</i></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtInvoicePaymentNote" MaxLength="200" TextMode="MultiLine" Width="350px"
                                        Height="90px" CssClass="textarea" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtInvoicePaymentNote"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Invoice Payment Note is required."
                                        ErrorMessage="Invoice Payment Note is required." ValidationGroup="Statements">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtInvoicePaymentNote" CssClass="failureNotification"
                                                ToolTip="Minimum 50 chars are required" Display="Dynamic" SetFocusOnError="True" ValidationGroup="Statements"
                                                ErrorMessage="Minimum 50 chars are required" ValidationExpression="^[a-zA-Z]{50,}$">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label4" runat="server">Invoice Billing Inquiry:<br /><i>(top of statement)</i></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtInvoiceInquiryNote" MaxLength="150" TextMode="MultiLine" Width="350px"
                                        Height="90px" CssClass="textarea" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txtInvoiceInquiryNote"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Invoice Inquiry Note is required."
                                        ErrorMessage="Invoice Inquiry Note is required." ValidationGroup="Statements">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtInvoiceInquiryNote" CssClass="failureNotification"
                                                ToolTip="Minimum 50 chars are required" Display="Dynamic" SetFocusOnError="True" ValidationGroup="Statements"
                                                ErrorMessage="Minimum 50 chars are required" ValidationExpression="^[a-zA-Z]{50,}$">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                        </td>
                        <td width="50%" valign="top">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label11" runat="server">Quick Pay Description 1:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtQuickPayDesc1" Width="350" MaxLength="60" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label14" runat="server">Quick Pay Description 2:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtQuickPayDesc2" Width="350" MaxLength="60" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label18" runat="server">Quick Pay Description 3:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtQuickPayDesc3" Width="350" MaxLength="60" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label19" runat="server">Quick Pay Description 4:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtQuickPayDesc4" Width="350" MaxLength="60" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label20" runat="server">Quick Pay Description 5:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtQuickPayDesc5" Width="350" MaxLength="60" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label12" runat="server">Invoice Message 1:<br /><i>(optional)</i></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtInvoiceMessage1" MaxLength="99" TextMode="MultiLine" Width="350px"
                                        Height="60px" CssClass="textarea" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row" style="display: none;">
                                <div class="editor-label">
                                    <asp:Label ID="Label13" runat="server">Invoice Message 2:<br /><i>(optional)</i></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtInvoiceMessage2" MaxLength="99" TextMode="MultiLine" Width="350px"
                                        Height="60px" CssClass="textarea" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label6" runat="server">Invoice Footer Note:<br /><i>(optional)</i></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtInvoiceFooterNote" MaxLength="100" TextMode="MultiLine" Width="350px"
                                        Height="60px" CssClass="textarea" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label7" runat="server">Invoice EOB Note:<br /><i>(optional)</i></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtInvoiceEOBNote" MaxLength="100" TextMode="MultiLine" Width="350px"
                                        Height="60px" CssClass="textarea" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label8" runat="server">Invoice Service Note:<br /><i>(optional)</i></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtInvoiceServiceNote" MaxLength="100" TextMode="MultiLine" Width="350px"
                                        Height="60px" CssClass="textarea" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label9" runat="server">Invoice Schedule Payment Note:<br /><i>(optional)</i></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtInvoiceSchedPayNote" MaxLength="100" TextMode="MultiLine" Width="350px"
                                        Height="60px" CssClass="textarea" runat="server"></asp:TextBox>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right">
                            <asp:ImageButton ID="ImageButton1" CssClass="btn-cancel" ImageUrl="../Content/Images/btn_cancel.gif" OnClientClick="return showMessage()" runat="server" />
                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                            <asp:ImageButton ID="btnUpdate" ImageUrl="../Content/Images/btn_update.gif" runat="server" OnClick="btnUpdate_Click" OnClientClick="return enableDisableButton(this);" CssClass="btn-update" ValidationGroup="Statements" />
                            &nbsp; &nbsp; &nbsp; 
                            <div id="divSuccessMessage" class="success-message" style="text-align: right">
                                <asp:Literal ID="litMessage" Text="" runat="server"></asp:Literal>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Statements"
                                ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                            <div class="success-message">
                                <asp:Literal ID="litFeeScheduleMessage" runat="server"></asp:Literal>
                            </div>
                        </td>
                    </tr>
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
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
   <script type="text/javascript" language="javascript">

       function showMessage() {
           var radWindow = $find("<%=RadWindow.ClientID %>");
            radWindow.radalert('Update abandoned and original values have been loaded.', 380, 100, '', refreshPage, '');
            return false;
        }

        function enableDisableButton(obj) {
            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('Statements');
            }
            if (isPageValid) {
                obj.src = "../Content/Images/btn_update_fade.gif";
                obj.disabled = 'disabled';
                <%= ClientScript.GetPostBackEventReference(btnUpdate, string.Empty) %>;
                return false;
            }

        }

    </script>
</asp:Content>