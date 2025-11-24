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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDAO userDAO = new UserDAO();

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userId = request.getParameter("username");
		String password = request.getParameter("password");
		
		UserDTO user = userDAO.login(userId, password);
		
		if(user != null) {
			HttpSession session = request.getSession();
			session.setAttribute("username", user.getUserId());
			session.setAttribute("nickname", user.getNickname());
			session.setAttribute("email", user.getEmail());
			
			// Admin redirect
			if("admin".equals(user.getUserId())) {
				response.sendRedirect("admin.jsp");
			} else {
				response.sendRedirect("index.jsp");
			}
		} else {
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().write("<script>alert('아이디 또는 비밀번호가 일치하지 않습니다.'); history.back();</script>");
		}
	}
}
