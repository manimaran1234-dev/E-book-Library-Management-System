<%@ page import="java.sql.*" %>
<%@ page import="com.example.library.DBUtil" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Books</title>
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

        h2 {
            text-align: center;
            margin: 20px 0;
            color: #333;
        }

        table {
            border-collapse: collapse;
            width: 90%;
            margin: 30px auto;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }

        th {
            background-color: #34495e;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        a.action-link {
            color: #2980b9;
            text-decoration: none;
            margin: 0 5px;
        }

        a.action-link:hover {
            text-decoration: underline;
        }

        .back-link {
            display: block;
            width: fit-content;
            margin: 20px auto;
            padding: 8px 14px;
            text-decoration: none;
            color: white;
            background-color: #2ecc71;
            border-radius: 6px;
        }

        .back-link:hover {
            background-color: #27ae60;
        }
    </style>
</head>
<body>

<header>
    <h1> View All Books</h1>
</header>

<h2>All Books in Library</h2>

<table>
    <tr>
        <th>ID</th>
        <th>Title</th>
        <th>Author</th>
        <th>Actions</th>
    </tr>

<%
    try {
        Connection conn = DBUtil.getConnection();
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM books");

        while (rs.next()) {
            int id = rs.getInt("id");
            String title = rs.getString("title");
            String author = rs.getString("author");
%>
    <tr>
        <td><%= id %></td>
        <td><%= title %></td>
        <td><%= author %></td>
        <td>
            <a class="action-link" href="updateBook.jsp?id=<%= id %>"> Edit books</a> |
            <a class="action-link" href="DeleteBookServlet?id=<%= id %>"
               onclick="return confirm('Are you sure you want to delete this book?');"> Delete book</a>
        </td>
    </tr>
<%
        }

        rs.close();
        stmt.close();
        conn.close();

    } catch (Exception e) {
%>
    <tr><td colspan="4" style="color: red;">Error: <%= e.getMessage() %></td></tr>
<%
    }
%>
</table>

<a class="back-link" href="adminDashboard.jsp"> Back to Admin Dashboard</a>

</body>
</html>
