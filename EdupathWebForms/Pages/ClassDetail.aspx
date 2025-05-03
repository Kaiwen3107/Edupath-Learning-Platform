<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClassDetail.aspx.cs" Inherits="EdupathWebForms.Pages.ClassDetail" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Class Detail</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container py-5">
            <!-- 班级基本信息 -->
            <asp:Panel ID="pnlClassInfo" runat="server" CssClass="mb-4">
                <h2><asp:Label ID="lblClassName" runat="server" /></h2>
                <p><asp:Label ID="lblDescription" runat="server" /></p>
                <p><strong>Teacher:</strong> <asp:Label ID="lblTeacher" runat="server" /></p>
            </asp:Panel>

            <!-- 班级内容列表 -->
            <asp:Panel ID="pnlContent" runat="server" CssClass="mb-5">
                <h4>Class Content</h4>
                <asp:Repeater ID="rptContent" runat="server">
                    <ItemTemplate>
                        <div class="card mb-3">
                            <div class="card-body">
                                <h5 class="card-title"><%# Eval("Title") %></h5>
                                <!-- 此处假设 Content 表中的文本字段名为 ContentText -->
                                <p class="card-text"><%# Eval("ContentText") %></p>
                                <!-- 如果有文件链接，可用超链接展示 -->
                                <%# Eval("ContentURL") != null ? "<a href='" + Eval("ContentURL") + "' target='_blank'>Download</a>" : "" %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>

            <!-- 作业列表 -->
            <asp:Panel ID="pnlAssignments" runat="server">
                <h4>Assignments</h4>
<asp:Repeater ID="rptAssignments" runat="server">
    <ItemTemplate>
        <div class="card mb-3">
            <div class="card-body">
                <h5 class="card-title"><%# Eval("Title") %></h5>
                <p class="card-text"><%# Eval("Description") %></p>
                <p><strong>Due Date:</strong> <%# Eval("DueDate", "{0:yyyy-MM-dd}") %></p>

                <!-- 如果有 AssignmentURL，显示下载链接 -->
                <asp:Panel runat="server" Visible='<%# !string.IsNullOrEmpty(Eval("AssignmentURL").ToString()) %>'>
                    <a href='<%# Eval("AssignmentURL") %>' target="_blank" class="btn btn-outline-primary me-2">📎 Download File</a>
                </asp:Panel>

                <!-- 跳转到作业提交页面，传入 AssignmentID 参数 -->
                <a href='<%# "AssignmentSubmission.aspx?assignmentId=" + Eval("AssignmentID") %>' class="btn btn-outline-success">Submit Assignment</a>
            </div>
        </div>
    </ItemTemplate>
</asp:Repeater>

            </asp:Panel>
        </div>
    </form>
</body>
</html>
