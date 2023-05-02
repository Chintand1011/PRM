<%@ Page Language="C#" AutoEventWireup="true" CodeFile="pc_add_popup_lite.aspx.cs"
    Inherits="pc_add_popup_lite" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <telerik:radscriptmanager id="RadScriptManager1" runat="server">
        </telerik:radscriptmanager>
        <asp:UpdatePanel ID="updPanelEligility" runat="server">
            <ContentTemplate>
                <div>
                    <table class="CareBluePopup">
                        <tr>
                            <td>
                                <h2p>Payment Processing Window</h2p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <h4p>Select patient and statement before entering details. If using the card reader, swipe first before entering info.</h4p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <br />
                                    <div>
                                        <asp:RadioButton ID="rdSwipeCard" Text="Swipe Card" GroupName="Card" Checked="True"
                                            AutoPostBack="True" OnCheckedChanged="ManagePaymentModes" runat="server" />
                                        <asp:RadioButton ID="rdKeyCard" Text="Key Card" GroupName="Card" AutoPostBack="True"
                                            OnCheckedChanged="ManagePaymentModes" runat="server" />
                                        <asp:RadioButton ID="rdCardOnFile" Text="Card On File" GroupName="Card" AutoPostBack="True"
                                            OnCheckedChanged="ManagePaymentModes" runat="server" />
                                        <asp:RadioButton ID="rdSaveCard" Text="Save Card" GroupName="Card" AutoPostBack="True"
                                            Visible="False" Enabled="False" OnCheckedChanged="ManagePaymentModes" runat="server" />
                                        <asp:RadioButton ID="rdTransaction" Text="Other Transaction" GroupName="Card" AutoPostBack="True"
                                            OnCheckedChanged="ManagePaymentModes" runat="server" />
                                        <asp:HiddenField ID="hdnValidate" runat="server" />
                                    </div>
                                    <div class="align-popup-fields" style="margin-top: 15px">
                                        <div class="form-row">
                                            <div class="editor-label" style="margin: 2px 6px 0 -60px;">
                                                <asp:Label runat="server">Patient:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:radcombobox id="cmbPatients" runat="server" emptymessage="Choose Patient..." allowcustomtext="False" markfirstmatch="True" autopostback="True" width="300px" itemrequesttimeout="500"
                                                    datatextfield="ComboBoxAbbr" datavaluefield="PatientID" maxheight="200" onitemsrequested="cmbPatients_ItemsRequested" onselectedindexchanged="cmbPatients_OnSelectedIndexChanged">
                                                </telerik:radcombobox>
                                                <asp:RequiredFieldValidator ID="rqdPatient" runat="server" ControlToValidate="cmbPatients"
                                                    Enabled="False" SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification"
                                                    ToolTip="Patient is required" ErrorMessage="Patient is required" ValidationGroup="SwipeCardValidationGroup">*</asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="editor-label" style="margin: 2px 6px 0 -60px;">
                                                <asp:Label ID="Label25" runat="server">Statement:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:radcombobox id="cmbStatements" runat="server" emptymessage="Choose Statement..."
                                                    allowcustomtext="False" markfirstmatch="True" autopostback="True" width="300px"
                                                    onselectedindexchanged="cmbStatements_OnSelectedIndexChanged" datatextfield="ComboBoxAbbr"
                                                    datavaluefield="StatementID" maxheight="200">
                                                </telerik:radcombobox>
                                                <asp:RequiredFieldValidator ID="rqdStatements" runat="server" ControlToValidate="cmbStatements"
                                                    Enabled="False" SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification"
                                                    ToolTip="Statement is required" ErrorMessage="Statement is required" ValidationGroup="SwipeCardValidationGroup">*</asp:RequiredFieldValidator>
                                            </div>
                                        </div>
                                        <div class="form-row" runat="server" id="divDescriptionDropdown" visible="False">
                                            <div class="editor-label" style="margin: 2px 6px 0 -60px;">
                                                <asp:Label ID="Label5" runat="server">Description:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:radcombobox id="cmbDescription" runat="server" emptymessage="Choose Description..."
                                                    allowcustomtext="True" maxlength="60" markfirstmatch="True" width="300px"
                                                    maxheight="200">
                                                </telerik:radcombobox>
                                                <asp:CustomValidator ID="cstmValidatorDescription" runat="server" ControlToValidate="cmbDescription"
                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Invalid Description, must be 3 chars long."
                                                    ValidateEmptyText="True" ClientValidationFunction="validateDescription" ErrorMessage="Invalid Description, must be 3 chars long."
                                                    ValidationGroup="SwipeCardValidationGroup">*</asp:CustomValidator>
                                            </div>
                                        </div>
                                        &nbsp;
                                    </div>
                                    <div style="border-top: 1px solid grey; width: 100%; margin-top: -5px;">
                                    </div>
                                    <asp:Panel ID="pnlSwipeCard" Visible="True" runat="server">

                                        <table border="0" width="100%">
                                            <tr>
                                                <td>
                                                    <table class="tblLables">
                                                        <tr style="height: 70px;">
                                                            <td width="130" valign="bottom" align="right">
                                                                <a href="javascript:;">
                                                                    <asp:Image ID="imgSwipeCard" onclick="resetAll()" Width="102px" runat="server" /></a>
                                                                <asp:TextBox ID="txtMagTek" MaxLength="1000" onblur="changeSwipImage(this)" onkeypress="return enterEvent(event)"
                                                                    runat="server" Style="float: right; border: 0; background-color: #fff;" Width="0" Height="1"
                                                                    EnableViewState="True" Visible="True" Wrap="False">
                                                                </asp:TextBox>
                                                            </td>
                                                            <td width="190" valign="bottom" align="left">
                                                                <asp:Image ID="imgcards" ImageUrl="~/Content/images/icon_paymentcard_none.jpg" Width="150px"
                                                                    Style="vertical-align: bottom; margin-bottom: -1px;" runat="server" />
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtMagtek"
                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Swipe card."
                                                                    ErrorMessage="Please swipe card before processing charge." ValidationGroup="SwipeCardValidationGroup">*
                                                                </asp:RequiredFieldValidator>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label70" CssClass="lblInputR" runat="server" Text="First Name:"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtPatientFirstName" runat="server" MaxLength="30" Width="160"></asp:TextBox>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator17" runat="server" ControlToValidate="txtPatientFirstName"
                                                                    Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="First Name is required."
                                                                    ErrorMessage="First Name is required." ValidationGroup="SwipeCardValidationGroup">*</asp:RequiredFieldValidator>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label71" CssClass="lblInputR" runat="server" Text="Last Name:"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtPatientLastName" runat="server" MaxLength="30" Width="160"></asp:TextBox>
                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator19" runat="server" ControlToValidate="txtPatientLastName"
                                                                    Display="Dynamic" ErrorMessage="Last Name is required." SetFocusOnError="True"
                                                                    CssClass="failureNotification" ToolTip="Last Name is required." ValidationGroup="SwipeCardValidationGroup">*</asp:RequiredFieldValidator>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label4" CssClass="lblInputR" Text="Zip:" runat="server"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:TextBox ID="txtZip" runat="server" MaxLength="5" Width="94"></asp:TextBox>
                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator11" runat="server"
                                                                    ControlToValidate="txtZip" Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                                    ValidationExpression="^[0-9]{5}$" ToolTip="Invalid Zip Code " ErrorMessage="Invalid Zip Code "
                                                                    ValidationGroup="SwipeCardValidationGroup">*</asp:RegularExpressionValidator>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label6" CssClass="lblInputR" Text="Card Last 4:" runat="server"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblCardLast4" runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label7" CssClass="lblInputR" Text="Exp Month" runat="server"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblExpMonth" runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label8" CssClass="lblInputR" Text="Exp Year" runat="server"></asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblExpYear" runat="server"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label1" CssClass="lblInputR" runat="server">Amount:</asp:Label>
                                                            </td>
                                                            <td>
                                                                <telerik:radnumerictextbox id="txtAmount" value="0" type="Currency" onkeypress="validateandChangeImage(event)" width="100"
                                                                    runat="server">
                                                                </telerik:radnumerictextbox>
                                                                <asp:CustomValidator ID="CustomValidator1" runat="server" ControlToValidate="txtAmount"
                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Invalid Amount."
                                                                    ValidateEmptyText="True" ClientValidationFunction="validateProcessAmount" ErrorMessage="Invalid Amount."
                                                                    ValidationGroup="SwipeCardValidationGroup">*</asp:CustomValidator>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <asp:Label ID="Label9" CssClass="lblInputR" runat="server">Email Receipt:</asp:Label>
                                                            </td>
                                                            <td>
                                                                <asp:Label ID="lblEmail" CssClass="copy-Email" Visible="False" runat="server"></asp:Label>
                                                                <asp:TextBox ID="txtEmail" Visible="False" onkeypress="validateandChangeImage(event)"
                                                                    Width="156" runat="server"></asp:TextBox>
                                                                <asp:RegularExpressionValidator ID="regEmail" runat="server" CssClass="failureNotification"
                                                                    ErrorMessage="Invalid Email" ToolTip="Invalid Email." ControlToValidate="txtEmail"
                                                                    Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                                                    ValidationGroup="SwipeCardValidationGroup">*</asp:RegularExpressionValidator>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td></td>
                                                            <td>
                                                                <asp:CheckBox ID="chkCardForFutureUse" Checked="True" runat="server" onclick="validateSaveCardForFutureUse()"
                                                                    Text="Save Card to Account" />
                                                                <br />
                                                                <asp:CheckBox ID="chkCreditPrimary" runat="server" Text="Make Card Primary" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td valign="top">
                                                    <asp:Panel ID="pnlPatientInformation" Visible="False" runat="server">
                                                        <table class="tblLables">
                                                            <tr style="height: 70px;">
                                                                <td width="100" valign="bottom" align="right">&nbsp;
                                                                </td>
                                                                <td width="190" valign="bottom" align="left">&nbsp;
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label55" CssClass="lblInputR" runat="server" Text="Location:"></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <telerik:radcombobox id="cmbLocations" runat="server" width="180" emptymessage="Choose Location"
                                                                        allowcustomtext="False" markfirstmatch="True" datatextfield="Abbr" datavaluefield="LocationID" maxheight="200">
                                                                    </telerik:radcombobox>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="cmbLocations"
                                                                        Display="Dynamic" ErrorMessage="Location is required." SetFocusOnError="True"
                                                                        CssClass="failureNotification" ToolTip="Location is required." ValidationGroup="SwipeCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label65" CssClass="lblInputR" runat="server" Text="Provider:"></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <telerik:radcombobox id="cmbProviders" runat="server" width="180" emptymessage="Choose Provider"
                                                                        allowcustomtext="False" markfirstmatch="True" datatextfield="ProviderAbbr" datavaluefield="ProviderID" maxheight="200">
                                                                    </telerik:radcombobox>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator15" runat="server" ControlToValidate="cmbProviders"
                                                                        Display="Dynamic" ErrorMessage="Provider is required." SetFocusOnError="True"
                                                                        CssClass="failureNotification" ToolTip="Provider is required." ValidationGroup="SwipeCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label68" CssClass="lblInputR" runat="server" Text="MRN Number:"></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtMRN" runat="server" MaxLength="30" Width="94"></asp:TextBox>
                                                                    <%--  <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" ControlToValidate="txtMRN"
                                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="MRN Number is required."
                                                                        ErrorMessage="MRN Number is required." ValidationGroup="SwipeCardValidationGroup">*</asp:RequiredFieldValidator>--%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label72" CssClass="lblInputR" runat="server" Text="Date of Birth:"></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <telerik:raddatepicker id="dtDateofBirth" mindate="1900/1/1" runat="server" width="126">
                                                                    </telerik:raddatepicker>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator20" runat="server" ControlToValidate="dtDateofBirth"
                                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Date of Birth is required."
                                                                        ErrorMessage="Date of Birth is required." ValidationGroup="SwipeCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label73" CssClass="lblInputR" runat="server" Text="Social Security:"></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <telerik:radmaskedtextbox id="txtSocialSecurity" runat="server" mask="###-##-####" width="100">
                                                                    </telerik:radmaskedtextbox>
                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator9" Display="Dynamic"
                                                                        runat="server" ToolTip="Format is XXX-XX-XXXX" ErrorMessage="Social Security's Format should be XXX-XX-XXXX"
                                                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtSocialSecurity"
                                                                        ValidationGroup="SwipeCardValidationGroup" ValidationExpression="\d{3}\-\d{2}\-\d{4}">*</asp:RegularExpressionValidator>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label74" CssClass="lblInputR" runat="server" Text="Gender:"></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <telerik:radcombobox id="cmbGender" runat="server" width="100" emptymessage="Select..."
                                                                        datavaluefield="Value" datatextfield="Text" allowcustomtext="False" markfirstmatch="True">
                                                                    </telerik:radcombobox>
                                                                    <%--  <asp:RequiredFieldValidator ID="RequiredFieldValidator21" runat="server" ControlToValidate="cmbGender"
                                                                        ErrorMessage="Gender is Required" Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                                        ToolTip="Gender is required." ValidationGroup="SwipeCardValidationGroup">*</asp:RequiredFieldValidator>--%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label75" CssClass="lblInputR" runat="server" Text="Home Phone:"></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <telerik:radmaskedtextbox id="txtHomePhone" runat="server" mask="(###) ###-####" width="100">
                                                                    </telerik:radmaskedtextbox>
                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator10" Display="Dynamic"
                                                                        runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                                                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtHomePhone"
                                                                        ValidationGroup="SwipeCardValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                                                    <%--    <asp:RequiredFieldValidator ID="RequiredFieldValidator22" runat="server" ControlToValidate="txtHomePhone"
                                                                        Display="Dynamic" ErrorMessage="Home Phone is required." SetFocusOnError="True"
                                                                        CssClass="failureNotification" ToolTip="Home Phone is required." ValidationGroup="SwipeCardValidationGroup">*</asp:RequiredFieldValidator>--%>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label77" CssClass="lblInputR" runat="server" Text="Email:"></asp:Label>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtPatientEmail" runat="server" Width="160" onkeyup="displayEmailAddress(this.value)"></asp:TextBox>
                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator12" runat="server"
                                                                        CssClass="failureNotification" ErrorMessage="Invalid Email" ToolTip="Invalid Email."
                                                                        ControlToValidate="txtPatientEmail" Display="Dynamic" SetFocusOnError="true"
                                                                        ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                                                        ValidationGroup="SwipeCardValidationGroup">*</asp:RegularExpressionValidator>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </asp:Panel>
                                                    <asp:ValidationSummary ID="ValidationSummary6" runat="server" ValidationGroup="SwipeCardValidationGroup"
                                                        ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                        CssClass="failureNotification" HeaderText="Please fix the following errors before submitting" />
                                                </td>
                                            </tr>
                                        </table>
                                        <div style="margin-top: -10px;">
                                            <a href="javascript:;" onclick="showRadConfirm()">
                                                <img src="../Content/Images/btn_cancel.gif" class="btn-pop-cancel" alt="Cancel" /></a>
                                            &nbsp;
                                        <asp:ImageButton ID="btnValidateCreditCard" runat="server" ImageUrl="../Content/Images/btn_submit.gif"
                                            CssClass="btn-pop-submit" OnClick="btnValidateCreditCard_Click" OnClientClick="validateFields()" />
                                        </div>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlKeyArea" Visible="False" runat="server">
                                        <table width="100%">
                                            <tr>
                                                <td>
                                                    <div id="divPaymentMethods">
                                                        <b>Payment Method </b>
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <asp:RadioButton ID="rdCreditCard" runat="server" GroupName="Account" AutoPostBack="True"
                                                                        Text="Credit Card" Checked="True" OnCheckedChanged="rdCreditCard_CheckedChanged" />&nbsp;<asp:RadioButton
                                                                            AutoPostBack="True" Text="Checking Account" ID="rdBankAccount" runat="server" GroupName="Account"
                                                                            OnCheckedChanged="rdBankAccount_CheckedChanged" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                    <asp:Panel ID="pnlCreditCard" Visible="False" runat="server">
                                                        <div>
                                                            <table class="CareBluePopup">
                                                                <tr>
                                                                    <td>
                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td width="45%" valign="top">
                                                                                    <table class="tblLables">

                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label26" CssClass="lblInputR" Text="First Name:" runat="server"></asp:Label>
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtCreditCardFirstName" runat="server" MaxLength="30"></asp:TextBox>
                                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtCreditCardFirstName"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="First Name is required."
                                                                                                    ErrorMessage="First Name is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label28" runat="server" CssClass="lblInputR" Text="Last Name:"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtCreditCardLastName" runat="server" MaxLength="30"></asp:TextBox>
                                                                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCreditCardLastName"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Last Name is required."
                                                                                                    ErrorMessage="Last Name is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label30" runat="server" CssClass="lblInputR" Text="Zip Code:"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtCreditCardZipCode" runat="server" CssClass="zip-code1" MaxLength="5"></asp:TextBox>
                                                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="txtCreditCardZipCode"
                                                                                                    Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                                                                                    ToolTip="Invalid Zip Code " ErrorMessage="Invalid Zip Code " ValidationGroup="CreditCardValidationGroup">*</asp:RegularExpressionValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label31" CssClass="lblInputR" runat="server">Card Type:</asp:Label>
                                                                                            </td>
                                                                                            <td>
                                                                                                <telerik:radcombobox id="cmbCardType" runat="server" emptymessage="Choose Type..."
                                                                                                    allowcustomtext="False" markfirstmatch="True" autopostback="True" width="150px"
                                                                                                    datatextfield="Abbr" datavaluefield="PaymentCardTypeID" maxheight="200" onselectedindexchanged="cmbCardType_OnSelectedIndexChanged">
                                                                                                </telerik:radcombobox>
                                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator14" runat="server" ControlToValidate="cmbCardType"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Card Type is required."
                                                                                                    ErrorMessage="Card Type is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label34" runat="server" CssClass="lblInputR" Text="Card Number:"></asp:Label>
                                                                                            </td>
                                                                                            <td>
                                                                                                <telerik:radmaskedtextbox id="txtCardNumber" runat="server" mask="####-####-####-####"
                                                                                                    validationgroup="CreditCardValidationGroup" width="150">
                                                                                                </telerik:radmaskedtextbox>
                                                                                                <asp:RequiredFieldValidator ID="rqdCardNumber" runat="server" ControlToValidate="txtCardNumber"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Card Number is required."
                                                                                                    ErrorMessage="Card Number is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                                                <asp:RegularExpressionValidator ID="regexpCardNumber" Display="Dynamic" runat="server"
                                                                                                    ToolTip="Invalid Card Number" ErrorMessage="Invalid Card Number" CssClass="failureNotification"
                                                                                                    ControlToValidate="txtCardNumber" SetFocusOnError="True" ValidationGroup="CreditCardValidationGroup"
                                                                                                    ValidationExpression="\d{4}\-\d{4}\-\d{4}\-\d{4}">*</asp:RegularExpressionValidator>
                                                                                                <asp:CustomValidator ID="cstVldCardNumber" ValidationGroup="CreditCardValidationGroup"
                                                                                                    ControlToValidate="txtCardNumber" ClientValidationFunction="validateCardNumber"
                                                                                                    ToolTip="Invalid Card Number" ErrorMessage="Invalid Card Number" CssClass="failureNotification"
                                                                                                    SetFocusOnError="True" runat="server">*</asp:CustomValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label35" runat="server" CssClass="lblInputR" Text="Expiration:"></asp:Label>
                                                                                            </td>
                                                                                            <td>
                                                                                                <telerik:radtextbox id="txtMonth" runat="server" maxlength="2" enablesingleinputrendering="true"
                                                                                                    emptymessage="MM" width="35px">
                                                                                                </telerik:radtextbox>
                                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator18" runat="server" ControlToValidate="txtMonth"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Expiration month is required."
                                                                                                    ErrorMessage="Expiration month is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                                                <asp:RangeValidator ID="RangeValidator1" runat="server" ToolTip="Invalid Expiration Month"
                                                                                                    Type="Integer" Display="Dynamic" ControlToValidate="txtMonth" SetFocusOnError="True"
                                                                                                    MinimumValue="1" MaximumValue="12" CssClass="failureNotification" ValidationGroup="CreditCardValidationGroup">*</asp:RangeValidator>

                                                                                                /
                                                                                            <telerik:radtextbox id="txtYear" maxlength="2" runat="server" enablesingleinputrendering="true" emptymessage="YY" onchange="validateYear(this)" width="43px">
                                                                                            </telerik:radtextbox>
                                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator" runat="server" ControlToValidate="txtYear"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Expiration year is required."
                                                                                                    ErrorMessage="Expiration year is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                                                <asp:RangeValidator ID="rngValidatorYear" runat="server" ToolTip="Invalid Expiration Year"
                                                                                                    ErrorMessage="Invalid Expiration Year" Display="Dynamic" ControlToValidate="txtYear"
                                                                                                    SetFocusOnError="True" Type="Integer" CssClass="failureNotification" ValidationGroup="CreditCardValidationGroup">*</asp:RangeValidator>
                                                                                            </td>
                                                                                        </tr>

                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label36" CssClass="lblInputR" runat="server" Text="CVV Security ID:"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtCVVSecurityID" runat="server" MaxLength="4" Width="82"></asp:TextBox>
                                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtCVVSecurityID"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="CVV Security ID is required."
                                                                                                    ErrorMessage="CVV Security ID is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                                                <asp:RegularExpressionValidator ID="rgExpCvvSecurityID" Display="Dynamic"
                                                                                                    runat="server" ToolTip="Invalid CVV Security ID" ErrorMessage="Invalid CVV Security ID"
                                                                                                    ControlToValidate="txtCVVSecurityID" CssClass="failureNotification" ValidationGroup="CreditCardValidationGroup">*</asp:RegularExpressionValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label CssClass="lblInputR" ID="Label2" runat="server">Amount:</asp:Label></td>
                                                                                            <td>
                                                                                                <telerik:radnumerictextbox id="txtCreditCardAmount" width="88" value="0" type="Currency" onchange="validateAmount(this)"
                                                                                                    runat="server">
                                                                                                </telerik:radnumerictextbox>
                                                                                                <asp:CompareValidator ID="cmpValidatorAmount" runat="server" ControlToValidate="txtCreditCardAmount"
                                                                                                    Operator="GreaterThan" ValueToCompare="0" SetFocusOnError="True" Display="Dynamic"
                                                                                                    CssClass="failureNotification" ToolTip="Amount should be greater than 0" ErrorMessage="Amount should be greater than 0"
                                                                                                    ValidationGroup="CreditCardValidationGroup">*</asp:CompareValidator>
                                                                                                <asp:CustomValidator ID="CustomValidator2" runat="server" ControlToValidate="txtCreditCardAmount"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Invalid Amount."
                                                                                                    ValidateEmptyText="True" ClientValidationFunction="validateProcessAmount" ErrorMessage="Invalid Amount."
                                                                                                    ValidationGroup="CreditCardValidationGroup">*</asp:CustomValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label CssClass="lblInputR" ID="Label20" runat="server">Email Receipt:</asp:Label>
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:Label ID="lblCardEmail" CssClass="copy-Email" Visible="False" runat="server"></asp:Label>
                                                                                                <asp:TextBox ID="txtCardEmail" Visible="False" runat="server"></asp:TextBox>
                                                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator8" runat="server" CssClass="failureNotification"
                                                                                                    ErrorMessage="Invalid Email" ToolTip="Invalid Email." ControlToValidate="txtCardEmail"
                                                                                                    Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                                                                                    ValidationGroup="CreditCardValidationGroup">*</asp:RegularExpressionValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>&nbsp;            
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:CheckBox ID="chkCreditFutureUse" Checked="True" runat="server" Text="Save Card to Account" />
                                                                                                <br />
                                                                                                <asp:CheckBox ID="chkCreditPrimarySeconday" runat="server" Text="Make Card Primary" />
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="50%" valign="top">
                                                                                    <asp:Panel ID="pnlCreditPateint" Visible="false" Enabled="false" runat="server">
                                                                                        <table class="tblLables">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label78" runat="server" CssClass="lblInputR" Text="Location:"></asp:Label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <telerik:radcombobox id="cmbCreditLocations" runat="server" width="200" emptymessage="Choose Location"
                                                                                                        allowcustomtext="False" markfirstmatch="True" datatextfield="Abbr" datavaluefield="LocationID"
                                                                                                        maxheight="200">
                                                                                                    </telerik:radcombobox>
                                                                                                    <asp:RequiredFieldValidator ID="rqdCreditLocations" runat="server" ControlToValidate="cmbCreditLocations"
                                                                                                        Display="Dynamic" ErrorMessage="Location is required." SetFocusOnError="True"
                                                                                                        CssClass="failureNotification" ToolTip="Location is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label79" runat="server" CssClass="lblInputR" Text="Provider:"></asp:Label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <telerik:radcombobox id="cmbCreditProviders" runat="server" width="200" emptymessage="Choose Provider"
                                                                                                        allowcustomtext="False" markfirstmatch="True" datatextfield="ProviderAbbr" datavaluefield="ProviderID"
                                                                                                        maxheight="200">
                                                                                                    </telerik:radcombobox>
                                                                                                    <asp:RequiredFieldValidator ID="rqdCreditProviders" runat="server" ControlToValidate="cmbCreditProviders"
                                                                                                        Display="Dynamic" ErrorMessage="Provider is required." SetFocusOnError="True"
                                                                                                        CssClass="failureNotification" ToolTip="Provider is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label80" runat="server" CssClass="lblInputR" Text="MRN Number:"></asp:Label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtCreditMRN" runat="server" Width="94" MaxLength="30"></asp:TextBox>
                                                                                                    <%--  <asp:RequiredFieldValidator ID="rqdCreditMRN" runat="server" ControlToValidate="txtCreditMRN"
                                                                                                                    Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="MRN Number is required."
                                                                                                                    ErrorMessage="MRN Number is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>--%>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label88" runat="server" CssClass="lblInputR" Text="Date of Birth:"></asp:Label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <telerik:raddatepicker id="rdCreditDateOfBirth" mindate="1900/1/1" runat="server" width="125"
                                                                                                        cssclass="set-telerik-ctrl-width">
                                                                                                    </telerik:raddatepicker>
                                                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator25" runat="server" ControlToValidate="rdCreditDateOfBirth"
                                                                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Date of Birth is required."
                                                                                                        ErrorMessage="Date of Birth is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label89" CssClass="lblInputR" runat="server" Text="Social Security:"></asp:Label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <telerik:radmaskedtextbox id="txtCreditSocialSecurity" runat="server" mask="###-##-####"
                                                                                                        width="100">
                                                                                                    </telerik:radmaskedtextbox>
                                                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator16" Display="Dynamic"
                                                                                                        runat="server" ToolTip="Format is XXX-XX-XXXX" ErrorMessage="Social Security's Format should be XXX-XX-XXXX"
                                                                                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtCreditSocialSecurity"
                                                                                                        ValidationGroup="CreditCardValidationGroup" ValidationExpression="\d{3}\-\d{2}\-\d{4}">*</asp:RegularExpressionValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label82" CssClass="lblInputR" runat="server" Text="Gender:"></asp:Label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <telerik:radcombobox id="cmbCreditGender" runat="server" emptymessage="Select" width="100"
                                                                                                        datavaluefield="Value" datatextfield="Text" allowcustomtext="False" markfirstmatch="True">
                                                                                                    </telerik:radcombobox>
                                                                                                    <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator23" runat="server" ControlToValidate="cmbCreditGender"
                                                                                                                    ErrorMessage="Gender is Required" Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                                                                                    ToolTip="Gender is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>--%>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label84" CssClass="lblInputR" runat="server" Text="Home Phone:"></asp:Label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <telerik:radmaskedtextbox id="txtCreditHomePhone" runat="server" mask="(###) ###-####"
                                                                                                        width="100">
                                                                                                    </telerik:radmaskedtextbox>
                                                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator13" Display="Dynamic"
                                                                                                        runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                                                                                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtCreditHomePhone"
                                                                                                        ValidationGroup="CreditCardValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                                                                                    <%--    <asp:RequiredFieldValidator ID="RequiredFieldValidator24" runat="server" ControlToValidate="txtCreditHomePhone"
                                                                                                                    Display="Dynamic" ErrorMessage="Home Phone is required." SetFocusOnError="True"
                                                                                                                    CssClass="failureNotification" ToolTip="Home Phone is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>--%>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label87" CssClass="lblInputR" runat="server" Text="Email:"></asp:Label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtCreditEmail" Width="181" runat="server" onkeyup="displayEmailAddress(this.value)"></asp:TextBox>
                                                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator15" runat="server"
                                                                                                        CssClass="failureNotification" ErrorMessage="Invalid Email" ToolTip="Invalid Email."
                                                                                                        ControlToValidate="txtCreditEmail" Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                                                                                        ValidationGroup="CreditCardValidationGroup">*</asp:RegularExpressionValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </asp:Panel>
                                                                                    <div class="form-row">
                                                                                        <div class="editor-field">
                                                                                            <asp:ValidationSummary ID="ValidationSummary3" runat="server" ValidationGroup="CreditCardValidationGroup"
                                                                                                ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                                                                CssClass="failureNotification" HeaderText="Please fix the following errors before submitting" />
                                                                                        </div>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>

                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:HiddenField ID="hdnIsDisableProcessingPopup" runat="server" />
                                                                        <asp:HiddenField ID="hdnPref" runat="server" />
                                                                        <a href="javascript:;" onclick="showRadConfirm()">
                                                                            <img alt="Cancel" src="../Content/Images/btn_cancel.gif" class="btn-pop-cancel" /></a>
                                                                        &nbsp;
                                                                    <asp:ImageButton ID="btnCreditCardSubmit" runat="server" ImageUrl="../Content/Images/btn_submit.gif"
                                                                        OnClientClick="return showCreditCardProcessing()" CssClass="btn-pop-submit" OnClick="btnCreditCardSubmit_AssignVaues" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </asp:Panel>
                                                    <asp:Panel ID="pnlBankAccount" runat="server" Visible="False">
                                                        <div>
                                                            <table class="CareBluePopup">
                                                                <tr>
                                                                    <td>
                                                                        <table width="100%">
                                                                            <tr>
                                                                                <td width="50%" valign="top">
                                                                                    <table class="tblLables">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label39" CssClass="lblInputR" runat="server">First Name:</asp:Label>
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtFirstName" runat="server" MaxLength="30"></asp:TextBox>
                                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtFirstName"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="First Name is required."
                                                                                                    ErrorMessage="First Name is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label40" CssClass="lblInputR" runat="server">Last Name:</asp:Label>
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtLastName" runat="server" MaxLength="30"></asp:TextBox>
                                                                                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLastName" SetFocusOnError="True"
                                                                                                    Display="Dynamic" CssClass="failureNotification" ToolTip="Last Name is required."
                                                                                                    ErrorMessage="Last Name is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%-- <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label5" CssClass="lblInputR" runat="server" Text="Zip Code:"></asp:Label></td>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtBankAccountZipCode" runat="server" CssClass="zip-code1" MaxLength="5"></asp:TextBox>
                                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator33" runat="server" ControlToValidate="txtBankAccountZipCode"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="ZipCode is required."
                                                                                                    ErrorMessage="ZipCode is required." ValidationGroup="CreditCardValidationGroup">*</asp:RequiredFieldValidator>
                                                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ControlToValidate="txtBankAccountZipCode"
                                                                                                    Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                                                                                    ToolTip="Invalid Zip Code " ErrorMessage="Invalid Zip Code " ValidationGroup="CreditCardValidationGroup">*</asp:RegularExpressionValidator>
                                                                                            </td>
                                                                                        </tr>--%>

                                                                                        <%-- Also uncomment from these methods ShowPatientInformation, ValidateandCreatePatientOrStatement, btnSubmitBank_Click--%>

                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label47" CssClass="lblInputR" runat="server">Account Type:</asp:Label></td>
                                                                                            <td>
                                                                                                <telerik:radcombobox id="cmbAccountType" runat="server" emptymessage="Choose Type..."
                                                                                                    allowcustomtext="False" markfirstmatch="True" width="150px" datatextfield="Text"
                                                                                                    datavaluefield="Value" maxheight="200">
                                                                                                </telerik:radcombobox>
                                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="cmbAccountType"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Account type is required."
                                                                                                    ErrorMessage="Account type is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label41" CssClass="lblInputR" runat="server">Routing Number:</asp:Label>
                                                                                            </td>
                                                                                            <td>
                                                                                                <telerik:radmaskedtextbox id="txtRoutingNumber" runat="server" mask="###-###-###" autopostback="True" ontextchanged="txtRoutingNumber_OnTextChanged"
                                                                                                    width="150" validationgroup="CreditCardValidationGroup">
                                                                                                </telerik:radmaskedtextbox>
                                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="txtRoutingNumber"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Routing number is required."
                                                                                                    ErrorMessage="Routing number is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                                                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator7" Display="Dynamic"
                                                                                                    runat="server" ControlToValidate="txtRoutingNumber" ToolTip="Invalid Routing Number."
                                                                                                    ErrorMessage="Invalid Routing Number." SetFocusOnError="True" CssClass="failureNotification"
                                                                                                    ValidationGroup="BankAccountValidationGroup" ValidationExpression="\d{3}\-\d{3}\-\d{3}">*</asp:RegularExpressionValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label43" CssClass="lblInputR" runat="server">Account Number:</asp:Label></td>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtAccountNumber" runat="server" Width="144" MaxLength="20"></asp:TextBox>
                                                                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txtAccountNumber"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Account number is required."
                                                                                                    ErrorMessage="Account number is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                                                                                                <asp:RegularExpressionValidator ID="RgrExpnAccountNumber" Display="Dynamic" runat="server"
                                                                                                    ControlToValidate="txtAccountNumber" ToolTip="Invalid Account Number." ErrorMessage="Invalid Account Number."
                                                                                                    SetFocusOnError="True" CssClass="failureNotification" ValidationGroup="BankAccountValidationGroup"
                                                                                                    ValidationExpression="^[0-9]{6,20}$">*</asp:RegularExpressionValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label44" CssClass="lblInputR" runat="server">Bank Name:</asp:Label>
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtBankName" runat="server" MaxLength="30"></asp:TextBox>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%--<tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label5" CssClass="lblInputR" runat="server">City</asp:Label>
                                                                                            </td>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtBankCity" runat="server"></asp:TextBox>
                                                                                            </td>
                                                                                        </tr>--%>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label76" CssClass="lblInputR" runat="server">State</asp:Label>
                                                                                            </td>
                                                                                            <td>
                                                                                                <telerik:radcombobox id="cmbBankStates" runat="server" width="151px" emptymessage="Choose State..."
                                                                                                    allowcustomtext="False" markfirstmatch="True" datatextfield="Name" datavaluefield="StateTypeID"
                                                                                                    maxheight="200">
                                                                                                </telerik:radcombobox>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label32" CssClass="lblInputR" runat="server">Amount:</asp:Label>
                                                                                            </td>
                                                                                            <td>
                                                                                                <telerik:radnumerictextbox id="txtBankAccountAmount" value="0" width="88" type="Currency" onchange="validateAmount(this)"
                                                                                                    runat="server">
                                                                                                </telerik:radnumerictextbox>
                                                                                                <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="txtBankAccountAmount"
                                                                                                    Operator="GreaterThan" ValueToCompare="0" SetFocusOnError="True" Display="Dynamic"
                                                                                                    CssClass="failureNotification" ToolTip="Amount should be greater than 0" ErrorMessage="Amount should be greater than 0"
                                                                                                    ValidationGroup="BankAccountValidationGroup">*</asp:CompareValidator>
                                                                                                <asp:CustomValidator ID="CustomValidator3" runat="server" ControlToValidate="txtBankAccountAmount"
                                                                                                    SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Invalid Amount."
                                                                                                    ValidateEmptyText="True" ClientValidationFunction="validateProcessAmount" ErrorMessage="Invalid Amount."
                                                                                                    ValidationGroup="BankAccountValidationGroup">*</asp:CustomValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:Label ID="Label29" CssClass="lblInputR" runat="server">Email Receipt:</asp:Label></td>
                                                                                            <td>
                                                                                                <asp:Label ID="lblBankEmail" CssClass="copy-Email" Visible="False" runat="server"></asp:Label>
                                                                                                <asp:TextBox ID="txtBankAccountEmail" Visible="False" runat="server"></asp:TextBox>
                                                                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator14" runat="server"
                                                                                                    CssClass="failureNotification" ErrorMessage="Invalid Email" ToolTip="Invalid Email."
                                                                                                    ControlToValidate="txtBankAccountEmail" Display="Dynamic" SetFocusOnError="true"
                                                                                                    ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                                                                                    ValidationGroup="BankAccountValidationGroup">*</asp:RegularExpressionValidator>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td>&nbsp;</td>
                                                                                            <td>
                                                                                                <asp:CheckBox ID="chkBankFutureUse" Checked="True" runat="server" Text="Save to Account" />
                                                                                                <br />
                                                                                                <asp:CheckBox ID="chkBankPrimarySeconday" runat="server" Text="Make Account Primary" />
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>

                                                                                <td width="50%" valign="top">
                                                                                    <asp:Panel ID="pnlBankAccountPatient" Visible="false" Enabled="false" runat="server">
                                                                                        <table class="tblLables">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label95" CssClass="lblInputR" runat="server" Text="Location:"></asp:Label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <telerik:radcombobox id="cmbBankLocations" runat="server" width="200" emptymessage="Choose Location"
                                                                                                        allowcustomtext="False" markfirstmatch="True" datatextfield="Abbr" datavaluefield="LocationID"
                                                                                                        maxheight="200">
                                                                                                    </telerik:radcombobox>
                                                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator29" runat="server" ControlToValidate="cmbBankLocations"
                                                                                                        Display="Dynamic" ErrorMessage="Location is required." SetFocusOnError="True"
                                                                                                        CssClass="failureNotification" ToolTip="Location is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label96" CssClass="lblInputR" runat="server" Text="Provider:"></asp:Label></td>
                                                                                                <td>
                                                                                                    <telerik:radcombobox id="cmbBankProviders" runat="server" width="200" emptymessage="Choose Provider"
                                                                                                        allowcustomtext="False" markfirstmatch="True" datatextfield="ProviderAbbr" datavaluefield="ProviderID"
                                                                                                        maxheight="200">
                                                                                                    </telerik:radcombobox>
                                                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator30" runat="server" ControlToValidate="cmbBankProviders"
                                                                                                        Display="Dynamic" ErrorMessage="Provider is required." SetFocusOnError="True"
                                                                                                        CssClass="failureNotification" ToolTip="Provider is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label97" CssClass="lblInputR" runat="server" Text="MRN Number:"></asp:Label></td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtBankMRN" runat="server" Width="94" MaxLength="30"></asp:TextBox>
                                                                                                    <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator31" runat="server" ControlToValidate="txtBankMRN"
                                                                                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="MRN Number is required."
                                                                                                                ErrorMessage="MRN Number is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>--%>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label94" runat="server" CssClass="lblInputR" Text="Date of Birth:"></asp:Label></td>
                                                                                                <td>
                                                                                                    <telerik:raddatepicker id="dtBankDateOfBirth" mindate="1900/1/1" runat="server" width="125" cssclass="set-telerik-ctrl-width">
                                                                                                    </telerik:raddatepicker>
                                                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator28" runat="server" ControlToValidate="dtBankDateOfBirth"
                                                                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Date of Birth is required."
                                                                                                        ErrorMessage="Date of Birth is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label98" runat="server" CssClass="lblInputR" Text="Social Security:"></asp:Label>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <telerik:radmaskedtextbox id="txtBankSocialSecurity" runat="server" mask="###-##-####"
                                                                                                        width="100">
                                                                                                    </telerik:radmaskedtextbox>
                                                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator20" Display="Dynamic"
                                                                                                        runat="server" ToolTip="Format is XXX-XX-XXXX" ErrorMessage="Social Security's Format should be XXX-XX-XXXX"
                                                                                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtBankSocialSecurity"
                                                                                                        ValidationGroup="BankAccountValidationGroup" ValidationExpression="\d{3}\-\d{2}\-\d{4}">*</asp:RegularExpressionValidator>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label90" runat="server" CssClass="lblInputR" Text="Gender:"></asp:Label></td>
                                                                                                <td>
                                                                                                    <telerik:radcombobox id="cmbBankGender" runat="server" width="100" emptymessage="Select"
                                                                                                        datavaluefield="Value" datatextfield="Text" allowcustomtext="False" markfirstmatch="True">
                                                                                                    </telerik:radcombobox>
                                                                                                    <%--  <asp:RequiredFieldValidator ID="RequiredFieldValidator26" runat="server" ControlToValidate="cmbBankGender"
                                                                                                                ErrorMessage="Gender is Required" Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                                                                                ToolTip="Gender is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>--%></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label91" runat="server" CssClass="lblInputR" Text="Home Phone:"></asp:Label></td>
                                                                                                <td>
                                                                                                    <telerik:radmaskedtextbox id="txtBankHomePhone" runat="server" mask="(###) ###-####"
                                                                                                        width="100">
                                                                                                    </telerik:radmaskedtextbox>
                                                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator17" Display="Dynamic"
                                                                                                        runat="server" ToolTip="Format is (XXX) XXX-XXXX" ErrorMessage="Format is (XXX) XXX-XXXX"
                                                                                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtBankHomePhone"
                                                                                                        ValidationGroup="BankAccountValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                                                                                    <%--         <asp:RequiredFieldValidator ID="RequiredFieldValidator27" runat="server" ControlToValidate="txtBankHomePhone"
                                                                                                                Display="Dynamic" ErrorMessage="Home Phone is required." SetFocusOnError="True"
                                                                                                                CssClass="failureNotification" ToolTip="Home Phone is required." ValidationGroup="BankAccountValidationGroup">*</asp:RequiredFieldValidator>--%>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Label ID="Label93" runat="server" CssClass="lblInputR" Text="Email:"></asp:Label></td>
                                                                                                <td>
                                                                                                    <asp:TextBox ID="txtBankEmail" Width="180" runat="server" onkeyup="displayEmailAddress(this.value)"></asp:TextBox>
                                                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator19" runat="server"
                                                                                                        CssClass="failureNotification" ErrorMessage="Invalid Email" ToolTip="Invalid Email."
                                                                                                        ControlToValidate="txtBankEmail" Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                                                                                        ValidationGroup="BankAccountValidationGroup">*</asp:RegularExpressionValidator>
                                                                                                </td>
                                                                                            </tr>

                                                                                        </table>
                                                                                    </asp:Panel>
                                                                                    <div class="form-row">
                                                                                        <div class="editor-field">
                                                                                            <asp:ValidationSummary ID="ValidationSummary4" runat="server" ValidationGroup="BankAccountValidationGroup"
                                                                                                ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                                                                CssClass="failureNotification" HeaderText="Please fix the following errors before submitting" />
                                                                                            <div id="divSuccessMessage" class="success-message" style="text-align: center">
                                                                                                <asp:Literal ID="litMessage" Text="" runat="server"></asp:Literal>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:HiddenField ID="hdnBankPNRef" runat="server" />
                                                                        <div id="divSubmit">
                                                                            <a href="javascript:;" onclick="showRadConfirm()">
                                                                                <img src="../Content/Images/btn_cancel.gif" class="btn-pop-cancel" alt="Cancel" /></a>
                                                                            &nbsp;
                                                                        <asp:ImageButton ID="btnSubmitBank" runat="server" ImageUrl="../Content/Images/btn_submit.gif"
                                                                            OnClientClick="return showBankAccountProcessing()" CssClass="btn-pop-submit"
                                                                            OnClick="btnBankSubmit_AssignValues" />
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </asp:Panel>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlCardOnFile" Visible="False" runat="server">
                                        <div>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <div class="ExtraPad align-popup-fields">
                                                            <div class="form-row">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label38" runat="server">Existing Account:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <telerik:radcombobox id="cmbPaymentMethods" runat="server" width="200px" datatextfield="AccountName"
                                                                        emptymessage="Choose Payment Method" allowcustomtext="False" markfirstmatch="True"
                                                                        datavaluefield="PaymentCardID" onselectedindexchanged="cmbPaymentMethods_OnSelectedIndexChanged"
                                                                        autopostback="True" maxheight="200">
                                                                    </telerik:radcombobox>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="cmbPaymentMethods"
                                                                        SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Existing Account is required."
                                                                        ErrorMessage="Existing Account is required." ValidationGroup="CardOnFileValidationGroup">*</asp:RequiredFieldValidator>
                                                                </div>
                                                            </div>
                                                            <div class="form-row">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label22" runat="server">Amount:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <telerik:radnumerictextbox id="txtCardOnFileAmount" value="0" width="88" type="Currency" onchange="validateAmount(this)"
                                                                        runat="server">
                                                                    </telerik:radnumerictextbox>
                                                                    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="txtCardOnFileAmount"
                                                                        Operator="GreaterThan" ValueToCompare="0" SetFocusOnError="True" Display="Dynamic"
                                                                        CssClass="failureNotification" ToolTip="Amount should be greater than 0" ErrorMessage="Amount should be greater than 0"
                                                                        ValidationGroup="CardOnFileValidationGroup">*</asp:CompareValidator>
                                                                    <asp:CustomValidator ID="CustomValidator4" runat="server" ControlToValidate="txtCardOnFileAmount"
                                                                        SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Invalid Amount."
                                                                        ValidateEmptyText="True" ClientValidationFunction="validateProcessAmount" ErrorMessage="Invalid Amount."
                                                                        ValidationGroup="CardOnFileValidationGroup">*</asp:CustomValidator>
                                                                </div>
                                                            </div>
                                                            <div class="form-row">
                                                                <div class="editor-label">
                                                                    <asp:Label runat="server">Email Receipt:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblCardOnFileEmail" Visible="False" runat="server"></asp:Label>
                                                                    <asp:TextBox ID="txtCardOnFileEmail" Visible="False" runat="server"></asp:TextBox>
                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" CssClass="failureNotification"
                                                                        ErrorMessage="Invalid Email" ToolTip="Invalid Email." ControlToValidate="txtCardOnFileEmail"
                                                                        Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                                                        ValidationGroup="CreditCardValidationGroup">*</asp:RegularExpressionValidator>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Panel ID="pnlCreditCardDetails" runat="server">
                                                            <table>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <h2>Details of Credit Card</h2>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" width="50%">
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label48" runat="server">First Name:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCFirstName" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label49" runat="server">Last Name:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCLastName" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label50" runat="server">Street:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCStreet" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label51" runat="server">Apt/Suite:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCAptSuite" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label52" runat="server">City:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCCity" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label53" runat="server">State:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCState" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label54" runat="server">Zip Code:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCZipCode" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                    <td valign="top" width="50%">
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label56" runat="server">Card Type:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCCardType" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label58" runat="server">Issuing Bank:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCIssuingBank" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label60" runat="server">Bank Phone:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCBankPhone" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label62" runat="server">Card Number:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCCardNumber" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label64" runat="server">Expiration:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCExpiration" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label57" runat="server">CVV Security ID:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCCVVSecurityID" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label66" runat="server">Card Class:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblCCCardClass" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                        <asp:Panel ID="pnlBankAccountDetails" runat="server">
                                                            <table>
                                                                <tr>
                                                                    <td colspan="2">
                                                                        <h2>Details of Bank Account</h2>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td valign="top" width="50%">
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label59" runat="server">First Name:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblBAFirstName" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label63" runat="server">Last Name:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblBALastName" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label67" runat="server">Rounting Number:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblBARountingNumber" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label69" runat="server">Account Number:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblBAAccountNumber" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label61" runat="server">Bank Primary Card:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblBAPrimaryCard" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                    <td valign="top" width="50%">
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label runat="server">Bank Name:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblBABankName" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label81" runat="server">Branch City:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblBABrachCity" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label83" runat="server">Bank State:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblBABankState" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="form-row">
                                                                            <div class="editor-label">
                                                                                <asp:Label ID="Label85" runat="server">Account Type:</asp:Label>
                                                                            </div>
                                                                            <div class="editor-field">
                                                                                <asp:Label ID="lblBAAccountType" runat="server"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </asp:Panel>
                                                        <asp:ValidationSummary ID="ValidationSummary5" runat="server" ValidationGroup="CardOnFileValidationGroup"
                                                            ShowMessageBox="True" ShowSummary="False" DisplayMode="BulletList" EnableClientScript="True"
                                                            CssClass="failureNotification" HeaderText="Please fix the following errors before submitting" />
                                                        <div>
                                                            <a href="javascript:;" onclick="showRadConfirm()">
                                                                <img src="../Content/Images/btn_cancel.gif" class="btn-pop-cancel" alt="Cancel" /></a>
                                                            &nbsp;
                                                        <asp:ImageButton ID="btnAssignValue" runat="server" ImageUrl="../Content/Images/btn_submit.gif"
                                                            OnClientClick="return showCardOnFileProcessing()" CssClass="btn-pop-submit" OnClick="btnAssignValue_OnClick" />
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </asp:Panel>
                                    <asp:Panel runat="server" Visible="False" ID="pnlSaveCard">
                                        <table>
                                            <tr class="align-popup-fields">
                                                <td valign="top" width="50%">
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            &nbsp
                                                        </div>
                                                        <div class="editor-field">
                                                            <a href="javascript:;">
                                                                <asp:Image ID="imgSavecardSwipe" ImageUrl="~/content/images/swipe-card-go.jpg" onclick="resetAll()"
                                                                    Width="102px" runat="server" /></a>
                                                        </div>
                                                    </div>
                                                    <div class="form-row" style="margin-bottom: -5px;">
                                                        <div class="editor-label" style="margin-top: 10px;">
                                                            <asp:Label ID="Label10" runat="server">Card Type:</asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Image ID="imgSaveCardCards" ImageUrl="~/Content/images/icon_paymentcard_none.jpg"
                                                                Width="150px" runat="server" />
                                                            <br />
                                                            <asp:TextBox ID="txtSaveCardMagtek" MaxLength="1000" onblur="changeSwipImage(this)"
                                                                onkeypress="return enterEvent(event)" runat="server" Style="border: 0; background-color: #fff;"
                                                                Width="0" TextMode="SingleLine" EnableViewState="True" Visible="True" Height="0"
                                                                Wrap="False">
                                                            </asp:TextBox>
                                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtMagtek"
                                                                SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Swipe card."
                                                                ErrorMessage="Please swipe card before processing charge." ValidationGroup="SaveCardValidationGroup"></asp:RequiredFieldValidator>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label11" Text="First Name:" runat="server"></asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Label ID="Label12" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label13" Text="Last Name:" runat="server"></asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Label ID="Label14" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label15" Text="Card Last 4:" runat="server"></asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Label ID="Label16" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label17" Text="Exp Month" runat="server"></asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Label ID="Label18" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label19" Text="Exp Year" runat="server"></asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:Label ID="Label21" runat="server"></asp:Label>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td valign="top">
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label23" runat="server" Text="Issuing Bank:"></asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:TextBox ID="txtSaveCardIssuingBank" runat="server" MaxLength="30"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label24" runat="server" Text="Bank Phone:"></asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <telerik:radmaskedtextbox id="txtSaveCardBankPhone" runat="server" mask="(###) ###-####"
                                                                width="155" validationgroup="SaveCardValidationGroup">
                                                            </telerik:radmaskedtextbox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" Display="Dynamic"
                                                                runat="server" ControlToValidate="txtBankPhone" ToolTip="Invalid Bank Phone."
                                                                ErrorMessage="Invalid Bank Phone." SetFocusOnError="True" CssClass="failureNotification"
                                                                ValidationGroup="SaveCardValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label27" runat="server" Text="CVV Security ID:"></asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:TextBox ID="TextBox5" runat="server" MaxLength="4"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="rglExprrCVVSecurityID" Display="Dynamic" runat="server"
                                                                ToolTip="Invalid CVV Security ID" ErrorMessage="Invalid CVV Security ID" ControlToValidate="txtCVVSecurityID"
                                                                CssClass="failureNotification" ValidationGroup="SaveCardValidationGroup">*</asp:RegularExpressionValidator>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="lblZipCode" runat="server" Text="Zip Code:"></asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:TextBox ID="txtZipCode" runat="server" CssClass="zip-code1" MaxLength="5"></asp:TextBox>
                                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtZipCode"
                                                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                                                ToolTip="Invalid Zip Code " ErrorMessage="Invalid Zip Code " ValidationGroup="SaveCardValidationGroup">*</asp:RegularExpressionValidator>
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            <asp:Label ID="Label42" runat="server" Text="Card Class:"></asp:Label>
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:RadioButton ID="rdPersonal" Text="Personal" runat="server" Checked="True" GroupName="CardClass" />&nbsp;<asp:RadioButton
                                                                ID="rdCorporate" Text="Corporate" runat="server" GroupName="CardClass" />
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            &nbsp;
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:CheckBox ID="CheckBox1" Checked="True" runat="server" Enabled="False" Text="Save Card to Account" />
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            &nbsp;
                                                        </div>
                                                        <div class="editor-field">
                                                            <asp:CheckBox ID="CheckBox2" runat="server" Text="Make Card Primary" />
                                                        </div>
                                                    </div>
                                                    <div class="form-row">
                                                        <div class="editor-label">
                                                            &nbsp;
                                                        </div>
                                                        <div class="editor-field">
                                                            &nbsp;
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                        <div class="form-row">
                                            <div class="editor-field">
                                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="SaveCardValidationGroup"
                                                    ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                    CssClass="failureNotification" HeaderText="Please fix the following errors before submitting" />
                                            </div>
                                        </div>
                                        <div>
                                            <a href="javascript:;" onclick="showRadConfirm()">
                                                <img src="../Content/Images/btn_cancel.gif" class="btn-pop-cancel" alt="Cancel" /></a>
                                            &nbsp;
                                        <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="../Content/Images/btn_submit.gif"
                                            CssClass="btn-pop-submit" />
                                        </div>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlTransaction" Visible="False" runat="server">
                                        <div>
                                            <table>
                                                <tr>
                                                    <td width="45%" valign="top">
                                                        <table class="tblLables">
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label3" CssClass="lblInputR" runat="server">Transaction Type:</asp:Label>
                                                                </td>
                                                                <td>
                                                                    <telerik:radcombobox id="cmbTransactionType" runat="server" width="160px" emptymessage="Choose Transaction Type..."
                                                                        onselectedindexchanged="cmbTransactionType_SelectedIndexChanged" allowcustomtext="False"
                                                                        autopostback="True" markfirstmatch="True" datatextfield="ServiceName" datavaluefield="TransactionTypeID"
                                                                        maxheight="200">
                                                                    </telerik:radcombobox>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="cmbTransactionType"
                                                                        SetFocusOnError="True" Display="Dynamic" CssClass="failureNotification" ToolTip="Transaction type is required."
                                                                        ErrorMessage="Transaction type is required." ValidationGroup="Transactions">*</asp:RequiredFieldValidator>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <asp:Label ID="Label33" CssClass="lblInputR" runat="server">Amount:</asp:Label>
                                                                </td>
                                                                <td>
                                                                    <telerik:radnumerictextbox runat="server" id="txtTransactionAmount" width="82" type="Currency" numberformat-decimaldigits="2"
                                                                        numberformat-groupseparator=",">
                                                                    </telerik:radnumerictextbox>
                                                                    <asp:CustomValidator CssClass="failureNotification" ValidateEmptyText="True" runat="server"
                                                                        ControlToValidate="txtTransactionAmount" ClientValidationFunction="validateProcessAmount" ValidationGroup="Transactions"
                                                                        Display="Dynamic" ToolTip="Amount is invalid."
                                                                        ErrorMessage="Amount is invalid.">*</asp:CustomValidator>

                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="top">
                                                                    <asp:Label ID="Label37" CssClass="lblInputR" runat="server">Message:</asp:Label>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtMessage" MaxLength="100" runat="server"></asp:TextBox>
                                                                    <asp:CustomValidator ID="CustomValidator5" CssClass="failureNotification" ValidateEmptyText="True"
                                                                        runat="server" ControlToValidate="txtMessage" ClientValidationFunction="validateMessage"
                                                                        ValidationGroup="Transactions" Display="Dynamic" ToolTip="Message required for statement description."
                                                                        ErrorMessage="Message required for statement description.">*</asp:CustomValidator>
                                                                    <br />
                                                                    <i>Messages will be displayed as the transaction description on the statement.</i>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td valign="top">
                                                                    <asp:Label ID="Label45" CssClass="lblInputR" runat="server">Notes:</asp:Label>
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txtTransactionNotes" TextMode="MultiLine" Width="350px" Height="90px" CssClass="textarea"
                                                                        MaxLength="255" runat="server"></asp:TextBox>
                                                                    <br />
                                                                    <i>Notes are optional and only visible to internal office staff.</i>
                                                                </td>
                                                            </tr>

                                                            <tr>
                                                                <td valign="top">
                                                                    <asp:Label ID="Label46" CssClass="lblInputR" runat="server">Email:</asp:Label>
                                                                </td>
                                                                <td>
                                                                    <asp:Label ID="lblTransactionEmail" CssClass="copy-Email" Visible="False" runat="server"></asp:Label>
                                                                    <asp:TextBox ID="txtTransactionEmail" Visible="False" runat="server"></asp:TextBox>
                                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" CssClass="failureNotification"
                                                                        ErrorMessage="Invalid Email" ToolTip="Invalid Email." ControlToValidate="txtTransactionEmail"
                                                                        Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                                                        ValidationGroup="Transactions">*</asp:RegularExpressionValidator>
                                                                    <br />
                                                                    <i>A receipt will be sent to the above email if entered.</i>
                                                                </td>
                                                            </tr>

                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:ValidationSummary ID="ValidationSummary7" runat="server" ValidationGroup="Transactions"
                                                            ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                            CssClass="failureNotification" HeaderText="Please fix the following errors before submitting" />
                                                        <a href="javascript:;" onclick="showRadConfirm()">
                                                            <img src="../Content/Images/btn_cancel.gif" class="btn-pop-cancel" alt="Cancel" /></a>
                                                        &nbsp;
                                                     <asp:ImageButton ID="btnTransaction" runat="server" ImageUrl="../Content/Images/btn_submit.gif" OnClientClick="return validateTransaction();" ValidationGroup="Transactions"
                                                         CssClass="btn-pop-submit" OnClick="btnTransaction_Click" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </asp:Panel>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="SaveCardValidationGroup"
                        ShowMessageBox="True" ShowSummary="False" DisplayMode="BulletList" EnableClientScript="True"
                        CssClass="failureNotification" HeaderText="Please fix the following errors before submitting" />
                </div>
                <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="1100px" height="850px"
                    modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    skin="CareBlueInf">
                    <ConfirmTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div>
                                <div style="margin-top: 20px; margin-left: 30px;">
                                <a href="#" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            &nbsp;&nbsp;
                                <a href="javascript:;" class="confirm-popup" onclick="$('#<%=btnSignature.ClientID %>').click();">
                                    <img src="../Content/Images/btn_sign_small.gif" alt="Sign" /></a>
                            &nbsp;&nbsp;
                                <a id="btnReceipt" href="javascript:;" class="confirm-popup" onclick="$find('{0}').close(false);">
                                    <img src="../Content/Images/btn_print_small.gif" alt="Print" /></a>
                                </div>
                            </div>
                        </div>
                    </ConfirmTemplate>
                    <AlertTemplate>
                        <div class="rwDialogPopup radalert">
                            <h5>
                            <div class="rwDialogText">
                                {1}
                            </div></h5>
                            <div class="align-buttons" style="margin-top: 20px; margin-left: 51px;">
                                <a href="#" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            </div>
                        </div>
                    </AlertTemplate>
                </telerik:radwindowmanager>
                <telerik:radwindowmanager id="RadWindowManager" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="1100px" height="850px"
                    modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    skin="CareBlueInf">
                    <ConfirmTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div>
                                <div style="margin-top: 15px; margin-left: 55px;">
                                    <a href="#" onclick="$find('{0}').close(false);">
                                        <img src="../Content/Images/btn_cancel.gif" alt="Cancel" /></a> &nbsp; &nbsp;
                                <a href="Javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_continue.gif" alt="Yes" /></a>
                                </div>
                            </div>
                        </div>
                    </ConfirmTemplate>
                </telerik:radwindowmanager>
                <telerik:radwindowmanager id="RadWindowCancelConfirmation" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="1100px" height="850px"
                    modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    skin="CareBlueInf">
                    <ConfirmTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div>
                                <div style="margin-top: 15px; margin-left: 55px;">
                                <a href="Javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_yes_small.gif" alt="Yes" /></a>   &nbsp; &nbsp;
                                  <a href="#" onclick="$find('{0}').close(false);">
                                        <img src="../Content/Images/btn_no_small.gif" alt="No" /></a>
                                </div>
                            </div>
                        </div>
                    </ConfirmTemplate>
                </telerik:radwindowmanager>
                <telerik:radwindowmanager id="RadWindowManager1" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                    modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    restrictionzoneid="divMainContent" skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize"
                    style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupConfirmationPayment" Behaviors="Close"
                            Width="420px" Height="340px" NavigateUrl="~/report/paymentConfirmation_popup.aspx"
                            DestroyOnClose="True">
                        </telerik:RadWindow>

                    </Windows>
                </telerik:radwindowmanager>
                <asp:Button ID="btnMagtek" OnClick="btnMagtek_Click" Style="display: none;" runat="server" />
                <asp:Button ID="btnSubmit" OnClick="btnSubmit_Click" Style="display: none;" runat="server" />
                <asp:Button ID="btnClear" OnClick="btnClear_ClearSavedValues" Style="display: none;"
                    runat="server" />
                <asp:Button ID="btnProcessCardOnFile" OnClick="btnProcessCard_Click" Style="display: none;"
                    runat="server" />
                <asp:Button ID="btnProcessCreditCardPayment" OnClick="btnCreditCardSubmit_Click"
                    Style="display: none;" runat="server" />
                <asp:Button ID="btnProcessBankAccountPayment" OnClick="btnSubmitBank_Click" Style="display: none;"
                    runat="server" />
                <asp:Button ID="btnSignature" OnClick="btnSignature_Click" Style="display: none;"
                    runat="server" />
                <asp:HiddenField ID="hdnIsReceipt" runat="server" />
                <asp:HiddenField ID="hdnAmount" Value="0" runat="server" />
                <asp:HiddenField ID="hdnIsContinueProcess" runat="server" />
            </ContentTemplate>
        </asp:UpdatePanel>
        <script type="text/javascript" language="javascript">

            var isRemoveQueryString = true;
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {

                if ($("#<%=hdnValidate.ClientID %>").val() == "1") {
                    resetAll();
                    $("#<%=hdnValidate.ClientID %>").val("");

                }

                // displaying email on label if email textbox is not empty
                isEmailEntered();

                GetRadWindow().BrowserWindow.unBlockUI();

            });

            function validateandResetUrl() {
                if (isRemoveQueryString) {
                    GetRadWindow().BrowserWindow.refreshPage();
                }
            }

            function GetRadWindow() {
                var oWindow = null;
                if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
                else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

                return oWindow;
            }

            function closePopup() {
                validateandResetUrl();
                GetRadWindow().close();
            }


            function showPaymentReceiptByOption() {

                if ($("#<%=hdnIsReceipt.ClientID %>").val() == "1") {
                    $('.confirm-popup').css('display', 'inline-block');
                    $('.align-buttons').css('margin-left', -10);
                }

                if ($("#<%=hdnIsReceipt.ClientID %>").val() == "0") {
                    GetRadWindow().BrowserWindow.showPaymentReceipt(true);
                } else {
                    GetRadWindow().BrowserWindow.showPaymentReceipt();
                }

                isRemoveQueryString = false;
                closePopup();
                $("#<%=hdnIsReceipt.ClientID %>").val("");

                GetRadWindow().BrowserWindow.unBlockUI();

            }

            function reloadPage(isOk) {
                
                if (!isOk) {
                    showPaymentReceiptByOption();
                }

                GetRadWindow().BrowserWindow.refreshPage();
                GetRadWindow().close();
            }

            function validateAmount(sender, arg) {
                var amount = parseInt(arg.Value);
                if (amount > 0 && amount < 50000) {
                    arg.IsValid = true;
                    return;
                }

                arg.IsValid = false;
            }

            function validateMessage(sender, args) {
                if (args.Value.trim().length >= 2) {
                    args.IsValid = true;
                    return;
                }
                else {
                    args.IsValid = false;
                    return;
                }
            }

            function validateCancel(isCancel) {
                if (isCancel) {
                    closePopup();
                }
            }


            function showRadConfirm() {
                var radWindowCancelConfirmation = $find("<%=RadWindowCancelConfirmation.ClientID %>");
                radWindowCancelConfirmation.radconfirm('Are you sure you want to cancel?', validateCancel, 400, 150, null, '', '../Content/Images/warning.png');
                return false;
            }


            function validateFields() {
                var isPageValid = false;

                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('SwipeCardValidationGroup');

                    if (isPageValid) {
                        GetRadWindow().BrowserWindow.blockUI();
                    }

                }
            }

            function validateTransaction() {
                if (typeof (Page_ClientValidate) == 'function') {
                    var isPageValid = Page_ClientValidate('Transactions');

                    if (isPageValid) {
                        GetRadWindow().BrowserWindow.blockUI();
                    }

                }
            }

            function processPayment(isAllowProcess) {
                $find("<%=popupConfirmationPayment.ClientID%>").close();
                if (isAllowProcess) {
                    GetRadWindow().BrowserWindow.blockUI();
                    processPayemtsFromDifferentMethods();
                }
            }

            function processPayemtsFromDifferentMethods() {

                var isChecked = $("#<%=rdSwipeCard.ClientID %>").is(':checked');
                if (isChecked) {
                    $("#<%=btnSubmit.ClientID %>").click();
                    return;
                }

                isChecked = $("#<%=rdKeyCard.ClientID %>").is(':checked');
                if (isChecked) {

                    var isCreditCardChecked = $("#<%=rdCreditCard.ClientID %>").is(':checked');
                    if (isCreditCardChecked) {
                        $("#<%=btnProcessCreditCardPayment.ClientID %>").click();
                    }

                    var isBankAccountChecked = $("#<%=rdBankAccount.ClientID %>").is(':checked');
                    if (isBankAccountChecked) {
                        $("#<%=btnProcessBankAccountPayment.ClientID %>").click();
                    }

                    return;
                }

                isChecked = $("#<%=rdCardOnFile.ClientID %>").is(':checked');
                if (isChecked) {
                    $("#<%=btnProcessCardOnFile.ClientID %>").click();
                    return;
                }

                isChecked = $("#<%=rdSaveCard.ClientID %>").is(':checked');
                if (isChecked) {
                    $("#<%=btnProcessCardOnFile.ClientID %>").click();
                    return;
                }

            }



            function showCreditCardProcessing() {
                var isPageValid = false;

                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('CreditCardValidationGroup');
                }

                if (isPageValid) {
                    GetRadWindow().BrowserWindow.blockUI();
                }

            }

            function showBankAccountProcessing() {
                var isPageValid = false;

                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('BankAccountValidationGroup');
                }

                if (isPageValid) {
                    GetRadWindow().BrowserWindow.blockUI();
                }
            }

            function showCardOnFileProcessing() {
                var isPageValid = false;

                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('CardOnFileValidationGroup');
                }

                if (isPageValid) {

                }
            }

            // Validating the credit Card Number

            function validateCardNumber(source, args) {
                var creditCardNumber = $('#<%=txtCardNumber.ClientID %>').val();
                var result = checkCC(creditCardNumber);
                if (result == -1) {
                    args.IsValid = false;
                } else {
                    args.IsValid = true;
                }
            }


            function checkCC(val) {

                String.prototype.startsWith = function (str) {
                    return (this.match("^" + str) == str);
                }

                Array.prototype.has = function (v, i) {
                    for (var j = 0; j < this.length; j++) {
                        if (this[j] == v) return (!i ? true : j);
                    }
                    return false;
                }

                // get rid of all non-numbers (space etc)
                val = val.replace(/[^0-9]/g, "");

                // now get digits
                var d = new Array();
                var a = 0;
                var len = 0;
                var cval = val;
                while (cval != 0) {
                    d[a] = cval % 10;
                    cval -= d[a];
                    cval /= 10;
                    a++;
                    len++;
                }

                if (len < 13)
                    return -1;

                var cType = -1;

                // mastercard
                if (val.startsWith("5")) {
                    if (len != 16)
                        return -1;
                    cType = 1;
                } else
                    // visa
                    if (val.startsWith("4")) {
                        if (len != 16 && len != 13)
                            return -1;
                        cType = 2;
                    } else
                        // amex
                        if (val.startsWith("34") || val.startsWith("37")) {
                            if (len != 15)
                                return -1;
                            cType = 3;
                        } else
                            // diners
                            if (val.startsWith("36") || val.startsWith("38") || val.startsWith("300") || val.startsWith("301") || val.startsWith("302") || val.startsWith("303") || val.startsWith("304") || val.startsWith("305")) {
                                if (len != 14)
                                    return -1;
                                cType = 4;
                            } else
                                // discover
                                if (val.startsWith("6011")) {
                                    if (len != 15 && len != 16)
                                        return -1;
                                    cType = 5;
                                } else
                                    // enRoute
                                    if (val.startsWith("2014") || val.startsWith("2149")) {
                                        if (len != 15 && len != 16)
                                            return -1;
                                        // any digit check
                                        return 6;
                                    } else
                                        // jcb
                                        if (val.startsWith("3")) {
                                            if (len != 16)
                                                return -1;
                                            cType = 7;
                                        } else
                                            // jcb
                                            if (val.startsWith("2131") || val.startsWith("1800")) {

                                                if (len != 15)
                                                    return -1;
                                                cType = 7;
                                            } else
                                                return -1;
                // invalid cc company

                // lets do some calculation
                var sum = 0;
                var i;
                for (i = 1; i < len; i += 2) {
                    var s = d[i] * 2;
                    sum += s % 10;
                    sum += (s - s % 10) / 10;
                }

                for (i = 0; i < len; i += 2)
                    sum += d[i];

                // musst be %10
                if (sum % 10 != 0)
                    return -1;

                return cType;
            }


            function enterEvent(e) {
                //            console.log(e.keyCode.toString());
                if (e.keyCode == 13) {
                    __doPostBack('<%=btnMagtek.UniqueID%>', "");
                    return false;
                }
            }

            function changeSwipImage(obj) {
                var isSweepChecked = $("#<%=rdSwipeCard.ClientID %>").is(':checked');
                if (isSweepChecked) {
                    $("#<%=imgSwipeCard.ClientID %>").get(0).src = "../content/images/swipe-card-stop.jpg";
                } else {
                    $("#<%=imgSavecardSwipe.ClientID %>").get(0).src = "../content/images/swipe-card-stop.jpg";
                }

                if (obj.value != "") {
                    $("#<%=btnMagtek.ClientID %>").click();
                }
            }



            function resetAll() {
                $("#<%=btnClear.ClientID %>").click();
                //resetValues();
                //validateSaveCardForFutureUse();

            }

            function validateSaveCardForFutureUse() {
                var isChecked = $("#<%=chkCardForFutureUse.ClientID %>").is(':checked');
                if (isChecked) {
                    $("#<%=chkCreditPrimary.ClientID %>").removeAttr("disabled");
                } else {
                    $("#<%=chkCreditPrimary.ClientID %>").removeAttr("checked");
                    $("#<%=chkCreditPrimary.ClientID %>").attr("disabled", "disabled");
                }
            }

            function resetValues() {
                $("#<%=txtMagTek.ClientID %>").focus();
                $("#<%=txtMagTek.ClientID %>").val("");
                $("#<%=txtFirstName.ClientID %>").text("");
                $("#<%=txtLastName.ClientID %>").text("");
                $("#<%=lblCardLast4.ClientID %>").text("");
                $("#<%=lblExpMonth.ClientID %>").text("");
                $("#<%=lblExpYear.ClientID %>").text("");
                $("#<%=imgSwipeCard.ClientID %>").get(0).src = "../content/images/swipe-card-go.jpg";
                $("#<%=imgcards.ClientID %>").get(0).src = "../content/images/icon_paymentcard_none.jpg";
                $("#<%=chkCardForFutureUse.ClientID %>").attr("checked", "checked");
                $("#<%=chkCreditPrimary.ClientID %>").removeAttr("checked");
            }


            function validateandChangeImage(e) {
                var magtekLength = $("#<%=txtMagTek.ClientID %>").val().length;
                if (e.keyCode == 13 && magtekLength == 0) {
                    $("#<%=imgSwipeCard.ClientID %>").get(0).src = "../content/images/swipe-card-go.jpg";
                }
            }

            function validateProcessAmount(sender, args) {
                var amount = args.Value;
                var combobox = $find("<%= cmbStatements.ClientID %>");
                var hdnAmount = $("#<%=hdnAmount.ClientID%>").val();
                hdnAmount = hdnAmount == "" ? 0 : parseFloat(hdnAmount);
                hdnAmount = combobox.get_value() == 0 ? 50000 : hdnAmount;
                args.IsValid = amount > 0 && hdnAmount == 0 ? true : amount > 0 && amount <= hdnAmount;
            }

            function validateAmount(obj) {
                if (obj.value == "") {
                    obj.value = 0;
                }
            }

            function displayEmailAddress(value) {
                $(".copy-Email").text(value);
            }


            function isEmailEntered() {
                var isChecked = $("#<%=rdSwipeCard.ClientID %>").is(':checked');
                if (isChecked) {
                    var email = $("#<%=txtPatientEmail.ClientID%>").val();
                    if (email != "") {
                        displayEmailAddress(email);
                    }

                    return;
                }

                isChecked = $("#<%=rdKeyCard.ClientID %>").is(':checked');
                if (isChecked) {

                    isChecked = $("#<%=rdCreditCard.ClientID %>").is(':checked');
                    if (isChecked) {
                        email = $("#<%=txtCreditEmail.ClientID%>").val();
                        if (email != "") {
                            displayEmailAddress(email);
                        }

                        return;

                    }


                    isChecked = $("#<%=rdCreditCard.ClientID %>").is(':checked');
                    if (isChecked) {
                        email = $("#<%=txtBankEmail.ClientID%>").val();
                        if (email != "") {
                            displayEmailAddress(email);
                        }

                    }


                }

            }

            function continueProcessPayment(isContinue) {
                if (isContinue) {
                    $("#<%=hdnIsContinueProcess.ClientID%>").val("true");
                    GetRadWindow().BrowserWindow.blockUI();
                    processPayemtsFromDifferentMethods();
                }
            }



            // For Other Transaction Radio optin

            function validateMessage(sender, args) {
                if (args.Value.trim().length >= 2) {
                    args.IsValid = true;
                    return;
                }
                else {
                    args.IsValid = false;
                    return;
                }
            }

            function validateYear(obj) {
                var value = $(obj).val();
                if (value.length == 2) {
                    var year = (new Date).getFullYear();
                    var yearStartWith = year.toString().substr(0, 2);
                    $(obj).val(yearStartWith + "" + value);
                }
            }

            function validateDescription(sender, args) {
                var combo = $find("<%= cmbDescription.ClientID %>");
                var text = combo.get_text();
                args.IsValid = text.length > 2;
            }


        </script>

        <script type="text/javascript">
            window.alert = function (string) {
                var reg = new RegExp("\\-", "g");
                var messages = string.replace(reg, "<br />").replace("Please fix the following errors before submitting", "Please fix the following errors before submitting - <br />");
                var radWindow = $find("<%=RadWindow.ClientID %>");
                radWindow.radalert(messages, 400, 100, '', "", "../Content/Images/warning.png");
            }

        </script>
    </form>
</body>
</html>
