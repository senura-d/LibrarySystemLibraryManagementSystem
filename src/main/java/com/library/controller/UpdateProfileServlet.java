package com.library.controller;

import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/updateProfile")
@MultipartConfig(maxFileSize = 16177215)
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("memberId");
        String userEmail = (String) session.getAttribute("userEmail");

        // Form එකෙන් දත්ත ගන්නවා
        String newName = request.getParameter("name");
        String newEmail = request.getParameter("email");
        String newPass = request.getParameter("password");

        InputStream inputStream = null;
        Part filePart = request.getPart("photo");
        if (filePart != null && filePart.getSize() > 0) {
            inputStream = filePart.getInputStream();
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "1234");

            // 1. Session ID නැත්නම් Email එකෙන් හොයාගන්නවා
            if (studentId == null && userEmail != null) {
                PreparedStatement psFindId = con.prepareStatement("SELECT student_id FROM members WHERE email = ?");
                psFindId.setString(1, userEmail);
                ResultSet rsId = psFindId.executeQuery();
                if (rsId.next()) {
                    studentId = rsId.getString("student_id");
                    session.setAttribute("memberId", studentId);
                }
                psFindId.close();
            }

            if (studentId == null) {
                response.sendRedirect("login.jsp");
                con.close();
                return;
            }

            // 2. Password Logic
            String finalPasswordHash = "";

            if (newPass == null || newPass.trim().isEmpty()) {
                // Password හිස් නම් පරණ එකම ගන්නවා
                PreparedStatement psGetPass = con.prepareStatement("SELECT password_hash FROM members WHERE student_id = ?");
                psGetPass.setString(1, studentId);
                ResultSet rsPass = psGetPass.executeQuery();
                if (rsPass.next()) {
                    finalPasswordHash = rsPass.getString("password_hash");
                }
                psGetPass.close();
            } else {
                // අලුත් එකක් ගැහුවොත් Hash කරනවා
                finalPasswordHash = hashPassword(newPass);
            }

            // 3. Update Query (මෙතන තමයි Error එක හැදුවේ: 'name' -> 'full_name')
            String sql;
            PreparedStatement ps;

            if (inputStream != null) {
                // Photo එකත් එක්ක
                sql = "UPDATE members SET full_name = ?, email = ?, password_hash = ?, profile_image = ? WHERE student_id = ?";
                ps = con.prepareStatement(sql);
                ps.setString(1, newName);
                ps.setString(2, newEmail);
                ps.setString(3, finalPasswordHash);
                ps.setBlob(4, inputStream);
                ps.setString(5, studentId);
            } else {
                // Photo නැතුව
                sql = "UPDATE members SET full_name = ?, email = ?, password_hash = ? WHERE student_id = ?";
                ps = con.prepareStatement(sql);
                ps.setString(1, newName);
                ps.setString(2, newEmail);
                ps.setString(3, finalPasswordHash);
                ps.setString(4, studentId);
            }

            int updated = ps.executeUpdate();

            if (updated > 0) {
                // Session එකත් Update කරනවා
                session.setAttribute("userName", newName);
                session.setAttribute("userEmail", newEmail);
                response.sendRedirect("history");
            } else {
                response.getWriter().println("Update Failed!");
            }
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) hexString.append(String.format("%02x", b));
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}