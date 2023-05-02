<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="syseligmgr.aspx.cs"
    Inherits="syseligmgr" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelConfiguartion" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Manage Eligibility... Need to update this title</h1>
            </div>
            <div class="bodyMain">
                <h2>Description text will be there...</h2>

                <div style="margin-top: 20px;">
                    <b id="bEmptyStack" runat="server">Flag for empty records is ENABLED</b>
                    <asp:ImageButton ID="btnFlagEmptyStack" ImageUrl="../Content/Images/btn_disable.gif"
                        OnClick="btnFlagEmptyStack_OnClick" runat="server" />
                    <br />
                    <br />
                    <b id="bManageStack" runat="server">Flag Stack is ENABLED</b>
                    <asp:ImageButton ID="btnManageStacksText" ImageUrl="../Content/Images/btn_disable.gif" runat="server" OnClick="btnManageStacksText_Click" />
                    <br />
                    <br />
                </div>
                <div>
                    <telerik:radgrid id="grdEligibilityStacks" runat="server" allowsorting="True" allowpaging="True"
                        pagesize="20" onneeddatasource="grdEligibilityStacks_NeedDataSource" onitemdatabound="grdEligibilityStacks_OnItemDataBound" width="1200px"
                        onitemcommand="grdEligibilityStacks_OnItemCommand" onitemcreated="grdEligibilityStacks_ItemCreated" allowautomaticupdates="False" allowautomaticinserts="False" allowmultirowedit="False">
                        <ClientSettings>
                          <Resizing AllowColumnResize="True" AllowRowResize="false" ResizeGridOnColumnResize="false" EnableRealTimeResize="false" AllowResizeToFit="false"/>
                        </ClientSettings>
                                <MasterTableView AutoGenerateColumns="False" EditMode="InPlace" DataKeyNames="XMLID, RuleID, Value, Value1Destination, Rule1MatchType, Rule2MatchType, Rule3MatchType, Rule4MatchType, Rule5MatchType">
                                    <Columns>
                                        <telerik:GridTemplateColumn HeaderText="XML" DataField="XMLID" SortExpression="XMLID" >
                                                                <ItemTemplate>
                                                                    <%# string.IsNullOrEmpty(Eval("XMLID").ToString()) ? "-" : Eval("XMLID").ToString() %>
                                                                </ItemTemplate>
                                                               
                                        </telerik:GridTemplateColumn>
                                        
                                        <telerik:GridTemplateColumn HeaderText="Loop" DataField="LoopID" SortExpression="LoopID" >
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "LoopID") %>
                                                                </ItemTemplate>
                                                                </telerik:GridTemplateColumn>

                                        
                                        <telerik:GridTemplateColumn HeaderText="Stack" UniqueName="Stack" DataField="Stack" SortExpression="Stack" HeaderStyle-Width="200px" >
                                                                <ItemTemplate>
                                                                    <%# Server.HtmlEncode((string)DataBinder.Eval(Container.DataItem, "Stack")) %>
                                                                </ItemTemplate>
                                                                </telerik:GridTemplateColumn>
                                        
                                              <telerik:GridTemplateColumn HeaderText="Value" DataField="Value" SortExpression="Value" HeaderStyle-Width="70px" >
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "Value") %>
                                                                </ItemTemplate>
                                                                </telerik:GridTemplateColumn>
                                        
                                        
                                         <telerik:GridTemplateColumn HeaderText="Rule" DataField="RuleID" SortExpression="RuleID">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "RuleID") %>
                                                                </ItemTemplate>
                                                                </telerik:GridTemplateColumn>
                                        
                                        
                                        <telerik:GridTemplateColumn HeaderText="Restrict" DataField="PayerIDCode" SortExpression="PayerIDCode" HeaderStyle-Width="50px">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chk" Visible='<%# Eval("XMLID").ToString() != "" %>' Enabled="False" Checked='<%# Int32.Parse(Eval("PayerIDCode").ToString() == "" ? "0" : Eval("PayerIDCode").ToString()) > 0 %>' runat="server"/>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:CheckBox ID="chkPayerIDCode" Checked='<%# Int32.Parse(Eval("PayerIDCode").ToString() == "" ? "0" : Eval("PayerIDCode").ToString()) > 0 %>' runat="server"/>
                                                                    </EditItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        
                                        <telerik:GridTemplateColumn UniqueName="Destination" HeaderText="Destination" DataField="Value1Destination" SortExpression="Value1Destination"  HeaderStyle-Width="200px">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "Value1Destination") %>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <telerik:RadComboBox ID="cmbDestinations" runat="server" Width="190px" EmptyMessage="Choose Destination"
                                                                                            AllowCustomText="False" MarkFirstMatch="True" DataTextField="name" DataValueField="name"
                                                                                            MaxHeight="200">
                                                                                        </telerik:RadComboBox>
                                                                   
                                                                </EditItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        
                                        <telerik:GridTemplateColumn HeaderText="R1ID" DataField="ET1XMLID" SortExpression="ET1XMLID"  HeaderStyle-Width="80px">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "ET1XMLID") %>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:ImageButton ID="btnRule1XMLID" OnClick="SaveRuleOfSelectedRow" ImageUrl="~/Content/Images/icon_circle_green.png" runat="server"/>
                                                                    <telerik:RadTextBox ID="txtET1XMLID"  runat="server" Width="50px" Text='<%# Bind("ET1XMLID")%>'>
                                                                    </telerik:RadTextBox>
                                                                </EditItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        
                                        
                                        <telerik:GridTemplateColumn HeaderText="R2ID" DataField="ET2XMLID" SortExpression="ET2XMLID"  HeaderStyle-Width="80px">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "ET2XMLID") %>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:ImageButton ID="btnRule2XMLID" Visible='<%# Eval("Rule1MatchType").ToString() == "0" %>' OnClick="SaveRuleOfSelectedRow" ImageUrl="~/Content/Images/icon_circle_green.png" runat="server"/>
                                                                    <telerik:RadTextBox ID="txtET2XMLID"  runat="server" Width="50px" Text='<%# Bind("ET2XMLID")%>'>
                                                                    </telerik:RadTextBox>
                                                                </EditItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        
                                        
                                        <telerik:GridTemplateColumn HeaderText="R3ID" DataField="ET3XMLID" SortExpression="ET3XMLID"  HeaderStyle-Width="80px">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "ET3XMLID") %>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:ImageButton ID="btnRule3XMLID" style="display: none" OnClick="SaveRuleOfSelectedRow" ImageUrl="~/Content/Images/icon_circle_green.png" runat="server"/>
                                                                    <telerik:RadTextBox ID="txtET3XMLID"  runat="server" Width="50px" Text='<%# Bind("ET3XMLID")%>'>
                                                                    </telerik:RadTextBox>
                                                                </EditItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        
                                        
                                        <telerik:GridTemplateColumn HeaderText="R4ID" DataField="ET4XMLID" SortExpression="ET4XMLID"  HeaderStyle-Width="80px">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "ET4XMLID") %>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:ImageButton ID="btnRule4XMLID" style="display: none" OnClick="SaveRuleOfSelectedRow" ImageUrl="~/Content/Images/icon_circle_green.png" runat="server"/>
                                                                    <telerik:RadTextBox ID="txtET4XMLID"  runat="server" Width="50px" Text='<%# Bind("ET4XMLID")%>'>
                                                                    </telerik:RadTextBox>
                                                                </EditItemTemplate>
                                        </telerik:GridTemplateColumn>
                                        
                                        
                                        <telerik:GridTemplateColumn HeaderText="R5ID" DataField="ET5XMLID" SortExpression="ET5XMLID"  HeaderStyle-Width="100px">
                                                                <ItemTemplate>
                                                                    <%# DataBinder.Eval(Container.DataItem, "ET5XMLID") %>
                                                                </ItemTemplate>
                                                                <EditItemTemplate>
                                                                    <asp:ImageButton ID="btnRule5XMLID" style="display: none" OnClick="SaveRuleOfSelectedRow" ImageUrl="~/Content/Images/icon_circle_green.png" runat="server"/>
                                                                    <telerik:RadTextBox ID="txtET5XMLID"  runat="server" Width="50px" Text='<%# Bind("ET5XMLID")%>'>
                                                                    </telerik:RadTextBox>
                                                                </EditItemTemplate>
                                        </telerik:GridTemplateColumn>
                                      
                                        
                                        <telerik:GridEditCommandColumn HeaderStyle-Width="53px" UniqueName="EditCptCode" ButtonType="ImageButton" UpdateText="Update" CancelText="Cancel" EditText="Edit" >
                                            <ItemStyle CssClass="EligibilityImageButton"></ItemStyle>
                                        </telerik:GridEditCommandColumn>

                                        <telerik:GridButtonColumn Text="Delete" UniqueName="DeleteCptCode" CommandName="Delete" ButtonType="ImageButton" ItemStyle-Width="10px"/>
                                        </Columns>
                                </MasterTableView>
                                 </telerik:radgrid>
                </div>

            </div>
            <telerik:radwindow runat="server" id="popupConflicts" visibletitlebar="True" visiblestatusbar="False"
                behaviors="Close, Resize" RestrictionZoneID="divMainContent" enableembeddedskins="False" title="Eligibility Rules Validation"
                skin="CareBlueInf" borderstyle="None" borderwidth="0" modal="true" width="750"
                height="600">
                    <ContentTemplate>
                        <div>
                            <br />
                            <div>
                                <p align="left" id="pMessage" runat="server"></p>

                                <asp:ImageButton id="btnSaveEligibilityStack" style="float: right; margin-top: -27px;" runat="server" ImageUrl="~/Content/Images/btn_save.gif"
                                      OnClick="btnSaveEligibilityStack_OnClick"/>
                                
                                <asp:ImageButton id="btnCancel" style="float: right; margin-top: -5px;" runat="server" ImageUrl="../Content/Images/btn_cancel.gif"
                                       OnClientClick="closePopup(); return false;" />
                                
                            </div>
                            <p>
                                <br />
                                   <div>
                                    <telerik:RadGrid ID="grdConflicts" runat="server" AllowSorting="True" AllowPaging="True"
                                        OnNeedDataSource="grdConflicts_NeedDataSource" PageSize="20">
                                        <MasterTableView AutoGenerateColumns="False">
                                            <Columns>
                                                <telerik:GridBoundColumn HeaderText="Flag Error" DataField="FlagError">
                                                </telerik:GridBoundColumn>
                                                
                                                     <telerik:GridTemplateColumn HeaderText="Error Message" DataField="ErrorMsg">
                                                                <ItemTemplate>
                                                                    <%# Server.HtmlEncode((string)DataBinder.Eval(Container.DataItem, "ErrorMsg")) %>
                                                                </ItemTemplate>
                                                                </telerik:GridTemplateColumn>
                                                <telerik:GridBoundColumn HeaderText="Rule ID" DataField="RuleID">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Payer ID Code" DataField="PayerIDCode">
                                                </telerik:GridBoundColumn>
                                                
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>
                                </div>
                            </p>
                        </div>
                    </ContentTemplate>
                </telerik:radwindow>
            <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px"
                modal="True" enableembeddedbasestylesheet="False" enableembeddedskins="False"
                RestrictionZoneID="divMainContent" skin="CareBlueInf" style="z-index: 3000">
                  <ConfirmTemplate>
                            <div class="rwDialogPopup radconfirm">
                                <h5>
                                    <div class="rwDialogText">
                                        {1}
                                    </div>
                                </h5>
                                <div>
                                    <div style="margin-top: 15px; margin-left: 30px;">                                        
                                        <a href="Javascript:;" onclick="$find('{0}').close(false);">
                                                <img src="../Content/Images/btn_cancel.gif" alt="Yes" /></a>
                                         &nbsp; &nbsp; 
                                        <a href="javascript:;" onclick="$find('{0}').close(true);">
                                            <img src="../Content/Images/btn_ok.gif" alt="No" /></a>
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
            <asp:Button ID="btnDeleteEligibilityStack" OnClick="btnDeleteEligibilityStack_OnClick" Style="display: none" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript">
        function closePopup() {
            $find("<%=popupConflicts.ClientID %>").close();
        }

        function deleteEligibilityStack(isDelete) {
            if (isDelete) {
                $("#<%=btnDeleteEligibilityStack.ClientID %>").click();
            }
        }

    </script>
</asp:Content>

