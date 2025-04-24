<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="EdupathWebForms.Pages.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edupath - Login</title>
    <link href="Assets/styles.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <h2>Edupath Learning Platform</h2>
            <div class="form-group">
                <asp:Label ID="lblUsername" runat="server" Text="Username:"></asp:Label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                    ControlToValidate="txtUsername" ErrorMessage="Username is required" 
                    ForeColor="Red"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <asp:Label ID="lblPassword" runat="server" Text="Password:"></asp:Label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                    ControlToValidate="txtPassword" ErrorMessage="Password is required" 
                    ForeColor="Red"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" CssClass="btn-primary" />
            </div>
            <div class="form-group">
                <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
            </div>
            <div class="form-links">
                <a href="Register.aspx">Register new account</a> | 
                <a href="ForgotPassword.aspx">Forgot password?</a>
            </div>
        </div>
    </form>
</body>
</html>