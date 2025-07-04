using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EdupathWebForms.Pages.Teacher
{
    public partial class EditQuiz : System.Web.UI.Page
    {
        // Use readonly keyword to ensure the connection string is initialized only once
        private readonly string _connectionString = ConfigurationManager.ConnectionStrings["EdupathConnectionString"].ConnectionString;
        private int _quizId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. User and Role Validation: Ensure only logged-in teachers can access this page
            if (Session["UserID"] == null || Session["Role"] == null || Session["Role"].ToString() != "teacher")
            {
                Response.Redirect("../Login.aspx");
                return;
            }

            // 2. Parse QuizID: Get the quiz ID from the URL query string
            // If QuizID is invalid, redirect to the teacher's class details page
            if (!int.TryParse(Request.QueryString["quizId"], out _quizId))
            {
                Response.Redirect("ClassDetailTeacher.aspx");
                return;
            }

            // 3. Load quiz details only on the first page load (IsPostBack is false)
            // This optimizes performance as title/description don't change frequently
            if (!IsPostBack)
            {
                LoadQuiz(); // Load quiz title and description
            }

            // 4. Always load questions and bind to GridView on every page load (including PostBacks)
            // This is crucial for maintaining GridView's state (especially DataKeys) across postbacks
            // and often resolves "DataKeys collection is empty" issues.
            LoadQuestions();

            // 5. Clear or hide the status message on every PostBack
            // This prevents old messages from persisting
            lblStatus.Text = "";
            lblStatus.CssClass = "d-none"; // Hidden by default, shown and styled by SetStatusMessage method
        }

        /// <summary>
        /// Loads the title and description of the current quiz from the database.
        /// </summary>
        private void LoadQuiz()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    SqlCommand cmd = new SqlCommand("SELECT Title, Description, ClassID FROM Quiz WHERE QuizID = @QuizID", conn);
                    cmd.Parameters.AddWithValue("@QuizID", _quizId);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        txtTitle.Text = reader["Title"].ToString();
                        txtDescription.Text = reader["Description"].ToString();
                        // You could store ClassID here if needed, e.g., ViewState["ClassID"] = reader["ClassID"];
                    }
                    else
                    {
                        // If the quiz does not exist, display an error and redirect
                        SetStatusMessage("❌ Quiz not found.", false);
                        Response.Redirect("ClassDetailTeacher.aspx");
                    }
                }
            }
            catch (Exception ex)
            {
                // Catch and display database or other errors during quiz loading
                SetStatusMessage("❌ Error loading quiz information: " + ex.Message, false);
            }
        }

        /// <summary>
        /// Loads all questions for the current quiz from the database and binds them to the GridView.
        /// </summary>
        private void LoadQuestions()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    // Order by QuestionID to ensure consistent display order
                    SqlCommand cmd = new SqlCommand("SELECT QuestionID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption FROM Question WHERE QuizID = @QuizID ORDER BY QuestionID ASC", conn);
                    cmd.Parameters.AddWithValue("@QuizID", _quizId);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt); // Populate DataTable with questions
                    gvQuestions.DataSource = dt;
                    gvQuestions.DataBind(); // Bind data to the GridView

                    // Show or hide the GridView based on whether there are any questions
                    gvQuestions.Visible = dt.Rows.Count > 0;
                }
            }
            catch (Exception ex)
            {
                // Catch and display database or other errors during question list loading
                SetStatusMessage("❌ Error loading question list: " + ex.Message, false);
            }
        }

        /// <summary>
        /// Handles the "Update Quiz" button click event: Updates the quiz's title and description.
        /// </summary>
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string title = txtTitle.Text.Trim();
            string description = txtDescription.Text.Trim();

            // Validate if the quiz title is empty
            if (string.IsNullOrWhiteSpace(title))
            {
                SetStatusMessage("⚠️ Quiz title cannot be empty.", false);
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Quiz SET Title = @Title, Description = @Description WHERE QuizID = @QuizID", conn);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@QuizID", _quizId);
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery(); // Execute the update operation
                    if (rowsAffected > 0)
                    {
                        // Update successful
                        SetStatusMessage("✅ Quiz updated successfully.", true);
                    }
                    else
                    {
                        // Quiz not found or no content was actually changed
                        SetStatusMessage("⚠️ Quiz not found or no content to update.", false);
                    }
                }
            }
            catch (Exception ex)
            {
                // Catch and display database or other errors during quiz update
                SetStatusMessage("❌ Failed to update quiz: " + ex.Message, false);
            }
        }

        /// <summary>
        /// Handles the "Delete Quiz" button click event: Deletes the quiz and all its associated data.
        /// Uses a database transaction to ensure atomicity (all or nothing operation).
        /// </summary>
        protected void btnDelete_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    conn.Open();
                    SqlTransaction transaction = conn.BeginTransaction(); // Begin a database transaction

                    try
                    {
                        // 1. Delete QuizSubmission records associated with this quiz
                        // This must be deleted first due to foreign key dependencies.
                        SqlCommand deleteQuizSubmissionsCmd = new SqlCommand("DELETE FROM QuizSubmission WHERE QuizID = @QuizID", conn, transaction);
                        deleteQuizSubmissionsCmd.Parameters.AddWithValue("@QuizID", _quizId);
                        deleteQuizSubmissionsCmd.ExecuteNonQuery();

                        // 2. Delete Question records associated with this quiz
                        // Questions also depend on Quiz, so they must be deleted before the Quiz itself.
                        SqlCommand deleteQuestionsCmd = new SqlCommand("DELETE FROM Question WHERE QuizID = @QuizID", conn, transaction);
                        deleteQuestionsCmd.Parameters.AddWithValue("@QuizID", _quizId);
                        deleteQuestionsCmd.ExecuteNonQuery();

                        // 3. Finally, delete the Quiz itself
                        SqlCommand deleteQuizCmd = new SqlCommand("DELETE FROM Quiz WHERE QuizID = @QuizID", conn, transaction);
                        deleteQuizCmd.Parameters.AddWithValue("@QuizID", _quizId);
                        deleteQuizCmd.ExecuteNonQuery();

                        transaction.Commit(); // All delete operations successful, commit the transaction
                        Response.Redirect("ClassDetailTeacher.aspx"); // Redirect after successful deletion
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback(); // If any error occurs, roll back all changes
                        SetStatusMessage("❌ Failed to delete quiz, data has been rolled back: " + ex.Message, false);
                    }
                }
            }
            catch (Exception ex)
            {
                // Catch and display unexpected errors when opening connection or beginning transaction
                SetStatusMessage("❌ An unexpected error occurred while deleting the quiz: " + ex.Message, false);
            }
        }

        /// <summary>
        /// Handles the "Add Question" button click event: Adds a new question to the quiz.
        /// </summary>
        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            string questionText = txtQuestion.Text.Trim();
            string optionA = txtOptionA.Text.Trim();
            string optionB = txtOptionB.Text.Trim();
            string optionC = txtOptionC.Text.Trim();
            string optionD = txtOptionD.Text.Trim();
            string correctOption = ddlCorrect.Text.Trim().ToUpper(); // Convert to uppercase for consistent validation

            // Input validation: Ensure all fields are filled and correct option format is valid
            if (string.IsNullOrWhiteSpace(questionText) ||
                string.IsNullOrWhiteSpace(optionA) ||
                string.IsNullOrWhiteSpace(optionB) ||
                string.IsNullOrWhiteSpace(optionC) ||
                string.IsNullOrWhiteSpace(optionD) ||
                string.IsNullOrWhiteSpace(correctOption))
            {
                SetStatusMessage("⚠️ Please fill in all question and option fields.", false);
                return;
            }

            if (!"ABCD".Contains(correctOption)) // Validate if correct option is A, B, C, or D
            {
                SetStatusMessage("⚠️ Correct answer must be A, B, C, or D.", false);
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    SqlCommand cmd = new SqlCommand("INSERT INTO Question (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectOption) VALUES (@QuizID, @QuestionText, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectOption)", conn);
                    cmd.Parameters.AddWithValue("@QuizID", _quizId);
                    cmd.Parameters.AddWithValue("@QuestionText", questionText);
                    cmd.Parameters.AddWithValue("@OptionA", optionA);
                    cmd.Parameters.AddWithValue("@OptionB", optionB);
                    cmd.Parameters.AddWithValue("@OptionC", optionC);
                    cmd.Parameters.AddWithValue("@OptionD", optionD);
                    cmd.Parameters.AddWithValue("@CorrectOption", correctOption);
                    conn.Open();
                    cmd.ExecuteNonQuery(); // Execute the insert operation
                }

                SetStatusMessage("✅ Question added successfully.", true);
                ClearQuestionForm(); // Clear input fields for adding more questions
                LoadQuestions(); // Reload GridView to display the newly added question
            }
            catch (Exception ex)
            {
                // Catch and display database or other errors during question addition
                SetStatusMessage("❌ Failed to add question: " + ex.Message, false);
            }
        }

        /// <summary>
        /// Handles the GridView row deleting event: Deletes the specified question.
        /// </summary>
        protected void gvQuestions_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                if (gvQuestions.DataKeys == null || gvQuestions.DataKeys.Count == 0)
                {
                    SetStatusMessage("❌ Error: Could not retrieve Question ID. DataKeys collection is empty. Ensure GridView has a data source and DataKeyNames is set.", false);
                    return; 
                }

                if (e.RowIndex < 0 || e.RowIndex >= gvQuestions.DataKeys.Count)
                {
                    SetStatusMessage($"❌ Error: Invalid row index for deletion ({e.RowIndex}). Actual number of questions is {gvQuestions.DataKeys.Count}.", false);
                    return; 
                }

                int questionId = Convert.ToInt32(gvQuestions.DataKeys[e.RowIndex].Value);

                using (SqlConnection conn = new SqlConnection(_connectionString))
                {
                    SqlCommand cmd = new SqlCommand("DELETE FROM Question WHERE QuestionID = @QuestionID", conn);
                    cmd.Parameters.AddWithValue("@QuestionID", questionId);
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery(); // Execute the delete operation
                    if (rowsAffected > 0)
                    {
                        // Deletion successful
                        SetStatusMessage("✅ Question deleted successfully.", true);
                    }
                    else
                    {
                        // Question not found or already deleted
                        SetStatusMessage("⚠️ Question not found or already deleted.", false);
                    }
                }
            }
            catch (Exception ex)
            {
                // Catch and display database or other errors during question deletion
                SetStatusMessage("❌ Failed to delete question: " + ex.Message, false);
            }
            finally
            {
                // Always reload the question list, regardless of deletion success or failure,
                // to ensure the GridView displays the most current data.
                LoadQuestions();
            }
        }

        /// <summary>
        /// Helper method: Sets the text content and CSS class for the status message label (lblStatus).
        /// </summary>
        /// <param name="message">The message text to display to the user.</param>
        /// <param name="isSuccess">If True, the message will be styled as success (green); if False, as error/warning (red).</param>
        private void SetStatusMessage(string message, bool isSuccess)
        {
            lblStatus.Text = message;
            // Set CSS class based on isSuccess parameter to control text color and visibility
            lblStatus.CssClass = "fw-bold d-block " + (isSuccess ? "text-success" : "text-danger");
        }

        /// <summary>
        /// Helper method: Clears all input fields used for adding new questions.
        /// </summary>
        private void ClearQuestionForm()
        {
            txtQuestion.Text = "";
            txtOptionA.Text = "";
            txtOptionB.Text = "";
            txtOptionC.Text = "";
            txtOptionD.Text = "";
            ddlCorrect.Text = "";
        }
    }
}