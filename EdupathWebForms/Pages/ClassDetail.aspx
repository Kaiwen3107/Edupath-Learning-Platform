<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClassDetail.aspx.cs" Inherits="EdupathWebForms.Pages.ClassDetail" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Class Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --accent-color: #f39c12;
            --light-gray: #f8f9fa;
            --text-dark: #2c3e50;
            --text-light: #7f8c8d;
            --border-radius: 8px;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: var(--text-dark);
            line-height: 1.6;
        }

        .container {
            max-width: 1140px;
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 2rem !important;
        }

        /* Class header styling */
        .class-header {
            border-bottom: 2px solid var(--light-gray);
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            position: relative;
        }

        .class-header h2 {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 0.75rem;
        }

        .class-teacher {
            display: flex;
            align-items: center;
            margin-top: 1rem;
        }

        .teacher-icon {
            color: var(--primary-color);
            margin-right: 10px;
            font-size: 1.2rem;
        }

        /* Section headers */
        .section-header {
            display: flex;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid var(--light-gray);
        }

        .section-header h4 {
            color: var(--text-dark);
            font-weight: 600;
            margin-bottom: 0;
            margin-left: 10px;
        }

        .section-icon {
            color: var(--primary-color);
            font-size: 1.5rem;
        }

        /* Content and assignment cards */
        .card {
            border: none;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 1.5rem;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.12);
        }

        .card-body {
            padding: 1.5rem;
        }

        .card-title {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 0.75rem;
        }

        .card-text {
            color: var(--text-light);
            margin-bottom: 1rem;
        }

        /* Assignment specific styling */
        .due-date {
            background-color: var(--light-gray);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            color: var(--text-dark);
            font-size: 0.9rem;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .due-date i {
            color: #e74c3c;
            margin-right: 5px;
        }

        /* Buttons */
        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-outline-success {
            color: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        .btn-outline-success:hover {
            background-color: var(--secondary-color);
            color: white;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .container {
                padding: 1rem !important;
            }
            
            .card-body {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container py-5">
            <!-- Class Basic Information -->
            <asp:Panel ID="pnlClassInfo" runat="server" CssClass="class-header">
                <h2><asp:Label ID="lblClassName" runat="server" /></h2>
                <p><asp:Label ID="lblDescription" runat="server" /></p>
                <div class="class-teacher">
                    <i class="fas fa-chalkboard-teacher teacher-icon"></i>
                    <strong>Teacher:</strong> <asp:Label ID="lblTeacher" runat="server" CssClass="ms-2" />
                </div>
            </asp:Panel>
            <!-- Class Content List -->
            <asp:Panel ID="pnlContent" runat="server" CssClass="mb-5">
                <div class="section-header">
                    <i class="fas fa-book-open section-icon"></i>
                    <h4>Class Content</h4>
                </div>
                <asp:Repeater ID="rptContent" runat="server">
                    <ItemTemplate>
                        <div class="card mb-3">
                            <div class="card-body">
                                <h5 class="card-title"><%# Eval("Title") %></h5>
                                <p class="card-text"><%# Eval("ContentText") %></p>
                                <%# Eval("ContentURL") != null ? "<a href='" + Eval("ContentURL") + "' target='_blank' class='btn btn-outline-primary'><i class='fas fa-download me-2'></i>Download</a>" : "" %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>
            <!-- Assignment List -->
            <asp:Panel ID="pnlAssignments" runat="server">
                <div class="section-header">
                    <i class="fas fa-tasks section-icon"></i>
                    <h4>Assignments</h4>
                </div>
                <asp:Repeater ID="rptAssignments" runat="server">
                    <ItemTemplate>
                        <div class="card mb-3">
                            <div class="card-body">
                                <h5 class="card-title"><%# Eval("Title") %></h5>
                                <p class="card-text"><%# Eval("Description") %></p>
                                <div class="due-date">
                                    <i class="far fa-calendar-alt"></i>
                                    <strong>Due Date:</strong> <%# Eval("DueDate", "{0:yyyy-MM-dd}") %>
                                </div>
                                <!-- Assignment Actions -->
                                <div class="d-flex mt-3">
                                    <!-- If has AssignmentURL, show download link -->
                                    <asp:Panel runat="server" Visible='<%# !string.IsNullOrEmpty(Eval("AssignmentURL").ToString()) %>'>
                                        <a href='<%# Eval("AssignmentURL") %>' target="_blank" class="btn btn-outline-primary me-2">
                                            <i class="fas fa-paperclip me-1"></i> Download File
                                        </a>
                                    </asp:Panel>
                                    <!-- Redirect to assignment submission page with AssignmentID parameter -->
                                    <a href='<%# "AssignmentSubmission.aspx?assignmentId=" + Eval("AssignmentID") %>' class="btn btn-outline-success">
                                        <i class="fas fa-upload me-1"></i> Submit Assignment
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>
             <!-- Class Content List -->
 <asp:Panel ID="pnlQuizzes" runat="server" CssClass="mb-5">
     <div class="section-header">
         <i class="fas fa-question section-icon"></i>
        <h4>Quizzes</h4>
         </div>
<asp:Repeater ID="rptQuizzes" runat="server">
    <ItemTemplate>
        <div class="card mb-3">
            <div class="card-body">
                <h5 class="card-title"><%# Eval("Title") %></h5>
                <p class="card-text"><%# Eval("Description") %></p>
                <a href='<%# "TakeQuiz.aspx?quizId=" + Eval("QuizID") %>' class="btn btn-outline-primary">Take Quiz</a>
            </div>
        </div>
    </ItemTemplate>
</asp:Repeater>
 </asp:Panel>
        </div>
    </form>
</body>
</html>