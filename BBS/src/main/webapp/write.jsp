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
    <title>JSP 게시판 웹 사이트 - 글 작성</title>
</head>
<body>
    <% 
        String userID = null;
        String userNickName = null;
        int boardID = -1;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
        }

        // 로그인 상태가 아니면 로그인 페이지로 이동
        if (userID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

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

            // bbs.jsp에서 boardID 가져오기
            String boardIDParam = request.getParameter("boardID");
            if (boardIDParam != null && !boardIDParam.isEmpty()) {
                boardID = Integer.parseInt(boardIDParam);
            }
        } catch (Exception e) {
            out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
            out.println(e.toString());
            e.printStackTrace();
        } finally {
            // 자원 해제
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
                <a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
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
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><%= userNickName %> <span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="logoutAction.jsp">로그아웃</a></li>
                                <li><a href="updateUser.jsp">회원 정보 수정</a></li>
                                <li><a href="myPosts.jsp?User_ID=<%= userID %>">My Post</a></li>
                            </ul>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>
    
    <div class="container">
        <div class="row">
            <form method="post" action="writeAction.jsp">
                <% if (boardID != -1) { %>
                    <input type="hidden" name="boardID" value="<%= boardID %>">
                <% } %>
                <table class="table table-stripped" style="text-align: center; border: 1px solid #dddddd">
                    <thead>
                        <tr>
                            <th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글쓰기 양식</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50"></td>
                        </tr>
                        <tr>
                            <td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"></textarea></td>
                        </tr>
                    </tbody>
                </table>
                <input type="submit" class="btn btn-primary pull-right" value="글쓰기">
            </form>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
</body>
</html>
