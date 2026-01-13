package com.library.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/history")
public class HistoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();

        // 1. හරියටම LoginServlet එකේ නම ("userEmail") පාවිච්චි කරනවා
        String email = (String) session.getAttribute("userEmail");

        // Login වෙලා නැත්නම් Login එකට යවනවා
        if (email == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String studentId = "";
        String fullName = (String) session.getAttribute("userName"); // Login එකෙන් නම Save කරපු නිසා කෙලින්ම ගන්නවා
        if(fullName == null) fullName = "Student";

        List<Map<String, String>> bookHistory = new ArrayList<>();
        List<Map<String, String>> roomHistory = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "1234");

            // 2. Email එකෙන් Student ID එක හොයාගන්නවා
            String sqlFindId = "SELECT student_id FROM members WHERE email = ?";
            PreparedStatement stmtId = conn.prepareStatement(sqlFindId);
            stmtId.setString(1, email);
            ResultSet rsId = stmtId.executeQuery();

            if (rsId.next()) {
                studentId = rsId.getString("student_id");
            }

            if (studentId == null || studentId.isEmpty()) {
                studentId = "Not Found";
            } else {

                // 3. Books History
                String sqlBooks = "SELECT b.title, br.borrow_date, br.return_date, br.status " +
                        "FROM borrow_records br " +
                        "JOIN books b ON br.book_id = b.book_id " +
                        "WHERE br.student_id = ? ORDER BY br.borrow_date DESC";

                PreparedStatement stmtBooks = conn.prepareStatement(sqlBooks);
                stmtBooks.setString(1, studentId);
                ResultSet rsBooks = stmtBooks.executeQuery();

                while (rsBooks.next()) {
                    Map<String, String> record = new HashMap<>();
                    record.put("bookName", rsBooks.getString("title"));
                    record.put("borrowDate", rsBooks.getString("borrow_date"));
                    record.put("returnDate", rsBooks.getString("return_date"));
                    record.put("status", rsBooks.getString("status"));
                    bookHistory.add(record);
                }

                // 4. Room Booking History
                String sqlRooms = "SELECT r.room_name, rb.booking_date, rb.time_slot, rb.status " +
                        "FROM room_booking rb " +
                        "JOIN rooms r ON rb.room_id = r.room_id " +
                        "WHERE rb.student_id = ? ORDER BY rb.booking_date DESC";

                PreparedStatement stmtRooms = conn.prepareStatement(sqlRooms);
                stmtRooms.setString(1, studentId);
                ResultSet rsRooms = stmtRooms.executeQuery();

                while (rsRooms.next()) {
                    Map<String, String> roomRecord = new HashMap<>();
                    roomRecord.put("roomName", rsRooms.getString("room_name"));
                    roomRecord.put("bookingDate", rsRooms.getString("booking_date"));
                    roomRecord.put("timeSlot", rsRooms.getString("time_slot"));
                    roomRecord.put("status", rsRooms.getString("status"));
                    roomHistory.add(roomRecord);
                }
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // දත්ත යවනවා
        request.setAttribute("studentId", studentId);
        request.setAttribute("userName", fullName);
        request.setAttribute("userEmail", email); // Email එකත් යවනවා
        request.setAttribute("historyList", bookHistory);
        request.setAttribute("roomList", roomHistory);

        request.getRequestDispatcher("history.jsp").forward(request, response);
    }
}
