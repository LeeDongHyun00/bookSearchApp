package com.book.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.book.dto.CategoryDTO;
import com.book.util.DBUtil;

public class CategoryDAO {
    
    public List<CategoryDTO> getAllCategories() {
        List<CategoryDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM 카테고리 ORDER BY 카테고리id";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                CategoryDTO dto = new CategoryDTO(
                    rs.getInt("카테고리id"),
                    rs.getString("카테고리이름")
                );
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
