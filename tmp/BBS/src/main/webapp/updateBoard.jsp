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
    <title>게시판 수정</title>
</head>
<body>
<%
    // 관리자 인증 체크 (예: 세션 또는 로그인 상태 확인)
    boolean isAdmin = true; // 관리자 여부 확인

    if (isAdmin) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String driverName = "com.mysql.jdbc.Driver";
            String dbURL = "jdbc:mysql://localhost:3306/jsp41";
            String dbUser = "jsp41";
            String dbPassword = "poiu0987";

            Class.forName(driverName);
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            int boardID = Integer.parseInt(request.getParameter("boardID"));

            // 게시판 정보 조회
            String selectSql = "SELECT * FROM Board WHERE Board_ID = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, boardID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String boardName = rs.getString("Board_Name");
                %>
                <div class="container">
                    <h3>게시판 수정</h3>
                    <form action="updateBoardAction.jsp" method="POST">
                        <input type="hidden" name="boardID" value="<%= boardID %>">
                        <div class="form-group">
                            <label for="boardName">게시판 이름</label>
                            <input type="text" class="form-control" id="boardName" name="boardName" value="<%= boardName %>" required>
                        </div>
                        <!-- 필요한 추가 정보 입력 -->

                        <button type="submit" class="btn btn-primary">게시판 수정</button>
                    </form>
                </div>
                <% } else {
                out.println("게시판을 찾을 수 없습니다.");
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
    } else {
        // 관리자 인증 실패 시 처리
        response.sendRedirect("login.jsp"); // 로그인 페이지로 리다이렉트
    }
%>
</body>
</html>
