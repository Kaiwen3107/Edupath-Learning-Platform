using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EdupathWebForms.Pages
{
    public partial class ClassDetail : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 检查 Session，只有学生可以访问
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "student")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int classId;
                if (int.TryParse(Request.QueryString["classId"], out classId))
                {
                    LoadClassDetails(classId);
                    LoadClassContent(classId);
                    LoadAssignments(classId);
                    LoadQuizzes(classId);
                }
                else
                {
                    Response.Redirect("StudentDashboard.aspx"); // 若 classId 不合法则返回仪表板
                }
            }
        }

        private void LoadClassDetails(int classId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // 注意：User 表中应有 FullName 字段存储教师姓名，有时表名可能为 [User] 或 Users
                SqlCommand cmd = new SqlCommand(@"
                    SELECT c.ClassName, c.Description, u.username AS TeacherName
                    FROM Class c
                    INNER JOIN [Users] u ON c.TeacherID = u.user_id
                    WHERE c.ClassID = @ClassID", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblClassName.Text = reader["ClassName"].ToString();
                    lblDescription.Text = reader["Description"].ToString();
                    lblTeacher.Text = reader["TeacherName"].ToString();
                }
                reader.Close();
            }
        }

        private void LoadClassContent(int classId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // 此处假设 Content 表中有 Title, ContentText, ContentURL 字段
                SqlCommand cmd = new SqlCommand(@"
                    SELECT Title, ContentText, ContentURL
                    FROM Content
                    WHERE ClassID = @ClassID", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptContent.DataSource = dt;
                rptContent.DataBind();
            }
        }

        private void LoadAssignments(int classId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT AssignmentID, Title, Description, DueDate, AssignmentURL
            FROM Assignment
            WHERE ClassID = @ClassID", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptAssignments.DataSource = dt;
                rptAssignments.DataBind();
            }
        }
        private void LoadQuizzes(int classId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT QuizID, Title, Description
            FROM Quiz
            WHERE ClassID = @ClassID", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptQuizzes.DataSource = dt;
                rptQuizzes.DataBind();
            }
        }

    }
}
