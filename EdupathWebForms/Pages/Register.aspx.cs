using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EdupathWebForms.Pages
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is already logged in
            if (Session["UserID"] != null)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            try
            {
                string username = txtUsername.Text.Trim();
                string email = txtEmail.Text.Trim();
                string password = txtPassword.Text;
                string role = ddlRole.SelectedValue;

                // Check if username or email already exists
                if (UserExists(username, email))
                {
                    lblMessage.Text = "Username or email already exists. Please try a different one.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // In a real application, you would hash the password
                // This is simplified for demonstration
                string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO Users (Username, Password, Email, Role) VALUES (@Username, @Password, @Email, @Role)", conn);
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Password", password); // Use hashing in real app!
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Role", role);

                    conn.Open();
                    int result = cmd.ExecuteNonQuery();

                    if (result > 0)
                    {
                        lblMessage.Text = "Registration successful! You can now login.";
                        lblMessage.ForeColor = System.Drawing.Color.Green;
                        ClearForm();
                    }
                    else
                    {
                        lblMessage.Text = "Registration failed. Please try again.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "An error occurred: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        private bool UserExists(string username, string email)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Username = @Username OR Email = @Email", conn);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Email", email);

                conn.Open();
                int count = (int)cmd.ExecuteScalar();

                return count > 0;
            }
        }

        private void ClearForm()
        {
            txtUsername.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtPassword.Text = string.Empty;
            txtConfirmPassword.Text = string.Empty;
            ddlRole.SelectedIndex = 0;
        }
    }
}