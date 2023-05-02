<%@ Page Language="C#" AutoEventWireup="true" CodeFile="managePatient_popup.aspx.cs"
    Inherits="managePatient_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .form-row-new
        {
            margin: 0px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
    </telerik:RadScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>
                    Patient Profile Management</h1>
            </div>
            <div class="bodyMain">
                <h2>
                    <asp:Literal ID="litPatientManagement" Text="Review and update patient profile information here."
                        runat="server"></asp:Literal></h2>
                <table class="CareBluePopup">
                    <tr>
                        <td valign="top">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label1" runat="server" Text="Account Status:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbAccountStatus" runat="server" Width="200" AllowCustomText="False"
                                        MarkFirstMatch="True" DataTextField="Abbr" DataValueField="StatusTypeID" MaxHeight="200">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="cmbAccountStatus"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Account Status is required."
                                        ErrorMessage="Account Status is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label2" runat="server" Text="MRN Number:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtMRN" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtMRN"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="MRN Number is required."
                                        ErrorMessage="MRN Number is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    Patient Information:
                                </div>
                                <div class="editor-field">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label3" runat="server" Text="First Name:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtFirstName" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtFirstName"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="First Name is required."
                                        ErrorMessage="First Name is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label4" runat="server" Text="Last Name:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtLastName" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtLastName"
                                        Display="Dynamic" ErrorMessage="Last Name is required." SetFocusOnError="True"
                                        CssClass="failureNotification" ToolTip="Last Name is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label5" runat="server" Text="Date of Birth:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadDatePicker ID="dtDateofBirth" MinDate="1900/1/1" runat="server" CssClass="set-telerik-ctrl-width">
                                    </telerik:RadDatePicker>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="dtDateofBirth"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Date of Birth is required."
                                        ErrorMessage="Date of Birth is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label6" runat="server" Text="Social Security:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadMaskedTextBox ID="txtSocialSecurity" runat="server" Mask="###-##-####"
                                        Width="149">
                                    </telerik:RadMaskedTextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" Display="Dynamic"
                                        runat="server" ToolTip="Format is XXX-XX-XXXX" ErrorMessage="Social Security's Format should be XXX-XX-XXXX"
                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtSocialSecurity"
                                        ValidationGroup="PtManagementValidationGroup" ValidationExpression="\d{3}\-\d{2}\-\d{4}">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label7" runat="server" Text="Gender:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbGender" runat="server" Width="200" EmptyMessage="Choose Gender"
                                        AllowCustomText="False" MarkFirstMatch="True">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator0" runat="server" ControlToValidate="cmbGender"
                                        ErrorMessage="Gender is Required" Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                        ToolTip="Gender is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label8" runat="server" Text="Home Phone:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadMaskedTextBox ID="txtHomePhone" runat="server" Mask="(###) ###-####"
                                        Width="149">
                                    </telerik:RadMaskedTextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator0" Display="Dynamic"
                                        runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtHomePhone"
                                        ValidationGroup="PtManagementValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtHomePhone"
                                        Display="Dynamic" ErrorMessage="Home Phone is required." SetFocusOnError="True"
                                        CssClass="failureNotification" ToolTip="Home Phone is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label9" runat="server" Text="Alt Phone:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadMaskedTextBox ID="txtAltPhone" runat="server" Mask="(###) ###-####" Width="149">
                                    </telerik:RadMaskedTextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" Display="Dynamic"
                                        ErrorMessage="Format is (XXX) XXX-XXXX" runat="server" ToolTip="Format is (XXX) XXX-XXXX"
                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtAltPhone"
                                        ValidationGroup="MyinfoValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label10" runat="server" Text="Email:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="regEmail" runat="server" CssClass="failureNotification"
                                        ErrorMessage="Invalid Email" ToolTip="Invalid Email." ControlToValidate="txtEmail"
                                        Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                        ValidationGroup="PtManagementValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label11" runat="server" Text="Primary Address:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label12" runat="server" Text="Street:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPrimaryStreet" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txtPrimaryStreet"
                                        Display="Dynamic" ErrorMessage="Street is required" SetFocusOnError="True" CssClass="failureNotification"
                                        ToolTip="Street is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label13" runat="server" Text="Apt/Suite:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPrimaryAptSuite" runat="server" MaxLength="30"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label14" runat="server" Text="City:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPrimaryCity" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtPrimaryCity"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="City is required."
                                        ErrorMessage="City is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label15" runat="server" Text="State:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbPrimaryStates" runat="server" Width="160px" EmptyMessage="Choose State..."
                                        AllowCustomText="False" MarkFirstMatch="True" DataTextField="Name" DataValueField="StateTypeID"
                                        MaxHeight="200">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="cmbPrimaryStates"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="State is required."
                                        ErrorMessage="State is required" ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label16" runat="server" Text="Zip Code +4:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPrimaryZipCode1" runat="server" CssClass="zip-code1" MaxLength="5"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="txtPrimaryZipCode1"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Zip Code 1 is required."
                                        ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtPrimaryZipCode1"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                        ErrorMessage="Invalid Zip Code 1" ToolTip="Invalid Zip Code 1" ValidationGroup="PtManagementValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="Label17" runat="server" Text="-"></asp:Label>
                                    <asp:TextBox ID="txtPrimaryZipCode2" runat="server" CssClass="zip-code2" MaxLength="4"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="txtPrimaryZipCode2"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{4}$"
                                        ErrorMessage="Invalid Zip Code 2" ToolTip="Invalid Zip Code 2" ValidationGroup="PtManagementValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    Preferences:
                                </div>
                                <div class="editor-field">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label18" runat="server" Text="Financial Responsibility:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbFinancialResponsibility" runat="server" Width="155px"
                                        AutoPostBack="True" AllowCustomText="False" MarkFirstMatch="True" Filter="StartsWith"
                                        MaxHeight="200" OnSelectedIndexChanged="cmbFinancialResponsibility_SelectedIndexChanged">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="cmbFinancialResponsibility"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Financial Responsibility is required."
                                        ErrorMessage="Financial Responsibility is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label19" runat="server" Text="Statements:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbStatements" runat="server" Width="155px" AllowCustomText="False"
                                        AutoPostBack="True" OnSelectedIndexChanged="cmbStatements_SelectedIndexChanged"
                                        MarkFirstMatch="True" Filter="StartsWith" MaxHeight="200">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" ControlToValidate="cmbStatements"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Statements is required."
                                        ErrorMessage="Statement is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    &nbsp;
                                </div>
                                <div class="editor-field">
                                    <asp:CheckBox ID="chkEmailMyStatements" Text="Email My Statements" runat="server" />
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label29" runat="server" Text="Login PIN Code:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPincode" MaxLength="8" runat="server"></asp:TextBox>
                                    <asp:CustomValidator ID="CustomValidator1" CssClass="failureNotification" runat="server"
                                        ControlToValidate="txtPincode" ClientValidationFunction="validatePincode" ValidateEmptyText="True"
                                        ValidationGroup="PtManagementValidationGroup" Display="Dynamic" ErrorMessage="PIN number must be valid"
                                        ToolTip="PIN number must be valid">*</asp:CustomValidator>
                                </div>
                            </div>
                        </td>
                        <td>
                        </td>
                        <td valign="top">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label20" runat="server" Text="Location:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbLocations" runat="server" Width="200" EmptyMessage="Choose Location"
                                        AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="LocationID"
                                        MaxHeight="200">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ControlToValidate="cmbLocations"
                                        Display="Dynamic" ErrorMessage="Location is required." SetFocusOnError="True"
                                        CssClass="failureNotification" ToolTip="Location is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label21" runat="server" Text="Provider:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbProviders" runat="server" Width="200" EmptyMessage="Choose Provider"
                                        AllowCustomText="False" MarkFirstMatch="True" DataTextField="ProviderAbbr" DataValueField="ProviderID"
                                        MaxHeight="200">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" ControlToValidate="cmbProviders"
                                        Display="Dynamic" ErrorMessage="Provider is required." SetFocusOnError="True"
                                        CssClass="failureNotification" ToolTip="Provider is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    Guardian Information:
                                </div>
                                <div class="editor-field">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label22" runat="server" Text="First Name:"></asp:Label>
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
                                    <asp:Label ID="Label23" runat="server" Text="Last Name:"></asp:Label>
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
                                    <asp:Label ID="Label24" runat="server" Text="Relationship:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbRelationship" runat="server" Width="200" AllowCustomText="False"
                                        MarkFirstMatch="True" DataTextField="RelationAbbr" DataValueField="RelTypeID"
                                        MaxHeight="200">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" ControlToValidate="cmbRelationship"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Relationship is required."
                                        ErrorMessage="Relationship is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label25" runat="server" Text="Date of Birth:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadDatePicker ID="dtGuardianDateofBirth" MinDate="1900/1/1" runat="server"
                                        CssClass="set-telerik-ctrl-width">
                                    </telerik:RadDatePicker>
                                    <asp:RequiredFieldValidator ID="rfvGuardianDateofBirth" runat="server" Enabled="False"
                                        ErrorMessage="Date of Birth is required." ControlToValidate="dtGuardianDateofBirth"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Date of Birth is required."
                                        ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label26" runat="server" Text="Social Security:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadMaskedTextBox ID="txtGuardianSSN" runat="server" Mask="###-##-####" Width="149">
                                    </telerik:RadMaskedTextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator5" Display="Dynamic"
                                        runat="server" ToolTip="Format is XXX-XX-XXXX" SetFocusOnError="True" CssClass="failureNotification"
                                        ErrorMessage="Format is XXX-XX-XXXX" ControlToValidate="txtGuardianSSN" ValidationGroup="PtManagementValidationGroup"
                                        ValidationExpression="\d{3}\-\d{2}\-\d{4}">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label27" runat="server" Text="Gender:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbGuardianGender" runat="server" Width="200" EmptyMessage="Choose Gender"
                                        AllowCustomText="False" MarkFirstMatch="True">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="rfvGuardianGender" runat="server" Enabled="False"
                                        ControlToValidate="cmbGuardianGender" Display="Dynamic" SetFocusOnError="True"
                                        ErrorMessage="Gender is required" CssClass="failureNotification" ToolTip="Gender is required."
                                        ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label28" runat="server" Text="Phone:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadMaskedTextBox ID="txtGuardianPhone" runat="server" Mask="(###) ###-####"
                                        Width="149">
                                    </telerik:RadMaskedTextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator6" Display="Dynamic"
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
                                    <asp:TextBox ID="txtGuardianEmail" runat="server"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator7" runat="server" CssClass="failureNotification"
                                        ToolTip="Invalid Email." ControlToValidate="txtGuardianEmail" Display="Dynamic"
                                        ErrorMessage="Inavlid Email" SetFocusOnError="true" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                        ValidationGroup="PtManagementValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Address:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbGuardianAddress" runat="server" Width="155px" AllowCustomText="False"
                                        AutoPostBack="True" OnSelectedIndexChanged="cmbGuardianAddress_SelectedIndexChanged"
                                        MarkFirstMatch="True" Filter="StartsWith" MaxHeight="200">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="cmbGuardianAddress"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Address is required."
                                        ErrorMessage="Address is required." ValidationGroup="PtManagementValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
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
                                    <telerik:RadComboBox ID="cmbSecondaryStates" runat="server" Width="149px" EmptyMessage="Choose State..."
                                        AllowCustomText="False" MarkFirstMatch="True" DataTextField="Name" DataValueField="StateTypeID"
                                        MaxHeight="200">
                                    </telerik:RadComboBox>
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
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator" runat="server" ControlToValidate="txtAltZipCode1"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                        ErrorMessage="Invalid Zip Code 1" ToolTip="Invalid Zip Code 1" ValidationGroup="PtManagementValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                                <div class="editor-field">
                                    <asp:Label runat="server" Text="-"></asp:Label>
                                    <asp:TextBox ID="txtAltZipCode2" runat="server" CssClass="zip-code2" MaxLength="4"></asp:TextBox>
                                    <asp:RegularExpressionValidator runat="server" ControlToValidate="txtAltZipCode2"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{4}$"
                                        ToolTip="Invalid Zip Code 2" ValidationGroup="PtManagementValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    &nbsp;
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    &nbsp;
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    &nbsp;
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <label>
                                        &nbsp;</label></div>
                                <div class="editor-field" style="padding-left: 8px;">
                                    <asp:ImageButton ID="btnUpdate" runat="server" ImageUrl="../Content/Images/btn_update.gif"
                                        OnClick="btnUpdate_Click" CssClass="btn-submit" ValidationGroup="PtManagementValidationGroup" />
                                    <asp:ImageButton ID="btnCancel" runat="server" ImageUrl="../Content/Images/btn_cancel.gif"
                                        OnClientClick="closePopup()" CssClass="btn-cancel" />
                                </div>
                            </div>
                            <asp:ValidationSummary runat="server" ValidationGroup="PtManagementValidationGroup"
                                Style="margin-left: 168px;" EnableClientScript="True" DisplayMode="BulletList"
                                ShowSummary="True" CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                            <div class="success-message">
                                <asp:Literal ID="litMessage" runat="server"></asp:Literal></div>
                        </td>
                    </tr>
                </table>
            </div>
            <telerik:RadWindowManager ID="windowManager" Behaviors="Move" Style="z-index: 200001"
                ShowContentDuringLoad="False" VisibleStatusbar="False" VisibleTitlebar="True"
                ReloadOnShow="True" runat="Server" Modal="True" EnableEmbeddedBaseStylesheet="True"
                EnableEmbeddedSkins="False" Skin="CareBlueInf">
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
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript" language="javascript">
        
        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }

        function closePopup() {
            GetRadWindow().close();
        }


        function redirectPage() {
            GetRadWindow().BrowserWindow.redirectToStatus();
            closePopup();
        }


        function validatePincode(sender, args) {
            if (args.Value.trim().length >= 4 && args.Value.trim().length <= 8) {
                args.IsValid = true;
            } else {
                args.IsValid = false;
            }
        }

    </script>
    </form>
</body>
</html>
