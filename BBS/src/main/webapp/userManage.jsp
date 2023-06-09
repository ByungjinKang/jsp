<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>사용자 관리</title>
</head>
<body>
<%
    // 관리자 인증 체크 (예: 세션 또는 로그인 상태 확인)
    boolean isAdmin = true; // 관리자 여부 확인

    if (isAdmin) {
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

            // 사용자 목록 조회
            String selectUserSql = "SELECT * FROM User";
            pstmt = conn.prepareStatement(selectUserSql);
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
                        <a class="navbar-brand" href="#">사용자 관리</a>
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
                <h3>사용자 목록</h3>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>사용자 ID</th>
                            <th>비밀번호</th>
                            <th>이름</th>
                            <th>성별</th>
                            <th>전화번호</th>
                            <th>주소</th>
                            <th>닉네임</th>
                            <th>관리자</th>
                            <th>이메일</th>
                            <th>작업</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% while (rs.next()) { %>
                            <tr>
                                <td><%= rs.getInt("User_ID") %></td>
                                <td><%= rs.getString("PW") %></td>
                                <td><%= rs.getString("User_name") %></td>
                                <td><%= rs.getString("Sex") %></td>
                                <td><%= rs.getString("PH") %></td>
                                <td><%= rs.getString("AD") %></td>
                                <td><%= rs.getString("NickName") %></td>
                                <td><%= rs.getString("Admin") %></td>
                                <td><%= rs.getString("Email") %></td>
                                <td>
                                    <a href="editUser.jsp?userID=<%= rs.getInt("User_ID") %>" class="btn btn-primary btn-sm">수정</a>
                                    <a href="deleteUserAction.jsp?userID=<%= rs.getInt("User_ID") %>" class="btn btn-primary btn-sm" onclick="return confirm('정말로 삭제하시겠습니까?')">삭제</a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
            <script src="js/bootstrap.js"></script>
<%
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
    } else {
        // 관리자 인증 실패 시 처리
        response.sendRedirect("login.jsp"); // 로그인 페이지로 리다이렉트
    }
%>
</body>
</html>
