<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%
    // 세션에서 현재 사용자의 User_ID를 가져옵니다.
    String follower = (String) session.getAttribute("userID");

    // followedID 매개변수를 받아옵니다.
    String followedID = request.getParameter("followedID");

    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Follow 테이블에서 팔로우 정보를 삭제합니다.
        String deleteSql = "DELETE FROM Follow WHERE Follower = ? AND Writer = ?";
        pstmt = conn.prepareStatement(deleteSql);
        pstmt.setString(1, follower);
        pstmt.setString(2, followedID);
        pstmt.executeUpdate();

        // 언팔로우 액션 이후의 처리 작업을 수행합니다.

        // 예: 언팔로우 성공 메시지를 출력합니다.
        out.println("<p>언팔로우 성공!</p>");
        
        // 메인 페이지로 이동하는 JavaScript 코드를 추가합니다.
        out.println("<script>");
        out.println("window.location.href = 'main.jsp';");
        out.println("</script>");
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
