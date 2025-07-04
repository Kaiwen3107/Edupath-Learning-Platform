using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace EdupathWebForms.Pages
{
    public partial class TakeQuiz : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        int quizId;
        protected int total = 0;
        protected int score = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"].ToString() != "student")
                Response.Redirect("Login.aspx");

            if (!int.TryParse(Request.QueryString["quizId"], out quizId))
                Response.Redirect("StudentDashboard.aspx");

            if (!IsPostBack)
            {
                LoadQuizInfo();
                LoadQuestions();
            }
        }

        private void LoadQuizInfo()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT Title, Description, ClassID FROM Quiz WHERE QuizID = @QuizID", conn);
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblQuizTitle.Text = reader["Title"].ToString();
                    lblQuizDescription.Text = reader["Description"].ToString();
                    ViewState["ClassID"] = reader["ClassID"].ToString();
                }
            }
        }

        private void LoadQuestions()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT QuestionID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption FROM Question WHERE QuizID = @QuizID", conn);
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptQuestions.DataSource = dt;
                rptQuestions.DataBind();
            }
        }

        protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                RadioButtonList rbl = (RadioButtonList)e.Item.FindControl("rblOptions");
                rbl.Items.Add(new ListItem(row["OptionA"].ToString(), "A"));
                rbl.Items.Add(new ListItem(row["OptionB"].ToString(), "B"));
                rbl.Items.Add(new ListItem(row["OptionC"].ToString(), "C"));
                rbl.Items.Add(new ListItem(row["OptionD"].ToString(), "D"));
            }
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            score = 0;
            total = 0;
            bool allAnswered = true;

            foreach (RepeaterItem item in rptQuestions.Items)
            {
                RadioButtonList rbl = (RadioButtonList)item.FindControl("rblOptions");
                HiddenField hfCorrect = (HiddenField)item.FindControl("hfCorrectOption");

                if (rbl.SelectedItem == null)
                {
                    allAnswered = false;
                    break;
                }

                if (rbl.SelectedValue == hfCorrect.Value)
                    score++;
                total++;
            }

            if (!allAnswered)
            {
                lblResult.Text = "❌ Please answer all questions before submitting.";
                lblResult.CssClass = "text-danger fw-bold";
                return;
            }

            int studentId = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand check = new SqlCommand("SELECT COUNT(*) FROM QuizSubmission WHERE StudentID = @StudentID AND QuizID = @QuizID", conn);
                check.Parameters.AddWithValue("@StudentID", studentId);
                check.Parameters.AddWithValue("@QuizID", quizId);

                int exists = (int)check.ExecuteScalar();

                if (exists == 0)
                {
                    SqlCommand insert = new SqlCommand("INSERT INTO QuizSubmission (QuizID, StudentID, Score, SubmittedAt) VALUES (@QuizID, @StudentID, @Score, GETDATE())", conn);
                    insert.Parameters.AddWithValue("@QuizID", quizId);
                    insert.Parameters.AddWithValue("@StudentID", studentId);
                    insert.Parameters.AddWithValue("@Score", score);
                    insert.ExecuteNonQuery();
                }
                else
                {
                    SqlCommand update = new SqlCommand("UPDATE QuizSubmission SET Score = CASE WHEN Score < @Score THEN @Score ELSE Score END, SubmittedAt = GETDATE() WHERE QuizID = @QuizID AND StudentID = @StudentID", conn);
                    update.Parameters.AddWithValue("@Score", score);
                    update.Parameters.AddWithValue("@QuizID", quizId);
                    update.Parameters.AddWithValue("@StudentID", studentId);
                    update.ExecuteNonQuery();
                }
            }

            lblScoreDisplay.Text = $"{score} / {total}";
            pnlScore.Visible = true;
            btnSubmitQuiz.Visible = false;
        }

        protected void btnReturnToClass_Click(object sender, EventArgs e)
        {
            string classId = ViewState["ClassID"].ToString();
            Response.Redirect("ClassDetail.aspx?id=" + classId);
        }
    }
}
