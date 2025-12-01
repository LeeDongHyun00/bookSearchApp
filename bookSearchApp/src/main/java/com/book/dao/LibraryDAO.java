package com.book.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.book.dto.LibraryDTO;
import com.book.util.DBUtil;

public class LibraryDAO {

    // 서재에 책 추가
    public boolean addToLibrary(String userId, String isbn) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean result = false;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO 서재 (사용자id, 책id, 등록일) VALUES (?, ?, NOW())";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, isbn);
            
            int count = pstmt.executeUpdate();
            if(count > 0) result = true;
            
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(pstmt, conn);
        }
        return result;
    }
    
    // 이미 서재에 있는지 확인
    public boolean isInLibrary(String userId, String isbn) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean result = false;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT count(*) FROM 서재 WHERE 사용자id = ? AND 책id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, isbn);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                if(rs.getInt(1) > 0) result = true;
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return result;
    }
    
    // 사용자의 서재 목록 조회 (필요시 사용)
    public List<LibraryDTO> getUserLibrary(String userId) {
        List<LibraryDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT l.*, b.책제목, b.표지이미지 FROM 서재 l " +
                         "JOIN 책 b ON l.책id = b.ISBN " +
                         "WHERE l.사용자id = ? ORDER BY l.등록일 DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                LibraryDTO dto = new LibraryDTO(
                    rs.getInt("서재id"),
                    rs.getString("사용자id"),
                    rs.getString("책id"),
                    rs.getTimestamp("등록일")
                );
                dto.setBookTitle(rs.getString("책제목"));
                dto.setBookCover(rs.getString("표지이미지"));
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return list;
    }
}
