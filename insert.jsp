<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>�����ͺ��̽� ����</title>
</head>
<body>

<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("euc-kr"); %>

<h2>���̺� student�� �����͸� �����ϴ� ���α׷� </h2>
<hr><center>
<h2>�л����� ���</h2>

<%
    Connection con = null;
    PreparedStatement pstmt = null;
	Statement stmt = null;
    StringBuffer SQL = new StringBuffer("insert into student(tid, tpw, tname, tyear, tnum, tdept, tmobile1, tmobile2, taddr, temail) "); 
    SQL.append("values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    String name = "ȫ�浿";

	String driverName = "org.gjt.mm.mysql.Driver";
    String dbURL = "jdbc:mysql://localhost:3306/jspdb";

    try {
		Class.forName(driverName);
        con = DriverManager.getConnection(dbURL, "root", "");
 //       pstmt = con.prepareStatement(sql);
 //       pstmt.executeUpdate();

        pstmt = con.prepareStatement(SQL.toString());
        //������ �л� ���ڵ� ������ �Է�
        pstmt.setString(1, "DBCP");
        pstmt.setString(2, "commons");
        pstmt.setString(3, name);
        pstmt.setInt(4, 2010);
        pstmt.setString(5, "1039653");
        pstmt.setString(6, "����������");
        pstmt.setString(7, "011");
        pstmt.setString(8, "2398-9750");
        pstmt.setString(9, "��õ��");
        pstmt.setString(10, "dbcp@gmail.com");

        int rowCount = pstmt.executeUpdate();        
        if (rowCount == 1) out.println("<hr>�л� [" + name+ "] ���ڵ� �ϳ��� ���������� ���� �Ǿ����ϴ�.<hr>");
        else out.println("�л� ���ڵ� ���Կ� ������ �ֽ��ϴ�.");
        
        //�ٽ� �л� ��ȸ
        stmt = con.createStatement();

    }
    catch(Exception e) {
    	out.println("MySql �����ͺ��̽� univdb�� student ��ȸ�� ������ �ֽ��ϴ�. <hr>");
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