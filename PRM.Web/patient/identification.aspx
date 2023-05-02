<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="identification.aspx.cs"
    Inherits="Identification" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelIdentification" runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="btnDownloadPatientPrimary" />
            <asp:PostBackTrigger ControlID="btnDownloadPatientSecondary" />
            <asp:PostBackTrigger ControlID="btnDownloadGuardianPrimary" />
            <asp:PostBackTrigger ControlID="btnDownloadGuardianSecondary" />
        </Triggers>
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Patient Identification</h1>
            </div>
            <div class="bodyMain">
                <h2>Review and Update patient profile information here.</h2>
                <table width="100%">
                    <tr>
                        <td valign="top" width="49%">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server">Patient Information:</asp:Label>
                                </div>
                                <div class="editor-field">
                                </div>
                            </div>
                            <table>
                                <tr>
                                    <td valign="top">

                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="First Name:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblFirstName" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="Last Name:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblLastName" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="Date of Birth:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblDateOfBirth" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="Social Security:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label runat="server" ID="lblSocialSecurity"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="Financial Responsibility:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label runat="server" ID="lblFinancialResponsibility"></asp:Label>
                                            </div>
                                        </div>
                                    </td>
                                    <td valign="top">
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="Street:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblStreet" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="App/Suite:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblAppSuite" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="City:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblCity" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="State:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label runat="server" ID="lblState"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="Zip Code +4:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label runat="server" ID="lblZipCode"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row" align="right">
                                            <a href="javascript:;" onclick="location.href='Manage.aspx'">
                                                <img src="../Content/Images/btn_edit.gif" alt="Edit" /></a>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="pnlPatientInformation" runat="server">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Primary Identification:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                    </div>
                                </div>
                                <div>

                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="ID Type:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbPatientPriIDType" runat="server" width="160" emptymessage="Select Type…" autopostback="True" onselectedindexchanged="cmbIdentifications_SelectedIndexChanged"
                                                allowcustomtext="False" markfirstmatch="True" datatextfield="Name" datavaluefield="IdentificationTypeID">
                                        </telerik:radcombobox>

                                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                            <asp:ImageButton ID="btnPatientPriClear" ImageUrl="../Content/Images/btn_clear_small.gif" runat="server" OnClick="btnClear_OnClick" />
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="ID Number:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtPatientPriIDNumber" runat="server"></asp:TextBox>
                                            <asp:CustomValidator runat="server" ControlToValidate="txtPatientPriIDNumber" ID="cstmPatientPriIDNumberValidator"
                                                ClientValidationFunction="validateIDNumber" Display="Dynamic" SetFocusOnError="True" Enabled="False"
                                                CssClass="failureNotification" ToolTip="Invalid ID Number." ErrorMessage="Invalid ID Number." ValidateEmptyText="True"
                                                ValidationGroup="Indentification">*</asp:CustomValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="State/Country:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbPatientPriStateCountry" runat="server" width="160" emptymessage="Select Issuer..."
                                                allowcustomtext="False" markfirstmatch="True" datatextfield="Name" maxheight="200">
                                        </telerik:radcombobox>
                                            <asp:RequiredFieldValidator ID="rqdPatientPriStateCountryValidator" runat="server" ControlToValidate="cmbPatientPriStateCountry"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="State/Country is required." Enabled="False"
                                                ErrorMessage="State/Country is required." ValidationGroup="Indentification">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Issue Date:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:raddatepicker id="dtPatientPriIssueDate" mindate="1900/1/1" runat="server" cssclass="set-telerik-ctrl-width">
                                        </telerik:raddatepicker>

                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Expiration Date:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:raddatepicker id="dtPatientPriExpirationDate" mindate="1900/1/1" runat="server" cssclass="set-telerik-ctrl-width">
                                        </telerik:raddatepicker>
                                            <asp:RequiredFieldValidator ID="rqdPatientPriExpirationDateValidator" runat="server" ControlToValidate="dtPatientPriExpirationDate"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Expiration Date is required." Enabled="False"
                                                ErrorMessage="Expiration Date is required." ValidationGroup="Indentification">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Notes:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtPatientPriNotes" runat="server" TextMode="MultiLine" Width="300" Height="17" ForeColor="#333333" Font-Size="10pt" Font-Bold="False" BackColor="#FFFFEA" Font-Names="Tahoma; Arial"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server">Scan of ID Card:</asp:Label>
                                        </div>
                                        <div id="divCardImagePatientPrimary" runat="server" class="editor-upload-field">
                                            <telerik:radasyncupload runat="server" id="insPatientPrimaryImageUpload" maxfilesize="5242880"
                                                multiplefileselection="Disabled" maxfileinputscount="1" allowedfileextensions=".jpeg,.jpg,.png" />
                                        </div>
                                        <div id="divDownloadRemovePatientPrimary" class="editor-field" runat="server" visible="False">
                                            <asp:Label ID="lblFileNamePatientPrimary" runat="server"></asp:Label>
                                            &nbsp;
                            <asp:ImageButton ID="btnDownloadPatientPrimary" ImageUrl="~/Content/Images/download.ico" Width="20"
                                AlternateText="Download" runat="server" OnClick="ImageDownload_Click" />&nbsp;<asp:ImageButton
                                    ID="btnRemovePatientPrimary" ImageUrl="~/Content/Images/close.ico" Width="20" AlternateText="Remove"
                                    runat="server" OnClick="ImageRemove_Click" />
                                        </div>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Secondary Identification:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                    </div>
                                </div>
                                <div>

                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="ID Type:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbPatientSecIDType" runat="server" width="160" allowcustomtext="False" emptymessage="Select Type…" autopostback="True" onselectedindexchanged="cmbIdentifications_SelectedIndexChanged"
                                                markfirstmatch="True" datatextfield="Name" datavaluefield="IdentificationTypeID">
                                        </telerik:radcombobox>

                                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                            <asp:ImageButton ID="btnPatientSecClear" ImageUrl="../Content/Images/btn_clear_small.gif" runat="server" OnClick="btnClear_OnClick" />

                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="ID Number:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtPatientSecIDNumber" runat="server"></asp:TextBox>
                                            <asp:CustomValidator runat="server" ControlToValidate="txtPatientSecIDNumber" ID="cstmPatientSecIDNumberValidator"
                                                ClientValidationFunction="validateIDNumber" Display="Dynamic" SetFocusOnError="True" Enabled="False"
                                                CssClass="failureNotification" ToolTip="Invalid ID Number." ErrorMessage="Invalid ID Number." ValidateEmptyText="True"
                                                ValidationGroup="Indentification">*</asp:CustomValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="State/Country:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbPatientSecStateCountry" runat="server" width="160" emptymessage="Select Issuer..."
                                                allowcustomtext="False" markfirstmatch="True" datatextfield="Name" maxheight="200">
                                        </telerik:radcombobox>
                                            <asp:RequiredFieldValidator ID="rqdPatientSecStateCountryValidator" runat="server" ControlToValidate="cmbPatientSecStateCountry"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="State/Country is required." Enabled="False"
                                                ErrorMessage="State/Country is required." ValidationGroup="Indentification">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Issue Date:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:raddatepicker id="dtPatientSecIssueDate" mindate="1900/1/1" runat="server" cssclass="set-telerik-ctrl-width">
                                        </telerik:raddatepicker>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Expiration Date:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:raddatepicker id="dtPatientSecExpirationDate" mindate="1900/1/1" runat="server" cssclass="set-telerik-ctrl-width">
                                        </telerik:raddatepicker>
                                            <asp:RequiredFieldValidator ID="rqdPatientSecExpirationDateValidator" runat="server" ControlToValidate="dtPatientSecExpirationDate"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Expiration Date is required." Enabled="False"
                                                ErrorMessage="Expiration Date is required." ValidationGroup="Indentification">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Notes:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtPatientSecNotes" runat="server" TextMode="MultiLine" Width="300" Height="17" ForeColor="#333333" Font-Size="10pt" Font-Bold="False" BackColor="#FFFFEA" Font-Names="Tahoma; Arial"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server">Scan of ID Card:</asp:Label>
                                        </div>
                                        <div id="divCardImagePatientSecondary" runat="server" class="editor-upload-field">
                                            <telerik:radasyncupload runat="server" id="insPatientSecondaryImageUpload" maxfileinputscount="1"
                                                maxfilesize="5242880" multiplefileselection="Disabled" allowedfileextensions=".jpeg,.jpg" />
                                        </div>
                                        <div id="divDownloadRemovePatientSecondary" class="editor-field" runat="server" visible="False">
                                            <asp:Label ID="lblFileNamePatientSecondary" runat="server"></asp:Label>
                                            &nbsp;
                            <asp:ImageButton ID="btnDownloadPatientSecondary" ImageUrl="~/Content/Images/download.ico"
                                Width="20" AlternateText="Download" runat="server" OnClick="ImageDownload_Click" />&nbsp;<asp:ImageButton
                                    ID="btnRemovePatientSecondary" ImageUrl="~/Content/Images/close.ico" Width="20" AlternateText="Remove"
                                    runat="server" OnClick="ImageRemove_Click" />
                                        </div>
                                    </div>

                                </div>
                            </asp:Panel>
                            <div id="divPatient" runat="server" visible="False">
                                <b>Identification cannot be captured for minors. Please use the guardian section to record this data.
                                </b>
                            </div>
                        </td>
                        <td valign="top" width="2%" style="border-right: 1px solid #325DA4; height: 100%;"></td>
                        <td valign="top" width="49%">

                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server">Guardian Information:</asp:Label>
                                </div>
                                <div class="editor-field">
                                </div>
                            </div>
                            <table>
                                <tr>
                                    <td valign="top">

                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="First Name:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblSecFirstName" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="Last Name:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblSecLastName" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="Date of Birth:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblSecDateOfBirth" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="Social Security:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label runat="server" ID="lblSecSocialSecurity"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="Relationship:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label runat="server" ID="lblSecRelationShip"></asp:Label>
                                            </div>
                                        </div>
                                    </td>
                                    <td valign="top">
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="Street:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblSecStreet" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="App/Suite:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblSecAppSuite" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="City:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label ID="lblSecCity" runat="server"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="State:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label runat="server" ID="lblSecState"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label runat="server" Text="Zip Code +4:"></asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <asp:Label runat="server" ID="lblSecZipCode"></asp:Label>
                                            </div>
                                        </div>
                                        <div class="form-row" align="right">
                                            <a href="javascript:;" onclick="location.href='Manage.aspx'">
                                                <img src="../Content/Images/btn_edit.gif" alt="Edit" /></a>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <asp:Panel ID="pnlGuardianInformation" runat="server">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Primary Identification:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                    </div>
                                </div>
                                <div>

                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="ID Type:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbGuardianPriIDType" runat="server" width="160" allowcustomtext="False" emptymessage="Select Type…" autopostback="True" onselectedindexchanged="cmbIdentifications_SelectedIndexChanged"
                                                markfirstmatch="True" datatextfield="Name" datavaluefield="IdentificationTypeID">
                                        </telerik:radcombobox>

                                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        <asp:ImageButton ID="btnGuardianPriClear" ImageUrl="../Content/Images/btn_clear_small.gif" runat="server" OnClick="btnClear_OnClick" />

                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="ID Number:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtGuardianPriIDNumber" runat="server"></asp:TextBox>
                                            <asp:CustomValidator runat="server" ControlToValidate="txtGuardianPriIDNumber" ID="cstmGuardianPriIDNumberValidator" Enabled="False"
                                                ClientValidationFunction="validateIDNumber" Display="Dynamic" SetFocusOnError="True"
                                                CssClass="failureNotification" ToolTip="Invalid ID Number." ErrorMessage="Invalid ID Number." ValidateEmptyText="True"
                                                ValidationGroup="Indentification">*</asp:CustomValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="State/Country:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbGuardianPriStateCountry" runat="server" width="160" emptymessage="Select Issuer..."
                                                allowcustomtext="False" markfirstmatch="True" datatextfield="Name" maxheight="200">
                                        </telerik:radcombobox>
                                            <asp:RequiredFieldValidator ID="rqdGuardianPriStateCountryValidator" runat="server" ControlToValidate="cmbGuardianPriStateCountry" Enabled="False"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="State/Country is required."
                                                ErrorMessage="State/Country is required." ValidationGroup="Indentification">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Issue Date:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:raddatepicker id="dtGuardianPriIssueDate" mindate="1900/1/1" runat="server" cssclass="set-telerik-ctrl-width">
                                        </telerik:raddatepicker>
                                            <asp:RequiredFieldValidator ID="rqdGuardianPriIssueDateValidator" runat="server" ControlToValidate="dtGuardianPriIssueDate" Enabled="False"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Issue Date is required."
                                                ErrorMessage="Issue Date is required." ValidationGroup="Indentification">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Expiration Date:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:raddatepicker id="dtGuardianPriExpirationDate" mindate="1900/1/1" runat="server" cssclass="set-telerik-ctrl-width">
                                        </telerik:raddatepicker>
                                            <asp:RequiredFieldValidator ID="rqdGuardianPriExpirationDateValidator" runat="server" ControlToValidate="dtGuardianPriExpirationDate" Enabled="False"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Expiration Date is required."
                                                ErrorMessage="Expiration Date is required." ValidationGroup="Indentification">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Notes:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtGuardianPriNotes" runat="server" TextMode="MultiLine" Width="300" Height="17" ForeColor="#333333" Font-Size="10pt" Font-Bold="False" BackColor="#FFFFEA" Font-Names="Tahoma; Arial"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server">Scan of ID Card:</asp:Label>
                                        </div>
                                        <div id="divCardImageGuardianPrimary" runat="server" class="editor-upload-field">
                                            <telerik:radasyncupload runat="server" id="insGuardianPrimaryImageUpload" maxfilesize="5242880"
                                                multiplefileselection="Disabled" maxfileinputscount="1" allowedfileextensions=".jpeg,.jpg,.png" />
                                        </div>
                                        <div id="divDownloadRemoveGuardianPrimary" class="editor-field" runat="server" visible="False">
                                            <asp:Label ID="lblFileNameGuardianPrimary" runat="server"></asp:Label>
                                            &nbsp;
                            <asp:ImageButton ID="btnDownloadGuardianPrimary" ImageUrl="~/Content/Images/download.ico" Width="20"
                                AlternateText="Download" runat="server" OnClick="ImageDownload_Click" />&nbsp;<asp:ImageButton
                                    ID="btnRemoveGuardianPrimary" ImageUrl="~/Content/Images/close.ico" Width="20" AlternateText="Remove"
                                    runat="server" OnClick="ImageRemove_Click" />
                                        </div>
                                    </div>


                                </div>


                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Secondary Identification:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                    </div>
                                </div>
                                <div>

                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="ID Type:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbGuardianSecIDType" runat="server" width="160" allowcustomtext="False" emptymessage="Select Type…" autopostback="True" onselectedindexchanged="cmbIdentifications_SelectedIndexChanged"
                                                markfirstmatch="True" datatextfield="Name" datavaluefield="IdentificationTypeID">
                                        </telerik:radcombobox>
                                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        <asp:ImageButton ID="btnGuardianSecClear" ImageUrl="../Content/Images/btn_clear_small.gif" runat="server" OnClick="btnClear_OnClick" />

                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="ID Number:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtGuardianSecIDNumber" runat="server"></asp:TextBox>
                                            <asp:CustomValidator runat="server" ControlToValidate="txtGuardianSecIDNumber" ID="cstmGuardianSecIDNumberValidator"
                                                ClientValidationFunction="validateIDNumber" Display="Dynamic" SetFocusOnError="True"
                                                CssClass="failureNotification" ToolTip="Invalid ID Number." ErrorMessage="Invalid ID Number." ValidateEmptyText="True" Enabled="False"
                                                ValidationGroup="Indentification">*</asp:CustomValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="State/Country:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbGuardianSecStateCountry" runat="server" width="160" emptymessage="Select Issuer..."
                                                allowcustomtext="False" markfirstmatch="True" datatextfield="Name" maxheight="200">
                                        </telerik:radcombobox>
                                            <asp:RequiredFieldValidator ID="rqdGuardianSecStateCountryValidator" runat="server" ControlToValidate="cmbGuardianSecStateCountry" Enabled="False"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="State/Country is required."
                                                ErrorMessage="State/Country is required." ValidationGroup="Indentification">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Issue Date:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:raddatepicker id="dtGuardianSecIssueDate" mindate="1900/1/1" runat="server" cssclass="set-telerik-ctrl-width">
                                        </telerik:raddatepicker>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Expiration Date:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:raddatepicker id="dtGuardianSecExpirationDate" mindate="1900/1/1" runat="server" cssclass="set-telerik-ctrl-width">
                                        </telerik:raddatepicker>
                                            <asp:RequiredFieldValidator ID="rqdGuardianSecExpirationDateValidator" runat="server" ControlToValidate="dtGuardianSecExpirationDate" Enabled="False"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Expiration Date is required."
                                                ErrorMessage="Expiration Date is required." ValidationGroup="Indentification">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Notes:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtGuardianSecNotes" runat="server" TextMode="MultiLine" Width="300" Height="17" ForeColor="#333333" Font-Size="10pt" Font-Bold="False" BackColor="#FFFFEA" Font-Names="Tahoma; Arial"></asp:TextBox>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server">Scan of ID Card:</asp:Label>
                                        </div>
                                        <div id="divCardImageGuardianSecondary" runat="server" class="editor-upload-field">
                                            <telerik:radasyncupload runat="server" id="insGuardianSecondaryImageUpload" maxfilesize="5242880"
                                                multiplefileselection="Disabled" maxfileinputscount="1" allowedfileextensions=".jpeg,.jpg,.png" />
                                        </div>
                                        <div id="divDownloadRemoveGuardianSecondary" class="editor-field" runat="server" visible="False">
                                            <asp:Label ID="lblFileNameGuardianSecondary" runat="server"></asp:Label>
                                            &nbsp;
                            <asp:ImageButton ID="btnDownloadGuardianSecondary" ImageUrl="~/Content/Images/download.ico" Width="20"
                                AlternateText="Download" runat="server" OnClick="ImageDownload_Click" />&nbsp;<asp:ImageButton
                                    ID="btnRemoveGuardianSecondary" ImageUrl="~/Content/Images/close.ico" Width="20" AlternateText="Remove"
                                    runat="server" OnClick="ImageRemove_Click" />
                                        </div>
                                    </div>

                                </div>

                            </asp:Panel>
                            <div id="divGuardian" runat="server" visible="False">
                                <b>Please add a guardian to the patient profile if additional identification needs to be recorded.
                                </b>
                            </div>
                        </td>
                    </tr>
                </table>
                <div align="right" style="margin-top: 20px;">
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Indentification"
                        ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                        CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                    <a href="javascript:;" onclick="refreshPage()">
                        <img alt="Cancel" src="../Content/Images/btn_cancel.gif" class="btn-cancel" /></a>
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
                    <asp:ImageButton ID="btnSubmit" OnClick="btnSubmit_SaveAllIdentifications" OnClientClick="return enableDisableButton(this);" CssClass="btn-submit" ImageUrl="../Content/Images/btn_update.gif" ValidationGroup="Indentification" runat="server" />
                    &nbsp; &nbsp; &nbsp;  
                </div>
            </div>
            <telerik:radwindowmanager id="windowManager" showcontentduringload="True" visiblestatusbar="False"
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
                            <a href="javascript:;" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:radwindowmanager>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript">

        function enableDisableButton(obj) {
            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('Users');
            }
            if (isPageValid) {
                obj.disabled = 'disabled';
                $(obj).addClass("disable-button");
                <%= ClientScript.GetPostBackEventReference(btnSubmit, string.Empty) %>;
                return false;
            }

        }

        function validateIDNumber(events, args) {
            var taxPayerIdLength = args.Value.length;
            if (taxPayerIdLength >= 5) {
                args.IsValid = true;
                return;
            }
            args.IsValid = false;
        }
    </script>
</asp:Content>
