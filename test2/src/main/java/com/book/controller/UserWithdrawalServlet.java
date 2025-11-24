package com.book.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.book.dao.UserDAO;

@WebServlet("/userWithdrawal")
public class UserWithdrawalServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDAO userDAO = new UserDAO();

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String userId = (String)session.getAttribute("username");
		
		if(userId == null) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		boolean isSuccess = userDAO.deleteUser(userId);
		
		response.setContentType("text/html; charset=UTF-8");
		if(isSuccess) {
			session.invalidate();
			response.getWriter().write("<script>alert('회원 탈퇴가 완료되었습니다.'); location.href='index.jsp';</script>");
		} else {
			response.getWriter().write("<script>alert('회원 탈퇴에 실패했습니다.'); history.back();</script>");
		}
	}
}
