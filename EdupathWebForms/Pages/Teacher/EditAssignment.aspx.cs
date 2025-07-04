using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages.Teacher
{
    public partial class EditAssignment : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        int assignmentId;
        string uploadFolder = "/Pages/Assignment/";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"].ToString() != "teacher")
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            if (!int.TryParse(Request.QueryString["assignmentId"], out assignmentId))
            {
                Response.Redirect("ClassDetailTeacher.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAssignment();
            }
        }

        private void LoadAssignment()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT Title, Description, DueDate, AssignmentURL FROM Assignment WHERE AssignmentID = @AssignmentID", conn);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtTitle.Text = reader["Title"].ToString();
                    txtDescription.Text = reader["Description"].ToString();
                    txtDueDate.Text = Convert.ToDateTime(reader["DueDate"]).ToString("yyyy-MM-ddTHH:mm");

                    string fileUrl = reader["AssignmentURL"].ToString();
                    lnkCurrentFile.Text = Path.GetFileName(fileUrl);
                    lnkCurrentFile.NavigateUrl = fileUrl;
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string title = txtTitle.Text.Trim();
            string description = txtDescription.Text.Trim();
            DateTime dueDate = DateTime.Parse(txtDueDate.Text);
            string newUrl = null;

            if (fileUpload.HasFile)
            {
                string filename = Path.GetFileName(fileUpload.FileName);
                string savePath = Server.MapPath(uploadFolder + filename);
                fileUpload.SaveAs(savePath);
                newUrl = uploadFolder + filename;
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"UPDATE Assignment SET Title = @Title, Description = @Description, DueDate = @DueDate
                    " + (newUrl != null ? ", AssignmentURL = @AssignmentURL" : "") + " WHERE AssignmentID = @AssignmentID", conn);
                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@Description", description);
                cmd.Parameters.AddWithValue("@DueDate", dueDate);
                if (newUrl != null)
                    cmd.Parameters.AddWithValue("@AssignmentURL", newUrl);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblStatus.Text = "✅ Assignment updated successfully.";
            LoadAssignment();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Assignment WHERE AssignmentID = @AssignmentID", conn);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            Response.Redirect("ClassDetailTeacher.aspx");
        }


    }
}