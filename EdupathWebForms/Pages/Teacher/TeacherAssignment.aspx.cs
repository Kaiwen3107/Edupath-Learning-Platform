using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages.Teacher
{
    public partial class TeacherAssignment : System.Web.UI.Page
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
                LoadAssignments();
            }
        }

        private void LoadAssignments()
        {
            int teacherId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT a.AssignmentID, a.Title, a.Description, a.DueDate, c.ClassName
                    FROM Assignment a
                    INNER JOIN Class c ON a.ClassID = c.ClassID
                    WHERE c.TeacherID = @TeacherID
                    ORDER BY a.DueDate DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@TeacherID", teacherId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptAssignments.DataSource = dt;
                rptAssignments.DataBind();
            }
        }
    }
}