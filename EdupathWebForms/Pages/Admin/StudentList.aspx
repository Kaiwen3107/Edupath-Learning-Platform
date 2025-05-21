<%@ Page Title="Student List" Language="C#" MasterPageFile="AdminSite.master" AutoEventWireup="true" CodeBehind="StudentList.aspx.cs" Inherits="EdupathWebForms.Pages.Admin.StudentList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>👨‍🎓 Student List</h2>

<div class="input-group mb-3 mt-3">
    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by username or email..." />
    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-outline-primary" OnClick="btnSearch_Click" />
</div>
<asp:GridView ID="gvStudents" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered mt-4">
    <Columns>
        <asp:BoundField DataField="user_id" HeaderText="ID" />
        <asp:BoundField DataField="username" HeaderText="Username" />
        <asp:BoundField DataField="email" HeaderText="Email" />
        <asp:BoundField DataField="RegisterAt" HeaderText="Registered At" DataFormatString="{0:yyyy-MM-dd}" />
        <asp:TemplateField HeaderText="Action">
            <ItemTemplate>
                <a href='<%# "EditStudent.aspx?id=" + Eval("user_id") %>' class="btn btn-sm btn-outline-primary">Edit</a>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
</asp:Content>