<%@ Page Title="Quiz Scores" Language="C#" MasterPageFile="TeacherSite.master" AutoEventWireup="true" CodeBehind="QuizScores.aspx.cs" Inherits="EdupathWebForms.Pages.Teacher.QuizScores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --accent-color: #f39c12;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
        }
        
        .quiz-scores-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .quiz-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #eee;
        }
        
        .quiz-title {
            color: var(--dark-gray);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .btn-back {
            background-color: var(--light-gray);
            color: var(--dark-gray);
            border: 1px solid #ddd;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
        }
        
        .btn-back:hover {
            background-color: #e9ecef;
            text-decoration: none;
            color: var(--primary-color);
        }
        
        .scores-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .scores-table th {
            background-color: var(--primary-color);
            color: white;
            padding: 12px 15px;
            text-align: left;
            font-weight: 500;
        }
        
        .scores-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        
        .scores-table tr:nth-child(even) {
            background-color: var(--light-gray);
        }
        
        .scores-table tr:hover {
            background-color: rgba(52, 152, 219, 0.1);
        }
        
        .score-high {
            color: var(--secondary-color);
            font-weight: 500;
        }
        
        .score-low {
            color: #e74c3c;
            font-weight: 500;
        }
        
        .no-records {
            text-align: center;
            padding: 50px;
            color: #6c757d;
        }
        
        .stats-container {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .stat-card {
            background-color: white;
            border-radius: 8px;
            padding: 15px 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            flex: 1;
        }
        
        .stat-value {
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
    </style>

    <div class="quiz-scores-container">
        <div class="quiz-header">
            <div>
                <h2 class="quiz-title">📊 Quiz Scores</h2>
                <p><strong>Quiz:</strong> <asp:Label ID="lblQuizTitle" runat="server" /></p>
            </div>
            <a href='<%# "ClassDetailTeacher.aspx?classId=" + Request.QueryString["classId"] %>' class="btn-back">
                <i class="fas fa-arrow-left me-1"></i> Back to Class
            </a>
        </div>
        
        <!-- Statistics Cards -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-value"><asp:Label ID="lblAverageScore" runat="server" Text="0" />%</div>
                <div class="stat-label">Average Score</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><asp:Label ID="lblTotalStudents" runat="server" Text="0" /></div>
                <div class="stat-label">Students Completed</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><asp:Label ID="lblHighScore" runat="server" Text="0" />%</div>
                <div class="stat-label">High Score</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><asp:Label ID="lblLowScore" runat="server" Text="0" />%</div>
                <div class="stat-label">Low Score</div>
            </div>
        </div>
        
        <!-- Scores GridView -->
        <asp:GridView ID="gvScores" runat="server" AutoGenerateColumns="False" 
            CssClass="scores-table" GridLines="None" EmptyDataText="No quiz submissions found">
            <Columns>
                <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                <asp:TemplateField HeaderText="Score">
                    <ItemTemplate>
                        <span class='<%# Convert.ToInt32(Eval("Score")) >= 70 ? "score-high" : "score-low" %>'>
                            <%# Eval("Score") %>%
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="SubmittedAt" HeaderText="Submitted At" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <a href='<%# "QuizSubmissionDetail.aspx?submissionId=" + Eval("SubmissionID") + "&quizId=" + Request.QueryString["quizId"] %>' 
                           class="btn btn-sm btn-outline-primary">
                            <i class="fas fa-eye"></i> View
                        </a>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="no-records">
                    <i class="fas fa-inbox fa-3x mb-3"></i>
                    <h4>No Quiz Submissions Yet</h4>
                    <p>Students haven't completed this quiz yet.</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>