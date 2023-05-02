<%@ Page Language="C#" AutoEventWireup="true" CodeFile="apply.aspx.cs" Inherits="qualify_apply" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Check Financing Options for Your Procedure</title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="../Styles/Widget.css" rel="stylesheet" type="text/css" />
    <style>
        .failureNotification {
            color: red;
        }
    </style>

</head>

<body>
    <div style="background-color: <%=HTMLBackgroundColor%>; border: 1px solid #325DA4; width:750px; display: table; border-radius: 10px;">
        <div style="margin-left:10px;">
            <table width="100%" style="padding: 20px 0px 0px 10px;">
                <tr>
                    <td valign="top" width="30%">
                        <asp:Image ID="imgLogo" runat="server" /><br />
                        <b><asp:Label ID="lblPractice" runat="server" /></b><br />
                        Phone: <asp:Label ID="lblPhoneMain" runat="server" /> 
                    </td>
                    <td valign="top" width="65%">
                        <h1><asp:Label ID="lblHTMLWelcome" runat="server" /></h1>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>

        <form runat="server">
            <telerik:radscriptmanager id="RadScriptManager1" runat="server">
            </telerik:radscriptmanager>
            <div id="divFields" runat="server" class="setwidth">
                <table width="100%" style="padding: 20px 0px 10px 10px;">
                    <tr>
                        <td width="15%">
                            <asp:Label ID="lblFirstName" Text="First Name:" runat="server"></asp:Label>
                        </td>
                        <td width="30%">
                            <asp:TextBox ID="txtFirstName" runat="server" MaxLength="50" Width="120" tabindex="1"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFirstName" CssClass="failureNotification"
                                Display="Dynamic" SetFocusOnError="True" ToolTip="First Name is required." ErrorMessage="First Name is required."
                                ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RequiredFieldValidator>
                        </td>
                        <td width="20%">
                            <asp:Label ID="lblDateofBirth" runat="server" AssociatedControlID="dtDateofBirth" Text="Date of Birth:"></asp:Label>
                        </td>
                        <td>
                            <telerik:raddatepicker id="dtDateofBirth" mindate="1900/1/1" Width="120" runat="server" tabindex="9">
                            </telerik:raddatepicker>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="dtDateofBirth" CssClass="failureNotification"
                                SetFocusOnError="True" Display="Dynamic" ToolTip="Date of Birth is required." ErrorMessage="Date of Birth is required."
                                ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblLastName" runat="server" Text="Last Name:"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtLastName" runat="server" MaxLength="50" Width="120" tabindex="2"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLastName" CssClass="failureNotification"
                                SetFocusOnError="True" Display="Dynamic" ToolTip="Last Name is required." ErrorMessage="Last Name is required."
                                ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RequiredFieldValidator>
                        </td>
                        <td>
                            <asp:Label ID="lblPhone" runat="server" Text="Phone:"></asp:Label>
                        </td>
                        <td>
                            <telerik:radmaskedtextbox id="txtPhone" runat="server" mask="(###) ###-####" width="95" tabindex="10"></telerik:radmaskedtextbox>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" Display="Dynamic"
                                runat="server" ToolTip="Format is (###) ###-####" SetFocusOnError="True" CssClass="failureNotification"
                                ErrorMessage="Phone format is (###) ###-####." ControlToValidate="txtPhone"
                                ValidationGroup="QualifyValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}"><img src="../content/images/icon_exclaim_red.png" /></asp:RegularExpressionValidator>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone" CssClass="failureNotification"
                                SetFocusOnError="True" Display="Dynamic" ToolTip="Phone number is required." ErrorMessage="Phone number is required."
                                ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblStreet" runat="server" Text="Street:"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtStreet" runat="server" MaxLength="50" tabindex="3"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtStreet" CssClass="failureNotification"
                                SetFocusOnError="True" Display="Dynamic" ToolTip="Street is required." ErrorMessage="Street is required."
                                ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RequiredFieldValidator>
                        </td>
                        <td>
                            <asp:Label runat="server" Text="Email:"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtEmailAddress" runat="server" MaxLength="50" width="215" tabindex="11"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="regEmail" runat="server" CssClass="failureNotification"
                                ErrorMessage="Invalid Email" ToolTip="Invalid Email." ControlToValidate="txtEmailAddress"
                                Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RegularExpressionValidator>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmailAddress" CssClass="failureNotification"
                                SetFocusOnError="True" Display="Dynamic" ToolTip="Email is required." ErrorMessage="Email is required."
                                ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblAptSuite" runat="server" Text="Apt/Suite:"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtAptSuite" runat="server" MaxLength="50" width="80" tabindex="4"></asp:TextBox>
                        </td>
                        <td>
                            <asp:Label ID="lblServiceType" runat="server" Text="Product or Service:"></asp:Label>
                        </td>
                        <td>
                            <telerik:radcombobox id="cmbServiceType" runat="server" width="148px" emptymessage="How can we help?"
                                maxheight="200" allowcustomtext="False" markfirstmatch="True" datatextfield="Name"
                                datavaluefield="CreditServiceTypeID"  tabindex="12">
                            </telerik:radcombobox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbServiceType" CssClass="failureNotification"
                                SetFocusOnError="True" Display="Dynamic" ToolTip="Service Type is required." ErrorMessage="Service Type is required."
                                ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblCity" runat="server" Text="City:"></asp:Label>
                        </td>
                        <td>
                            <asp:TextBox ID="txtCity" runat="server" MaxLength="50" tabindex="5"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCity" CssClass="failureNotification"
                                SetFocusOnError="True" Display="Dynamic" ToolTip="City is required." ErrorMessage="City is required."
                                ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RequiredFieldValidator>
                        </td>
                        <td>
                            <asp:Label ID="Label2" runat="server" Text="Credit Rating:"></asp:Label>
                        </td>
                        <td>
                            <telerik:radcombobox id="cmbCreditType" runat="server" width="148px" emptymessage="How is your credit?"
                                maxheight="200" allowcustomtext="False" markfirstmatch="True" datatextfield="Name"
                                datavaluefield="CreditClassTypeID" tabindex="13">
                            </telerik:radcombobox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbCreditType" CssClass="failureNotification"
                                SetFocusOnError="True" Display="Dynamic" ToolTip="Credit score estimate is required." ErrorMessage="Credit score estimate is required."
                                ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblState" runat="server" Text="State:"></asp:Label>
                        </td>
                        <td>
                            <telerik:radcombobox id="cmbStates" runat="server" width="148px" emptymessage="Select state"
                                maxheight="200" allowcustomtext="False" markfirstmatch="True" datatextfield="Name"
                                datavaluefield="StateTypeID" tabindex="6">
                            </telerik:radcombobox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbStates" CssClass="failureNotification"
                                SetFocusOnError="True" Display="Dynamic" ToolTip="State is required." ErrorMessage="State is required."
                                ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RequiredFieldValidator>
                        </td>
                        <td>
                            <asp:Label runat="server" Text="Current Patient:"></asp:Label>
                        </td>
                        <td>
                            <table cellspacing="0" cellpadding="0" style="border-collapse: collapse;"><tr>
                                <td class="container" style="padding:0;">
                                    <div style="margin-top:-3px;">
                                        <asp:RadioButtonList ID="IsPatient" runat="server" RepeatDirection="Horizontal"  tabindex="13">
                                            <asp:ListItem Value="1">Yes</asp:ListItem>
                                            <asp:ListItem Value="0">No</asp:ListItem>
                                        </asp:RadioButtonList>
                                    </div>
                                </td><td class="container" style="padding:0;">
                                    <div>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="IsPatient" CssClass="failureNotification"
                                        SetFocusOnError="True" Display="Dynamic" ToolTip="Are you already a patient?" ErrorMessage="Are you already a patient?"
                                        ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RequiredFieldValidator>
                                    </div>
                                </td>
                            </tr></table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <asp:Label ID="lblZipCode" runat="server" Text="Zip Code:"></asp:Label>
                        </td>
                        <td valign="top">
                            <asp:TextBox ID="txtZipCode" runat="server" MaxLength="5" width="80" tabindex="7"></asp:TextBox>
                            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtZipCode"
                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                ErrorMessage="Invalid Zip Code" ToolTip="Invalid Zip Code" ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RegularExpressionValidator>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtZipCode" CssClass="failureNotification"
                                SetFocusOnError="True" Display="Dynamic" ToolTip="Zip code is required." ErrorMessage="Zip code is required."
                                ValidationGroup="QualifyValidationGroup"><img src="../content/images/icon_exclaim_red.png" /></asp:RequiredFieldValidator>
                        </td>
                        <td valign="top">
                            <asp:Label ID="Label3" runat="server">Comments:</asp:Label>
                        </td>
                        <td valign="top">
                            <asp:TextBox TextMode="MultiLine" ID="txtComments" Width="230px" Height="60px" CssClass="textarea" runat="server"  tabindex="14" Font-Names="arial" Font-Size="Small"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <div style="margin:-25px 0 20px 20px;">
                    <asp:CustomValidator ID="CustomValidator2" ValidationGroup="QualifyValidationGroup"
                        ClientValidationFunction="validatePaymentTerms" CssClass="failureNotification"
                        SetFocusOnError="True" runat="server" Display="Dynamic" ToolTip="Please agree to terms and conditions."
                        ErrorMessage="Please agree to terms and conditions."><img src="../content/images/icon_exclaim_red.png" /></asp:CustomValidator>
                    <asp:CheckBox ID="chkAgreeTerms" runat="server" Text="I authorize the use of credit reports to provide me<br/>&nbsp;the best rate and I agree to the " tabindex="15"/><a href="../terms/credit.htm" style="text-decoration:none;" target="_blank">Terms and Conditions</a>.
                    <p style="margin-top:5px;">&nbsp;Evaluating your options will NOT affect your credit score.</p>
                </div>
                <div style="margin:-48px 0  0 458px;">
                    <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="../Content/Images/btn_submitrequest.png" ValidationGroup="QualifyValidationGroup"
                        OnClick="btnSubmit_Click" CssClass="btn-submit"  tabindex="16"/>
                </div>
                <div>
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="QualifyValidationGroup"
                        ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                        CssClass="failureNotification" HeaderText="Please fix the following errors:" />
                </div>
            </div>
            <div style="margin:5px 0  0px 458px;">
                <img id="imgClose" runat="server" class='btn-close' Visible="False" style='cursor: pointer; margin-bottom:40px;' onclick='closePopup();' alt='Close' src='../Content/Images/btn_closerequest.png'/>
            </div>
        </form>

        <div style="margin-left:20px;">
            <img src="../content/images/providers/logo_poweredby_careblue.png" />
            <br />&nbsp;
        </div>
    </div>
    <script>
        function validatePaymentTerms(source, args) {
            args.IsValid = document.getElementById('<%= chkAgreeTerms.ClientID %>').checked;
        }
        function closePopup() {
            window.close();
        }
    </script>
</body>
</html>
