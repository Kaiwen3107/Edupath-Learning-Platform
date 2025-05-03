<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="EdupathWebForms.Pages.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Edupath - Login</title>
    <style>
        :root {
            --primary-color: #4285F4;
            --secondary-color: #F8F9FA;
            --text-color: #333333;
            --error-color: #FF4545;
            --light-gray: #E1E1E1;
            --white: #FFFFFF;
            --shadow: rgba(0, 0, 0, 0.08);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background-color: var(--secondary-color);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        .login-container {
            display: flex;
            background-color: var(--white);
            border-radius: 12px;
            overflow: hidden;
            width: 900px;
            height: 750px;
            box-shadow: 0 8px 24px var(--shadow);
        }
        
        .login-form {
            flex: 1;
            padding: 48px;
            display: flex;
            flex-direction: column;
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 12px;
        }
        
        .logo-icon {
            width: 24px;
            height: 24px;
            background-color: var(--primary-color);
            border-radius: 6px;
            position: relative;
        }
        
        .logo-text {
            font-weight: 600;
            color: var(--text-color);
        }
        
        .login-header {
            margin-top: 48px;
        }
        
        .welcome-text {
            color: #707070;
            font-size: 14px;
            margin-bottom: 12px;
        }
        
        .login-title {
            font-size: 24px;
            font-weight: 600;
            color: var(--text-color);
            margin-bottom: 36px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            font-size: 14px;
            color: #707070;
            margin-bottom: 8px;
        }
        
        .form-control {
            width: 100%;
            height: 48px;
            border: 1px solid var(--light-gray);
            border-radius: 6px;
            padding: 0 16px;
            font-size: 15px;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
        }
        
        .password-container {
            position: relative;
        }
        
        .password-toggle {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            color: #707070;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: var(--white);
            border: none;
            border-radius: 6px;
            height: 48px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            width: 100%;
            margin-top: 16px;
            transition: background-color 0.3s;
        }
        
        .btn-primary:hover {
            background-color: #3367D6;
        }
        
        .error-message {
            color: var(--error-color);
            font-size: 14px;
            margin-top: 4px;
        }
        
        .divider {
            display: flex;
            align-items: center;
            margin: 24px 0;
            color: #707070;
            font-size: 14px;
        }
        
        .divider::before,
        .divider::after {
            content: "";
            flex: 1;
            height: 1px;
            background-color: var(--light-gray);
        }
        
        .divider::before {
            margin-right: 16px;
        }
        
        .divider::after {
            margin-left: 16px;
        }
        
        .social-logins {
            display: flex;
            justify-content: space-between;
            gap: 12px;
        }
        
        .social-btn {
            flex: 1;
            height: 48px;
            border: 1px solid var(--light-gray);
            border-radius: 6px;
            background-color: var(--white);
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .social-btn:hover {
            background-color: #F5F5F5;
        }
        
        .form-links {
            margin-top: 24px;
            text-align: center;
            font-size: 14px;
            color: #707070;
        }
        
        .form-links a {
            color: var(--primary-color);
            text-decoration: none;
            margin: 0 4px;
        }
        
        .form-links a:hover {
            text-decoration: underline;
        }
        
        .login-image {
            flex: 1;
            background: linear-gradient(135deg, #6E8EFB, #4FACFE);
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
        }
        
        .login-image::before {
            content: "";
            position: absolute;
            width: 200%;
            height: 200%;
            background: linear-gradient(135deg, rgba(255,255,255,0.2), rgba(255,255,255,0.1), rgba(255,255,255,0.3));
            border-radius: 35%;
            top: -50%;
            left: -50%;
            animation: rotate 20s linear infinite;
        }
        
        @keyframes rotate {
            from {
                transform: rotate(0deg);
            }
            to {
                transform: rotate(360deg);
            }
        }
        
        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
                width: 100%;
                height: auto;
            }
            
            .login-image {
                display: none;
            }
            
            .login-form {
                padding: 24px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="login-form">
                <div class="logo">
                    <div class="logo-icon"></div>
                    <span class="logo-text">Edupath</span>
                </div>
                
                <div class="login-header">
                    <div class="welcome-text">Start your journey</div>
                    <h2 class="login-title">Sign In to Edupath</h2>
                </div>
                
                <div class="form-group">
                    <asp:Label ID="lblUsername" runat="server" Text="Username" CssClass="form-label"></asp:Label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="example@email.com"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                        ControlToValidate="txtUsername" ErrorMessage="Username is required" 
                        CssClass="error-message"></asp:RequiredFieldValidator>
                </div>
                
                <div class="form-group">
                    <asp:Label ID="lblPassword" runat="server" Text="Password" CssClass="form-label"></asp:Label>
                    <div class="password-container">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                        <button type="button" class="password-toggle">
                            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                <circle cx="12" cy="12" r="3"></circle>
                            </svg>
                        </button>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                        ControlToValidate="txtPassword" ErrorMessage="Password is required" 
                        CssClass="error-message"></asp:RequiredFieldValidator>
                </div>
                
                <asp:Button ID="btnLogin" runat="server" Text="Sign In" OnClick="btnLogin_Click" CssClass="btn-primary" />
                
                <div class="form-group">
                    <asp:Label ID="lblMessage" runat="server" CssClass="error-message"></asp:Label>
                </div>
                
                <div class="divider">or sign in with</div>
                
                <div class="social-logins">
                    <button type="button" class="social-btn">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="#1877F2">
                            <path d="M20.0064 12.0197C20.0064 7.22213 16.1236 3.33936 11.326 3.33936C6.52835 3.33936 2.64557 7.22213 2.64557 12.0197C2.64557 16.3407 5.70537 19.9395 9.77568 20.6611V14.4671H7.71102V12.0197H9.77568V10.1258C9.77568 8.01611 10.9341 6.93594 12.8684 6.93594C13.7952 6.93594 14.7645 7.12413 14.7645 7.12413V9.12181H13.6958C12.6445 9.12181 12.2884 9.80103 12.2884 10.4993V12.0197H14.6726L14.2658 14.4671H12.2884V20.6611C16.3587 19.9395 19.4185 16.3407 19.4185 12.0197H20.0064Z"/>
                        </svg>
                    </button>
                    <button type="button" class="social-btn">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24">
                            <path fill="#EA4335" d="M5.26620003,9.76452941 C6.19878754,6.93863203 8.85444915,4.90909091 12,4.90909091 C13.6909091,4.90909091 15.2181818,5.50909091 16.4181818,6.49090909 L19.9090909,3 C17.7818182,1.14545455 15.0545455,0 12,0 C7.27006974,0 3.1977497,2.69829785 1.23999023,6.65002441 L5.26620003,9.76452941 Z"/>
                            <path fill="#34A853" d="M16.0407269,18.0125889 C14.9509167,18.7163016 13.5660892,19.0909091 12,19.0909091 C8.86648613,19.0909091 6.21911939,17.076871 5.27698177,14.2678769 L1.23746264,17.3349879 C3.19279051,21.2936293 7.26500293,24 12,24 C14.9328362,24 17.7353462,22.9573905 19.834192,20.9995801 L16.0407269,18.0125889 Z"/>
                            <path fill="#4A90E2" d="M19.834192,20.9995801 C22.0291676,18.9520994 23.4545455,15.903663 23.4545455,12 C23.4545455,11.2909091 23.3454545,10.5272727 23.1818182,9.81818182 L12,9.81818182 L12,14.4545455 L18.4363636,14.4545455 C18.1187732,16.013626 17.2662994,17.2212117 16.0407269,18.0125889 L19.834192,20.9995801 Z"/>
                            <path fill="#FBBC05" d="M5.27698177,14.2678769 C5.03832634,13.556323 4.90909091,12.7937589 4.90909091,12 C4.90909091,11.2182781 5.03443647,10.4668121 5.26620003,9.76452941 L1.23999023,6.65002441 C0.43658717,8.26043162 0,10.0753848 0,12 C0,13.9195484 0.444780743,15.7301709 1.23746264,17.3349879 L5.27698177,14.2678769 Z"/>
                        </svg>
                    </button>
                    <button type="button" class="social-btn">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24">
                            <path d="M16.7023 12.6235C16.6606 10.9157 17.9456 9.95125 18.0164 9.90992C17.1015 8.58117 15.7031 8.39859 15.2042 8.38367C14.0348 8.25625 12.8992 9.05484 12.3062 9.05484C11.6967 9.05484 10.7551 8.39109 9.75234 8.40859C8.45984 8.42609 7.25359 9.14984 6.59312 10.2673C5.23328 12.5321 6.24297 15.8732 7.54797 17.5513C8.20328 18.3733 8.96766 19.2863 9.95859 19.249C10.9229 19.2066 11.3086 18.6202 12.4665 18.6202C13.6097 18.6202 13.9707 19.249 14.9799 19.2237C16.0243 19.2066 16.6911 18.405 17.3266 17.5733C18.0757 16.625 18.3735 15.695 18.3867 15.6537C18.3632 15.644 16.7464 14.9646 16.7023 12.6235Z" fill="black"/>
                            <path d="M14.9254 7.21856C15.4588 6.55809 15.8233 5.64918 15.7197 4.72534C14.9437 4.75793 13.9786 5.24387 13.4238 5.8904C12.9295 6.4661 12.4934 7.40502 12.6104 8.29903C13.4818 8.36271 14.3715 7.8674 14.9254 7.21856Z" fill="black"/>
                        </svg>
                    </button>
                </div>
                
                <div class="form-links">
                    <span>Don't have an account?</span>
                    <a href="Register.aspx">Register</a>
                    <span>|</span>
                    <a href="ForgotPassword.aspx">Forgot password?</a>
                </div>
            </div>
            
            <div class="login-image">
                <!-- The animated background is created with CSS -->
            </div>
        </div>
    </form>
    
    <script>
        // Toggle password visibility
        document.querySelector('.password-toggle').addEventListener('click', function() {
            const passwordField = document.getElementById('<%= txtPassword.ClientID %>');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                this.innerHTML = `
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                        <line x1="1" y1="1" x2="23" y2="23"></line>
                    </svg>
                `;
            } else {
                passwordField.type = 'password';
                this.innerHTML = `
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                        <circle cx="12" cy="12" r="3"></circle>
                    </svg>
                `;
            }
        });
    </script>
</body>
</html>