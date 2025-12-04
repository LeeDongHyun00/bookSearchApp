package com.book.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.book.dao.ReviewDAO;
import com.book.dto.ReviewDTO;
import com.book.dto.UserDTO;

@WebServlet("/updateReview")
public class UpdateReviewServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        
        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String isbn = request.getParameter("isbn");
        String content = request.getParameter("content");
        int rating = Integer.parseInt(request.getParameter("rating"));
        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        
        ReviewDTO review = new ReviewDTO();
        review.setReviewId(reviewId);
        review.setBookId(isbn);
        review.setUserId(user.getUserId());
        review.setContent(content);
        review.setRating(rating);
        
        ReviewDAO dao = new ReviewDAO();
        boolean result = dao.updateReview(review);
        
        if(result) {
            response.sendRedirect("detail.jsp?id=" + isbn);
        } else {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('리뷰 수정 실패.'); history.back();</script>");
        }
    }
}
