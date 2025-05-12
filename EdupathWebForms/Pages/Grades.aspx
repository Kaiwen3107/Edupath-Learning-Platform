<%@ Page Title="Grades" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeBehind="Grades.aspx.cs" Inherits="EdupathWebForms.Pages.Grades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2 class="mb-4">📊 My Grades</h2>

    <h4>Assignments</h4>
    <asp:Repeater ID="rptAssignments" runat="server">
        <HeaderTemplate>
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Title</th>
                        <th>Course</th>
                        <th>Submitted At</th>
                        <th>Grade</th>
                    </tr>
                </thead>
                <tbody>
        </HeaderTemplate>
        <ItemTemplate>
                    <tr>
                        <td><%# Eval("Title") %></td>
                        <td><%# Eval("ClassName") %></td>
                        <td><%# Eval("SubmissionAT", "{0:yyyy-MM-dd HH:mm}") %></td>
                        <td><%# Eval("Grade") == DBNull.Value ? "Not Graded" : Eval("Grade") + " / 100" %></td>
                    </tr>
        </ItemTemplate>
        <FooterTemplate>
                </tbody>
            </table>
        </FooterTemplate>
    </asp:Repeater>

    <h4 class="mt-5">Quizzes</h4>
    <asp:Repeater ID="rptQuizzes" runat="server">
        <HeaderTemplate>
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Quiz</th>
                        <th>Course</th>
                        <th>Attempt(s)</th>
                        <th>Score</th>
                        <th>Last Submitted</th>
                    </tr>
                </thead>
                <tbody>
        </HeaderTemplate>
        <ItemTemplate>
                    <tr>
                        <td><%# Eval("Title") %></td>
                        <td><%# Eval("ClassName") %></td>
                        <td><%# Eval("AttemptHistory") %></td>
                        <td><%# Eval("Score") + " / " + Eval("TotalMarks") %></td>
                        <td><%# Eval("SubmittedAt", "{0:yyyy-MM-dd HH:mm}") %></td>
                    </tr>
        </ItemTemplate>
        <FooterTemplate>
                </tbody>
            </table>
        </FooterTemplate>
    </asp:Repeater>

</asp:Content>
