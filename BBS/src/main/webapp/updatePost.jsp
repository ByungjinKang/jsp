<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>게시글 수정</title>
</head>
<body>
<%
    // 세션에서 userID 가져오기
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }

    // 관리자 인증 체크 (세션 또는 로그인 상태 확인)
    boolean isAdmin = false;
    String adminValue = null;
    if (userID != null) {
        Connection conn = null;
        PreparedStatement adminPstmt = null;
        ResultSet adminRs = null;
        
        try {
            String driverName = "com.mysql.jdbc.Driver";
            String dbURL = "jdbc:mysql://localhost:3306/jsp41";
            String dbUser = "jsp41";
            String dbPassword = "poiu0987";

            Class.forName(driverName);
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String adminSql = "SELECT Admin FROM User WHERE User_ID = ?";
            adminPstmt = conn.prepareStatement(adminSql);
            adminPstmt.setString(1, userID);
            adminRs = adminPstmt.executeQuery();
            if (adminRs.next()) {
                adminValue = adminRs.getString("Admin");
                if (adminValue != null && adminValue.equals("1")) {
                    isAdmin = true;
                }
            }
        } catch (Exception e) {
            out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
            out.println(e.toString());
            e.printStackTrace();
        } finally {
            // 자원 해제
            if (adminPstmt != null) {
                adminPstmt.close();
            }
            if (adminRs != null) {
                adminRs.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }

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

            int postID = 0;
            if (request.getParameter("postID") != null) {
                postID = Integer.parseInt(request.getParameter("postID"));
            }

            // 선택한 게시글 정보 조회
            String selectPostSql = "SELECT * FROM Post WHERE POST_code = ?";
            pstmt = conn.prepareStatement(selectPostSql);
            pstmt.setInt(1, postID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String title = rs.getString("Title");
                String content = rs.getString("Content");

                %>
                <nav class="navbar navbar-default">
                    <div class="container-fluid">
                        <div class="navbar-header">
                            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                                <span class="sr-only">Toggle navigation</span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                            </button>
                            <a class="navbar-brand" href="#">게시판 관리자 페이지</a>
                        </div>

                        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                            <ul class="nav navbar-nav">
                                <li><a href="adminPage.jsp">게시판 관리</a></li>
                            </ul>

                            <ul class="nav navbar-nav navbar-right">
                                <li><a href="#">관리자</a></li>
                                <li><a href="logout.jsp">로그아웃</a></li>
                                <li><a href="myPosts.jsp?User_ID=<%= userID %>">My Post</a></li>

                            </ul>
                        </div>
                    </div>
                </nav>

                <div class="container">
                    <h3>게시글 수정</h3>
                    <form action="updateAction.jsp?postID=<%= postID %>" method="POST">
                        <input type="hidden" name="postID" value="<%= postID %>">
                        <div class="form-group">
                            <label for="title">제목</label>
                            <input type="text" class="form-control" id="title" name="title" value="<%= title %>" required>
                        </div>
                        <div class="form-group">
                            <label for="content">내용</label>
                            <textarea class="form-control" id="content" name="content" rows="5" required><%= content %></textarea>
                        </div>
                        <!-- 필요한 추가 정보 입력 -->

                        <button type="submit" class="btn btn-primary">수정</button>
                    </form>
                </div>

                <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
                <script src="js/bootstrap.js"></script>
            <% } else {
                // 선택한 게시글이 없는 경우 처리
                out.println("해당 게시글을 찾을 수 없습니다.");
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
