using System;
using System.Web.UI;

namespace EdupathWebForms
{
    public partial class Site : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.DataBind(); // Needed for <%# ... %> to evaluate
        }

        public string GetActive(string page)
        {
            string current = System.IO.Path.GetFileNameWithoutExtension(Request.Path);
            return current.Equals(page, StringComparison.OrdinalIgnoreCase) ? "active" : "";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Login.aspx");
        }
    }
}
