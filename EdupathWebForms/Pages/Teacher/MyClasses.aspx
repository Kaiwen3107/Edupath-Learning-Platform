<%@ Page Title="My Classes" Language="C#" MasterPageFile="TeacherSite.master" AutoEventWireup="true" CodeBehind="MyClasses.aspx.cs" Inherits="EdupathWebForms.Pages.Teacher.MyClasses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --accent-color: #f39c12;
            --dark-color: #2c3e50;
            --light-color: #f8f9fa;
        }
        
        .my-classes-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            border-bottom: 2px solid var(--light-color);
            padding-bottom: 1rem;
        }
        
        .page-header h2 {
            color: var(--dark-color);
            font-weight: 700;
            margin-bottom: 0;
        }
        
        /* Create Class Card */
        .create-class-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-bottom: 2.5rem;
            background-color: white;
        }
        
        .create-class-card h4 {
            color: var(--dark-color);
            margin-bottom: 1.5rem;
            font-weight: 600;
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
            transition: all 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        
        .btn-create {
            background-color: var(--secondary-color);
            border: none;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-create:hover {
            background-color: #28a745;
            transform: translateY(-2px);
        }
        
        /* Classes GridView */
        .classes-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 1.5rem;
        }
        
        .classes-table th {
            background-color: var(--primary-color);
            color: white;
            padding: 1rem;
            text-align: left;
            font-weight: 500;
        }
        
        .classes-table td {
            padding: 1rem;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        
        .classes-table tr:nth-child(even) {
            background-color: var(--light-color);
        }
        
        .classes-table tr:hover {
            background-color: rgba(52, 152, 219, 0.05);
        }
        
        .action-btn {
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .action-btn:hover {
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .status-message {
            padding: 0.75rem 1rem;
            border-radius: 6px;
            margin-top: 1rem;
            display: inline-block;
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
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .classes-table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>

    <div class="my-classes-container">
        <div class="page-header">
            <h2>📁 My Classes</h2>
        </div>

        <!-- Create New Class Card -->
        <div class="create-class-card">
            <h4>Create New Class</h4>

            <div class="mb-4">
                <label class="form-label">Class Name</label>
                <asp:TextBox ID="txtClassName" runat="server" CssClass="form-control" placeholder="Enter class name" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtClassName"
                    ErrorMessage="Class name is required" Display="Dynamic" CssClass="text-danger" />
            </div>

            <div class="mb-4">
                <label class="form-label">Description</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" 
                    TextMode="MultiLine" Rows="3" placeholder="Enter class description" />
            </div>

            <asp:Button ID="btnCreateClass" runat="server" Text="Create Class" 
                CssClass="btn btn-create" OnClick="btnCreateClass_Click" />
            <asp:Label ID="lblStatus" runat="server" CssClass="status-message d-block mt-3" />
        </div>

        <!-- My Classes Table -->
        <asp:GridView ID="gvMyClasses" runat="server" AutoGenerateColumns="False" 
            CssClass="classes-table" GridLines="None" DataKeyNames="ClassID">
            <Columns>
                <asp:BoundField DataField="ClassID" HeaderText="ID" ItemStyle-Width="80px" />
                <asp:BoundField DataField="ClassName" HeaderText="Class Name" />
                <asp:BoundField DataField="Description" HeaderText="Description" />
                <asp:BoundField DataField="EnrollmentCode" HeaderText="Enrollment Code" />
                <asp:TemplateField HeaderText="Actions" ItemStyle-Width="120px">
                    <ItemTemplate>
                        <a href='<%# "ClassDetailTeacher.aspx?id=" + Eval("ClassID") %>' 
                            class="action-btn btn btn-sm btn-outline-primary">
                            <i class="fas fa-eye"></i> View
                        </a>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="text-center py-5">
                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                    <h5>No Classes Found</h5>
                    <p class="text-muted">You haven't created any classes yet</p>
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>
</asp:Content>