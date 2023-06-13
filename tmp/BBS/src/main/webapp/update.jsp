<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.sql.*" %>

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
    String userNickName = null; // 닉네임 변수 추가

    // 데이터베이스 연결 변수 초기화
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
        
        // 세션에서 userID 가져오기
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
            
            // 닉네임 가져오기
            String query = "SELECT Nickname FROM User WHERE User_ID = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                userNickName = rs.getString("Nickname");
            }
        }
        
        // 로그인 여부 확인
        if (userID == null) {
            // 로그인되지 않은 경우 로그인 페이지로 이동
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인하세요.')");
            script.println("location.href = 'login.jsp'");
            script.println("</script>");
        } else {
            int postID = 0;
            
            // postID 파라미터 가져오기
            if (request.getParameter("postID") != null) {
                postID = Integer.parseInt(request.getParameter("postID"));
            }
            
            // postID 유효성 검사
            if (postID == 0) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('유효하지 않은 글입니다.')");
                script.println("location.href = 'bbs.jsp'");
                script.println("</script>");
            } else {
                String title = null;
                String content = null;

                // 게시글 정보 가져오기
                String query = "SELECT * FROM Post WHERE POST_code = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setInt(1, postID);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    title = rs.getString("Title");
                    content = rs.getString("Content");
                } else {
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("alert('유효하지 않은 글입니다.')");
                    script.println("location.href = 'bbs.jsp'");
                    script.println("</script>");
                }

                %>
                <nav class="navbar navbar-default">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="main.jsp">Novel AI</a>
                    </div>
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <ul class="nav navbar-nav">
                            <li><a href="main.jsp">메인</a></li>
                        </ul>
                        <ul class="nav navbar-nav navbar-right">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><%= userNickName %><span class="caret"></span></a>
                                <ul class="dropdown-menu">
                                    <li><a href="logoutAction.jsp">로그아웃</a></li>
                                    <li><a href="updateUser.jsp">회원 정보 수정</a></li>
                                    <li><a href="myPosts.jsp?User_ID=<%= userID %>">My Post</a></li>

                                </ul>
                            </li>
                        </ul>
                    </div>
                </nav>

                <div class="container">
                    <div class="row">
                        <form method="post" action="updateAction.jsp?postID=<%= postID %>">
                            <table class="table table-stripped" style="text-align: center; border: 1px solid #dddddd">
                                <thead>
                                    <tr>
                                        <th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><input type="text" class="form-control" placeholder="글 제목" name="title" maxlength="20" value="<%= title %>"></td>
                                    </tr>
                                    <tr>
                                        <td><textarea class="form-control" placeholder="글 내용" name="content" maxlength="100" style="height: 350px;"><%= content %></textarea></td>
                                    </tr>
                                </tbody>
                            </table>
                            <input type="submit" class="btn btn-primary pull-right" value="글수정">
                        </form>
                    </div>
                </div>

                <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
                <script src="js/bootstrap.js"></script>
                <%                
            }
        }
    } catch (Exception e) {
        out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
        out.println(e.toString());
        e.printStackTrace();
    } finally {
        // 자원 해제
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
%>
</body>
</html>
