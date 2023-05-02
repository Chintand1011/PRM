<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="manage.aspx.cs"
    Inherits="manage" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Patient Profile Management</h1>
            </div>
            <div class="bodyMain">
                <h2>
                    <asp:Literal ID="litPatientManagement" Text="Review and update patient profile information here."
                        runat="server"></asp:Literal></h2>
                <table width="100%">
                    <tr>
                        <td valign="top">
                            <div class="form-row" style="padding: 5px 0 10px 0;">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Account ID:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblAccountID" runat="server" Font-Bold="False" Font-Size="1.2em" ForeColor="Black">Not Available</asp:Label>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Account Status:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbAccountStatus" runat="server" width="160" allowcustomtext="False"
                                        markfirstmatch="True" datatextfield="Abbr" datavaluefield="StatusTypeID">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbAccountStatus" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="Account Status is required."
                                        ErrorMessage="Account Status is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="MRN Number:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtMRN" runat="server" MaxLength="30" Width="154"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label28" runat="server" Text="Login PIN:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPincode" MaxLength="8" runat="server" Enabled="False"></asp:TextBox>
                                    <asp:CustomValidator ID="CustomValidatorPincode" CssClass="failureNotification" runat="server"
                                        Enabled="False" ControlToValidate="txtPincode" ClientValidationFunction="validatePincode"
                                        ValidateEmptyText="True" ValidationGroup="PtManagementValidationGroup" Display="Dynamic"
                                        ErrorMessage="PIN number must be valid" ToolTip="PIN number must be valid">*</asp:CustomValidator>
                                </div>
                            </div>
                            <br />
                            &nbsp;
                            <div class="form-row">
                                <div class="editor-label">
                                    Patient Information:
                                </div>
                                <div class="editor-field">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="First Name:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtFirstName" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFirstName" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="First Name is required."
                                        ErrorMessage="First Name is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Last Name:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtLastName" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLastName" Display="Dynamic"
                                        ErrorMessage="Last Name is required." SetFocusOnError="True" CssClass="failureNotification"
                                        ToolTip="Last Name is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Date of Birth:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:raddatepicker id="dtDateofBirth" onselecteddatechanged="dtDateofBirth_OnSelectedDateChanged" autopostback="True" mindate="1900/1/1" runat="server" cssclass="set-telerik-ctrl-width" width="148">
                                    </telerik:raddatepicker>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="dtDateofBirth" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="Date of Birth is required."
                                        ErrorMessage="Date of Birth is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Social Security:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radmaskedtextbox id="txtSocialSecurity" runat="server" mask="###-##-####"
                                        width="143">
                                    </telerik:radmaskedtextbox>
                                    <asp:RegularExpressionValidator Display="Dynamic" runat="server" ToolTip="Format is XXX-XX-XXXX"
                                        ErrorMessage="Social Security's Format should be XXX-XX-XXXX" SetFocusOnError="True"
                                        CssClass="failureNotification" ControlToValidate="txtSocialSecurity" ValidationGroup="PtManagementValidationGroup"
                                        ValidationExpression="\d{3}\-\d{2}\-\d{4}">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label1" runat="server" Text="Gender:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbGender" runat="server" width="143" emptymessage="Choose Gender" datatextfield="Text" datavaluefield="Value"
                                        allowcustomtext="False" markfirstmatch="True">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="cmbGender"
                                        ErrorMessage="Gender is Required" Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                        ToolTip="Gender is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Primary Phone:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radmaskedtextbox id="txtHomePhone" runat="server" mask="(###) ###-####"
                                        width="143">
                                    </telerik:radmaskedtextbox>
                                    <asp:RegularExpressionValidator Display="Dynamic" runat="server" ToolTip="Format is (XXX) XXX-XXXX"
                                        ErrorMessage="Format is (XXX) XXX-XXXX" SetFocusOnError="True" CssClass="failureNotification"
                                        ControlToValidate="txtHomePhone" ValidationGroup="PtManagementValidationGroup"
                                        ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtHomePhone" Display="Dynamic"
                                        ErrorMessage="Home Phone is required." SetFocusOnError="True" CssClass="failureNotification"
                                        ToolTip="Home Phone is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label3" runat="server" Text="Alternate Phone:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radmaskedtextbox id="txtAltPhone" runat="server" mask="(###) ###-####" width="143">
                                    </telerik:radmaskedtextbox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" Display="Dynamic"
                                        ErrorMessage="Format is (XXX) XXX-XXXX" runat="server" ToolTip="Format is (XXX) XXX-XXXX"
                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtAltPhone"
                                        ValidationGroup="MyinfoValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label2" runat="server" Text="Email:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtEmail" autocomplete="off" runat="server" onkeyup="validateEmailAddress();" Width="200"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="regEmail" runat="server" CssClass="failureNotification"
                                        ErrorMessage="Invalid Email" ToolTip="Invalid Email." ControlToValidate="txtEmail"
                                        Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                        ValidationGroup="PtManagementValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    &nbsp;
                                </div>
                                <div class="editor-field">
                                    <asp:CheckBox ID="chkEmailMyStatements" Text="Email Statements and Notifications" runat="server" />
                                    <img src="../Content/Images/icon_help.png" alt="help" title="Statements may be emailed if there is a valid email address entered for either the patient or guardian. If both have an email listed, statements are sent to the guardian." />
                                </div>
                            </div>
                            <br />
                            &nbsp;

                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Primary Address:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Street:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPrimaryStreet" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPrimaryStreet" Display="Dynamic"
                                        ErrorMessage="Street is required" SetFocusOnError="True" CssClass="failureNotification"
                                        ToolTip="Street is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Apt/Suite:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPrimaryAptSuite" runat="server" MaxLength="30"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="City:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPrimaryCity" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPrimaryCity" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="City is required."
                                        ErrorMessage="City is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="State:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbPrimaryStates" runat="server" width="157px" emptymessage="Choose State..."
                                        allowcustomtext="False" markfirstmatch="True" datatextfield="Name" datavaluefield="StateTypeID"
                                        maxheight="200">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbPrimaryStates" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="State is required."
                                        ErrorMessage="State is required" ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Zip Code +4:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPrimaryZipCode1" runat="server" CssClass="zip-code1" MaxLength="5"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtPrimaryZipCode1"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Zip Code 1 is required."
                                        ErrorMessage="Zip Code 1 is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPrimaryZipCode1"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                        ErrorMessage="Invalid Zip Code 1" ToolTip="Invalid Zip Code 1" ValidationGroup="PtManagementValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                                <div class="editor-field">
                                    <asp:Label runat="server" Text="-"></asp:Label>
                                    <asp:TextBox ID="txtPrimaryZipCode2" runat="server" CssClass="zip-code2" MaxLength="4"></asp:TextBox>
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtPrimaryZipCode2"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{4}$"
                                        ErrorMessage="Invalid Zip Code 2" ToolTip="Invalid Zip Code 2" ValidationGroup="PtManagementValidationGroup">*</asp:RegularExpressionValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>

                        </td>
                        <td></td>
                        <td valign="top">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Location:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbLocations" runat="server" width="200" emptymessage="Choose Location"
                                        allowcustomtext="False" markfirstmatch="True" datatextfield="Abbr" datavaluefield="LocationID"
                                        maxheight="200">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbLocations" Display="Dynamic"
                                        ErrorMessage="Location is required." SetFocusOnError="True" CssClass="failureNotification"
                                        ToolTip="Location is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Provider:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbProviders" runat="server" width="200" emptymessage="Choose Provider"
                                        allowcustomtext="False" markfirstmatch="True" datatextfield="ProviderAbbr" datavaluefield="ProviderID"
                                        maxheight="200">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbProviders" Display="Dynamic"
                                        ErrorMessage="Provider is required." SetFocusOnError="True" CssClass="failureNotification"
                                        ToolTip="Provider is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label4" runat="server" Text="Responsible Party:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbFinancialResponsibility" runat="server" width="155px"
                                        autopostback="True" allowcustomtext="False" markfirstmatch="True" filter="StartsWith"
                                        maxheight="200" onselectedindexchanged="cmbFinancialResponsibility_SelectedIndexChanged">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="cmbFinancialResponsibility"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Financial Responsibility is required."
                                        ErrorMessage="Financial Responsibility is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Mail Statements:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbStatements" runat="server" width="157px" allowcustomtext="False"
                                        autopostback="True" onselectedindexchanged="cmbStatements_SelectedIndexChanged"
                                        markfirstmatch="True" filter="StartsWith" maxheight="200">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbStatements" Display="Dynamic"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="Statements is required."
                                        ErrorMessage="Statement is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <span class="spnRequired" style="color: red"></span>
                                </div>
                            </div>
                            <br />
                            &nbsp;
                            <div class="form-row">
                                <div class="editor-label">
                                    Guardian Information:  
                                </div>
                                <div class="editor-field">
                                    <span id="spanGuardianInfo" runat="server" visible="False">&nbsp; &nbsp;<img alt="Info" src="../Content/Images/msg_icon_caution.gif" />&nbsp;<font color="darkred"> Guardian is required as patient is a minor.</font></span>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label11" runat="server" Text="Relationship:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbRelationship" runat="server" width="143" allowcustomtext="False" autopostback="True" onselectedindexchanged="cmbRelationship_SelectedIndexChanged"
                                        markfirstmatch="True" datatextfield="RelationAbbr" datavaluefield="RelTypeID"
                                        maxheight="200">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator ID="rfRelationShip" Enabled="False" runat="server" ControlToValidate="cmbRelationship"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Relationship is required."
                                        ErrorMessage="Relationship is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="First Name:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtGuardianFirstName" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvGuardianFirstName" runat="server" Enabled="False"
                                        ControlToValidate="txtGuardianFirstName" Display="Dynamic" SetFocusOnError="True"
                                        ErrorMessage="First Name is required." CssClass="failureNotification" ToolTip="First Name is required."
                                        ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label5" runat="server" Text="Last Name:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtGuardianLastName" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvGuardianLastName" runat="server" Enabled="False"
                                        ControlToValidate="txtGuardianLastName" Display="Dynamic" SetFocusOnError="True"
                                        ErrorMessage="Last Name is required." CssClass="failureNotification" ToolTip="Last Name is required."
                                        ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label6" runat="server" Text="Date of Birth:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:raddatepicker id="dtGuardianDateofBirth" mindate="1900/1/1" runat="server"
                                        cssclass="set-telerik-ctrl-width">
                                    </telerik:raddatepicker>
                                    <asp:RequiredFieldValidator ID="rfvGuardianDateofBirth" runat="server" Enabled="False"
                                        ErrorMessage="Date of Birth is required." ControlToValidate="dtGuardianDateofBirth"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Date of Birth is required."
                                        ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <asp:CustomValidator CssClass="failureNotification" runat="server" ClientValidationFunction="validateDateOfBirth"
                                        ControlToValidate="dtGuardianDateofBirth" ValidationGroup="PtManagementValidationGroup" Display="Dynamic"
                                        ErrorMessage="Guardian must be at least 18 years old." ToolTip="Guardian must be at least 18 years old.">*</asp:CustomValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label7" runat="server" Text="Social Security:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radmaskedtextbox id="txtGuardianSSN" runat="server" mask="###-##-####" width="149">
                                    </telerik:radmaskedtextbox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" Display="Dynamic"
                                        runat="server" ToolTip="Format is XXX-XX-XXXX" SetFocusOnError="True" CssClass="failureNotification"
                                        ErrorMessage="Format is XXX-XX-XXXX" ControlToValidate="txtGuardianSSN" ValidationGroup="PtManagementValidationGroup"
                                        ValidationExpression="\d{3}\-\d{2}\-\d{4}">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label8" runat="server" Text="Gender:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbGuardianGender" runat="server" width="143" emptymessage="Choose Gender"
                                        allowcustomtext="False" markfirstmatch="True">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator ID="rfvGuardianGender" runat="server" Enabled="False"
                                        ControlToValidate="cmbGuardianGender" Display="Dynamic" SetFocusOnError="True"
                                        ErrorMessage="Gender is required" CssClass="failureNotification" ToolTip="Gender is required."
                                        ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label9" runat="server" Text="Phone:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radmaskedtextbox id="txtGuardianPhone" runat="server" mask="(###) ###-####"
                                        width="149">
                                    </telerik:radmaskedtextbox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator5" Display="Dynamic"
                                        ErrorMessage="Format is (XXX) XXX-XXXX" runat="server" ToolTip="Format is (XXX) XXX-XXXX"
                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtGuardianPhone"
                                        ValidationGroup="PtManagementValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                    <asp:RequiredFieldValidator ID="rfvGuardianPhone" runat="server" Enabled="False"
                                        ControlToValidate="txtGuardianPhone" Display="Dynamic" SetFocusOnError="True"
                                        ErrorMessage="Home Phone is required." CssClass="failureNotification" ToolTip="Home Phone is required."
                                        ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Email:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtGuardianEmail" autocomplete="off" runat="server" onkeyup="validateEmailAddress();" Width="200"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator7" runat="server" CssClass="failureNotification"
                                        ToolTip="Invalid Email." ControlToValidate="txtGuardianEmail" Display="Dynamic"
                                        ErrorMessage="Inavlid Email" SetFocusOnError="true" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                        ValidationGroup="PtManagementValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label10" runat="server" Text="Guardian Address:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbGuardianAddress" runat="server" width="155px" allowcustomtext="False"
                                        autopostback="True" onselectedindexchanged="cmbGuardianAddress_SelectedIndexChanged"
                                        markfirstmatch="True" filter="StartsWith" maxheight="200">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="cmbGuardianAddress"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Address is required."
                                        ErrorMessage="Address is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <br />
                            &nbsp;
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Alternate Mailing Address:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Street:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtSecondaryStreet" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvAltStreet" runat="server" Enabled="False" ControlToValidate="txtSecondaryStreet"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Street is required."
                                        ErrorMessage="Street is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Apt/Suite:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtSecondaryAptSuite" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="City:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtSecondaryCity" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvAltCity" runat="server" Enabled="False" ControlToValidate="txtSecondaryCity"
                                        ErrorMessage="City is required." Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                        ToolTip="City is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="State:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbSecondaryStates" runat="server" width="157px" emptymessage="Choose State..."
                                        allowcustomtext="False" markfirstmatch="True" datatextfield="Name" datavaluefield="StateTypeID"
                                        maxheight="200">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator ID="rfvdAltState" runat="server" Enabled="False" ControlToValidate="cmbSecondaryStates"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="State is required."
                                        ErrorMessage="States is required" ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblZipCode1" runat="server" Text="Zip Code +4:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtAltZipCode1" runat="server" CssClass="zip-code1" MaxLength="5"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvAltZipCode1" runat="server" Enabled="False" ControlToValidate="txtAltZipCode1"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Zip code 1 is required."
                                        ErrorMessage="Zip Code 1 is required" ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtAltZipCode1"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                        ErrorMessage="Invalid Zip Code 1" ToolTip="Invalid Zip Code 1" ValidationGroup="PtManagementValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                                <div class="editor-field">
                                    <asp:Label runat="server" Text="-"></asp:Label>
                                    <asp:TextBox ID="txtAltZipCode2" runat="server" CssClass="zip-code2" MaxLength="4"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtAltZipCode2"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{4}$"
                                        ToolTip="Invalid Zip Code 2" ValidationGroup="PtManagementValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <label>
                                        &nbsp;</label>
                                </div>
                                <div class="editor-label">
                                    <label>
                                        &nbsp;</label>
                                </div>
                                <div class="editor-field" style="padding-left: 300px;">
                                    <asp:HiddenField ID="hdnIsAdd" runat="server" />
                                    <asp:HiddenField ID="hdnIsContinue" runat="server" />
                                    <asp:ImageButton ID="btnUpdate" runat="server" ImageUrl="../Content/Images/btn_update.gif"
                                        OnClientClick="return disableButton(this);" OnClick="btnUpdate_Click" CssClass="btn-submit" />
                                    &nbsp; &nbsp;
                                    <img src="../Content/Images/btn_cancel.gif" class="btn-cancel" alt="Cancel" style="cursor: pointer" onclick='showCancelMessage();' />

                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <div style="float: right;">
                <br />
                <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="PtManagementValidationGroup"
                    ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                    CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                <div class="success-message">
                    <asp:Literal ID="litMessage" runat="server"></asp:Literal>
                </div>
            </div>
            <telerik:radwindowmanager id="windowManager" behaviors="Move" style="z-index: 200001"
                showcontentduringload="False" visiblestatusbar="False" visibletitlebar="True"
                reloadonshow="True" runat="Server" modal="True" enableembeddedbasestylesheet="True"
                enableembeddedskins="False" skin="CareBlueInf">
                 <ConfirmTemplate>
                    <div class="rwDialogPopup radconfirm">
                        <h5>
                            <div class="rwDialogText">
                                {1}
                            </div>
                        </h5>
                        <div>
                            <div style="margin-top: 15px; margin-left: 70px;">
                                <a href="javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_continue.gif" alt="Continue" /></a> 
                                 &nbsp; &nbsp;
                                <a href="javascript:;" onclick="$find('{0}').close(false);">
                                    <img src="../Content/Images/btn_cancel.gif" alt="Cancel" /></a>
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
                            <a href="javascript:;" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:radwindowmanager>
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
<asp:Content ID="Content1" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript">


        $(function () {
            showAsteriskSign();
            validateEmailAddress();
        });

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {

            $(function () {
                validateEmailAddress();
                showAsteriskSign();
            });
        });

        function removeSpans() {
            $(".spnRequired").each(function () {
                $(this).hide();
            });
        }

        function showAsteriskSign() {
            var isAdd = $("#<%= hdnIsAdd.ClientID %>").val() == "1";
            if (isAdd) {
                $(".spnRequired").each(function () {
                    $(this).text("*");
                });
            }
        }


        function showCancelMessage() {
            var radWindow = $find("<%=windowManager.ClientID %>");
            radWindow.radalert("<br>Updates have been canceled.", 350, 150, "", redirectPage, "../Content/Images/warning.png");

        }

        function redirectPage() {
            var isRequestFromBlueCredit = '<%= ClientSession.IsRedirectToBluecredit %>';
            var url = isRequestFromBlueCredit == "True" ? "/patient/bluecredit.aspx" : "<%=ClientSession.WebPathRootProvider %>" + "patient/status.aspx";
            location.href = url;
        }

        function validatePincode(sender, args) {
            if ((args.Value.trim().length >= 4 && args.Value.trim().length <= 8) || args.Value.trim().length == 0) {
                args.IsValid = true;
            } else {
                args.IsValid = false;
            }
        }


        function validateDateOfBirth(sender, args) {
            var picker = $find("<%=dtGuardianDateofBirth.ClientID%>");
            var date = picker.get_selectedDate();
            args.IsValid = getAge(date) >= 18;
        }

        function getAge(birthDateString) {
            var today = new Date();
            var birthDate = new Date(birthDateString);
            var age = today.getFullYear() - birthDate.getFullYear();
            var m = today.getMonth() - birthDate.getMonth();
            if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
            return age;
        }

        function redirectToPFSReports() {
            location.href = "<%=ClientSession.WebPathRootProvider %>" + "Credit/pfsreports.aspx";
        }

        function disableButton(obj) {
            // Removing the span errors
            removeSpans();

            // Validating the email address
            validateEmailAddress();

            var isAdd = $("#<%= hdnIsAdd.ClientID %>").val() == "1";
           var isPageValid = false;

           if (typeof (Page_ClientValidate) == 'function') {
               isPageValid = Page_ClientValidate('PtManagementValidationGroup');
           }

           if (isPageValid) {
               obj.disabled = 'disabled';
               obj.src = !isAdd ? "../Content/Images/btn_update_fade.gif" : "../Content/Images/btn_submit_fade.gif";
               <%= ClientScript.GetPostBackEventReference(btnUpdate, string.Empty) %>;
                return false;
            }


        }

        function validateEmailAddress() {

            var emailAddress = $("#<%=txtEmail.ClientID%>").val();

            if (emailAddress == "") {
                emailAddress = $("#<%=txtGuardianEmail.ClientID%>").val();
            }

            var pattern = new RegExp(/^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/);
            var chkStatements = $("#<%=chkEmailMyStatements.ClientID%>");

            if (!pattern.test(emailAddress)) {
                chkStatements.removeAttr("checked");
                chkStatements.attr("disabled", "disabled");
            } else {
                chkStatements.removeAttr("disabled");
                chkStatements.attr("checked", "checked");
            }
        }

        function validateMrnConfirmPopup(isContinue) {
            if (isContinue) {
                $("#<%=hdnIsContinue.ClientID%>").val(isContinue);
                $("#<%=btnUpdate.ClientID%>").click();
            }
        }

    </script>
</asp:Content>
