<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <link rel="stylesheet" href="./css/3.css">
    <title>회원 정보 수정</title>
</head>
<body>
<%
    // 세션에서 사용자 ID 가져오기
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }

    // 로그인 여부 확인
    if (userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인하세요.')");
        script.println("location.href = 'login.jsp'");
        script.println("</script>");
    }

    // 회원 정보 가져오기
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String nickname = null;
    String userName = null;
    String ph = null;
    String ad = null;

    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 회원 정보 조회 쿼리
        String query = "SELECT Nickname, User_name, PH, AD FROM User WHERE User_ID = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, userID);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            nickname = rs.getString("Nickname");
            userName = rs.getString("User_name");
            ph = rs.getString("PH");
            ad = rs.getString("AD");
        } else {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('유효하지 않은 회원입니다.')");
            script.println("location.href = 'main.jsp'");
            script.println("</script>");
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

<nav class="navbar navbar-default">
    <div class="navbar-header">
        <a class="navbar-brand" href="main.jsp">회원 정보 수정</a>
    </div>
</nav>

<div class="container">
    <div class="row">
        <form method="post" action="updateUserAction.jsp">
            <table class="table table-stripped" style="text-align: center; border: 1px solid #dddddd">
                <thead>
                <tr>
                    <th colspan="2" style="background-color: #eeeeee; text-align: center;">회원 정보 수정 양식</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><input type="text" class="form-control" placeholder="닉네임" name="nickname" value="<%= nickname %>"></td>
                </tr>
                <tr>
                    <td><input type="text" class="form-control" placeholder="이름" name="username" value="<%= userName %>"></td>
                </tr>
                <tr>
                    <td><input type="text" class="form-control" placeholder="전화번호" name="ph" value="<%= ph %>"></td>
                </tr>
                <tr>
                    <td><input type="text" class="form-control" placeholder="주소" name="ad" value="<%= ad %>"></td>
                </tr>
                <tr>
                    <td><input type="password" class="form-control" placeholder="기존 비밀번호" name="oldPw"></td>
                </tr>
                <tr>
                    <td><input type="password" class="form-control" placeholder="새 비밀번호" name="newPw"></td>
                </tr>
                <tr>
                    <td><input type="password" class="form-control" placeholder="새 비밀번호 확인" name="newPwConfirm"></td>
                </tr>
                </tbody>
            </table>
            <input type="submit" class="btn btn-primary pull-right" value="수정">
        </form>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
</body>
</html>
