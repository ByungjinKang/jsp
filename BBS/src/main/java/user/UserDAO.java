package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/jsp41";
			String dbID = "jsp41";
			String dbPassword = "poiu0987";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID=?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString(1).equals(userPassword))
					return 1; // 로그인 성공
				else
					return 0; // 비밀번호 틀림
			}
			return -1; // 아이디 없음 
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -2; // DB 오류 
	}
	
	public int join(User user) {
		String SQL = "INSERT INTO USER (PW, User_name, Sex, PH, AD, NickName, Admin, Email) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getPW());
			pstmt.setString(2, user.getUser_name());
			pstmt.setString(3, user.getSex());
			pstmt.setString(4, user.getPH());
			pstmt.setString(5, user.getAD());
			pstmt.setString(6, user.getNickName());
			pstmt.setString(7, user.getAdmin());
			pstmt.setString(8, user.getEmail());
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // DB 오류 
	}
}
