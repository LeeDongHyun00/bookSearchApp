package com.book.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.book.dao.UserDAO;
import com.book.dto.UserDTO;

@WebServlet("/adminUpdateUser")
public class AdminUpdateUserServlet extends HttpServlet {
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
		
		// Get parameters
		String targetUserId = request.getParameter("targetUserId");
		String nickname = request.getParameter("nickname");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		
		// Get current user data
		UserDTO user = userDAO.getUser(targetUserId);
		
		if (user == null) {
			response.getWriter().write("<script>alert('사용자를 찾을 수 없습니다.'); location.href='admin.jsp?tab=users';</script>");
			return;
		}
		
		// Update user data
		user.setNickname(nickname);
		user.setEmail(email);
		
		// Only update password if provided
		if (password != null && !password.trim().isEmpty()) {
			user.setPassword(password);
		}
		
		boolean isSuccess = userDAO.updateUser(user);
		
		if (isSuccess) {
			response.getWriter().write("<script>alert('회원 정보가 수정되었습니다.'); location.href='admin.jsp';</script>");
		} else {
			response.getWriter().write("<script>alert('수정에 실패했습니다.'); history.back();</script>");
		}
	}
}
