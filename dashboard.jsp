<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page session="true" %>
<%
    String categoryParam = request.getParameter("category");
    String url = "jdbc:mysql://localhost:3306/registrationdb";
    String dbUser = "root";
    String dbPass = "maran@2820";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String userName = (String) session.getAttribute("name");
%>

<!DOCTYPE html>
<html>
<head>
    <title>UserDashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(to right, #f0f4ff, #e2ecf5);
        }

        h2 {
            background-color: #2c3e50;
            color: white;
            margin: 0;
            padding: 20px;
            font-size: 24px;
        }

        .container {
            display: flex;
            padding: 20px;
        }

        .left-panel {
            width: 22%;
            background-color: #fefefe;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            margin-right: 20px;
            height: fit-content;
        }

        .left-panel h4 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #333;
        }

        .subject {
            padding: 12px;
            margin-bottom: 12px;
            border-radius: 8px;
            font-weight: bold;
            text-align: center;
            color: white;
            cursor: pointer;
            transition: 0.3s;
            text-decoration: none;
            display: block;
        }

        .subject:hover {
            opacity: 0.85;
        }

        .fiction { background-color: #ff7675; }
        .science { background-color: #74b9ff; }
        .maths { background-color: #55efc4; }
        .history { background-color: #ffeaa7; color: black; }
        .other { background-color: #a29bfe; }

        .book-list {
            flex: 1;
            background-color: #ffffff;
            border-radius: 10px;
            padding: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        .book {
            width: 150px;
            height: 200px;
            background: linear-gradient(to top right, #d4eaff, #ffffff);
            border: 2px solid #89c2ff;
            border-radius: 10px;
            padding: 10px;
            text-align: center;
            font-weight: bold;
            color: #2b2b2b;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 2px 2px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .book:hover {
            transform: translateY(-5px);
            background: #e0f0ff;
            cursor: pointer;
        }

        .error {
            color: red;
            font-weight: bold;
            padding: 10px;
        }
    </style>
</head>
<body>

<h2>Welcome, <%= userName %>! Explore your books</h2>

<div class="container">
    <!-- LEFT PANEL - Category List -->
    <div class="left-panel">
        <h4>Categories</h4>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, dbUser, dbPass);
                stmt = conn.prepareStatement("SELECT DISTINCT category FROM books");
                rs = stmt.executeQuery();

                while (rs.next()) {
                    String category = rs.getString("category");
                    String cssClass = "other";
                    if ("fiction".equalsIgnoreCase(category)) cssClass = "fiction";
                    else if ("science".equalsIgnoreCase(category)) cssClass = "science";
                    else if ("maths".equalsIgnoreCase(category)) cssClass = "maths";
                    else if ("history".equalsIgnoreCase(category)) cssClass = "history";

        %>
                    <a class="subject <%= cssClass %>" href="userDashboard.jsp?category=<%= category %>">
                        <%= category.toUpperCase() %>
                    </a>
        <%
                }
                rs.close();
                stmt.close();
            } catch(Exception e) {
                out.println("<div class='error'>Error loading categories: " + e.getMessage() + "</div>");
            }
        %>
    </div>

    <!-- RIGHT PANEL - Books -->
    <div class="book-list">
        <%
            try {
                String query = "SELECT title FROM books";
                if (categoryParam != null && !categoryParam.trim().isEmpty()) {
                    query += " WHERE category = ?";
                    stmt = conn.prepareStatement(query);
                    stmt.setString(1, categoryParam);
                } else {
                    stmt = conn.prepareStatement(query);
                }

                rs = stmt.executeQuery();
                boolean found = false;
                while (rs.next()) {
                    found = true;
                    String title = rs.getString("title");
        %>
                    <div class="book"><%= title %></div>
        <%
                }
                if (!found) {
                    out.println("<div class='error'>No books found in this category.</div>");
                }

                rs.close();
                stmt.close();
                conn.close();

            } catch(Exception e) {
                out.println("<div class='error'>Error loading books: " + e.getMessage() + "</div>");
            }
        %>
    </div>
</div>

</body>
</html>
