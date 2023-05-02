<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="welcome.aspx.cs"
    Inherits="welcome" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel ID="MyInfoUpdatePancel" runat="server">
        <ContentTemplate>
            <div class="pgColumn1">
                <h2>Provider Information</h2>
                <!--<img src="content/images/providers/<%=LogoName%>" width="<%=LogoWidth%>px" height="<%=LogoHeight %>px"
                    style="margin: 10px 0px 0px 10px;" />-->
                <h5><b>Your Doctor:</b></h5>
                <h4 style="margin-top:0px; margin-bottom:5px;"><%=ProviderName%></h4>
                <h5> 
                    <%=PracticeName%>
                  
                    <br />
                    <%=Addr1%><%=Addr2%>
                    <br />
                    <%=City%>, <%=StateAbbr%> <%=Zip%>
                    <br />
                    <%=Phone%><%=Fax%>
                    <br />
                    <br />
                    <b>Have Questions?</b>
                    <br />
                    <%=InvInquiryNote%>
                    <br />
                </h5>
            </div>
            <div class="pgColumn2">
                <h1>Welcome</h1>
                <br />
                <asp:Literal ID="litBounceEmail" runat="server"></asp:Literal>

                <div class="form-row">
                    <div class="editor-label">
                        <asp:Label runat="server" Text="Last Web Login:"></asp:Label>
                    </div>
                    <div class="editor-field">
                        <asp:Label ID="lblLastWebLogin" runat="server"></asp:Label>
                    </div>
                </div>
                <div class="form-row">
                    <div class="editor-label">
                        <asp:Label runat="server" Text="Last Mobile Login:"></asp:Label>
                    </div>
                    <div class="editor-field">
                        <asp:Label ID="lblLastMobileLogin" runat="server"></asp:Label>
                    </div>
                </div>

            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
