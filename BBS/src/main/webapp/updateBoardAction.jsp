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
    <title>게시판 수정 처리</title>
</head>
<body>
<%
    // 관리자 인증 체크 (예: 세션 또는 로그인 상태 확인)
    boolean isAdmin = true; // 관리자 여부 확인

    if (isAdmin) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            String driverName = "com.mysql.jdbc.Driver";
            String dbURL = "jdbc:mysql://localhost:3306/jsp41";
            String dbUser = "jsp41";
            String dbPassword = "poiu0987";

            Class.forName(driverName);
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            int boardID = Integer.parseInt(request.getParameter("boardID"));
            String boardName = request.getParameter("boardName");

            // 게시판 이름 업데이트
            String updateSql = "UPDATE Board SET Board_Name = ? WHERE Board_ID = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, boardName);
            pstmt.setInt(2, boardID);
            int result = pstmt.executeUpdate();

            if (result > 0) {
                response.sendRedirect("adminPage.jsp"); // 관리자 페이지로 리다이렉트
            } else {
                out.println("게시판 수정에 실패했습니다.");
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
    } else {
        // 관리자 인증 실패 시 처리
        response.sendRedirect("login.jsp"); // 로그인 페이지로 리다이렉트
    }
%>
</body>
</html>
