<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <title>JSP 게시판 웹 사이트</title>
    <style>
        .container {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <%
        // 세션에서 User_ID 가져오기
        String userID = null;
        String userNickName = null;
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

    <nav class="navbar navbar-default">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
            </div>
            <div class="collapse navbar-collapse">
                <ul class="nav navbar-nav navbar-right">
                    <% if (loggedIn) { %>
                        <li><a href="write.jsp?boardID=<%= request.getParameter("boardID") %>">게시글 등록</a></li> <!-- 수정: write.jsp로 이동할 때 boardID 전달 -->
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                <%= userNickName %><span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a href="logoutAction.jsp">로그아웃</a></li>
                            </ul>
                        </li>
                    <% } else { %>
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h3>게시판</h3>
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
        <h4>게시판: <%= boardNameValue %></h4>
        
        <form action="bbs.jsp" method="GET">
            <div class="form-group">
                <label for="searchKeyword">검색어</label>
                <input type="text" class="form-control" id="searchKeyword" name="searchKeyword" placeholder="검색어를 입력하세요">
            </div>
            <div class="form-group">
                <label for="boardID">게시판</label>
                <select class="form-control" id="boardID" name="boardID">
                    <option value="">전체 게시판</option>
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
                int postCode = rs.getInt("POST_code");
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
            <div class="panel panel-default">
                <div class="panel-body">
                    <h4><a href="view.jsp?postCode=<%= postCode %>"><%= count %>. <%= title %></a></h4>
                    <p>작성일: <%= date %></p>
                    <p>작성자: <%= userNickNames %></p>
                    <% if (modifiedDate != null) { %>
                        <p>수정일: <%= modifiedDate %></p>
                    <% } else { %>
                        <p>수정일: </p>
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
