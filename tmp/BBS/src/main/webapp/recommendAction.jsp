<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>

<%
    // 현재 페이지 URL 가져오기
    String currentURL = request.getRequestURL().toString();

    // URL에서 쿼리 파라미터 추출
    String postID = request.getParameter("postID");

    String userID = null; // userID 변수 선언

    // 세션에서 userID 가져오기
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    } else {
        response.sendRedirect("login.jsp"); // 로그인되지 않은 경우 로그인 페이지로 리다이렉트
        return;
    }

    Connection conn = null;
    PreparedStatement recommendCheckPstmt = null;
    PreparedStatement recommendInsertPstmt = null;
    PreparedStatement recommendDeletePstmt = null;
    int recommendCount = 0;
    boolean isRecommended = false;

    try {
        // 데이터베이스 연결
        String driverName = "com.mysql.jdbc.Driver";
        String dbURL = "jdbc:mysql://localhost:3306/jsp41";
        String dbUser = "jsp41";
        String dbPassword = "poiu0987";

        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // 이미 추천한 기록이 있는지 확인
        String recommendCheckSql = "SELECT * FROM Recommend WHERE POST_code = ? AND User_ID = ?";
        recommendCheckPstmt = conn.prepareStatement(recommendCheckSql);
        recommendCheckPstmt.setString(1, postID);
        recommendCheckPstmt.setString(2, userID);
        ResultSet recommendCheckRs = recommendCheckPstmt.executeQuery();

        if (recommendCheckRs.next()) { // 이미 추천한 경우 추천 취소
            isRecommended = true;

            String recommendDeleteSql = "DELETE FROM Recommend WHERE POST_code = ? AND User_ID = ?";
            recommendDeletePstmt = conn.prepareStatement(recommendDeleteSql);
            recommendDeletePstmt.setString(1, postID);
            recommendDeletePstmt.setString(2, userID);
            recommendDeletePstmt.executeUpdate();
        } else { // 추천한 기록이 없는 경우 추천 추가
            String recommendInsertSql = "INSERT INTO Recommend (POST_code, User_ID) VALUES (?, ?)";
            recommendInsertPstmt = conn.prepareStatement(recommendInsertSql);
            recommendInsertPstmt.setString(1, postID);
            recommendInsertPstmt.setString(2, userID);
            recommendInsertPstmt.executeUpdate();
        }

        // 추천 수 가져오기
        String recommendCountSql = "SELECT COUNT(*) AS count FROM Recommend WHERE POST_code = ?";
        PreparedStatement recommendCountPstmt = conn.prepareStatement(recommendCountSql);
        recommendCountPstmt.setString(1, postID);
        ResultSet recommendCountRs = recommendCountPstmt.executeQuery();
        if (recommendCountRs.next()) {
            recommendCount = recommendCountRs.getInt("count");
        }

        // 데이터베이스 연결 종료
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (isRecommended) {
        out.println("추천이 취소되었습니다.");
    } else {
        out.println("추천되었습니다.");
    }

    out.println("추천 수: " + recommendCount);

    response.sendRedirect("view.jsp?postID=" + postID);
%>
