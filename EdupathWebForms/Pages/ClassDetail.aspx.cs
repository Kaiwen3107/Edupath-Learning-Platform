using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace EdupathWebForms.Pages
{
    public partial class ClassDetail : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        int classId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "student")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // Try to parse classId in both initial load and postbacks
            // The classId is needed for both LoadClassDetails and LoadDiscussion
            if (int.TryParse(Request.QueryString["classId"], out classId))
            {
                // Load class details only on initial load, as they are static
                if (!IsPostBack)
                {
                    LoadClassDetails(classId);
                    LoadClassContent(classId);     
                    LoadAssignments(classId); 
                    LoadQuizzes(classId);
                }

                // Always load discussion on every postback
                // This ensures DataKeys are always populated when events like RowDeleting fire
                LoadDiscussion(classId);
                LoadClassDetails(classId);
                LoadClassContent(classId);
                LoadAssignments(classId);
                LoadQuizzes(classId);

            }
            else
            {
                ShowStatusMessage("Invalid class specified", false);
                Response.Redirect("StudentDashboard.aspx");
            }
        }

        private void LoadClassDetails(int classId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT c.ClassName, c.Description, u.username AS TeacherName
                    FROM Class c
                    INNER JOIN Users u ON c.TeacherID = u.user_id
                    WHERE c.ClassID = @ClassID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblClassName.Text = reader["ClassName"].ToString();
                    lblDescription.Text = reader["Description"].ToString();
                    lblTeacher.Text = reader["TeacherName"].ToString();
                }
                reader.Close();
            }
        }

        protected void btnPost_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMessage.Text))
            {
                ShowStatusMessage("Message cannot be empty", false);
                return;
            }

            try
            {
                int userId = Convert.ToInt32(Session["UserID"]);
                int classId = Convert.ToInt32(Request.QueryString["classId"]);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        INSERT INTO Discussion (ClassID, UserID, Message, CreatedAt)
                        VALUES (@ClassID, @UserID, @Message, GETDATE())";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ClassID", classId);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@Message", txtMessage.Text.Trim());

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                txtMessage.Text = "";
                ShowStatusMessage("Message posted successfully", true);
                LoadDiscussion(classId);
            }
            catch (Exception ex)
            {
                ShowStatusMessage("Error posting message: " + ex.Message, false);
            }
        }

        private void LoadDiscussion(int classId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        SELECT d.DiscussionID, d.Message, d.CreatedAt, 
                               u.user_id AS UserID, u.username AS Username
                        FROM Discussion d
                        JOIN Users u ON d.UserID = u.user_id
                        WHERE d.ClassID = @ClassID
                        ORDER BY d.CreatedAt DESC";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ClassID", classId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvDiscussion.DataSource = dt;
                    gvDiscussion.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowStatusMessage("Error loading discussion: " + ex.Message, false);
            }
        }

        protected void gvDiscussion_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Get the UserID from DataKeys
                int messageUserId = Convert.ToInt32(gvDiscussion.DataKeys[e.Row.RowIndex].Values["UserID"]);
                int currentUserId = Convert.ToInt32(Session["UserID"]);
                string currentUserRole = Session["Role"]?.ToString();

                // Find the delete button (it's the first control in the last cell)
                if (e.Row.Cells[e.Row.Cells.Count - 1].Controls.Count > 0)
                {
                    // CHANGE THIS LINE: Cast to Button instead of LinkButton
                    Button deleteBtn = (Button)e.Row.Cells[e.Row.Cells.Count - 1].Controls[0];

                    // Show only if user is teacher or message owner
                    deleteBtn.Visible = (currentUserRole == "teacher" || currentUserId == messageUserId);
                }
            }
        }

        protected void gvDiscussion_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                // Validate session
                if (Session["UserID"] == null || Session["Role"] == null)
                {
                    ShowStatusMessage("Session expired. Please login again.", false);
                    Response.Redirect("Login.aspx");
                    return;
                }

                // Validate GridView data
                if (gvDiscussion.DataKeys == null || gvDiscussion.DataKeys.Count == 0)
                {
                    ShowStatusMessage("Could not retrieve discussion data.", false);
                    return;
                }

                // Validate row index
                if (e.RowIndex < 0 || e.RowIndex >= gvDiscussion.DataKeys.Count)
                {
                    ShowStatusMessage("Invalid message selected.", false);
                    return;
                }

                // Get IDs
                int discussionId = Convert.ToInt32(gvDiscussion.DataKeys[e.RowIndex].Values["DiscussionID"]);
                int currentUserId = Convert.ToInt32(Session["UserID"]);
                string currentUserRole = Session["Role"].ToString();
                int messageUserId = Convert.ToInt32(gvDiscussion.DataKeys[e.RowIndex].Values["UserID"]);

                // Validate permissions
                if (currentUserRole != "teacher" && currentUserId != messageUserId)
                {
                    ShowStatusMessage("You don't have permission to delete this message.", false);
                    return;
                }

                // Perform deletion
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"
                        DELETE FROM Discussion 
                        WHERE DiscussionID = @DiscussionID 
                        AND (UserID = @UserID OR @IsTeacher = 1)";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@DiscussionID", discussionId);
                    cmd.Parameters.AddWithValue("@UserID", currentUserId);
                    cmd.Parameters.AddWithValue("@IsTeacher", currentUserRole == "teacher" ? 1 : 0);

                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowStatusMessage("Message deleted successfully.", true);
                    }
                    else
                    {
                        ShowStatusMessage("Message not found or already deleted.", false);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowStatusMessage("Error deleting message: " + ex.Message, false);
            }
            finally
            {
                LoadDiscussion(classId);
            }
        }

        public string GetInitials(string username)
        {
            if (string.IsNullOrEmpty(username)) return "";
            string[] parts = username.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 0) return "";
            if (parts.Length == 1) return parts[0][0].ToString();
            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpper();
        }

        private void ShowStatusMessage(string message, bool isSuccess)
        {
            divStatusMessage.Attributes["class"] = isSuccess ? "status-message status-success" : "status-message status-error";
            statusMessageText.InnerText = message;
            divStatusMessage.Style["display"] = "block";

            // Register script to hide message after 5 seconds
            ScriptManager.RegisterStartupScript(this, GetType(), "HideStatusMessage",
                "setTimeout(function() { document.getElementById('" + divStatusMessage.ClientID + "').style.display = 'none'; }, 5000);", true);
        }

        private void LoadQuizzes(int classId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT QuizID, Title, Description
            FROM Quiz
            WHERE ClassID = @ClassID", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptQuizzes.DataSource = dt;
                rptQuizzes.DataBind();
            }
        }
        private void LoadAssignments(int classId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT AssignmentID, Title, Description, DueDate, AssignmentURL
            FROM Assignment
            WHERE ClassID = @ClassID", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptAssignments.DataSource = dt;
                rptAssignments.DataBind();
            }
        }

        private void LoadClassContent(int classId)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                // 此处假设 Content 表中有 Title, ContentText, ContentURL 字段
                SqlCommand cmd = new SqlCommand(@"
                    SELECT Title, Description, ContentURL
                    FROM Content
                    WHERE ClassID = @ClassID", conn);
                cmd.Parameters.AddWithValue("@ClassID", classId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptContent.DataSource = dt;
                rptContent.DataBind();
            }
        }


    }
}