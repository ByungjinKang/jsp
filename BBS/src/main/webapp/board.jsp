<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.io.PrintWriter" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>게시판</title>
</head>
<body>
<%
    // 게시판 ID 파라미터 가져오기
    int boardID = Integer.parseInt(request.getParameter("boardID"));

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 게시판 정보 조회
        String selectBoardSql = "SELECT * FROM Board WHERE Board_ID = ?";
        pstmt = conn.prepareStatement(selectBoardSql);
        pstmt.setInt(1, boardID);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String boardName = rs.getString("Board_Name");

            %>
            <nav class="navbar navbar-default">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="#">게시판 - <%= boardName %></a>
                    </div>

                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <ul class="nav navbar-nav">
                            <li><a href="adminPage.jsp">관리자 페이지</a></li>
                        </ul>

                        <ul class="nav navbar-nav navbar-right">
                            <li><a href="#">관리자</a></li>
                            <li><a href="logout.jsp">로그아웃</a></li>
                        </ul>
                    </div>
                </div>
            </nav>

            <div class="container">
                <h3>게시판 - <%= boardName %></h3>
                <!-- 게시판 기능 구현 -->

            </div>

            <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
            <script src="js/bootstrap.js"></script>
        <% } else {
            out.println("<div class=\"container\">");
            out.println("<p>유효하지 않은 게시판입니다.</p>");
            out.println("</div>");
        }
    } catch (Exception e) {
        out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
        out.println(e.toString());
        e.printStackTrace();
    } finally {
        if (rs != null) {
            rs.close();
        }
        if (pstmt != null) {
            pstmt.close();
        }
        if (conn != null) {
            conn.close();
        }
    }
%>
</body>
</html>
