using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics; // 用于 Debug.WriteLine

namespace EdupathWebForms.Pages.Teacher
{
    public partial class ClassDetailTeacher : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        protected int classId; // 标记为 protected，以便在 ASPX 页面中通过 <%= classId %> 访问

        private const int StudentsPerPage = 10;
        private const int DiscussionsPerPage = 5;

        protected void Page_Load(object sender, EventArgs e)
        {
            Debug.WriteLine($"[Page_Load] Page_Load started. IsPostBack: {IsPostBack}");

            // 1. 验证用户会话和角色
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "teacher")
            {
                Debug.WriteLine("[Page_Load] User not authenticated or not a teacher. Redirecting to Login.");
                Response.Redirect("../Login.aspx");
                return;
            }

            // 2. 获取班级ID
            if (!int.TryParse(Request.QueryString["id"], out classId))
            {
                Debug.WriteLine("[Page_Load] ClassID not found in QueryString. Redirecting to MyClasses.");
                Response.Redirect("MyClasses.aspx");
                return;
            }
            Debug.WriteLine($"[Page_Load] Current ClassID: {classId}");

            // 3. 非回发时加载所有数据
            if (!IsPostBack)
            {
                Debug.WriteLine("[Page_Load] Initial page load (!IsPostBack). Loading all data.");
                Session["StudentPage"] = 0; // 初始化学生分页
                Session["DiscussionPage"] = 0; // 初始化讨论分页

                LoadClassInfo();
                LoadAssignments();
                LoadQuizzes();
                LoadContents();
                LoadStudents(); // 首次加载时绑定学生 GridView
                LoadDiscussion(); // 首次加载时绑定讨论 Repeater
            }
            else
            {
                Debug.WriteLine("[Page_Load] PostBack detected. Data will be loaded by specific event handlers if needed.");
            }
            
            Page.DataBind(); 
        }

        private void LoadClassInfo()
        {
            Debug.WriteLine($"[LoadClassInfo] Loading class info for ClassID: {classId}");
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT ClassName, Description, EnrollmentCode FROM Class WHERE ClassID = @ClassID AND TeacherID = @TeacherID", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);
                cmd.Parameters.AddWithValue("@TeacherID", Session["UserID"]); // 确保老师只能访问自己的班级
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblClassName.Text = reader["ClassName"].ToString();
                    lblDescription.Text = reader["Description"].ToString();
                    lblCode.Text = reader["EnrollmentCode"].ToString();
                    Debug.WriteLine($"[LoadClassInfo] Class found: {lblClassName.Text}");
                }
                else
                {
                    lblResult.Text = "❌ Class information not found or you do not have permission to access this class。";
                    Debug.WriteLine($"[LoadClassInfo] ClassID {classId} not found or current UserID {Session["UserID"]} does not have access.");
                    // 考虑在这里重定向到 MyClasses.aspx
                    // Response.Redirect("MyClasses.aspx");
                }
            }
        }

        private void LoadAssignments()
        {
            Debug.WriteLine($"[LoadAssignments] Loading assignments for ClassID: {classId}");
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT AssignmentID, Title, Description, DueDate, AssignmentURL FROM Assignment WHERE ClassID = @ClassID", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptAssignments.DataSource = dt;
                rptAssignments.DataBind();
                Debug.WriteLine($"[LoadAssignments] Loaded {dt.Rows.Count} assignments.");
            }
        }

        private void LoadQuizzes()
        {
            Debug.WriteLine($"[LoadQuizzes] Loading quizzes for ClassID: {classId}");
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT QuizID, Title, Description FROM Quiz WHERE ClassID = @ClassID", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptQuizzes.DataSource = dt;
                rptQuizzes.DataBind();
                Debug.WriteLine($"[LoadQuizzes] Loaded {dt.Rows.Count} quizzes.");
            }
        }

        private void LoadContents()
        {
            Debug.WriteLine($"[LoadContents] Loading contents for ClassID: {classId}");
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT ContentId, Title, Description, ContentURL FROM Content WHERE ClassID = @ClassID", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptContents.DataSource = dt;
                rptContents.DataBind();
                Debug.WriteLine($"[LoadContents] Loaded {dt.Rows.Count} contents.");
            }
        }

        private void LoadStudents()
        {
            Debug.WriteLine($"[LoadStudents] Loading students for ClassID: {classId}, Page: {Session["StudentPage"]}");
            int page = Convert.ToInt32(Session["StudentPage"]);
            int offset = page * StudentsPerPage;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(@"SELECT user_id, username, email FROM Users
                                        WHERE user_id IN (SELECT StudentID FROM Enrollment WHERE ClassID = @ClassID)
                                        ORDER BY username OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);
                cmd.Parameters.AddWithValue("@Offset", offset);
                cmd.Parameters.AddWithValue("@PageSize", StudentsPerPage);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptStudents.DataSource = dt;
                rptStudents.DataBind();
                Debug.WriteLine($"[LoadStudents] Repeater bound with {dt.Rows.Count} students.");

                btnPrevStudent.Enabled = (page > 0);
                using (SqlCommand countCmd = new SqlCommand("SELECT COUNT(*) FROM Enrollment WHERE ClassID = @ClassID", conn))
                {
                    countCmd.Parameters.AddWithValue("@ClassID", classId);
                    int totalStudents = (int)countCmd.ExecuteScalar();
                    btnNextStudent.Enabled = ((page + 1) * StudentsPerPage < totalStudents);
                    Debug.WriteLine($"[LoadStudents] Total students: {totalStudents}. Prev enabled: {btnPrevStudent.Enabled}, Next enabled: {btnNextStudent.Enabled}");
                }
            }
        }
        protected void btnPrevStudent_Click(object sender, EventArgs e)
        {
            Debug.WriteLine("[btnPrevStudent_Click] Previous student page button clicked.");
            int page = Convert.ToInt32(Session["StudentPage"]);
            if (page > 0)
            {
                Session["StudentPage"] = page - 1;
            }
            LoadStudents();
        }

        protected void btnNextStudent_Click(object sender, EventArgs e)
        {
            Debug.WriteLine("[btnNextStudent_Click] Next student page button clicked.");
            Session["StudentPage"] = Convert.ToInt32(Session["StudentPage"]) + 1;
            LoadStudents();
        }

       

        private void LoadDiscussion()
        {
            Debug.WriteLine($"[LoadDiscussion] Loading discussions for ClassID: {classId}, Page: {Session["DiscussionPage"]}");
            int page = Convert.ToInt32(Session["DiscussionPage"]);
            int offset = page * DiscussionsPerPage;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(@"SELECT d.DiscussionID, d.Message, d.CreatedAt, u.username FROM Discussion d
                                                 JOIN Users u ON d.UserID = u.user_id
                                                 WHERE d.ClassID = @ClassID
                                                 ORDER BY d.CreatedAt DESC
                                                 OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);
                cmd.Parameters.AddWithValue("@Offset", offset);
                cmd.Parameters.AddWithValue("@PageSize", DiscussionsPerPage);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptDiscussion.DataSource = dt;
                rptDiscussion.DataBind();
                Debug.WriteLine($"[LoadDiscussion] Loaded {dt.Rows.Count} discussions.");

                btnPrevDiscussion.Enabled = (page > 0);
                using (SqlCommand countCmd = new SqlCommand("SELECT COUNT(*) FROM Discussion WHERE ClassID = @ClassID", conn))
                {
                    countCmd.Parameters.AddWithValue("@ClassID", classId);
                    int totalDiscussions = (int)countCmd.ExecuteScalar();
                    btnNextDiscussion.Enabled = ((page + 1) * DiscussionsPerPage < totalDiscussions);
                    Debug.WriteLine($"[LoadDiscussion] Total discussions: {totalDiscussions}. Prev enabled: {btnPrevDiscussion.Enabled}, Next enabled: {btnNextDiscussion.Enabled}");
                }
            }
        }

        protected void btnPrevDiscussion_Click(object sender, EventArgs e)
        {
            Debug.WriteLine("[btnPrevDiscussion_Click] Previous discussion page button clicked.");
            int page = Convert.ToInt32(Session["DiscussionPage"]);
            if (page > 0)
            {
                Session["DiscussionPage"] = page - 1;
            }
            LoadDiscussion();
        }

        protected void btnNextDiscussion_Click(object sender, EventArgs e)
        {
            Debug.WriteLine("[btnNextDiscussion_Click] Next discussion page button clicked.");
            Session["DiscussionPage"] = Convert.ToInt32(Session["DiscussionPage"]) + 1;
            LoadDiscussion();
        }

        protected void btnPostComment_Click(object sender, EventArgs e)
        {
            Debug.WriteLine("[btnPostComment_Click] Post comment button clicked.");
            if (!Page.IsValid)
            {
                Debug.WriteLine("[btnPostComment_Click] Page is not valid. Returning.");
                return;
            }

            string message = txtNewComment.Text.Trim();
            if (string.IsNullOrWhiteSpace(message))
            {
                lblResult.Text = "❌ Commnet Cant Empty。";
                lblResult.CssClass = "text-danger fw-bold d-block mt-3";
                Debug.WriteLine("[btnPostComment_Click] Comment message is empty.");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO Discussion (ClassID, UserID, Message, CreatedAt) VALUES (@ClassID, @UserID, @Message, GETDATE())", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);
                cmd.Parameters.AddWithValue("@UserID", Session["UserID"]);
                cmd.Parameters.AddWithValue("@Message", message);
                conn.Open();
                cmd.ExecuteNonQuery();
                Debug.WriteLine("[btnPostComment_Click] Comment inserted into database.");
            }

            txtNewComment.Text = "";
            lblResult.Text = "✅ Discussion Post Succesful！";
            lblResult.CssClass = "text-success fw-bold d-block mt-3";
            LoadDiscussion(); 
        }

        protected void btnDeleteClass_Click(object sender, EventArgs e)
        {
            Debug.WriteLine($"[btnDeleteClass_Click] Delete class button clicked for ClassID: {classId}");
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlTransaction tx = conn.BeginTransaction();

                try
                {
                    // 1. Delete (Submission) 
                    SqlCommand cmd1 = new SqlCommand("DELETE FROM Submission WHERE AssignmentID IN (SELECT AssignmentID FROM Assignment WHERE ClassID = @ClassID)", conn, tx);
                    cmd1.Parameters.AddWithValue("@ClassID", classId);
                    int rows1 = cmd1.ExecuteNonQuery();
                    Debug.WriteLine($"[btnDeleteClass_Click] Deleted {rows1} Submission records.");

                    // 2. Delete (QuizSubmission) 
                    SqlCommand cmd2 = new SqlCommand("DELETE FROM QuizSubmission WHERE QuizID IN (SELECT QuizID FROM Quiz WHERE ClassID = @ClassID)", conn, tx);
                    cmd2.Parameters.AddWithValue("@ClassID", classId);
                    int rows2 = cmd2.ExecuteNonQuery();
                    Debug.WriteLine($"[btnDeleteClass_Click] Deleted {rows2} QuizSubmission records.");

                    // 3. Delete (Discussion) 
                    SqlCommand cmd3 = new SqlCommand("DELETE FROM Discussion WHERE ClassID = @ClassID", conn, tx);
                    cmd3.Parameters.AddWithValue("@ClassID", classId);
                    int rows3 = cmd3.ExecuteNonQuery();
                    Debug.WriteLine($"[btnDeleteClass_Click] Deleted {rows3} Discussion records.");

                    // 4. Delete (Content) 
                    SqlCommand cmd4 = new SqlCommand("DELETE FROM Content WHERE ClassID = @ClassID", conn, tx);
                    cmd4.Parameters.AddWithValue("@ClassID", classId);
                    int rows4 = cmd4.ExecuteNonQuery();
                    Debug.WriteLine($"[btnDeleteClass_Click] Deleted {rows4} Content records.");

                    // 5. Delete (Assignment)
                    SqlCommand cmd5 = new SqlCommand("DELETE FROM Assignment WHERE ClassID = @ClassID", conn, tx);
                    cmd5.Parameters.AddWithValue("@ClassID", classId);
                    int rows5 = cmd5.ExecuteNonQuery();
                    Debug.WriteLine($"[btnDeleteClass_Click] Deleted {rows5} Assignment records.");

                    // 6. Delete (Quiz) 
                    SqlCommand cmd6 = new SqlCommand("DELETE FROM Quiz WHERE ClassID = @ClassID", conn, tx);
                    cmd6.Parameters.AddWithValue("@ClassID", classId);
                    int rows6 = cmd6.ExecuteNonQuery();
                    Debug.WriteLine($"[btnDeleteClass_Click] Deleted {rows6} Quiz records.");

                    // 7. Delete (Enrollment) 
                    SqlCommand cmd7 = new SqlCommand("DELETE FROM Enrollment WHERE ClassID = @ClassID", conn, tx);
                    cmd7.Parameters.AddWithValue("@ClassID", classId);
                    int rows7 = cmd7.ExecuteNonQuery();
                    Debug.WriteLine($"[btnDeleteClass_Click] Deleted {rows7} Enrollment records.");

                    // 8.Delete (Class) 
                    SqlCommand cmd8 = new SqlCommand("DELETE FROM Class WHERE ClassID = @ClassID", conn, tx);
                    cmd8.Parameters.AddWithValue("@ClassID", classId);
                    int rows8 = cmd8.ExecuteNonQuery();
                    Debug.WriteLine($"[btnDeleteClass_Click] Deleted {rows8} Class records.");

                    tx.Commit();
                    Debug.WriteLine("[btnDeleteClass_Click] Transaction committed successfully. Class deleted.");

                    
                    Response.Redirect("MyClasses.aspx");
                }
                catch (Exception ex)
                {
                    tx.Rollback();
                    lblResult.Text = "❌ Delete Class Fail: " + ex.Message;
                    lblResult.CssClass = "text-danger fw-bold d-block mt-3";
                    Debug.WriteLine($"[btnDeleteClass_Click] Error deleting class (ID: {classId}): {ex.Message}");
                }
            }
        }



    }
}