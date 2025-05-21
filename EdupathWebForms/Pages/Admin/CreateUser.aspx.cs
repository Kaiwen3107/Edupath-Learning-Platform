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
    public partial class CreateUser : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string role = ddlRole.SelectedValue;

            if (password.Length < 6)
            {
                lblStatus.CssClass = "text-danger d-block mt-3";
                lblStatus.Text = "❌ Password must be at least 6 characters.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 检查是否用户名或邮箱已存在
                SqlCommand check = new SqlCommand("SELECT COUNT(*) FROM Users WHERE username = @Username OR email = @Email", conn);
                check.Parameters.AddWithValue("@Username", username);
                check.Parameters.AddWithValue("@Email", email);

                int exists = (int)check.ExecuteScalar();
                if (exists > 0)
                {
                    lblStatus.CssClass = "text-danger d-block mt-3";
                    lblStatus.Text = "❌ Username or email already exists.";
                    return;
                }

                SqlCommand insert = new SqlCommand(@"
                    INSERT INTO Users (username, email, password, role, RegisterAt)
                    VALUES (@Username, @Email, @Password, @Role, GETDATE())", conn);
                insert.Parameters.AddWithValue("@Username", username);
                insert.Parameters.AddWithValue("@Email", email);
                insert.Parameters.AddWithValue("@Password", password); // 明文存储仅限教学演示，请使用哈希！
                insert.Parameters.AddWithValue("@Role", role);

                insert.ExecuteNonQuery();
            }

            lblStatus.CssClass = "text-success d-block mt-3";
            lblStatus.Text = "✅ User created successfully.";
            txtUsername.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
        }
    }
}