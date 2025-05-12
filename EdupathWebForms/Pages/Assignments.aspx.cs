using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EdupathWebForms.Pages
{
    public partial class Assignments : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "student")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAssignments();
            }
        }

        private void LoadAssignments()
        {
            int studentId = Convert.ToInt32(Session["UserID"]);
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT a.AssignmentID, a.Title, a.Description, a.DueDate, c.ClassName
                    FROM Assignment a
                    INNER JOIN Class c ON a.ClassID = c.ClassID
                    INNER JOIN Enrollment e ON e.ClassID = c.ClassID
                    WHERE e.StudentID = @StudentID
                    ORDER BY a.DueDate";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@StudentID", studentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            // 分组逻辑：按日期插入 Literal Header
            if (dt.Rows.Count > 0)
            {
                string lastDate = "";
                List<AssignmentDisplay> displayList = new List<AssignmentDisplay>();

                foreach (DataRow row in dt.Rows)
                {
                    DateTime due = Convert.ToDateTime(row["DueDate"]);
                    string currentDate = due.ToString("dddd, d MMMM yyyy");

                    string dateHeaderHtml = "";
                    if (currentDate != lastDate)
                    {
                        dateHeaderHtml = $"<h5 class='mt-4'>{currentDate}</h5>";
                        lastDate = currentDate;
                    }

                    displayList.Add(new AssignmentDisplay
                    {
                        AssignmentID = Convert.ToInt32(row["AssignmentID"]),
                        Title = row["Title"].ToString(),
                        ClassName = row["ClassName"].ToString(),
                        DueDate = due,
                        DateHeader = dateHeaderHtml
                    });
                }

                rptAssignments.DataSource = displayList;
                rptAssignments.DataBind();
            }
            else
            {
                lblNoAssignment.Visible = true;
            }
        }

        public class AssignmentDisplay
        {
            public int AssignmentID { get; set; }
            public string Title { get; set; }
            public string ClassName { get; set; }
            public DateTime DueDate { get; set; }
            public string DateHeader { get; set; }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}
