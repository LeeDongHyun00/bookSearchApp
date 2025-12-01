package com.book.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.book.dao.UserDAO;

@WebServlet("/emailCheck")
public class EmailCheckServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDAO userDAO = new UserDAO();

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("email");
		
		response.setContentType("text/plain; charset=UTF-8");
		
		if(email == null || email.trim().isEmpty()) {
			response.getWriter().write("error");
			return;
		}
		
		boolean isExists = userDAO.checkEmail(email);

		if(isExists) {
			response.getWriter().write("used");
		} else {
			response.getWriter().write("available");
		}
	}
}
