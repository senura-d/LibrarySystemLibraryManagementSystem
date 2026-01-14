<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Recommended Books</title>
    <style>

        body {
            background-color: #ffffff;
            font-family: Arial, sans-serif;
        }


        .recommendation-box {
            width: 300px;
            margin: 50px auto;
            border: 1px solid #ccc;
            padding: 15px;
            border-radius: 8px;
            background-color: #f9f9f9;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .recommendation-box h3 {
            margin-top: 0;
            color: #333;
            text-align: center;
        }

        .recommendation-box ul {
            list-style-type: none;
            padding: 0;
        }

        .recommendation-box li {
            padding: 6px;
            margin-bottom: 5px;
            background-color: #ffffff; /* white book items */
            border-radius: 4px;
        }
    </style>
</head>
<body>

<div class="recommendation-box">
    <h3>Recommended Books</h3>

    <ul>
        <%
            List<String> books = (List<String>) request.getAttribute("recommendations");
            if (books != null) {
                for (String book : books) {
        %>
                    <li><%= book %></li>
        <%
                }
            }
        %>
    </ul>
</div>

</body>
</html>
