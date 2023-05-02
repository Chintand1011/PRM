<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="messagectr.aspx.cs"
    Inherits="messagectr" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <link href="../Styles/Popup.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="../Scripts/radwindowPrintButton.js"></script>
    <script type="text/javascript">
        function printWin(e) {
            var oWnd = $find("<%=popupEstimateView.ClientID%>");
            oWnd.close();
            createPDF();
        }

        function createPDF() {
            blockUI();
            $("#<%=btnCreatePDF.ClientID %>").click();
        }

    </script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelEligility" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Practice Message Center</h1>
            </div>
            <div class="bodyMain">
                <h2>Manage notifications, pending actions and patient messages from one place. Messages from the last 90 days are shown unless the filter is set to an alternate date range.</h2>
                <div>
                    <telerik:radpanelbar runat="server" id="RadPanelBar1" width="1161">
                        <Items>
                            <telerik:RadPanelItem Expanded="False" Text="Filters">
                                <ContentTemplate>
                                    <table class="align-label" style="margin-top: 15px">
                                        <tr>
                                            <td>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label1" runat="server" Text="Patient:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbPatients" runat="server" Width="200px" EmptyMessage="All Patients" AutoPostBack="True" ItemRequestTimeout="500"
                                                            AllowCustomText="True" EnableLoadOnDemand="True" OnItemsRequested="cmbPatients_ItemsRequested" MarkFirstMatch="True" DataTextField="ComboBoxAbbr" DataValueField="PatientID"
                                                            MaxHeight="200">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label2" runat="server" Text="Location:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbLocations" runat="server" Width="200px" EmptyMessage="All Locations"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="LocationID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label3" runat="server" Text="Provider:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbProviders" runat="server" Width="200px" EmptyMessage="All Providers"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="ProviderAbbr" DataValueField="ProviderID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label21" runat="server" Text="Assigned:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbUsers" runat="server" Width="200px" EmptyMessage="All Users"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="NameAbbr" DataValueField="SysUserID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label5" runat="server" Text="Types:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbTypes" runat="server" Width="200px" EmptyMessage="All Types"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="Abbr" DataValueField="MessageTypeID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label6" runat="server" Text="Priority:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbPriority" runat="server" Width="200px" EmptyMessage="All Priorities"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataValueField="MessagePriorityTypeID" DataTextField="Abbr">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label30" runat="server" Text="Status:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadComboBox ID="cmbStates" runat="server" Width="200px" EmptyMessage="All States"
                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="StateAbbr" DataValueField="TransactionStateTypeID">
                                                        </telerik:RadComboBox>
                                                    </div>
                                                </div>
                                                <div class="form-row">
                                                    <div class="editor-label">
                                                        <asp:Label ID="Label7" runat="server" Text="Message Date:"></asp:Label>
                                                    </div>
                                                    <div class="editor-field">
                                                        <telerik:RadDatePicker ID="dtDateMin" runat="server" MinDate="1/1/2010" Width="100"
                                                            CssClass="set-telerik-ctrl-width">
                                                        </telerik:RadDatePicker>
                                                        -
                                    <telerik:RadDatePicker ID="dtDateMax" runat="server" MinDate="1/1/2010" Width="100"
                                        CssClass="set-telerik-ctrl-width">
                                    </telerik:RadDatePicker>
                                                        <asp:CompareValidator ID="CompareValidator2" ControlToValidate="dtDateMax" ControlToCompare="dtDateMin"
                                                            Operator="GreaterThan" Display="dynamic" SetFocusOnError="True" CssClass="failureNotification"
                                                            ErrorMessage="Date must be greater." ToolTip="Date must be greater." runat="server"
                                                            ValidationGroup="Transaction" Text="*" />
                                                    </div>
                                                </div>
                                                <div style="margin-left: 60px;">
                                                    <asp:ImageButton ID="btnClear" ImageUrl="../Content/Images/btn_clear.gif" CssClass="btn-clear"
                                                        OnClick="btnClear_OnClick" runat="server" />
                                                    &nbsp;
                                <asp:ImageButton ID="btnSearch" CssClass="btn-search" ImageUrl="../Content/Images/btn_search.gif" OnClientClick="showProgressPopup();"
                                    OnClick="btnSearch_Click" runat="server" ValidationGroup="Transaction" />
                                                </div>
                                                <div>
                                                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="Transaction"
                                                        ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                                        CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </telerik:RadPanelItem>
                        </Items>
                    </telerik:radpanelbar>
                </div>
                <table width="100%">
                    <tr>
                        <td>
                            <div>
                                <telerik:radgrid id="grdMessages" runat="server" allowsorting="True" allowpaging="True"
                                    onneeddatasource="grdMessages_NeedDataSource" pagesize="20" onitemcommand="grdMessages_OnItemCommand"
                                    onitemdatabound="grdMessages_ItemDataBound" ondetailtabledatabind="grdMessages_OnDetailTableDataBind">
                                    <MasterTableView AutoGenerateColumns="False" DataKeyNames="MessageID,FlagRead,FlagArchive,FlagMessage,ImageFilename,MessageAssignUserID">
                                        <DetailTables>
                                           <telerik:GridTableView Name="MessageDetails" AutoGenerateColumns="False" Width="100%">
                                             <Columns>
                                               <telerik:GridTemplateColumn>
                                                <ItemTemplate>
                                                    <table width="100%" border="0">
                                                       <tr valign="top">
                                                           <td width="250">
                                                               <asp:Literal ID="ltSubject" runat="server"></asp:Literal> <br/>
                                                               <asp:Literal ID="ltDateTime" runat="server"></asp:Literal> <br/>
                                                               <asp:Literal ID="ltMsgStatus" runat="server"></asp:Literal> <br/>
                                                               <div style="line-height:0.5em;">&nbsp;</div>
                                                               Assigned User: <br/>
                                                               <div style="line-height:0.5em;">&nbsp;</div>
                                                               <telerik:RadComboBox ID="cmbAllUsers"  Command="AssignUser" runat="server" Width="200px" EmptyMessage="Un Assigned" AutoPostBack="True" OnSelectedIndexChanged="ProcessCommands"
                                                                 AllowCustomText="False" MarkFirstMatch="True" DataTextField="NameAbbr" DataValueField="SysUserID">
                                                               </telerik:RadComboBox> <br/>
                                                               <div style="line-height:0.5em;">&nbsp;</div>
                                                               <telerik:RadButton Command="UnRead" FlagState="" ID="btnUnRead" Text="Unread" OnClick="ProcessCommands" runat="server"></telerik:RadButton>
                                                               <telerik:RadButton Command="Forward" ID="btnForward" Text="Forward" OnClick="ProcessCommands"  runat="server"></telerik:RadButton> <br/>
                                                               <div style="line-height:0.5em;">&nbsp;</div>
                                                               <div id="divPatientID" runat="server" Visible="False">
                                                                   View Details: <br/>
                                                                   <div style="line-height:0.5em;">&nbsp;</div>
                                                                   <span style="line-height:2.2em;">
                                                                       <telerik:RadButton Command="Patient" ID="btnPatient" Text="Patient" OnClick="ProcessCommands" runat="server"></telerik:RadButton>
                                                                       <telerik:RadButton Command="Statement" ID="btnStatement" Text="Statement" OnClick="ProcessCommands" runat="server"></telerik:RadButton>
                                                                       <telerik:RadButton Command="Transaction" ID="btnTransaction" Text="Transaction" OnClick="ProcessCommands" runat="server"></telerik:RadButton>
                                                                       <telerik:RadButton Command="PayPlan" ID="btnPayPlan" Text="PayPlan" OnClick="ProcessCommands" runat="server"></telerik:RadButton>
                                                                       <telerik:RadButton Command="Bluecredit" ID="btnBluecredit" Text="Bluecredit" OnClick="ProcessCommands" runat="server"></telerik:RadButton>
                                                                       <telerik:RadButton Command="PFS" ID="btnPfs" Text="PFS" OnClick="ProcessCommands" runat="server"></telerik:RadButton>
                                                                   </span>
                                                                   <br/>
                                                                       <div style="line-height:0.5em;">&nbsp;</div>
                                                                       <asp:Label id="lblContactNameAbbr" runat="server"></asp:Label> Contact Info:  <br/>
                                                                       <div style="line-height:0.5em;">&nbsp;</div>
                                                                       &nbsp; <asp:Label ID="lblPatient" runat="server"></asp:Label> <%--(<asp:Label ID="lblPatientID" runat="server"></asp:Label>)--%> <br />
                                                                       &nbsp; <asp:Label id="lblContactAddr" runat="server"></asp:Label> <br />
                                                                       &nbsp; <asp:Label id="lblContactCSZ" runat="server"></asp:Label> <br />
                                                                       &nbsp; <asp:Label id="lblContactPhone" runat="server"></asp:Label> <br />
                                                                       &nbsp; <asp:Label id="lblContactEmail" runat="server"></asp:Label> <br />
                                                                       &nbsp;
                                                              </div>

                                                            <!-- 
                                                                <telerik:RadButton Command="FlagMessage" FlagState="" ID="btnFlag" Text="Flag" OnClick="ProcessCommands" runat="server"></telerik:RadButton>
                                                                <telerik:RadButton Command="Close" ID="btnClose" Text="Close" OnClientClicked="showRadConfirm" AutoPostBack="False" runat="server"></telerik:RadButton>
                                                                <telerik:RadButton ID="btnArchive" OnClick="MakeMessageArchive" FlagState="" CssClass="archive" Style="display: none;" runat="server"/>
                                                            -->

                                                           </td>
                                                           <td width="500">
                                                               <span style="line-height:2.0em; font-weight:600;">Message:</span>
                                                               <div runat="server" id="divMessageBody" align="left"></div>

                                                                <div style="margin-left:20px; margin-top:10px;" id="divAccountID" runat="server" Visible="False">
                                                                    <asp:Label runat="server">Message sent in reference to Account ID:</asp:Label> <asp:Label ID="lblAccountID" runat="server"></asp:Label>
                                                                </div>
                                                                <div style="margin-left:20px; margin-top:10px;" id="divBluecreditId" runat="server" Visible="False">
                                                                    <asp:Label runat="server">Message sent in reference to BlueCredit ID:</asp:Label> <asp:Label ID="lblBluecreditID" runat="server"></asp:Label>
                                                                </div>
                                                                <div style="margin-left:20px; margin-top:10px;" id="divPaymentPlanID" runat="server" Visible="False">
                                                                    <asp:Label runat="server">Message sent in reference to Payment Plan ID:</asp:Label> <asp:Label ID="lblPaymentPlanID" runat="server"></asp:Label>
                                                                </div>
                                                                <div style="margin-left:20px; margin-top:10px;" id="divStatementID" runat="server" Visible="False">
                                                                    <asp:Label runat="server">Message sent in reference to Statement ID:</asp:Label> <asp:Label ID="lblStatementID" runat="server"></asp:Label>
                                                                    <asp:Label runat="server"><br /> &nbsp; &nbsp; &nbsp; &nbsp; Patient Balance:</asp:Label> <asp:Label ID="lblPatientBal" runat="server"></asp:Label>
                                                                    <asp:Label runat="server"><br /> &nbsp; &nbsp; &nbsp; &nbsp; Total Payments:</asp:Label> <asp:Label ID="lblPatientPay" runat="server"></asp:Label>
                                                                </div>
                                                                <div style="margin-left:20px; margin-top:10px;" id="divTransactionID" runat="server" Visible="False">
                                                                    <asp:Label runat="server">Message sent in reference to Transaction ID:</asp:Label> <asp:Label ID="lblTransactionID" runat="server"></asp:Label>
                                                                </div>
                                                                <div style="margin-left:20px; margin-top:10px;" id="divPFSID" runat="server" Visible="False">
                                                                    <asp:Label runat="server">Message sent in reference to Credit Report ID:</asp:Label> <asp:Label ID="lblPFSID" runat="server"></asp:Label>
                                                                </div>
                                                                <span style="line-height:2.0em; font-weight:600;">Message Reply:</span>
                                                               <div> <%=ReplyMessage %></div>
                                                               <div style="margin-top:10px;">
                                                                   <b id="bReplyLabel" runat="server"></b>
                                                                   <div style="line-height:0.5em;">&nbsp;</div>
                                                                   <asp:TextBox ID="txtReply" style="font-family:calibri; font-size:1.2em;" Width="350" Height="100" TextMode="MultiLine" Rows="10" Columns="40" runat="server"></asp:TextBox><br />
                                                                   <asp:ImageButton ID="btnSaveReply" style="margin:5px 0 0 0px;" Command="SaveReply" OnClientClick="disableButton(this);" OnClick="SaveMessageNotesOrReply" ImageUrl="../Content/Images/btn_send_small.gif" runat="server" />
                                                               </div>

                                                           </td>
                                                           <td>
                                                                <div style="line-height:0.5em;">&nbsp;</div>
                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                    <tr style="line-height:1.0em;">
                                                                        <td width="60">Type:</td>
                                                                        <td><asp:Label ID="lblType" runat="server"></asp:Label> (<asp:Label ID="lblRestricted" runat="server"></asp:Label>)</td>
                                                                    </tr>
                                                                    <tr style="line-height:1.0em;">
                                                                        <td>Priority:</td>
                                                                        <td><asp:Label ID="lblPriority" runat="server"></asp:Label></td>
                                                                    </tr>
                                                                    <tr style="line-height:1.0em;">
                                                                        <td>Due Date:</td>
                                                                        <td><asp:Label ID="lblDueDate" runat="server"></asp:Label> </td>
                                                                    </tr>
                                                                    <tr style="line-height:1.0em;">
                                                                        <td>Read Date:</td>
                                                                        <td><asp:Label ID="lblDateRead" runat="server"></asp:Label> <asp:Label ID="lblReadUserName" runat="server"></asp:Label> </td>
                                                                    </tr>
                                                                    <tr style="line-height:1.0em;">
                                                                        <td>Archived:</td>
                                                                        <td><asp:Label ID="lblDateArchived" runat="server"></asp:Label> <asp:Label ID="lblArchiveUserName" runat="server"></asp:Label> </td>
                                                                    </tr>
                                                                </table>

                                                               <div style="line-height:0.5em;">&nbsp;</div>
                                                               &nbsp; Notes:
                                                               <div style="line-height:0.5em;">&nbsp;</div>
                                                               <asp:TextBox ID="txtNotes" style="font-family:calibri; font-size:1.2em; margin-left:6px;" Width="270" Height="120" TextMode="MultiLine" Rows="10" Columns="40" runat="server"></asp:TextBox><br />
                                                               <asp:ImageButton ID="btnSaveNotes" style="margin:5px 0 0 6px;" Command="SaveNotes" OnClientClick="disableButton(this);" OnClick="SaveMessageNotesOrReply" ImageUrl="../Content/Images/btn_update_small.gif" runat="server" />

                                                           </td>
                                                        </tr>
                                                    </table>
                                                    &nbsp;
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                             </Columns>
                                           </telerik:GridTableView>
                                         </DetailTables>
                                        <Columns>
                                            <telerik:GridBoundColumn HeaderText="ID" DataField="MessageID">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridButtonColumn HeaderText="" UniqueName="FlagRead" ButtonType="ImageButton"
                                                    ImageUrl="~/Content/images/spacer_transparent.gif">
                                            </telerik:GridButtonColumn>
                                            <telerik:GridTemplateColumn>
                                                <ItemTemplate>
                                                    <asp:Image ID="imgPriority" runat="server" />
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                            <telerik:GridBoundColumn HeaderText="Priority" DataField="MessageStatusTypeAbbr">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Type" DataField="MessageTypeAbbr">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Subject" DataField="MessageSubject">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Patient" DataField="PatientName">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Assigned" UniqueName="MessageAssignUserName" DataField="MessageAssignUserName">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Date" UniqueName="DateCreated" DataField="DateCreated">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridButtonColumn CommandName="Flag" UniqueName="Flag" HeaderText="Flag" ButtonType="ImageButton">
                                            </telerik:GridButtonColumn>
                                            <telerik:GridButtonColumn CommandName="Archive" UniqueName="ArchiveView" HeaderText="Archive" ButtonType="ImageButton"
                                                    ImageUrl="~/Content/Images/icon_archive.png">
                                            </telerik:GridButtonColumn>
                                        <%--  
                                            <telerik:GridBoundColumn HeaderText="Priority" DataField="MessagePriorityTypeAbbr">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Provider" DataField="ProviderName">
                                            </telerik:GridBoundColumn>
                                        --%>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:radgrid>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <telerik:radwindow id="popupSendMessage" showcontentduringload="True" visiblestatusbar="False"
                behaviors="Reload,Close" visibletitlebar="True" reloadonshow="True"
                runat="Server" width="450px" height="310px" modal="True" enableshadow="False"
                enableembeddedbasestylesheet="False" enableembeddedskins="False" skin="CareBlue">
                <ContentTemplate>
                    <div>
                        <table class="CareBluePopup" width="100%">
                            <tr>
                                <td>
                                    <h2p>Forward Message</h2p>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <h4p>Use this form to forward this message to another email address.</h4p>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div style="margin: 20px 0 0 0px;">
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label14" CssClass="lblInputR" runat="server" Text="Email Address:"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEmail" runat="server" style="font-family:calibri; font-size:1.2em;" width="250"></asp:TextBox>
                                                    <asp:RegularExpressionValidator ID="regEmail" runat="server" CssClass="failureNotification"
                                                        ErrorMessage="Invalid Email" ToolTip="Invalid Email." ControlToValidate="txtEmail"
                                                        Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$"
                                                        ValidationGroup="MessageValidation">*</asp:RegularExpressionValidator>
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" Display="Dynamic"
                                                        ErrorMessage="Email is required." SetFocusOnError="True" CssClass="failureNotification"
                                                        ToolTip="Email is required." ValidationGroup="MessageValidation">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr valign="top">
                                                <td>
                                                    <asp:Label ID="Label19" runat="server" CssClass="lblInputR" Text="Recipient Note:"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtNote" TextMode="MultiLine" style="font-family:calibri; font-size:1.2em;" Width="250" Height="82" Rows="10" Columns="40" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNote" Display="Dynamic"
                                                        ErrorMessage="Note is required." SetFocusOnError="True" CssClass="failureNotification"
                                                        ToolTip="Note is required." ValidationGroup="MessageValidation">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                        </table>

                                    </div>
                                    <div style="margin-top: 10px">
                                        <asp:HiddenField ID="hdnIsShowPDFViewer" runat="server" />
                                        <asp:Image ImageUrl="../Content/Images/btn_cancel.gif" Style="cursor: pointer;" CssClass="btn-pop-cancel" onclick="closePopup()" runat="server" />
                                        <asp:Image ImageUrl="../Content/Images/btn_submit.gif" Style="cursor: pointer;" CssClass="btn-pop-submit" onclick="validateInputsandSendMessage();" runat="server" />
                                        <asp:ValidationSummary ID="ValidationSummary3" runat="server" ValidationGroup="MessageValidation"
                                            ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                            CssClass="failureNotification" HeaderText="Please correct the following and resubmit:" />
                                    </div>

                                </td>
                            </tr>
                        </table>
                    </div>
                    <asp:Button ID="btnCreatePDF" OnClick="btnCreatePDF_OnClick" runat="server" Style="display: none" />
                </ContentTemplate>
            </telerik:radwindow>
            <telerik:radwindow runat="server" id="popupEstimateView" cssclass="customprintbutton" onclientshow="OnClientShow"
                navigateurl="~/report/estimateview_popup.aspx" destroyonclose="True"
                showcontentduringload="True" visiblestatusbar="False" visibletitlebar="True"
                reloadonshow="True" width="860px" height="850px" modal="True" enableshadow="False"
                enableembeddedbasestylesheet="False" enableembeddedskins="False" behaviors="Pin,Reload,Close,Move,Resize"
                skin="CareBlueInv">
            </telerik:radwindow>
            <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="1100px" height="850px"
                modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize" style="z-index: 3000">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popupPaymentPlan" Width="790px" Height="500px"
                        NavigateUrl="~/report/managePaymentPlan_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupEditBlueCredit" Width="1050px" Height="780px"
                        NavigateUrl="~/report/bluecredit_editcredit_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupManageAccounts" Width="750px" Height="650px"
                        NavigateUrl="~/report/pc_add_popup.aspx?ShowPaymentMethods=1">
                    </telerik:RadWindow>
                    <telerik:RadWindow runat="server" ID="popupCreditReport" Width="810px" Height="850px"
                        NavigateUrl="~/report/pfs_viewpro_popup.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                     <telerik:RadWindow runat="server" ID="popupPaymentReceipt" NavigateUrl="~/report/paymentReceipt_popup.aspx"
                        Width="450" Height="670" CssClass="customprintbutton" DestroyOnClose="True">
                    </telerik:RadWindow>
                </Windows>
            </telerik:radwindowmanager>
            <telerik:radwindowmanager id="radConfirm" showcontentduringload="True" visiblestatusbar="False"
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
                               <a href="javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_ok.gif" alt="Ok" /></a>  &nbsp; &nbsp; 
                                 <a href="Javascript:;" onclick="$find('{0}').close(false);">
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
                        <div style="margin-top: 20px; margin-left: 51px;">
                            <a href="javascript:;" onclick="$find('{0}').close(true);">
                                <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                        </div>
                    </div>
                </AlertTemplate>
            </telerik:radwindowmanager>

            <asp:HiddenField ID="hdnIsRedirectToBluecredit" runat="server" />
            <asp:HiddenField ID="hdnIsRedirectToStatus" runat="server" />
            <asp:Button ID="btnSendMessage" OnClick="btnSendMessage_OnClick" Style="display: none;" runat="server" />
            <asp:Button ID="btnAssignValues" OnClick="btnAssignValues_OnClick" Style="display: none;" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript">

        var url = "<%=ClientSession.WebPathRootProvider%>";
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {


            if ($("#<%=hdnIsRedirectToBluecredit.ClientID%>").val() != "") {
                if ($("#<%=hdnIsRedirectToBluecredit.ClientID%>").val() == "1") {
                    url = url + "patient/bluecredit.aspx";
                } else {
                    url = url + "patient/paymentplans.aspx";
                }

                location.href = url;
            }

            if ($("#<%=hdnIsRedirectToStatus.ClientID%>").val() != "") {
                location.href = url + "patient/status.aspx";
                $("#<%=hdnIsRedirectToStatus.ClientID%>").val("");
            }


            if ($("#<%=hdnIsShowPDFViewer.ClientID %>").val() == "1") {
                viewPdfViewer();
                $("#<%=hdnIsShowPDFViewer.ClientID %>").val("");
            }

            unBlockUI();
        });


        function validateInputsandSendMessage() {

            var isPageValid = false;

            if (typeof (Page_ClientValidate) == 'function') {
                isPageValid = Page_ClientValidate('MessageValidation');
            }

            if (isPageValid) {
                blockUI();
                $("#<%=btnSendMessage.ClientID%>").click();
            }

        }


        function validateandArchiveMessage(isConfirmed) {
            if (isConfirmed) {
                __doPostBack('ArchiveMessage');
            }
        }

        function assignValues(isBlueCredit) {
            $("#<%=hdnIsRedirectToBluecredit.ClientID%>").val(isBlueCredit);
            $("#<%=btnAssignValues.ClientID%>").click();
        }

        function closePopup() {
            $find("<%=popupSendMessage.ClientID%>").close();
        }

        function showProgressPopup() {
            blockUI();
        }

        function showAddPaymentPopup() {

            var popup = $find("<%=popupManageAccounts.ClientID%>");
            popup.show();

            window.setTimeout(function () {
                popup.setActive(true);
                popup.set_modal(true);
            }, 0);

        }

        function genericFunction() {
            var popup = $find("<%=popupPaymentPlan.ClientID%>");
            popup.reload();
        }

        function disableButton(button) {

            button = $(button);

            setTimeout(function () {
                button.addClass("disable-button");
                button.attr("disabled", "disabled");
            }, 1000);
        }

    </script>

</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript">

        //Need this function it being used in TUPFS popup
        function redirectToPFSReport() {

        }

        function viewPdfViewer() {
            var popupName = "Estimate";
            var location = "<%=ClientSession.WebPathRootProvider %>" + "report/pdfviewer_popup.aspx";
            window.open(location, popupName, "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");
        }

    </script>
</asp:Content>
