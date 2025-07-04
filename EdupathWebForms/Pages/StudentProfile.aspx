<%@ Page Title="Student Profile" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" 
    CodeBehind="StudentProfile.aspx.cs" Inherits="EdupathWebForms.Pages.StudentProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        .profile-container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .profile-avatar {
            width: 100px;
            height: 100px;
            background-color: #3498db;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: bold;
            margin: 0 auto 15px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 600;
            margin-bottom: 5px;
            display: block;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
        }
        
        .btn-save {
            background-color: #3498db;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            transition: background-color 0.3s;
        }
        
        .btn-save:hover {
            background-color: #2980b9;
        }
        
        .status-message {
            padding: 10px;
            margin: 15px 0;
            border-radius: 4px;
            display: none;
        }
        
        .status-success {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-error {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .readonly-info {
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
        }
    </style>

    <div class="profile-container">
        <div class="profile-header">
            <div class="profile-avatar" runat="server" id="divAvatar">
                <!-- Avatar initials will be set in code-behind -->
            </div>
            <h2>Student Profile</h2>
        </div>
        
        <!-- Status Message Display -->
        <div id="divStatusMessage" runat="server" class="status-message">
            <span id="statusMessageText" runat="server"></span>
        </div>
        
        <!-- Read-only Information -->
        <div class="readonly-info">
            <div class="form-group">
                <span class="form-label">User ID</span>
                <asp:Label ID="lblUserId" runat="server" CssClass="form-control-plaintext"></asp:Label>
            </div>
            <div class="form-group">
                <span class="form-label">Role</span>
                <asp:Label ID="lblRole" runat="server" CssClass="form-control-plaintext"></asp:Label>
            </div>
            <div class="form-group">
                <span class="form-label">Registration Date</span>
                <asp:Label ID="lblRegisterDate" runat="server" CssClass="form-control-plaintext"></asp:Label>
            </div>
        </div>
        
        <!-- Editable Information -->
        <div class="form-group">
            <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtUsername">Username</asp:Label>
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtUsername" 
                ErrorMessage="Username is required" Display="Dynamic" CssClass="text-danger"></asp:RequiredFieldValidator>
        </div>
        
        <div class="form-group">
            <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtEmail">Email</asp:Label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" MaxLength="50"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail" 
                ErrorMessage="Email is required" Display="Dynamic" CssClass="text-danger"></asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                ErrorMessage="Invalid email format" Display="Dynamic" CssClass="text-danger"></asp:RegularExpressionValidator>
        </div>
        
        <div class="form-group">
            <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtCurrentPassword">Current Password (required for changes)</asp:Label>
            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtNewPassword">New Password (leave blank to keep current)</asp:Label>
            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtNewPassword"
                ValidationExpression="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$"
                ErrorMessage="Password must be at least 8 characters with at least one letter and one number"
                Display="Dynamic" CssClass="text-danger"></asp:RegularExpressionValidator>
        </div>
        
        <div class="form-group">
            <asp:Label runat="server" CssClass="form-label" AssociatedControlID="txtConfirmPassword">Confirm New Password</asp:Label>
            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
            <asp:CompareValidator runat="server" ControlToValidate="txtConfirmPassword" 
                ControlToCompare="txtNewPassword" ErrorMessage="Passwords do not match" 
                Display="Dynamic" CssClass="text-danger"></asp:CompareValidator>
        </div>
        
        <div class="form-group text-center">
            <asp:Button ID="btnSave" runat="server" Text="Save Changes" CssClass="btn-save" OnClick="btnSave_Click" />
        </div>
    </div>
</asp:Content>