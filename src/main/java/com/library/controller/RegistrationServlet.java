package com.library.controller;

import com.library.model.StudentMember;
import java.io.IOException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get the data from the JSP form
        String name = request.getParameter("fullname");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        String sid = request.getParameter("sid");

        try {
            // 2. Load the MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 3. Connect to the Database (SSL FIX ADDED HERE)
            // Note: ?useSSL=false&allowPublicKeyRetrieval=true added to the URL
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/library_db?useSSL=false&allowPublicKeyRetrieval=true",
                    "root",
                    "1234");

            // 4. Generate a unique Member ID and Hash the Password
            String memberId = "MEM-" + UUID.randomUUID().toString().substring(0, 8);
            String passwordHash = hashPassword(pass);

            // 5. Create the OOP Object
            StudentMember newStudent = new StudentMember(memberId, name, email, passwordHash, sid);

            // 6. Save to Database (SQL)
            // Added 'role' column with default value 'STUDENT' just in case your DB needs it
            String sql = "INSERT INTO members (member_id, full_name, email, password_hash, student_id, role) VALUES (?, ?, ?, ?, ?, 'STUDENT')";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newStudent.getMemberId());
            ps.setString(2, newStudent.getFullName());
            ps.setString(3, newStudent.getEmail());
            ps.setString(4, newStudent.getPasswordHash());
            ps.setString(5, newStudent.getStudentId());

            ps.executeUpdate();
            con.close();

            // 7. Success! Redirect to Login Page
            // Instead of just showing text, we send them to login
            response.sendRedirect("login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            // If error, show it on screen
            response.setContentType("text/html");
            response.getWriter().println("<h3>Registration Error: " + e.getMessage() + "</h3>");
            response.getWriter().println("<p>Check your console (IntelliJ) for more details.</p>");
        }
    }

    // Helper method to hash password
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}