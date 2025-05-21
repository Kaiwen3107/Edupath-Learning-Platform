<%@ Page Title="Manual Enroll" Language="C#" MasterPageFile="AdminSite.master" AutoEventWireup="true" CodeBehind="ManualEnroll.aspx.cs" Inherits="EdupathWebForms.Pages.Admin.ManualEnroll" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- 搜索学生 -->
    <div class="input-group mb-2">
        <asp:TextBox ID="txtSearchStudent" runat="server" CssClass="form-control" placeholder="Search student name..." />
        <asp:Button ID="btnSearchStudent" runat="server" Text="Search" CssClass="btn btn-outline-secondary" OnClick="btnSearchStudent_Click" />
    </div>
        <asp:DropDownList ID="ddlStudents" runat="server" CssClass="form-select mb-3" />

    <!-- 搜索课程 -->
    <div class="input-group mb-2">
        <asp:TextBox ID="txtSearchClass" runat="server" CssClass="form-control" placeholder="Search class name..." />
        <asp:Button ID="btnSearchClass" runat="server" Text="Search" CssClass="btn btn-outline-secondary" OnClick="btnSearchClass_Click" />
    </div>
        <asp:DropDownList ID="ddlClasses" runat="server" CssClass="form-select mb-3" />

        <asp:Button ID="btnEnroll" runat="server" Text="Enroll" CssClass="btn btn-primary" OnClick="btnEnroll_Click" />
        <asp:Label ID="lblResult" runat="server" CssClass="text-success d-block mt-3" />
</asp:Content>
