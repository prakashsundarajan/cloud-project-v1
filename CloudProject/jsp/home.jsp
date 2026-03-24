<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>

<%
    String user = (String) session.getAttribute("username");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String msg = (String) session.getAttribute("msg");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body class="bg-light">

<div class="container mt-5">

    <div class="card shadow p-4">

        <h2 class="text-center">Welcome <%= user %> 😎</h2>

        <% if (msg != null) { %>
            <div class="alert alert-success mt-3">
                <%= msg %>
            </div>
        <%
            session.removeAttribute("msg");
        } %>

        <div class="text-center mt-4">

            <a href="<%=request.getContextPath()%>/jsp/upload.jsp" class="btn btn-primary m-2">
                Upload File 📂
            </a>

            <a href="<%=request.getContextPath()%>/jsp/files.jsp" class="btn btn-success m-2">
                View Files 📁
            </a>

            <a href="<%=request.getContextPath()%>/logout" class="btn btn-danger m-2">
                Logout 🚪
            </a>

        </div>

    </div>

</div>

</body>
</html>