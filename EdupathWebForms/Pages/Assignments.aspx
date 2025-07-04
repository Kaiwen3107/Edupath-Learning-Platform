<%@ Page Title="Assignments" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeBehind="Assignments.aspx.cs" Inherits="EdupathWebForms.Pages.Assignments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        /* Basic Styles for assignments list */
        .assignment-time {
            flex-shrink: 0; /* Prevent time from shrinking */
            width: 60px; /* Fixed width for time display */
            text-align: right;
            font-weight: bold;
            font-size: 0.95rem;
        }

        .assignment-entry {
            display: flex;
            align-items: flex-start; /* Align content to the top */
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .assignment-entry:last-child {
            border-bottom: none; /* No border for the last item */
        }

        .assignment-details {
            flex-grow: 1;
            padding-left: 15px;
        }

        .assignment-title {
            font-weight: 600;
            color: #34495e;
            font-size: 1.1rem;
        }

        .assignment-class-info {
            color: #7f8c8d;
            font-size: 0.85rem;
            margin-top: 5px;
        }

        .action-button {
            flex-shrink: 0; /* Prevent button from shrinking */
            margin-left: 15px;
        }

        /* Styling for the date headers */
        .date-header {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2c3e50;
            margin-top: 30px;
            margin-bottom: 15px;
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 5px;
        }

        /* Message for no assignments */
        .no-assignments-message {
            text-align: center;
            padding: 50px 0;
            color: #95a5a6;
            font-size: 1.2rem;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .assignment-entry {
                flex-direction: column;
                align-items: flex-start;
            }
            .assignment-time {
                width: auto;
                text-align: left;
                margin-bottom: 5px;
            }
            .assignment-details {
                padding-left: 0;
            }
            .action-button {
                margin-top: 10px;
                margin-left: 0;
                width: 100%; /* Full width button on small screens */
                text-align: center;
            }
        }
    </style>

    <div class="container py-4">
        <h2 class="mb-4">📋 Upcoming Assignments</h2>

        <asp:Repeater ID="rptAssignments" runat="server">
            <ItemTemplate>
                <%-- This Literal will render the date header if applicable for the current item --%>
                <asp:Literal ID="litDateHeader" runat="server" Text='<%# Eval("DateHeader") %>' />
                
                <div class="assignment-entry">
                    <div class="assignment-time text-muted">
                        <%# Convert.ToDateTime(Eval("DueDate")).ToString("HH:mm") %>
                    </div>
                    <div class="assignment-details">
                        <div class="assignment-title"><%# Eval("Title") %></div>
                        <div class="assignment-class-info">Assignment is due &bull; <%# Eval("ClassName") %></div>
                    </div>
                    <div class="action-button">
                        <a href='<%# "AssignmentSubmission.aspx?assignmentId=" + Eval("AssignmentID") %>' class="btn btn-primary btn-sm">
                            <i class="fas fa-upload me-1"></i> Add submission
                        </a>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Label ID="lblNoAssignment" runat="server" CssClass="no-assignments-message" Visible="false">
            <i class="fas fa-check-circle fa-2x mb-3 d-block"></i>
            🎉 No upcoming assignments! Good job!
        </asp:Label>
    </div>
</asp:Content>