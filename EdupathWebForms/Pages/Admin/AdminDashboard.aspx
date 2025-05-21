<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="AdminSite.master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="EdupathWebForms.Pages.Admin.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2 class="mb-4">📊 Admin Dashboard</h2>

    <div class="row">
        <div class="col-md-4 mb-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">👨‍🎓 Total Students</h5>
                    <h2><asp:Label ID="lblStudents" runat="server" /></h2>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">👩‍🏫 Total Teachers</h5>
                    <h2><asp:Label ID="lblTeachers" runat="server" /></h2>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-3">
            <div class="card text-center shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">🏫 Total Classes</h5>
                    <h2><asp:Label ID="lblClasses" runat="server" /></h2>
                </div>
            </div>
        </div>
    </div>

    <h4 class="mt-5">Quick Actions</h4>
        <div class="row">
            <div class="col-md-6 mb-3">
                <a href="CreateUser.aspx" class="btn btn-outline-success w-100">➕ Create User</a>
         </div>
         <div class="col-md-6 mb-3">
               <a href="ManualEnroll.aspx" class="btn btn-outline-primary w-100">🧩 Manual Enroll Student to Class</a>
         </div>
</div>
</asp:Content>
