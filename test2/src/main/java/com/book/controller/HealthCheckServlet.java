package com.book.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import com.book.util.DBUtil;

@WebServlet("/health")
public class HealthCheckServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/plain; charset=UTF-8");
		
		Connection conn = null;
		try {
			conn = DBUtil.getConnection();
			if (conn != null && !conn.isClosed()) {
				response.getWriter().write("Database Connection: OK");
			} else {
				response.getWriter().write("Database Connection: FAILED (Connection is null or closed)");
			}
		} catch (SQLException e) {
			response.getWriter().write("Database Connection: ERROR (" + e.getMessage() + ")");
			e.printStackTrace();
		} finally {
			DBUtil.close(conn);
		}
	}
}
