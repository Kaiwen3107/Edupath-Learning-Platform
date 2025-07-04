<%@ Page Title="Class Details" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" 
    CodeBehind="ClassDetail.aspx.cs" Inherits="EdupathWebForms.Pages.ClassDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
         .class-detail-container {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 30px;
        }
        
        /* Header Styles */
        .class-header {
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 15px;
            margin-bottom: 25px;
        }
        
        .class-title {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .class-description {
            color: #7f8c8d;
            margin-bottom: 15px;
        }
        
        .teacher-info {
            display: flex;
            align-items: center;
            color: #34495e;
        }
        
        .teacher-icon {
            color: #3498db;
            margin-right: 10px;
            font-size: 1.2rem;
        }
        
        /* Section Headers */
        .section-header {
            display: flex;
            align-items: center;
            margin: 25px 0 15px 0;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .section-title {
            color: #2c3e50;
            font-weight: 600;
            margin-left: 10px;
            margin-bottom: 0;
        }
        
        .section-icon {
            color: #3498db;
            font-size: 1.5rem;
        }
        
        /* Card Styles */
        .content-card {
            border: none;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        
        .content-card:hover {
            transform: translateY(-3px);
        }
        
        .card-body {
            padding: 20px;
        }
        
        .card-title {
            color: #3498db;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .card-text {
            color: #7f8c8d;
            margin-bottom: 15px;
        }
        
        /* Due Date Badge */
        .due-date-badge {
            background-color: #f8f9fa;
            padding: 5px 12px;
            border-radius: 20px;
            color: #2c3e50;
            font-size: 0.9rem;
            display: inline-block;
            margin-bottom: 15px;
        }
        
        .due-date-icon {
            color: #e74c3c;
            margin-right: 5px;
        }
        
        /* Button Styles */
        .btn-download {
            color: #3498db;
            border-color: #3498db;
            margin-right: 10px;
        }
        
        .btn-download:hover {
            background-color: #3498db;
            color: white;
        }
        
        .btn-submit {
            color: #2ecc71;
            border-color: #2ecc71;
        }
        
        .btn-submit:hover {
            background-color: #2ecc71;
            color: white;
        }
        
        /* Discussion Section */
        .discussion-card {
            margin-bottom: 20px;
        }
        
        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .user-info {
            display: flex;
            align-items: center;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            background-color: #3498db;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 12px;
        }
        
        .username {
            font-weight: 600;
            margin-bottom: 0;
        }
        
        .message-time {
            color: #95a5a6;
            font-size: 0.85rem;
        }
        
        .message-content {
            white-space: pre-wrap;
            word-wrap: break-word;
            padding-left: 52px;
        }
        
        /* Post Message Form */
        .post-form {
            margin-bottom: 30px;
        }
        
        .form-control {
            border-radius: 6px;
            margin-bottom: 15px;
        }
        
        .btn-post {
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 8px 20px;
        }
        
        .btn-post:hover {
            background-color: #2980b9;
        }
        
        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .class-detail-container {
                padding: 15px;
            }
            
            .card-body {
                padding: 15px;
            }
            
            .btn {
                margin-bottom: 10px;
                width: 100%;
            }
        }

        .class-container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .section-header {
            border-bottom: 1px solid #e9ecef;
            margin: 25px 0 15px;
            padding-bottom: 10px;
        }
        
        .discussion-grid {
            width: 100%;
            margin-top: 20px;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .discussion-grid th {
            background-color: #3498db;
            color: white;
            padding: 12px;
            text-align: left;
        }
        
        .discussion-grid td {
            padding: 12px;
            border-bottom: 1px solid #e9ecef;
            vertical-align: top;
        }
        
        .user-avatar {
            width: 32px;
            height: 32px;
            background-color: #3498db;
            color: white;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 8px;
        }
        
        .message-content {
            white-space: pre-wrap;
        }
        
        .status-message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
            display: none;
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

    <div class="class-container">
        <!-- Class Header -->
        <div class="class-header">
            <h2><asp:Label ID="lblClassName" runat="server" /></h2>
            <p class="text-muted"><asp:Label ID="lblDescription" runat="server" /></p>
            <p><i class="fas fa-chalkboard-teacher"></i> Teacher: <asp:Label ID="lblTeacher" runat="server" /></p>
        </div>

        <!-- Status Message Display -->
        <div id="divStatusMessage" runat="server" class="status-message">
            <span id="statusMessageText" runat="server"></span>
        </div>

           <!-- Class Content Section -->
        <div class="section-header">
            <i class="fas fa-book-open section-icon"></i>
            <h4 class="section-title">Class Content</h4>
        </div>
        
        <asp:Repeater ID="rptContent" runat="server">
            <ItemTemplate>
                <div class="card content-card">
                    <div class="card-body">
                        <h5 class="card-title"><%# Eval("Title") %></h5>
                        <p class="card-text"><%# Eval("Description") %></p>
                        <%# Eval("ContentURL") != null ? "<a href='" + Eval("ContentURL") + "' target='_blank' class='btn btn-download'><i class='fas fa-download me-2'></i>Download</a>" : "" %>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <!-- Assignments Section -->
        <div class="section-header">
            <i class="fas fa-tasks section-icon"></i>
            <h4 class="section-title">Assignments</h4>
        </div>
        
        <asp:Repeater ID="rptAssignments" runat="server">
            <ItemTemplate>
                <div class="card content-card">
                    <div class="card-body">
                        <h5 class="card-title"><%# Eval("Title") %></h5>
                        <p class="card-text"><%# Eval("Description") %></p>
                        <div class="due-date-badge">
                            <i class="far fa-calendar-alt due-date-icon"></i>
                            <strong>Due Date:</strong> <%# Eval("DueDate", "{0:yyyy-MM-dd}") %>
                        </div>
                        <div class="d-flex flex-wrap">
                            <asp:Panel runat="server" Visible='<%# !string.IsNullOrEmpty(Eval("AssignmentURL").ToString()) %>'>
                                <a href='<%# Eval("AssignmentURL") %>' target="_blank" class="btn btn-download me-2 mb-2">
                                    <i class="fas fa-paperclip me-1"></i> Download File
                                </a>
                            </asp:Panel>
                            <a href='<%# "AssignmentSubmission.aspx?assignmentId=" + Eval("AssignmentID") %>' class="btn btn-submit mb-2">
                                <i class="fas fa-upload me-1"></i> Submit Assignment
                            </a>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <!-- Quizzes Section -->
        <div class="section-header">
            <i class="fas fa-question-circle section-icon"></i>
            <h4 class="section-title">Quizzes</h4>
        </div>
        
        <asp:Repeater ID="rptQuizzes" runat="server">
            <ItemTemplate>
                <div class="card content-card">
                    <div class="card-body">
                        <h5 class="card-title"><%# Eval("Title") %></h5>
                        <p class="card-text"><%# Eval("Description") %></p>
                        <a href='<%# "TakeQuiz.aspx?quizId=" + Eval("QuizID") %>' class="btn btn-download">
                            <i class="fas fa-play-circle me-1"></i> Take Quiz
                        </a>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <!-- Discussion Section -->
        <div class="section-header">
            <h4><i class="fas fa-comments"></i> Class Discussion</h4>
        </div>
        
        <!-- Post Message Form -->
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title">Post a Message</h5>
                <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control mb-3" 
                    TextMode="MultiLine" Rows="3" placeholder="Write your message here..."></asp:TextBox>
                <asp:Button ID="btnPost" runat="server" Text="Post Message" 
                    CssClass="btn btn-primary" OnClick="btnPost_Click" />
            </div>
        </div>
        
        <!-- Discussion GridView -->
        <asp:GridView ID="gvDiscussion" runat="server"
            AutoGenerateColumns="False"
            DataKeyNames="DiscussionID,UserID"
            OnRowDeleting="gvDiscussion_RowDeleting"
            OnRowDataBound="gvDiscussion_RowDataBound"
            CssClass="discussion-grid"
            GridLines="None">
            <Columns>
                <asp:TemplateField HeaderText="User">
                    <ItemTemplate>
                        <div class="d-flex align-items-center">
                            <div class="user-avatar">
                                <%# GetInitials(Eval("Username").ToString()) %>
                            </div>
                            <div>
                                <strong><%# Eval("Username") %></strong>
                                <div class="text-muted small">
                                    <%# Eval("CreatedAt", "{0:MMM dd, yyyy HH:mm}") %>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="Message">
                    <ItemTemplate>
                        <div class="message-content">
                            <%# Eval("Message") %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:CommandField 
                    ShowDeleteButton="True" 
                    ButtonType="Button" 
                    DeleteText="Delete"
                    ControlStyle-CssClass="btn btn-sm btn-outline-danger" />
            </Columns>
            <EmptyDataTemplate>
                <div class="text-center py-4 text-muted">
                    <i class="fas fa-comment-slash fa-2x"></i>
                    <p>No discussion messages yet</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>