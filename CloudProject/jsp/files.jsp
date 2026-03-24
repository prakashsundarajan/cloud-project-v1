<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Integer userId = (Integer) session.getAttribute("userid");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String msg = (String) session.getAttribute("msg");
    String search = request.getParameter("search");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Your Files</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
.thumbnail {
    width: 70px;
    height: 70px;
    object-fit: cover;
    border-radius: 8px;
}

/* 🌙 DARK MODE */
.dark-mode {
    background-color: #121212 !important;
    color: white !important;
}

.dark-mode .card {
    background-color: #1e1e1e;
    color: white;
}

.dark-mode .table {
    color: white;
}

.dark-mode .table-dark {
    background-color: #333;
}

/* 🔥 Hover effect */
.table tbody tr:hover {
    background-color: #f1f1f1;
}

.dark-mode .table tbody tr:hover {
    background-color: #2c2c2c;
}
</style>

</head>

<body class="bg-light">

<div class="container mt-5">

    <div class="card shadow p-4">

        <!-- 🔥 Header -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3>Your Files 📂</h3>

            <button onclick="toggleDarkMode()" class="btn btn-dark btn-sm">
                🌙
            </button>
        </div>

        <!-- 🔍 Search -->
        <form method="get" class="mb-3 text-center">
            <input type="text" name="search"
                   value="<%= (search != null) ? search : "" %>"
                   placeholder="Search file..."
                   class="form-control w-50 d-inline">

            <button type="submit" class="btn btn-primary ms-2">
                🔍
            </button>
        </form>

        <!-- 🔥 Message -->
        <% if (msg != null) { %>
            <div class="alert alert-info text-center">
                <%= msg %>
            </div>
        <%
            session.removeAttribute("msg");
        } %>

        <!-- 📋 Table -->
        <table class="table table-bordered table-hover text-center align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Preview</th>
                    <th>File Name</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>

<%
try (Connection con = DBConnection.getConnection()) {

    String sql;

    if (search != null && !search.trim().isEmpty()) {
        sql = "SELECT * FROM files WHERE userid=? AND filename LIKE ?";
    } else {
        sql = "SELECT * FROM files WHERE userid=?";
    }

    PreparedStatement ps = con.prepareStatement(sql);
    ps.setInt(1, userId);

    if (search != null && !search.trim().isEmpty()) {
        ps.setString(2, "%" + search + "%");
    }

    ResultSet rs = ps.executeQuery();

    boolean hasData = false;

    while(rs.next()){
        hasData = true;
        String fileName = rs.getString("filename");
        String lower = fileName.toLowerCase();
%>

<tr>
    <td><%= rs.getInt("id") %></td>

    <td>
        <% if (lower.endsWith(".jpg") || lower.endsWith(".png") || lower.endsWith(".jpeg")) { %>
            <img src="<%=request.getContextPath()%>/preview?file=<%= fileName %>" class="thumbnail">
        <% } else if (lower.endsWith(".pdf")) { %>
            📄
        <% } else { %>
            📁
        <% } %>
    </td>

    <td><%= fileName %></td>

    <td>

        <a href="<%=request.getContextPath()%>/preview?file=<%= fileName %>"
           class="btn btn-info btn-sm" title="Preview" target="_blank">👀</a>

        <a href="<%=request.getContextPath()%>/download?file=<%= fileName %>"
           class="btn btn-success btn-sm" title="Download">⬇️</a>

        <a href="<%=request.getContextPath()%>/delete?file=<%= fileName %>"
           class="btn btn-danger btn-sm"
           onclick="return confirm('Delete this file?');" title="Delete">🗑️</a>

        <form action="<%=request.getContextPath()%>/rename" method="post"
              style="display:inline;">

            <input type="hidden" name="oldName" value="<%= fileName %>">

            <input type="text" name="newName"
                   placeholder="Rename"
                   required
                   style="width:90px; font-size:12px;">

            <button type="submit" class="btn btn-warning btn-sm" title="Rename">✏️</button>
        </form>

    </td>
</tr>

<%
    }

    if (!hasData) {
%>
<tr>
    <td colspan="4">No matching files 🔍</td>
</tr>
<%
    }

    rs.close();
    ps.close();

} catch(Exception e){
%>
<tr>
    <td colspan="4">Error: <%= e.getMessage() %></td>
</tr>
<%
}
%>

            </tbody>
        </table>

        <div class="text-center mt-3">
            <a href="<%=request.getContextPath()%>/jsp/home.jsp" class="btn btn-secondary">
                ⬅ Back
            </a>
        </div>

    </div>

</div>

<!-- 🌙 DARK MODE SCRIPT -->
<script>
function toggleDarkMode() {
    document.body.classList.toggle("dark-mode");

    if (document.body.classList.contains("dark-mode")) {
        localStorage.setItem("theme", "dark");
    } else {
        localStorage.setItem("theme", "light");
    }
}

window.onload = function() {
    if (localStorage.getItem("theme") === "dark") {
        document.body.classList.add("dark-mode");
    }
};
</script>

</body>
</html>