package com.book.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBUtil {
    private static String HOST;
    private static String PORT;
    private static String DB_NAME;
    private static String USER;
    private static String PASS;
    private static String URL;

    private static java.util.Properties properties = new java.util.Properties();

    static {
        try {
            // Priority 1: Try root classpath (src/main/java/db.properties)
            java.io.InputStream input = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
            
            // Priority 2: Try /db.properties explicitly
            if (input == null) {
                input = DBUtil.class.getResourceAsStream("/db.properties");
            }

            if (input == null) {
                System.err.println("CRITICAL ERROR: Unable to find db.properties!");
                System.err.println("Tried: classpath root and /db.properties");
                // Default fallback
            } else {
                properties.load(input);
                HOST = properties.getProperty("HOST");
                PORT = properties.getProperty("PORT");
                DB_NAME = properties.getProperty("DB_NAME");
                USER = properties.getProperty("USER");
                PASS = properties.getProperty("PASS");
                input.close();
            }
            
            URL = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DB_NAME 
                + "?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Seoul&useSSL=false&allowPublicKeyRetrieval=true";
                
        } catch (java.io.IOException ex) {
            ex.printStackTrace();
        }
    }
    
    public static String getProperty(String key) {
        return properties.getProperty(key);
    }
    
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // 드라이버 로드
            Class.forName("com.mysql.cj.jdbc.Driver");
           
            // 연결 시도
            conn = DriverManager.getConnection(URL, USER, PASS);
            
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
