<%@ Page Title="Grade Submission" Language="C#" MasterPageFile="TeacherSite.master" 
    AutoEventWireup="true" CodeBehind="GradeSubmission.aspx.cs" 
    Inherits="EdupathWebForms.Pages.Teacher.GradeSubmission" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --accent-color: #f39c12;
            --danger-color: #e74c3c;
            --light-gray: #f8f9fa;
            --dark-gray: #343a40;
        }
        
        .grading-container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .grading-header {
            background-color: var(--primary-color);
            color: white;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .grading-header h4 {
            margin-bottom: 0;
            font-weight: 600;
        }
        
        .grading-card {
            border: none;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .grading-body {
            padding: 2rem;
        }
        
        .student-info {
            background-color: var(--light-gray);
            border-radius: 6px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .student-info-label {
            font-weight: 500;
            color: var(--dark-gray);
        }
        
        .student-info-value {
            font-weight: 600;
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
        }
        
        .grade-preview-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 0.5rem;
        }
        
        .grade-badge {
            font-size: 0.9rem;
            font-weight: 600;
            padding: 0.35rem 0.75rem;
            border-radius: 1rem;
        }
        
        .grade-legend {
            font-size: 0.8rem;
            color: #6c757d;
        }
        
        .btn-action {
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            border-radius: 6px;
            transition: all 0.3s;
        }
        
        .btn-submit {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }
        
        .btn-submit:hover {
            background-color: #28a745;
            transform: translateY(-2px);
        }
        
        .btn-cancel {
            background-color: var(--light-gray);
            color: var(--dark-gray);
            border: 1px solid #ddd;
        }
        
        .btn-cancel:hover {
            background-color: #e9ecef;
        }
        
        .rubric-container {
            margin-top: 1.5rem;
            border: 1px solid #eee;
            border-radius: 6px;
            padding: 1rem;
        }
        
        .rubric-title {
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--dark-gray);
        }
        
        .rubric-item {
            margin-bottom: 0.5rem;
        }
    </style>

    <div class="grading-container">
        <div class="grading-card">
            <div class="grading-header">
                <h4><i class="fas fa-graduation-cap me-2"></i>Grade Submission</h4>
            </div>
            <div class="grading-body">
                <asp:HiddenField ID="hfSubmissionID" runat="server" />
                <asp:HiddenField ID="hfAssignmentID" runat="server" />
                
                <!-- Student Information -->
                <div class="student-info">
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <span class="student-info-label">Student:</span>
                            <span class="student-info-value"><asp:Literal ID="litStudentName" runat="server" /></span>
                        </div>
                        <div class="col-md-6">
                            <span class="student-info-label">Submitted:</span>
                            <span class="student-info-value"><asp:Literal ID="litSubmitDate" runat="server" /></span>
                        </div>
                    </div>
                </div>
                
                <!-- Grade Input -->
                <div class="mb-4">
                    <label class="form-label">Grade (0-100)</label>
                    <asp:TextBox ID="txtGrade" runat="server" CssClass="form-control" 
                        TextMode="Number" min="0" max="100" required="required" />
                    <div class="grade-preview-container">
                        <small class="grade-legend">A: 90-100 | B: 70-89 | C: 50-69 | F: Below 50</small>
                        <span class="badge grade-badge bg-secondary" id="gradeBadge">-</span>
                    </div>
                </div>
                
                <!-- Feedback -->
                <div class="mb-4">
                    <label class="form-label">Feedback</label>
                    <asp:TextBox ID="txtFeedback" runat="server" CssClass="form-control" 
                        TextMode="MultiLine" Rows="5" placeholder="Provide constructive feedback..." />
                </div>
                
                <!-- Optional Rubric Section -->
                <div class="rubric-container">
                    <div class="rubric-title">
                        <i class="fas fa-clipboard-list me-2"></i>Grading Rubric
                    </div>
                    <div class="rubric-item">
                        <strong>90-100 (A):</strong> Excellent work, exceeds expectations
                    </div>
                    <div class="rubric-item">
                        <strong>70-89 (B):</strong> Good work, meets all requirements
                    </div>
                    <div class="rubric-item">
                        <strong>50-69 (C):</strong> Satisfactory, needs improvement
                    </div>
                    <div class="rubric-item">
                        <strong>Below 50 (F):</strong> Incomplete or unsatisfactory
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="d-flex justify-content-between mt-4">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                        CssClass="btn btn-cancel btn-action" OnClick="btnCancel_Click" />
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Grade" 
                        CssClass="btn btn-submit btn-action" OnClick="btnSubmit_Click" />
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#<%= txtGrade.ClientID %>').on('input', function () {
                var grade = $(this).val();
                var badge = $('#gradeBadge');

                if (grade === '' || isNaN(grade)) {
                    badge.text('-').removeClass().addClass('badge bg-secondary');
                    return;
                }

                badge.text(grade);

                if (grade >= 90) {
                    badge.removeClass().addClass('badge bg-success');
                } else if (grade >= 70) {
                    badge.removeClass().addClass('badge bg-primary');
                } else if (grade >= 50) {
                    badge.removeClass().addClass('badge bg-warning');
                } else {
                    badge.removeClass().addClass('badge bg-danger');
                }
            });
        });
    </script>
</asp:Content>