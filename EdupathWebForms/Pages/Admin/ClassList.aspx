<%@ Page Title="Class List" Language="C#" MasterPageFile="AdminSite.master" AutoEventWireup="true" CodeBehind="ClassList.aspx.cs" Inherits="EdupathWebForms.Pages.Admin.ClassList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>🏫 Class List</h2>

    <asp:GridView ID="gvClasses" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered mt-4">
        <Columns>
            <asp:BoundField DataField="ClassID" HeaderText="Class ID" />
            <asp:BoundField DataField="ClassName" HeaderText="Class Name" />
            <asp:BoundField DataField="TeacherName" HeaderText="Teacher" />
            <asp:BoundField DataField="EnrollmentCode" HeaderText="Enrollment Code" />
            <asp:TemplateField HeaderText="Action">
                <ItemTemplate>
                    <a href='<%# "EditClass.aspx?id=" + Eval("ClassID") %>' class="btn btn-sm btn-outline-primary">Edit</a>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
