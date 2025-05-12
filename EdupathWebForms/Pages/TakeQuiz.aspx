<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TakeQuiz.aspx.cs" Inherits="EdupathWebForms.Pages.TakeQuiz" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Take Quiz</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container py-5">
            <h2><asp:Label ID="lblQuizTitle" runat="server" /></h2>
            <p><asp:Label ID="lblQuizDescription" runat="server" /></p>

            <asp:Repeater ID="rptQuestions" runat="server" OnItemDataBound="rptQuestions_ItemDataBound">
                <ItemTemplate>
                    <div class="mb-4">
                        <h5>Q<%# Container.ItemIndex + 1 %>: <%# Eval("QuestionText") %></h5>
                        <asp:RadioButtonList ID="rblOptions" runat="server" RepeatDirection="Vertical" />
                        <asp:HiddenField ID="hfQuestionID" runat="server" Value='<%# Eval("QuestionID") %>' />
                        <asp:HiddenField ID="hfCorrectOption" runat="server" Value='<%# Eval("CorrectOption") %>' />
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Button ID="btnSubmitQuiz" runat="server" Text="Submit Quiz" CssClass="btn btn-success" OnClick="btnSubmitQuiz_Click" />
            <asp:Label ID="lblResult" runat="server" CssClass="d-block mt-3 fs-5 fw-bold"></asp:Label>
        </div>
    </form>
</body>
</html>
