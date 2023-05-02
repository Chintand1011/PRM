<%@ Page Language="C#" AutoEventWireup="true" CodeFile="pdfviewer_popup.aspx.cs"
    Inherits="pdfviewer_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/Print.css" rel="stylesheet" type="text/css" />
    <title>CareBlue Document Retrieval</title>
</head>
<body>
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
    </telerik:RadScriptManager>
    <div>
        <h2 id="h1ErrorMessage" runat="server">
            Retrieving file, please wait...
        </h2>
        <asp:Image ID="imgFile" Visible="False" runat="server" />
    </div>
    <asp:HiddenField ID="hdnAllowButtonClick" runat="server" />
    <asp:Button ID="btnGetResponse" OnClick="btnGetResponse_OnClick" Style="display: none;"
        runat="server" />
    </form>
    <telerik:RadWindowManager ID="RadWindowManager1" ShowContentDuringLoad="True" VisibleStatusbar="False"
        VisibleTitlebar="True" ReloadOnShow="True" runat="Server" Width="700px" Height="500px"
        Modal="True" EnableEmbeddedBaseStylesheet="False" EnableEmbeddedSkins="False"
        RestrictionZoneID="divMainContent" Skin="CareBlueInf" Behaviors="Close" Style="z-index: 3000">
        <Windows>
            <telerik:RadWindow runat="server" ID="popupInfo" NavigateUrl="~/report/info_popup.aspx"
                DestroyOnClose="True">
            </telerik:RadWindow>
        </Windows>
    </telerik:RadWindowManager>
    <script type="text/javascript">
        $(function () {
            if ($("#<%=hdnAllowButtonClick.ClientID %>").val() == "1") {
                $("#<%=btnGetResponse.ClientID %>").click();
                $("#<%=hdnAllowButtonClick.ClientID %>").val("");
            }


        });
    </script>
</body>
</html>
