<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>JSP 게시판 웹 사이트</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 4.5rem;
        }
        .jumbotron {
            background-color: #f8f9fa;
        }
        .jumbotron h1 {
            font-size: 3rem;
            margin-bottom: 2rem;
        }
        .jumbotron p {
            font-size: 1.5rem;
        }
        .navbar {
            margin-bottom: 2rem;
        }
        .sidebar {
            position: fixed;
            top: 20%;
            right: 1rem;
            width: 200px;
            height: calc(80vh - 90px); /* Adjust the height as needed */
            overflow-y: auto; /* Enable vertical scrolling */
        }
    
        .following-list,
        .follower-list,
        .post-list {
            margin-bottom: 1rem;
        }
    
        .following-item,
        .follower-item,
        .post-item {
            display: block;
            margin-bottom: 0.5rem;
            padding: 0.5rem;
            border: 1px solid #ccc;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
    
        .following-item:hover,
        .follower-item:hover,
        .post-item:hover {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
<%
    // 세션에서 User_ID 가져오기
    String userID = null;
    String userNickName = null;
    String userAdmin = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
        // User 테이블에서 NickName과 Admin 가져오기
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

            String userSql = "SELECT NickName, Admin FROM User WHERE User_ID = ?";
            userPstmt = conn.prepareStatement(userSql);
            userPstmt.setString(1, userID);
            userRs = userPstmt.executeQuery();
            if (userRs.next()) {
                userNickName = userRs.getString("NickName");
                userAdmin = userRs.getString("Admin");
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
    }

    // 로그인 여부 확인
    boolean loggedIn = (userID != null && !userID.isEmpty());
    // 관리자 여부 확인
    boolean isAdmin = (userAdmin != null && userAdmin.equals("1"));

    // Board 테이블에서 게시판 정보 가져오기
    Connection conn = null;
    PreparedStatement boardPstmt = null;
    ResultSet boardRs = null;
    try {
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        String boardSql = "SELECT * FROM Board";
        boardPstmt = conn.prepareStatement(boardSql);
        boardRs = boardPstmt.executeQuery();
    } catch (Exception e) {
        out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
        out.println(e.toString());
        e.printStackTrace();
    }
%>

<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
    <a class="navbar-brand" href="main.jsp">Novel AI</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarCollapse">
        <ul class="navbar-nav mr-auto">
            <%
                if (boardRs != null) {
                    while (boardRs.next()) {
            %>
            <li class="nav-item">
                <a class="nav-link" href="bbs.jsp?boardID=<%= boardRs.getString("Board_ID") %>"><%= boardRs.getString("Board_Name") %></a>
            </li>
            <%
                    }
                }
            %>
        </ul>
        <ul class="navbar-nav ml-auto">
            <% if (userID == null) { %>
            <li class="nav-item">
                <a class="nav-link" href="login.jsp">로그인</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="join.jsp">회원가입</a>
            </li>
            <% } else { %>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <%= userNickName %>
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
                    <a class="dropdown-item" href="logoutAction.jsp">로그아웃</a>
                    <a class="dropdown-item" href="updateUser.jsp">회원 정보 수정</a>
                    <a class="dropdown-item" href="myPosts.jsp?User_ID=<%= userID %>">My Post</a>
                </div>
            </li>
            <% if (isAdmin) { %>
            <li class="nav-item">
                <a class="nav-link" href="adminPage.jsp">관리자 페이지</a>
            </li>
            <% } %>
            <% } %>
        </ul>
    </div>
</nav>

<div class="jumbotron text-center">
    <h1 class="display-4">Novel AI</h1>
    <p class="lead">AI 소설 커뮤니티 NovelAI입니다.</p>
    <% if (loggedIn) { %>
    <p>로그인되었습니다. 환영합니다, <%= userNickName %> 님!</p>
    <% } else { %>
    <p>로그인 후 게시판을 이용할 수 있습니다.</p>
    <% } %>
    
    <div class="sidebar">
        <%-- 팔로워 목록 --%>
        <% if (loggedIn) { %>
        <h2>팔로워 목록</h2>
        <div class="follower-list">
            <% 
                Connection conn2 = null;
                PreparedStatement followerPstmt = null;
                ResultSet followerRs = null;
                try {
                    String driverName = "com.mysql.jdbc.Driver";
                    String dbURL = "jdbc:mysql://localhost:3306/jsp41";
                    String dbUser = "jsp41";
                    String dbPassword = "poiu0987";
    
                    Class.forName(driverName);
                    conn2 = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    
                    String followerSql = "SELECT User.User_ID, User.NickName FROM Follow JOIN User ON Follow.Follower = User.User_ID WHERE Follow.Writer = ?";
                    followerPstmt = conn2.prepareStatement(followerSql);
                    followerPstmt.setString(1, userID);
                    followerRs = followerPstmt.executeQuery();
                    while (followerRs.next()) {
                        String followerID = followerRs.getString("User_ID");
                        String followerNickName = followerRs.getString("NickName");
            %>
                        <a href="myPosts.jsp?User_ID=<%= followerID %>" class="follower-item"><%= followerNickName %></a>
            <%
                    }
                } catch (Exception e) {
                    out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
                    out.println(e.toString());
                    e.printStackTrace();
                } finally {
                    // 자원 해제
                    if (followerPstmt != null) {
                        followerPstmt.close();
                    }
                    if (followerRs != null) {
                        followerRs.close();
                    }
                    if (conn2 != null) {
                        conn2.close();
                    }
                }
            %>
        </div>
        <% } %>
    
        <%-- 팔로잉 목록 --%>
        <% if (loggedIn) { %>
        <h2 class="mb-3">팔로잉 목록</h2>
        <div class="following-list">
            <% 
                Connection conn3 = null;
                PreparedStatement followingPstmt = null;
                ResultSet followingRs = null;
                try {
                    String driverName = "com.mysql.jdbc.Driver";
                    String dbURL = "jdbc:mysql://localhost:3306/jsp41";
                    String dbUser = "jsp41";
                    String dbPassword = "poiu0987";
    
                    Class.forName(driverName);
                    conn3 = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    
                    String followingSql = "SELECT User.User_ID, User.NickName FROM Follow JOIN User ON Follow.Writer = User.User_ID WHERE Follow.Follower = ?";
                    followingPstmt = conn3.prepareStatement(followingSql);
                    followingPstmt.setString(1, userID);
                    followingRs = followingPstmt.executeQuery();
                    while (followingRs.next()) {
                        String followingID = followingRs.getString("User_ID");
                        String followingNickName = followingRs.getString("NickName");
            %>
                        <a href="myPosts.jsp?User_ID=<%= followingID %>" class="following-item"><%= followingNickName %></a>
            <%
                    }
                } catch (Exception e) {
                    out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
                    out.println(e.toString());
                    e.printStackTrace();
                } finally {
                    // 자원 해제
                    if (followingPstmt != null) {
                        followingPstmt.close();
                    }
                    if (followingRs != null) {
                        followingRs.close();
                    }
                    if (conn3 != null) {
                        conn3.close();
                    }
                }
            %>
        </div>
        <% } %>
    
        <%-- 로그인 한 사용자 게시글 목록 --%>
        <% if (loggedIn) { %>
        <h2>내 게시글</h2>
        <div class="post-list">
            <% 
                Connection conn4 = null;
                PreparedStatement postPstmt = null;
                ResultSet postRs = null;
                try {
                    String driverName = "com.mysql.jdbc.Driver";
                    String dbURL = "jdbc:mysql://localhost:3306/jsp41";
                    String dbUser = "jsp41";
                    String dbPassword = "poiu0987";
    
                    Class.forName(driverName);
                    conn4 = DriverManager.getConnection(dbURL, dbUser, dbPassword);
    
                    String postSql = "SELECT * FROM Post WHERE User_ID = ?";
                    postPstmt = conn4.prepareStatement(postSql);
                    postPstmt.setString(1, userID);
                    postRs = postPstmt.executeQuery();
                    while (postRs.next()) {
                        int postID = postRs.getInt("POST_code");
                        String postTitle = postRs.getString("Title");
            %>
                        <a href="view.jsp?postID=<%= postID %>" class="post-item"><%= postTitle %></a>
            <%
                    }
                } catch (Exception e) {
                    out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
                    out.println(e.toString());
                    e.printStackTrace();
                } finally {
                    // 자원 해제
                    if (postPstmt != null) {
                        postPstmt.close();
                    }
                    if (postRs != null) {
                        postRs.close();
                    }
                    if (conn4 != null) {
                        conn4.close();
                    }
                }
            %>
        </div>
        <% } %>
    
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/js/bootstrap.min.js"></script>
</body>
</html>
