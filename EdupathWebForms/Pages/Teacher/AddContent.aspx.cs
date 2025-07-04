using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.AccessControl;

namespace EdupathWebForms.Pages.Teacher
{
    public partial class AddContent : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        protected int classId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Authentication check
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "teacher")
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            // Class ID validation
            if (!int.TryParse(Request.QueryString["classId"], out classId))
            {
                Response.Redirect("MyClasses.aspx");
                return;
            }

            // Verify teacher has access to this class
            if (!IsTeacherAuthorized(classId))
            {
                Response.Redirect("MyClasses.aspx");
                return;
            }
        }

        // Verify the current teacher owns this class
        private bool IsTeacherAuthorized(int classId)
        {
            int teacherId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Class WHERE ClassID = @ClassID AND TeacherID = @TeacherID", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);
                cmd.Parameters.AddWithValue("@TeacherID", teacherId);

                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            // Server-side validation
            if (!ValidateForm())
            {
                return;
            }

            string title = txtTitle.Text.Trim();
            string description = txtDescription.Text.Trim();
            string contentUrl = null;

            try
            {
                // File handling
                if (fileUpload.HasFile)
                {
                    // Validate file extension
                    string extension = Path.GetExtension(fileUpload.FileName).ToLower();
                    string[] allowedExtensions = { ".pdf", ".ppt", ".pptx", ".doc", ".docx", ".xls", ".xlsx", ".txt" };

                    if (!allowedExtensions.Contains(extension))
                    {
                        lblStatus.Text = "❌ Invalid file type. Please upload PDF, PPT, PPTX, DOC, DOCX, XLS, XLSX, or TXT files.";
                        lblStatus.CssClass = "text-danger d-block mt-3";
                        return;
                    }

                    // Save file
                    try
                    {
                        string folderPath = Server.MapPath("~/Pages/Contents/");

                        // Create directory if it doesn't exist with proper permissions
                        if (!Directory.Exists(folderPath))
                        {
                            Directory.CreateDirectory(folderPath);

                            // Set appropriate directory permissions
                            DirectoryInfo dirInfo = new DirectoryInfo(folderPath);
                            DirectorySecurity dirSecurity = dirInfo.GetAccessControl();
                            dirSecurity.AddAccessRule(new FileSystemAccessRule("NETWORK SERVICE",
                                FileSystemRights.FullControl,
                                InheritanceFlags.ContainerInherit | InheritanceFlags.ObjectInherit,
                                PropagationFlags.None,
                                AccessControlType.Allow));
                            dirInfo.SetAccessControl(dirSecurity);
                        }

                        string fileName = DateTime.Now.Ticks + "_" + Path.GetFileName(fileUpload.FileName);
                        string fullPath = Path.Combine(folderPath, fileName);
                        fileUpload.SaveAs(fullPath);

                        // Verify file was created
                        if (!File.Exists(fullPath))
                        {
                            throw new Exception("File could not be created on the server.");
                        }

                        contentUrl = "Pages/Contents/" + fileName;
                    }
                    catch (Exception ex)
                    {
                        lblStatus.Text = "❌ File upload error: " + ex.Message;
                        lblStatus.CssClass = "text-danger d-block mt-3";
                        return;
                    }
                }

                // Database operation
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Content (ClassID, Title, Description, ContentURL, CreatedAt)
                        VALUES (@ClassID, @Title, @Description, @URL, GETDATE())", conn);

                    cmd.Parameters.AddWithValue("@ClassID", classId);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@URL", (object)contentUrl ?? DBNull.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Success
                lblStatus.Text = "✅ Content uploaded successfully.";
                lblStatus.CssClass = "text-success d-block mt-3";
                txtTitle.Text = "";
                txtDescription.Text = "";
            }
            catch (Exception ex)
            {
                // Error handling
                lblStatus.Text = "❌ Error: " + ex.Message;
                lblStatus.CssClass = "text-danger d-block mt-3";

                // Log the error (could be expanded to write to a log file)
                System.Diagnostics.Debug.WriteLine("Error in AddContent: " + ex.ToString());
            }
        }

        private bool ValidateForm()
        {
            // Manual server-side validation
            if (string.IsNullOrWhiteSpace(txtTitle.Text))
            {
                lblStatus.Text = "❌ Title is required.";
                lblStatus.CssClass = "text-danger d-block mt-3";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDescription.Text))
            {
                lblStatus.Text = "❌ Description is required.";
                lblStatus.CssClass = "text-danger d-block mt-3";
                return false;
            }

            if (!fileUpload.HasFile)
            {
                lblStatus.Text = "❌ Please select a file to upload.";
                lblStatus.CssClass = "text-danger d-block mt-3";
                return false;
            }

            return true;
        }
    }
}