<%@ Page Title="Edit Student" Language="C#" MasterPageFile="AdminSite.master" AutoEventWireup="true" CodeBehind="EditStudent.aspx.cs" Inherits="EdupathWebForms.Pages.Admin.EditStudent" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Edit Student</h2>

    <div class="mb-3">
        <label>Username</label>
        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" />
    </div>
    <div class="mb-3">
        <label>Email</label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
    </div>
    <div>
        <label>Password</label>
        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" />
    </div>
    <br />
    <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-primary" OnClick="btnUpdate_Click" />
    <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn btn-danger ms-2" OnClick="btnDelete_Click" OnClientClick="return confirm('Are you sure you want to delete this student?');" />
</asp:Content>
