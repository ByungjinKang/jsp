<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>

<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("UTF-8"); %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>데이터베이스 예제</title>
</head>
<body>

<%
    Connection con = null;
    PreparedStatement pstmt = null;
    Statement stmt = null;
    StringBuffer SQL = new StringBuffer("INSERT INTO User (PW, User_name, Sex, PH, AD, NickName, Admin, Email) ");
    SQL.append("VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

    String driverName = "com.mysql.jdbc.Driver";
    String dbURL = "jdbc:mysql://localhost:3306/jsp41";

    try {
        String encoding = "euc-kr";

        Class.forName(driverName);
        con = DriverManager.getConnection(dbURL, "jsp41", "poiu0987");
        pstmt = con.prepareStatement(SQL.toString());

        // 입력할 회원 정보 설정
        pstmt.setString(1, request.getParameter("PW"));
        pstmt.setString(2, request.getParameter("User_name"));
        pstmt.setString(3, request.getParameter("Sex"));
        pstmt.setString(4, request.getParameter("PH"));
        pstmt.setString(5, request.getParameter("AD"));
        pstmt.setString(6, request.getParameter("NickName"));
        pstmt.setString(7, request.getParameter("Admin"));
        pstmt.setString(8, request.getParameter("Email"));

        int rowCount = pstmt.executeUpdate();
        if (rowCount == 1) {
            out.println("레코드 하나가 성공적으로 삽입되었습니다.<hr>");
        } else {
            out.println("회원 정보 삽입에 문제가 있습니다.");
        }

        // 다시 조회
        stmt = con.createStatement();

    } catch (Exception e) {
        out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
        out.println(e.toString());
        e.printStackTrace();
    } finally {
        if (pstmt != null) {
            pstmt.close();
        }
        if (con != null) {
            con.close();
        }
    }
    out.println("<meta http-equiv='Refresh' content='1;URL=main.jsp'>");
%>

<p><hr>

</body>
</html>
