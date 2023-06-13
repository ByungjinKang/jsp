<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="./css/1.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
    <title>JSP 게시판 웹 사이트</title>
    <style>
        h3{
            font-family: 'TheJamsil5Bold';
            padding-bottom: 10px;
        }

        h4{
            padding-top: 10px;
        }

        .btn-group{
            padding-bottom: 10px;

        }
        
        .post-panel{
            padding-top: 20px;
        }

        .panel-body{
            background-color: #f8f9fa;
            padding: 20px;
            border: 1px solid #ccc;
            

        }

        .container{
            padding-top: 70px;
        }

        body {
            padding-top: 60px;
            background-color: #e2e2e2;
        }
        .panel {
            border-radius: 0px;
            border-color: #ddd;
        }
        .panel-title {
            color: #333;
            font-size: 20px;
            font-weight: 600;
        }
        .panel-body p {
            font-size: 16px;
            color: #555;
        }
        .navbar {
            border-radius: 0px;
            margin-bottom: 2rem;
        }
        .navbar-brand {
            font-size: 20px;
            font-weight: 600;
        }
        .dropdown-menu {
            border-radius: 0px;
            border-color: #ddd;
        }
        .form-control {
            border-radius: 0px;
        }
        .btn {
            border-radius: 0px;
        }
    </style>
</head>
<body>
    <!-- 세션에서 User_ID 가져오기 -->
    <% 
        String userID = null;
        String userNickName = null;
        String userAdmin = null;
        if (session.getAttribute("userID") != null) {
            userID = (String) session.getAttribute("userID");
            // User 테이블에서 NickName 가져오기
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
    %>

    <!-- 네비게이션 바 -->
    <nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="main.jsp">Novel AI</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav ml-auto">
                    <% if (loggedIn) { %>
                        <li class="nav-item">
                            <a class="nav-link" href="write.jsp?boardID=<%= request.getParameter("boardID") %>">게시글 등록</a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <%= userNickName %>
                            </a>
                            <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                <a class="dropdown-item" href="logoutAction.jsp">로그아웃</a>
                                <a class="dropdown-item" href="updateUser.jsp">회원 정보 수정</a>
                            </div>
                        </li>
                    <% } else { %>
                        <li class="nav-item">
                            <a class="nav-link" href="login.jsp">로그인</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="join.jsp">회원가입</a>
                        </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>
    

    <!-- 게시판 목록 -->
    <div class="container">
        <% 
            // JDBC 연결 및 SQL 문 실행 준비
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

                // 게시판 이름 가져오기
                String boardNameValue = "";
                String boardIDParam = request.getParameter("boardID");
                if (boardIDParam != null && !boardIDParam.isEmpty()) {
                    int boardID = Integer.parseInt(boardIDParam);
                    String boardSql = "SELECT Board_Name FROM Board WHERE Board_ID = ?";
                    pstmt = conn.prepareStatement(boardSql);
                    pstmt.setInt(1, boardID);
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        boardNameValue = rs.getString("Board_Name");
                    }
                    pstmt.close();
                    rs.close();
                }
        %>
        <h3><%= boardNameValue %></h3>
        
        <!-- 검색 폼 -->
        <form action="bbs.jsp" method="GET">
            <div class="form-group">
                <label for="searchKeyword">검색어</label>
                <input type="text" class="form-control" id="searchKeyword" name="searchKeyword" placeholder="검색어를 입력하세요">
            </div>
            <div class="form-group">
                <label for="boardID">게시판</label>
                <select class="form-control" id="boardID" name="boardID">
                    <% 
                        // Board 테이블에서 게시판 정보 가져오기
                        String boardSql = "SELECT * FROM Board";
                        pstmt = conn.prepareStatement(boardSql);
                        rs = pstmt.executeQuery();
                        
                        while (rs.next()) {
                            int boardID = rs.getInt("Board_ID");
                            String boardName = rs.getString("Board_Name");
                            String selected = "";
                            if (boardID == Integer.parseInt(boardIDParam)) {
                                selected = "selected";
                            }
                    %>
                            <option value="<%= boardID %>" <%= selected %>><%= boardName %></option>
                    <% 
                        }
                        pstmt.close();
                        rs.close();
                    %>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">검색</button>
            <button type="button" class="btn btn-default" onclick="resetSearch()">초기화</button>
            <button type="button" class="btn btn-default" onclick="showAllPosts()">전체 글 보기</button>
        </form>

        <!-- 게시글 목록 -->
        <% 
            // 검색어 파라미터 확인
            String searchKeyword = request.getParameter("searchKeyword");
            int boardID = -1;
            if (boardIDParam != null && !boardIDParam.isEmpty()) {
                boardID = Integer.parseInt(boardIDParam);
            }
            
            // SQL 문 동적 생성
            StringBuilder sqlBuilder = new StringBuilder();
            sqlBuilder.append("SELECT * FROM Post ");
            if (searchKeyword != null && !searchKeyword.isEmpty()) {
                sqlBuilder.append("WHERE Title LIKE ? OR User_ID IN (SELECT User_ID FROM User WHERE NickName LIKE ?) ");
            }
            if (boardID != -1) {
                if (sqlBuilder.toString().contains("WHERE")) {
                    sqlBuilder.append("AND Board_ID = ? ");
                } else {
                    sqlBuilder.append("WHERE Board_ID = ? ");
                }
            }
            sqlBuilder.append("ORDER BY POST_code ASC");
            
            String sql = sqlBuilder.toString();
            pstmt = conn.prepareStatement(sql);
            int parameterIndex = 1;
            if (searchKeyword != null && !searchKeyword.isEmpty()) {
                pstmt.setString(parameterIndex++, "%" + searchKeyword + "%");
                pstmt.setString(parameterIndex++, "%" + searchKeyword + "%");
            }
            if (boardID != -1) {
                pstmt.setInt(parameterIndex, boardID);
            }

            rs = pstmt.executeQuery();

            // 게시글 목록 출력
            int count = 1;
            while (rs.next()) {
                int postID = rs.getInt("POST_code");
                String title = rs.getString("Title");
                String date = rs.getString("C_Date");
                String userNickNames = "";
                String modifiedDate = rs.getString("M_Date");

                // User 테이블에서 NickName 가져오기
                String userSql = "SELECT NickName FROM User WHERE User_ID = ?";
                PreparedStatement userPstmt = conn.prepareStatement(userSql);
                userPstmt.setString(1, rs.getString("User_ID"));
                ResultSet userRs = userPstmt.executeQuery();
                if (userRs.next()) {
                    userNickNames = userRs.getString("NickName");
                }
        %>
            <div class="panel panel-default post-panel">
                <div class="panel-body">
                    <h4><a href="view.jsp?postID=<%= postID %>"><%= count %>. <%= title %></a></h4>
                    <p>작성일: <%= date %></p>
                    <p>작성자: <%= userNickNames %></p>
                    <% if (modifiedDate != null) { %>
                        <p>수정일: <%= modifiedDate %></p>
                    <% } else { %>
                        <p>수정일: </p>
                    <% } %>
                    <% if (loggedIn && (userAdmin != null && userAdmin.equals("1"))) { %>
                        <!-- 수정, 삭제 버튼 -->
                        <div class="btn-group">
                            <a href="updatePost.jsp?postID=<%= postID %>&boardID=<%= boardIDParam %>" class="btn btn-primary btn-sm">수정</a>
                            <a href="deleteAction.jsp?postID=<%= postID %>&boardID=<%= boardIDParam %>" class="btn btn-primary btn-sm" onclick="return confirm('정말로 삭제하시겠습니까?')">삭제</a>
                        </div>
                    <% } %>
                </div>
            </div>
        <% 
                count++;
            }
        } catch (Exception e) {
            out.println("MySQL 데이터베이스 처리에 문제가 발생했습니다.<hr>");
            out.println(e.toString());
            e.printStackTrace();
        } finally {
            // 자원 해제
            if (pstmt != null) {
                pstmt.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
    %>

    <!-- 페이징 -->
    <div class="text-center">
        <ul class="pagination">
            <!-- 페이징 코드 추가 -->
        </ul>
    </div>

    <script>
        function resetSearch() {
            document.getElementById("searchKeyword").value = "";
        }

        function showAllPosts() {
            var boardIDParam = document.getElementById("boardID").value;
            window.location.href = "bbs.jsp?boardID=" + boardIDParam;
        }
    </script>
</body>
</html>
