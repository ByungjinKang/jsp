<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>

<%
    // 세션에서 User_ID 가져오기
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }

    // 게시글 등록 처리
    if (userID != null && request.getParameter("bbsTitle") != null && request.getParameter("bbsContent") != null && request.getParameter("boardID") != null) {
        String directory = application.getRealPath("./upload/");
        int maxSize = 1024 * 1024 * 100;
        String encoding = "UTF-8";

        MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding, new DefaultFileRenamePolicy());
        String fileName = multipartRequest.getOriginalFileName("file");
        String fileRealName = multipartRequest.getFilesystemName("file");
        String title = multipartRequest.getParameter("bbsTitle");
        String content = multipartRequest.getParameter("bbsContent");
        int boardID = Integer.parseInt(multipartRequest.getParameter("boardID"));

        // 비속어 필터링
        String[] profanityWords = {"18년18놈", "18새끼"}; // 비속어 목록
        boolean containsProfanity = false;

        for (String word : profanityWords) {
            if (content.contains(word) || title.contains(word)) {
                containsProfanity = true;
                break;
            }
        }

        if (containsProfanity) {
            out.println("<script>");
            out.println("alert('글 등록에 실패했습니다. 비속어를 포함하고 있습니다.')");
            out.println("history.back()");
            out.println("</script>");
        } else {
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                String driverName = "com.mysql.jdbc.Driver";
                String dbURL = "jdbc:mysql://localhost:3306/jsp41";
                String dbUser = "jsp41";
                String dbPassword = "poiu0987";

                Class.forName(driverName);
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                String sql = "INSERT INTO Post (User_ID, C_Date, Title, Content, Board_ID, FileName, FileRealName) VALUES (?, NOW(), ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, userID);
                pstmt.setString(2, title);
                pstmt.setString(3, content);
                pstmt.setInt(4, boardID);
                pstmt.setString(5, fileName);
                pstmt.setString(6, fileRealName);
                pstmt.executeUpdate();

                response.sendRedirect("bbs.jsp?boardID=" + boardID); // 해당 게시판 페이지로 이동
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
        }
    } else {
        out.println("<script>");
        out.println("alert('글 등록에 실패했습니다. 모든 항목을 입력해주세요.')");
        out.println("history.back()");
        out.println("</script>");
    }
%>
