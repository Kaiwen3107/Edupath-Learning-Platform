<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AssignmentSubmission.aspx.cs" Inherits="EdupathWebForms.Pages.AssignmentSubmission" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Assignment Submission</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server" class="container py-5">
        <h2>📎 Assignment Submission</h2>

        <!-- 状态提示 -->
        <asp:Panel ID="pnlStatus" runat="server" CssClass="alert d-none">
            <asp:Label ID="lblStatus" runat="server" />
        </asp:Panel>

        <!-- 提交状态 -->
        <div class="card my-4">
            <div class="card-header">Submission status</div>
            <div class="card-body">
                <table class="table">
                    <tr>
                        <th>Status</th>
                        <td><asp:Label ID="lblStatusText" runat="server" /></td>
                    </tr>
                    <tr>
                        <th>Grading status</th>
                        <td><asp:Label ID="lblGradeStatus" runat="server" /></td>
                    </tr>
                    <tr>
                        <th>Time remaining</th>
                        <td><asp:Label ID="lblTimeRemaining" runat="server" /></td>
                    </tr>
                    <tr>
                        <th>Last modified</th>
                        <td><asp:Label ID="lblLastModified" runat="server" /></td>
                    </tr>
                </table>

                <!-- 文件查看与删除 -->
                <asp:Panel ID="pnlFile" runat="server" Visible="false" CssClass="mb-3">
                    <asp:HyperLink ID="lnkSubmission" runat="server" CssClass="btn btn-outline-secondary" Target="_blank">🔗 View Uploaded File</asp:HyperLink>
                    <asp:Button ID="btnDelete" runat="server" Text="Remove submission" CssClass="btn btn-danger ms-2" OnClick="btnDelete_Click" />
                </asp:Panel>

                <!-- 文件上传 -->
                <asp:FileUpload ID="fileUpload" runat="server" CssClass="form-control my-3" />
                <asp:Button ID="btnUpload" runat="server" Text="Submit / Update Submission" CssClass="btn btn-primary" OnClick="btnUpload_Click" />
            </div>
        </div>

    </form>
</body>
</html>
