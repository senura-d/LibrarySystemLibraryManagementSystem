package com.library.controller;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ProfileImageServlet")
public class ProfileImageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String studentId = request.getParameter("id");

        if (studentId == null || studentId.isEmpty()) return;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Database සම්බන්ධතාවය (ඔයාගේ තොරතුරු වලට අනුව වෙනස් කරන්න)
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "1234");

            // Database එකේ ඇති රූපය (BLOB) ලබා ගැනීම
            PreparedStatement ps = con.prepareStatement("SELECT profile_image FROM members WHERE student_id = ?");
            ps.setString(1, studentId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                byte[] imgData = rs.getBytes("profile_image");

                if (imgData != null && imgData.length > 0) {
                    response.setContentType("image/jpeg");
                    OutputStream os = response.getOutputStream();
                    os.write(imgData);
                    os.flush();
                    os.close();
                } else {
                    // රූපයක් නොමැති නම් පෙන්වන Default රූපය
                    response.sendRedirect("https://cdn-icons-png.flaticon.com/512/3135/3135715.png");
                }
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}