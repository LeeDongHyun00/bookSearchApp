package com.book.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.book.dto.AuthorDTO;
import com.book.dto.BookDTO;
import com.book.dto.CategoryDTO;
import com.book.dto.ReviewDTO;
import com.book.util.DBUtil;

public class BookDAO {

    // 책 목록 조회 (기본 정보만)
    public List<BookDTO> getAllBooks() {
        List<BookDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM 책";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                BookDTO dto = mapBook(rs);
                fillAuthors(conn, dto);
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return list;
    }
    
    // 카테고리별 책 조회
    public List<BookDTO> getBooksByCategory(int categoryId) {
        List<BookDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT b.* FROM 책 b " +
                         "JOIN 책_카테고리 bc ON b.ISBN = bc.책id " +
                         "WHERE bc.카테고리id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, categoryId);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                BookDTO dto = mapBook(rs);
                fillAuthors(conn, dto);
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return list;
    }

    // 책 상세 조회
    public BookDTO getBook(String isbn) {
        BookDTO dto = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM 책 WHERE ISBN = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, isbn);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                dto = mapBook(rs);
                fillAuthors(conn, dto);
                fillCategories(conn, dto);
                fillReviews(conn, dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return dto;
    }

    // 통합 검색 및 필터링
    public List<BookDTO> getBooks(String query, String[] categoryIds, String sort) {
        List<BookDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            StringBuilder sql = new StringBuilder("SELECT DISTINCT b.* FROM 책 b ");
            
            if (categoryIds != null && categoryIds.length > 0) {
                sql.append("JOIN 책_카테고리 bc ON b.ISBN = bc.책id ");
            }
            
            if (query != null && !query.trim().isEmpty()) {
                sql.append("LEFT JOIN 책_저자 ba ON b.ISBN = ba.책id ");
                sql.append("LEFT JOIN 저자 a ON ba.저자id = a.저자id ");
            }
            
            sql.append("WHERE 1=1 ");
            
            // 검색 조건
            if (query != null && !query.trim().isEmpty()) {
                sql.append("AND (b.책제목 LIKE ? OR b.출판사 LIKE ? OR a.저자이름 LIKE ?) ");
            }
            
            // 카테고리 조건
            if (categoryIds != null && categoryIds.length > 0) {
                sql.append("AND bc.카테고리id IN (");
                for (int i = 0; i < categoryIds.length; i++) {
                    sql.append(i == 0 ? "?" : ", ?");
                }
                sql.append(") ");
            }
            
            // 정렬
            if ("popular".equals(sort)) {
                sql.append("ORDER BY b.리뷰참가자수 DESC");
            } else if ("rating".equals(sort)) {
                sql.append("ORDER BY b.리뷰평균점수 DESC");
            } else {
                sql.append("ORDER BY b.ISBN DESC");
            }
            
            pstmt = conn.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (query != null && !query.trim().isEmpty()) {
                String searchPattern = "%" + query + "%";
                pstmt.setString(paramIndex++, searchPattern);
                pstmt.setString(paramIndex++, searchPattern);
                pstmt.setString(paramIndex++, searchPattern);
            }
            
            if (categoryIds != null && categoryIds.length > 0) {
                for (String catId : categoryIds) {
                    pstmt.setInt(paramIndex++, Integer.parseInt(catId));
                }
            }
            
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                BookDTO dto = mapBook(rs);
                fillAuthors(conn, dto);
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return list;
    }
    
    private BookDTO mapBook(ResultSet rs) throws Exception {
        return new BookDTO(
            rs.getString("ISBN"),
            rs.getString("책제목"),
            rs.getString("출판사"),
            rs.getString("책소개"),
            rs.getString("표지이미지"),
            rs.getInt("e북여부") == 1,
            rs.getDouble("리뷰평균점수"),
            rs.getInt("리뷰참가자수")
        );
    }
    
    private void fillAuthors(Connection conn, BookDTO book) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT a.* FROM 저자 a JOIN 책_저자 ba ON a.저자id = ba.저자id WHERE ba.책id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, book.getIsbn());
            rs = pstmt.executeQuery();
            while(rs.next()) {
                book.getAuthors().add(new AuthorDTO(rs.getInt("저자id"), rs.getString("저자이름")));
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            // Connection은 닫지 않음
            DBUtil.close(rs, pstmt, null);
        }
    }
    
    private void fillCategories(Connection conn, BookDTO book) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT c.* FROM 카테고리 c JOIN 책_카테고리 bc ON c.카테고리id = bc.카테고리id WHERE bc.책id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, book.getIsbn());
            rs = pstmt.executeQuery();
            while(rs.next()) {
                book.getCategories().add(new CategoryDTO(rs.getInt("카테고리id"), rs.getString("카테고리이름")));
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, null);
        }
    }
    
    private void fillReviews(Connection conn, BookDTO book) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            // 사용자 닉네임도 같이 가져오기 위해 조인
            String sql = "SELECT r.*, u.닉네임 FROM 리뷰 r JOIN 사용자 u ON r.사용자id = u.사용자id WHERE r.책id = ? ORDER BY r.작성일 DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, book.getIsbn());
            rs = pstmt.executeQuery();
            while(rs.next()) {
                ReviewDTO review = new ReviewDTO(
                    rs.getInt("리뷰id"),
                    rs.getString("책id"),
                    rs.getString("사용자id"),
                    rs.getString("리뷰내용"),
                    rs.getInt("리뷰점수"),
                    rs.getTimestamp("작성일")
                );
                review.setUserName(rs.getString("닉네임"));
                book.getReviews().add(review);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, null);
        }
    }

    // 책 평점 및 리뷰 수 업데이트 (증분 방식)
    public void updateBookRating(String isbn, int scoreDelta, int countDelta) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
            // 1. 현재 평점과 리뷰 수 조회
            String selectSql = "SELECT 리뷰평균점수, 리뷰참가자수 FROM 책 WHERE ISBN = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setString(1, isbn);
            rs = pstmt.executeQuery();
            
            double currentAvg = 0.0;
            int currentCount = 0;
            
            if(rs.next()) {
                currentAvg = rs.getDouble("리뷰평균점수");
                currentCount = rs.getInt("리뷰참가자수");
            }
            DBUtil.close(rs, pstmt, null);
            
            // 2. 새로운 값 계산
            int newCount = currentCount + countDelta;
            double newAvg = 0.0;
            
            if(newCount > 0) {
                // (기존평균 * 기존수 + 점수변화량) / 새로운수
                double totalScore = (currentAvg * currentCount) + scoreDelta;
                newAvg = totalScore / newCount;
                // 소수점 한자리 반올림
                newAvg = Math.round(newAvg * 10) / 10.0;
            }
            
            // 3. 업데이트
            String updateSql = "UPDATE 책 SET 리뷰평균점수 = ?, 리뷰참가자수 = ? WHERE ISBN = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setDouble(1, newAvg);
            pstmt.setInt(2, newCount);
            pstmt.setString(3, isbn);
            pstmt.executeUpdate();
            
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
    }

    // 책 수정 (관리자용)
    public boolean updateBook(BookDTO book) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            
            String sql = "UPDATE 책 SET 책제목=?, 출판사=?, 책소개=?, 표지이미지=?, e북여부=? WHERE ISBN=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, book.getTitle());
            pstmt.setString(2, book.getPublisher());
            pstmt.setString(3, book.getSynopsis());
            pstmt.setString(4, book.getCoverImage());
            pstmt.setInt(5, book.isEbook() ? 1 : 0);
            pstmt.setString(6, book.getIsbn());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch(Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(null, pstmt, conn);
        }
    }
    
    // 책 삭제 (관리자용)
    public boolean deleteBook(String isbn) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작
            
            // 1. 책_저자 관계 삭제
            String sqlAuthor = "DELETE FROM 책_저자 WHERE 책id = ?";
            pstmt = conn.prepareStatement(sqlAuthor);
            pstmt.setString(1, isbn);
            pstmt.executeUpdate();
            pstmt.close();
            
            // 2. 책_카테고리 관계 삭제
            String sqlCategory = "DELETE FROM 책_카테고리 WHERE 책id = ?";
            pstmt = conn.prepareStatement(sqlCategory);
            pstmt.setString(1, isbn);
            pstmt.executeUpdate();
            pstmt.close();
            
            // 3. 리뷰 삭제
            String sqlReview = "DELETE FROM 리뷰 WHERE 책id = ?";
            pstmt = conn.prepareStatement(sqlReview);
            pstmt.setString(1, isbn);
            pstmt.executeUpdate();
            pstmt.close();
            
            // 4. 책 삭제
            String sqlBook = "DELETE FROM 책 WHERE ISBN = ?";
            pstmt = conn.prepareStatement(sqlBook);
            pstmt.setString(1, isbn);
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
            
        } catch(Exception e) {
            e.printStackTrace();
            try { if(conn != null) conn.rollback(); } catch(Exception ex) {}
            return false;
        } finally {
            try { if(conn != null) conn.setAutoCommit(true); } catch(Exception ex) {}
            DBUtil.close(null, pstmt, conn);
        }
    }
    // 인기 도서 Top N 조회
    public List<BookDTO> getTopBooks(int limit) {
        List<BookDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            // 리뷰수와 평점 순으로 정렬
            String sql = "SELECT * FROM 책 ORDER BY 리뷰참가자수 DESC, 리뷰평균점수 DESC  LIMIT ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                BookDTO dto = mapBook(rs);
                fillAuthors(conn, dto);
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return list;
    }
    
    // 인기 작가 Top N 조회 (책이 많은 순 or 랜덤)
    // NOTE: 실제 작가 평점이 없으므로 책이 많은 순, 그리고 가나다순으로 정렬하여 조회
    public List<AuthorDTO> getTopAuthors(int limit) {
        List<AuthorDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT a.*, COUNT(ba.책id) as book_count " +
                         "FROM 저자 a " +
                         "JOIN 책_저자 ba ON a.저자id = ba.저자id " +
                         "GROUP BY a.저자id " +
                         "ORDER BY book_count DESC " +
                         "LIMIT ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                list.add(new AuthorDTO(rs.getInt("저자id"), rs.getString("저자이름")));
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return list;
    }
}
