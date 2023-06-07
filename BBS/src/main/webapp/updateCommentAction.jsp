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
<title>JSP 게시판 웹 사이트 - 댓글 수정 처리</title>
</head>
<body>
<%
    String userID = null;

    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }

    int commentID = 0;
    if (request.getParameter("commentID") != null) {
        commentID = Integer.parseInt(request.getParameter("commentID"));
    }

    String commentContent = request.getParameter("commentContent");

    Connection conn = null;
    PreparedStatement commentPstmt = null;
    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 댓글 수정 시간 가져오기
        String updateDateSql = "SELECT COM_mdd FROM Comment WHERE COM_code = ?";
        PreparedStatement updateDatePstmt = conn.prepareStatement(updateDateSql);
        updateDatePstmt.setInt(1, commentID);
        ResultSet updateDateRs = updateDatePstmt.executeQuery();
        String previousUpdateDate = null;
        if (updateDateRs.next()) {
            previousUpdateDate = updateDateRs.getString("COM_mdd");
        }

        // 현재 시간 가져오기
        java.util.Date currentDate = new java.util.Date();
        java.sql.Timestamp currentTimestamp = new java.sql.Timestamp(currentDate.getTime());

        // 댓글 수정 시간 업데이트
        String commentSql = "UPDATE Comment SET COM_con = ?, COM_mdd = ? WHERE COM_code = ?";
        commentPstmt = conn.prepareStatement(commentSql);
        commentPstmt.setString(1, commentContent);
        commentPstmt.setTimestamp(2, currentTimestamp);
        commentPstmt.setInt(3, commentID);
        commentPstmt.executeUpdate();

        // 댓글 수정이 완료되었으므로, 해당 댓글이 속한 게시물 페이지로 리다이렉트
        String postCodeSql = "SELECT POST_code FROM Comment WHERE COM_code = ?";
        PreparedStatement postCodePstmt = conn.prepareStatement(postCodeSql);
        postCodePstmt.setInt(1, commentID);
        ResultSet postCodeRs = postCodePstmt.executeQuery();
        if (postCodeRs.next()) {
            int postCode = postCodeRs.getInt("POST_code");
            response.sendRedirect("view.jsp?postCode=" + postCode);
        } else {
            // 댓글이 속한 게시물의 코드를 찾을 수 없는 경우, 에러 메시지 출력 후 목록 페이지로 이동
            out.println("<div class=\"container\">");
            out.println("<p>유효하지 않은 댓글입니다.</p>");
            out.println("<a href=\"bbs.jsp\" class=\"btn btn-primary\">목록</a>");
            out.println("</div>");
        }
    } catch (Exception e) {
        out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
        out.println(e.toString());
        e.printStackTrace();
    } finally {
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
