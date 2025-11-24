package com.book.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.book.dto.UserDTO;
import com.book.util.DBUtil;

public class UserDAO {
	
	// Login
	public UserDTO login(String userId, String password) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		UserDTO user = null;
		
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT * FROM 사용자 WHERE 사용자id = ? AND 비밀번호 = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			pstmt.setString(2, password);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				user = new UserDTO();
				user.setUserId(rs.getString("사용자id"));
				user.setPassword(rs.getString("비밀번호"));
				user.setEmail(rs.getString("이메일"));
				user.setNickname(rs.getString("닉네임"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.close(rs, pstmt, conn);
		}
		return user;
	}
	
	// Insert User (Signup)
	public boolean insertUser(UserDTO user) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int result = 0;
		
		try {
			conn = DBUtil.getConnection();
			String sql = "INSERT INTO 사용자 (사용자id, 비밀번호, 이메일, 닉네임) VALUES (?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUserId());
			pstmt.setString(2, user.getPassword());
			pstmt.setString(3, user.getEmail());
			pstmt.setString(4, user.getNickname());
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.close(pstmt, conn);
		}
		return result > 0;
	}
	
	// Check ID Availability
	public boolean checkId(String userId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean exists = false;
		
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT count(*) FROM 사용자 WHERE 사용자id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			
			if(rs.next() && rs.getInt(1) > 0) {
				exists = true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.close(rs, pstmt, conn);
		}
		return exists;
	}
	
	// Get User Info
	public UserDTO getUser(String userId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		UserDTO user = null;
		
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT * FROM 사용자 WHERE 사용자id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				user = new UserDTO();
				user.setUserId(rs.getString("사용자id"));
				user.setPassword(rs.getString("비밀번호"));
				user.setEmail(rs.getString("이메일"));
				user.setNickname(rs.getString("닉네임"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.close(rs, pstmt, conn);
		}
		return user;
	}
	
	// Update User Info
	public boolean updateUser(UserDTO user) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int result = 0;
		
		try {
			conn = DBUtil.getConnection();
			String sql = "UPDATE 사용자 SET 비밀번호 = ?, 이메일 = ?, 닉네임 = ? WHERE 사용자id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getPassword());
			pstmt.setString(2, user.getEmail());
			pstmt.setString(3, user.getNickname());
			pstmt.setString(4, user.getUserId());
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.close(pstmt, conn);
		}
		return result > 0;
	}

	// Get All Users for Admin
	public List<UserDTO> getAllUsers() {
		List<UserDTO> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT * FROM 사용자";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				UserDTO user = new UserDTO();
				user.setUserId(rs.getString("사용자id"));
				user.setEmail(rs.getString("이메일"));
				user.setNickname(rs.getString("닉네임"));
				list.add(user);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.close(rs, pstmt, conn);
		}
		return list;
	}

	// Delete User (Withdrawal)
	public boolean deleteUser(String userId) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int result = 0;
		
		try {
			conn = DBUtil.getConnection();
			String sql = "DELETE FROM 사용자 WHERE 사용자id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userId);
			
			result = pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.close(pstmt, conn);
		}
		return result > 0;
	}

	// Check Nickname Availability
	public boolean checkNickname(String nickname) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean exists = false;
		
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT count(*) FROM 사용자 WHERE 닉네임 = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nickname);
			rs = pstmt.executeQuery();
			
			if(rs.next() && rs.getInt(1) > 0) {
				exists = true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.close(rs, pstmt, conn);
		}
		return exists;
	}

	// Check Email Availability
	public boolean checkEmail(String email) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean exists = false;
		
		try {
			conn = DBUtil.getConnection();
			String sql = "SELECT count(*) FROM 사용자 WHERE 이메일 = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();
			
			if(rs.next() && rs.getInt(1) > 0) {
				exists = true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.close(rs, pstmt, conn);
		}
		return exists;
	}
}
