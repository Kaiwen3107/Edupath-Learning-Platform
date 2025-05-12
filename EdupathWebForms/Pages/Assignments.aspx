<%@ Page Title="Assignments" Language="C#" MasterPageFile="Site.master" AutoEventWireup="true" CodeBehind="Assignments.aspx.cs" Inherits="EdupathWebForms.Pages.Assignments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- 这里是你的作业列表内容，保持原有 HTML + Repeater 等结构 -->
    <h2 class="mb-4">📋 Assignment Timeline</h2>

    <asp:Repeater ID="rptAssignments" runat="server">
        <ItemTemplate>
            <asp:Literal ID="litDateHeader" runat="server" Text='<%# Eval("DateHeader") %>' />
            <div class="d-flex align-items-start mb-3 border-bottom pb-2">
                <div class="assignment-time text-muted">
                    <%# Convert.ToDateTime(Eval("DueDate")).ToString("HH:mm") %>
                </div>
                <div class="flex-grow-1 ps-3">
                    <div class="fw-bold"><%# Eval("Title") %></div>
                    <div class="text-muted small">Assignment is due · <%# Eval("ClassName") %></div>
                </div>
                <div>
                    <a href='<%# "AssignmentSubmission.aspx?assignmentId=" + Eval("AssignmentID") %>' class="btn btn-outline-primary btn-sm">Add submission</a>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <asp:Label ID="lblNoAssignment" runat="server" CssClass="text-muted fs-5" Visible="false">🎉 No upcoming assignments!</asp:Label>
</asp:Content>
