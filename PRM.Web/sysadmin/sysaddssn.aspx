<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="sysaddssn.aspx.cs"
    Inherits="sysaddssn" %>


<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>SSN Encryption Utility</h1>
            </div>
            <div class="bodyMain">
                <h2>Please enter patient and valid ssn you want to encrypt</h2>
                <div style="float: right; width: 100%">
                    <div align="center">

                        <asp:TextBox ID="txtInputs" TextMode="MultiLine" placeholder="Format should be PatientId, PatientSsn, GuardianSsn separated by new line" Rows="5" Columns="40" runat="server"></asp:TextBox>
                        <br />
                        <br />
                        <asp:ImageButton ID="btnSubmit" ImageUrl="../Content/Images/btn_submit.gif" OnClick="btnSubmit_OnClick" runat="server" />
                    </div>
                </div>

            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" language="javascript">
        function showMessage(message) {
            alert(message);
        }
    </script>
</asp:Content>
