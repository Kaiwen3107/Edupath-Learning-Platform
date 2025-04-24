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
            if (Session["UserID"] != null)
            {
                RedirectBasedOnRole();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            // In a real application, you would hash the password
            // This is simplified for demonstration
            string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT UserID, Username, RoleID FROM Users WHERE Username = @Username AND Password = @Password ", conn);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password); // Use hashing in real app!

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    // Authentication successful
                    Session["UserID"] = reader["UserID"].ToString();
                    Session["Username"] = reader["Username"].ToString();
                    Session["RoleID"] = reader["RoleID"].ToString();

                    RedirectBasedOnRole();
                }
                else
                {
                    // Authentication failed
                    lblMessage.Text = "Invalid username or password.";
                }
                reader.Close();
            }
        }

        private void RedirectBasedOnRole()
        {
            int roleID = Convert.ToInt32(Session["RoleID"]);
            switch (roleID)
            {
                case 1: // Admin
                    Response.Redirect("~/Admin/Dashboard.aspx");
                    break;
                case 2: // Teacher
                    Response.Redirect("~/Teacher/Dashboard.aspx");
                    break;
                case 3: // Student
                    Response.Redirect("~/Student/Dashboard.aspx");
                    break;
                default:
                    Response.Redirect("~/Default.aspx");
                    break;
            }
        }
    }
}