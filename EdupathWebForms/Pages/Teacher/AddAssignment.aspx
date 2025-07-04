<%@ Page Title="Add Assignment" Language="C#" MasterPageFile="TeacherSite.master" AutoEventWireup="true" CodeBehind="AddAssignment.aspx.cs" Inherits="EdupathWebForms.Pages.Teacher.AddAssignment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --accent-color: #f39c12;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
        }
        
        .assignment-container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .assignment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .assignment-header h2 {
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
        
        .assignment-card {
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
            text-align: center;
            margin-bottom: 1rem;
            transition: all 0.3s;
        }
        
        .file-upload-container:hover {
            border-color: var(--primary-color);
            background-color: rgba(52, 152, 219, 0.05);
        }
        
        .btn-submit {
            background-color: var(--secondary-color);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-submit:hover {
            background-color: #28a745;
            transform: translateY(-2px);
        }
        
        .status-message {
            padding: 0.75rem 1rem;
            border-radius: 6px;
            margin-top: 1rem;
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
        
        .text-muted {
            font-size: 0.875rem;
        }
        
        .datetime-input {
            max-width: 300px;
        }
    </style>

    <div class="assignment-container">
        <div class="assignment-header">
            <h2>📝 Add Assignment</h2>
            <a href='<%# "ClassDetailTeacher.aspx?classId=" + Request.QueryString["classId"] %>' class="btn-back">
                <i class="fas fa-arrow-left me-1"></i> Back to Class
            </a>
        </div>
        
        <div class="assignment-card">
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
                <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-control datetime-input" TextMode="DateTimeLocal" />
                <asp:RequiredFieldValidator ID="rfvDueDate" runat="server" 
                    ControlToValidate="txtDueDate" 
                    ErrorMessage="Due date is required" 
                    Display="Dynamic" 
                    CssClass="text-danger" />
                <asp:CustomValidator ID="cvDueDate" runat="server"
                    ControlToValidate="txtDueDate"
                    ErrorMessage="Due date must be in the future"
                    Display="Dynamic"
                    CssClass="text-danger"
                    ClientValidationFunction="ValidateDueDate" />
            </div>
            
            <div class="mb-4">
                <label class="form-label">Attachment (Optional)</label>
                <div class="file-upload-container">
                    <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control" />
                </div>
                <asp:CustomValidator ID="cvFileUpload" runat="server"
                    ControlToValidate="fileUpload"
                    ErrorMessage="Please upload a valid file type"
                    Display="Dynamic"
                    CssClass="text-danger"
                    ClientValidationFunction="ValidateFileUpload"
                    ValidateEmptyText="false" />
                <small class="form-text text-muted">Supported file formats: PDF, DOC, DOCX, PPT, PPTX, XLS, XLSX, ZIP</small>
            </div>
            
            <asp:Button ID="btnSubmit" runat="server" Text="Create Assignment" 
                CssClass="btn btn-submit" OnClick="btnSubmit_Click" />
            <asp:Label ID="lblStatus" runat="server" CssClass="status-message d-block mt-3" />
        </div>
    </div>

    <script type="text/javascript">
        function ValidateDueDate(source, args) {
            var inputDate = new Date(args.Value);
            var currentDate = new Date();
            
            // Clear time portion for date comparison
            currentDate.setHours(0, 0, 0, 0);
            
            args.IsValid = inputDate > currentDate;
        }
        
        function ValidateFileUpload(source, args) {
            var fileUpload = document.getElementById('<%= fileUpload.ClientID %>');

            // Skip validation if no file selected (attachment is optional)
            if (fileUpload.files.length === 0) {
                args.IsValid = true;
                return;
            }

            var fileName = fileUpload.value;
            var extension = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
            var allowedExtensions = ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'zip'];

            args.IsValid = allowedExtensions.indexOf(extension) !== -1;
        }
    </script>
</asp:Content>