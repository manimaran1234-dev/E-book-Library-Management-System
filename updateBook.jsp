<%@ page import="java.sql.*" %>
<%@ page import="com.example.library.DBUtil" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    Connection conn = DBUtil.getConnection();
    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM books WHERE id = ?");
    stmt.setInt(1, id);
    ResultSet rs = stmt.executeQuery();
    rs.next();
%>
<!DOCTYPE html>
<html>
<head><title>Update Book</title></head>
<body>
    <h2>Update Book</h2>
    <form action="UpdateBookServlet" method="post">
        <input type="hidden" name="id" value="<%= rs.getInt("id") %>"/>
        Title: <input type="text" name="title" value="<%= rs.getString("title") %>"/><br/>
        Author: <input type="text" name="author" value="<%= rs.getString("author") %>"/><br/>
        Year: <input type="text" name="year" value="<%= rs.getInt("year") %>"/><br/>
        Genre: <input type="text" name="genre" value="<%= rs.getString("genre") %>"/><br/>
        <input type="submit" value="Update Book"/>
    </form>
</body>
</html>
