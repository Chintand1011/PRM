<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="config.aspx.cs"
    Inherits="config" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelConfiguartion" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Update Configuration</h1>
            </div>
            <div class="bodyMain">
                <h2>Set practice information and configuration defaults on this page.</h2>
                <table width="100%">
                    <tr>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td width="50%" valign="top">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label2" runat="server">Login ID:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtLoginID" Enabled="True" Width="194px" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label3" runat="server">Pratice Name:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPracticeName" Enabled="True" Width="194px" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label1" runat="server">Name Abbreviation:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtNameAbbreviation" Enabled="True" Width="194px" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label5" runat="server">Practice EIN:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtPracticeEIN" Enabled="True" Width="194px" runat="server"></asp:TextBox>
                                    <asp:RegularExpressionValidator  ControlToValidate="txtPracticeEIN" ToolTip="Practice EIN should be numeric"  ValidationGroup="Configuration"
                                                runat="server" ErrorMessage="Practice EIN should be numeric" CssClass="failureNotification" SetFocusOnError="True"
                                                Display="Dynamic" ValidationExpression="[0-9]*\.?[0-9]*">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label21" runat="server">Check Payable To:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtCheckPayableTo" Enabled="True" Width="194px" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <br />
                            &nbsp;
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label15" runat="server">Address 1:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtAddress1" MaxLength="50" Width="194px" runat="server"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtAddress1"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Address1 is required."
                                        ErrorMessage="Address1 is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label16" runat="server">Address 2:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtAddress2" MaxLength="50" Width="194px" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label17" runat="server">City:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtCity" runat="server" Width="194px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtCity"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="City is required."
                                        ErrorMessage="City is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label18" runat="server">State:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbStates" runat="server" width="200px" emptymessage="Choose State..."
                                        allowcustomtext="False" markfirstmatch="True" datatextfield="Name" datavaluefield="StateTypeID"
                                        maxheight="200">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="cmbStates"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="State is required."
                                        ErrorMessage="State is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
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
                                        ErrorMessage="Invalid Zip Code 1" ToolTip="Invalid Zip Code 1" ValidationGroup="Configuration">*</asp:RegularExpressionValidator>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="Label20" runat="server" Text="-"></asp:Label>
                                    <asp:TextBox ID="txtZipCode2" runat="server" CssClass="zip-code2" MaxLength="4"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtZipCode2"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{4}$"
                                        ToolTip="Invalid Zip Code 2" ErrorMessage="Invalid Zip Code 2" ValidationGroup="Configuration">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label4" runat="server" Text="Main Phone:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radmaskedtextbox id="txtMainPhone" runat="server" mask="(###) ###-####"
                                        width="149">
                                    </telerik:radmaskedtextbox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtMainPhone"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Main Phone is required."
                                        ErrorMessage="Main Phone is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" Display="Dynamic"
                                        runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtMainPhone"
                                        ValidationGroup="Configuration" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label11" runat="server" Text="Billing Phone:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radmaskedtextbox id="txtBillingPhone" runat="server" mask="(###) ###-####"
                                        width="149">
                                    </telerik:radmaskedtextbox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtBillingPhone"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Billing Phone is required."
                                        ErrorMessage="Billing Phone is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" Display="Dynamic"
                                        runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtBillingPhone"
                                        ValidationGroup="Configuration" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label7" runat="server">Fax Number:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radmaskedtextbox id="txtFaxNumber" runat="server" mask="(###) ###-####"
                                        width="149">
                                    </telerik:radmaskedtextbox>
                                </div>
                            </div>
                            <br />
                            &nbsp;

                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label10" runat="server">Internal Notes:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtNotes" TextMode="MultiLine" Width="350px" Height="90px" CssClass="textarea"
                                        runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <br />
                            &nbsp;
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label33" runat="server">Patient Search Behavior:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:CheckBox ID="chkActiveSearch" runat="server" />
                                    Only Active Patients by Default
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label35" runat="server">&nbsp;</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:CheckBox ID="chkLocationSearch" runat="server" />
                                    Only Assigned Location by Default
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label34" runat="server">&nbsp;</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:CheckBox ID="chkProviderSearch" runat="server" />
                                    Only Assigned Provider by Default
                                </div>
                            </div>

                        </td>
                        <td width="50%" valign="top">
                            <div class="contactWrap">
                                <fieldset style="margin: -20px 80px 10px 20px; padding: 5px;">
                                    <legend style="padding: 0px; margin-left: 10px;"><b>&nbsp; Revenue Options &nbsp;</b></legend>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label8" runat="server">NSF Check Fee:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtNSFCheckFee" maxlength="5" type="Currency"
                                                numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                            </telerik:radnumerictextbox>
                                            <asp:RangeValidator ID="RangeValidator10" ControlToValidate="txtNSFCheckFee" Display="Dynamic"
                                                ToolTip="The maximum allowed returned check fee is $39.00." ErrorMessage="The maximum allowed returned check fee is $39.00."
                                                SetFocusOnError="True" Type="Double" MinimumValue="0.00" MaximumValue="39" ValidationGroup="Configuration"
                                                CssClass="failureNotification" runat="server">*</asp:RangeValidator>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtNSFCheckFee"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="NSF Check Fee is required."
                                                ErrorMessage="NSF Check Fee is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="revDigits" ControlToValidate="txtNSFCheckFee" ValidationGroup="Configuration"
                                                runat="server" ErrorMessage="*" CssClass="failureNotification" SetFocusOnError="True"
                                                Display="Dynamic" ValidationExpression="[0-9]*\.?[0-9]*"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label30" runat="server">Late Statement Fee:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtLatePayStatement" maxlength="5"
                                                type="Currency" numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                            </telerik:radnumerictextbox>
                                            <asp:RangeValidator ID="RangeValidator11" ControlToValidate="txtLatePayStatement"
                                                Display="Dynamic" ToolTip="The maximum allowed late statement fee is $39.00." ErrorMessage="The maximum allowed late statement fee is $39.00."
                                                SetFocusOnError="True" Type="Double" MinimumValue="0.00" MaximumValue="39" ValidationGroup="Configuration"
                                                CssClass="failureNotification" runat="server">*</asp:RangeValidator>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="txtLatePayStatement"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Statement Fee is required."
                                                ErrorMessage="Statement Fee is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator7" ControlToValidate="txtLatePayStatement" ValidationGroup="Configuration"
                                                runat="server" ErrorMessage="*" CssClass="failureNotification" SetFocusOnError="True"
                                                Display="Dynamic" ValidationExpression="[0-9]*\.?[0-9]*"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label31" runat="server">Late BlueCredit Fee:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtLatePayBlueCredit" maxlength="5"
                                                type="Currency" numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                            </telerik:radnumerictextbox>
                                            <asp:RangeValidator ID="RangeValidator12" ControlToValidate="txtLatePayBlueCredit"
                                                Display="Dynamic" ToolTip="The maximum allowed late BlueCredit fee is $39.00." ErrorMessage="The maximum allowed late BlueCredit fee is $39.00."
                                                SetFocusOnError="True" Type="Double" MinimumValue="0.00" MaximumValue="39" ValidationGroup="Configuration"
                                                CssClass="failureNotification" runat="server">*</asp:RangeValidator>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="txtLatePayBlueCredit"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="BlueCredit Fee is required."
                                                ErrorMessage="BlueCredit Fee is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator8" ControlToValidate="txtLatePayBlueCredit" ValidationGroup="Configuration"
                                                runat="server" ErrorMessage="*" CssClass="failureNotification" SetFocusOnError="True"
                                                Display="Dynamic" ValidationExpression="[0-9]*\.?[0-9]*"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label9" runat="server">UCR Multiplier:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtUCRMultiplier" maxlength="4" type="Number"
                                                numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                            </telerik:radnumerictextbox>
                                            <asp:RangeValidator ID="RangeValidator1" ControlToValidate="txtUCRMultiplier" Display="Dynamic"
                                                ToolTip="UCR Multiplier should between 0.01 to 10.00" ErrorMessage="UCR Multiplier should between 0.01 to 10.00"
                                                SetFocusOnError="True" Type="Double" MinimumValue="0.01" MaximumValue="10" ValidationGroup="Configuration"
                                                CssClass="failureNotification" runat="server">*</asp:RangeValidator>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtUCRMultiplier"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="UCR Multiplier is required."
                                                ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator5" ControlToValidate="txtUCRMultiplier" ValidationGroup="Configuration"
                                                runat="server" ErrorMessage="*" CssClass="failureNotification" SetFocusOnError="True"
                                                Display="Dynamic" ValidationExpression="[0-9]*\.?[0-9]*"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label29" runat="server">CMS Multiplier:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtCMSMultiplier" maxlength="4" type="Number"
                                                numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                            </telerik:radnumerictextbox>
                                            <asp:RangeValidator ID="RangeValidator9" ControlToValidate="txtCMSMultiplier" Display="Dynamic"
                                                ToolTip="CMS Multiplier should between 0.01 to 10.00" ErrorMessage="CMS Multiplier should between 0.01 to 10.00"
                                                SetFocusOnError="True" Type="Double" MinimumValue="0.01" MaximumValue="10" ValidationGroup="Configuration"
                                                CssClass="failureNotification" runat="server">*</asp:RangeValidator>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="txtCMSMultiplier"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="CMS Multiplier is required."
                                                ErrorMessage="CMS Multiplier is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator6" ControlToValidate="txtCMSMultiplier" ValidationGroup="Configuration"
                                                runat="server" ErrorMessage="*" CssClass="failureNotification" SetFocusOnError="True"
                                                Display="Dynamic" ValidationExpression="[0-9]*\.?[0-9]*"></asp:RegularExpressionValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label41" runat="server">Offer CMS Surveys:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbOfferCMSSurvey" runat="server" width="80px" emptymessage="Choose Offer CMS Surveys..."
                                                allowcustomtext="False" markfirstmatch="True" maxheight="200">
                                                </telerik:radcombobox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ControlToValidate="cmbOfferCMSSurvey"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Offer CMS Surveys is required."
                                                ErrorMessage="Offer CMS Surveys is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </fieldset>
                            </div>
                            <div class="contactWrap">
                                <fieldset style="margin: 0px 80px 10px 20px; padding: 5px;">
                                    <legend style="padding: 0px; margin-left: 10px;"><b>&nbsp; Payment Plan Options &nbsp;</b></legend>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label22" runat="server">Accept Payment Plans:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbAcceptPaymentPlans" runat="server" width="80px" emptymessage="Choose Accept Payment Plan..."
                                                allowcustomtext="False" markfirstmatch="True" autopostback="True" onselectedindexchanged="cmbAcceptPaymentPlans_OnSelectedIndexChanged"
                                                maxheight="200">
                                                </telerik:radcombobox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="cmbAcceptPaymentPlans"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Accept Payment Plans is required."
                                                ErrorMessage="Accept Payment Plans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label12" runat="server">Payment Plan Web Access:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbPaymentPlanWebAccess" runat="server" width="80px" emptymessage="Payment Plan Web Access..."
                                                allowcustomtext="False" markfirstmatch="True" maxheight="200">
                                                </telerik:radcombobox>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label39" runat="server">Payment Plan Fee:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtPPFee" type="Currency"
                                                numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                                </telerik:radnumerictextbox>
                                            <asp:RangeValidator ID="RangeValidator17" ControlToValidate="txtPPFee"
                                                Display="Dynamic" ToolTip="Payment plan fee should be between zero and $10.00" ErrorMessage="Payment plan fee should be between zero and $10.00"
                                                SetFocusOnError="True" MinimumValue="0" Type="Double" MaximumValue="10" ValidationGroup="Configuration"
                                                CssClass="failureNotification" runat="server">*</asp:RangeValidator>
                                            <asp:RequiredFieldValidator ID="rqdPPFee" runat="server" ControlToValidate="txtPPFee"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Payment plan fee is required."
                                                ErrorMessage="Payment plan fee is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>

                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label6" runat="server">Minimum to Qualify:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtMinimumToQualify" type="Currency"
                                                numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                                </telerik:radnumerictextbox>
                                            <asp:RangeValidator ID="RangeValidator2" ControlToValidate="txtMinimumToQualify"
                                                Display="Dynamic" ToolTip="Minimum to qualify for payment plans should between $50 and $1,000." ErrorMessage="Minimum to qualify for payment plans should between $50 and $1,000."
                                                SetFocusOnError="True" MinimumValue="50" Type="Double" MaximumValue="1000" ValidationGroup="Configuration"
                                                CssClass="failureNotification" runat="server">*</asp:RangeValidator>
                                            <asp:RequiredFieldValidator ID="rqdMinimumToQualify" runat="server" ControlToValidate="txtMinimumToQualify"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Minimum to qualify for payment plans is required."
                                                ErrorMessage="Minimum to qualify for payment plans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label32" runat="server">Maximum to Qualify:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtMaximumToQualify" type="Currency"
                                                numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                                </telerik:radnumerictextbox>

                                            <asp:RequiredFieldValidator ID="rqdMaximumToQualify" runat="server" ControlToValidate="txtMaximumToQualify"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Maximum to qualify for payment plans is required."
                                                ErrorMessage="Maximum to qualify for payment plans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>

                                            <asp:CustomValidator CssClass="failureNotification" runat="server"
                                                ControlToValidate="txtMaximumToQualify" ClientValidationFunction="validatePlanMaximumAmount" ValidateEmptyText="True"
                                                ValidationGroup="Configuration" Display="Dynamic" ErrorMessage="Maximum to qualify for payment plans should be $500 more than plan minimum and less than $10,000."
                                                ToolTip="Maximum to qualify for payment plans should be $500 more than plan minimum and less than $10,000.">*</asp:CustomValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label38" runat="server">Minimum Down Dollars:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtMinimumDPDollar" type="Currency"
                                                numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                                </telerik:radnumerictextbox>

                                            <asp:RequiredFieldValidator ID="rqdMinimumDPDollar" runat="server" ControlToValidate="txtMinimumDPDollar"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Minimum down payment for payment plans is required."
                                                ErrorMessage="Minimum down payment for payment plans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>

                                            <asp:CustomValidator CssClass="failureNotification" runat="server"
                                                ControlToValidate="txtMinimumDPDollar" ClientValidationFunction="validateMinimumDownDollarAmount" ValidateEmptyText="True"
                                                ValidationGroup="Configuration" Display="Dynamic" ErrorMessage="Down payment minimum for payment plans should be between zero and $500 less than the plan maximum."
                                                ToolTip="Down payment minimum for payment plans should be between zero and $500 less than the plan maximum.">*</asp:CustomValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label37" runat="server">Minimum Down Rate:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtMinimumDPRate" type="Percent"
                                                numberformat-decimaldigits="1" numberformat-groupseparator=",">
                                                </telerik:radnumerictextbox>
                                            <asp:RangeValidator ID="RangeValidator15" ControlToValidate="txtMinimumDPRate"
                                                Display="Dynamic" Type="Double" ToolTip="Minimum down payment rate for payment plans should be between 0% and 80%."
                                                ErrorMessage="Minimum down payment rate for payment plans should be between 0% and 80%." SetFocusOnError="True"
                                                MinimumValue="0" MaximumValue="50" ValidationGroup="Configuration" CssClass="failureNotification"
                                                runat="server">*</asp:RangeValidator>
                                            <asp:RequiredFieldValidator ID="rqdMinimumDPRate" runat="server" ControlToValidate="txtMinimumDPRate"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Minimum down payment rate for payment plans is required."
                                                ErrorMessage="Minimum down payment rate for payment plans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label14" runat="server">Minimum Payment:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtMinimumPayment" type="Currency"
                                                numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                                </telerik:radnumerictextbox>
                                            <asp:RequiredFieldValidator ID="rqdMinimumPayment" runat="server" ControlToValidate="txtMinimumPayment"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Minimum payment for payment plans is required."
                                                ErrorMessage="Minimum payment for payment plans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                            <asp:CompareValidator ControlToValidate="txtMinimumPayment" ControlToCompare="txtMinimumToQualify" Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationGroup="Configuration"
                                                Type="Double" Operator="LessThan" ErrorMessage="Minimum payment per period for payment plans should less than the plan minimum." ToolTip="Minimum payment per period for payment plans should less than the plan minimum." runat="server">*</asp:CompareValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label24" runat="server">Maximum Plan Periods:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radtextbox id="txtMaximumPlanPeriods" runat="server" inputtype="Number">
                                                </telerik:radtextbox>
                                            <asp:RangeValidator ID="RangeValidator4" ControlToValidate="txtMaximumPlanPeriods"
                                                Display="Dynamic" ToolTip="Maximum periods for payment plans should between 3 to 72." ErrorMessage="Maximum periods for payment plans should between 3 to 72."
                                                SetFocusOnError="True" MinimumValue="3" Type="Integer" MaximumValue="72" ValidationGroup="Configuration"
                                                CssClass="failureNotification" runat="server">*</asp:RangeValidator>
                                            <asp:RequiredFieldValidator ID="rqdMaximumPlanPeriods" runat="server" ControlToValidate="txtMaximumPlanPeriods"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Maximum periods for payment plans is required."
                                                ErrorMessage="Maximum periods for payment plans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                          
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label36" runat="server">Minimum Credit Score:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radtextbox id="txtMinimumPPPFSRecord" runat="server" inputtype="Number">
                                                </telerik:radtextbox>
                                            <asp:RangeValidator ID="RangeValidator14" ControlToValidate="txtMinimumPPPFSRecord"
                                                Display="Dynamic" Type="Integer" ToolTip="Minimum credit score for payment plans should between 400 and 850."
                                                ErrorMessage="Minimum credit score for payment plans should between 400 and 850." SetFocusOnError="True"
                                                MinimumValue="400" MaximumValue="850" ValidationGroup="Configuration" CssClass="failureNotification"
                                                runat="server">*</asp:RangeValidator>
                                            <asp:RequiredFieldValidator ID="rqdMinimumPPPFSRecord" runat="server" ControlToValidate="txtMinimumPPPFSRecord"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Minimum credit score for payment plans is required."
                                                ErrorMessage="Minimum credit score for payment plans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                            
                                        </div>
                                    </div>

                                </fieldset>
                            </div>
                            <div class="contactWrap">
                                <fieldset style="margin: 0px 80px 10px 20px; padding: 5px;">
                                    <legend style="padding: 0px; margin-left: 10px;"><b>&nbsp; BlueCredit Options &nbsp;</b></legend>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label40" runat="server">Offer Credit Checks:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbOfferCreditCheck" runat="server" width="80px" emptymessage="Choose Offer Credit Checks..."
                                                allowcustomtext="False" markfirstmatch="True" maxheight="200">
                                                </telerik:radcombobox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" ControlToValidate="cmbOfferCreditCheck"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Offer Credit Checks is required."
                                                ErrorMessage="Offer Credit Checks is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label23" runat="server">Offer BlueCredit:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbOfferBlueCredit" runat="server" width="80px" emptymessage="Choose Offer BlueCredit..."
                                                allowcustomtext="False" markfirstmatch="True" autopostback="True" onselectedindexchanged="cmbOfferBlueCredit_OnSelectedIndexChanged"
                                                maxheight="200">
                                                </telerik:radcombobox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="cmbOfferBlueCredit"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Offer BlueCredit is required."
                                                ErrorMessage="Offer BlueCredit is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="txtLenderFunded" runat="server">Lender-Funded Loans:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbOfferLenderFunded" runat="server" width="80px" emptymessage="Choose Offer Lender Loans..."
                                                allowcustomtext="False" markfirstmatch="True" maxheight="200">
                                                </telerik:radcombobox>
                                            <asp:RequiredFieldValidator ID="rqdLenderFunded" runat="server" ControlToValidate="cmbOfferLenderFunded"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Offer Lender Funded Loans is required."
                                                ErrorMessage="Offer Lender Funded Loans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label13" runat="server">BlueCredit Web Access:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radcombobox id="cmbBlueCreditWebAccess" runat="server" width="80px" emptymessage="BlueCredit Web Access..."
                                                allowcustomtext="False" markfirstmatch="True" maxheight="200">
                                                </telerik:radcombobox>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label25" runat="server">Minimum to Qualify:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtCreditMinimum" type="Currency" numberformat-decimaldigits="2"
                                                numberformat-groupseparator=",">
                                                </telerik:radnumerictextbox>
                                            <asp:RequiredFieldValidator ID="rqdCreditMinimum" runat="server" ControlToValidate="txtCreditMinimum"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Credit minimum for BlueCredit plans is required."
                                                ErrorMessage="Credit minimum for BlueCredit plans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>

                                            <asp:CustomValidator CssClass="failureNotification" runat="server"
                                                ControlToValidate="txtCreditMinimum" ClientValidationFunction="validateCreditMinimumAmount" ValidateEmptyText="True"
                                                ValidationGroup="Configuration" Display="Dynamic" ErrorMessage="Credit minimum for BlueCredit plans should more than $500 and less than the plan maximum."
                                                ToolTip="Credit minimum for BlueCredit plans should more than $500 and less than the plan maximum.">*</asp:CustomValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label26" runat="server">Maximum to Qualify:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtCreditMaximum" type="Currency" numberformat-decimaldigits="2"
                                                numberformat-groupseparator=",">
                                                </telerik:radnumerictextbox>
                                           <asp:RequiredFieldValidator ID="rqdCreditMaximum" runat="server" ControlToValidate="txtCreditMaximum"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Credit maximum for BlueCredit plans is required."
                                                ErrorMessage="Credit maximum for BlueCredit plans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                            
                                             <asp:CustomValidator CssClass="failureNotification" runat="server"
                                                ControlToValidate="txtCreditMaximum" ClientValidationFunction="validateCreditMaximumAmount" ValidateEmptyText="True"
                                                ValidationGroup="Configuration" Display="Dynamic" ErrorMessage="Credit maximum for BlueCredit plans should $500 more than the plan minimum, and up to $100,000."
                                                ToolTip="Credit maximum for BlueCredit plans should $500 more than the plan minimum, and up to $100,000.">*</asp:CustomValidator>

                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label27" runat="server">Minimum Down Payment:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radnumerictextbox runat="server" id="txtMinimumDownPayment" type="Percent"
                                                numberformat-decimaldigits="1" numberformat-groupseparator=",">
                                                </telerik:radnumerictextbox>
                                            <asp:RangeValidator ID="RangeValidator7" ControlToValidate="txtMinimumDownPayment"
                                                Display="Dynamic" Type="Double" ToolTip="Minimum down payment for BlueCredit plans should be between 0% and 80%."
                                                ErrorMessage="Minimum down payment for BlueCredit plans should be between 0% and 80%." SetFocusOnError="True"
                                                MinimumValue="0" MaximumValue="80" ValidationGroup="Configuration" CssClass="failureNotification"
                                                runat="server">*</asp:RangeValidator>
                                            <asp:RequiredFieldValidator ID="rqdMinimumDownPayment" runat="server" ControlToValidate="txtMinimumDownPayment"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Minimum down payment for BlueCredit plans is required."
                                                ErrorMessage="Minimum down payment for BlueCredit plans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label ID="Label28" runat="server">Minimum Credit Score:</asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:radtextbox id="txtMinimumPFSRecord" runat="server" inputtype="Number">
                                                </telerik:radtextbox>
                                            <asp:RangeValidator ID="RangeValidator8" ControlToValidate="txtMinimumPFSRecord"
                                                Display="Dynamic" Type="Integer" ToolTip="Minimum credit score for BlueCredit plans should between 400 and 850."
                                                ErrorMessage="Minimum credit score for BlueCredit plans should between 400 and 850." SetFocusOnError="True"
                                                MinimumValue="400" MaximumValue="850" ValidationGroup="Configuration" CssClass="failureNotification"
                                                runat="server">*</asp:RangeValidator>
                                            <asp:RequiredFieldValidator ID="rqdMinimumPFSRecord" runat="server" ControlToValidate="txtMinimumPFSRecord"
                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Minimum credit score for BlueCredit plans is required."
                                                ErrorMessage="Minimum credit score for BlueCredit plans is required." ValidationGroup="Configuration">*</asp:RequiredFieldValidator>
                                            
                                        </div>
                                    </div>
                                </fieldset>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right">
                            &nbsp; <br />
                            <asp:ImageButton ID="ImageButton1" CssClass="btn-cancel" ImageUrl="../Content/Images/btn_cancel.gif"
                                OnClientClick="return showMessage()" runat="server" />
                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
                            <asp:ImageButton ID="btnUpdate" CssClass="btn-update" ImageUrl="../Content/Images/btn_update.gif" Style="margin-right:30px;"
                                Text="Update" runat="server" OnClick="btnUpdate_Click" ValidationGroup="Configuration" />
                            
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div id="divSuccessMessage" class="success-message" style="text-align: right">
                                <asp:Literal ID="litMessage" Text="" runat="server"></asp:Literal>
                            </div>
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Configuration"
                                ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                CssClass="failureNotification" HeaderText="Please correct the following issues: -" />
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
                                <a href="javascript:;" onclick="$find('{0}').close(true);">
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
    <script type="text/javascript" language="javascript">

        function showMessage() {
            var radWindow = $find("<%=RadWindow.ClientID %>");
            radWindow.radalert('Update abandoned and original values have been loaded.', 380, 100, '', refreshPage, '../Content/Images/success.png');
            return false;
        }

        function validatePlanMaximumAmount(sender, args) {

            var minimumPlan = $find("<%=txtMinimumToQualify.ClientID%>");
            var minPlanValue = parseFloat(minimumPlan.get_value()) + 500;
            var maximumPlanValue = parseFloat(args.Value);
            args.IsValid = maximumPlanValue > minPlanValue && maximumPlanValue <= 10000;
        }

        function validateMinimumDownDollarAmount(sender, args) {

            var maximumPlan = $find("<%=txtMaximumToQualify.ClientID%>");
            var maxPlanValue = parseFloat(maximumPlan.get_value()) - 500;
            var minDownDollar = parseFloat(args.Value);
            args.IsValid = minDownDollar < maxPlanValue;
        }

        function validateCreditMinimumAmount(sender, args) {

            var maximumPlan = $find("<%=txtMaximumToQualify.ClientID%>");
            var maxPlanValue = parseFloat(maximumPlan.get_value());
            var creditMin = parseFloat(args.Value);
            args.IsValid = creditMin < maxPlanValue && creditMin >= 500;
        }

        function validateCreditMaximumAmount(sender, args) {

            var minimumPlan = $find("<%=txtMinimumToQualify.ClientID%>");
            var minPlanValue = parseFloat(minimumPlan.get_value()) + 500;
            var creditMax = parseFloat(args.Value);
            args.IsValid = creditMax > minPlanValue && creditMax <= 100000;
        }


    </script>
</asp:Content>