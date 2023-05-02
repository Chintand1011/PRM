<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="insurances.aspx.cs"
    Inherits="insurances" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <%--<asp:UpdatePanel runat="server">
        <ContentTemplate>--%>
    <div class="hdrTitle">
        <h1>Patient Insurance</h1>
    </div>
    <div class="bodyMain">
        <h2>Review and update patient health insurance information. If the patient's carrier
            is not available, you may add it under the administrative menu.</h2>
        <table width="100%">
            <tr>
                <td>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Active Carrier:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <telerik:radcombobox id="cmbActiveCarriers" runat="server" emptymessage="Choose Carrier..."
                                width="350px" maxheight="200" allowcustomtext="False" markfirstmatch="True" datatextfield="CarrierName"
                                datavaluefield="CarrierID">
                            </telerik:radcombobox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbActiveCarriers"
                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Active Carrier is required."
                                ErrorMessage="Active Carrier is required." ValidationGroup="InsuranceValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                </td>
                <td colspan="2"></td>
            </tr>
            <tr>
                <td>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Plan Type:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <telerik:radcombobox id="cmbPlanTypes" runat="server" emptymessage="Choose Plan Type..." onselectedindexchanged="cmbPlanTypes_OnSelectedIndexChanged" autopostback="True"
                                width="350px" maxheight="200" allowcustomtext="False" markfirstmatch="True" datatextfield="PolicyAbbr"
                                datavaluefield="PolicyTypeID">
                            </telerik:radcombobox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbPlanTypes" Display="Dynamic"
                                SetFocusOnError="True" CssClass="failureNotification" ToolTip="Plan Type is required."
                                ErrorMessage="Plan Type is required." ValidationGroup="InsuranceValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Plan Name:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtPlanName" Width="344px" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPlanName" Display="Dynamic"
                                SetFocusOnError="True" CssClass="failureNotification" ToolTip="Plan Name is required."
                                ErrorMessage="Plan Name is required." ValidationGroup="InsuranceValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Relationship Type:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <telerik:radcombobox id="cmbRelationshipType" runat="server" emptymessage="Choose Relationship Type..." onselectedindexchanged="cmbRelationshipType_OnSelectedIndexChanged"
                                maxheight="200" allowcustomtext="False" markfirstmatch="True" datatextfield="RelationAbbr" autopostback="True"
                                datavaluefield="RelTypeID">
                            </telerik:radcombobox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbRelationshipType"
                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Relationship Type is required."
                                ErrorMessage="Relationship Type is required." ValidationGroup="InsuranceValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Subscriber ID:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtSubscriberID" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtSubscriberID"
                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="SubscriberID is required."
                                ErrorMessage="SubscriberID is required." ValidationGroup="InsuranceValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Group Number:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtGroupNumber" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Plan ID:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtPlanID" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Expiration:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <telerik:raddatepicker id="dtExpiration" mindate="2006/1/1" runat="server">
                            </telerik:raddatepicker>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="dtExpiration" Display="Dynamic"
                                SetFocusOnError="True" CssClass="failureNotification" ToolTip="Expiration is required."
                                ErrorMessage="Expiration is required." ValidationGroup="InsuranceValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Eligibility Phone:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtEligibilityPhone" runat="server"></asp:TextBox>
                        </div>
                    </div>
                </td>
                <td>&nbsp;
                </td>
                <td valign="top">
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label ID="lblPatientInfo" runat="server"></asp:Label>
                        </div>
                        <div class="editor-field">
                            &nbsp;
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">First Name:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtFirstName" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLastName"
                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="First Name is required."
                                ErrorMessage="First Name is required." ValidationGroup="InsuranceValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Last Name:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtLastName" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLastName"
                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Last Name is required."
                                ErrorMessage="Last Name is required." ValidationGroup="InsuranceValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Date of Birth:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <telerik:raddatepicker id="dtDOB" mindate="1900/1/1" runat="server">
                            </telerik:raddatepicker>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="dtDOB"
                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Date Of Birth is required."
                                ErrorMessage="Date Of Birth is required." ValidationGroup="InsuranceValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Social Security:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <telerik:radmaskedtextbox id="txtSSN" runat="server" mask="###-##-####"
                                width="149">
                            </telerik:radmaskedtextbox>
                            <asp:RegularExpressionValidator Display="Dynamic" runat="server" ToolTip="Format is XXX-XX-XXXX"
                                ErrorMessage="Social Security's Format should be XXX-XX-XXXX" SetFocusOnError="True"
                                CssClass="failureNotification" ControlToValidate="txtSSN" ValidationGroup="InsuranceValidationGroup"
                                ValidationExpression="\d{3}\-\d{2}\-\d{4}">*</asp:RegularExpressionValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Gender:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <telerik:radcombobox id="cmbGender" runat="server" emptymessage="Choose Gender"
                                maxheight="200" allowcustomtext="False" markfirstmatch="True">
                            </telerik:radcombobox>
                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbGender"
                                Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Gender is required."
                                ErrorMessage="Gender is required." ValidationGroup="InsuranceValidationGroup">*</asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Pri Ins Card:</asp:Label>
                        </div>
                        <div id="divInsCardImage" runat="server" class="editor-upload-field">
                            <telerik:radasyncupload runat="server" id="insCard1ImageUpload" maxfilesize="5242880"
                                multiplefileselection="Disabled" maxfileinputscount="1" allowedfileextensions=".jpeg,.jpg,.png" />
                        </div>
                        <div id="divInsDownloadRemove" class="editor-field" runat="server" visible="False">
                            <asp:Label ID="lblInsCardImage" runat="server"></asp:Label>
                            &nbsp;
                            <asp:ImageButton ID="insImageDownload" ImageUrl="~/Content/Images/download.ico" Width="20"
                                AlternateText="Download" runat="server" OnClick="insImageDownload_Click" />&nbsp;<asp:ImageButton
                                    ID="insImageRemove" ImageUrl="~/Content/Images/close.ico" Width="20" AlternateText="Remove"
                                    runat="server" OnClick="insImageRemove_Click" />
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Sec Ins Card:</asp:Label>
                        </div>
                        <div id="divIDCardImage" runat="server" class="editor-upload-field">
                            <telerik:radasyncupload runat="server" id="insCard2ImageUpload" maxfileinputscount="1"
                                maxfilesize="5242880" multiplefileselection="Disabled" allowedfileextensions=".jpeg,.jpg" />
                        </div>
                        <div id="divIDDownloadRemove" class="editor-field" runat="server" visible="False">
                            <asp:Label ID="lblIDCardImage" runat="server"></asp:Label>
                            &nbsp;
                            <asp:ImageButton ID="cardImageDownload" ImageUrl="~/Content/Images/download.ico"
                                Width="20" AlternateText="Download" runat="server" OnClick="cardImageDownload_Click" />&nbsp;<asp:ImageButton
                                    ID="cardImageRemove" ImageUrl="~/Content/Images/close.ico" Width="20" AlternateText="Remove"
                                    runat="server" OnClick="cardImageRemove_Click" />
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <div class="form-row">
                        <div class="editor-label">
                            <asp:Label runat="server">Notes:</asp:Label>
                        </div>
                        <div class="editor-field">
                            <asp:TextBox ID="txtNotes" Rows="6" Columns="80" runat="server" TextMode="MultiLine">
                            </asp:TextBox>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:HiddenField ID="hdnIns" runat="server" />
                </td>
                <td>
                    <asp:ImageButton ID="btnSubmit" ImageUrl="../Content/Images/btn_submit.gif" runat="server"
                        OnClick="btnSubmit_Click" CssClass="btn-submit" OnClientClick="return enableDisableButton(this);" />&nbsp;<asp:ImageButton
                            ID="btnCancel" ImageUrl="../Content/Images/btn_cancel.gif" CssClass="btn-cancel"
                            runat="server" />
                </td>
            </tr>
            <tr>
                <td colspan="2"></td>
                <td>
                    <div class="form-row">
                        <div class="editor-label">
                            &nbsp;
                        </div>
                        <div class="editor-field">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="InsuranceValidationGroup"
                                ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <asp:HiddenField ID="hdnPath" runat="server" />
    </div>
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
    <%--</ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript">

        function viewPdfViewer() {
            var popupName = "View Image";
            var location = $("#<%=hdnPath.ClientID %>").val() + "report/pdfviewer_popup.aspx?PopupTitle=" + popupName;
            window.open(location, popupName, "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");
            window.document.title = popupName;
        }

        function enableDisableButton(obj) {
            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('InsuranceValidationGroup');
            }
            if (isPageValid) {
                obj.disabled = 'disabled';
                <%= ClientScript.GetPostBackEventReference(btnSubmit, string.Empty) %>;
                return false;
            }

        }


    </script>
</asp:Content>
