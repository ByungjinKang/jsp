<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>사용자 정보 수정</title>
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

            // 사용자 정보 조회
            int userID = Integer.parseInt(request.getParameter("userID"));
            String selectUserSql = "SELECT * FROM User WHERE User_ID = ?";
            pstmt = conn.prepareStatement(selectUserSql);
            pstmt.setInt(1, userID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
%>
                <nav class="navbar navbar-default">
                    <div class="container-fluid">
                        <div class="navbar-header">
                            <a class="navbar-brand" href="#">사용자 정보 수정</a>
                        </div>

                        <div class="collapse navbar-collapse">
                            <ul class="nav navbar-nav navbar-right">
                                <li><a href="adminPage.jsp">관리자 페이지로 돌아가기</a></li>
                            </ul>
                        </div>
                    </div>
                </nav>

                <div class="container">
                    <h3>사용자 정보 수정</h3>
                    <form action="editUserAction.jsp" method="POST">
                        <input type="hidden" name="userID" value="<%= rs.getInt("User_ID") %>">
                        <div class="form-group">
                            <label for="password">비밀번호</label>
                            <input type="password" class="form-control" id="password" name="password" value="<%= rs.getString("PW") %>" required>
                        </div>
                        <div class="form-group">
                            <label for="name">이름</label>
                            <input type="text" class="form-control" id="name" name="name" value="<%= rs.getString("User_name") %>" required>
                        </div>
                        <div class="form-group">
                            <label for="sex">성별</label>
                            <input type="text" class="form-control" id="sex" name="sex" value="<%= rs.getString("Sex") %>" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">전화번호</label>
                            <input type="text" class="form-control" id="phone" name="phone" value="<%= rs.getString("PH") %>" required>
                        </div>
                        <div class="form-group">
                            <label for="address">주소</label>
                            <input type="text" class="form-control" id="address" name="address" value="<%= rs.getString("AD") %>" required>
                        </div>
                        <div class="form-group">
                            <label for="nickname">닉네임</label>
                            <input type="text" class="form-control" id="nickname" name="nickname" value="<%= rs.getString("NickName") %>" required>
                        </div>
                        <div class="form-group">
                            <label for="admin">관리자 여부</label>
                            <input type="text" class="form-control" id="admin" name="admin" value="<%= rs.getString("Admin") %>" required>
                        </div>
                        <div class="form-group">
                            <label for="email">이메일</label>
                            <input type="email" class="form-control" id="email" name="email" value="<%= rs.getString("Email") %>" required>
                        </div>

                        <button type="submit" class="btn btn-primary">수정</button>
                    </form>
                </div>

                <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
                <script src="js/bootstrap.js"></script>
<%
            } else {
                out.println("<p>사용자 정보를 찾을 수 없습니다.</p>");
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
    } else {
        // 관리자 인증 실패 시 처리
        response.sendRedirect("login.jsp"); // 로그인 페이지로 리다이렉트
    }
%>
</body>
</html>
