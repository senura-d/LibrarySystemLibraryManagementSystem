<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // 1. කලින් Login වෙලාද කියලා බලනවා
    String studentId = (String) session.getAttribute("memberId");
    if (studentId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String currentName = "";
    String currentPhone = "";
    String currentPass = "";

    // 2. Database එකෙන් දැනට තියෙන විස්තර ටික ගන්නවා
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "1234");

        // student_id එක පාවිච්චි කරලා විස්තර හොයනවා
        PreparedStatement ps = con.prepareStatement("SELECT * FROM members WHERE student_id = ?");
        ps.setString(1, studentId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            currentName = rs.getString("name");
            currentPhone = rs.getString("phone");
            currentPass = rs.getString("password");
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f3f4f6; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .container { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.1); width: 350px; }
        h2 { text-align: center; color: #333; margin-bottom: 20px; }
        label { font-weight: bold; color: #555; display: block; margin-top: 10px; }
        input { width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #4F46E5; color: white; border: none; border-radius: 8px; font-size: 16px; margin-top: 20px; cursor: pointer; transition: 0.3s; }
        button:hover { background: #4338ca; }
        .cancel { background: #ddd; color: #333; margin-top: 10px; text-decoration: none; display: block; text-align: center; padding: 10px; border-radius: 8px; }
        .cancel:hover { background: #bbb; }
    </style>
</head>
<body>

<div class="container">
    <h2>✏️ Edit Profile</h2>

    <form action="updateProfile" method="post">
        <label>Student ID (Cannot Change)</label>
        <input type="text" value="<%= studentId %>" disabled style="background: #e9ecef; color: #777;">

        <label>Full Name</label>
        <input type="text" name="name" value="<%= currentName %>" required>

        <label>Phone Number</label>
        <input type="text" name="phone" value="<%= currentPhone != null ? currentPhone : "" %>">

        <label>Password</label>
        <input type="text" name="password" value="<%= currentPass %>" required>

        <button type="submit">Update Profile</button>
        <a href="history" class="cancel">Cancel</a>
    </form>
</div>

</body>
</html>