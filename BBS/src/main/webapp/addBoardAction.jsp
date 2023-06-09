<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.io.PrintWriter" %>

<%
    String boardName = request.getParameter("boardName");
    // 필요한 추가 정보 수신

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 게시판 추가
        String insertSql = "INSERT INTO Board (Board_Name) VALUES (?)";
        pstmt = conn.prepareStatement(insertSql);
        pstmt.setString(1, boardName);
        // 필요한 추가 정보 설정

        pstmt.executeUpdate();

        response.sendRedirect("adminPage.jsp"); // 관리자 페이지로 리다이렉트
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
