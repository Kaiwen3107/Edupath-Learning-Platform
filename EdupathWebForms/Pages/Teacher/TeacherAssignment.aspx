<%@ Page Title="Assignments" Language="C#" MasterPageFile="TeacherSite.master" AutoEventWireup="true" CodeBehind="TeacherAssignment.aspx.cs" Inherits="EdupathWebForms.Pages.Teacher.TeacherAssignment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>📝 My Assignments</h2>

    <asp:Repeater ID="rptAssignments" runat="server">
        <ItemTemplate>
            <div class="card mb-3">
                <div class="card-body">
                    <h5 class="card-title"><%# Eval("Title") %> (<%# Eval("ClassName") %>)</h5>
                    <p><%# Eval("Description") %></p>
                    <p><strong>Due:</strong> <%# Eval("DueDate", "{0:yyyy-MM-dd HH:mm}") %></p>
                    <a href='<%# "AssignmentSubmissionList.aspx?assignmentId=" + Eval("AssignmentID") %>' class="btn btn-sm btn-outline-primary">View Submissions</a>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</asp:Content>
