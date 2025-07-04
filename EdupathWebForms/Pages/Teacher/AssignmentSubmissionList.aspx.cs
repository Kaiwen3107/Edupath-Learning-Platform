using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages.Teacher
{
    public partial class AssignmentSubmissionList : System.Web.UI.Page
    {
        protected string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        protected int assignmentId;
        protected int classId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Authentication check
            if (Session["UserID"] == null || Session["Role"].ToString() != "teacher")
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            // Get assignment ID from query string
            if (!int.TryParse(Request.QueryString["assignmentId"], out assignmentId))
            {
                Response.Redirect("ClassDetailTeacher.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAssignmentDetails();
                LoadSubmissionData();
                UpdateStatistics();
            }
        }

        private void LoadAssignmentDetails()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT a.Title, c.ClassName, c.ClassID, 
                           (SELECT COUNT(*) FROM Enrollment WHERE ClassID = a.ClassID) AS TotalStudents
                    FROM Assignment a
                    JOIN Class c ON a.ClassID = c.ClassID
                    WHERE a.AssignmentID = @AssignmentID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        lblAssignmentTitle.Text = reader["Title"].ToString();
                        ViewState["ClassName"] = reader["ClassName"].ToString();
                        ViewState["TotalStudents"] = reader["TotalStudents"].ToString();
                        classId = Convert.ToInt32(reader["ClassID"]);
                        litTotalCount.Text = reader["TotalStudents"].ToString();
                    }
                }
            }
        }

        private void LoadSubmissionData()
        {
            DataTable dtSubmissions = GetSubmissionData();
            gvSubmissions.DataSource = dtSubmissions;
            gvSubmissions.DataBind();
            litShowingCount.Text = dtSubmissions.Rows.Count.ToString();
        }

        private DataTable GetSubmissionData()
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        u.user_id AS UserID,
                        u.username AS StudentName,
                        s.SubmissionAT AS SubmitAt,
                        s.Grade,
                        s.SubmissionURL,
                        s.SubmissionID,
                        CASE 
                            WHEN s.SubmissionID IS NULL THEN 'Not Submitted'
                            WHEN s.Grade IS NULL THEN 'Submitted (Ungraded)'
                            ELSE 'Graded'
                        END AS Status
                    FROM Enrollment e
                    JOIN Users u ON e.StudentID = u.user_id
                    LEFT JOIN Submission s ON s.StudentID = u.user_id AND s.AssignmentID = @AssignmentID
                    WHERE e.ClassID = @ClassID
                    ORDER BY u.username";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                cmd.Parameters.AddWithValue("@ClassID", classId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            return dt;
        }

        private void UpdateStatistics()
        {
            int total = 0;
            int graded = 0;
            int pending = 0;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // Get total submissions count
                string query = @"
                    SELECT COUNT(*) 
                    FROM Submission 
                    WHERE AssignmentID = @AssignmentID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                conn.Open();
                total = (int)cmd.ExecuteScalar();

                // Get graded count
                query = @"
                    SELECT COUNT(*) 
                    FROM Submission 
                    WHERE AssignmentID = @AssignmentID AND Grade IS NOT NULL";

                cmd.CommandText = query;
                graded = (int)cmd.ExecuteScalar();

                pending = total - graded;
            }

            totalSubmissions.InnerText = total.ToString();
            gradedSubmissions.InnerText = graded.ToString();
            pendingSubmissions.InnerText = pending.ToString();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            DataTable dt = GetSubmissionData();

            if (!string.IsNullOrEmpty(txtSearch.Text))
            {
                string searchTerm = txtSearch.Text.ToLower();
                DataView dv = dt.DefaultView;
                dv.RowFilter = $"StudentName LIKE '%{searchTerm}%'";
                dt = dv.ToTable();
            }

            gvSubmissions.DataSource = dt;
            gvSubmissions.DataBind();
            litShowingCount.Text = dt.Rows.Count.ToString();
        }

        protected void gvSubmissions_Row
            (object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Style rows based on status
                DataRowView rowView = (DataRowView)e.Row.DataItem;
                string status = rowView["Status"].ToString();

                if (status.Contains("Graded"))
                {
                    e.Row.CssClass += " table-success";
                }
                else if (status.Contains("Ungraded"))
                {
                    e.Row.CssClass += " table-warning";
                }
            }
        }

        public string GetStatusBadgeClass(object status)
        {
            if (status == null) return "badge bg-secondary";

            string statusText = status.ToString();
            return statusText.Contains("Graded") ? "badge-graded" :
                   statusText.Contains("Submitted") ? "badge-submitted" :
                   "badge-pending";
        }

        public string GetGradeDisplay(object grade)
        {
            if (grade == null || grade == DBNull.Value)
                return "<span class='badge bg-secondary'>-</span>";

            if (int.TryParse(grade.ToString(), out int gradeValue))
            {
                string badgeClass = gradeValue >= 90 ? "bg-success" :
                                  gradeValue >= 70 ? "bg-primary" :
                                  gradeValue >= 50 ? "bg-warning" : "bg-danger";

                return $"<span class='badge {badgeClass}'>{gradeValue}</span>";
            }

            return grade.ToString();
        }
    }
}