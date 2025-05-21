using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages.Admin
{
    public partial class EditTeacher : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        int userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out userId))
            {
                Response.Redirect("TeacherList.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUser();
            }
        }
        private void LoadUser()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT username, email, password  FROM Users WHERE user_id = @UserID AND Role = 'teacher'", conn);
                cmd.Parameters.AddWithValue("@UserID", userId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtUsername.Text = reader["username"].ToString();
                    txtEmail.Text = reader["email"].ToString();
                    txtPassword.Text = reader["password"].ToString();
                }
                else
                {
                    Response.Redirect("StudentList.aspx");
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("UPDATE Users SET username = @Username, email = @Email, password = @Password WHERE user_id = @UserID", conn);
                cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim());
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("TeacherList.aspx");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();
                try
                {
                    // First delete all dependencies in correct order

                    // 1. Delete all Submissions for Assignments in teacher's classes
                    var cmdDeleteSubmissions = new SqlCommand(@"
                DELETE FROM Submission 
                WHERE AssignmentID IN (
                    SELECT AssignmentID 
                    FROM Assignment 
                    WHERE ClassID IN (SELECT ClassID FROM Class WHERE TeacherID = @UserID)
                )", conn, transaction);
                    cmdDeleteSubmissions.Parameters.AddWithValue("@UserID", userId);
                    cmdDeleteSubmissions.ExecuteNonQuery();

                    // 2. Delete all Assignments in teacher's classes
                    var cmdDeleteAssignments = new SqlCommand(@"
                DELETE FROM Assignment 
                WHERE ClassID IN (SELECT ClassID FROM Class WHERE TeacherID = @UserID)",
                        conn, transaction);
                    cmdDeleteAssignments.Parameters.AddWithValue("@UserID", userId);
                    cmdDeleteAssignments.ExecuteNonQuery();

                    // 3. Delete all QuizSubmissions for teacher's classes
                    var cmdDeleteQuizSubmissions = new SqlCommand(@"
                DELETE FROM QuizSubmission 
                WHERE QuizID IN (
                    SELECT QuizID 
                    FROM Quiz 
                    WHERE ClassID IN (SELECT ClassID FROM Class WHERE TeacherID = @UserID)
                )", conn, transaction);
                    cmdDeleteQuizSubmissions.Parameters.AddWithValue("@UserID", userId);
                    cmdDeleteQuizSubmissions.ExecuteNonQuery();

                    // 4. Delete all Questions for teacher's classes
                    var cmdDeleteQuestions = new SqlCommand(@"
                DELETE FROM Question 
                WHERE QuizID IN (
                    SELECT QuizID 
                    FROM Quiz 
                    WHERE ClassID IN (SELECT ClassID FROM Class WHERE TeacherID = @UserID)
                )", conn, transaction);
                    cmdDeleteQuestions.Parameters.AddWithValue("@UserID", userId);
                    cmdDeleteQuestions.ExecuteNonQuery();

                    // 5. Delete all Quizzes in teacher's classes
                    var cmdDeleteQuizzes = new SqlCommand(@"
                DELETE FROM Quiz 
                WHERE ClassID IN (SELECT ClassID FROM Class WHERE TeacherID = @UserID)",
                        conn, transaction);
                    cmdDeleteQuizzes.Parameters.AddWithValue("@UserID", userId);
                    cmdDeleteQuizzes.ExecuteNonQuery();

                    // 6. Delete all Content in teacher's classes
                    var cmdDeleteContent = new SqlCommand(@"
                DELETE FROM Content 
                WHERE ClassID IN (SELECT ClassID FROM Class WHERE TeacherID = @UserID)",
                        conn, transaction);
                    cmdDeleteContent.Parameters.AddWithValue("@UserID", userId);
                    cmdDeleteContent.ExecuteNonQuery();

                    // 7. Delete all Discussions in teacher's classes
                    var cmdDeleteClassDiscussions = new SqlCommand(@"
                DELETE FROM Discussion 
                WHERE ClassID IN (SELECT ClassID FROM Class WHERE TeacherID = @UserID)",
                        conn, transaction);
                    cmdDeleteClassDiscussions.Parameters.AddWithValue("@UserID", userId);
                    cmdDeleteClassDiscussions.ExecuteNonQuery();

                    // 8. Delete personal discussions by the teacher
                    var cmdDeleteTeacherDiscussions = new SqlCommand(@"
                DELETE FROM Discussion 
                WHERE UserID = @UserID",
                        conn, transaction);
                    cmdDeleteTeacherDiscussions.Parameters.AddWithValue("@UserID", userId);
                    cmdDeleteTeacherDiscussions.ExecuteNonQuery();

                    // 9. Delete all Enrollments for teacher's classes
                    var cmdDeleteEnrollments = new SqlCommand(@"
                DELETE FROM Enrollment 
                WHERE ClassID IN (SELECT ClassID FROM Class WHERE TeacherID = @UserID)",
                        conn, transaction);
                    cmdDeleteEnrollments.Parameters.AddWithValue("@UserID", userId);
                    cmdDeleteEnrollments.ExecuteNonQuery();

                    // 10. Delete all Classes taught by the teacher
                    var cmdDeleteClasses = new SqlCommand(@"
                DELETE FROM Class 
                WHERE TeacherID = @UserID",
                        conn, transaction);
                    cmdDeleteClasses.Parameters.AddWithValue("@UserID", userId);
                    cmdDeleteClasses.ExecuteNonQuery();

                    // 11. Finally delete the teacher
                    var cmdDeleteTeacher = new SqlCommand(@"
                DELETE FROM Users 
                WHERE user_id = @UserID AND Role = 'teacher'",
                        conn, transaction);
                    cmdDeleteTeacher.Parameters.AddWithValue("@UserID", userId);
                    cmdDeleteTeacher.ExecuteNonQuery();

                    transaction.Commit();
                    Response.Write("<script>alert('✅ Teacher deleted successfully!');</script>");
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    Response.Write("<script>alert('❌ Delete failed: " + ex.Message.Replace("'", "\\'") + "');</script>");
                    return;
                }
            }
            // Redirect outside the using block
            Response.Redirect("TeacherList.aspx");
        }
    }
}