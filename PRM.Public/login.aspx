<%@ Page Title="Log In" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true"
    CodeFile="login.aspx.cs" Inherits="Patient_Login" %>


<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <link href="Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
   
        <h1>
        <%-- <asp:ValidationSummary ID="LoginUserValidationSummary" runat="server" CssClass="failureNotification"
            ValidationGroup="LoginUserValidationGroup" />--%>
    </h1>
    <div class="form-row-login">
        <h1 style="margin: 10px 0px 10px 20px; font-size: 1.5em;">
            Patient Login</h1>

            <table border="0">
        <tr>
            <td>
                <div class="label-login">
                    <asp:Label ID="lblLastName" runat="server" AssociatedControlID="txtLastName">Last Name:</asp:Label>
                </div>
            </td>
            <td>
                    <telerik:RadTextBox ID="txtLastName" runat="server" MaxLength="30" Width="124px"
                        InputType="Text" BorderColor="#999999" BorderStyle="Solid" BorderWidth="1">
                    </telerik:RadTextBox>
                    <asp:RequiredFieldValidator ID="rfvLastName" runat="server" ControlToValidate="txtLastName"
                        CssClass="failureNotification" ErrorMessage="Last Name is required." ToolTip="Last Name is required."
                        ValidationGroup="LoginUserValidationGroup">*</asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <div class="label-login">
                    <asp:Label ID="lblAccountID" runat="server" AssociatedControlID="txtAccountID">Account ID:</asp:Label>
                </div>
            </td>
            <td>
                    <telerik:RadNumericTextBox runat="server" ID="txtAccountID" Width="124px" MaxLength="10"
                        Height="21px" Type="Number" NumberFormat-DecimalDigits="0" NumberFormat-GroupSeparator=""
                        ToolTip="Your Account ID can be found on any statement.">
                    </telerik:RadNumericTextBox>
                    <asp:RequiredFieldValidator ID="rfvAccountID" runat="server" ControlToValidate="txtAccountID"
                        CssClass="failureNotification" ErrorMessage="Account ID is required." ToolTip="Account ID is required."
                        ValidationGroup="LoginUserValidationGroup">*</asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <div class="label-login">
                    <asp:Label ID="lblDateofBirth" runat="server" AssociatedControlID="dtDateofBirth">Date of Birth:</asp:Label>
                </div>
            </td>
            <td style="line-height:0px;">     <!-- MVS: Line height is required due to an issue interpretting the size of the Telerik datepicker by IE -->
                    <telerik:RadDatePicker ID="dtDateofBirth" MinDate="1/1/1900" runat="server"  
                        Calendar-Skin="Windows7" Height="22" Width="150" Skin="Default" MaxDate="12/31/2020" CssClass="fldDate"
                        FocusedDate="1/1/1970">
                    </telerik:RadDatePicker>
                    <asp:RequiredFieldValidator ID="rfvDateofBirth" runat="server" ControlToValidate="dtDateofBirth"
                        CssClass="failureNotification" ErrorMessage="Date of Birth is required." ToolTip="Date of Birth is required."
                        ValidationGroup="LoginUserValidationGroup">*</asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div class="editor-section" style="height:13px;">
                    AND</div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="label-login">
                    <asp:Label ID="Label1" runat="server" AssociatedControlID="txtPINCode">PIN Code:</asp:Label>
                </div>
            </td>
            <td>
                    <telerik:RadTextBox ID="txtPINCode" Width="124px" Height="21px" onkeypress="clearFieldValues('PIN')"
                        TextMode="Password" MaxLength="8" ToolTip="Your PIN is your billing zip code until you update it."
                        runat="server">
                    </telerik:RadTextBox>
                    <asp:CustomValidator ID="CustomValidator1" CssClass="failureNotification" runat="server"
                        ControlToValidate="txtPINCode" ClientValidationFunction="validatePincode" ValidationGroup="LoginUserValidationGroup"
                        Display="Dynamic" ErrorMessage="PIN Code should be minimum of 4 and maximum of 8 characters"
                        ToolTip="PIN Code should be minimum of 4 and maximum of 8 characters">*</asp:CustomValidator>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div class="editor-section" style="height:13px;">
                    OR</div>
            </td>
        </tr>
        <tr>
            <td>
                <div class="label-login">
                    <asp:Label ID="lblSSNCode" runat="server" AssociatedControlID="txtSSNCode">SSN Last 4:</asp:Label>
                </div>
            </td>
            <td>
                    <telerik:RadTextBox ID="txtSSNCode" TextMode="Password" Width="124px" Height="21px"
                        MaxLength="4" onkeypress="clearFieldValues('SSN')" ToolTip="Last 4 digits of your social security number."
                        runat="server">
                    </telerik:RadTextBox>
                    <asp:CustomValidator ID="CustomValidator2" CssClass="failureNotification" runat="server"
                        ControlToValidate="txtSSNCode" ClientValidationFunction="validateSSNCode" ValidationGroup="LoginUserValidationGroup"
                        Display="Dynamic" ErrorMessage="Invalid SSNCode" ToolTip="Invalid SSNCode">*</asp:CustomValidator>
            </td>
        </tr>
    </table>

        <div style="clear: both;">
        </div>
        <div style="margin: 10px 0px 0px 150px">
            <asp:ImageButton ID="btnLogin" runat="server" src="content/images/btn_login.gif"
                OnClientClick="return validateInputs()" ValidationGroup="LoginUserValidationGroup"
                OnClick="LoginButton_Click" />
        </div>
    </div>
    <div class="boxLogin">
        <img src="content/images/cbpp_welcome.jpg" style="margin-left: 0px;" /></div>
    <h5 style="margin: 10px 0px 0px 30px;">
        You can find your Account ID listed on any of the statements you have received by
        mail or email. Alternatively you may call your doctor's office to obtain this information.
        <br /> If you have not logged in before, your default PIN is your billing zip code.
        We recommend you change your PIN after first login.
        </h5>
    <div class="failureNotification" style="margin: 15px 0px 0px 30px;">
        <asp:Literal ID="litMessage" runat="server"></asp:Literal>
    </div>
    <telerik:RadWindowManager ID="RadWindow" ShowContentDuringLoad="True" VisibleStatusbar="False"
        VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Modal="True" EnableEmbeddedBaseStylesheet="False"
        EnableEmbeddedSkins="False" RestrictionZoneID="mvs01" Skin="CareBlueInf" Style="z-index: 3000">
        <AlertTemplate>
            <div class="rwDialogPopup radalert">
                <h5>
                    <div class="rwDialogText">
                        {1}
                    </div>
                </h5>
                <div style="margin-top: 20px; margin-left: 51px;">
                    <a href="javascript:;" onclick="$find('{0}').close(true);">
                        <img src="Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                </div>
            </div>
        </AlertTemplate>
    </telerik:RadWindowManager>
    <script type="text/javascript">
        //        $(function () {
        //            $("#<%=txtPINCode.ClientID %>").prop("type", "password");
        //        });

        function validatePincode(sender, args) {
            if (!isNaN(args.Value.trim()) && args.Value.trim().length >= 4 && args.Value.trim().length <= 8) {
                args.IsValid = true;
            } else {
                args.IsValid = false;
            }
        }

        function validateSSNCode(sender, args) {
            if (!isNaN(args.Value.trim()) && args.Value.trim().length == 4) {
                args.IsValid = true;
                return;
            }
            args.IsValid = false;
        }


        function clearFieldValues(requestFrom) {
            if (requestFrom == "SSN") {

                var ssn = $find("<%=txtPINCode.ClientID %>");
                ssn.set_value("");
            } else {
                var pincode = $find("<%=txtSSNCode.ClientID %>");
                pincode.set_value("");
            }
        }

        function validateInputs() {
            var errorList = "<div style='margin:-10px 0px 5px -30px;'>Please fix the following and retry:<br></div>";
            var isPageValid = false;
            var lastName = $find("<%=txtLastName.ClientID %>");
            var dob = $find("<%=dtDateofBirth.ClientID %>");
            var accountId = $find("<%=txtAccountID.ClientID %>");
            var ssn = $find("<%=txtSSNCode.ClientID %>");
            var pincode = $find("<%=txtPINCode.ClientID %>");

            if (lastName.get_value() == "") {
                errorList = errorList + "- Last name is required<br />";
            }

            if (dob.get_selectedDate() == null) {
                errorList = errorList + "- Date of birth is required<br />";
            }

            if (accountId.get_value() == "") {
                errorList = errorList + "- Account ID is required<br />";
            }

            if (isNaN(ssn.get_value().trim())) {
                errorList = errorList + "- SSN should be a number<br />";
            }

            if (ssn.get_value().length > 0 && ssn.get_value().length != 4) {
                errorList = errorList + "- SSN should be 4 digits<br />";
            }

            if (ssn.get_value() == "" && pincode.get_value() == "") {
                errorList = errorList + "- Please enter SSN or PIN<br />";
            }

            if (isNaN(pincode.get_value())) {
                errorList = errorList + "- PIN should be a number<br />";
            }

            if (pincode.get_value().length > 0 && pincode.get_value().length < 4) {
                errorList = errorList + "- PIN is between 4 and 8 digits<br />";
            }

            if (errorList.length > 90) {
                radalert(errorList, 350, 150, '', "", "Content/Images/warning.png");
            }

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('LoginUserValidationGroup');
            }

            if (isPageValid && errorList.length > 90) {
                isPageValid = false;
            }

            return isPageValid;
        }

    </script>
</asp:Content>
