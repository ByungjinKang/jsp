<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        int userID = Integer.parseInt(request.getParameter("userID"));

        String deleteSql = "DELETE FROM User WHERE User_ID=?";
        pstmt = conn.prepareStatement(deleteSql);
        pstmt.setInt(1, userID);

        int result = pstmt.executeUpdate();

        if (result > 0) {
            out.println("<script>");
            out.println("alert('사용자 정보가 삭제되었습니다.')");
            out.println("location.href='userManage.jsp';");
            out.println("</script>");
        } else {
            out.println("<script>");
            out.println("alert('사용자 정보 삭제에 실패했습니다.')");
            out.println("history.back();");
            out.println("</script>");
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
