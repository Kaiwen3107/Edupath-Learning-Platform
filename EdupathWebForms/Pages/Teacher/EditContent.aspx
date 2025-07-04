<%@ Page Title="Edit Content" Language="C#" MasterPageFile="TeacherSite.master" AutoEventWireup="true" CodeBehind="EditContent.aspx.cs" Inherits="EdupathWebForms.Pages.Teacher.EditContent" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --danger-color: #e74c3c;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
        }
        
        .edit-content-container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .edit-content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .edit-content-header h2 {
            color: var(--dark-gray);
            font-weight: 600;
            margin-bottom: 0;
        }
        
        .btn-back {
            background-color: var(--light-gray);
            color: var(--dark-gray);
            border: 1px solid #ddd;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .btn-back:hover {
            background-color: #e9ecef;
            text-decoration: none;
        }
        
        .content-card {
            border: none;
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
        
        .file-upload-container {
            border: 2px dashed #ddd;
            border-radius: 6px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s;
        }
        
        .file-upload-container:hover {
            border-color: var(--primary-color);
            background-color: rgba(52, 152, 219, 0.05);
        }
        
        .current-file {
            display: inline-block;
            padding: 0.5rem 1rem;
            background-color: var(--light-gray);
            border-radius: 4px;
            margin-top: 0.5rem;
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

    <div class="edit-content-container">
        <div class="edit-content-header">
            <h2>✏️ Edit Class Content</h2>
            <a href='<%# "ClassDetailTeacher.aspx?classId=" + Request.QueryString["classId"] %>' class="btn-back">
                <i class="fas fa-arrow-left me-1"></i> Back to Class
            </a>
        </div>
        
        <asp:Label ID="lblStatus" runat="server" CssClass="status-message d-block"  />
        
        <div class="content-card">
            <div class="mb-4">
                <label class="form-label">Title</label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Enter content title" />
                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" 
                    ControlToValidate="txtTitle" 
                    ErrorMessage="Title is required" 
                    Display="Dynamic" 
                    CssClass="text-danger" />
            </div>
            
            <div class="mb-4">
                <label class="form-label">Description</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" 
                    TextMode="MultiLine" Rows="4" placeholder="Enter content description" />
                <asp:RequiredFieldValidator ID="rfvDescription" runat="server" 
                    ControlToValidate="txtDescription" 
                    ErrorMessage="Description is required" 
                    Display="Dynamic" 
                    CssClass="text-danger" />
            </div>
            
            <div class="mb-4">
                <label class="form-label">Current File</label>
                <div class="current-file">
                    <i class="fas fa-file me-2"></i>
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
                    <asp:Button ID="btnUpdate" runat="server" Text="Update Content" 
                        CssClass="btn btn-update" OnClick="btnUpdate_Click" />
                </div>
                <div>
                    <asp:Button ID="btnDelete" runat="server" Text="Delete Content" 
                        CssClass="btn btn-delete" OnClick="btnDelete_Click" 
                        OnClientClick="return confirm('Are you sure you want to delete this content?');" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>