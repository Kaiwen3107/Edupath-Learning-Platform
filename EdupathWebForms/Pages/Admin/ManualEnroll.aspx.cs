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
    public partial class ManualEnroll : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStudents();
                LoadClasses();
            }
        }

        private void LoadStudents(string keyword = "")
        {
            ddlStudents.Items.Clear();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT user_id, username FROM Users WHERE role = 'student'";
                if (!string.IsNullOrWhiteSpace(keyword))
                {
                    query += " AND username LIKE @Keyword";
                }

                SqlCommand cmd = new SqlCommand(query, conn);
                if (!string.IsNullOrWhiteSpace(keyword))
                {
                    cmd.Parameters.AddWithValue("@Keyword", "%" + keyword + "%");
                }

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    ddlStudents.Items.Add(new System.Web.UI.WebControls.ListItem(
                        reader["username"].ToString(), reader["user_id"].ToString()));
                }
            }
        }

        private void LoadClasses(string keyword = "")
        {
            ddlClasses.Items.Clear();
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT ClassID, ClassName FROM Class";
                if (!string.IsNullOrWhiteSpace(keyword))
                {
                    query += " WHERE ClassName LIKE @Keyword";
                }

                SqlCommand cmd = new SqlCommand(query, conn);
                if (!string.IsNullOrWhiteSpace(keyword))
                {
                    cmd.Parameters.AddWithValue("@Keyword", "%" + keyword + "%");
                }

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    ddlClasses.Items.Add(new System.Web.UI.WebControls.ListItem(
                        reader["ClassName"].ToString(), reader["ClassID"].ToString()));
                }
            }
        }


        protected void btnEnroll_Click(object sender, EventArgs e)
        {
            int studentId = int.Parse(ddlStudents.SelectedValue);
            int classId = int.Parse(ddlClasses.SelectedValue);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand check = new SqlCommand(@"
                    SELECT COUNT(*) FROM Enrollment
                    WHERE StudentID = @StudentID AND ClassID = @ClassID", conn);
                check.Parameters.AddWithValue("@StudentID", studentId);
                check.Parameters.AddWithValue("@ClassID", classId);
                conn.Open();

                int count = (int)check.ExecuteScalar();
                if (count > 0)
                {
                    lblResult.Text = "⚠ Student already enrolled in this class.";
                    return;
                }

                SqlCommand insert = new SqlCommand(@"
                    INSERT INTO Enrollment (ClassID, StudentID)
                    VALUES (@ClassID, @StudentID)", conn);
                insert.Parameters.AddWithValue("@ClassID", classId);
                insert.Parameters.AddWithValue("@StudentID", studentId);
                insert.ExecuteNonQuery();

                lblResult.Text = "✅ Student enrolled successfully.";
            }
        }
        protected void btnSearchStudent_Click(object sender, EventArgs e)
        {
            LoadStudents(txtSearchStudent.Text.Trim());
        }

        protected void btnSearchClass_Click(object sender, EventArgs e)
        {
            LoadClasses(txtSearchClass.Text.Trim());
        }
    }
}