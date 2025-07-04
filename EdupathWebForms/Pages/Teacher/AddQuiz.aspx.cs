using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages.Teacher
{
    public partial class AddQuiz : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        protected int classId;
        protected int quizId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "teacher")
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            if (!int.TryParse(Request.QueryString["classId"], out classId))
            {
                Response.Redirect("MyClasses.aspx");
            }

            if (Session["CurrentQuizID"] != null)
            {
                quizId = Convert.ToInt32(Session["CurrentQuizID"]);
                pnlQuestions.Visible = true;
            }
        }

        protected void btnCreateQuiz_Click(object sender, EventArgs e)
        {
            string title = txtQuizTitle.Text.Trim();
            string description = txtQuizDescription.Text.Trim();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Quiz (ClassID, Title, Description, CreatedAt)
                    OUTPUT INSERTED.QuizID
                    VALUES (@ClassID, @Title, @Description, GETDATE())", conn);

                cmd.Parameters.AddWithValue("@ClassID", classId);
                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@Description", description);

                conn.Open();
                quizId = (int)cmd.ExecuteScalar();
                Session["CurrentQuizID"] = quizId;
            }

            lblStatus.Text = "✅ Quiz created. You may now add questions.";
            pnlQuestions.Visible = true;
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            string question = txtQuestionText.Text.Trim();
            string a = txtOptionA.Text.Trim();
            string b = txtOptionB.Text.Trim();
            string c = txtOptionC.Text.Trim();
            string d = txtOptionD.Text.Trim();
            string correct = ddlCorrectOption.SelectedValue;

            if (Session["CurrentQuizID"] == null)
            {
                lblQuestionStatus.Text = "❌ Please create a quiz first.";
                return;
            }

            int quizId = Convert.ToInt32(Session["CurrentQuizID"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption)
                    VALUES (@QuizID, @Text, @A, @B, @C, @D, @Correct)", conn);

                cmd.Parameters.AddWithValue("@QuizID", quizId);
                cmd.Parameters.AddWithValue("@Text", question);
                cmd.Parameters.AddWithValue("@A", a);
                cmd.Parameters.AddWithValue("@B", b);
                cmd.Parameters.AddWithValue("@C", c);
                cmd.Parameters.AddWithValue("@D", d);
                cmd.Parameters.AddWithValue("@Correct", correct);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblQuestionStatus.Text = "✅ Question added.";
            txtQuestionText.Text = txtOptionA.Text = txtOptionB.Text = txtOptionC.Text = txtOptionD.Text = "";
            ddlCorrectOption.SelectedIndex = 0;
        }
    }
}