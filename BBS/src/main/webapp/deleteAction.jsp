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
<title>JSP 게시판 웹 사이트 - 게시물 삭제 처리</title>
</head>
<body>
<%
    String userID = null;

    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }

    int postID = 0;
    if (request.getParameter("postID") != null) {
        postID = Integer.parseInt(request.getParameter("postID"));
    }

    String boardID = "";
    if (request.getParameter("boardID") != null) {
        boardID = request.getParameter("boardID");
    }

    Connection conn = null;
    PreparedStatement postPstmt = null;
    PreparedStatement commentPstmt = null;

    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 게시물 삭제
        String deletePostSql = "DELETE FROM Post WHERE POST_code = ?";
        postPstmt = conn.prepareStatement(deletePostSql);
        postPstmt.setInt(1, postID);
        postPstmt.executeUpdate();

        // 해당 게시물의 댓글 삭제
        String deleteCommentSql = "DELETE FROM Comment WHERE POST_code = ?";
        commentPstmt = conn.prepareStatement(deleteCommentSql);
        commentPstmt.setInt(1, postID);
        commentPstmt.executeUpdate();

        // 게시물 삭제 후 게시판 페이지로 리다이렉트
        response.sendRedirect("bbs.jsp?boardID=" + boardID);
    } catch (Exception e) {
        out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
        out.println(e.toString());
        e.printStackTrace();
    } finally {
        if (postPstmt != null) {
            postPstmt.close();
        }
        if (commentPstmt != null) {
            commentPstmt.close();
        }
        if (conn != null) {
            conn.close();
        }
    }
%>
</body>
</html>
