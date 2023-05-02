<%@ Page Language="C#" AutoEventWireup="true" CodeFile="myinfo_popup_obsolete.aspx.cs" Inherits="myinfo_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title />
    <script src="Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
    </telerik:RadScriptManager>
    <asp:UpdatePanel ID="MyInfoUpdatePancel" runat="server">
        <ContentTemplate>
            <div class="pgColumn2" style="background-image: url('Content/Images/popup_back_lg.jpg');">
                <h1>
                    Update Profile</h1>
                <h3>
                    You may update your mailing address and change your preference for delivery of statements.
                    Please call your provider to update your primary billing address.
                </h3>
                <hr />
                <br />
                &nbsp;
                <table width="100%">
                    <tr>
                        <td width="49%" valign="top">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Primary Address:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblPatientName" runat="server"></asp:Label><br />
                                    <asp:Label ID="lblStreet" runat="server"></asp:Label><br />
                                    <asp:Label ID="lblAptSuite" runat="server"></asp:Label><br />
                                    <asp:Label ID="lblCity" runat="server"></asp:Label><br />
                                    <asp:Label ID="lblState" runat="server"></asp:Label><br />
                                    <asp:Label ID="lblZipCode" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblStatements" runat="server" Text="Send Statements To:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbStatements" runat="server" Width="149px" DataTextField="Abbr"
                                        AllowCustomText="False" MarkFirstMatch="True" DataValueField="LocationID" MaxHeight="200">
                                    </telerik:RadComboBox>
                                    <asp:RequiredFieldValidator ID="rfvStatements" runat="server" ControlToValidate="cmbStatements"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Statements is required."
                                        ValidationGroup="MyinfoValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblEmail" runat="server" Text="Email:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtEmail" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                                        SetFocusOnError="True" CssClass="failureNotification" ToolTip="Email is required."
                                        Display="Dynamic" ValidationGroup="MyinfoValidationGroup">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="regEmail" runat="server" CssClass="failureNotification"
                                        ToolTip="Invalid Email." ControlToValidate="txtEmail" Display="Dynamic" SetFocusOnError="true"
                                        ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                        ValidationGroup="MyinfoValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    &nbsp;
                                </div>
                                <div class="editor-field">
                                    <asp:CheckBox ID="chkEmailMyStatements" runat="server" Text="Email My Statements" />
                                </div>
                            </div>
                        </td>
                        <td width="2%">
                            &nbsp;
                        </td>
                        <td width="49%" valign="top">
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblAlternateMailingAddress" runat="server" Text="Secondary Mailing Address:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblAltAptSuite" runat="server" Text="Apt/Suite:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtAltAptSuite" runat="server" MaxLength="30"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblAltcity" runat="server" Text="City:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtAltCity" runat="server" MaxLength="30"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblAltState" runat="server" Text="State:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadComboBox ID="cmbAltStates" runat="server" Width="149px" EmptyMessage="Choose State..."
                                        AllowCustomText="False" MarkFirstMatch="True" DataTextField="Name" DataValueField="StateTypeID"
                                        MaxHeight="200">
                                    </telerik:RadComboBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblZipCode1" runat="server" Text="Zip Code +4:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtAltZipCode1" runat="server" CssClass="zip-code1" MaxLength="5"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtAltZipCode1"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{5}$"
                                        ToolTip="Invalid Zip Code 1" ValidationGroup="MyinfoValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="Label1" runat="server" Text="-"></asp:Label>
                                    <asp:TextBox ID="txtAltZipCode2" runat="server" CssClass="zip-code2" MaxLength="4"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtAltZipCode2"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ValidationExpression="^[0-9]{4}$"
                                        ToolTip="Invalid Zip Code 2" ValidationGroup="MyinfoValidationGroup">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblAltPhone" runat="server" Text="Alt Phone:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:RadMaskedTextBox ID="txtAltPhone" runat="server" Mask="(###) ###-####" Width="149">
                                    </telerik:RadMaskedTextBox>
                                    <asp:RegularExpressionValidator Display="Dynamic" runat="server" ToolTip="Format is (XXX) XXX-XXXX"
                                        SetFocusOnError="True" CssClass="failureNotification" ControlToValidate="txtAltPhone"
                                        ValidationGroup="MyinfoValidationGroup" ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                &nbsp;
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblAltStreet" runat="server" Text="Street:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtAltStreet" runat="server" MaxLength="30"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                &nbsp;
                            </div>
                            <div class="form-row">
                                &nbsp;
                            </div>
                            <div class="form-row">
                                &nbsp;
                            </div>
                            <div class="form-row">
                                <div class="editor-field">
                                    <input type="button" value="Cancel" onclick="closePopup()" />&nbsp;
                                    <asp:Button runat="server" Text="Next" ID="btnUpdate" OnClick="btnUpdate_Click" ValidationGroup="MyinfoValidationGroup" />
                                </div>
                            </div>
                            <asp:ValidationSummary runat="server" ValidationGroup="MyinfoValidationGroup" ShowSummary="True"
                                CssClass="failureNotification" HeaderText="Please fix the errors highlighted above." />
                            <div id="divSuccessMessage" class="success-message">
                                <asp:Literal ID="litMessage" runat="server"></asp:Literal></div>
                        </td>
                    </tr>
                </table>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript" language="javascript">

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {

            $(function () {
                setTimeout('$("#divSuccessMessage").html("");', 3000);
            });
        });

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }

        function closePopup() {
            GetRadWindow().close();
        }
    </script>
    </form>
</body>
</html>
