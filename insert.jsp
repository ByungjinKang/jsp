<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>데이터베이스 예제</title>
</head>
<body>

<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("euc-kr"); %>

<h2>테이블 student에 데이터를 삽입하는 프로그램 </h2>
<hr><center>
<h2>학생정보 등록</h2>

<%
    Connection con = null;
    PreparedStatement pstmt = null;
	Statement stmt = null;
    StringBuffer SQL = new StringBuffer("insert into student(tid, tpw, tname, tyear, tnum, tdept, tmobile1, tmobile2, taddr, temail) "); 
    SQL.append("values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    String name = "홍길동";

	String driverName = "org.gjt.mm.mysql.Driver";
    String dbURL = "jdbc:mysql://localhost:3306/jspdb";

    try {
		Class.forName(driverName);
        con = DriverManager.getConnection(dbURL, "root", "");
 //       pstmt = con.prepareStatement(sql);
 //       pstmt.executeUpdate();

        pstmt = con.prepareStatement(SQL.toString());
        //삽입할 학생 레코드 데이터 입력
        pstmt.setString(1, "DBCP");
        pstmt.setString(2, "commons");
        pstmt.setString(3, name);
        pstmt.setInt(4, 2010);
        pstmt.setString(5, "1039653");
        pstmt.setString(6, "전산정보과");
        pstmt.setString(7, "011");
        pstmt.setString(8, "2398-9750");
        pstmt.setString(9, "인천시");
        pstmt.setString(10, "dbcp@gmail.com");

        int rowCount = pstmt.executeUpdate();        
        if (rowCount == 1) out.println("<hr>학생 [" + name+ "] 레코드 하나가 성공적으로 삽입 되었습니다.<hr>");
        else out.println("학생 레코드 삽입에 문제가 있습니다.");
        
        //다시 학생 조회
        stmt = con.createStatement();

    }
    catch(Exception e) {
    	out.println("MySql 데이터베이스 univdb의 student 조회에 문제가 있습니다. <hr>");
        out.println(e.toString());
        e.printStackTrace();
    }
    finally {
        if(pstmt != null) pstmt.close();
        if(con != null) con.close();
    }
//	out.println("<meta http-equiv='Refresh' content='1;URL=selectdb.jsp'>");
%>

<p><hr>

</body>
</html>