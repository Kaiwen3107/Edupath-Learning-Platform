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
        int assignmentId;
        int studentId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "student")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            studentId = Convert.ToInt32(Session["UserID"]);

            if (!int.TryParse(Request.QueryString["assignmentId"], out assignmentId))
            {
                Response.Redirect("StudentDashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadSubmission();

            }
        }

        private void LoadSubmission()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT s.SubmissionURL, s.SubmissionAT, s.Grade, a.DueDate
                    FROM Assignment a
                    LEFT JOIN Submission s ON a.AssignmentID = s.AssignmentID AND s.StudentID = @StudentID
                    WHERE a.AssignmentID = @AssignmentID", conn);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                cmd.Parameters.AddWithValue("@StudentID", studentId);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    string url = reader["SubmissionURL"] as string;
                    DateTime? submittedAt = reader["SubmissionAT"] as DateTime?;
                    object gradeObj = reader["Grade"];
                    DateTime due = Convert.ToDateTime(reader["DueDate"]);

                    if (!string.IsNullOrEmpty(url))
                    {
                        pnlFile.Visible = true;
                        lnkSubmission.NavigateUrl = "Teacher/" + url;
                        lblStatusText.Text = "✅ Submitted for grading";
                        lblLastModified.Text = submittedAt?.ToString("f") ?? "-";

                        TimeSpan diff = due - submittedAt.GetValueOrDefault(DateTime.Now);
                        lblTimeRemaining.Text = diff.TotalSeconds > 0
                            ? $"Submitted {Math.Floor(diff.TotalDays)} days early"
                            : $"⏰ Submitted {Math.Abs(Math.Floor(diff.TotalDays))} days late";
                    }
                    else
                    {
                        pnlFile.Visible = false;
                        lblStatusText.Text = "❌ Not submitted";
                        lblLastModified.Text = "-";
                        TimeSpan remain = due - DateTime.Now;
                        lblTimeRemaining.Text = remain.TotalSeconds > 0
                            ? $"{Math.Floor(remain.TotalDays)} days remaining"
                            : "⏰ Overdue";
                    }

                    lblGradeStatus.Text = gradeObj == DBNull.Value ? "Not graded" : "✅ " + gradeObj + " / 100";
                }

                reader.Close();
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (!fileUpload.HasFile)
            {
                ShowStatus("⚠ Please choose a file to upload.", "alert-danger");
                return;
            }

            // Save file
            string fileName = Path.GetFileName(fileUpload.FileName);
            string folderPath = Server.MapPath("Teacher/Submissions/");
            Directory.CreateDirectory(folderPath);
            string savedFileName = Guid.NewGuid().ToString() + "_" + fileName;
            string fullPath = Path.Combine(folderPath, savedFileName);
            fileUpload.SaveAs(fullPath);
            string virtualPath = "Submissions/" + savedFileName;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                SqlCommand check = new SqlCommand(@"
                    SELECT COUNT(*) FROM Submission
                    WHERE AssignmentID = @AssignmentID AND StudentID = @StudentID", conn);
                check.Parameters.AddWithValue("@AssignmentID", assignmentId);
                check.Parameters.AddWithValue("@StudentID", studentId);
                int count = (int)check.ExecuteScalar();

                if (count > 0)
                {
                    SqlCommand update = new SqlCommand(@"
                        UPDATE Submission
                        SET SubmissionURL = @URL, SubmissionAT = GETDATE()
                        WHERE AssignmentID = @AssignmentID AND StudentID = @StudentID", conn);
                    update.Parameters.AddWithValue("@URL", virtualPath);
                    update.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    update.Parameters.AddWithValue("@StudentID", studentId);
                    update.ExecuteNonQuery();
                }
                else
                {
                    SqlCommand insert = new SqlCommand(@"
                        INSERT INTO Submission (AssignmentID, StudentID, SubmissionURL, SubmissionAT)
                        VALUES (@AssignmentID, @StudentID, @URL, GETDATE())", conn);
                    insert.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    insert.Parameters.AddWithValue("@StudentID", studentId);
                    insert.Parameters.AddWithValue("@URL", virtualPath);
                    insert.ExecuteNonQuery();
                }
            }

            ShowStatus("✅ Submission uploaded successfully.", "alert-success");
            LoadSubmission();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand delete = new SqlCommand(@"
                    UPDATE Submission
                    SET SubmissionURL = NULL, SubmissionAT = NULL
                    WHERE AssignmentID = @AssignmentID AND StudentID = @StudentID", conn);
                delete.Parameters.AddWithValue("@AssignmentID", assignmentId);
                delete.Parameters.AddWithValue("@StudentID", studentId);
                delete.ExecuteNonQuery();
            }

            ShowStatus("❌ Submission removed.", "alert-warning");
            LoadSubmission();
        }

        private void ShowStatus(string message, string cssClass)
        {
            pnlStatus.CssClass = "alert " + cssClass;
            pnlStatus.CssClass = pnlStatus.CssClass.Replace("d-none", ""); // 显示
            lblStatus.Text = message;
        }

    }
}
