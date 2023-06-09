<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <title>JSP 게시판 웹 사이트</title>
</head>
<body>
    <%
        // 세션에서 User_ID 가져오기
        String userID = null;
        String userNickName = null;
        String userAdmin = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
            // User 테이블에서 NickName과 Admin 가져오기
            Connection conn = null;
            PreparedStatement userPstmt = null;
            ResultSet userRs = null;
            try {
                String driverName = "com.mysql.jdbc.Driver";
                String dbURL = "jdbc:mysql://localhost:3306/jsp41";
                String dbUser = "jsp41";
                String dbPassword = "poiu0987";

                Class.forName(driverName);
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                String userSql = "SELECT NickName, Admin FROM User WHERE User_ID = ?";
                userPstmt = conn.prepareStatement(userSql);
                userPstmt.setString(1, userID);
                userRs = userPstmt.executeQuery();
                if (userRs.next()) {
                    userNickName = userRs.getString("NickName");
                    userAdmin = userRs.getString("Admin");
                }
            } catch (Exception e) {
                out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
                out.println(e.toString());
                e.printStackTrace();
            } finally {
                // 자원 해제
                if (userPstmt != null) {
                    userPstmt.close();
                }
                if (userRs != null) {
                    userRs.close();
                }
                if (conn != null) {
                    conn.close();
                }
            }
        }

        // 로그인 여부 확인
        boolean loggedIn = (userID != null && !userID.isEmpty());
        // 관리자 여부 확인
        boolean isAdmin = (userAdmin != null && userAdmin.equals("1"));

        // Board 테이블에서 게시판 정보 가져오기
        Connection conn = null;
        PreparedStatement boardPstmt = null;
        ResultSet boardRs = null;
        try {
            String driverName = "com.mysql.jdbc.Driver";
            String dbURL = "jdbc:mysql://localhost:3306/jsp41";
            String dbUser = "jsp41";
            String dbPassword = "poiu0987";

            Class.forName(driverName);
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String boardSql = "SELECT * FROM Board";
            boardPstmt = conn.prepareStatement(boardSql);
            boardRs = boardPstmt.executeQuery();
        } catch (Exception e) {
            out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
            out.println(e.toString());
            e.printStackTrace();
        }
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
                <a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
            </div>

            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav">
                    <li class="active"><a href="main.jsp">메인</a></li>
                    <% if (boardRs != null) { %>
                        <% while (boardRs.next()) { %>
                            <li><a href="bbs.jsp?boardID=<%= boardRs.getString("Board_ID") %>"><%= boardRs.getString("Board_Name") %></a></li>
                        <% } %>
                    <% } %>
                </ul>
                <% if (userID == null) { %>
                    <ul class="nav navbar-nav navbar-right">
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">접속하기<span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="login.jsp">로그인</a></li>
                                <li><a href="join.jsp">회원가입</a></li>
                            </ul>
                        </li>
                    </ul>
                <% } else { %>
                    <ul class="nav navbar-nav navbar-right">
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                <%= userNickName %><span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a href="logoutAction.jsp">로그아웃</a></li>
                                <li><a href="updateUser.jsp">회원 정보 수정</a></li>
                            </ul>
                        </li>
                        <% if (isAdmin) { %>
                            <li><a href="adminPage.jsp">관리자 페이지</a></li>
                        <% } %>
                    </ul>
                <% } %>
            </div>
        </div>
    </nav>

    <!-- <div class="container">
        <h2>게시판 종류</h2>
        <% if (boardRs != null) { %>
            <ul>
                <% while (boardRs.next()) { %>
                    <li>
                        <a href="bbs.jsp?boardID=<%= boardRs.getString("Board_ID") %>"><%= boardRs.getString("Board_Name") %></a>
                    </li>
                <% } %>
            </ul>
        <% } else { %>
            <p>게시판이 존재하지 않습니다.</p>
        <% } %>
    </div> -->

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>
