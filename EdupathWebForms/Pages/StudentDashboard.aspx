<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentDashboard.aspx.cs" Inherits="EdupathWebForms.Pages.StudentDashboard" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Student Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #f8f9fa;
            padding-top: 20px;
        }
        .sidebar a {
            display: block;
            padding: 10px 15px;
            color: #000;
            text-decoration: none;
        }
        .sidebar a:hover {
            background-color: #e2e6ea;
        }
        .active {
            background-color: #d1d8de;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-3 sidebar">
                    <h4 class="ps-3">🎓 Edupath</h4>
                    <a href="#" class="active">🏫 Class</a>
                    <a href="#">📝 Assignment</a>
                    <a href="#">📊 Grade</a>
                    <a href="#">🙋 Profile</a>
                    <asp:Button ID="Button1" runat="server" OnClick="btnLogout_Click" Text="Log Out" />
                </div>

                <!-- Main content -->
                <div class="col-md-9 p-4">
                    <h2>Welcome，<%= Session["Username"] %>！</h2>

                    <div class="mb-4">
                        <h4>Join New Class</h4>
                        <asp:TextBox ID="txtCode" runat="server" CssClass="form-control" placeholder="Enter Class Code"></asp:TextBox>
                        <asp:Button ID="btnJoin" runat="server" CssClass="btn btn-primary mt-2" Text="Join" OnClick="btnJoin_Click" />
                        <asp:Label ID="lblJoinResult" runat="server" CssClass="text-danger d-block mt-2"></asp:Label>
                    </div>

                    <h4>My Class</h4>
                    <asp:Repeater ID="rptClasses" runat="server">
                        <ItemTemplate>
                            <div class="card mb-3">
                                <div class="card-body">
                                    <h5 class="card-title"><%# Eval("ClassName") %></h5>
                                    <p class="card-text"><%# Eval("Description") %></p>
                                    <a href='<%# "ClassDetail.aspx?classId=" + Eval("ClassID") %>' class="btn btn-outline-primary">Enter Class</a>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </form>
</body>
</html>