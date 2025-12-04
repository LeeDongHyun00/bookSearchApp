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

@WebServlet("/removeFromLibrary")
public class RemoveFromLibraryServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        
        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String libraryIdStr = request.getParameter("libraryId");
        if(libraryIdStr != null) {
            int libraryId = Integer.parseInt(libraryIdStr);
            LibraryDAO dao = new LibraryDAO();
            dao.removeFromLibrary(libraryId, user.getUserId());
        }
        
        response.sendRedirect("mypage.jsp?tab=library");
    }
}
