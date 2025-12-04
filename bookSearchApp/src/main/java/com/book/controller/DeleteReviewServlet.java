package com.book.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.book.dao.ReviewDAO;
import com.book.dto.UserDTO;

@WebServlet("/deleteReview")
public class DeleteReviewServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        
        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String reviewIdStr = request.getParameter("reviewId");
        String isbn = request.getParameter("isbn"); // For redirecting back to detail if needed
        
        if(reviewIdStr != null) {
            int reviewId = Integer.parseInt(reviewIdStr);
            ReviewDAO dao = new ReviewDAO();
            dao.deleteReview(reviewId);
        }
        
        String referer = request.getHeader("Referer");
        if(referer != null && referer.contains("detail.jsp") && isbn != null) {
             response.sendRedirect("detail.jsp?id=" + isbn);
        } else {
             response.sendRedirect("mypage.jsp?tab=reviews");
        }
    }
}
