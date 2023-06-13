<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내가 작성한 글</title>
    <link rel="stylesheet" href="./css/1.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f2f2f2;
            color: #333;
        }

        h1 {
            font-size: 24px;
            margin-bottom: 10px;
            font-family: 'TheJamsil5Bold';
            padding: 10px 5px;
        }

        .post {
            border: 1px solid #ccc;
            padding: 10px;
            margin: 20px 0px;
            background-color: #fff;
        }

        .post h3 {
            font-size: 18px;
            margin: 0;
        }

        .post p {
            margin: 0;
        }

        .follower-count {
            margin-top: 20px;
            font-size: 14px;
            color: #777;
        }

        .button-container {
            margin-top: 20px;
        }

        .button-container button {
            font-size: 14px;
            padding: 5px 10px;
            background-color: #333;
            border: none;
            color: #fff;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <%
        // 이전 페이지에서 전달된 User_ID를 받아옵니다.
        String userID = request.getParameter("User_ID");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet resultSet = null;
        String userNickName = null;
        int followerCount = 0;

        try {
            String driverName = "com.mysql.jdbc.Driver";
            String dbURL = "jdbc:mysql://localhost:3306/jsp41";
            String dbUser = "jsp41";
            String dbPassword = "poiu0987";

            Class.forName(driverName);
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // 유저의 닉네임을 조회합니다.
            String selectUserSql = "SELECT NickName FROM User WHERE User_ID = ?";
            pstmt = conn.prepareStatement(selectUserSql);
            pstmt.setString(1, userID);
            resultSet = pstmt.executeQuery();

            if (resultSet.next()) {
                userNickName = resultSet.getString("NickName");
            }

            // 팔로워 수를 조회합니다.
            String selectFollowerSql = "SELECT COUNT(*) AS FollowerCount FROM Follow WHERE Writer = ?";
            pstmt = conn.prepareStatement(selectFollowerSql);
            pstmt.setString(1, userID);
            resultSet = pstmt.executeQuery();

            if (resultSet.next()) {
                followerCount = resultSet.getInt("FollowerCount");
            }

            // 유저의 닉네임을 제목으로 출력합니다.
            out.println("<h1>" + userNickName + "님이 작성한 글</h1>");

            // 현재 사용자의 작성한 글 목록을 조회합니다.
            String selectSql = "SELECT Post.POST_code, Post.Title, Post.Content, Post.C_Date, Post.M_Date, User.NickName " +
                    "FROM Post " +
                    "JOIN User ON Post.User_ID = User.User_ID " +
                    "WHERE Post.User_ID = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setString(1, userID);
            resultSet = pstmt.executeQuery();

            // 조회 결과를 출력합니다.
            while (resultSet.next()) {
                int postCode = resultSet.getInt("POST_code");
                String title = resultSet.getString("Title");
                String content = resultSet.getString("Content");
                String cDate = resultSet.getString("C_Date");
                String mDate = resultSet.getString("M_Date");
                String authorNickName = resultSet.getString("NickName");

                out.println("<div class='post'>");
                out.println("<h3>글번호: " + postCode + "</h3>");
                out.println("<h3>제목: <a href='view.jsp?postID=" + postCode + "'>" + title + "</a></h3>");
                out.println("<p>내용: " + content + "</p>");
                out.println("<p>작성일: " + cDate + "</p>");
                out.println("<p>수정일: " + mDate + "</p>");
                out.println("<p>작성자: " + authorNickName + "</p>");
                out.println("</div>");
                out.println("<hr>");
            }
        } catch (Exception e) {
            out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
            out.println(e.toString());
            e.printStackTrace();
        } finally {
            if (resultSet != null) {
                resultSet.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    %>

    <div class="follower-count">
        <p>팔로워 수: <%= followerCount %></p>
    </div>

    <div class="button-container">
        <button onclick="goBack()">뒤로 가기</button>
    </div>

    <script>
        function goBack() {
            history.go(-1);
        }
    </script>
</body>
</html>
