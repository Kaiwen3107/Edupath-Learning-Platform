<%@ Page Title="Student Dashboard" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="EdupathWebForms.Pages.StudentDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        /* Main Container Styles */
        .student-dashboard {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        /* Welcome Header */
        .welcome-header {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Card Styles */
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        
        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }
        
        .card-header {
            font-weight: 600;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .card-body {
            padding: 1.5rem;
        }
        
        /* Join Class Section */
        .join-class-form .form-control {
            height: calc(2.5rem + 2px);
            border-radius: 6px;
            border: 1px solid #ced4da;
        }
        
        .join-class-form .btn {
            height: calc(2.5rem + 2px);
            border-radius: 6px;
            font-weight: 500;
        }
        
        /* Class Cards */
        .class-card {
            transition: all 0.3s ease;
        }
        
        .class-card .card-title {
            color: #3498db;
            font-weight: 600;
            margin-bottom: 0.75rem;
        }
        
        .class-card .card-text {
            color: #7f8c8d;
            margin-bottom: 1.25rem;
        }
        
        .class-card .btn {
            border-radius: 6px;
            font-weight: 500;
            padding: 0.5rem 1.25rem;
            transition: all 0.2s;
        }
        
        /* Status Messages */
        .status-message {
            padding: 0.75rem 1rem;
            border-radius: 6px;
            margin-top: 1rem;
            display: none;
        }
        
        .status-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .status-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .card-body {
                padding: 1rem;
            }
            
            .welcome-header {
                font-size: 1.75rem;
            }
            
            .join-class-form .col-md-9, 
            .join-class-form .col-md-3 {
                width: 100%;
                margin-bottom: 10px;
            }
        }
    </style>

    <div class="student-dashboard">
        <h2 class="welcome-header">Welcome, <%= Session["Username"] %> 👋</h2>

        <!-- Join Class -->
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                Join a New Class
            </div>
            <div class="card-body join-class-form">
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
        <h4 class="mb-3">My Enrolled Classes</h4>
        <asp:Repeater ID="rptClasses" runat="server">
            <ItemTemplate>
                <div class="card mb-3 class-card">
                    <div class="card-body">
                        <h5 class="card-title"><%# Eval("ClassName") %></h5>
                        <p class="card-text"><%# Eval("Description") %></p>
                        <a href='<%# "ClassDetail.aspx?classId=" + Eval("ClassID") %>' class="btn btn-outline-primary">Enter Class</a>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>