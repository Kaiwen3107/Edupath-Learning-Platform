using System;
using System.Web.UI;

namespace EdupathWebForms.Pages.Teacher
{
    public partial class TeacherSite : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.DataBind(); // 让 <%# %> 表达式生效
        }

        public string GetActive(string pageName)
        {
            string current = System.IO.Path.GetFileNameWithoutExtension(Request.Path);
            return string.Equals(current, pageName, StringComparison.OrdinalIgnoreCase) ? "active" : "";
        }
    }
}
