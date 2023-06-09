<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.io.PrintWriter" %>

<%
    int commentID = 0;
    if (request.getParameter("commentID") != null) {
        commentID = Integer.parseInt(request.getParameter("commentID"));
    }

    Connection conn = null;
    PreparedStatement deletePstmt = null;
    PreparedStatement postIDPstmt = null;
    ResultSet postIDRs = null;
    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 게시글 페이지로 리다이렉트하기 위해 댓글이 속한 게시물의 코드를 가져옴
        String postIDSql = "SELECT POST_code FROM Comment WHERE COM_code = ?";
        postIDPstmt = conn.prepareStatement(postIDSql);
        postIDPstmt.setInt(1, commentID);
        postIDRs = postIDPstmt.executeQuery();
        int postID = 0;
        if (postIDRs.next()) {
            postID = postIDRs.getInt("POST_code");
        }

        String deleteSql = "DELETE FROM Comment WHERE COM_code = ?";
        deletePstmt = conn.prepareStatement(deleteSql);
        deletePstmt.setInt(1, commentID);
        int rowsAffected = deletePstmt.executeUpdate();

        if (rowsAffected > 0) {
            response.sendRedirect("view.jsp?postID=" + postID);
        } else {
            out.println("<p>댓글 삭제에 실패했습니다.</p>");
            out.println("<a href=\"bbs.jsp\" class=\"btn btn-primary\">목록</a>");
        }
    } catch (Exception e) {
        out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
        out.println(e.toString());
        e.printStackTrace();
    } finally {
        if (postIDRs != null) {
            postIDRs.close();
        }
        if (postIDPstmt != null) {
            postIDPstmt.close();
        }
        if (deletePstmt != null) {
            deletePstmt.close();
        }
        if (conn != null) {
            conn.close();
        }
    }
%>
