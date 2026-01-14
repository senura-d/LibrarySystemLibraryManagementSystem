<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    // 1. Session Check (Login වෙලාද බලනවා)
    if (session.getAttribute("userEmail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Servlet එකෙන් එවන දත්ත ගන්නවා
    String studentId = (String) request.getAttribute("studentId");
    String userName = (String) request.getAttribute("userName");
    String userEmail = (String) request.getAttribute("userEmail");

    // Null check (Error එන එක නවත්තන්න)
    if (studentId == null) studentId = "Loading...";
    if (userName == null) userName = "Student";
    if (userEmail == null) userEmail = (String) session.getAttribute("userEmail");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My History - Library System</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #4F46E5; --bg-color: #f3f4f6; --card-bg: #ffffff; --text-dark: #1f2937; --text-light: #6b7280; }
        body { font-family: 'Poppins', sans-serif; background-color: var(--bg-color); margin: 0; padding: 20px; color: var(--text-dark); }
        .container { max-width: 90%; margin: 0 auto; padding-bottom: 50px; }

        /* --- Profile Section Styles --- */
        .profile-header { background: var(--card-bg); padding: 30px; border-radius: 20px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .profile-content { display: flex; align-items: flex-start; gap: 30px; }

        /* Image */
        .profile-img-container { position: relative; width: 100px; height: 100px; flex-shrink: 0; }
        .profile-img { width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 3px solid #e0e7ff; }

        /* Form Layout */
        .profile-details-form { flex-grow: 1; display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .detail-item { display: flex; flex-direction: column; }
        .detail-label { font-size: 12px; color: var(--text-light); margin-bottom: 5px; font-weight: 600; }
        .detail-value { font-size: 15px; font-weight: 500; padding: 8px 0; }

        /* Inputs (Edit Mode) */
        .form-input {
            padding: 8px 12px; border: 2px solid #e0e7ff; border-radius: 8px;
            font-family: inherit; font-size: 14px; width: 100%; box-sizing: border-box;
            transition: 0.3s;
        }
        .form-input:focus { border-color: var(--primary); outline: none; }

        /* Buttons */
        .btn { padding: 8px 16px; border-radius: 8px; border: none; font-size: 13px; font-weight: 500; cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; justify-content: center; gap: 5px; text-decoration: none;}
        .btn-edit { background-color: #e0e7ff; color: var(--primary); }
        .btn-edit:hover { background-color: #c7d2fe; }
        .btn-save { background-color: #10b981; color: white; }
        .btn-save:hover { background-color: #059669; }
        .btn-cancel { background-color: #ef4444; color: white; }
        .btn-cancel:hover { background-color: #dc2626; }
        .btn-pdf { background-color: var(--primary); color: white; margin-left: auto; }

        /* --- Tables Styles --- */
        .content-grid { display: grid; grid-template-columns: 3fr 1fr; gap: 20px; align-items: stretch; }
        .card-section { background: var(--card-bg); padding: 25px; border-radius: 16px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 20px; }
        h3 { margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px; font-size: 16px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #f0f0f0; font-size: 13px; }
        th { color: #888; font-weight: 500; }

        /* Badges */
        .badge { padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 600; }
        .badge-returned { background: #d1fae5; color: #065f46; }
        .badge-borrowed, .badge-booked { background: #fef3c7; color: #92400e; }
        .badge-overdue, .badge-cancelled { background: #fee2e2; color: #991b1b; }

        /* QR Section */
        .qr-section { background: var(--card-bg); padding: 25px; border-radius: 16px; text-align: center; box-shadow: 0 4px 6px rgba(0,0,0,0.05); height: fit-content; }
        .qr-box { background: #f8fafc; padding: 10px; border-radius: 12px; margin-top: 15px; border: 2px dashed #cbd5e1; display: inline-block; }

        /* Helper for Toggle */
        .edit-mode { display: none; }
    </style>
</head>
<body>

<div class="container">

    <div class="profile-header">
        <form action="updateProfile" method="post" enctype="multipart/form-data">

            <div class="header-top" style="display: flex; align-items: center; margin-bottom: 25px;">
                <div class="profile-title" style="font-size: 18px; font-weight: 500;">Student Profile</div>

                <div style="display: flex; gap: 10px; margin-left: auto;">
                    <button type="button" class="btn btn-edit view-mode" onclick="toggleEditMode()">
                        ✏️ Edit Profile
                    </button>

                    <div class="edit-mode" style="display: none; gap: 10px;">
                        <button type="submit" class="btn btn-save">💾 Save Changes</button>
                        <button type="button" class="btn btn-cancel" onclick="toggleEditMode()">❌ Cancel</button>
                    </div>

                    <button type="button" class="btn btn-pdf" onclick="window.print()">📄 Print</button>
                </div>
            </div>

            <div class="profile-content">
                <div class="profile-img-container">
                    <img src="ProfileImageServlet?id=<%= studentId %>" alt="Profile" class="profile-img">
                </div>

                <div class="profile-details-form">

                    <div class="detail-item">
                        <span class="detail-label">Student ID</span>
                        <span class="detail-value" style="color: #888;"><%= studentId %></span>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Email Address</span>
                        <span class="detail-value view-mode" style="color: #555;"><%= userEmail %></span>
                        <div class="edit-mode" style="display: none;">
                            <input type="email" name="email" value="<%= userEmail %>" class="form-input" required>
                        </div>
                    </div>

                    <div class="detail-item">
                        <span class="detail-label">Full Name</span>
                        <span class="detail-value view-mode"><%= userName %></span>
                        <div class="edit-mode" style="display: none;">
                            <input type="text" name="name" value="<%= userName %>" class="form-input" required>
                        </div>
                    </div>

                    <div class="detail-item edit-mode" style="display: none;">
                        <span class="detail-label" style="color: var(--primary);">New Password</span>
                        <input type="password" name="password" placeholder="Leave blank to keep current" class="form-input">
                    </div>

                    <div class="detail-item edit-mode" style="display: none; grid-column: span 2;">
                        <span class="detail-label" style="color: var(--primary);">Change Profile Photo</span>
                        <input type="file" name="photo" accept="image/*" class="form-input">
                    </div>

                </div>
            </div>
        </form>
    </div>

    <div class="content-grid">
        <div class="main-content">

            <div class="card-section">
                <h3>📚 Book Transactions</h3>
                <table>
                    <thead>
                    <tr>
                        <th>Book Title</th>
                        <th>Borrow Date</th>
                        <th>Return Date</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Map<String, String>> bookHistory = (List<Map<String, String>>) request.getAttribute("historyList");
                        if (bookHistory != null && !bookHistory.isEmpty()) {
                            for (Map<String, String> record : bookHistory) {
                                String status = record.get("status");
                                String badgeClass = "badge-borrowed";
                                if("RETURNED".equalsIgnoreCase(status)) badgeClass = "badge-returned";
                                if("OVERDUE".equalsIgnoreCase(status)) badgeClass = "badge-overdue";
                    %>
                    <tr>
                        <td style="font-weight: 600;"><%= record.get("bookName") %></td>
                        <td><%= record.get("borrowDate") %></td>
                        <td><%= record.get("returnDate") != null ? record.get("returnDate") : "-" %></td>
                        <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                    </tr>
                    <%      }
                    } else {
                    %>
                    <tr><td colspan="4" style="text-align:center; color:#888; padding: 20px;">No book borrowing history found.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <div class="card-section">
                <h3>🏢 Study Room Bookings</h3>
                <table>
                    <thead>
                    <tr>
                        <th>Room Name</th>
                        <th>Date</th>
                        <th>Time Slot</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Map<String, String>> roomList = (List<Map<String, String>>) request.getAttribute("roomList");
                        if (roomList != null && !roomList.isEmpty()) {
                            for (Map<String, String> room : roomList) {
                                String rStatus = room.get("status");
                                String rBadge = "badge-booked";
                                if("COMPLETED".equalsIgnoreCase(rStatus)) rBadge = "badge-returned";
                                if("CANCELLED".equalsIgnoreCase(rStatus)) rBadge = "badge-cancelled";
                    %>
                    <tr>
                        <td style="font-weight:600; color: #4F46E5;"><%= room.get("roomName") %></td>
                        <td><%= room.get("bookingDate") %></td>
                        <td><%= room.get("timeSlot") %></td>
                        <td><span class="badge <%= rBadge %>"><%= rStatus %></span></td>
                    </tr>
                    <%      }
                    } else {
                    %>
                    <tr><td colspan="4" style="text-align:center; color:#888; padding: 20px;">No room bookings found.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

        </div>

        <div class="qr-section">
            <h3>Member ID</h3>
            <p style="font-size:12px; color:#888;">Use this for Access</p>
            <a href="QRServlet?id=<%= studentId %>" download="MemberID_<%= studentId %>.png">
                <div class="qr-box">
                    <img src="QRServlet?id=<%= studentId %>" width="150" height="150" alt="QR">
                </div>
            </a>
            <p style="margin-top:15px; font-weight:bold; font-size: 18px; color:#4F46E5;">
                <%= studentId %>
            </p>
        </div>
    </div>
</div>

<script>
    function toggleEditMode() {
        const viewElements = document.querySelectorAll('.view-mode');
        const editElements = document.querySelectorAll('.edit-mode');


        const isEditing = editElements[0].style.display !== 'none';

        if (isEditing) {

            viewElements.forEach(el => el.style.display = 'block');
            editElements.forEach(el => el.style.display = 'none');
        } else {

            viewElements.forEach(el => el.style.display = 'none');
            editElements.forEach(el => el.style.display = 'block');


            const flexContainers = document.querySelectorAll('.edit-mode[style*="gap"]');
            flexContainers.forEach(el => el.style.display = 'flex');
        }
    }
</script>

</body>
</html>