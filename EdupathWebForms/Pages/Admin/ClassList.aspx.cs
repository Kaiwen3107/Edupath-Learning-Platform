using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages.Admin
{
    public partial class ClassList : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadClasses();
            }
        }

        private void LoadClasses()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT 
                        c.ClassID, 
                        c.ClassName, 
                        c.EnrollmentCode, 
                        u.username AS TeacherName
                    FROM Class c
                    LEFT JOIN Users u ON c.TeacherID = u.user_id
                    ORDER BY c.ClassID DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvClasses.DataSource = dt;
                gvClasses.DataBind();
            }
        }
    }
}