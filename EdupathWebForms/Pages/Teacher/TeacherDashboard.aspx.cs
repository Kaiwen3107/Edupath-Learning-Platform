using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages.Teacher
{
    public partial class TeacherDashboard : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "teacher")
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDashboard();
            }
        }

        private void LoadDashboard()
        {
            int teacherId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 班级数
                SqlCommand cmdClass = new SqlCommand("SELECT COUNT(*) FROM Class WHERE TeacherID = @TeacherID", conn);
                cmdClass.Parameters.AddWithValue("@TeacherID", teacherId);
                lblClassCount.Text = cmdClass.ExecuteScalar().ToString();

                // 作业数
                SqlCommand cmdAssign = new SqlCommand(@"
                    SELECT COUNT(*) FROM Assignment 
                    WHERE ClassID IN (SELECT ClassID FROM Class WHERE TeacherID = @TeacherID)", conn);
                cmdAssign.Parameters.AddWithValue("@TeacherID", teacherId);
                lblAssignmentCount.Text = cmdAssign.ExecuteScalar().ToString();

                // 提交数
                SqlCommand cmdSubmit = new SqlCommand(@"
                    SELECT COUNT(*) FROM Submission 
                    WHERE AssignmentID IN (
                        SELECT AssignmentID FROM Assignment 
                        WHERE ClassID IN (
                            SELECT ClassID FROM Class WHERE TeacherID = @TeacherID
                        )
                    )", conn);
                cmdSubmit.Parameters.AddWithValue("@TeacherID", teacherId);
                lblSubmissionCount.Text = cmdSubmit.ExecuteScalar().ToString();
            }
        }
    }
}