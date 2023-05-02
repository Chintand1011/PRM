<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="bankinfo.aspx.cs"
    Inherits="patient_bankinfo" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div class="pgColumn1">
        <h2>Explanation of Page</h2>
        <h4>Your saved credit cards and bank accounts may be managed here.</h4>
        <h5>Add a checking account or credit card before making a web portal payment. Payment accounts are also required before settting up a payment plan. For your convenience, you may also see your account listed from payments made in your provider's office.
            <br />
            <br />
            <b>Did you know?</b><br />
            Only payments you authorize will be processed. Outstanding balances will never be paid automatically with a saved payment account.</h5>
    </div>
    <div class="pgColumn2">
        <h1>Saved Forms of Payment
        </h1>
        <div>
            <h3>Linked Checking Accounts
            </h3>
            <telerik:radgrid id="grdLinkedBankAccounts" runat="server" allowsorting="True" allowpaging="True"
                pagesize="10" onneeddatasource="grdLinkedBankAccounts_NeedDataSource" onitemcommand="grdLinkedBankAccounts_OnItemCommand"
                onitemdatabound="grdLinkedBankAccounts_ItemDataBound">
                <MasterTableView AutoGenerateColumns="False" DataKeyNames="PaymentCardID,FlagActivePP, FlagActiveBC, PNRef,ActivePPAbbr,ActiveBCAbbr" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; You have not yet registered a checking account to make payments. Click on 'Add New' to register a payment method.<br>&nbsp;">
                    <Columns>
                        <telerik:GridBoundColumn HeaderText="Account Holder" DataField="AccountHolder">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Bank Name" DataField="BankName">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Branch Location" DataField="City">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Account Name" DataField="AccountName">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn HeaderText="PayPlan" AllowFiltering="False" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Image ID="imgPaymentPlan" runat="server" Style="margin-left:-20px;"/>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderText="BlueCredit" AllowFiltering="False" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Image ID="imgBlueCredit" runat="server" Style="margin-left:-20px;"/>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridButtonColumn CommandName="EditBankAccount" HeaderText="Edit" ButtonType="ImageButton"
                            ImageUrl="~/Content/Images/icon_edit.png">
                        </telerik:GridButtonColumn>
                        <telerik:GridButtonColumn CommandName="RemoveBankAccount" HeaderText="Remove" ButtonType="ImageButton"
                            ImageUrl="~/Content/Images/icon_delete.png"  ItemStyle-HorizontalAlign="Center" >
                        </telerik:GridButtonColumn>
                        <%--<telerik:GridButtonColumn CommandName="RemoveBankAccount" HeaderText="Remove" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/delete.PNG" ConfirmText="Do you want to remove selected bank account ?\n This action is permanent and can't be undone.">
                                </telerik:GridButtonColumn>--%>
                    </Columns>
                </MasterTableView>
            </telerik:radgrid>
            <asp:HiddenField ID="hdnBankPNRef" runat="server" />
            <asp:HiddenField ID="hdnSelectedBankAccountID" runat="server" />
            <asp:HiddenField ID="hdnIsLongMessage" runat="server" />
            <asp:ImageButton ID="btnAddNewBank" ImageUrl="Content/Images/btn_addnew_small.gif" CssClass="btn-add-new"
                runat="server" OnClick="btnAddNewBank_Click" />
        </div>
        &nbsp;
        <div>
            <h3>Linked Credit Cards
            </h3>
            <telerik:radgrid id="gridLinkedCreditCards" runat="server" allowsorting="True" allowpaging="True"
                pagesize="10" onneeddatasource="gridLinkedCreditCards_NeedDataSource" onitemcommand="gridLinkedCreditCards_OnItemCommand"
                onitemdatabound="gridLinkedCreditCards_ItemDataBound">
                <MasterTableView AutoGenerateColumns="False" DataKeyNames="PaymentCardID,FlagActivePP, FlagActiveBC,ActivePPAbbr,ActiveBCAbbr" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; You have not yet registered a credit card to make payments. Click on 'Add New' to register a payment method.<br>&nbsp;">
                    <Columns>
                        <telerik:GridBoundColumn HeaderText="Account Holder" DataField="AccountHolder">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Card Type" DataField="CardTypeAbbr">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Account Name" DataField="AccountName">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Expiration" DataField="Expiration">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn HeaderText="Status" DataField="StatusTypeAbbr">
                        </telerik:GridBoundColumn>
                        <telerik:GridTemplateColumn HeaderText="PayPlan" AllowFiltering="False" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Image ID="imgPaymentPlan" runat="server" Style="margin-left:-15px;"/>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridTemplateColumn HeaderText="BlueCredit" AllowFiltering="False" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:Image ID="imgBlueCredit" runat="server" Style="margin-left:-15px;"/>
                            </ItemTemplate>
                        </telerik:GridTemplateColumn>
                        <telerik:GridButtonColumn CommandName="EditCreditCard" HeaderText="Edit" ButtonType="ImageButton"
                            ImageUrl="~/Content/Images/icon_edit.png">
                        </telerik:GridButtonColumn>
                        <telerik:GridButtonColumn CommandName="RemoveCreditCard" HeaderText="Remove" ButtonType="ImageButton"
                            ImageUrl="~/Content/Images/icon_delete.png">
                        </telerik:GridButtonColumn>
                    </Columns>
                </MasterTableView>
            </telerik:radgrid>
            <asp:HiddenField ID="hdnSelectedCreditCardID" runat="server" />
            <asp:ImageButton ID="btnAddNewCreditCard" ImageUrl="Content/Images/btn_addnew_small.gif"
                CssClass="btn-add-new" runat="server" OnClick="btnAddNewCreditCard_Click" />
        </div>
    </div>

    <telerik:radwindowmanager id="windowManager" showcontentduringload="True" visiblestatusbar="False"
        visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
        modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
        skin="CareBlue" behaviors="Pin,Reload,Close,Move,Resize" style="z-index: 3000">
        <Windows>
            <telerik:RadWindow runat="server" ID="popupManageAccounts" Width="750px" Height="550px"
                NavigateUrl="~/report/pc_add_popup.aspx" DestroyOnClose="True">
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
                        <a href="Javascript:;"
                                onclick="$find('{0}').close(true);">
                                <img src="Content/Images/btn_yes_small.gif" alt="Yes" /></a>  &nbsp; &nbsp; 
                        
                        <a href="javascript:;" onclick="$find('{0}').close(false);">
                            <img src="Content/Images/btn_no_small.gif" alt="No" /></a>
                    </div>
                </div>
            </div>
        </ConfirmTemplate>
        <AlertTemplate>
            <div class="rwDialogPopup radalert" style="margin: -7px 0 0 6px;">
                <% var style = hdnIsLongMessage.Value == "1" ? "margin-left: 200px;" : "margin-left: 100px;";
                   hdnIsLongMessage.Value = "0"; %>
                <h5>
                    <div class="rwDialogText" style="margin: 39px 10px 0 17px;">
                        {1} 
                    </div>
                </h5>
                <div id="divbuttons" style="margin-top: 20px; <%=style%>;">
                    <a href="javascript:;" onclick="$find('{0}').close(true);">
                        <img src="Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                </div>
            </div>
        </AlertTemplate>
    </telerik:radwindowmanager>
    <asp:Button ID="btnRemoveBankAccount" OnClick="btnRemoveBankAccount_Click" Style="display: none;" runat="server" />
    <asp:Button ID="btnRemoveCreditCard" OnClick="btnRemoveCreditCard_Click" Style="display: none;" runat="server" />
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">
        function closeBankPopup() {
            doPostBack();
        }

        function closeRefresh() {
            location.href = location.href;
        }

        function refreshPage() {
            closeRefresh();
        }


        function closeCreditCardPopup() {
            doPostBack();
        }

        function validateBankAccountRemoveRequest(isRemove) {
            if (isRemove) {
                $("#<%=btnRemoveBankAccount.ClientID%>").click();
            }
        }

        function validateCreditCardRemoveRequest(isRemove) {
            if (isRemove) {
                $("#<%=btnRemoveCreditCard.ClientID%>").click();
            }
        }

        function doPostBack() {
            __doPostBack('', '');
        }
    </script>
</asp:Content>
