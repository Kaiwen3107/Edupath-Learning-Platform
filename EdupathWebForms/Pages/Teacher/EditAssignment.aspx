<%@ Page Title="Edit Assignment" Language="C#" MasterPageFile="TeacherSite.master" AutoEventWireup="true" CodeBehind="EditAssignment.aspx.cs" Inherits="EdupathWebForms.Pages.Teacher.EditAssignment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --danger-color: #e74c3c;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
        }
        
        .edit-assignment-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .edit-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid var(--light-gray);
            padding-bottom: 1rem;
        }
        
        .edit-header h2 {
            color: var(--dark-gray);
            font-weight: 600;
            margin-bottom: 0;
        }
        
        .btn-back {
            background-color: var(--light-gray);
            color: var(--dark-gray);
            border: 1px solid #ddd;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
        }
        
        .btn-back:hover {
            background-color: #e9ecef;
            text-decoration: none;
            transform: translateX(-2px);
        }
        
        .btn-back i {
            margin-right: 5px;
        }
        
        .assignment-form {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 2rem;
        }
        
        .form-label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--dark-gray);
        }
        
        .form-control {
            border-radius: 6px;
            padding: 0.75rem 1rem;
            border: 1px solid #ced4da;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        
        .current-file {
            display: flex;
            align-items: center;
            padding: 0.75rem;
            background-color: var(--light-gray);
            border-radius: 6px;
            margin-bottom: 1rem;
        }
        
        .current-file a {
            color: var(--primary-color);
            text-decoration: none;
            margin-left: 0.5rem;
        }
        
        .current-file a:hover {
            text-decoration: underline;
        }
        
        .file-upload-container {
            border: 2px dashed #ddd;
            border-radius: 6px;
            padding: 1.5rem;
            text-align: center;
            margin-bottom: 1rem;
            transition: all 0.3s;
        }
        
        .file-upload-container:hover {
            border-color: var(--primary-color);
            background-color: rgba(52, 152, 219, 0.05);
        }
        
        .btn-update {
            background-color: var(--primary-color);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-update:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
        }
        
        .btn-delete {
            background-color: var(--danger-color);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-delete:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
        }
        
        .status-message {
            padding: 0.75rem 1rem;
            border-radius: 6px;
            margin-bottom: 1.5rem;
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
    </style>

    <div class="edit-assignment-container">
        <div class="edit-header">
            <h2>✏️ Edit Assignment</h2>
            <a href='<%# "ClassDetailTeacher.aspx?classId=" + Request.QueryString["classId"] %>' class="btn-back">
                <i class="fas fa-arrow-left"></i> Back to Class
            </a>
        </div>
        
        <asp:Label ID="lblStatus" runat="server" CssClass="status-message d-block" />
        
        <div class="assignment-form">
            <div class="mb-4">
                <label class="form-label">Title</label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Enter assignment title" />
                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" 
                    ControlToValidate="txtTitle" 
                    ErrorMessage="Title is required" 
                    Display="Dynamic" 
                    CssClass="text-danger" />
            </div>
            
            <div class="mb-4">
                <label class="form-label">Description</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" 
                    TextMode="MultiLine" Rows="4" placeholder="Enter assignment description" />
                <asp:RequiredFieldValidator ID="rfvDescription" runat="server" 
                    ControlToValidate="txtDescription" 
                    ErrorMessage="Description is required" 
                    Display="Dynamic" 
                    CssClass="text-danger" />
            </div>
            
            <div class="mb-4">
                <label class="form-label">Due Date</label>
                <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                <asp:RequiredFieldValidator ID="rfvDueDate" runat="server" 
                    ControlToValidate="txtDueDate" 
                    ErrorMessage="Due date is required" 
                    Display="Dynamic" 
                    CssClass="text-danger" />
            </div>
            
            <div class="mb-4">
                <label class="form-label">Current File</label>
                <div class="current-file">
                    <i class="fas fa-paperclip"></i>
                    <asp:HyperLink ID="lnkCurrentFile" runat="server" Target="_blank" />
                </div>
            </div>
            
            <div class="mb-4">
                <label class="form-label">Replace File (optional)</label>
                <div class="file-upload-container">
                    <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" />
                </div>
                <small class="form-text text-muted">Leave blank to keep current file</small>
            </div>
            
            <div class="d-flex justify-content-between">
                <div>
                    <asp:Button ID="btnUpdate" runat="server" Text="Update Assignment" 
                        CssClass="btn btn-update" OnClick="btnUpdate_Click" />
                </div>
                <div>
                    <asp:Button ID="btnDelete" runat="server" Text="Delete Assignment" 
                        CssClass="btn btn-delete" OnClick="btnDelete_Click" 
                        OnClientClick="return confirm('Are you sure you want to delete this assignment? This action cannot be undone.');" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>