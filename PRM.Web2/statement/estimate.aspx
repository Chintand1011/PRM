<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="estimate.aspx.cs"
    Inherits="estimate" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div style="float: right; width: 100%">
                <div class="hdrTitle">
                    <h1>New Estimate Utility</h1>
                </div>
                <div class="bodyMain">
                    <h2>Description will be there.</h2>
                    <table>
                        <tr>
                            <asp:Panel ID="pnlTop" runat="server">
                                <td>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Patient:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:RadComboBox ID="cmbPatients" runat="server" Width="200px" EmptyMessage="Choose Patient..."
                                                AllowCustomText="False" MarkFirstMatch="True" AutoPostBack="True" DataTextField="PatientAbbr"
                                                DataValueField="PatientID" MaxHeight="200" OnSelectedIndexChanged="cmbPatients_SelectedIndexChanged">
                                            </telerik:RadComboBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbPatients" Display="Dynamic"
                                                SetFocusOnError="True" CssClass="failureNotification" ToolTip="Patient is required."
                                                ValidationGroup="UtilityValidationGroup">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Eligibility:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:RadComboBox ID="cmbEligibility" runat="server" Width="200px" EmptyMessage="Choose Eligibility Response..."
                                                AllowCustomText="False" MarkFirstMatch="True" AutoPostBack="True" DataTextField="EligName"
                                                DataValueField="EligibilityID" MaxHeight="200" OnSelectedIndexChanged="cmbEligibility_SelectedIndexChanged">
                                            </telerik:RadComboBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbEligibility" Display="Dynamic"
                                                SetFocusOnError="True" CssClass="failureNotification" ToolTip="Eligibility is required."
                                                ValidationGroup="UtilityValidationGroup">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Relation:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:RadComboBox ID="cmbRelations" runat="server" Width="200px" EmptyMessage="Choose Place Type..."
                                                AllowCustomText="False" MarkFirstMatch="True" AutoPostBack="True" DataTextField="RelationAbbr"
                                                DataValueField="RelTypeID" MaxHeight="200" OnSelectedIndexChanged="cmbRelations_SelectedIndexChanged">
                                            </telerik:RadComboBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbRelations" Display="Dynamic"
                                                SetFocusOnError="True" CssClass="failureNotification" ToolTip="Relation is required."
                                                ValidationGroup="UtilityValidationGroup">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                </td>
                                <td>&nbsp;
                                </td>
                                <td>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Carrier Name:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtCarrierName" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Eligibility Date:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:RadDatePicker ID="dtEligibilityDate" MinDate="1900/1/1" runat="server" CssClass="set-telerik-ctrl-width"
                                                Enabled="False">
                                            </telerik:RadDatePicker>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Plan Status:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtPlanStatus" runat="server" MaxLength="30" Enabled="False"></asp:TextBox>
                                        </div>
                                    </div>
                                </td>
                            </asp:Panel>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <asp:Panel ID="pnlMiddle" runat="server" Enabled="False">
                                <td>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Provider:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:RadComboBox ID="cmbProviders" runat="server" Width="200px" EmptyMessage="Choose Provider..."
                                                AllowCustomText="False" MarkFirstMatch="True" AutoPostBack="True" DataTextField="ProviderAbbr"
                                                DataValueField="ProviderID" MaxHeight="200" OnSelectedIndexChanged="cmbProviders_SelectedIndexChanged">
                                            </telerik:RadComboBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbProviders" Display="Dynamic"
                                                SetFocusOnError="True" CssClass="failureNotification" ToolTip="Provider is required."
                                                ValidationGroup="UtilityValidationGroup">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Service Type:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:RadComboBox ID="cmbServiceType" runat="server" Width="200px" EmptyMessage="Choose Service Type..."
                                                AllowCustomText="False" MarkFirstMatch="True" AutoPostBack="True" DataTextField="ServiceAbbr"
                                                DataValueField="ServiceClassTypeID" MaxHeight="200" OnSelectedIndexChanged="cmbServiceType_SelectedIndexChanged">
                                            </telerik:RadComboBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbServiceType" Display="Dynamic"
                                                SetFocusOnError="True" CssClass="failureNotification" ToolTip="Provider is required."
                                                ValidationGroup="UtilityValidationGroup">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Place of Service:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:RadComboBox ID="cmbPlaceTypes" runat="server" Width="200px" EmptyMessage="Choose Place Type..."
                                                AllowCustomText="False" MarkFirstMatch="True" AutoPostBack="True" DataTextField="PlaceAbbr"
                                                DataValueField="PlaceofServiceTypeID" MaxHeight="200" OnSelectedIndexChanged="cmbPlaceTypes_SelectedIndexChanged">
                                            </telerik:RadComboBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbPlaceTypes" Display="Dynamic"
                                                SetFocusOnError="True" CssClass="failureNotification" ToolTip="Place of Service is required."
                                                ValidationGroup="UtilityValidationGroup">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Fee Schedule:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <telerik:RadComboBox ID="cmbFeeSchedules" runat="server" Width="200px" EmptyMessage="Choose Schedule..."
                                                AllowCustomText="False" MarkFirstMatch="True" AutoPostBack="True" DataTextField="ScheduleAbbr"
                                                DataValueField="FeeScheduleID" MaxHeight="200" Enabled="False" OnSelectedIndexChanged="cmbFeeSchedules_SelectedIndexChanged">
                                            </telerik:RadComboBox>
                                            <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbFeeSchedules" Display="Dynamic"
                                                SetFocusOnError="True" CssClass="failureNotification" ToolTip="Fee Schedule is required."
                                                ValidationGroup="UtilityValidationGroup">*</asp:RequiredFieldValidator>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Contract Type:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:RadioButton ID="rdbtnInNetwork" Checked="True" Text="In Network" runat="server"
                                                GroupName="ContractType" />&nbsp;<asp:RadioButton ID="rdbtnOutNetwork" Text="Out of Network"
                                                    runat="server" GroupName="ContractType" />
                                        </div>
                                    </div>
                                </td>
                                <td></td>
                                <td>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Service Zip:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtServiceZip" runat="server" CssClass="zip-code1" Enabled="False"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="CoPay Amount:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtCoPayAmount" runat="server" CssClass="zip-code1" Enabled="False"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Co Insurance:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtCoInsurance" runat="server" CssClass="zip-code1" Enabled="False"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Deduct / Met:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtDeduct" runat="server" CssClass="zip-code1" Enabled="False"></asp:TextBox>
                                        </div>
                                        <div class="editor-field">
                                            <asp:Label runat="server" Text="/"></asp:Label>
                                            <asp:TextBox ID="txtDeductCYTD" runat="server" CssClass="zip-code2" Enabled="False"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="editor-label">
                                            <asp:Label runat="server" Text="Stop-Loss / Met:"></asp:Label>
                                        </div>
                                        <div class="editor-field">
                                            <asp:TextBox ID="txtStopLoss" runat="server" CssClass="zip-code1" Enabled="False"></asp:TextBox>
                                        </div>
                                        <div class="editor-field">
                                            <asp:Label runat="server" Text="/"></asp:Label>
                                            <asp:TextBox ID="txtStopLossCYT" runat="server" CssClass="zip-code2" Enabled="False"></asp:TextBox>
                                        </div>
                                    </div>
                                </td>
                            </asp:Panel>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <asp:Panel ID="pnlBottomHCPCS" runat="server" Enabled="False">
                                    <div align="right">
                                        <asp:ImageButton ID="lnkShowMoreRows" runat="server" ImageUrl="../Content/Images/btn_showmore_fade.gif"
                                            Enabled="False" OnClick="lnkShowMoreRows_Click"></asp:ImageButton><asp:Literal ID="litSpace"
                                                runat="server" Text=" | "></asp:Literal>
                                        <asp:ImageButton ID="lnkShowFewer" Enabled="False" runat="server" ImageUrl="../Content/Images/btn_showless_fade.gif"
                                            OnClick="lnkShowFewer_Click"></asp:ImageButton>
                                    </div>
                                    <asp:CustomValidator ValidationGroup="UtilityValidationGroup" ClientValidationFunction="validateCPTInformation"
                                        CssClass="failureNotification" runat="server" Display="Dynamic" ToolTip="Please enter CPT number for atleast one item.">*</asp:CustomValidator>
                                    <telerik:RadGrid ID="grdHcpcs" runat="server" Width="100%">
                                        <MasterTableView AutoGenerateColumns="False" DataMember="SerialNo" DataKeyNames="SerialNo">
                                            <Columns>
                                                <telerik:GridBoundColumn DataField="SerialNo">
                                                    <HeaderStyle Width="5px" />
                                                </telerik:GridBoundColumn>
                                                <telerik:GridTemplateColumn UniqueName="Validation">
                                                    <HeaderStyle Width="5px" />
                                                    <ItemTemplate>
                                                        <asp:CustomValidator ID="cstmValidator" CssClass="failureNotification" runat="server"
                                                            ValidationGroup="UtilityValidationGroup" Display="Dynamic" ToolTip="Invalid CPT Code, please enter the correct CPT Code."><img src="../Content/Images/caution.ico" alt="*"/></asp:CustomValidator>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="CPT" UniqueName="CPT">
                                                    <HeaderStyle Width="50px" />
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtCPTNumber" autocomplete="off" MaxLength="5" Text='<%# Bind("CptNo") %>'
                                                            onkeyup="ontextchanged(this,event)" onchange="javascript: validateCptNumber(this);"
                                                            runat="server" Width="70"></asp:TextBox>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn UniqueName="Controls">
                                                    <ItemTemplate>
                                                        <headerstyle width="0px" />
                                                        <table cellpadding="0" cellspacing="0" id="tblControls" runat="server" visible="False"
                                                            style="padding: 0px;">
                                                            <tr style="padding-bottom: 0px;">
                                                                <td style="padding-left: 0px; width: 0px;">
                                                                    <div id="divImages" runat="server">
                                                                        <asp:ImageButton ID="btnUp" ImageUrl="../Content/Images/up.gif" ToolTip="Move this row to Up"
                                                                            OnClick="btnUp_OnClick" runat="server" />
                                                                        <br />
                                                                        <asp:ImageButton ID="btnDown" ImageUrl="../Content/Images/down.gif" ToolTip="Move this row to bottom"
                                                                            OnClick="btnDown_OnClick" runat="server" />
                                                                    </div>
                                                                </td>
                                                                <td style="padding-left: 0px; width: 0px;">
                                                                    <asp:ImageButton ID="btnDeleteRow" ImageUrl="../Content/Images/delete.ico" OnClick="btnDeleteRow_OnClick"
                                                                        Style="float: right;" ToolTip="Delete this row" Visible="True" runat="server" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Quantity" UniqueName="Quantity">
                                                    <HeaderStyle Width="31px" />
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtQuantity" Text='<%# Bind("Quantity") %>' Enabled="False" runat="server"
                                                            onchange="javascript: validateQuantity(this);" Width="31"></asp:TextBox>
                                                        <asp:RangeValidator ID="rngValidator" CssClass="failureNotification" runat="server"
                                                            Type="Integer" MinimumValue="1" MaximumValue="999" ControlToValidate="txtQuantity"
                                                            ValidationGroup="UtilityValidationGroup" Display="Dynamic" ToolTip="Quantity should between in 1 to 999.">*</asp:RangeValidator>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Date" UniqueName="Date">
                                                    <HeaderStyle Width="100px" />
                                                    <ItemTemplate>
                                                        <telerik:RadDatePicker ID="dtDate" SelectedDate='<%# Bind("Dated") %>' Enabled="False"
                                                            onchange="javascript: validateDateTime(this);" MinDate="1900/1/1" Width="100" MaxDate="<%# DateTime.Now %>"
                                                            runat="server" CssClass="set-telerik-ctrl-width">
                                                        </telerik:RadDatePicker>
                                                        <asp:CustomValidator ID="cstmValidatorDate" CssClass="failureNotification" ValidateEmptyText="True"
                                                            Enabled="False" runat="server" ControlToValidate="dtDate" ClientValidationFunction="validateDate"
                                                            ValidationGroup="UtilityValidationGroup" Display="Dynamic" ToolTip="Date should be less than today"
                                                            ErrorMessage="Date should be less than today">*</asp:CustomValidator>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="S" UniqueName="FieldS">
                                                    <HeaderStyle Width="20px" />
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtS" Enabled="False" Text='<%# Bind("FieldS") %>' runat="server"
                                                            Width="20"></asp:TextBox>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Description" UniqueName="Description">
                                                    <HeaderStyle Width="425px" />
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtDescription" Enabled="False" Text='<%# Bind("Description") %>'
                                                            runat="server" Width="500"></asp:TextBox>
                                                        <asp:CustomValidator ID="cstmValidatorDescription" CssClass="failureNotification"
                                                            ValidateEmptyText="True" Enabled="False" runat="server" ControlToValidate="txtDescription"
                                                            ClientValidationFunction="validateDescription" ValidationGroup="UtilityValidationGroup"
                                                            Display="Dynamic" ToolTip="Description should between in 5 to 200" ErrorMessage="Description should between in 5 to 200">*</asp:CustomValidator>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn>
                                                    <HeaderStyle Width="40px" />
                                                    <ItemTemplate>
                                                        <asp:Button ID="btnCpt" Text="" OnClick="btnCpt_OnClick" runat="server" Style="display: none" />
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Charge" UniqueName="charge">
                                                    <HeaderStyle Width="100px" />
                                                    <ItemTemplate>
                                                        <telerik:RadNumericTextBox runat="server" ID="txtCharge" DbValue='<%# Bind("Charge") %>'
                                                            CssClass="charge" Enabled="False" Width="90" Type="Currency" NumberFormat-DecimalDigits="2"
                                                            NumberFormat-GroupSeparator=",">
                                                        </telerik:RadNumericTextBox>
                                                        <asp:CustomValidator ID="cstmValidatorCharge" CssClass="failureNotification" ValidateEmptyText="True"
                                                            Enabled="False" runat="server" ControlToValidate="txtCharge" ClientValidationFunction="validateCharge"
                                                            ValidationGroup="UtilityValidationGroup" Display="Dynamic" ToolTip="Charge must be greater than 0"
                                                            ErrorMessage="Charge must be greater than 0">*</asp:CustomValidator>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                                <telerik:GridTemplateColumn HeaderText="Adjustment" UniqueName="Adjustment">
                                                    <HeaderStyle Width="100px" />
                                                    <ItemTemplate>
                                                        <%--    <asp:TextBox ID="txtAdjustment" Text='<%# Bind("Adjustment") %>'
                                                        runat="server" Width="100"></asp:TextBox>--%>
                                                        <telerik:RadNumericTextBox runat="server" ID="txtAdjustment" DbValue='<%# Bind("Adjustment") %>'
                                                            onchange="javascript: validateAdjustment(this);" Enabled="False" Width="90" Type="Currency"
                                                            NumberFormat-DecimalDigits="2" NumberFormat-GroupSeparator=",">
                                                        </telerik:RadNumericTextBox>
                                                    </ItemTemplate>
                                                </telerik:GridTemplateColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                </asp:Panel>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <asp:HiddenField ID="hdnEstimateID" runat="server" />
                                <asp:HiddenField ID="hdnShowConfirmationPopup" runat="server" />
                                <a href="javascript:;" onclick="clearGrid();" style="float: left; margin-top: 10px;">
                                    <img src="../Content/Images/btn_clear.gif" alt="Clear" class="btn-cancel"></img></a>
                                &nbsp; &nbsp; 
                                <asp:ImageButton ID="btnSubmit" ImageUrl="../Content/Images/btn_save_fade.gif" Style="margin-top: 10px; float: right;"
                                    runat="server" OnClick="btnSubmit_Click" OnClientClick="return enableDisableButton(this);"
                                    CssClass="btn-submit" />
                            </td>
                        </tr>
                    </table>
                    <div style="margin-left: 390px;">
                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="UtilityValidationGroup"
                            ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                            CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                    </div>
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
                                <a href="#" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            </div>
                        </div>
                    </AlertTemplate>
                    <ConfirmTemplate>
                        <div class="rwDialogPopup radconfirm">
                            <h5>
                                <div class="rwDialogText">
                                    {1} Estimate as been saved under that user's account. they can either make changes
                                    and update the page, or clear it.
                                </div>
                            </h5>
                            <div>
                                <div style="margin-top: 15px; margin-left: 55px;">
                                    <a href="#" onclick="$find('{0}').close(true);">
                                        <img src="../Content/Images/btn_ok.gif" alt="Ok" /></a> &nbsp; &nbsp; <a href="#"
                                            onclick="redirectPage()">
                                            <img src="../Content/Images/btn_cancel.gif" alt="Cancel" /></a>
                                </div>
                            </div>
                        </div>
                    </ConfirmTemplate>
                </telerik:RadWindowManager>
                <telerik:RadWindow runat="server" ID="popupMessage" Behaviors="Move" Style="z-index: 200001"
                    Width="460px" Height="180px" ShowContentDuringLoad="False" VisibleStatusbar="False"
                    VisibleTitlebar="True" ReloadOnShow="True" Modal="True" EnableEmbeddedBaseStylesheet="True"
                    EnableEmbeddedSkins="False" Skin="CareBlueInf">
                    <ContentTemplate>
                        <div id="divMessage" align="center">
                                <br />
                                <br />
                                <h5>A positive adjustment will increase the overall charge of the CPT. 
                                <br />If a reduction is intended, please make this adjustment negative.
                                <br />
                                <br />
                                <br />
                                <a href="javascript:;" onclick="resetAdjustment(false)">
                                    <img src="../Content/Images/btn_ignore.gif" class="btn-ignore" alt="Ignore" /></a>
                                &nbsp; &nbsp; &nbsp; &nbsp; 
                                <a href="#" onclick="resetAdjustment(true)">
                                    <img src="../Content/Images/btn_reset.gif" class="btn-reset" alt="Reset" /></a>
                            </h5>
                        </div>
                    </ContentTemplate>
                </telerik:RadWindow>
                <asp:Button ID="btnClearGird" Style="display: none" OnClick="btnClearGrid_OnClick" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript" language="javascript">

        // For Numeric inputs only
        var keyCodes = new Array(48, 49, 50, 51, 52, 53, 54, 55, 55, 56, 57, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105);

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            if ($("#<%=hdnShowConfirmationPopup.ClientID%>").val() == "1") {
                radconfirm('', confirmCallBackFn, 500, 140, "");
            }
        });


        function validateCPTInformation(source, args) {
            $(".charge").each(function () {
                if ($(this).val() == "") {
                    alert("Please enter CPT number for atleast one item.");
                    args.IsValid = false;
                    return false;
                }
                args.IsValid = true;
                return false;
            });

        }

        function ontextchanged(obj, e) {
            var length = obj.value.length;
            var isValidate = false;
            for (var i = 0; i < keyCodes.length; i++) {
                if (keyCodes[i] == e.keyCode) {
                    isValidate = true;
                }
            }
            if (length == 5 && isValidate) {
                isValidate = false;
                var btnCPTEstimateID = obj.id.replace("txtCPTNumber", "btnCpt");
                $("#" + btnCPTEstimateID).click();
            }

        }


        function validateQuantity(obj) {
            var quantityValue = $("#" + obj.id).val();
            if (quantityValue == "") {
                $("#" + obj.id).val(1);
            }
        }

        function validateCptNumber(obj) {
            var length = obj.value.length;
            if (length < 5) {
                var btnCPTEstimateID = obj.id.replace("txtCPTNumber", "btnCpt");
                $("#" + btnCPTEstimateID).click();
            }
        }

        function validateDescription(sender, args) {
            if (args.Value.trim().length >= 5 && args.Value.trim().length <= 200) {
                args.IsValid = true;
                return;
            }
            else {
                args.IsValid = false;
                return;
            }
        }
        function validateCharge(sender, arg) {
            var charge = parseInt(arg.Value);
            if (charge > 0) {
                arg.IsValid = true;
                return;
            }

            arg.IsValid = false;
        }

        function validateDate(sender, arg) {

            var requestedDate = new Date(arg.Value);
            if (requestedDate <= new Date('<%= DateTime.Now%>')) {
                arg.IsValid = true;
                return;
            }

            arg.IsValid = false;
        }

        function confirmCallBackFn(arg) {

        }

        function redirectPage() {
            var url = location.href.replace("#", "");
            location.href = url;
        }

        function validateDateTime(obj) {
            var id = obj.id.replace("wrapper", "dateInput");
            var picker = $("#" + id);
            if (picker.val() == "") {
                picker.val(new Date());
            }
        }

        var adjustmentFieldID = Object();

        function validateAdjustment(obj) {
            var adjustment = $("#" + obj.id).val();
            if (adjustment > 0) {
                adjustmentFieldID = obj.id;
                $find("<%=popupMessage.ClientID%>").show();
            }
        }

        function resetAdjustment(isReset) {
            $find("<%=popupMessage.ClientID%>").close();
            if (isReset) {
                $find(adjustmentFieldID).set_value(0);
            }
        }

        function clearGrid() {
            $("#<%=btnClearGird.ClientID%>").click();
        }


        function enableDisableButton(obj) {
            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('UtilityValidationGroup');
            }
            if (isPageValid) {
                obj.disabled = 'disabled';
                obj.src = $("#<%=hdnEstimateID.ClientID %>").val() == "" ? "../Content/Images/btn_submit_fade.gif" : "../Content/Images/btn_update_fade.gif";
                <%= ClientScript.GetPostBackEventReference(btnSubmit, string.Empty) %>;
                return false;
            }

        }

    </script>
    <script type="text/javascript" src="../Scripts/blockEnterEvent.js"></script>
</asp:Content>
