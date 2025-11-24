package com.book.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.book.dao.UserDAO;
import com.book.dto.UserDTO;

@WebServlet("/signup")
public class SignUpServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDAO userDAO = new UserDAO();

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String userId = request.getParameter("userId");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String nickname = request.getParameter("nickname");
		String fromAdmin = request.getParameter("fromAdmin");
		
		UserDTO user = new UserDTO(userId, password, email, nickname);
		boolean isSuccess = userDAO.insertUser(user);
		
		response.setContentType("text/html; charset=UTF-8");
		if(isSuccess) {
			// Redirect to admin page if called from admin panel
			if("true".equals(fromAdmin)) {
				// Use session to pass message and redirect properly
				request.getSession().setAttribute("successMessage", "회원이 추가되었습니다.");
				response.sendRedirect("admin.jsp");
			} else {
				response.getWriter().write(
						"<script>alert('가입성공'); location.href='login.jsp';</script>");
			}
		}else {
			response.getWriter().write(
					"<script>alert('가입실패'); history.back();</script>");
		}
	}
}
