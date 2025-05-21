using System;
using System.Web.UI;

namespace EdupathWebForms.Pages.Admin
{
    public partial class AdminSite : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.DataBind(); // 使 <%# %> 生效
        }

        public string GetActive(string pageName)
        {
            string current = System.IO.Path.GetFileNameWithoutExtension(Request.Path);
            return string.Equals(current, pageName, StringComparison.OrdinalIgnoreCase) ? "active" : "";
        }
    }
}
