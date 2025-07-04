<%@ Page Title="Edit Quiz" Language="C#" MasterPageFile="TeacherSite.master" AutoEventWireup="true" CodeBehind="EditQuiz.aspx.cs" Inherits="EdupathWebForms.Pages.Teacher.EditQuiz" EnableViewState="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --danger-color: #e74c3c;
            --dark-color: #2c3e50;
            --light-color: #f8f9fa;
        }
        
        .edit-quiz-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            border-bottom: 1px solid #eee;
            padding-bottom: 1rem;
        }
        
        .page-header h2 {
            color: var(--dark-color);
            font-weight: 600;
            margin-bottom: 0;
        }
        
        .btn-back {
            background-color: var(--light-color);
            color: var(--dark-color);
            border: 1px solid #ddd;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .btn-back:hover {
            background-color: #e9ecef;
            text-decoration: none;
        }
        
        .quiz-form {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        
        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--dark-color);
        }
        
        .form-control {
            border-radius: 6px;
            padding: 0.75rem 1rem;
            border: 1px solid #ced4da;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(52, 152, 219, 0.25);
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
        }
        
        .btn-danger {
            background-color: var(--danger-color);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
        }
        
        .btn-success {
            background-color: var(--secondary-color);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
        }
        
        .btn:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }
        
        .status-message {
            padding: 0.75rem 1rem;
            border-radius: 6px;
            margin: 1rem 0;
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
        
        .question-card {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .question-card h5 {
            color: var(--dark-color);
            font-weight: 600;
            margin-bottom: 1.5rem;
        }
        
        .option-label {
            font-weight: 500;
            color: var(--dark-color);
        }
        
        .correct-answer-container {
            margin-top: 1rem;
        }
        
        .questions-grid {
            margin-top: 2rem;
        }
        
        .questions-grid th {
            background-color: var(--dark-color);
            color: white;
            font-weight: 500;
        }
        
        .questions-grid td {
            vertical-align: middle;
        }
        
        .delete-btn {
            color: var(--danger-color);
            background-color: transparent;
            border: 1px solid var(--danger-color);
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .delete-btn:hover {
            color: white;
            background-color: var(--danger-color);
        }
    </style>

    <div class="edit-quiz-container">
        <div class="page-header">
            <h2>✏️ Edit Quiz</h2>
            <a href='<%# "ClassDetailTeacher.aspx?classId=" + Request.QueryString["classId"] %>' class="btn-back">
                <i class="fas fa-arrow-left me-1"></i> Back to Class
            </a>
        </div>
        
        <asp:Label ID="lblStatus" runat="server" CssClass="status-message"></asp:Label>

        <div class="quiz-form">
            <div class="mb-4">
                <label class="form-label">Quiz Title:</label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Enter quiz title" />
                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" 
                    ControlToValidate="txtTitle" 
                    ErrorMessage="Quiz title is required" 
                    Display="Dynamic" 
                    CssClass="text-danger" />
            </div>
            
            <div class="mb-4">
                <label class="form-label">Quiz Description:</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" 
                    TextMode="MultiLine" Rows="4" placeholder="Enter quiz description" />
            </div>
            
            <div class="d-flex gap-2">
                <asp:Button ID="btnUpdate" runat="server" Text="Update Quiz" CssClass="btn btn-primary" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnDelete" runat="server" Text="Delete Quiz" CssClass="btn btn-danger" 
                    OnClick="btnDelete_Click" 
                    OnClientClick="return confirm('Are you sure you want to delete this quiz and all its associated questions and submissions?');" />
            </div>
        </div>

        <div class="question-card">
            <h5>📚 Add New Question</h5>
            
            <div class="mb-3">
                <label class="form-label">Question Text:</label>
                <asp:TextBox ID="txtQuestion" runat="server" CssClass="form-control" placeholder="Enter the question" />
                <asp:RequiredFieldValidator ID="rfvQuestion" runat="server" 
                    ControlToValidate="txtQuestion" 
                    ErrorMessage="Question text is required" 
                    Display="Dynamic" 
                    CssClass="text-danger" />
            </div>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Option A:</label>
                    <asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control" placeholder="Enter option A" />
                    <asp:RequiredFieldValidator ID="rfvOptionA" runat="server" 
                        ControlToValidate="txtOptionA" 
                        ErrorMessage="Option A is required" 
                        Display="Dynamic" 
                        CssClass="text-danger" />
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Option B:</label>
                    <asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control" placeholder="Enter option B" />
                    <asp:RequiredFieldValidator ID="rfvOptionB" runat="server" 
                        ControlToValidate="txtOptionB" 
                        ErrorMessage="Option B is required" 
                        Display="Dynamic" 
                        CssClass="text-danger" />
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Option C:</label>
                    <asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control" placeholder="Enter option C" />
                    <asp:RequiredFieldValidator ID="rfvOptionC" runat="server" 
                        ControlToValidate="txtOptionC" 
                        ErrorMessage="Option C is required" 
                        Display="Dynamic" 
                        CssClass="text-danger" />
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Option D:</label>
                    <asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control" placeholder="Enter option D" />
                    <asp:RequiredFieldValidator ID="rfvOptionD" runat="server" 
                        ControlToValidate="txtOptionD" 
                        ErrorMessage="Option D is required" 
                        Display="Dynamic" 
                        CssClass="text-danger" />
                </div>
            </div>
            
            <div class="correct-answer-container">
                <label class="form-label">Correct Answer:</label>
                <asp:DropDownList ID="ddlCorrect" runat="server" CssClass="form-control">
                    <asp:ListItem Value="A">Option A</asp:ListItem>
                    <asp:ListItem Value="B">Option B</asp:ListItem>
                    <asp:ListItem Value="C">Option C</asp:ListItem>
                    <asp:ListItem Value="D">Option D</asp:ListItem>
                </asp:DropDownList>
            </div>
            
            <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" CssClass="btn btn-success mt-3" OnClick="btnAddQuestion_Click" />
        </div>

        <div class="questions-grid">
            <h3 class="mb-3">📝 Quiz Questions</h3>
            <asp:GridView ID="gvQuestions" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="QuestionID"
                OnRowDeleting="gvQuestions_RowDeleting"
                CssClass="table table-hover table-bordered"
                GridLines="None"
                EmptyDataText="No questions have been added yet">
                <Columns>
                    <asp:BoundField DataField="QuestionID" HeaderText="ID" ItemStyle-Width="50px" />
                    <asp:BoundField DataField="QuestionText" HeaderText="Question" />
                    <asp:BoundField DataField="OptionA" HeaderText="Option A" />
                    <asp:BoundField DataField="OptionB" HeaderText="Option B" />
                    <asp:BoundField DataField="OptionC" HeaderText="Option C" />
                    <asp:BoundField DataField="OptionD" HeaderText="Option D" />
                    <asp:BoundField DataField="CorrectOption" HeaderText="Correct Answer" ItemStyle-Width="100px" />
                    <asp:CommandField ShowDeleteButton="True" ButtonType="Button" DeleteText="Delete" ControlStyle-CssClass="delete-btn" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>