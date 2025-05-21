using System;
using System.Data.SqlClient;
using System.Configuration;

namespace EdupathWebForms.Pages.Admin
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 检查 Session，只有admin可以访问
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "admin")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            
            if (!IsPostBack)
            {
                LoadCounts();
            }
        }

        private void LoadCounts()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 学生总数
                SqlCommand cmdStudent = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role = 'student'", conn);
                lblStudents.Text = cmdStudent.ExecuteScalar().ToString();

                // 教师总数
                SqlCommand cmdTeacher = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role = 'teacher'", conn);
                lblTeachers.Text = cmdTeacher.ExecuteScalar().ToString();

                // 班级总数
                SqlCommand cmdClass = new SqlCommand("SELECT COUNT(*) FROM Class", conn);
                lblClasses.Text = cmdClass.ExecuteScalar().ToString();
            }
        }
    }
}
