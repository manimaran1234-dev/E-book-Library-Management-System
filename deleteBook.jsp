<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String url = "jdbc:mysql://localhost:3306/registrationdb";
    String dbUser = "root";
    String dbPass = "maran@2820";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Book - Admin</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f3f4f6;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            text-align: center;
        }

        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ccc;
        }

        th {
            background-color: #34495e;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .delete-btn {
            background-color: #e74c3c;
            color: white;
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
        }

        .delete-btn:hover {
            background-color: #c0392b;
        }

        .back-link {
            display: block;
            width: fit-content;
            margin: 20px auto;
            text-decoration: none;
            color: #3498db;
        }
    </style>
</head>
<body>

<header>
    <h1>Delete Book</h1>
</header>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM books");
%>

<table>
    <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Author</th>
        <th>Category</th>
        <th>Year</th>
        <th>Action</th>
    </tr>

    <%
        while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("author") %></td>
        <td><%= rs.getString("category") %></td>
        <td><%= rs.getInt("year") %></td>
        <td>
            <a href="DeleteBookServlet?id=<%= rs.getInt("id") %>" class="delete-btn" onclick="return confirm('Are you sure you want to delete this book?');">Delete</a>
        </td>
    </tr>
    <%
        }
    %>
</table>

<a class="back-link" href="adminDashboard.jsp">&larr; Back to Admin Dashboard</a>


<%
    } catch(Exception e) {
        out.println("<p style='color:red;'>Error loading books: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

</body>
</html>
