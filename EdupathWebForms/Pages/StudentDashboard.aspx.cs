using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EdupathWebForms.Pages
{
    public partial class StudentDashboard : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "student")
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadMyClasses();
            }
        }

        protected void btnJoin_Click(object sender, EventArgs e)
        {
            string enrollCode = txtCode.Text.Trim();
            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 查找是否有这个邀请码对应的班级
                SqlCommand findClass = new SqlCommand("SELECT ClassID FROM Class WHERE EnrollmentCode = @Code", conn);
                findClass.Parameters.AddWithValue("@Code", enrollCode);
                object result = findClass.ExecuteScalar();

                if (result != null)
                {
                    int classId = Convert.ToInt32(result);

                    // 检查是否已经加入
                    SqlCommand checkEnroll = new SqlCommand("SELECT COUNT(*) FROM Enrollment WHERE ClassID = @ClassID AND StudentID = @StudentID", conn);
                    checkEnroll.Parameters.AddWithValue("@ClassID", classId);
                    checkEnroll.Parameters.AddWithValue("@StudentID", userId);

                    int count = (int)checkEnroll.ExecuteScalar();

                    if (count == 0)
                    {
                        // 加入班级
                        SqlCommand enroll = new SqlCommand("INSERT INTO Enrollment (ClassID, StudentID) VALUES (@ClassID, @StudentID)", conn);
                        enroll.Parameters.AddWithValue("@ClassID", classId);
                        enroll.Parameters.AddWithValue("@StudentID", userId);
                        enroll.ExecuteNonQuery();

                        lblJoinResult.CssClass = "text-success";
                        lblJoinResult.Text = "✅ Successfully joined the class!";
                        LoadMyClasses();
                    }
                    else
                    {
                        lblJoinResult.Text = "⚠️ You have already joined this class.";
                    }
                }
                else
                {
                    lblJoinResult.Text = "❌ Invalid invitation code. Please try again.";
                }
            }
        }

        private void LoadMyClasses()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT c.ClassID, c.ClassName, c.Description
                    FROM Class c
                    INNER JOIN Enrollment e ON c.ClassID = e.ClassID
                    WHERE e.StudentID = @StudentID", conn);
                cmd.Parameters.AddWithValue("@StudentID", userId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptClasses.DataSource = dt;
                rptClasses.DataBind();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}
