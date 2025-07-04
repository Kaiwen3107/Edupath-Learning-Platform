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
    public partial class EditStudent : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        int userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out userId))
            {
                Response.Redirect("StudentList.aspx");
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
                SqlCommand cmd = new SqlCommand("SELECT username, email, password  FROM Users WHERE user_id = @UserID AND Role = 'student'", conn);
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

            Response.Redirect("StudentList.aspx");
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
                    var cmd1 = new SqlCommand("DELETE FROM Submission WHERE StudentID = @UserID", conn, transaction);
                    cmd1.Parameters.AddWithValue("@UserID", userId);
                    cmd1.ExecuteNonQuery();

                    // 删除 QuizSubmission
                    var cmd2 = new SqlCommand("DELETE FROM QuizSubmission WHERE StudentID = @UserID", conn, transaction);
                    cmd2.Parameters.AddWithValue("@UserID", userId);
                    cmd2.ExecuteNonQuery();

                    // 删除 Enrollment
                    var cmd3 = new SqlCommand("DELETE FROM Enrollment WHERE StudentID = @UserID", conn, transaction);
                    cmd3.Parameters.AddWithValue("@UserID", userId);
                    cmd3.ExecuteNonQuery();

                    // 删除 Discussion
                    var cmd4 = new SqlCommand("DELETE FROM Discussion WHERE UserID = @UserID", conn, transaction);
                    cmd4.Parameters.AddWithValue("@UserID", userId);
                    cmd4.ExecuteNonQuery();

                    // 最后删除用户
                    var cmd5 = new SqlCommand("DELETE FROM Users WHERE user_id = @UserID AND Role = 'student'", conn, transaction);
                    cmd5.Parameters.AddWithValue("@UserID", userId);
                    cmd5.ExecuteNonQuery();

                    transaction.Commit();
                    Response.Write("<script>alert('✅ Student deleted successfully!');</script>");
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    Response.Write("<script>alert('❌ Delete failed: " + ex.Message.Replace("'", "\\'") + "');</script>");
                    return;
                }
            }

            
            Response.Redirect("StudentList.aspx");

        }

    }
}