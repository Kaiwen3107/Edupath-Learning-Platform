using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization; // For CultureInfo

namespace EdupathWebForms.Pages
{
    public partial class Assignments : System.Web.UI.Page
    {
        // Connection string from Web.config
        string connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Security: Check if user is logged in and has 'student' role
            if (Session["UserID"] == null || Session["Role"]?.ToString() != "student")
            {
                Response.Redirect("Login.aspx"); // Redirect to login if not authorized
                return;
            }

            // Load assignments only on initial page load (not on postbacks)
            if (!IsPostBack)
            {
                LoadAssignments();
            }
        }

        private void LoadAssignments()
        {
            int studentId = Convert.ToInt32(Session["UserID"]); // Get current student's ID
            DataTable dt = new DataTable(); // DataTable to hold raw assignment data

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    // SQL query to retrieve assignments for the logged-in student
                    // It joins Assignment, Class, and Enrollment tables.
                    // Orders by DueDate to facilitate timeline grouping.
                    string query = @"
                            SELECT a.AssignmentID, a.Title, a.Description, a.DueDate, c.ClassName
                            FROM Assignment a
                            INNER JOIN Class c ON a.ClassID = c.ClassID
                            INNER JOIN Enrollment e ON e.ClassID = c.ClassID
                            WHERE e.StudentID = @StudentID
                            ORDER BY a.DueDate";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@StudentID", studentId); // Parameterized query for security

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt); // Fill DataTable with results
                }

                // Process data for display, adding date headers for grouping
                if (dt.Rows.Count > 0)
                {
                    string lastDateHeader = ""; // Keep track of the last date processed
                    List<AssignmentDisplay> displayList = new List<AssignmentDisplay>(); // List for Repeater data source

                    foreach (DataRow row in dt.Rows)
                    {
                        DateTime dueDate = Convert.ToDateTime(row["DueDate"]);
                        // Format date for display and comparison (e.g., "Monday, 23 May")
                        string currentDateFormatted = dueDate.ToString("dddd, d MMMM", CultureInfo.CurrentCulture);

                        string dateHeaderHtml = "";
                        // If the date is different from the last one, create a new date header
                        if (currentDateFormatted != lastDateHeader)
                        {
                            dateHeaderHtml = $"<h5 class='date-header'>{currentDateFormatted}</h5>";
                            lastDateHeader = currentDateFormatted; // Update the last date
                        }

                        // Add assignment data to the display list
                        displayList.Add(new AssignmentDisplay
                        {
                            AssignmentID = Convert.ToInt32(row["AssignmentID"]),
                            Title = row["Title"].ToString(),
                            ClassName = row["ClassName"].ToString(),
                            DueDate = dueDate,
                            DateHeader = dateHeaderHtml // This will be empty string or an <h5> tag
                        });
                    }

                    rptAssignments.DataSource = displayList; // Set the Repeater's data source
                    rptAssignments.DataBind(); // Bind the data to the Repeater
                }
                else
                {
                    lblNoAssignment.Visible = true; // Show the "No upcoming assignments" message
                }
            }
            catch (Exception ex)
            {
                // Log the exception for debugging purposes (e.g., to a file or console)
                // In a real application, you'd use a proper logging framework.
                System.Diagnostics.Debug.WriteLine($"Error loading assignments: {ex.Message}");
                // Optionally, display a user-friendly error message
                lblNoAssignment.Text = "An error occurred while loading assignments. Please try again later.";
                lblNoAssignment.Visible = true;
                lblNoAssignment.CssClass = "text-danger no-assignments-message"; // Style as an error message
            }
        }

        /// <summary>
        /// Custom class to hold assignment data structured for display in the Repeater,
        /// including a dynamic date header.
        /// </summary>
        public class AssignmentDisplay
        {
            public int AssignmentID { get; set; }
            public string Title { get; set; }
            public string ClassName { get; set; }
            public DateTime DueDate { get; set; }
            public string DateHeader { get; set; } // Will contain HTML for the date header
        }

        // Handles logout button click (if you have one on this page or master page)
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear(); // Clear all session data
            Response.Redirect("Login.aspx"); // Redirect to login page
        }
    }
}