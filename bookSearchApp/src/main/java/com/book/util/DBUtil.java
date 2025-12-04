package com.book.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBUtil {
    // 로컬 MySQL 설정
    private static final String HOST = "localhost";
    private static final String PORT = "3306"; 
    private static final String DB_NAME = "booksearchapp";
    private static final String USER = "root";
    private static final String PASS = "password";
    
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
