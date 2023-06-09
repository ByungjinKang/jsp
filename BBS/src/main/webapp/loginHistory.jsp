<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>로그인 기록</title>
</head>
<body>
<%
    // 관리자 인증 체크 (예: 세션 또는 로그인 상태 확인)
    boolean isAdmin = false; // 관리자 여부 확인

    // 로그인 세션에서 userID 가져오기
    String userID = (String) session.getAttribute("userID");

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

        // 사용자의 Admin 속성값 조회
        String selectAdminSql = "SELECT Admin FROM User WHERE User_ID = ?";
        pstmt = conn.prepareStatement(selectAdminSql);
        pstmt.setString(1, userID);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            int adminValue = rs.getInt("Admin");
            isAdmin = (adminValue == 1); // Admin 속성값이 1이면 isAdmin을 true로 설정
        }

        if (isAdmin) {
            // 로그인 기록 조회
            String selectLoginHistorySql = "SELECT * FROM LoginHistory";
            pstmt = conn.prepareStatement(selectLoginHistorySql);
            rs = pstmt.executeQuery();

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
                        <a class="navbar-brand" href="#">로그인 기록</a>
                    </div>

                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <ul class="nav navbar-nav">
                            <li><a href="adminPage.jsp">게시판 관리</a></li>
                            <li><a href="main.jsp">메인으로 돌아가기</a></li>
                        </ul>

                        <ul class="nav navbar-nav navbar-right">
                            <li><a href="#">관리자</a></li>
                            <li><a href="logoutAction.jsp">로그아웃</a></li>
                        </ul>
                    </div>
                </div>
            </nav>

            <div class="container">
                <h3>로그인 기록</h3>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>로그인 기록 ID</th>
                            <th>사용자 ID</th>
                            <th>로그인 시간</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% while (rs.next()) { %>
                            <tr>
                                <td><%= rs.getInt("LOGH_code") %></td>
                                <td><%= rs.getInt("User_ID") %></td>
                                <td><%= rs.getTimestamp("LOGTIME") %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
            <script src="js/bootstrap.js"></script>
<%
        } else {
            // 관리자 인증 실패 시 처리
            response.sendRedirect("login.jsp"); // 로그인 페이지로 리다이렉트
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
