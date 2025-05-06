using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

namespace EdupathWebForms.Pages
{
    public partial class AssignmentSubmission : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 检查学生登录状态
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "student")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int assignmentId;
                if (int.TryParse(Request.QueryString["assignmentId"], out assignmentId))
                {
                    LoadAssignmentDetails(assignmentId);
                }
                else
                {
                    lblMessage.Text = "Invalid assignment.";
                    btnSubmit.Enabled = false;
                }
            }
        }

        private void LoadAssignmentDetails(int assignmentId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"
                    SELECT Title, Description, DueDate
                    FROM Assignment
                    WHERE AssignmentID = @AssignmentID", conn);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblAssignmentTitle.Text = reader["Title"].ToString();
                    lblAssignmentDesc.Text = reader["Description"].ToString();
                    lblDueDate.Text = Convert.ToDateTime(reader["DueDate"]).ToString("yyyy-MM-dd");
                }
                reader.Close();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (fileUploadSubmission.HasFile)
            {
                int assignmentId = Convert.ToInt32(Request.QueryString["assignmentId"]);
                int userId = Convert.ToInt32(Session["UserID"]);

                // 获取文件名，并保存到服务器 Submissions 文件夹下
                string fileName = Path.GetFileName(fileUploadSubmission.FileName);
                string folderPath = Server.MapPath("~/Submissions/");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }
                string filePath = Path.Combine(folderPath, fileName);

                fileUploadSubmission.SaveAs(filePath);

                // 将提交记录写入数据库
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Submission (AssignmentID, StudentID, SubmissionURL, SubmissionAT)
                        VALUES (@AssignmentID, @StudentID, @SubmissionURL, GETDATE())", conn);
                    cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    cmd.Parameters.AddWithValue("@StudentID", userId);
                    cmd.Parameters.AddWithValue("@SubmissionURL", "~/Submissions/" + fileName);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                lblMessage.CssClass = "text-success";
                lblMessage.Text = "Submission successful!";
            }
            else
            {
                lblMessage.Text = "Please select a file.";
            }
        }
    }
}
