package com.book.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.book.dto.ReviewDTO;
import com.book.util.DBUtil;

public class ReviewDAO {
    private BookDAO bookDAO = new BookDAO();

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
            if(count > 0) {
                result = true;
                // 평점 업데이트 (점수, +1명)
                bookDAO.updateBookRating(review.getBookId(), review.getRating(), 1);
            }
            
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
    // 특정 사용자의 특정 책 리뷰 조회
    public ReviewDTO getReview(String userId, String isbn) {
        ReviewDTO review = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM 리뷰 WHERE 사용자id = ? AND 책id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, isbn);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                review = new ReviewDTO(
                    rs.getInt("리뷰id"),
                    rs.getString("책id"),
                    rs.getString("사용자id"),
                    rs.getString("리뷰내용"),
                    rs.getInt("리뷰점수"),
                    rs.getTimestamp("작성일")
                );
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return review;
    }

    // 리뷰 수정
    public boolean updateReview(ReviewDTO review) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean result = false;
        int oldRating = 0;
        
        try {
            conn = DBUtil.getConnection();
            
            // 수정 전 기존 평점 조회
            String selectSql = "SELECT 리뷰점수 FROM 리뷰 WHERE 리뷰id = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, review.getReviewId());
            ResultSet rs = pstmt.executeQuery();
            if(rs.next()) {
                oldRating = rs.getInt("리뷰점수");
            }
            DBUtil.close(rs, pstmt, null);
            
            String sql = "UPDATE 리뷰 SET 리뷰내용 = ?, 리뷰점수 = ?, 작성일 = NOW() WHERE 리뷰id = ? AND 사용자id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, review.getContent());
            pstmt.setInt(2, review.getRating());
            pstmt.setInt(3, review.getReviewId());
            pstmt.setString(4, review.getUserId());
            
            int count = pstmt.executeUpdate();
            if(count > 0) {
                result = true;
                // 평점 업데이트 (점수차이, 인원변동없음)
                int scoreDelta = review.getRating() - oldRating;
                bookDAO.updateBookRating(review.getBookId(), scoreDelta, 0);
            }
            
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(pstmt, conn);
        }
        return result;
    }

    // 리뷰 삭제
    public boolean deleteReview(int reviewId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean result = false;
        String isbn = null;
        int oldRating = 0;
        
        try {
            conn = DBUtil.getConnection();
            
            // 삭제 전 ISBN 및 평점 조회
            String selectSql = "SELECT 책id, 리뷰점수 FROM 리뷰 WHERE 리뷰id = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, reviewId);
            rs = pstmt.executeQuery();
            if(rs.next()) {
                isbn = rs.getString("책id");
                oldRating = rs.getInt("리뷰점수");
            }
            DBUtil.close(rs, pstmt, null);
            
            if(isbn != null) {
                String deleteSql = "DELETE FROM 리뷰 WHERE 리뷰id = ?";
                pstmt = conn.prepareStatement(deleteSql);
                pstmt.setInt(1, reviewId);
                int count = pstmt.executeUpdate();
                
                if(count > 0) {
                    result = true;
                    // 평점 업데이트 (점수차감, -1명)
                    bookDAO.updateBookRating(isbn, -oldRating, -1);
                }
            }
            
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return result;
    }
    // 전체 리뷰 수 조회
    public int getTotalReviewCount() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT COUNT(*) FROM 리뷰";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                count = rs.getInt(1);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return count;
    }
}
