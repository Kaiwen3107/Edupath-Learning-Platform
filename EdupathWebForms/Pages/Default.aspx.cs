using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages
{
    public partial class Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null && Session["Role"] != null)
            {
                string role = Session["Role"].ToString();

                if (role == "admin")
                {
                    Response.Redirect("/Admin/AdminDashboard.aspx");
                }
                else if (role == "teacher")
                {
                    Response.Redirect("/Pages/Teacher/TeacherDashboard.aspx");
                }
                else if (role == "student")
                {
                    Response.Redirect("/Pages/StudentDashboard.aspx");
                }
            }
        }
    }
}