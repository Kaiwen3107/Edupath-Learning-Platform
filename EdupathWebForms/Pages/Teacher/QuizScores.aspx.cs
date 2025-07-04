using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages.Teacher
{
    public partial class QuizScores : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        int quizId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"].ToString() != "teacher")
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            if (!int.TryParse(Request.QueryString["quizId"], out quizId))
            {
                Response.Redirect("ClassDetailTeacher.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadQuizTitle();
                LoadScores();
            }
        }

        private void LoadQuizTitle()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT Title FROM Quiz WHERE QuizID = @QuizID", conn);
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    lblQuizTitle.Text = result.ToString();
                }
            }
        }

        private void LoadScores()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT u.username AS StudentName, 
                           s.Score, 
                           s.SubmittedAt
                    FROM QuizSubmission s
                    JOIN Users u ON s.StudentID = u.user_id
                    WHERE s.QuizID = @QuizID
                    ORDER BY s.Score DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@QuizID", quizId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvScores.DataSource = dt;
                gvScores.DataBind();
            }
        }
    }
}