<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Issue Book - Admin</title>
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>

    <style>
        body { font-family: Arial, sans-serif; padding: 50px; background-color: #f4f7f6; }
        .container { max-width: 500px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        h2 { text-align: center; color: #333; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 16px; }

        /* Submit Button Style */
        input[type="submit"] { width: 100%; padding: 10px; background-color: #28a745; color: white; border: none; border-radius: 5px; font-size: 18px; cursor: pointer; margin-top: 10px; }
        input[type="submit"]:hover { background-color: #218838; }

        /* Camera Button Style */
        .cam-btn { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; margin-bottom: 10px; }
        .cam-btn:hover { background-color: #0056b3; }

        /* Success Message Box */
        .success-msg {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
            border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>📚 Issue Book</h2>

    <%
        String status = request.getParameter("status");
        if ("success".equals(status)) {
    %>
    <div class="success-msg">
        ✅ <b>Success!</b> The book has been issued successfully.
    </div>
    <%
        }
    %>

    <div id="reader" style="width: 100%; display:none; margin-bottom: 15px;"></div>

    <button type="button" class="cam-btn" onclick="startCamera()">📸 Open Camera</button>

    <form action="IssueBookServlet" method="post">

        <div class="form-group">
            <label>Student ID (Scan QR Here):</label>
            <input type="text" name="studentId" id="studentId" placeholder="Click 'Open Camera' or Type ID" required>
        </div>

        <div class="form-group">
            <label>Book ID:</label>
            <input type="text" name="bookId" placeholder="Enter Book ID (e.g., 1)" required>
        </div>

        <input type="submit" value="Issue Book Now">
    </form>
</div>

<script>
    function startCamera() {
        document.getElementById("reader").style.display = "block";

        const html5QrCode = new Html5Qrcode("reader");

        html5QrCode.start(
            { facingMode: "environment" },
            {
                fps: 10,
                qrbox: 250
            },
            (decodedText, decodedResult) => {
                console.log(`Code matched = ${decodedText}`, decodedResult);
                document.getElementById("studentId").value = decodedText;

                html5QrCode.stop().then((ignore) => {
                    document.getElementById("reader").style.display = "none";
                }).catch((err) => {
                    console.log("Stop failed: ", err);
                });
            },
            (errorMessage) => {
                // scanning...
            })
            .catch((err) => {
                alert("Error starting camera: " + err);
            });
    }
</script>

</body>
</html>