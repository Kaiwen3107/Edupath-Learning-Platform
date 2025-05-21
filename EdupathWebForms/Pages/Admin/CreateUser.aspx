<%@ Page Title="Create User" Language="C#" MasterPageFile="AdminSite.master" AutoEventWireup="true" CodeBehind="CreateUser.aspx.cs" Inherits="EdupathWebForms.Pages.Admin.CreateUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Create New User</h2>

    <!-- 用户名 -->
    <div class="mb-3">
        <label>Username</label>
        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" />
        <asp:RequiredFieldValidator ID="valUsername" runat="server" ControlToValidate="txtUsername"
            ErrorMessage="Username is required." CssClass="text-danger d-block" Display="Static" />
    </div>

    <!-- Email -->
    <div class="mb-3">
        <label>Email</label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
        <asp:RequiredFieldValidator ID="valEmail" runat="server" ControlToValidate="txtEmail"
            ErrorMessage="Email is required." CssClass="text-danger d-block" Display="Static" />
        <asp:RegularExpressionValidator ID="regexEmail" runat="server" ControlToValidate="txtEmail"
            ValidationExpression="^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$"
            ErrorMessage="Invalid email format." CssClass="text-danger d-block" Display="Static" />
    </div>

    <!-- 密码 -->
    <div class="mb-3">
        <label>Password</label>
        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" />
        <asp:RequiredFieldValidator ID="valPassword" runat="server" ControlToValidate="txtPassword"
            ErrorMessage="Password is required." CssClass="text-danger d-block" Display="Static" />
        <asp:RegularExpressionValidator ID="regexPassword" runat="server" ControlToValidate="txtPassword"
            ValidationExpression=".{6,}" ErrorMessage="Password must be at least 6 characters."
            CssClass="text-danger d-block" Display="Static" />
    </div>

    <!-- 角色 -->
    <div class="mb-3">
        <label>Role</label>
        <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select">
            <asp:ListItem Value="student">Student</asp:ListItem>
            <asp:ListItem Value="teacher">Teacher</asp:ListItem>
        </asp:DropDownList>
    </div>

    <asp:Button ID="btnCreate" runat="server" Text="Create" CssClass="btn btn-primary" OnClick="btnCreate_Click" />
    <asp:Label ID="lblStatus" runat="server" CssClass="d-block mt-3 fw-bold" />
</asp:Content>
