<%@ Page Title="Assignment Submissions" Language="C#" MasterPageFile="TeacherSite.master" 
    AutoEventWireup="true" CodeBehind="AssignmentSubmissionList.aspx.cs" 
    Inherits="EdupathWebForms.Pages.Teacher.AssignmentSubmissionList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid py-4">
        <!-- Header Section -->
        <div class="card mb-4">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">Assignment Submissions</h4>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h5><asp:Label ID="lblAssignmentTitle" runat="server" /></h5>
                    </div>
                    <div class="col-md-6">
                        <div class="stats-container float-md-end">
                            <div class="stat-item">
                                <span class="stat-value" id="totalSubmissions" runat="server">0</span>
                                <span class="stat-label">Total</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value text-success" id="gradedSubmissions" runat="server">0</span>
                                <span class="stat-label">Graded</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-value text-warning" id="pendingSubmissions" runat="server">0</span>
                                <span class="stat-label">Pending</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Submission Table -->
        <div class="card">
            <div class="card-header bg-white">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h5 class="mb-0">Student Submissions</h5>
                    </div>
                    <div class="col-md-6">
                        <div class="input-group">
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" 
                                placeholder="Search students..." />
                            <asp:Button ID="btnSearch" runat="server" Text="Search" 
                                CssClass="btn btn-outline-secondary" OnClick="btnSearch_Click" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <asp:GridView ID="gvSubmissions" runat="server" AutoGenerateColumns="False" 
                        CssClass="table table-hover align-middle mb-0" DataKeyNames="SubmissionID" 
                        GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="StudentName" HeaderText="Student" 
                                HeaderStyle-CssClass="bg-light" />
                            <asp:TemplateField HeaderText="Status" HeaderStyle-CssClass="bg-light">
                                <ItemTemplate>
                                    <span class='badge <%# GetStatusBadgeClass(Eval("Status")) %>'>
                                        <%# Eval("Status") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="SubmitAt" HeaderText="Submitted" 
                                DataFormatString="{0:MMM dd, yyyy HH:mm}" HeaderStyle-CssClass="bg-light" />
                            <asp:TemplateField HeaderText="Grade" HeaderStyle-CssClass="bg-light">
                                <ItemTemplate>
                                    <%# GetGradeDisplay(Eval("Grade")) %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions" HeaderStyle-CssClass="bg-light text-end" 
                                ItemStyle-CssClass="text-end">
                                <ItemTemplate>
                                    <div class="btn-group" role="group">
                                        <a href='<%# Eval("SubmissionURL") %>' target="_blank" class="btn btn-sm btn-outline-primary"
                                            title="View Submission">
                                            <i class="fas fa-eye"></i> View
                                        </a>
                                        <asp:HyperLink ID="btnGrade" runat="server" 
                                            NavigateUrl='<%# $"GradeSubmission.aspx?submissionId={Eval("SubmissionID")}&assignmentId={assignmentId}" %>'
                                            CssClass="btn btn-sm btn-outline-success"
                                            ToolTip="Grade Submission">
                                            <i class="fas fa-edit"></i> Grade
                                        </asp:HyperLink>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="text-center py-5">
                                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                <h5>No Submissions Yet</h5>
                                <p class="text-muted">Students haven't submitted any work for this assignment</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
            <div class="card-footer bg-white">
                <div class="row">
                    <div class="col-md-6">
                        <span class="text-muted">
                            Showing <asp:Literal ID="litShowingCount" runat="server" /> of 
                            <asp:Literal ID="litTotalCount" runat="server" /> submissions
                        </span>
                    </div>
                    <div class="col-md-6">
                        <nav aria-label="Page navigation" class="float-md-end">
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" tabindex="-1">Previous</a>
                                </li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item">
                                    <a class="page-link" href="#">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style type="text/css">
        .stats-container {
            display: flex;
            gap: 15px;
        }
        .stat-item {
            text-align: center;
            padding: 8px 15px;
            background: #f8f9fa;
            border-radius: 6px;
            min-width: 80px;
        }
        .stat-value {
            font-size: 1.25rem;
            font-weight: 700;
            display: block;
        }
        .stat-label {
            color: #6c757d;
            font-size: 0.8rem;
            text-transform: uppercase;
        }
        .badge {
            padding: 5px 10px;
            font-weight: 500;
        }
        .badge-submitted {
            background-color: #0dcaf0;
            color: white;
        }
        .badge-graded {
            background-color: #198754;
            color: white;
        }
        .badge-pending {
            background-color: #ffc107;
            color: black;
        }
        .table-hover tbody tr:hover {
            background-color: rgba(13, 110, 253, 0.05);
        }
        .btn-group .btn {
            margin-right: 5px;
        }
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
    </style>
</asp:Content>