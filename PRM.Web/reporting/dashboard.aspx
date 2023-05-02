<%@ Page Title="" Language="C#" MasterPageFile="~/User.master" AutoEventWireup="true"
    CodeFile="dashboard.aspx.cs" Inherits="dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
    <script type="text/javascript">

        function onClientSeriesClicked(sender, args) {
            $("#<%=hdnCategory.ClientID%>").val(args.get_category());
            $("#<%=btnLoadSeries.ClientID%>").click();
        }

        function onClientMultipleSeriesClicked(sender, args) {
            $("#<%=hdnMultipleSeriesCategory.ClientID%>").val(args.get_category());
            $("#<%=btnLoadMultipleSeries.ClientID%>").click();
        }
        


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <telerik:radajaxmanager id="RadAjaxManager1" runat="server">
            <AjaxSettings>
                <telerik:AjaxSetting AjaxControlID="btnLoadSeries">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="radGraph"></telerik:AjaxUpdatedControl>
                        <telerik:AjaxUpdatedControl ControlID="hdnCategory"></telerik:AjaxUpdatedControl>
                        </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="btnRefreshEligibiltyGraph">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="radGraph"></telerik:AjaxUpdatedControl>
                        </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="btnLoadMultipleSeries">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="radGraphMultipleSeries"></telerik:AjaxUpdatedControl>
                    </UpdatedControls>
                </telerik:AjaxSetting>
                <telerik:AjaxSetting AjaxControlID="btnRefreshEligibiltyMultipleGraph">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="radGraphMultipleSeries"></telerik:AjaxUpdatedControl>
                        </UpdatedControls>
                </telerik:AjaxSetting>
            </AjaxSettings>
        </telerik:radajaxmanager>


    <telerik:radhtmlchart id="radGraph" runat="server" onclientseriesclicked="onClientSeriesClicked">
            </telerik:radhtmlchart>
    <asp:ImageButton ID="btnRefreshEligibiltyGraph" ImageUrl="../Content/Images/btn_refresh.gif" OnClick="btnRefreshEligibiltyGraph_OnClick" runat="server" />
    <asp:HiddenField ID="hdnCategory" runat="server" />
    <asp:Button ID="btnLoadSeries" OnClick="btnLoadSeries_OnClick" Style="display: none;" runat="server" />

    <h2>Stacked Series</h2>
    <telerik:radhtmlchart id="radGraphMultipleSeries" runat="server" onclientseriesclicked="onClientMultipleSeriesClicked">
            </telerik:radhtmlchart>
    <asp:ImageButton ID="btnRefreshEligibiltyMultipleGraph" ImageUrl="../Content/Images/btn_refresh.gif" OnClick="btnRefreshEligibiltyMultipleGraph_OnClick" runat="server" />
    <asp:HiddenField ID="hdnMultipleSeriesCategory" runat="server" />
    <asp:Button ID="btnLoadMultipleSeries" OnClick="btnLoadMultipleSeries_OnClick" Style="display: none;" runat="server" />

</asp:Content>
