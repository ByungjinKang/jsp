<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<%
    // JDBC 연결 및 SQL 문 실행 준비
    Connection con = null;
    PreparedStatement pstmt = null;
    StringBuffer SQL = new StringBuffer("SELECT * FROM User WHERE Email=? AND PW=?");

    String driverName = "com.mysql.jdbc.Driver";
    String dbURL = "jdbc:mysql://localhost:3306/jsp41";

    try {
        // 요청 파라미터에서 이메일과 비밀번호 가져오기
        String email = request.getParameter("email");
        String password = request.getParameter("userPassword");

        // JDBC 드라이버 로딩 및 연결 설정
        Class.forName(driverName);
        con = DriverManager.getConnection(dbURL, "jsp41", "poiu0987");
        pstmt = con.prepareStatement(SQL.toString());

        // 입력된 이메일과 비밀번호 설정
        pstmt.setString(1, email);
        pstmt.setString(2, password);

        // 쿼리 실행 및 결과 처리
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            // 로그인 성공 시 세션에 이메일 정보 저장 후 메인 페이지로 이동
            session.setAttribute("userID", rs.getString("User_ID"));
            response.sendRedirect("main.jsp");
        } else {
            // 로그인 실패 시 알림창을 띄우고 이전 페이지로 이동
            out.println("<script>");
            out.println("alert('아이디와 비밀번호를 확인해주세요.')");
            out.println("history.back()");
            out.println("</script>");
        }
    } catch (Exception e) {
        out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
        out.println(e.toString());
        e.printStackTrace();
    } finally {
        // 자원 해제
        if (pstmt != null) {
            pstmt.close();
        }
        if (con != null) {
            con.close();
        }
    }
%>


<p><hr>
