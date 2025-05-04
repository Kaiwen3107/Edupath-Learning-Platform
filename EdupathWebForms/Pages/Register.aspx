<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="EdupathWebForms.Pages.Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edupath - Registration</title>
    <style type="text/css">
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            height: 100vh;
            background: linear-gradient(45deg, #00c6ff, #7b4397, #dc2430);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .register-container {
            width: 380px;
            background-color: white;
            padding: 30px 40px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }

        h2 {
            text-align: center;
            color: #333;
            font-size: 28px;
            font-weight: 600;
            margin-top: 0;
            margin-bottom: 10px;
        }

        .subtitle {
            text-align: center;
            color: #666;
            font-size: 14px;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-size: 14px;
            color: #333;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 15px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #7b4397;
            box-shadow: 0 0 0 2px rgba(123, 67, 151, 0.1);
        }

        .password-wrapper {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #999;
            cursor: pointer;
        }

        .checkbox-wrapper {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .checkbox-wrapper input {
            margin-top: 4px;
            margin-right: 10px;
        }

        .checkbox-wrapper label {
            font-size: 13px;
            color: #555;
            line-height: 1.4;
        }

        .btn-primary {
            background-color: #8e44ad;
            color: white;
            padding: 14px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            display: block;
            width: 100%;
            transition: background-color 0.3s;
        }

        .btn-primary:hover {
            background-color: #7b2d9b;
        }

        .validation-error {
            color: #e74c3c;
            font-size: 12px;
            display: block;
            margin-top: 5px;
        }

        .success-message {
            color: #2ecc71;
            text-align: center;
            margin-top: 10px;
            font-weight: 500;
        }

        .form-links {
            text-align: center;
            margin-top: 25px;
            font-size: 14px;
            color: #666;
        }

        .form-links a {
            color: #8e44ad;
            text-decoration: none;
            font-weight: 500;
        }

        .form-links a:hover {
            text-decoration: underline;
        }

        .terms-text {
            text-align: center;
            font-size: 12px;
            color: #888;
            margin-top: 20px;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-container">
            <h2>Register</h2>
            <div class="subtitle">Create an account or <asp:HyperLink ID="hlSignIn" runat="server" NavigateUrl="~/Pages/Login.aspx">Login</asp:HyperLink></div>
            
            <div class="form-group">
                <asp:Label ID="lblEmail" runat="server" Text="Email address"></asp:Label>
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
                <asp:Label ID="lblUsername" runat="server" Text="Username"></asp:Label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                    ControlToValidate="txtUsername" ErrorMessage="Username is required" 
                    CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>
            
            <div class="form-group">
                <asp:Label ID="lblPassword" runat="server" Text="Password"></asp:Label>
                <div class="password-wrapper">
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                    <asp:Button runat="server" CssClass="password-toggle" OnClientClick="togglePasswordVisibility('txtPassword'); return false;" CausesValidation="false" Text="" />
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="position:absolute; right:12px; top:50%; transform:translateY(-50%); pointer-events:none;">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                        <circle cx="12" cy="12" r="3"></circle>
                    </svg>
                </div>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                    ControlToValidate="txtPassword" ErrorMessage="Password is required" 
                    CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revPassword" runat="server" 
                    ControlToValidate="txtPassword" ErrorMessage="Password must be at least 6 characters long" 
                    ValidationExpression=".{6,}" CssClass="validation-error" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>
            
            <div class="form-group">
                <asp:Label ID="lblConfirmPassword" runat="server" Text="Confirm Password"></asp:Label>
                <div class="password-wrapper">
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                    <asp:Button runat="server" CssClass="password-toggle" OnClientClick="togglePasswordVisibility('txtConfirmPassword'); return false;" CausesValidation="false" Text="" />
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="position:absolute; right:12px; top:50%; transform:translateY(-50%); pointer-events:none;">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                        <circle cx="12" cy="12" r="3"></circle>
                    </svg>
                </div>
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                    ControlToValidate="txtConfirmPassword" ErrorMessage="Please confirm your password" 
                    CssClass="validation-error" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:CompareValidator ID="cvPassword" runat="server" 
                    ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" 
                    ErrorMessage="Passwords do not match" CssClass="validation-error" Display="Dynamic"></asp:CompareValidator>
            </div>
            
            <div class="form-group">
                <asp:Label ID="lblRole" runat="server" Text="I am a"></asp:Label>
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Student" Value="student" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Teacher" Value="teacher"></asp:ListItem>
                </asp:DropDownList>
            </div>
            
            
            <div class="form-group">
                <asp:Button ID="btnRegister" runat="server" Text="Sign up" OnClick="btnRegister_Click" CssClass="btn-primary" UseSubmitBehavior="true" />
            </div>
            
            <div class="form-group">
                <asp:Label ID="lblMessage" runat="server" CssClass="success-message"></asp:Label>
            </div>
            
            <div class="terms-text">
                By signing up to create an account, you are accepting our terms of service and privacy policy
            </div>
        </div>
    </form>

    <script type="text/javascript">
        function togglePasswordVisibility(controlId) {
            var passwordInput = document.getElementById(controlId);
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
            } else {
                passwordInput.type = "password";
            }
        }

        // Fix for password toggle button causing form submission
        document.addEventListener('DOMContentLoaded', function () {
            var passwordToggle = document.querySelector('.password-toggle');
            if (passwordToggle) {
                passwordToggle.addEventListener('click', function (e) {
                    e.preventDefault(); // Prevent the default button behavior
                });
            }

            // Add click event to the signup button as backup
            var signupBtn = document.getElementById('<%= btnRegister.ClientID %>');
            if (signupBtn) {
                signupBtn.addEventListener('click', function (e) {
                    // This is a backup to ensure the form submits
                    console.log('Sign up button clicked');
                });
            }
        });
    </script>
</body>
</html>