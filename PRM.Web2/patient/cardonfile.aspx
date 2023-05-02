<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="cardonfile.aspx.cs"
    Inherits="cardonfile" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div class="hdrTitle">
        <h1>Registered Forms of Payment</h1>
    </div>
    <div class="bodyMain">
        <h2>All forms of payment this patient has registered are displayed below. Cards registered
            by the patient throught the payment portal are also shown.</h2>
        <h3>Bank Accounts</h3>
        <telerik:RadGrid ID="grdLinkedBankAccounts" runat="server" AllowSorting="True" AllowPaging="True"
            PageSize="10" OnNeedDataSource="grdLinkedBankAccounts_NeedDataSource" OnItemCommand="grdLinkedBankAccounts_OnItemCommand"
            OnItemDataBound="grdLinkedBankAccounts_ItemDataBound">
            <MasterTableView AutoGenerateColumns="False" DataKeyNames="PaymentCardID, PNRef, FlagActivePP, FlagActiveBC,ActivePPAbbr,ActiveBCAbbr" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No linked banking accounts have been saved.<br>&nbsp;">
                <Columns>
                    <telerik:GridBoundColumn HeaderText="Bank Name" DataField="BankName">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Account Holder" DataField="AccountHolder">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Account Name" DataField="AccountName">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Branch Location" DataField="City">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                    </telerik:GridBoundColumn>
                    <telerik:GridTemplateColumn HeaderText="PayPlan" AllowFiltering="False">
                        <ItemTemplate>
                            <asp:Image ID="imgPaymentPlan" runat="server" />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridTemplateColumn HeaderText="BlueCredit" AllowFiltering="False">
                        <ItemTemplate>
                            <asp:Image ID="imgBlueCredit" runat="server" />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridButtonColumn CommandName="EditBankAccount" HeaderText="Edit" ButtonType="ImageButton"
                        ImageUrl="~/Content/Images/edit.PNG">
                    </telerik:GridButtonColumn>
                    <telerik:GridButtonColumn CommandName="RemoveBankAccount" HeaderText="Remove" ButtonType="ImageButton"
                        ImageUrl="~/Content/Images/close.ico">
                    </telerik:GridButtonColumn>
                    <%--<telerik:GridButtonColumn CommandName="RemoveBankAccount" HeaderText="Remove" ButtonType="ImageButton"
                            ImageUrl="~/Content/Images/delete.PNG" ConfirmText="Do you want to remove selected bank account ?\n This action is permanent and can't be undone.">
                        </telerik:GridButtonColumn>--%>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <asp:HiddenField ID="hdnBankPNRef" runat="server" />
        <asp:HiddenField ID="hdnSelectedBankAccountID" runat="server" />
        <asp:ImageButton ID="btnAddNewBank" ImageUrl="../Content/Images/btn_addnew.gif" CssClass="btn-add-new"
            runat="server" OnClick="btnAddNewBank_Click" Style="float: right; margin: 10px 10px 0px 0px;" />
        <br />
        <br />
        <h3>Credit Cards</h3>
        <telerik:RadGrid ID="gridLinkedCreditCards" runat="server" AllowSorting="True" AllowPaging="True"
            PageSize="10" OnNeedDataSource="gridLinkedCreditCards_NeedDataSource" OnItemCommand="gridLinkedCreditCards_OnItemCommand"
            OnItemDataBound="gridLinkedCreditCards_ItemDataBound">
            <MasterTableView AutoGenerateColumns="False" DataKeyNames="PaymentCardID,FlagActivePP, FlagActiveBC,ActivePPAbbr,ActiveBCAbbr,FlagExpired" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No linked credit cards have been saved.<br>&nbsp;">
                <Columns>
                    <telerik:GridBoundColumn HeaderText="Card Type" DataField="CardTypeAbbr">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Account Holder" DataField="AccountHolder">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Account Name" DataField="AccountName">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Expiration" DataField="Expiration" DataFormatString="{0:MM/yyyy}">
                    </telerik:GridBoundColumn>
                    <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                    </telerik:GridBoundColumn>
                    <telerik:GridTemplateColumn HeaderText="PayPlan" AllowFiltering="False">
                        <ItemTemplate>
                            <asp:Image ID="imgPaymentPlan" runat="server" />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridTemplateColumn HeaderText="BlueCredit" AllowFiltering="False">
                        <ItemTemplate>
                            <asp:Image ID="imgBlueCredit" runat="server" />
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>
                    <telerik:GridButtonColumn CommandName="EditCreditCard" UniqueName="EditCard" HeaderText="Edit" ButtonType="ImageButton"
                        ImageUrl="~/Content/Images/edit.PNG">
                    </telerik:GridButtonColumn>
                    <telerik:GridButtonColumn CommandName="RemoveCreditCard" HeaderText="Remove" ButtonType="ImageButton"
                        ImageUrl="~/Content/Images/close.ico">
                    </telerik:GridButtonColumn>
                </Columns>
            </MasterTableView>
        </telerik:RadGrid>
        <asp:HiddenField ID="hdnSelectedCreditCardID" runat="server" />
        <asp:ImageButton ID="btnAddNewCreditCard" ImageUrl="../Content/Images/btn_addnew.gif"
            CssClass="btn-add-new" runat="server" OnClick="btnAddNewCreditCard_Click" Style="float: right; margin: 10px 10px 0px 0px;" />
        <%--<asp:UpdatePanel ID="updPanelCreditCard" runat="server" OnUnload="updPanelCreditCard_Unload">
            <ContentTemplate>--%>
        <telerik:RadWindowManager ID="RadWindow" ShowContentDuringLoad="True" VisibleStatusbar="False"
            EnableEmbeddedScripts="True" VisibleTitlebar="True" ReloadOnShow="True" runat="Server"
            Width="700px" Height="500px" Modal="True" EnableEmbeddedBaseStylesheet="False"
            EnableEmbeddedSkins="False" RestrictionZoneID="divMainContent" Skin="CareBlue" Behaviors="Pin,Reload,Close,Move,Resize"
            Style="z-index: 3000">
            <Windows>
                <telerik:RadWindow runat="server" ID="popupManageAccounts" Width="750px" Height="565px"
                    NavigateUrl="~/report/pc_add_popup.aspx" DestroyOnClose="True">
                </telerik:RadWindow>
            </Windows>
        </telerik:RadWindowManager>
        <telerik:RadWindowManager ID="RadWindowManager" ShowContentDuringLoad="True" VisibleStatusbar="False"
            VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="700px" Height="500px"
            Modal="True" EnableEmbeddedBaseStylesheet="False" EnableEmbeddedSkins="False"
            RestrictionZoneID="divMainContent" Skin="CareBlueInf" Style="z-index: 3000">
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
                                <img src="../Content/Images/btn_yes_small.gif" alt="Yes" /></a>
                              &nbsp; &nbsp; 
                            <a href="#" onclick="$find('{0}').close(false);">
                                <img src="../Content/Images/btn_no_small.gif" alt="No" /></a>
                        </div>
                    </div>
                </div>
            </ConfirmTemplate>
            <AlertTemplate>
                <div class="rwDialogPopup radalert" style="margin: -7px 0 0 6px; padding: 10px;">
                    <h5>
                        <div class="rwDialogText" style="margin: 25px 0 0 45px !important; text-align: justify;">
                            {1} 
                        </div>
                    </h5>
                    <div id="divbuttons" style="margin-top: 20px; margin-left: 163px;">
                        <a href="javascript:;" onclick="$find('{0}').close(true);">
                            <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                    </div>
                </div>
            </AlertTemplate>
        </telerik:RadWindowManager>
        <asp:Button ID="btnRemoveBankAccountOrCreditCard" OnClick="btn_RemoveBankAccountOrCreditCard" Style="display: none;" runat="server" />
    </div>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">

        var glbIsFromUpdate = false;
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            unBlockUI();
        });

        function closeBankPopup() {
            doPostBack();
        }

        function closeRefresh() {
            location.href = location.href;
        }

        function confirmRemoveBankAccount() {
            if (confirm(" Are you sure you wish to cancel all changes ?")) {
                doPostBack();
            }
        }

        function confirmDeletionOfBankAccountOrCreditCard(isDelete) {
            if (isDelete) {
                $("#<%= btnRemoveBankAccountOrCreditCard.ClientID%>").click();
            }
        }

        function doPostBack() {
            __doPostBack('', '');
        }
    </script>
    </asp:Content>