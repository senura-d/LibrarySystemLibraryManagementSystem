package com.library.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/IssueBookServlet")
public class IssueBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        String studentId = request.getParameter("studentId");
        String bookId = request.getParameter("bookId");

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/library_db?useSSL=false&allowPublicKeyRetrieval=true",
                    "root",
                    "1234");


            String sql = "INSERT INTO borrow_records (student_id, book_id) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, studentId);
            ps.setInt(2, Integer.parseInt(bookId));

            int result = ps.executeUpdate();

            con.close();


            if (result > 0) {

                response.sendRedirect("issue_book.jsp?status=success");
            } else {
                response.sendRedirect("issue_book.jsp?status=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect("issue_book.jsp?status=error");
        }
    }
}