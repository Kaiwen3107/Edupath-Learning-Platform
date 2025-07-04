<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TakeQuiz.aspx.cs" Inherits="EdupathWebForms.Pages.TakeQuiz" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Take Quiz</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .question-card {
            background-color: #fdfdfd;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .score-panel {
            border: 2px dashed #17a2b8;
            background-color: #e8f9fd;
        }
        .score-panel h4 {
            color: #117a8b;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container py-5">
            <h2><asp:Label ID="lblQuizTitle" runat="server" /></h2>
            <p><asp:Label ID="lblQuizDescription" runat="server" /></p>

            <asp:Repeater ID="rptQuestions" runat="server" OnItemDataBound="rptQuestions_ItemDataBound">
                <ItemTemplate>
                    <div class="question-card">
                        <h5>Q<%# Container.ItemIndex + 1 %>: <%# Eval("QuestionText") %></h5>
                        <asp:RadioButtonList ID="rblOptions" runat="server" RepeatDirection="Vertical" />
                        <asp:HiddenField ID="hfQuestionID" runat="server" Value='<%# Eval("QuestionID") %>' />
                        <asp:HiddenField ID="hfCorrectOption" runat="server" Value='<%# Eval("CorrectOption") %>' />
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Button ID="btnSubmitQuiz" runat="server" Text="Submit Quiz" CssClass="btn btn-success" OnClick="btnSubmitQuiz_Click" />

            <asp:Panel ID="pnlScore" runat="server" Visible="false" CssClass="alert score-panel mt-4 p-4 text-center">
                <h4>Your Score:</h4>
                <asp:Label ID="lblScoreDisplay" runat="server" CssClass="fs-3 fw-bold text-success" />
                <br />
                <asp:Button ID="btnReturnToClass" runat="server" Text="Return to Class" CssClass="btn btn-outline-primary mt-3" OnClick="btnReturnToClass_Click" />
            </asp:Panel>

            <asp:Label ID="lblResult" runat="server" CssClass="d-block mt-3 fs-5 fw-bold text-danger" />
        </div>
    </form>
</body>
</html>
