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
<title>JSP 게시판 웹 사이트 - 댓글 수정</title>
</head>
<body>
<%
    String userID = null;
    String userNickName = null;

    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
        Connection conn = null;
        PreparedStatement userPstmt = null;
        ResultSet userRs = null;
        try {
            String driverName = "com.mysql.jdbc.Driver";
            String dbURL = "jdbc:mysql://localhost:3306/jsp41";
            String dbUser = "jsp41";
            String dbPassword = "poiu0987";

            Class.forName(driverName);
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String userSql = "SELECT NickName FROM User WHERE User_ID = ?";
            userPstmt = conn.prepareStatement(userSql);
            userPstmt.setString(1, userID);
            userRs = userPstmt.executeQuery();
            if (userRs.next()) {
                userNickName = userRs.getString("NickName");
            }
        } catch (Exception e) {
            out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
            out.println(e.toString());
            e.printStackTrace();
        } finally {
            if (userPstmt != null) {
                userPstmt.close();
            }
            if (userRs != null) {
                userRs.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }

    int commentID = 0;
    if (request.getParameter("commentID") != null) {
        commentID = Integer.parseInt(request.getParameter("commentID"));
    }

    Connection conn = null;
    PreparedStatement commentPstmt = null;
    ResultSet commentRs = null;
    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String commentSql = "SELECT * FROM Comment WHERE COM_code = ?";
        commentPstmt = conn.prepareStatement(commentSql);
        commentPstmt.setInt(1, commentID);
        commentRs = commentPstmt.executeQuery();

        if (commentRs.next()) {
            String commentContent = commentRs.getString("COM_con");
            String commentWriter = commentRs.getString("User_ID");
            String commentDate = commentRs.getString("COM_date");

            // 작성자의 닉네임 가져오기
            String commentWriterNickName = null;
            String commentWriterSql = "SELECT NickName FROM User WHERE User_ID = ?";
            PreparedStatement commentWriterPstmt = conn.prepareStatement(commentWriterSql);
            commentWriterPstmt.setString(1, commentWriter);
            ResultSet commentWriterRs = commentWriterPstmt.executeQuery();
            if (commentWriterRs.next()) {
                commentWriterNickName = commentWriterRs.getString("NickName");
            }
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
                        <a class="navbar-brand" href="#">JSP 게시판 웹 사이트</a>
                    </div>

                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <ul class="nav navbar-nav">
                            <li><a href="main.jsp">메인</a></li>
                            <li class="active"><a href="bbs.jsp">게시판</a></li>
                        </ul>

                        <ul class="nav navbar-nav navbar-right">
                            <% if (userID == null) { %>
                            <li><a href="login.jsp">로그인</a></li>
                            <li><a href="join.jsp">회원가입</a></li>
                            <% } else { %>
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                    <%= userNickName %><span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a href="logoutAction.jsp">로그아웃</a></li>
                                    <li><a href="updateUser.jsp">회원 정보 수정</a></li>

                                </ul>
                            </li>
                            <% } %>
                        </ul>
                    </div>
                </div>
            </nav>

            <div class="container">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4>댓글 수정</h4>
                    </div>
                    <div class="panel-body">
                        <form action="updateCommentAction.jsp" method="POST">
                            <input type="hidden" name="commentID" value="<%= commentID %>">
                            <div class="form-group">
                                <label for="commentContent">댓글 내용</label>
                                <textarea class="form-control" id="commentContent" name="commentContent" rows="3"><%= commentContent %></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">수정</button>
                            <a href="view.jsp?postID=<%= commentRs.getInt("POST_code") %>" class="btn btn-primary">취소</a>
                        </form>
                    </div>
                </div>
            </div>

            <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
            <script src="js/bootstrap.js"></script>
<%
        } else {
            out.println("<div class=\"container\">");
            out.println("<p>유효하지 않은 댓글입니다.</p>");
            out.println("<a href=\"bbs.jsp\" class=\"btn btn-primary\">목록</a>");
            out.println("</div>");
        }
    } catch (Exception e) {
        out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
        out.println(e.toString());
        e.printStackTrace();
    } finally {
        if (commentPstmt != null) {
            commentPstmt.close();
        }
        if (commentRs != null) {
            commentRs.close();
        }
        if (conn != null) {
            conn.close();
        }
    }
%>
</body>
</html>
