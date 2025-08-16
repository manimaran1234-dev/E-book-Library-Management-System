<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registration Success</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #74ebd5, #acb6e5);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .success-box {
            background: #fff;
            padding: 40px 30px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        h2 {
            color: #333;
            margin-bottom: 15px;
        }

        p {
            color: #666;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #fff;
            background: #50c9c3;
            padding: 10px 20px;
            border-radius: 6px;
        }

        a:hover {
            background: #3fc0b8;
        }
    </style>
</head>
<body>
    <div class="success-box">
        <h2>Registration Successful!</h2>
        <p>You can now login with your credentials.</p>
        <a href="login.jsp">Go to Login</a>
    </div>
</body>
</html>
>