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

@WebServlet("/userUpdateInfo")
public class UserUpdateInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDAO userDAO = new UserDAO();

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();
		String userId = (String)session.getAttribute("username");
		
		if(userId == null) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		String nickname = request.getParameter("nickname");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String passwordConfirm = request.getParameter("passwordConfirm");
		
		// Password validation
		if(password != null && !password.isEmpty()) {
			if(!password.equals(passwordConfirm)) {
				response.setContentType("text/html; charset=UTF-8");
				response.getWriter().write("<script>alert('비밀번호가 일치하지 않습니다.'); history.back();</script>");
				return;
			}
		} else {
			// Keep old password if not provided
			UserDTO currentUser = userDAO.getUser(userId);
			password = currentUser.getPassword();
		}
		
		UserDTO user = new UserDTO(userId, password, email, nickname);
		boolean isSuccess = userDAO.updateUser(user);
		
		if(isSuccess) {
			session.setAttribute("nickname", nickname);
			session.setAttribute("email", email);
			
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().write("<script>alert('회원정보가 수정되었습니다.'); location.href='mypage.jsp?tab=info';</script>");
		} else {
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().write("<script>alert('회원정보 수정에 실패했습니다.'); history.back();</script>");
		}
	}
}
