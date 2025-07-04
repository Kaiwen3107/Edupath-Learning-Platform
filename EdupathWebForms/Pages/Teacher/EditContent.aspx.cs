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
    public partial class EditContent : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        int contentId;
        string uploadFolder = "/Pages/Contents/";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"].ToString() != "teacher")
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            if (!int.TryParse(Request.QueryString["contentId"], out contentId))
            {
                Response.Redirect("ClassDetailTeacher.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadContent();
            }
        }

        private void LoadContent()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT Title, Description, ContentURL FROM Content WHERE ContentID = @ContentID", conn);
                cmd.Parameters.AddWithValue("@ContentID", contentId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtTitle.Text = reader["Title"].ToString();
                    txtDescription.Text = reader["Description"].ToString();
                    string fileUrl = reader["ContentURL"].ToString();
                    lnkCurrentFile.Text = Path.GetFileName(fileUrl);
                    lnkCurrentFile.NavigateUrl = fileUrl;
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string newTitle = txtTitle.Text.Trim();
            string newDesc = txtDescription.Text.Trim();
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
                SqlCommand cmd = new SqlCommand(@"UPDATE Content SET Title = @Title, Description = @Description
                    " + (newUrl != null ? ", ContentURL = @ContentURL" : "") + " WHERE ContentID = @ContentID", conn);
                cmd.Parameters.AddWithValue("@Title", newTitle);
                cmd.Parameters.AddWithValue("@Description", newDesc);
                if (newUrl != null)
                    cmd.Parameters.AddWithValue("@ContentURL", newUrl);
                cmd.Parameters.AddWithValue("@ContentID", contentId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblStatus.Text = "✅ Content updated successfully.";
            LoadContent();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Content WHERE ContentID = @ContentID", conn);
                cmd.Parameters.AddWithValue("@ContentID", contentId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            Response.Redirect("ClassDetailTeacher.aspx");
        }
    }
}