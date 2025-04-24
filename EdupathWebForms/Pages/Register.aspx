<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="EdupathWebForms.Pages.Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edupath - Registration</title>
    <style type="text/css">
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .register-container {
            max-width: 500px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 15px;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            display: block;
            width: 100%;
        }
        .btn-primary:hover {
            background-color: #45a049;
        }
        .validation-error {
            color: red;
            font-size: 12px;
            display: block;
            margin-top: 5px;
        }
        .success-message {
            color: green;
            text-align: center;
            margin-top: 10px;
        }
        .form-links {
            text-align: center;
            margin-top: 20px;
        }
        .form-links a {
            color: #4CAF50;
            text-decoration: none;
        }
        .form-links a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-container">
            <h2>Create Your Edupath Account</h2>

            
            <div class="form-group">
                <asp:Label ID="lblUsername" runat="server" Text="Username:"></asp:Label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                    ControlToValidate="txtUsername" ErrorMessage="Username is required" 
                    CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
            
            <div class="form-group">
                <asp:Label ID="lblEmail" runat="server" Text="Email:"></asp:Label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                    ControlToValidate="txtEmail" ErrorMessage="Email is required" 
                    CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                    ControlToValidate="txtEmail" ErrorMessage="Please enter a valid email address" 
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                    CssClass="validation-error" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>
            
            <div class="form-group">
                <asp:Label ID="lblPassword" runat="server" Text="Password:"></asp:Label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                    ControlToValidate="txtPassword" ErrorMessage="Password is required" 
                    CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revPassword" runat="server" 
                    ControlToValidate="txtPassword" ErrorMessage="Password must be at least 6 characters long" 
                    ValidationExpression=".{6,}" CssClass="validation-error" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>
            
            <div class="form-group">
                <asp:Label ID="lblConfirmPassword" runat="server" Text="Confirm Password:"></asp:Label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                    ControlToValidate="txtConfirmPassword" ErrorMessage="Please confirm your password" 
                    CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:CompareValidator ID="cvPassword" runat="server" 
                    ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" 
                    ErrorMessage="Passwords do not match" CssClass="validation-error" Display="Dynamic"></asp:CompareValidator>
            </div>
            
            <div class="form-group">
                <asp:Label ID="lblRole" runat="server" Text="I am a:"></asp:Label>
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Student" Value="student" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Teacher" Value="teacher"></asp:ListItem>
                </asp:DropDownList>
            </div>
            
            <div class="form-group">
                <asp:Button ID="btnRegister" runat="server" Text="Register" OnClick="btnRegister_Click" CssClass="btn-primary" />
            </div>
            
            <div class="form-group">
                <asp:Label ID="lblMessage" runat="server" CssClass="success-message"></asp:Label>
            </div>
            
            <div class="form-links">
                <p>Already have an account? <a href="Login.aspx">Login here</a></p>
            </div>
        </div>
    </form>
</body>
</html>