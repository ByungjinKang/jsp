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
<title>JSP 게시판 웹 사이트</title>
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

    int postID = 0;
    if (request.getParameter("postCode") != null) {
        postID = Integer.parseInt(request.getParameter("postCode"));
    }

    // 게시글 방문 기록 저장 및 조회수 업데이트
    if (userID != null) {
        Connection conn = null;
        PreparedStatement historyPstmt = null;
        try {
            String driverName = "com.mysql.jdbc.Driver";
            String dbURL = "jdbc:mysql://localhost:3306/jsp41";
            String dbUser = "jsp41";
            String dbPassword = "poiu0987";

            Class.forName(driverName);
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // 이미 방문한 기록이 있는지 확인
            String historyCheckSql = "SELECT * FROM PostHistory WHERE POST_code = ? AND User_ID = ?";
            PreparedStatement historyCheckPstmt = conn.prepareStatement(historyCheckSql);
            historyCheckPstmt.setInt(1, postID);
            historyCheckPstmt.setString(2, userID);
            ResultSet historyCheckRs = historyCheckPstmt.executeQuery();

            if (!historyCheckRs.next()) { // 방문 기록이 없는 경우에만 기록 저장
                String historyInsertSql = "INSERT INTO PostHistory (POST_code, User_ID) VALUES (?, ?)";
                historyPstmt = conn.prepareStatement(historyInsertSql);
                historyPstmt.setInt(1, postID);
                historyPstmt.setString(2, userID);
                historyPstmt.executeUpdate();

                // 조회수 업데이트
                String updateViewCountSql = "UPDATE Post SET ViewCount = (SELECT COUNT(*) FROM PostHistory WHERE POST_code = ?) WHERE POST_code = ?";
                PreparedStatement updateViewCountPstmt = conn.prepareStatement(updateViewCountSql);
                updateViewCountPstmt.setInt(1, postID);
                updateViewCountPstmt.setInt(2, postID);
                updateViewCountPstmt.executeUpdate();
            }
        } catch (Exception e) {
            out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
            out.println(e.toString());
            e.printStackTrace();
        } finally {
            if (historyPstmt != null) {
                historyPstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    }

    Connection conn = null;
    PreparedStatement postPstmt = null;
    ResultSet postRs = null;
    PreparedStatement commentPstmt = null;
    ResultSet commentRs = null;
    PreparedStatement boardPstmt = null;
    ResultSet boardRs = null;
    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String postSql = "SELECT * FROM Post WHERE POST_code = ?";
        postPstmt = conn.prepareStatement(postSql);
        postPstmt.setInt(1, postID);
        postRs = postPstmt.executeQuery();

        String boardSql = "SELECT * FROM Board";
        boardPstmt = conn.prepareStatement(boardSql);
        boardRs = boardPstmt.executeQuery();

        if (postRs.next()) {
            String title = postRs.getString("Title");
            String content = postRs.getString("Content");
            String writer = postRs.getString("User_ID");
            String date = postRs.getString("C_Date");
            String modifiedDate = postRs.getString("M_Date");
            int viewCount = postRs.getInt("ViewCount");

            // 작성자의 닉네임 가져오기
            String writerNickName = null;
            String writerSql = "SELECT NickName FROM User WHERE User_ID = ?";
            PreparedStatement writerPstmt = conn.prepareStatement(writerSql);
            writerPstmt.setString(1, writer);
            ResultSet writerRs = writerPstmt.executeQuery();
            if (writerRs.next()) {
                writerNickName = writerRs.getString("NickName");
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
                                </ul>
                            </li>
                            <% } %>
                        </ul>
                    </div>
                </div>
            </nav>

            <div class="container">
                <div class="panel panel-default">
                    <div class="panel-body">
                        <h4><%= title %></h4>
                        <p>작성자: <%= writerNickName %></p>
                        <p>작성일: <%= date %></p>
                        <% if (modifiedDate != null) { %>
                            <p>수정일: <%= modifiedDate %></p>
                        <% } %>
                        <p>조회수: <%= viewCount %></p>
                        <p><%= content %></p>
                    </div>
                </div>

                <h4>댓글</h4>
                <%
                    String commentSql = "SELECT * FROM Comment WHERE POST_code = ?";
                    commentPstmt = conn.prepareStatement(commentSql);
                    commentPstmt.setInt(1, postID);
                    commentRs = commentPstmt.executeQuery();

                    while (commentRs.next()) {
                        String commentContent = commentRs.getString("COM_con");
                        String commentWriter = commentRs.getString("User_ID");
                        String commentDate = commentRs.getString("COM_date");
                        String commentModifiedDate = commentRs.getString("COM_mdd");

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
                        <div class="panel panel-default">
                            <div class="panel-body">
                                <p><%= commentContent %></p>
                                <p>작성자: <%= commentWriterNickName %></p>
                                <p>작성일: <%= commentDate %></p>
                                <% if (commentModifiedDate != null) { %>
                                    <p>수정일: <%= commentModifiedDate %></p>
                                <% } %>
                                <% if (userID != null && userID.equals(commentWriter)) { %>
                                <a href="updateComment.jsp?commentID=<%= commentRs.getInt("COM_code") %>" class="btn btn-primary btn-sm">수정</a>
                                <a href="deleteCommentAction.jsp?commentID=<%= commentRs.getInt("COM_code") %>" class="btn btn-primary btn-sm">삭제</a>
                                <% } %>
                            </div>
                        </div>
                <% } %>

                <% if (userID != null) { %>
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <form action="commentAction.jsp" method="POST">
                                <input type="hidden" name="postCode" value="<%= postID %>">
                                <div class="form-group">
                                    <label for="commentContent">댓글 작성</label>
                                    <textarea class="form-control" id="commentContent" name="commentContent" rows="3"></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary">작성</button>
                            </form>
                        </div>
                    </div>
                <% } %>

                <% if (boardRs.next()) { %>
                <a href="bbs.jsp?boardID=<%= boardRs.getString("Board_ID") %>" class="btn btn-primary">목록</a>
                <% } %>
                <% if (userID != null && userID.equals(writer)) { %>
                <a href="update.jsp?postID=<%= postID %>&boardID=<%= boardRs.getString("Board_ID") %>" class="btn btn-primary">수정</a>
                <a href="deleteAction.jsp?postID=<%= postID %>&boardID=<%= boardRs.getString("Board_ID") %>" class="btn btn-primary">삭제</a>
                <% } %>
            </div>

            <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
            <script src="js/bootstrap.js"></script>
        <% 
        } 
        else {
            out.println("<div class=\"container\">");
            out.println("<p>유효하지 않은 글입니다.</p>");
            if (boardRs.next()) {
                out.println("<a href=\"bbs.jsp?boardID=" + boardRs.getString("Board_ID") + "\" class=\"btn btn-primary\">목록</a>");
            }
            out.println("</div>");
        }
    } catch (Exception e) {
        out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
        out.println(e.toString());
        e.printStackTrace();
    } finally {
        if (postPstmt != null) {
            postPstmt.close();
        }
        if (postRs != null) {
            postRs.close();
        }
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
