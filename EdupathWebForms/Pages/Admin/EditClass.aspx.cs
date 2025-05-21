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
    public partial class EditClass : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        int classId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out classId))
            {
                Response.Redirect("Class.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadClassDetails();
            }
        }

        private void LoadClassDetails()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT c.ClassID, c.ClassName, c.EnrollmentCode, u.username AS TeacherName
                    FROM Class c
                    LEFT JOIN Users u ON c.TeacherID = u.user_id
                    WHERE c.ClassID = @ClassID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblClassID.Text = reader["ClassID"].ToString();
                    lblClassName.Text = reader["ClassName"].ToString();
                    lblCode.Text = reader["EnrollmentCode"].ToString();
                    lblTeacher.Text = reader["TeacherName"].ToString();
                }
                else
                {
                    lblResult.CssClass = "text-danger";
                    lblResult.Text = "❌ Class not found.";
                }
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // 删除 Submission
                    var cmd1 = new SqlCommand(@"
                        DELETE FROM Submission 
                        WHERE AssignmentID IN (
                            SELECT AssignmentID FROM Assignment WHERE ClassID = @ClassID
                        )", conn, transaction);
                    cmd1.Parameters.AddWithValue("@ClassID", classId);
                    cmd1.ExecuteNonQuery();

                    // 删除 Assignment
                    var cmd2 = new SqlCommand("DELETE FROM Assignment WHERE ClassID = @ClassID", conn, transaction);
                    cmd2.Parameters.AddWithValue("@ClassID", classId);
                    cmd2.ExecuteNonQuery();

                    // 删除 QuizSubmission
                    var cmd3 = new SqlCommand(@"
                        DELETE FROM QuizSubmission 
                        WHERE QuizID IN (
                            SELECT QuizID FROM Quiz WHERE ClassID = @ClassID
                        )", conn, transaction);
                    cmd3.Parameters.AddWithValue("@ClassID", classId);
                    cmd3.ExecuteNonQuery();

                    // 删除 Quiz
                    var cmd4 = new SqlCommand("DELETE FROM Quiz WHERE ClassID = @ClassID", conn, transaction);
                    cmd4.Parameters.AddWithValue("@ClassID", classId);
                    cmd4.ExecuteNonQuery();

                    // 删除 Enrollment
                    var cmd5 = new SqlCommand("DELETE FROM Enrollment WHERE ClassID = @ClassID", conn, transaction);
                    cmd5.Parameters.AddWithValue("@ClassID", classId);
                    cmd5.ExecuteNonQuery();

                    // 删除 Discussion
                    var cmd7 = new SqlCommand("DELETE FROM Discussion WHERE ClassID = @ClassID", conn, transaction);
                    cmd7.Parameters.AddWithValue("@ClassID", classId);
                    cmd7.ExecuteNonQuery();

                    // 删除 Class
                    var cmd6 = new SqlCommand("DELETE FROM Class WHERE ClassID = @ClassID", conn, transaction);
                    cmd6.Parameters.AddWithValue("@ClassID", classId);
                    cmd6.ExecuteNonQuery();

                    transaction.Commit();
                    Response.Redirect("AdminDashboard.aspx");
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    lblResult.CssClass = "text-danger";
                    lblResult.Text = "❌ Failed to delete class: " + ex.Message;
                }
            }
        }
    }
}