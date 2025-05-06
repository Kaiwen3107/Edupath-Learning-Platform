<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AssignmentSubmission.aspx.cs" Inherits="EdupathWebForms.Pages.AssignmentSubmission" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Assignment Submission</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container py-5">
            <h2>Submit Assignment</h2>
            <asp:Panel ID="pnlAssignmentInfo" runat="server" CssClass="mb-4">
                <h4><asp:Label ID="lblAssignmentTitle" runat="server" /></h4>
                <p><asp:Label ID="lblAssignmentDesc" runat="server" /></p>
                <p><strong>Due Date:</strong> <asp:Label ID="lblDueDate" runat="server" /></p>
            </asp:Panel>
            <div class="mb-3">
                <asp:FileUpload ID="fileUploadSubmission" runat="server" CssClass="form-control" />
            </div>
            <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
            <asp:Label ID="lblMessage" runat="server" CssClass="text-danger d-block mt-2" />
        </div>
    </form>
</body>
</html>
