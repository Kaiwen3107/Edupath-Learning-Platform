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
    public partial class MyClasses : System.Web.UI.Page
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
                LoadMyClasses();
            }
        }

        private void LoadMyClasses()
        {
            int teacherId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT ClassID, ClassName, Description, EnrollmentCode FROM Class WHERE TeacherID = @TeacherID", conn);
                cmd.Parameters.AddWithValue("@TeacherID", teacherId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvMyClasses.DataSource = dt;
                gvMyClasses.DataBind();
            }
        }

        protected void btnCreateClass_Click(object sender, EventArgs e)
        {
            int teacherId = Convert.ToInt32(Session["UserID"]);
            string className = txtClassName.Text.Trim();
            string description = txtDescription.Text.Trim();
            string code = GenerateCode();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO Class (ClassName, Description, EnrollmentCode, TeacherID)
                    VALUES (@Name, @Desc, @Code, @TeacherID)", conn);

                cmd.Parameters.AddWithValue("@Name", className);
                cmd.Parameters.AddWithValue("@Desc", description);
                cmd.Parameters.AddWithValue("@Code", code);
                cmd.Parameters.AddWithValue("@TeacherID", teacherId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblStatus.Text = "✅ Class created successfully.";
            txtClassName.Text = "";
            txtDescription.Text = "";

            LoadMyClasses();
        }

        private string GenerateCode()
        {
            return Guid.NewGuid().ToString().Substring(0, 6).ToUpper();
        }
    }
}