<%@ Page Title="Teacher Dashboard" Language="C#" MasterPageFile="TeacherSite.master" AutoEventWireup="true" CodeBehind="TeacherDashboard.aspx.cs" Inherits="EdupathWebForms.Pages.Teacher.TeacherDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --accent-color: #f39c12;
            --dark-color: #2c3e50;
            --light-color: #f8f9fa;
        }
        
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }
        
        .dashboard-title {
            color: var(--dark-color);
            font-weight: 600;
            margin-bottom: 0;
        }
        
        .stat-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            height: 100%;
            overflow: hidden;
            border-left: 4px solid;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }
        
        .stat-card.classes {
            border-left-color: var(--primary-color);
        }
        
        .stat-card.assignments {
            border-left-color: var(--secondary-color);
        }
        
        .stat-card.submissions {
            border-left-color: var(--accent-color);
        }
        
        .stat-card .card-body {
            padding: 1.5rem;
            text-align: center;
        }
        
        .stat-card .card-title {
            font-size: 1rem;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }
        
        .stat-card .card-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 0;
        }
        
        .stat-card .card-icon {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: inherit;
        }
        
        .recent-activity {
            margin-top: 2rem;
        }
        
        .activity-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
        }
        
        .activity-title {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 1px solid #eee;
        }
        
        .quick-actions {
            margin-top: 2rem;
        }
        
        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            border-radius: 8px;
            background-color: white;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            height: 100%;
            text-align: center;
            border: none;
            color: var(--dark-color);
        }
        
        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
            text-decoration: none;
            color: var(--primary-color);
        }
        
        .action-btn i {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }
    </style>

    <div class="container-fluid">
        <div class="dashboard-header">
            <h2 class="dashboard-title">📊 Teacher Dashboard</h2>
            <div class="text-muted">
                Last login: <%= DateTime.Now.ToString("MMM dd, yyyy hh:mm tt") %>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="stat-card classes">
                    <div class="card-body">
                        <div class="card-icon">📁</div>
                        <h5 class="card-title">My Classes</h5>
                        <h2 class="card-value"><asp:Label ID="lblClassCount" runat="server" /></h2>
                    </div>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="stat-card assignments">
                    <div class="card-body">
                        <div class="card-icon">📝</div>
                        <h5 class="card-title">Assignments Created</h5>
                        <h2 class="card-value"><asp:Label ID="lblAssignmentCount" runat="server" /></h2>
                    </div>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="stat-card submissions">
                    <div class="card-body">
                        <div class="card-icon">📨</div>
                        <h5 class="card-title">Total Submissions</h5>
                        <h2 class="card-value"><asp:Label ID="lblSubmissionCount" runat="server" /></h2>
                    </div>
                </div>
            </div>
        </div>


        <!-- Recent Activity -->
        <div class="recent-activity">
            <div class="activity-card">
                <h4 class="activity-title">Recent Activity</h4>
                <asp:GridView ID="gvRecentActivity" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="ActivityType" HeaderText="Activity" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center py-4 text-muted">
                            No recent activity found
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>