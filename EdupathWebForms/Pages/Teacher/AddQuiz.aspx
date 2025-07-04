<%@ Page Title="Add Quiz" Language="C#" MasterPageFile="TeacherSite.master" AutoEventWireup="true" CodeBehind="AddQuiz.aspx.cs" Inherits="EdupathWebForms.Pages.Teacher.AddQuiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>🧪 Add Quiz</h2>

    <div class="card p-4 mb-4">
        <div class="mb-3">
            <label>Quiz Title</label>
            <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="form-control" />
        </div>

        <div class="mb-3">
            <label>Quiz Description</label>
            <asp:TextBox ID="txtQuizDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
        </div>

        <asp:Button ID="btnCreateQuiz" runat="server" Text="Create Quiz" CssClass="btn btn-primary" OnClick="btnCreateQuiz_Click" />
        <asp:Label ID="lblStatus" runat="server" CssClass="text-success d-block mt-3" />
    </div>

    <asp:Panel ID="pnlQuestions" runat="server" Visible="false">
        <h4>Add Questions</h4>

        <div class="mb-3">
            <label>Question Text</label>
            <asp:TextBox ID="txtQuestionText" runat="server" CssClass="form-control" />
        </div>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label>Option A</label>
                <asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control" />
            </div>
            <div class="col-md-6 mb-3">
                <label>Option B</label>
                <asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control" />
            </div>
            <div class="col-md-6 mb-3">
                <label>Option C</label>
                <asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control" />
            </div>
            <div class="col-md-6 mb-3">
                <label>Option D</label>
                <asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control" />
            </div>
        </div>

        <div class="mb-3">
            <label>Correct Answer</label>
            <asp:DropDownList ID="ddlCorrectOption" runat="server" CssClass="form-select">
                <asp:ListItem Text="A" Value="A" />
                <asp:ListItem Text="B" Value="B" />
                <asp:ListItem Text="C" Value="C" />
                <asp:ListItem Text="D" Value="D" />
            </asp:DropDownList>
        </div>

        <asp:Button ID="btnAddQuestion" runat="server" Text="Add Question" CssClass="btn btn-success" OnClick="btnAddQuestion_Click" />
        <asp:Label ID="lblQuestionStatus" runat="server" CssClass="text-success d-block mt-3" />
    </asp:Panel>
</asp:Content>