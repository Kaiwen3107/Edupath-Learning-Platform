using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages
{
    public partial class TakeQuiz : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        int quizId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "student")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!int.TryParse(Request.QueryString["quizId"], out quizId))
            {
                Response.Redirect("StudentDashboard.aspx");
                return;
            }

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
                SqlCommand cmd = new SqlCommand("SELECT Title, Description FROM Quiz WHERE QuizID = @QuizID", conn);
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblQuizTitle.Text = reader["Title"].ToString();
                    lblQuizDescription.Text = reader["Description"].ToString();
                }
                reader.Close();
            }
        }

        private void LoadQuestions()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT QuestionID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption
                    FROM Question WHERE QuizID = @QuizID", conn);
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
                var rbl = (RadioButtonList)e.Item.FindControl("rblOptions");

                if (rbl != null)
                {
                    rbl.Items.Clear();
                    rbl.Items.Add(new ListItem(row["OptionA"].ToString(), "A"));
                    rbl.Items.Add(new ListItem(row["OptionB"].ToString(), "B"));
                    rbl.Items.Add(new ListItem(row["OptionC"].ToString(), "C"));
                    rbl.Items.Add(new ListItem(row["OptionD"].ToString(), "D"));
                }
            }
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            int correctCount = 0;
            int totalQuestions = rptQuestions.Items.Count;

            foreach (RepeaterItem item in rptQuestions.Items)
            {
                var rbl = (RadioButtonList)item.FindControl("rblOptions");
                var hfCorrect = (HiddenField)item.FindControl("hfCorrectOption");

                if (rbl != null && hfCorrect != null && rbl.SelectedValue != "")
                {
                    if (rbl.SelectedValue == hfCorrect.Value)
                    {
                        correctCount++;
                    }
                }
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 检查是否已有提交记录
                SqlCommand check = new SqlCommand(@"
                    SELECT Score, AttemptHistory FROM QuizSubmission
                    WHERE QuizID = @QuizID AND StudentID = @StudentID", conn);
                check.Parameters.AddWithValue("@QuizID", quizId);
                check.Parameters.AddWithValue("@StudentID", userId);

                SqlDataReader reader = check.ExecuteReader();
                bool hasRecord = reader.Read();
                int previousScore = hasRecord ? Convert.ToInt32(reader["Score"]) : 0;
                int previousAttempts = hasRecord ? Convert.ToInt32(reader["AttemptHistory"]) : 0;
                reader.Close();

                if (hasRecord)
                {
                    int bestScore = Math.Max(previousScore, correctCount);
                    SqlCommand update = new SqlCommand(@"
                        UPDATE QuizSubmission
                        SET Score = @Score, AttemptHistory = @AttemptHistory, SubmittedAt = GETDATE()
                        WHERE QuizID = @QuizID AND StudentID = @StudentID", conn);
                    update.Parameters.AddWithValue("@Score", bestScore);
                    update.Parameters.AddWithValue("@AttemptHistory", previousAttempts + 1);
                    update.Parameters.AddWithValue("@QuizID", quizId);
                    update.Parameters.AddWithValue("@StudentID", userId);
                    update.ExecuteNonQuery();
                }
                else
                {
                    SqlCommand insert = new SqlCommand(@"
                        INSERT INTO QuizSubmission (QuizID, StudentID, Score, AttemptHistory)
                        VALUES (@QuizID, @StudentID, @Score, 1)", conn);
                    insert.Parameters.AddWithValue("@QuizID", quizId);
                    insert.Parameters.AddWithValue("@StudentID", userId);
                    insert.Parameters.AddWithValue("@Score", correctCount);
                    insert.ExecuteNonQuery();
                }
            }

            lblResult.CssClass += " text-success";
            lblResult.Text = $"✅ You scored {correctCount} out of {totalQuestions}!";

            btnSubmitQuiz.Enabled = false;
        }
    }
}
