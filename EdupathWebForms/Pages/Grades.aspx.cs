using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EdupathWebForms.Pages
{
    public partial class Grades : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "student")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAssignmentGrades();
                LoadQuizGrades();
            }
        }

        private void LoadAssignmentGrades()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT a.Title, c.ClassName, s.SubmissionAT, s.Grade
                    FROM Submission s
                    INNER JOIN Assignment a ON s.AssignmentID = a.AssignmentID
                    INNER JOIN Class c ON a.ClassID = c.ClassID
                    WHERE s.StudentID = @StudentID", conn);
                cmd.Parameters.AddWithValue("@StudentID", studentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptAssignments.DataSource = dt;
                rptAssignments.DataBind();
            }
        }

        private void LoadQuizGrades()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT q.Title, c.ClassName, s.Score, s.AttemptHistory, s.SubmittedAt,
                           (SELECT COUNT(*) FROM Question WHERE QuizID = q.QuizID) AS TotalMarks
                    FROM QuizSubmission s
                    INNER JOIN Quiz q ON s.QuizID = q.QuizID
                    INNER JOIN Class c ON q.ClassID = c.ClassID
                    WHERE s.StudentID = @StudentID", conn);
                cmd.Parameters.AddWithValue("@StudentID", studentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptQuizzes.DataSource = dt;
                rptQuizzes.DataBind();
            }
        }
    }
}
