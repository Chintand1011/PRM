<%@ Page Title="Log In" Language="C#" AutoEventWireup="true"
    CodeFile="login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Login</title>
    <link href="Content/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <script type="text/javascript" src="<%= ResolveUrl("Scripts/jquery.3.2.1.min.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("Content/vendor/popper/popper.min.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("Content/vendor/bootstrap/js/bootstrap.min.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("Scripts/pp.survey.notification.min.js")%>"></script>
    <script type="text/javascript" src="<%= ResolveUrl("Scripts/pp.survey.min.js")%>"></script>
    <style>
        body {
            padding-top: 54px;
        }

        @media (min-width: 992px) {
            body {
                padding-top: 56px;
            }
        }
    </style>
</head>
<body>

    <div class="container">
        <div>
            <div>
                <h3>Sign in - New</h3>
            </div>
            <div>
                <form role="form" runat="server">
                    <asp:ScriptManager runat="server">
                    </asp:ScriptManager>
                    <fieldset>
                        <div class="form-group">
                            <asp:TextBox ID="txtSurveyCode" CssClass="form-control" placeholder="survey code" runat="server"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtPassword" TextMode="Password" CssClass="form-control" placeholder="password" runat="server"></asp:TextBox>
                        </div>

                        <div id="notification"></div>

                        <!-- Change this to a button or input when using this as a form -->
                        <asp:Button ID="btnProcessLogin" CssClass="btn btn-sm btn-success" OnClick="btnProcessLogin_OnClick" Text="Login" runat="server" />
                    </fieldset>
                </form>
            </div>
        </div>
    </div>
    <!-- /container -->
</body>
</html>
