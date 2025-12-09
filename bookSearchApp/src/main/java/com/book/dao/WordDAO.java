package com.book.dao;

import com.book.dto.WordDTO;
import com.book.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WordDAO {
    
    public List<WordDTO> getAllWords() {
        List<WordDTO> words = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "SELECT id, word, category, created_at FROM FORBIDDEN_WORDS"; 

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                WordDTO word = new WordDTO();
                word.setWordId(rs.getInt("id"));
                word.setWord(rs.getString("word"));
                word.setCategory(rs.getString("category"));
                word.setRegDate(rs.getString("created_at"));
                words.add(word);
            }
        } catch (SQLException e) {
            System.err.println("금지어 목록 조회 오류: " + e.getMessage());
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }
        return words;
    }
}