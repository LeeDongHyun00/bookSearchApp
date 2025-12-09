package com.book.controller;

import java.io.IOException;
import com.book.dao.BookDAO;
import com.book.dto.BookDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/adminUpdateBook")
public class AdminUpdateBookServlet extends HttpServlet {
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
            String title = request.getParameter("title");
            String publisher = request.getParameter("publisher");
            String synopsis = request.getParameter("synopsis");
            String coverImage = request.getParameter("coverImage");
            boolean isEbook = "on".equals(request.getParameter("isEbook"));

            BookDTO book = new BookDTO();
            book.setIsbn(isbn);
            book.setTitle(title);
            book.setPublisher(publisher);
            book.setSynopsis(synopsis);
            book.setCoverImage(coverImage);
            book.setEbook(isEbook);

            BookDAO dao = new BookDAO();
            boolean success = dao.updateBook(book);

            if (success) {
                session.setAttribute("successMessage", "도서 정보가 수정되었습니다.");
            } else {
                session.setAttribute("successMessage", "도서 수정에 실패했습니다.");
            }
            
            response.sendRedirect("admin.jsp?tab=books");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("successMessage", "오류가 발생했습니다: " + e.getMessage());
            response.sendRedirect("admin.jsp?tab=books");
        }
    }
}
