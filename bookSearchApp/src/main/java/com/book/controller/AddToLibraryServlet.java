package com.book.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.book.dao.LibraryDAO;
import com.book.dto.UserDTO;

@WebServlet("/addToLibrary")
public class AddToLibraryServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        
        // AuthFilter가 처리하지만 안전을 위해 한번 더 체크
        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String isbn = request.getParameter("isbn");
        String userId = user.getUserId(); // UserDTO 필드명 확인 필요 (getUserId() 가정)
        
        LibraryDAO dao = new LibraryDAO();
        
        // 이미 있는지 확인
        if(dao.isInLibrary(userId, isbn)) {
            // 이미 있으면 경고창 띄우고 뒤로가기 혹은 detail 페이지로
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('이미 서재에 담긴 책입니다.'); history.back();</script>");
            return;
        }
        
        boolean result = dao.addToLibrary(userId, isbn);
        
        if(result) {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('서재에 추가되었습니다.'); location.href='detail.jsp?id=" + isbn + "';</script>");
        } else {
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<script>alert('서재 추가 실패.'); history.back();</script>");
        }
    }
}
