<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="encryptdecrypt.aspx.cs"
    Inherits="encryptdecrypt" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        .result {
            margin-top: 20px;
            width: 30%;
            color: green;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Encryption & Decryption</h1>
            </div>
            <div class="bodyMain">
                <h2>Select operation you want to perform.</h2>
                <div style="float: right; width: 100%">
                    <div align="center">
                        <h1>Encryption & Decryption Utility</h1>
                        <asp:TextBox ID="txtInput" TextMode="MultiLine" Rows="2" Columns="40" runat="server"></asp:TextBox>
                        <br />
                        <br />
                        <asp:RadioButton ID="rdEncrypt" GroupName="Security" runat="server" />
                        Encrypt
            <asp:RadioButton GroupName="Security" ID="rdDecrypt" runat="server" />
                        Decrypt
            <br />
                        <%--<asp:Label ID="lblResult" runat="server">Result: </asp:Label>--%>
                        <br />
                        <asp:ImageButton ID="btnSubmit" ImageUrl="../Content/Images/btn_submit.gif" OnClick="btnSubmit_OnClick" runat="server" />
                        <div class="result">
                            <span id="spanResult" runat="server"></span>
                        </div>
                    </div>
                </div>

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <script type="text/javascript" language="javascript">
        function showMessage(message) {
            alert(message);
        }
    </script>
</asp:Content>

