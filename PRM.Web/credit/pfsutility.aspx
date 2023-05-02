<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="pfsutility.aspx.cs"
    Inherits="pfsutility" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>BlueCredit Manager</h1>
            </div>
            <div class="bodyMain">
                <h2>Enter the known information below to request a credit report. Social security is not required - name, date of birth and any previous address is sufficient.
                    <br />All credit inquiries must be made in compliance with the Fair Credit Reporting Act and consumer protections set forth in this regulation. </h2>
                <table width="100%" style="padding-top: 20px">
                    <tr>
                        <td valign="top" width="33%">
                            <div class="form-row">
                                <div style="font-size:1.2em; font-weight:700; margin:0 0 10px 150px; color:#444444;">
                                    Patient or Guardian Info
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblFirstName" Text="First Name:" runat="server"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtFirstName" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtFirstName" CssClass="failureNotification"
                                        Display="Dynamic" SetFocusOnError="True" ToolTip="First Name is required." ErrorMessage="First Name is required."
                                        ValidationGroup="CreditValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblMiddleName" Text="Middle Name:" runat="server"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtMiddleName" runat="server" MaxLength="30"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblLastName" runat="server" Text="Last Name:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtLastName" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLastName" CssClass="failureNotification"
                                        SetFocusOnError="True" Display="Dynamic" ToolTip="Last Name is required." ErrorMessage="Last Name is required."
                                        ValidationGroup="CreditValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblDateofBirth" runat="server" AssociatedControlID="dtDateofBirth"
                                        Text="Date of Birth:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:raddatepicker id="dtDateofBirth" mindate="1900/1/1" runat="server" cssclass="DemoDate" Width="126">
                                    </telerik:raddatepicker>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblSocialSecurity" runat="server" Text="Social Security:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radmaskedtextbox id="txtSocialSecurity" runat="server" mask="###-##-####" width="100">
                                    </telerik:radmaskedtextbox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" Display="Dynamic"
                                        runat="server" ToolTip="Invalid Social Security Number." ErrorMessage="Invalid Social Security Number."
                                        CssClass="failureNotification" ControlToValidate="txtSocialSecurity" ValidationGroup="CreditValidationGroup"
                                        ValidationExpression="\d{3}\-\d{2}\-\d{4}">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblConfirmSSN" runat="server" Text="Confirm SSN:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radmaskedtextbox id="txtConfirmSSN" runat="server" mask="###-##-####" width="100">
                                    </telerik:radmaskedtextbox>
                                </div>
                                <asp:CompareValidator ID="cmpSSN" ControlToValidate="txtSocialSecurity" Display="Dynamic"
                                    ControlToCompare="txtConfirmSSN" runat="server" CssClass="failureNotification"
                                    SetFocusOnError="True" ToolTip="Social security and Confirm SSN should be same."
                                    ErrorMessage="Social security and Confirm SSN should be same." ValidationGroup="CreditValidationGroup">*</asp:CompareValidator>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label12" runat="server">*Stated Income:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radnumerictextbox type="Currency" clientevents-onkeypress="disableEnterKey" width="100" id="txtIncone" minvalue="0" value="0" maxvalue="999999" runat="server"></telerik:radnumerictextbox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label3" runat="server">*Housing:</asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbHousingType" datatextfield="Text" datavaluefield="Value"
                                        runat="server" width="117px" emptymessage="Choose Housing..." maxheight="200"
                                        allowcustomtext="False" markfirstmatch="True">
                                                    </telerik:radcombobox>
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


                        </td>
                        <td valign="top">
                            <div class="form-row">
                                <div style="font-size:1.2em; font-weight:700; margin:0 0 10px 130px; color:#444444;">
                                    Any Current or Previous Address
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblStreet" runat="server" Text="Street:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtStreet" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtStreet" CssClass="failureNotification"
                                        SetFocusOnError="True" Display="Dynamic" ToolTip="Street is required." ErrorMessage="Street is required."
                                        ValidationGroup="CreditValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblAptSuite" runat="server" Text="Apt/Suite:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtAptSuite" runat="server" MaxLength="30"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblCity" runat="server" Text="City:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtCity" runat="server" MaxLength="30"></asp:TextBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCity" CssClass="failureNotification"
                                        SetFocusOnError="True" Display="Dynamic" ToolTip="City is required." ErrorMessage="City is required."
                                        ValidationGroup="CreditValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblState" runat="server" Text="State:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbStates" runat="server" width="148px" emptymessage="Choose State..."
                                        maxheight="200" allowcustomtext="False" markfirstmatch="True" datatextfield="Name"
                                        datavaluefield="Abbr">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbStates" CssClass="failureNotification"
                                        SetFocusOnError="True" Display="Dynamic" ToolTip="State is required." ErrorMessage="State is required."
                                        ValidationGroup="CreditValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblZipCode" runat="server" Text="Zip Code +4:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:TextBox ID="txtZipCode1" runat="server" CssClass="zip-code1" width="68" MaxLength="5"></asp:TextBox>
                                </div>
                                <div class="editor-field">
                                    &nbsp;-
                                    <asp:TextBox ID="txtZipCode2" runat="server" CssClass="zip-code2" MaxLength="4"></asp:TextBox>
                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtZipCode1" CssClass="failureNotification"
                                        SetFocusOnError="True" Display="Dynamic" ToolTip="Zip Code is required." ErrorMessage="Zip Code is required."
                                        ValidationGroup="CreditValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="lblHomePhone" runat="server" Text="Home Phone:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radmaskedtextbox id="txtHomePhone" runat="server" mask="(###) ###-####"
                                        width="148">
                                    </telerik:radmaskedtextbox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" Display="Dynamic"
                                        runat="server" ToolTip="Invalid Home Phone" ErrorMessage="Invalid Home Phone"
                                        CssClass="failureNotification" ControlToValidate="txtHomePhone" ValidationGroup="CreditValidationGroup"
                                        ValidationExpression="\(\d{3}\) \d{3}\-\d{4}">*</asp:RegularExpressionValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    &nbsp;
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label ID="Label2" runat="server" Text="Internal Reference:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <telerik:radcombobox id="cmbCreditReasons" runat="server" width="200px"
                                        maxheight="200" allowcustomtext="False" markfirstmatch="True" datatextfield="Abbr"
                                        datavaluefield="TUReasonTypeID">
                                    </telerik:radcombobox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="cmbCreditReasons"
                                        CssClass="failureNotification" Display="Dynamic" SetFocusOnError="True" ToolTip="Credit Reason is required."
                                        ErrorMessage="Credit Reason is required." ValidationGroup="CreditValidationGroup">*</asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    &nbsp;
                                </div>
                                <div class="editor-field">
                                    <asp:CheckBox ID="chkAgreeTerms" runat="server" Text="I Declare Permissible Purpose and FCRA compliance" />&nbsp;
                                    <img id="Img1" src="~/Content/Images/help.png" width="12" runat="server" alt="help" onclick="gotoFCRA()" />
                                    <asp:CustomValidator ID="CustomValidator2" ValidationGroup="CreditValidationGroup"
                                        ClientValidationFunction="validatePaymentTerms" CssClass="failureNotification"
                                        SetFocusOnError="True" runat="server" Display="Dynamic" ToolTip="Please certify FCRA compliance."
                                        ErrorMessage="Please certify FCRA compliance.">*</asp:CustomValidator>
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
                            <div class="editor-field" style="margin-left:-50px;"">
                                <asp:HiddenField ID="hdnLastDayCount" runat="server" />
                                <asp:ImageButton ID="btnCancel" runat="server" OnClientClick="location.href = location.href; return false;" ImageUrl="../Content/Images/btn_clear.gif" CssClass="btn-cancel" />
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                <asp:ImageButton ID="btnSubmit" runat="server" ImageUrl="../Content/Images/btn_submit.gif"
                                    OnClick="btnSubmit_Click" OnClientClick="return  onSubmit();" CssClass="btn-submit" />
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    &nbsp;
                                </div>
                                <div class="editor-field">
                                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="CreditValidationGroup"
                                        ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                        CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
                <%--                <table width="100%">
                    <tr>
                        <td>
                            <div>
                                <h2>
                                    Credit Reports</h2>
                                <telerik:RadGrid ID="grdPastCreditReports" runat="server" AllowSorting="True" AllowPaging="True"
                                    PageSize="10" OnNeedDataSource="grdPastCreditReports_NeedDataSource" OnItemCommand="grdPastCreditReports_OnItemCommand">
                                    <MasterTableView AutoGenerateColumns="False" DataKeyNames="PFSID, respPrintImage">
                                        <Columns>
                                            <telerik:GridBoundColumn HeaderText="PFS ID" DataField="PFSID">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Submit Date" DataField="SubmitDate" DataFormatString="{0:MM/dd/yyyy}">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Date of Birth" DataField="DateofBirth" DataFormatString="{0:MM/dd/yyyy}">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Provider" DataField="ProviderName">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Result Type" DataField="ResultTypeAbbr">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Score Pfs" DataField="ScorePfs">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Score Fico" DataField="scorefico">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Residual Income" DataField="residualincome">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Debt To Income" DataField="debttoincome">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridButtonColumn CommandName="ViewHistory" HeaderText="View" ButtonType="ImageButton"
                                                ImageUrl="~/Content/Images/view.png">
                                            </telerik:GridButtonColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                            </div>
                        </td>
                    </tr>
                </table>
                --%>
            </div>
            <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="810px" height="850px"
                modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize" style="z-index: 3000">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popupCreditReport" NavigateUrl="~/report/pfs_viewpro_popup.aspx"
                        DestroyOnClose="True">
                    </telerik:RadWindow>
                </Windows>
            </telerik:radwindowmanager>
            <telerik:radwindowmanager id="radWindowDialog" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                restrictionzoneid="divMainContent" skin="CareBlueInf" style="z-index: 3000">
                <ConfirmTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div>
                                <div style="margin-top: 15px; margin-left: 55px;">
                              <a href="Javascript:;" onclick="$find('{0}').close(true);"> <img src="../Content/Images/btn_submit.gif" alt="Submit" /></a> 
                                           &nbsp; &nbsp; 
                                    <a href="#" onclick="$find('{0}').close(false);">
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
                        <div style="margin-top: 20px; margin-left: 120px;">
                            <a href="#" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:radwindowmanager>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            unBlockUI();
        });



        //        var prm = Sys.WebForms.PageRequestManager.getInstance();
        //        prm.add_endRequest(function () {
        //            $(function () {
        //                                //Clears Message After 3 Seconds
        //                setTimeout('$("#divSuccessMessage").html("");', 3000);
        //            });
        //        });
        //        
        //        function checkboxClicked(e, idFragment) {
        //            var currentCheckBox = e.srcElement || e.target;
        //            var inputs = document.getElementsByTagName("input");
        //            for (var i = 0; i < inputs.length; i++) {
        //                var input = inputs[i];
        //                if (input.id == currentCheckBox.id)
        //                    continue;
        //                if (input.id.indexOf(idFragment) < 0)
        //                    continue;
        //                //clear out the rest of the checkboxes 
        //                if (input.type && input.type == "checkbox") {
        //                    input.checked = false;
        //                }
        //            }
        //        }

        //        function isStatementSelected() {

        //            var checking = false;

        //            var inputs = document.getElementsByTagName("input");
        //            for (var i = 0; i < inputs.length; i++) {
        //                if (inputs[i].checked == true) {
        //                    checking = true;
        //                    break;
        //                }

        //            }
        //            if (!checking) {
        //                alert("Please select the statement");
        //                return false;
        //            }

        //            var isChecked = document.getElementById('').checked;
        //            if (!isChecked) {
        //                alert("Please agree for Payment and Terms");
        //                return false;
        //            }
        //            return true;
        //        }

        function validatePaymentTerms(source, args) {
            args.IsValid = document.getElementById('<%= chkAgreeTerms.ClientID %>').checked;
        }


        function redirectToPFSReport() {
            location.href = location.href;
        }

        var isValid = false;

        function validateState(sender, args) {
            setTimeout(function () {

                var combobox = $find("<%=cmbStates.ClientID %>");
                var value = combobox.get_value();

                if (value == -1) {
                    isValid = false;
                } else {
                    isValid = true;
                }

            }, 10);


            args.IsValid = isValid;

        }

        function disableEnterKey(sender, args) {
            if (args.get_keyCode() == '13')
                args.set_cancel(true);
        }

        var allowSubmit = false;

        function validateSubmit(isSubmit) {
            if (isSubmit) {
                allowSubmit = true;
                $("#<%=btnSubmit.ClientID%>").click();
            }
        }

        function onSubmit() {

            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('CreditValidationGroup');
            }

            if (!isPageValid) {
                return false;
            }

            if (!allowSubmit) {
                var picker = $find("<%= dtDateofBirth.ClientID %>");
                var ssn = $find("<%= txtSocialSecurity.ClientID %>");

                var date = picker.get_selectedDate();
                if (date == null && ssn.get_value() == '') {
                    var radWindow = $find("<%=radWindowDialog.ClientID %>");
                    radWindow.radconfirm('Date of Birth and SSN are recommended but not mandatory, would you still like to submit?', validateSubmit, 450, 150, null, '', "../Content/Images/warning.png");
                } else {
                    allowSubmit = true;
                }
            }

            // can't use same in else because mean varible being reset
            if (allowSubmit) {
                blockUI();
            }

            return allowSubmit;
        }


        function submitPfs() {
            $("#<%=btnSubmit.ClientID%>").click();
        }

        // This method being used from c# code
        function redirectToWebinquiry() {
            location.href = "<%= ClientSession.WebPathRootProvider %>" + "reporting/webinquiry.aspx";
            return false;
        }


    </script>
</asp:Content>