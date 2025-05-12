<%@ Page Title="Student Dashboard" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="EdupathWebForms.Pages.StudentDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2 class="mb-4">Welcome, <%= Session["Username"] %> 👋</h2>

    <!-- Join Class -->
    <div class="card mb-4">
        <div class="card-header bg-primary text-white">
            Join a New Class
        </div>
        <div class="card-body">
            <div class="row g-2">
                <div class="col-md-9">
                    <asp:TextBox ID="txtCode" runat="server" CssClass="form-control" placeholder="Enter class code" />
                </div>
                <div class="col-md-3">
                    <asp:Button ID="btnJoin" runat="server" CssClass="btn btn-primary w-100" Text="Join" OnClick="btnJoin_Click" />
                </div>
            </div>
            <asp:Label ID="lblJoinResult" runat="server" CssClass="text-danger mt-2 d-block"></asp:Label>
        </div>
    </div>

    <!-- My Classes -->
    <h4>My Enrolled Classes</h4>
    <asp:Repeater ID="rptClasses" runat="server">
        <ItemTemplate>
            <div class="card mb-3">
                <div class="card-body">
                    <h5 class="card-title"><%# Eval("ClassName") %></h5>
                    <p class="card-text"><%# Eval("Description") %></p>
                    <a href='<%# "ClassDetail.aspx?classId=" + Eval("ClassID") %>' class="btn btn-outline-primary">Enter Class</a>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</asp:Content>
