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
import com.book.util.WordFilterUtil;

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
        
        String foundWord = WordFilterUtil.filter(content); 
        
        if (foundWord != null) {
            String alertMessage = "리뷰 내용에 부적절한 단어 ('" + foundWord + "')가 포함되어 있습니다. 내용을 수정해주세요.";
            session.setAttribute("alertMessage", alertMessage);

            response.sendRedirect("detail.jsp?id=" + isbn);
            return;
        }
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
