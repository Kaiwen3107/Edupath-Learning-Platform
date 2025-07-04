using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace EdupathWebForms.Pages.Teacher
{
    public partial class GradeSubmission : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        int submissionId;
        int assignmentId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Authentication check
            if (Session["UserID"] == null || Session["Role"].ToString() != "teacher")
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            // Get submission ID from query string
            if (!int.TryParse(Request.QueryString["submissionId"], out submissionId) ||
                !int.TryParse(Request.QueryString["assignmentId"], out assignmentId))
            {
                Response.Redirect("AssignmentSubmissionList.aspx");
                return;
            }

            hfSubmissionID.Value = submissionId.ToString();
            hfAssignmentID.Value = assignmentId.ToString();

            if (!IsPostBack)
            {
                LoadSubmissionData();
            }
        }

        private void LoadSubmissionData()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT u.username AS StudentName, 
                           s.SubmissionAT AS SubmitAt,
                           s.Grade,
                           s.Feedback
                    FROM Submission s
                    JOIN Users u ON s.StudentID = u.user_id
                    WHERE s.SubmissionID = @SubmissionID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SubmissionID", submissionId);
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        litStudentName.Text = reader["StudentName"].ToString();
                        litSubmitDate.Text = Convert.ToDateTime(reader["SubmitAt"]).ToString("MMM dd, yyyy HH:mm");
                        txtGrade.Text = reader["Grade"] != DBNull.Value ? reader["Grade"].ToString() : "";
                        txtFeedback.Text = reader["Feedback"] != DBNull.Value ? reader["Feedback"].ToString() : "";
                    }
                    else
                    {
                        Response.Redirect($"AssignmentSubmissionList.aspx?assignmentId={assignmentId}");
                    }
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (int.TryParse(txtGrade.Text.Trim(), out int grade) && grade >= 0 && grade <= 100)
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        UPDATE Submission 
                        SET Grade = @Grade, 
                            Feedback = @Feedback,
                            GradedBy = @TeacherID,
                            GradedAt = GETDATE()
                        WHERE SubmissionID = @SubmissionID";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Grade", grade);
                    cmd.Parameters.AddWithValue("@Feedback", txtFeedback.Text);
                    cmd.Parameters.AddWithValue("@TeacherID", Session["UserID"]);
                    cmd.Parameters.AddWithValue("@SubmissionID", submissionId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Redirect back to submissions list
                Response.Redirect($"AssignmentSubmissionList.aspx?assignmentId={assignmentId}");
            }
            else
            {
                // Show error message
                ScriptManager.RegisterStartupScript(this, GetType(), "GradeError",
                    "alert('Please enter a valid grade between 0 and 100');", true);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect($"AssignmentSubmissionList.aspx?assignmentId={assignmentId}");
        }
    }
}