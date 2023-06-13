<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<script>
    function goBack() {
        window.history.back();
    }

    function goMain() {
        window.location.href = "main.jsp";
    }
</script>
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

        // 이미 팔로우 중인지 확인합니다.
        String checkSql = "SELECT * FROM Follow WHERE Follower = ? AND Writer = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, follower);
        pstmt.setString(2, followedID);
        ResultSet resultSet = pstmt.executeQuery();

        if (resultSet.next()) {
            // 이미 팔로우 중인 경우
            out.println("<p>이미 팔로우 중입니다.</p>");
        } else {
            // 팔로우 테이블에 팔로우 정보를 추가합니다.
            String insertSql = "INSERT INTO Follow (Follower, Writer) VALUES (?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setString(1, follower);
            pstmt.setString(2, followedID);
            pstmt.executeUpdate();

            // 팔로우 액션 이후의 처리 작업을 수행합니다.

            // 예: 팔로우 성공 메시지를 출력합니다.
            out.println("<p>팔로우 성공!</p>");
        }

        // main.jsp로 이동하는 JavaScript를 실행합니다.
        out.println("<script>goMain();</script>");
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
