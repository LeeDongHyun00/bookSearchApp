package com.book.controller;

import java.io.IOException;
import com.book.dao.BookDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/adminDeleteBook")
public class AdminDeleteBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String currentUserId = (String) session.getAttribute("username");
        
        // 권한 체크
        if (!"admin".equals(currentUserId)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String isbn = request.getParameter("isbn");
            
            if (isbn == null || isbn.trim().isEmpty()) {
                throw new IllegalArgumentException("ISBN is required");
            }

            BookDAO dao = new BookDAO();
            boolean success = dao.deleteBook(isbn);

            if (success) {
                session.setAttribute("successMessage", "도서가 삭제되었습니다.");
            } else {
                session.setAttribute("successMessage", "도서 삭제에 실패했습니다.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("successMessage", "오류가 발생했습니다: " + e.getMessage());
        }
        
        response.sendRedirect("admin.jsp?tab=books");
    }
}
