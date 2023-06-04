<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <title>JSP 게시판 웹 사이트</title>
    <style>
        .container {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <%
        // 세션에서 User_ID 가져오기
        String userID = null;
        String userNickName = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
            // User 테이블에서 NickName 가져오기
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

                String userSql = "SELECT NickName FROM User WHERE User_ID = ?";
                userPstmt = conn.prepareStatement(userSql);
                userPstmt.setString(1, userID);
                userRs = userPstmt.executeQuery();
                if (userRs.next()) {
                    userNickName = userRs.getString("NickName");
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
    %>

    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
            </div>
            <div class="collapse navbar-collapse">
                <ul class="nav navbar-nav navbar-right">
                    <% if (loggedIn) { %>
                        <li><a href="write.jsp">게시글 등록</a></li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                <%= userNickName %><span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a href="logoutAction.jsp">로그아웃</a></li>
                            </ul>
                        </li>
                    <% } else { %>
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h3>게시판</h3>
        <% 
            // JDBC 연결 및 SQL 문 실행 준비
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

                String sql = "SELECT * FROM Post ORDER BY POST_code ASC";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                // 게시글 목록 출력
                int count = 1;
                while (rs.next()) {
                    int postCode = rs.getInt("POST_code");
                    String title = rs.getString("Title");
                    String date = rs.getString("C_Date");
                    String userNickNames = "";
                
                    // User 테이블에서 NickName 가져오기
                    String userSql = "SELECT NickName FROM User WHERE User_ID = ?";
                    PreparedStatement userPstmt = conn.prepareStatement(userSql);
                    userPstmt.setString(1, rs.getString("User_ID"));
                    ResultSet userRs = userPstmt.executeQuery();
                    if (userRs.next()) {
                        userNickNames = userRs.getString("NickName");
                    }
        %>
            <div class="panel panel-default">
                <div class="panel-body">
                    <h4><a href="view.jsp?postCode=<%= postCode %>"><%= count %>. <%= title %></a></h4>
                    <p>작성일: <%= date %></p>
                    <p>작성자: <%= userNickNames %></p>
                </div>
            </div>
        <% 
                count++;
            }
        } catch (Exception e) {
            out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
            out.println(e.toString());
            e.printStackTrace();
        } finally {
            // 자원 해제
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    %>
    </div>
</body>
</html>
