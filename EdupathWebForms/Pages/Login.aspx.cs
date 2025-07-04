using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages
{
    public partial class Login : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is already logged in
            if (!IsPostBack && Session["user_id"] != null) //Only redirect on initial page load, not postbacks
            {
                RedirectBasedOnRole();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter both username and password.";
                return; // Stop further processing
            }

            string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // IMPORTANT:  Use parameterized queries to prevent SQL injection
                // Also select the Role column instead of RoleID
                SqlCommand cmd = new SqlCommand("SELECT user_id, username, role FROM Users WHERE username = @Username AND password = @Password", conn);

                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password); // **DANGER: Replace with PASSWORD HASHING!**

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // Authentication successful
                        Session["UserID"] = reader["user_id"].ToString();
                        Session["Username"] = reader["Username"].ToString();
                        Session["Role"] = reader["Role"].ToString(); // Store the Role (string)

                        RedirectBasedOnRole();
                    }
                    else
                    {
                        // Authentication failed
                        lblMessage.Text = "Invalid username or password.";
                    }
                    reader.Close();
                }
                catch (SqlException ex)
                {
                    // You should log the exception details (ex.Message) for debugging.
                    Console.WriteLine("Database Error: " + ex.Message); // Log to a file or event log in production
                    // Handle database errors gracefully.  Log the error!
                    lblMessage.Text = "An error occurred while connecting to the database. Please try again later. " + ex.Message;
                }
                finally
                {
                    if (conn.State == ConnectionState.Open) // Safely close connection.
                    {
                        conn.Close();
                    }
                }
            }
        }

        private void RedirectBasedOnRole()
        {
            // Use the string Role instead of RoleID
            string role = Session["Role"].ToString();
            switch (role.ToLower()) // Convert to lowercase for case-insensitive comparison
            {
                case "admin":
                    Response.Redirect("Admin/AdminDashboard.aspx");
                    break;
                case "teacher":
                    Response.Redirect("Teacher/TeacherDashboard.aspx");
                    break;
                case "student":
                    Response.Redirect("StudentDashboard.aspx");
                    break;
                default:
                    Response.Redirect("~/Default.aspx");
                    break;
            }
        }
    }
}
