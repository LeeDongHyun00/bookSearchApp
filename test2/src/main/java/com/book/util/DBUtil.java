package com.book.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBUtil {
    // 로컬 MySQL 설정
    private static final String HOST = "YOUR_LOCAH_HOST";
    private static final String PORT = "YOUR_PORT"; 
    private static final String DB_NAME = "YOUT_DB_NAME";
    private static final String USER = "YOUR_ID";
    private static final String PASS = "YOUR_PASSWORD";
    
    private static final String URL = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DB_NAME 
            + "?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Seoul&useSSL=false&allowPublicKeyRetrieval=true";
    
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // 드라이버 로드
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 연결 시도
            conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("Local DB Connection Success!");
            
        } catch(ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch(SQLException e) {
            System.err.println("Connection Failed: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
    
    // 자원 해제
    public static void close(Connection conn) {
        try {
            if(conn != null && !conn.isClosed()) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public static void close(PreparedStatement pstmt, Connection conn) {
        close(null, pstmt, conn); 
    }
    
    // 자원 해제
    public static void close(ResultSet rs, PreparedStatement pstmt, Connection conn) {
        try {
            if(rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if(pstmt != null) pstmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if(conn != null && !conn.isClosed()) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
