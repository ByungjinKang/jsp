<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>JSP 게시판 웹 사이트</title>
</head>
<body>
<%
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }
    if (userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인하세요.')");
        script.println("location.href = 'login.jsp'");
        script.println("</script>");
    }
    int postID = 0;
    if (request.getParameter("postID") != null) {
        postID = Integer.parseInt(request.getParameter("postID"));
    }
    if (postID == 0) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다.')");
        script.println("location.href = 'bbs.jsp'");
        script.println("</script>");
    }

    String title = request.getParameter("title");
    String content = request.getParameter("content");

    // XSS 방지를 위해 입력값 필터링
    title = title.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
    content = content.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String query = "SELECT Title, Content, Board_ID FROM Post WHERE POST_code = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, postID);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            String prevTitle = rs.getString("Title");
            String prevContent = rs.getString("Content");
            String boardID = rs.getString("Board_ID");

            // 이전 내용과 입력받은 내용이 같은지 확인
            if (prevTitle.equals(title) && prevContent.equals(content)) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('수정된 내용이 없습니다.')");
                script.println("location.href = 'view.jsp?postID=" + postID + "'");
                script.println("</script>");
                return;
            }
        }

        query = "UPDATE Post SET Title = ?, Content = ?, M_Date = ? WHERE POST_code = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, title);
        pstmt.setString(2, content);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String currentDate = sdf.format(new Date());
        pstmt.setString(3, currentDate);

        pstmt.setInt(4, postID);
        pstmt.executeUpdate();

        response.sendRedirect("view.jsp?postID=" + postID);
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

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
</body>
</html>
