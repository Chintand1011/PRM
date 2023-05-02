<%@ Page Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true" CodeFile="bluecredit.aspx.cs"
    Inherits="bluecredit" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="updPanelConfiguartion" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Update Available Patient Credit Plans</h1>
            </div>
            <div class="bodyMain">
                <h2>Modify practice owned BlueCredit plans for your patients. Please note that although lender funded BlueCredit plans are displayed, they may only be managed by CareBlue.</h2>
                <table width="100%">
                    <tr>
                        <td colspan="2"></td>
                    </tr>
                    <tr>
                        <td>
                            <div style="overflow: auto">
                                <telerik:RadGrid ID="grdBlueCredit" runat="server" AllowSorting="True" AllowPaging="True"
                                    OnItemDataBound="grdBlueCredit_ItemDataBound" OnNeedDataSource="grdBlueCredit_NeedDataSource"
                                    PageSize="25">
                                    <MasterTableView AutoGenerateColumns="False" DataKeyNames="FlagActive,CreditTypeID">
                                        <Columns>
                                            <telerik:GridBoundColumn HeaderText="ID" DataField="CreditTypeID">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Plan" DataField="PlanName">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Max Term" DataField="TermMaxAbbr">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Term APR" DataField="RateAPRAbbr">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Default" DataField="RateDefaultAbbr">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Default Fee" DataField="DefaultFee$">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Min Payment" DataField="MinPayDollar$">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Qualified Balance" DataField="QualBalRange$">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridBoundColumn HeaderText="Status" DataField="StatusAbbr">
                                            </telerik:GridBoundColumn>
                                            <telerik:GridTemplateColumn HeaderText="">
                                                <HeaderStyle Width="90px" />
                                                <ItemTemplate>
                                                    <telerik:RadButton ID="btnFlagActive" runat="server" ButtonType="ToggleButton" Style="padding-left: 25px"
                                                        ToggleType="CheckBox" AutoPostBack="True" OnClick="btnFlagActive_OnClick" Skin="Metro">
                                                        <ToggleStates>
                                                            <telerik:RadButtonToggleState PrimaryIconCssClass="rbAdd" Text="Add"></telerik:RadButtonToggleState>
                                                            <telerik:RadButtonToggleState PrimaryIconCssClass="rbRemove" Text="Remove"></telerik:RadButtonToggleState>
                                                        </ToggleStates>
                                                    </telerik:RadButton>
                                                </ItemTemplate>
                                            </telerik:GridTemplateColumn>
                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Statements"
                                ShowSummary="False" ShowMessageBox="True" DisplayMode="BulletList" EnableClientScript="True"
                                CssClass="failureNotification" HeaderText="Please correct the following inputs before re-submitting your request:" />
                            <div class="success-message" align="right">
                                <asp:Literal ID="litFeeScheduleMessage" runat="server"></asp:Literal>
                            </div>
                            <asp:HiddenField ID="hdnShowMessage" runat="server" />
                        </td>
                    </tr>
                </table>
                <telerik:RadWindowManager ID="RadWindow" ShowContentDuringLoad="True" VisibleStatusbar="False"
                    VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="700px" Height="500px"
                    Modal="True" EnableEmbeddedBaseStylesheet="False" EnableEmbeddedSkins="False"
                    RestrictionZoneID="divMainContent" Skin="CareBlueInf" Style="z-index: 3000">
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
                </telerik:RadWindowManager>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
