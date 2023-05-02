<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="survey.aspx.cs" Inherits="survey" %>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        input[type='radio'] {
            transform: scale(1.3);
        }
    </style>
    <script src="Content/vendor/icheck/icheck.min.js"></script>
    <link href="Content/vendor/icheck/skins/flat/blue.css" rel="stylesheet" />

    <script>
        $(document).ready(function () {
            $('input').iCheck({
                checkboxClass: 'icheckbox_flat-blue',
                radioClass: 'iradio_flat-blue',
            });
        });
    </script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <h3 class="mt-5" runat="server" id="questionHeading">Survey Questions</h3>
    <asp:Literal ID="ltQuestionTitle" runat="server"></asp:Literal>
    <div class="col-md-10 mt-5">
        <h5 runat="server" id="headingQuestion"></h5>
        <asp:Panel ID="pnlRadioButton" runat="server">
            <div>
                <asp:RadioButtonList ID="rdQuestionAnswer" runat="server" />
            </div>
            <div>
                <asp:TextBox TextMode="SingleLine" ID="txtRadioAnswer" runat="server" Visible="False"></asp:TextBox>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlTextbox" runat="server">
            <asp:TextBox ID="txtQuestionAnswer" runat="server"></asp:TextBox>   
        </asp:Panel>
        <asp:Panel ID="pnlDropdown" runat="server">
            <asp:DropDownList ID="drpList" runat="server"/>
        </asp:Panel>
        <asp:Panel ID="pnlCheckbox" runat="server">
            <asp:CheckBoxList ID="chklist" runat="server">
            </asp:CheckBoxList>
            <div>
                <asp:TextBox TextMode="SingleLine" ID="TextBox1" runat="server" Visible="False"></asp:TextBox>
            </div>
        </asp:Panel>
        <div id="notification" class="mt-2"></div>
        <div class="mt-5">
            <asp:Button ID="btnPrev" IsNext="0" CssClass="btn btn-primary float-left" Text="Prev Question" runat="server" OnClick="SaveAnswer" />
            <asp:Button ID="btnNext" IsNext="1" CssClass="btn btn-primary float-right" Text="Next Question" runat="server" OnClick="SaveAnswer" />
        </div>
    </div>
</asp:Content>
