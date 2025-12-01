package com.book.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.book.dto.ReviewDTO;
import com.book.util.DBUtil;

public class ReviewDAO {

    // 리뷰 추가
    public boolean addReview(ReviewDTO review) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean result = false;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO 리뷰 (책id, 사용자id, 리뷰내용, 리뷰점수, 작성일) VALUES (?, ?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, review.getBookId());
            pstmt.setString(2, review.getUserId());
            pstmt.setString(3, review.getContent());
            pstmt.setInt(4, review.getRating());
            
            int count = pstmt.executeUpdate();
            if(count > 0) result = true;
            
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(pstmt, conn);
        }
        return result;
    }
    
    // 특정 책의 리뷰 목록 조회
    public List<ReviewDTO> getReviewsByBook(String isbn) {
        List<ReviewDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT r.*, u.닉네임 FROM 리뷰 r " +
                         "JOIN 사용자 u ON r.사용자id = u.사용자id " +
                         "WHERE r.책id = ? ORDER BY r.작성일 DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, isbn);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                ReviewDTO dto = new ReviewDTO(
                    rs.getInt("리뷰id"),
                    rs.getString("책id"),
                    rs.getString("사용자id"),
                    rs.getString("리뷰내용"),
                    rs.getInt("리뷰점수"),
                    rs.getTimestamp("작성일")
                );
                dto.setUserName(rs.getString("닉네임"));
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return list;
    }
    
    // 특정 사용자의 리뷰 목록 조회
    public List<ReviewDTO> getReviewsByUser(String userId) {
        List<ReviewDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT r.*, b.책제목 FROM 리뷰 r " +
                         "JOIN 책 b ON r.책id = b.ISBN " +
                         "WHERE r.사용자id = ? ORDER BY r.작성일 DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                ReviewDTO dto = new ReviewDTO(
                    rs.getInt("리뷰id"),
                    rs.getString("책id"),
                    rs.getString("사용자id"),
                    rs.getString("리뷰내용"),
                    rs.getInt("리뷰점수"),
                    rs.getTimestamp("작성일")
                );
                dto.setBookTitle(rs.getString("책제목"));
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
