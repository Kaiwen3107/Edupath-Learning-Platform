<%@ Page Title="View Class" Language="C#" MasterPageFile="AdminSite.master" AutoEventWireup="true" CodeBehind="EditClass.aspx.cs" Inherits="EdupathWebForms.Pages.Admin.EditClass" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Class Details</h2>

    <table class="table table-bordered">
        <tr>
            <th>Class ID</th>
            <td><asp:Label ID="lblClassID" runat="server" /></td>
        </tr>
        <tr>
            <th>Class Name</th>
            <td><asp:Label ID="lblClassName" runat="server" /></td>
        </tr>
        <tr>
            <th>Teacher</th>
            <td><asp:Label ID="lblTeacher" runat="server" /></td>
        </tr>
        <tr>
            <th>Enrollment Code</th>
            <td><asp:Label ID="lblCode" runat="server" /></td>
        </tr>
    </table>

    <asp:Button ID="btnDelete" runat="server" Text="Delete Class" CssClass="btn btn-danger"
        OnClick="btnDelete_Click" OnClientClick="return confirm('Are you sure you want to delete this class?');" />

    <asp:Label ID="lblResult" runat="server" CssClass="d-block mt-3 fw-bold" />
</asp:Content>
