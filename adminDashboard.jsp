<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String selectedCategory = request.getParameter("category");

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
    <title>Admin Dashboard - Library</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            background-color: #f8f9fa;
        }

        header {
            background-color: #2c3e50;
            color: white;
            padding: 20px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header h1 {
            margin: 0;
        }

        .logout-btn {
            background-color: #e74c3c;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
        }

        nav {
            background-color: #34495e;
            padding: 15px 20px;
            display: flex;
            gap: 15px;
        }

        nav a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            padding: 8px 12px;
            background-color: #2ecc71;
            border-radius: 6px;
        }

        nav a:hover {
            background-color: #27ae60;
        }

        .dashboard-container {
            display: flex;
        }

        .left-panel {
            width: 220px;
            background-color: #ecf0f1;
            padding: 20px;
            border-right: 2px solid #bdc3c7;
        }

        .left-panel h3 {
            margin-top: 0;
        }

        .category {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
        }

        .fiction { background-color: #d1c4e9; color: #4a148c; }
        .science { background-color: #c8e6c9; color: #1b5e20; }
        .maths { background-color: #ffccbc; color: #bf360c; }

        .category a {
            text-decoration: none;
            display: block;
            color: inherit;
        }

        .main-content {
            flex-grow: 1;
            padding: 30px;
        }

        .book-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .book {
            background-color: #fff;
            border: 2px solid #ddd;
            padding: 15px;
            border-radius: 8px;
            width: 160px;
            height: 180px;
            box-shadow: 2px 2px 8px rgba(0,0,0,0.1);
            text-align: center;
            font-weight: bold;
        }

        h2 {
            color: #2c3e50;
        }

        .no-books {
            color: #888;
            font-style: italic;
        }
    </style>
</head>
<body>

<header>
    <h1>📘 Admin Dashboard</h1>
    <a href="logout.jsp" class="logout-btn">Logout</a>
</header>

<nav>
    <a href="viewBooks.jsp">📚 View Books</a>
    <a href="addBook.jsp">➕ Add Book</a>
    <a href="deleteBook.jsp">❌ Delete Book</a>
    <a href="ViewUsersServlet">👥 View All Users</a>
</nav>

<div class="dashboard-container">

    <!-- LEFT CATEGORY PANEL -->
    <div class="left-panel">
        <h3>Categories</h3>
        <%
            Set<String> categories = new HashSet<>();

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, dbUser, dbPass);
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT DISTINCT category FROM books");

                while (rs.next()) {
                    String cat = rs.getString("category");
                    if (cat != null && !cat.trim().isEmpty()) {
                        categories.add(cat.trim().toLowerCase());
                    }
                }

                // Ensure default categories appear
                String[] defaultCategories = {"fiction", "science", "maths"};
                for (String defCat : defaultCategories) {
                    categories.add(defCat);
                }

                for (String cat : categories) {
                    String className = cat.toLowerCase();
        %>
                    <div class="category <%= className %>">
                        <a href="adminDashboard.jsp?category=<%= cat %>">
                            <%= cat.substring(0,1).toUpperCase() + cat.substring(1) %>
                        </a>
                    </div>
        <%
                }
            } catch(Exception e) {
                out.println("<p style='color:red;'>Error loading categories: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception ignore) {}
                if (stmt != null) try { stmt.close(); } catch (Exception ignore) {}
                if (conn != null) try { conn.close(); } catch (Exception ignore) {}
            }
        %>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <h2>
            <%
                if (selectedCategory != null) {
                    out.print(selectedCategory.substring(0,1).toUpperCase() + selectedCategory.substring(1) + " Books");
                } else {
                    out.print("All Books");
                }
            %>
        </h2>

        <div class="book-grid">
            <%
                try {
                    conn = DriverManager.getConnection(url, dbUser, dbPass);
                    stmt = conn.createStatement();
                    String sql = "SELECT * FROM books";
                    if (selectedCategory != null && !selectedCategory.trim().isEmpty()) {
                        sql += " WHERE category='" + selectedCategory + "'";
                    }
                    rs = stmt.executeQuery(sql);

                    boolean hasBooks = false;

                    while (rs.next()) {
                        hasBooks = true;
                        String title = rs.getString("title");
                        String author = rs.getString("author");
            %>
                        <div class="book">
                            <%= title %><br/>
                            <small><%= author %></small>
                        </div>
            <%
                    }

                    if (!hasBooks) {
            %>
                        <p class="no-books">No books available in this category.</p>
            <%
                    }
                } catch(Exception e) {
                    out.println("<p style='color:red;'>Error loading books: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (Exception ignore) {}
                    if (stmt != null) try { stmt.close(); } catch (Exception ignore) {}
                    if (conn != null) try { conn.close(); } catch (Exception ignore) {}
                }
            %>
        </div>
    </div>

</div>

</body>
</html>
