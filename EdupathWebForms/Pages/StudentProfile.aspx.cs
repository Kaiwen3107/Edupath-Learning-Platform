using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace EdupathWebForms.Pages
{
    public partial class StudentProfile : System.Web.UI.Page
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
                LoadStudentProfile();
            }
        }

        private void LoadStudentProfile()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT user_id, username, email, role, RegisterAt FROM Users WHERE user_id = @UserID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    lblUserId.Text = reader["user_id"].ToString();
                    txtUsername.Text = reader["username"].ToString();
                    txtEmail.Text = reader["email"].ToString();
                    lblRole.Text = reader["role"].ToString();
                    lblRegisterDate.Text = Convert.ToDateTime(reader["RegisterAt"]).ToString("yyyy-MM-dd HH:mm");

                    // Set avatar initials
                    divAvatar.InnerText = GetInitials(reader["username"].ToString());
                }

                reader.Close();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                ShowStatusMessage("Please correct the form errors", false);
                return;
            }

            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                string currentPassword = txtCurrentPassword.Text.Trim();
                string newPassword = txtNewPassword.Text.Trim();
                string username = txtUsername.Text.Trim();
                string email = txtEmail.Text.Trim();

                // Verify current password if changing password or if password is required for changes
                if (!string.IsNullOrEmpty(newPassword) || !string.IsNullOrEmpty(currentPassword))
                {
                    if (string.IsNullOrEmpty(currentPassword))
                    {
                        ShowStatusMessage("Current password is required to make changes", false);
                        return;
                    }

                    if (!VerifyCurrentPassword(userId, currentPassword))
                    {
                        ShowStatusMessage("Current password is incorrect", false);
                        return;
                    }
                }

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query;
                    SqlCommand cmd;

                    if (!string.IsNullOrEmpty(newPassword))
                    {
                        // Update with password change
                        query = @"UPDATE Users SET username = @Username, email = @Email, 
                                  password = @Password WHERE user_id = @UserID";
                        cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@Password", HashPassword(newPassword));
                    }
                    else
                    {
                        // Update without password change
                        query = "UPDATE Users SET username = @Username, email = @Email WHERE user_id = @UserID";
                        cmd = new SqlCommand(query, conn);
                    }

                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserID", userId);

                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowStatusMessage("Profile updated successfully", true);
                        // Update avatar initials if username changed
                        divAvatar.InnerText = GetInitials(username);
                    }
                    else
                    {
                        ShowStatusMessage("No changes were made", false);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowStatusMessage("Error updating profile: " + ex.Message, false);
            }
        }

        private bool VerifyCurrentPassword(int userId, string currentPassword)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT password FROM Users WHERE user_id = @UserID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);

                conn.Open();
                string storedPassword = cmd.ExecuteScalar()?.ToString();

                // In a real application, you should compare hashed passwords
                return storedPassword == currentPassword;
            }
        }

        private string HashPassword(string password)
        {
            // In a real application, use proper password hashing like BCrypt or ASP.NET Identity
            // This is just a placeholder - NEVER store plain text passwords in production!
            return password;
        }

        private string GetInitials(string username)
        {
            if (string.IsNullOrEmpty(username)) return "";
            string[] parts = username.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 0) return "";
            if (parts.Length == 1) return parts[0][0].ToString();
            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpper();
        }

        private void ShowStatusMessage(string message, bool isSuccess)
        {
            divStatusMessage.Attributes["class"] = isSuccess ? "status-message status-success" : "status-message status-error";
            statusMessageText.InnerText = message;
            divStatusMessage.Style["display"] = "block";

            // Register script to hide message after 5 seconds
            ScriptManager.RegisterStartupScript(this, GetType(), "HideStatusMessage",
                "setTimeout(function() { document.getElementById('" + divStatusMessage.ClientID + "').style.display = 'none'; }, 5000);", true);
        }
    }
}