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

@WebServlet("/adminAddUser")
public class AdminAddUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDAO userDAO = new UserDAO();

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		// Admin security check
		HttpSession session = request.getSession();
		String currentUserId = (String) session.getAttribute("username");
		
		if (!"admin".equals(currentUserId)) {
			response.sendRedirect("admin.jsp");
			return;
		}
		
		// Get user parameters
		String userId = request.getParameter("userId");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String nickname = request.getParameter("nickname");
		
		// Create new user
		UserDTO user = new UserDTO(userId, password, email, nickname);
		boolean isSuccess = userDAO.insertUser(user);
		
		// Always redirect to admin dashboard, never to login
		if (isSuccess) {
			session.setAttribute("successMessage", "회원이 추가되었습니다.");
			response.sendRedirect("admin.jsp");
		} else {
			session.setAttribute("errorMessage", "회원 추가에 실패했습니다.");
			response.sendRedirect("adminAddUser.jsp");
		}
	}
}
