<%@ Page Title="Class Details" Language="C#" MasterPageFile="~/Pages/Teacher/TeacherSite.master" AutoEventWireup="true" CodeBehind="ClassDetailTeacher.aspx.cs" Inherits="EdupathWebForms.Pages.Teacher.ClassDetailTeacher" EnableViewState="true" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        /* Base Styles */
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --accent-color: #f39c12;
            --danger-color: #e74c3c;
            --dark-color: #2c3e50;
            --light-color: #f8f9fa;
            --border-radius: 8px;
            --box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        body {
            background-color: #f5f7fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
        }
        
        /* Header Section */
        .class-header {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .class-title {
            color: var(--dark-color);
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .class-description {
            color: #6c757d;
            margin-bottom: 15px;
        }
        
        .enrollment-code {
            background-color: var(--light-color);
            padding: 8px 12px;
            border-radius: var(--border-radius);
            display: inline-block;
            font-family: monospace;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }
        
        .action-btn {
            padding: 10px 15px;
            border-radius: var(--border-radius);
            font-weight: 500;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        
        .btn-outline-primary {
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
        }
        
        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-outline-success {
            border: 2px solid var(--secondary-color);
            color: var(--secondary-color);
        }
        
        .btn-outline-success:hover {
            background-color: var(--secondary-color);
            color: white;
        }
        
        .btn-outline-warning {
            border: 2px solid var(--accent-color);
            color: var(--accent-color);
        }
        
        .btn-outline-warning:hover {
            background-color: var(--accent-color);
            color: white;
        }
        
        .btn-outline-danger {
            border: 2px solid var(--danger-color);
            color: var(--danger-color);
        }
        
        .btn-outline-danger:hover {
            background-color: var(--danger-color);
            color: white;
        }
        
        /* Content Cards */
        .section-title {
            color: var(--dark-color);
            font-weight: 600;
            margin: 30px 0 15px;
            padding-bottom: 8px;
            border-bottom: 2px solid var(--light-color);
        }
        
        .content-card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.2s ease;
            border-left: 4px solid var(--primary-color);
        }
        
        .content-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }
        
        .card-title {
            color: var(--dark-color);
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .card-text {
            color: #6c757d;
            margin-bottom: 15px;
        }
        
        .due-date {
            background-color: var(--light-color);
            padding: 5px 10px;
            border-radius: 20px;
            display: inline-block;
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
        
        .card-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .card-btn {
            padding: 6px 12px;
            font-size: 0.9rem;
            border-radius: var(--border-radius);
            text-decoration: none;
            transition: all 0.2s;
        }
        
        .card-btn:hover {
            text-decoration: none;
        }
        
        /* Students List */
        .student-item {
            background-color: white;
            border-radius: var(--border-radius);
            padding: 12px 15px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .student-info {
            font-weight: 500;
        }
        
        .student-email {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        /* Discussion Section */
        .discussion-form {
            background-color: white;
            border-radius: var(--border-radius);
            padding: 20px;
            box-shadow: var(--box-shadow);
            margin-bottom: 25px;
        }
        
        .discussion-item {
            background-color: white;
            border-radius: var(--border-radius);
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: var(--box-shadow);
        }
        
        .discussion-author {
            font-weight: 600;
            color: var(--dark-color);
            margin-bottom: 5px;
        }
        
        .discussion-time {
            color: #6c757d;
            font-size: 0.85rem;
        }
        
        .discussion-message {
            margin-top: 10px;
            white-space: pre-wrap;
        }
        
        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin: 20px 0;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 30px;
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            color: #6c757d;
        }
        
        /* Status Messages */
        .status-message {
            padding: 12px;
            border-radius: var(--border-radius);
            margin: 15px 0;
            font-weight: 500;
        }
        
        .status-success {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-error {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>

    <div class="class-header">
        <h2 class="class-title">🏫 Class Details</h2>
        
        <div class="action-buttons">
            <a href='<%= "AddContent.aspx?classId=" + classId %>' class="action-btn btn-outline-primary">➕ Add Content</a>
            <a href='<%= "AddAssignment.aspx?classId=" + classId %>' class="action-btn btn-outline-success">📝 Add Assignment</a>
            <a href='<%= "AddQuiz.aspx?classId=" + classId %>' class="action-btn btn-outline-warning">🧪 Add Quiz</a>
            <asp:Button ID="btnDeleteClass" runat="server" Text="🗑 Delete Class" CssClass="action-btn btn-outline-danger"
                OnClick="btnDeleteClass_Click"
                OnClientClick="return confirm('Are you sure you want to delete this class? This will remove all assignments, quizzes, and enrollments.');" />
        </div>
        
        <h4 class="class-title"><asp:Label ID="lblClassName" runat="server" /></h4>
        <p class="class-description"><asp:Label ID="lblDescription" runat="server" /></p>
        <p><strong>Enrollment Code:</strong> <span class="enrollment-code"><asp:Label ID="lblCode" runat="server" /></span></p>
    </div>

    <!-- Content Section -->
    <h4 class="section-title">📚 Contents</h4>
    <asp:Repeater ID="rptContents" runat="server">
        <ItemTemplate>
            <div class="content-card">
                <h5 class="card-title"><%# Eval("Title") %></h5>
                <p class="card-text"><%# Eval("Description") %></p>
                <div class="card-actions">
                    <%# Eval("ContentURL") != DBNull.Value ? "<a href='" + ResolveUrl("~/" + Eval("ContentURL").ToString()) + "' class='card-btn btn-outline-primary' target='_blank'>View File</a>" : "" %>
                    <a href='<%# "EditContent.aspx?contentId=" + Eval("ContentID") %>' class="card-btn btn-outline-secondary">Edit</a>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate>
            <div class="empty-state">
                <asp:Label ID="lblNoContent" runat="server" Text="No content found." Visible='<%# rptContents.Items.Count == 0 %>'></asp:Label>
            </div>
        </FooterTemplate>
    </asp:Repeater>

    <!-- Assignments Section -->
    <h4 class="section-title">📝 Assignments</h4>
    <asp:Repeater ID="rptAssignments" runat="server">
        <ItemTemplate>
            <div class="content-card">
                <h5 class="card-title"><%# Eval("Title") %></h5>
                <p class="card-text"><%# Eval("Description") %></p>
                <div class="due-date">
                    <i class="far fa-calendar-alt"></i> Due: <%# Eval("DueDate", "{0:yyyy-MM-dd HH:mm}") %>
                </div>
                <div class="card-actions">
                    <a href='<%# "AssignmentSubmissionList.aspx?assignmentId=" + Eval("AssignmentID") %>' class="card-btn btn-outline-secondary">📋 View Submissions</a>
                    <%# Eval("AssignmentURL") != DBNull.Value ? "<a href='" + ResolveUrl("~/" + Eval("AssignmentURL").ToString()) + "' class='card-btn btn-outline-primary' target='_blank'>View File</a>" : "" %>
                    <a href='<%# "EditAssignment.aspx?assignmentId=" + Eval("AssignmentID") %>' class="card-btn btn-outline-secondary">Edit</a>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate>
            <div class="empty-state">
                <asp:Label ID="lblNoAssignments" runat="server" Text="No assignments found." Visible='<%# rptAssignments.Items.Count == 0 %>'></asp:Label>
            </div>
        </FooterTemplate>
    </asp:Repeater>

    <!-- Quizzes Section -->
    <h4 class="section-title">🧪 Quizzes</h4>
    <asp:Repeater ID="rptQuizzes" runat="server">
        <ItemTemplate>
            <div class="content-card">
                <h5 class="card-title"><%# Eval("Title") %></h5>
                <p class="card-text"><%# Eval("Description") %></p>
                <div class="card-actions">
                    <a href='<%# "../TakeQuiz.aspx?quizId=" + Eval("QuizID") + "&readonly=true" %>' class="card-btn btn-outline-secondary">Preview</a>
                    <a href='<%# "QuizScores.aspx?quizId=" + Eval("QuizID") %>' class="card-btn btn-outline-info">📊 View Scores</a>
                    <a href='<%# "EditQuiz.aspx?quizId=" + Eval("QuizID") %>' class="card-btn btn-outline-secondary">Edit</a>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate>
            <div class="empty-state">
                <asp:Label ID="lblNoQuizzes" runat="server" Text="No quizzes found." Visible='<%# rptQuizzes.Items.Count == 0 %>'></asp:Label>
            </div>
        </FooterTemplate>
    </asp:Repeater>

    <!-- Students Section -->
    <h4 class="section-title">👨‍🎓 Enrolled Students</h4>
    <asp:Repeater ID="rptStudents" runat="server">
        <ItemTemplate>
            <div class="student-item">
                <div class="student-info">
                    <%# Eval("username") %> <span class="student-email">(<%# Eval("email") %>)</span>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <div class="pagination">
        <asp:Button ID="btnPrevStudent" runat="server" Text="Previous" OnClick="btnPrevStudent_Click" CssClass="card-btn btn-outline-secondary" />
        <asp:Button ID="btnNextStudent" runat="server" Text="Next" OnClick="btnNextStudent_Click" CssClass="card-btn btn-outline-secondary" />
    </div>

    <!-- Discussion Section -->
    <h4 class="section-title">💬 Class Discussion</h4>
    <div class="discussion-form">
        <asp:TextBox ID="txtNewComment" runat="server" CssClass="form-control mb-2" TextMode="MultiLine" Rows="3" placeholder="Enter your comment here..."></asp:TextBox>
        <asp:RequiredFieldValidator ID="rfvComment" runat="server" ControlToValidate="txtNewComment" ErrorMessage="Comment cannot be empty" CssClass="text-danger d-block mt-1" Display="Dynamic" />
        <asp:Button ID="btnPostComment" runat="server" Text="Post Comment" CssClass="action-btn btn-outline-primary" OnClick="btnPostComment_Click" />
    </div>

    <asp:Repeater ID="rptDiscussion" runat="server">
        <ItemTemplate>
            <div class="discussion-item">
                <div class="discussion-author"><%# Eval("Username") %></div>
                <div class="discussion-time"><%# Eval("CreatedAt", "{0:yyyy-MM-dd HH:mm}") %></div>
                <div class="discussion-message"><%# Eval("Message") %></div>
            </div>
        </ItemTemplate>
        <FooterTemplate>
            <div class="empty-state">
                <asp:Label ID="lblNoDiscussions" runat="server" Text="No discussions yet. Be the first to post!" Visible='<%# rptDiscussion.Items.Count == 0 %>'></asp:Label>
            </div>
        </FooterTemplate>
    </asp:Repeater>

    <div class="pagination">
        <asp:Button ID="btnPrevDiscussion" runat="server" Text="Previous" OnClick="btnPrevDiscussion_Click" CssClass="card-btn btn-outline-secondary" />
        <asp:Button ID="btnNextDiscussion" runat="server" Text="Next" OnClick="btnNextDiscussion_Click" CssClass="card-btn btn-outline-secondary" />
    </div>

    <!-- Status Message -->
    <asp:Label ID="lblResult" runat="server" CssClass="status-message" Visible="false" />
</asp:Content>