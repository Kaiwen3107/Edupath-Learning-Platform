using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Security.AccessControl;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages.Teacher
{
    public partial class AddAssignment : System.Web.UI.Page
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

            if (!IsPostBack)
            {
                // Set minimum due date to tomorrow
                txtDueDate.Attributes["min"] = DateTime.Now.AddDays(1).ToString("yyyy-MM-ddTHH:mm");
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

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            // Server-side validation
            if (!Page.IsValid || !ValidateForm())
            {
                return;
            }

            string title = txtTitle.Text.Trim();
            string description = txtDescription.Text.Trim();
            DateTime dueDate;
            string assignmentUrl = null;

            // Parse due date
            if (!DateTime.TryParse(txtDueDate.Text, out dueDate))
            {
                ShowError("Invalid due date format.");
                return;
            }

            // Server-side validation of due date
            if (dueDate <= DateTime.Now)
            {
                ShowError("Due date must be in the future.");
                return;
            }

            try
            {
                // Handle file upload if present
                if (fileUpload.HasFile)
                {
                    // Validate file extension
                    string extension = Path.GetExtension(fileUpload.FileName).ToLower();
                    string[] allowedExtensions = { ".pdf", ".doc", ".docx", ".ppt", ".pptx", ".xls", ".xlsx", ".zip" };

                    if (!allowedExtensions.Contains(extension))
                    {
                        ShowError("Invalid file type. Please upload PDF, DOC, DOCX, PPT, PPTX, XLS, XLSX, or ZIP files.");
                        return;
                    }

                    // Save file with enhanced error handling
                    string folderPath = Server.MapPath("~/Pages/Assignments/");

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

                    string fileName = $"{DateTime.Now.Ticks}_{Path.GetFileName(fileUpload.FileName)}";
                    string fullPath = Path.Combine(folderPath, fileName);

                    fileUpload.SaveAs(fullPath);

                    // Verify file was created
                    if (!File.Exists(fullPath))
                    {
                        throw new Exception("File could not be created on the server.");
                    }

                    assignmentUrl = "Pages/Assignments/" + fileName;
                }

                // Insert assignment to database
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO Assignment (ClassID, Title, Description, DueDate, AssignmentURL, CreatedAt)
                        VALUES (@ClassID, @Title, @Description, @DueDate, @URL, GETDATE())", conn);

                    cmd.Parameters.AddWithValue("@ClassID", classId);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@DueDate", dueDate);
                    cmd.Parameters.AddWithValue("@URL", (object)assignmentUrl ?? DBNull.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Success
                ShowSuccess("✅ Assignment created successfully!");
                ClearForm();
            }
            catch (Exception ex)
            {
                // Error handling
                ShowError("Error: " + ex.Message);

                // Log the error
                System.Diagnostics.Debug.WriteLine("Error in AddAssignment: " + ex.ToString());
            }
        }

        private bool ValidateForm()
        {
            // Manual server-side validation
            if (string.IsNullOrWhiteSpace(txtTitle.Text))
            {
                ShowError("Title is required.");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDescription.Text))
            {
                ShowError("Description is required.");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDueDate.Text))
            {
                ShowError("Due date is required.");
                return false;
            }

            return true;
        }

        private void ShowError(string message)
        {
            lblStatus.Text = "❌ " + message;
        }

        private void ShowSuccess(string message)
        {
            lblStatus.Text = message;
        }

        private void ClearForm()
        {
            txtTitle.Text = "";
            txtDescription.Text = "";
            txtDueDate.Text = "";
        }
    }
}