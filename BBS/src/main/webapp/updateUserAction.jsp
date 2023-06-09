<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
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

    // 폼 데이터 가져오기
    String nickname = request.getParameter("nickname");
    String oldPw = request.getParameter("oldPw");
    String newPw = request.getParameter("newPw");
    String newPwConfirm = request.getParameter("newPwConfirm");
    String userName = request.getParameter("username");
    String ph = request.getParameter("ph");
    String ad = request.getParameter("ad");

    // 데이터베이스 연결
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 기존 비밀번호 확인
        String checkQuery = "SELECT PW FROM User WHERE User_ID = ?";
        pstmt = conn.prepareStatement(checkQuery);
        pstmt.setString(1, userID);
        ResultSet checkRs = pstmt.executeQuery();

        if (checkRs.next()) {
            String dbPw = checkRs.getString("PW");

            if (dbPw.equals(oldPw)) {
                // 새 비밀번호 확인
                if (newPw.equals(newPwConfirm)) {
                    // 회원 정보 업데이트 쿼리
                    String updateQuery = "UPDATE User SET Nickname = ?, PW = ?, User_name = ?, PH = ?, AD = ? WHERE User_ID = ?";
                    pstmt = conn.prepareStatement(updateQuery);
                    pstmt.setString(1, nickname);
                    pstmt.setString(2, newPw);
                    pstmt.setString(3, userName);
                    pstmt.setString(4, ph);
                    pstmt.setString(5, ad);
                    pstmt.setString(6, userID);
                    int rows = pstmt.executeUpdate();

                    if (rows > 0) {
                        // 회원 정보 수정 성공
                        PrintWriter script = response.getWriter();
                        script.println("<script>");
                        script.println("alert('회원 정보가 수정되었습니다.')");
                        script.println("location.href = 'main.jsp'");
                        script.println("</script>");
                    } else {
                        // 회원 정보 수정 실패
                        PrintWriter script = response.getWriter();
                        script.println("<script>");
                        script.println("alert('회원 정보 수정에 실패했습니다.')");
                        script.println("history.back()");
                        script.println("</script>");
                    }
                } else {
                    // 새 비밀번호와 새 비밀번호 확인이 일치하지 않음
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("alert('새 비밀번호와 새 비밀번호 확인이 일치하지 않습니다.')");
                    script.println("history.back()");
                    script.println("</script>");
                }
            } else {
                // 기존 비밀번호가 일치하지 않음
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('기존 비밀번호가 일치하지 않습니다.')");
                script.println("history.back()");
                script.println("</script>");
            }
        } else {
            // 사용자가 존재하지 않음
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
        if (pstmt != null) {
            pstmt.close();
        }
        if (conn != null) {
            conn.close();
        }
    }
%>

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
</body>
</html>
