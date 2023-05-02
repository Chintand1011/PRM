<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="feeschedule.aspx.cs"
    Inherits="feeschedule" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">

    <style type="text/css">
        .rwLoading {
            background-image: none !important;
        }
    </style>

</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligibility" runat="server">
        <Triggers>
            <asp:PostBackTrigger ControlID="lnkDownloadSampleFile" />
        </Triggers>
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Fee Schedule Management</h1>
            </div>
            <div class="bodyMain">
                <h2>Manage carrier fee schedules for the practice or by individual providers. Note that global fee schedules may not be modified.</h2>
                <table width="100%">
                    <asp:Panel ID="pnlExistingFeeSchedule" runat="server">
                        <tr>
                            <td colspan="2">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Existing Schedule:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:radcombobox id="cmbFeeSchedules" runat="server" width="300px" emptymessage="Choose Fee Schedule..."
                                            allowcustomtext="False" markfirstmatch="True" autopostback="True" datatextfield="ScheduleName"
                                            datavaluefield="FeeScheduleID" maxheight="200" onselectedindexchanged="cmbFeeSchedules_SelectedIndexChanged">
                                        </telerik:radcombobox>
                                    </div>
                                    <div class="editor-field" id="divRunNew" runat="server">
                                        &nbsp;or &nbsp;
                                        <asp:ImageButton ID="btnNewFeeSchedule" CssClass="btn-new" runat="server" ImageUrl="../Content/Images/btn_new.gif"
                                            OnClick="btnNewFeeSchedule_Click" />
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </asp:Panel>
                    <h3 id="hFeeScheduleTitle" runat="server" visible="False" class="bolder">Add New FeeSchedule.
                    </h3>
                    <asp:Panel ID="pnlFeeScheduleDetail" runat="server" Visible="False">
                        <tr>
                            <td colspan="2">
                                <hr />
                            </td>
                        </tr>
                        <tr>
                            <td width="50%" valign="top">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label1" runat="server">Carrier:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:radcombobox id="cmbCarriers" runat="server" width="300px" emptymessage="Choose Carrier..."
                                            autopostback="True" onselectedindexchanged="cmbCarriers_OnSelectedIndexChanged"
                                            allowcustomtext="False" markfirstmatch="True" datatextfield="CarrierName" datavaluefield="CarrierID"
                                            maxheight="200">
                                        </telerik:radcombobox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbCarriers" Display="Dynamic"
                                            SetFocusOnError="True" CssClass="failureNotification" ToolTip="Carrier is required."
                                            ErrorMessage="Carrier is required." ValidationGroup="FeeScheduleInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label2" runat="server">Descriptive Name:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtDescriptiveName" runat="server" MaxLength="50" Width="295px"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtDescriptiveName"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Descriptive Name is required."
                                            ErrorMessage="Descriptive Name is required." ValidationGroup="FeeScheduleInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label4" runat="server">Display Name:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtDisplayName" runat="server" MaxLength="30" Width="295px"></asp:TextBox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtDisplayName" Display="Dynamic"
                                            SetFocusOnError="True" CssClass="failureNotification" ToolTip="Display Name is required."
                                            ErrorMessage="Display Name is required." ValidationGroup="FeeScheduleInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label6" runat="server">Reference ID:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtReferenceID" runat="server" MaxLength="30"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label8" runat="server">Notes:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <asp:TextBox ID="txtNotes" TextMode="MultiLine" Width="350px" Height="90px" CssClass="textarea"
                                            runat="server"></asp:TextBox>
                                        <br />
                                        <div runat="server" id="divIndividualPractices" visible="False" style="font-weight: bold; margin-top: 20px;">
                                            <asp:Label ID="lblIndividualpractice" ForeColor="red" runat="server">Global Fee Schedules cannot be modified by individual practices</asp:Label>
                                        </div>
                                    </div>
                                </div>

                                <% if (cmbFeeSchedules.SelectedValue != "")
                                   { %>

                                <div class="form-row">
                                    <div class="editor-label">
                                        &nbsp;
                                    </div>
                                    <div class="editor-field">
                                        <a href="javascript:;" onclick="printPopup()">
                                            <img src="../Content/Images/toolbar_print.gif" class="btn-print" alt="Print" />
                                            <b>Print Fee Schedules</b>
                                        </a>
                                    </div>
                                </div>

                                <% } %>


                                <div runat="server" id="divManageFeeSchdule" visible="False">

                                    <div class="form-row">
                                        <div class="editor-label">
                                            &nbsp;
                                        </div>
                                        <div class="editor-field">
                                            <asp:ImageButton ID="btnViewImportPopup" OnClick="ShowPopup"
                                                ImageUrl="~/Content/Images/toolbar_tupfs.png" runat="server" />
                                            <asp:LinkButton runat="server" ID="lnkImportFeeSchedule" OnClick="ShowPopup" Text="Import Fee Schedule"></asp:LinkButton>
                                            &nbsp;
                                            (<asp:LinkButton ID="lnkDownloadSampleFile" OnClick="lnkDownloadSampleFile_OnClick" Text="Download Sample File" runat="server"></asp:LinkButton>)
                                            <br />
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="editor-label">
                                            &nbsp;
                                        </div>
                                        <div class="editor-field">
                                            <asp:ImageButton ID="btnViewFullSchedule" OnClick="ShowPopup"
                                                ImageUrl="~/Content/Images/icon_pdfblue.gif" runat="server" />
                                            <asp:LinkButton runat="server" ID="lnkManageFeeScheduleCodes" OnClick="ShowPopup" Text="Manage Fee Schedule Codes"></asp:LinkButton>
                                            
                                            <br />
                                        </div>
                                    </div>

                                </div>

                            </td>
                            <td width="50%" valign="top">
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label runat="server">Status Type:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:radcombobox id="cmbStatusTypes" runat="server" width="200px" emptymessage="Choose Status Type..."
                                            allowcustomtext="False" markfirstmatch="True" datatextfield="ProviderAbbr" datavaluefield="ProviderID"
                                            maxheight="200">
                                        </telerik:radcombobox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbStatusTypes" Display="Dynamic"
                                            SetFocusOnError="True" CssClass="failureNotification" ToolTip="Status Type is required."
                                            ErrorMessage="Status Type is required." ValidationGroup="FeeScheduleInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label3" runat="server">Service Type:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:radcombobox id="cmbServiceTypes" runat="server" width="200px" emptymessage="Choose Service Type..."
                                            allowcustomtext="False" markfirstmatch="True" datatextfield="ServiceAbbr" datavaluefield="ServiceClassTypeID"
                                            maxheight="200">
                                        </telerik:radcombobox>
                                        <asp:RequiredFieldValidator runat="server" ControlToValidate="cmbServiceTypes" Display="Dynamic"
                                            SetFocusOnError="True" CssClass="failureNotification" ToolTip="Service Type is required."
                                            ErrorMessage="Service Type is required." ValidationGroup="FeeScheduleInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label20" runat="server">Global Schedule:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:radcombobox id="cmbGlobalSchedule" runat="server" width="200px" emptymessage="Choose Global Schedule..."
                                            autopostback="True" onselectedindexchanged="cmbGlobalSchedule_OnSelectedIndexChanged"
                                            allowcustomtext="False" markfirstmatch="True" maxheight="200">
                                        </telerik:radcombobox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="cmbGlobalSchedule"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Global Schedule is required."
                                            ErrorMessage="Global Schedule is required." ValidationGroup="FeeScheduleInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label5" runat="server">Provider:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:radcombobox id="cmbProviders" runat="server" width="200px" emptymessage="Choose Provider..."
                                            allowcustomtext="False" markfirstmatch="True" datatextfield="ProviderAbbr" datavaluefield="ProviderID"
                                            maxheight="200">
                                        </telerik:radcombobox>
                                        <asp:RequiredFieldValidator ID="rqdProivders" runat="server" ControlToValidate="cmbProviders"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Provider is required."
                                            ErrorMessage="Provider is required." ValidationGroup="FeeScheduleInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label7" runat="server">Contract Type:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:radcombobox id="cmbContractTypes" runat="server" width="200px" emptymessage="Choose Contract Type..."
                                            allowcustomtext="False" markfirstmatch="True" datatextfield="ProviderAbbr" datavaluefield="ProviderID"
                                            maxheight="200">
                                        </telerik:radcombobox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="cmbContractTypes"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Contract Type is required."
                                            ErrorMessage="Contract Type is required." ValidationGroup="FeeScheduleInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label9" runat="server">Reimbursement:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:radcombobox id="cmbReimbursement" runat="server" width="200px" emptymessage="Choose Reimbursement..."
                                            allowcustomtext="False" markfirstmatch="True" datatextfield="ProviderAbbr" datavaluefield="ProviderID"
                                            maxheight="200">
                                        </telerik:radcombobox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="cmbReimbursement"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Reimbursement is required."
                                            ErrorMessage="Reimbursement is required." ValidationGroup="FeeScheduleInfo">*</asp:RequiredFieldValidator>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        <asp:Label ID="Label10" runat="server">Expiration:</asp:Label>
                                    </div>
                                    <div class="editor-field">
                                        <telerik:raddatepicker id="dtExpiration" mindate="1/1/1900" runat="server" calendar-skin="Windows7"
                                            width="150" skin="Windows7" maxdate="12/31/2020">
                                        </telerik:raddatepicker>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="dtExpiration"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Expiration is required."
                                            ErrorMessage="Expiration is required." ValidationGroup="FeeScheduleInfo">*</asp:RequiredFieldValidator>
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
                                        <%--<asp:Button ID="btnCancel" Text="Cancel" runat="server" OnClick="btnCancel_Click" />--%>
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
                                        <asp:ImageButton ID="ImageButton1" CssClass="btn-cancel" ImageUrl="../Content/Images/btn_cancel.gif" OnClientClick="refreshPage()" runat="server" />
                                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
                                        <asp:ImageButton ID="btnSubmit" CssClass="btn-submit" ImageUrl="../Content/Images/btn_submit.gif" OnClientClick="return enableDisableButton(this, true)" runat="server" OnClick="btnSubmit_Click" />
                                        &nbsp; &nbsp; &nbsp; &nbsp; 
                                </div>
                                <div class="form-row">
                                    <div class="editor-label">
                                        &nbsp;
                                    </div>
                                    <div class="editor-field">
                                        <asp:ValidationSummary ID="ValidationSummary3" runat="server" ValidationGroup="FeeScheduleInfo"
                                            ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                            CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                                        <div class="success-message">
                                            <asp:Literal ID="litFeeScheduleMessage" runat="server"></asp:Literal>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                        <%--<tr>
                            <asp:Panel ID="pnlManageServiceCharge" Visible="False" runat="server">
                                <tr>
                                    <td colspan="2">
                                        <hr />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <h2 style="font-weight: 300;">Manage Service Charges</h2>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <h3 id="hServiceTitle" runat="server" visible="False" class="bolder">Add New Service Charge
                                        </h3>
                                        <div class="form-row" id="divTopServicePanel" runat="server">
                                            <div class="editor-label">
                                                <asp:Label ID="Label11" runat="server">Service Code:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <telerik:radcombobox id="cmbServiceCodes" runat="server" width="300px" emptymessage="Choose Service Code..."
                                                    allowcustomtext="False" markfirstmatch="True" autopostback="True" datatextfield="CPTTitle"
                                                    datavaluefield="CPTCode" maxheight="200" onselectedindexchanged="cmbServiceCodes_SelectedIndexChanged">
                                                </telerik:radcombobox>
                                            </div>
                                            <div class="editor-field" id="divNewServiceCode" runat="server">
                                                &nbsp;or &nbsp;<asp:ImageButton ID="btnNewServiceCode" runat="server" ImageUrl="../Content/Images/btn_new.gif"
                                                    OnClick="btnNewServiceCode_Click" />
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <asp:Panel ID="pnlServiceCharge" runat="server" Visible="False">
                                    <tr>
                                        <td colspan="2">
                                            <hr />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td width="50%" valign="top">
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label12" runat="server">Service Code:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox ID="txtServiceCode" runat="server" MaxLength="5"></asp:TextBox>
                                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" Display="Dynamic"
                                                        ControlToValidate="txtServiceCode" CssClass="failureNotification" ValidationExpression="^[\s\S]{5,}$"
                                                        runat="server" ToolTip="Invalid Service Code." ErrorMessage="Invalid Service Code.">*</asp:RegularExpressionValidator>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtServiceCode"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Service Code is required."
                                                        ErrorMessage="Service Code is required." ValidationGroup="ServiceChargeInfo">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label13" runat="server">Short Name:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox ID="txtShortName" MaxLength="50" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtShortName"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Short Name is required."
                                                        ErrorMessage="Short Name is required." ValidationGroup="ServiceChargeInfo">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label14" runat="server">Invoice Name:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox ID="txtInvoiceName" MaxLength="50" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txtInvoiceName"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Status Type is required."
                                                        ErrorMessage="Status Type is required." ValidationGroup="ServiceChargeInfo">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label15" runat="server">Description:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox ID="txtDescription" MaxLength="500" TextMode="MultiLine" Width="350px"
                                                        Height="90px" CssClass="textarea" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                        </td>
                                        <td width="50%" valign="top">
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label16" runat="server">Service Type:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radcombobox id="cmbServiceChargeServiceTypes" runat="server" width="200px"
                                                        emptymessage="Choose Service Type..." allowcustomtext="False" markfirstmatch="True"
                                                        datatextfield="ServiceAbbr" datavaluefield="ServiceTypeID" maxheight="200">
                                                    </telerik:radcombobox>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="cmbServiceChargeServiceTypes"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Status Type is required."
                                                        ErrorMessage="Status Type is required." ValidationGroup="ServiceChargeInfo">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label17" runat="server">Category:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <asp:TextBox ID="txtCategory" runat="server"></asp:TextBox>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label18" runat="server">Provider Charge:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radnumerictextbox runat="server" id="txtProviderCharge" width="150px" cssclass="sumamount"
                                                        type="Currency" numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                                    </telerik:radnumerictextbox>
                                                    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="txtProviderCharge"
                                                        ToolTip="Provider charge should be greater than 0" ErrorMessage="Provider charge should be greater than 0"
                                                        Display="Dynamic" ForeColor="Red" ValidationGroup="ServiceChargeInfo" ValueToCompare="0"
                                                        Operator="GreaterThan">*</asp:CompareValidator>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="txtProviderCharge"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Provider Charge is required."
                                                        ErrorMessage="Provider Charge is required." ValidationGroup="ServiceChargeInfo">*</asp:RequiredFieldValidator>
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    <asp:Label ID="Label19" runat="server">Allowable:</asp:Label>
                                                </div>
                                                <div class="editor-field">
                                                    <telerik:radnumerictextbox runat="server" id="txtAllowable" width="150px" cssclass="sumamount"
                                                        type="Currency" numberformat-decimaldigits="2" numberformat-groupseparator=",">
                                                    </telerik:radnumerictextbox>
                                                    <asp:CompareValidator ID="CompareValidator3" runat="server" ControlToValidate="txtAllowable"
                                                        ControlToCompare="txtProviderCharge" ToolTip="Value should be Less than or equal to Provider Charge"
                                                        ErrorMessage="Value should be Less than or equal to Provider Charge" Display="Dynamic"
                                                        ForeColor="Red" ValidationGroup="ServiceChargeInfo" Operator="LessThanEqual">*</asp:CompareValidator>
                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="txtAllowable"
                                                        Display="Dynamic" SetFocusOnError="True" CssClass="failureNotification" ToolTip="Allowable is required."
                                                        ErrorMessage="Allowable is required." ValidationGroup="ServiceChargeInfo">*</asp:RequiredFieldValidator>
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
                                                    &nbsp;
                                                </div>
                                                <div class="editor-field">
                                                    <asp:HiddenField ID="hdnIsRebind" runat="server" />
                                                    <asp:HiddenField ID="hdnWidth" runat="server" />
                                                    <asp:ImageButton ID="btnServiceChargeCancel" ImageUrl="../Content/Images/btn_cancel.gif"
                                                        CssClass="btn-cancel" OnClick="btnServiceChargeCancel_Click" runat="server" />
                                                    &nbsp;
                                                    <asp:ImageButton ID="btnServiceChargeSubmit" ImageUrl="../Content/Images/btn_submit.gif"
                                                        CssClass="btn-submit" OnClientClick="return enableDisableButton(this, false);" runat="server"
                                                        OnClick="btnServiceChargeSubmit_Click" />
                                                </div>
                                            </div>
                                            <div class="form-row">
                                                <div class="editor-label">
                                                    &nbsp;
                                                </div>
                                                <div class="editor-field">
                                                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="ServiceChargeInfo"
                                                        ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                        CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                                                    <div id="divSuccessMessage" class="success-message">
                                                        <asp:Literal ID="litServiceChargeMessage" runat="server"></asp:Literal>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </asp:Panel>
                            </asp:Panel>
                        </tr>--%>
                    </asp:Panel>
                </table>
                <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="700" height="500px"
                    modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    skin="CareBlueInf">
                    <AlertTemplate>
                        <div class="rwDialogPopup radalert">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div id="divbuttons" style="margin-top: 20px; margin-left: 51px;">
                                <a href="#" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            </div>
                        </div>
                    </AlertTemplate>
                </telerik:radwindowmanager>
                <telerik:radwindowmanager id="RadWindowManager1" showcontentduringload="True" visiblestatusbar="False"
                    visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                    modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                    RestrictionZoneID="divMainContent" skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize"
                    style="z-index: 3000">
                    <Windows>
                        <telerik:RadWindow runat="server" ID="popupImportFeeSchedule" Width="790px" Height="500px"
                            NavigateUrl="~/report/importFeeSchedules_popup.aspx" DestroyOnClose="True">
                        </telerik:RadWindow>
                    </Windows>
                </telerik:radwindowmanager>
                <telerik:radwindow runat="server" id="popupFeeSchedule" navigateurl="~/report/feeschedule_popup.aspx"
                    showcontentduringload="False" visiblestatusbar="False" visibletitlebar="True" onclientshow="OnClientShow" onclientpageload="OnClientPageLoad"
                    reloadonshow="True" width="1100px" height="850px" modal="True" enableshadow="False"
                    enableembeddedbasestylesheet="False" enableembeddedskins="False" skin="CareBlue"
                    behaviors="Pin,Reload,Close,Move,Resize" destroyonclose="True" style="z-index: 3000">
                </telerik:radwindow>
                <%-- <asp:Button ID="btnReset" Style="display: none;" OnClick="btnReset_OnClick" runat="server" />--%>
            </div>

            <div id="loading" style="display: none; text-align: center; margin: auto;">
                <img src="../Content/Images/loading.gif" alt="Loading..." />
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">
        function printPopup() {
            var location = "<%=Extension.ClientSession.WebPathRootProvider %>" + "report/feeSchedulePrint_popup.aspx";
            window.open(location, "WindowPopup", "width=700px, height=860px, scrollbars=yes");
        }

        function reloadPage() {
            
            var href = location.href.replace("#", "");
            location.href = href;
        }

        function enableDisableButton(obj, isFeeSchedule) {

            if (isFeeSchedule) {
                var isPageValid = false;
                if (typeof (Page_ClientValidate) == 'function') {
                    isPageValid = Page_ClientValidate('FeeScheduleInfo');
                }
                if (isPageValid) {
                    var combobox = $find("<%= cmbFeeSchedules.ClientID %>");
                    var selectedValue = combobox == null ? 0 : combobox.get_value();
                    obj.disabled = 'disabled';
                    obj.src = selectedValue == 0 ? "../Content/Images/btn_submit_fade.gif" : "../Content/Images/btn_update_fade.gif";
                    <%= ClientScript.GetPostBackEventReference(btnSubmit, string.Empty) %>;
                    return false;
                }
            } else {
                var isValid = false;
                if (typeof (Page_ClientValidate) == 'function') {
                    isValid = Page_ClientValidate('ServiceChargeInfo');
                }
                <%--if (isValid) {
                    var combobox = $find("<%= cmbServiceCodes.ClientID %>");
                    var selectedValue = combobox == null ? 0 : combobox.get_value();
                    obj.disabled = 'disabled';
                    obj.src = selectedValue == 0 ? "../Content/Images/btn_submit_fade.gif" : "../Content/Images/btn_update_fade.gif";
                    <%= ClientScript.GetPostBackEventReference(btnServiceChargeSubmit, string.Empty) %>;
                    return false;
                }--%>
            }


        }


        // For telerik popup
        function OnClientShow(sender, args) {
            loadingSign = $get("loading");
            contentCell = sender._contentCell;
            if (contentCell && loadingSign) {
                contentCell.appendChild(loadingSign);
                contentCell.style.verticalAlign = "middle";
                loadingSign.style.display = "";
            }
        }

        function OnClientPageLoad(sender, args) {
            if (contentCell && loadingSign) {
                contentCell.removeChild(loadingSign);
                contentCell.style.verticalAlign = "";
                loadingSign.style.display = "none";
            }
        }

    </script>
</asp:Content>