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

    static {
        try (java.io.InputStream input = DBUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            java.util.Properties prop = new java.util.Properties();
            
            if (input == null) {
                System.err.println("Sorry, unable to find db.properties. Make sure it is in the classpath (src/main/resources).");
                // Set default values or throw exception
                HOST = "localhost";
                PORT = "3306";
                DB_NAME = "BookSearchApp";
                USER = "root";
                PASS = "";
            } else {
                prop.load(input);
                HOST = prop.getProperty("HOST");
                PORT = prop.getProperty("PORT");
                DB_NAME = prop.getProperty("DB_NAME");
                USER = prop.getProperty("USER");
                PASS = prop.getProperty("PASS");
            }
            
            URL = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DB_NAME 
                + "?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Seoul&useSSL=false&allowPublicKeyRetrieval=true";
                
        } catch (java.io.IOException ex) {
            ex.printStackTrace();
        }
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
