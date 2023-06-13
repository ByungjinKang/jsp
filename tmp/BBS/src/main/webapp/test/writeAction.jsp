<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "java.io.File" %>
<%@ page import = "com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import = "com.oreilly.servlet.MultipartRequest" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
 
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page"></jsp:useBean>
<jsp:setProperty name="bbs" property="bbsTitle"/>
<jsp:setProperty name="bbs" property="bbsContent"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; c harset=UTF-8">
<title>JSP BBS</title>
</head>
<body>
    <% 
    try{
    	
    	String userID = null;
    	if (session.getAttribute("userID") != null){
            userID = (String) session.getAttribute("userID");
    	}
    	if (userID == null){ //로그인 안했을경우;
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인하세요.')");
            script.println("location.href = 'login.jsp'");    // 메인 페이지로 이동
            script.println("</script>");
    	}else{
    		
    			
    	
    			
    		String directory = application.getRealPath("upload");
    		int maxSize = 1024 * 1024 * 100;
    		String encoding = "UTF-8";
    		
    		MultipartRequest multipartRequest
    		= new MultipartRequest(request, directory, maxSize, encoding, new DefaultFileRenamePolicy());
    		String bbstitle = multipartRequest.getParameter("bbsTitle");
    		String bbscontent = multipartRequest.getParameter("bbsContent");
    		String fileName = multipartRequest.getOriginalFileName("file");
    		String fileRealName = multipartRequest.getFilesystemName("file");
    		
    		
    		
    		if (bbstitle == null || bbscontent == null){
        		PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('모든 문항을 입력해주세요.')");
                script.println("history.back()");    // 이전 페이지로 사용자를 보냄
                script.println("</script>");
        	}else{
        		BbsDAO bbsDAO = new BbsDAO();
                int result = bbsDAO.write(bbstitle, userID, bbscontent, fileName, fileRealName);
                if (result == -1){ // 글쓰기 실패시
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("alert('글쓰기에 실패했습니다.')");
                    script.println("history.back()");    // 이전 페이지로 사용자를 보냄
                    script.println("</script>");
                }else{ // 글쓰기 성공시
                	PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("location.href = 'bbs.jsp'");    // 메인 페이지로 이동
                    script.println("</script>");    
                }
        	}	
   
		}
    	
    		
	}		catch(IOException ioe){
		out.println(ioe);
		} catch	(Exception ex){
			out.println(ex);
    }
    %>
 
</body>
</html>