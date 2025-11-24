package com.book.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.book.dao.UserDAO;

@WebServlet("/adminBanUser")
public class AdminBanUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDAO userDAO = new UserDAO();

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		// Admin security check
		HttpSession session = request.getSession();
		String currentUserId = (String) session.getAttribute("username");
		
		if (!"admin".equals(currentUserId)) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		// Get user ID to ban
		String targetUserId = request.getParameter("userId");
		
		if (targetUserId == null || targetUserId.trim().isEmpty()) {
			response.getWriter().write("<script>alert('사용자 ID가 유효하지 않습니다.'); history.back();</script>");
			return;
		}
		
		// Prevent banning admin
		if ("admin".equals(targetUserId)) {
			response.getWriter().write("<script>alert('관리자는 추방할 수 없습니다.'); history.back();</script>");
			return;
		}
		
		boolean isSuccess = userDAO.deleteUser(targetUserId);
		
		if (isSuccess) {
			response.getWriter().write("<script>alert('회원이 추방되었습니다.'); location.href='admin.jsp';</script>");
		} else {
			response.getWriter().write("<script>alert('추방에 실패했습니다.'); history.back();</script>");
		}
	}
}
