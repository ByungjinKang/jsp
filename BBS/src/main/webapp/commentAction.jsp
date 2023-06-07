<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    // 댓글 작성 폼에서 전달된 데이터 가져오기
    int postID = Integer.parseInt(request.getParameter("postCode"));
    String commentContent = request.getParameter("commentContent");
    
    // 현재 로그인한 사용자의 정보 가져오기
    String userID = (String) session.getAttribute("userID");

    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        
        // 댓글을 추가하는 SQL 쿼리 작성
        String sql = "INSERT INTO Comment (POST_code, User_ID, COM_date, COM_con) VALUES (?, ?, NOW(), ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, postID);
        pstmt.setString(2, userID);
        pstmt.setString(3, commentContent);
        
        // 댓글 추가 실행
        pstmt.executeUpdate();
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
    
    // 댓글 추가 후 상세 페이지로 이동
    response.sendRedirect("view.jsp?postCode=" + postID);
%>
