<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.book.dao.BookDAO" %>
<%@ page import="com.book.dto.BookDTO" %>
<jsp:include page="header.jsp" />

<%
    // Security Check - Admin Only
    String currentUserId = (String) session.getAttribute("username");
    if (!"admin".equals(currentUserId)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get ISBN to edit
    String editIsbn = request.getParameter("isbn");
    if (editIsbn == null || editIsbn.trim().isEmpty()) {
        response.sendRedirect("admin.jsp?tab=books");
        return;
    }
    
    // Fetch book data
    BookDAO bookDAO = new BookDAO();
    BookDTO book = bookDAO.getBook(editIsbn);
    
    if (book == null) {
        response.sendRedirect("admin.jsp?tab=books");
        return;
    }
%>

<div class="container mx-auto px-4 py-12">
  <div class="max-w-2xl mx-auto">
    <a
      href="admin.jsp?tab=books"
      class="inline-flex items-center text-sm text-gray-500 hover:text-primary mb-6 transition-colors">
      <svg
        class="w-4 h-4 mr-1"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24">
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
      </svg>
      관리자 페이지로 돌아가기
    </a>

    <div class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
      <div class="bg-gradient-to-r from-primary to-gray-900 p-8 text-white">
        <div class="flex items-center gap-3 mb-2">
            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/>
                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>
            </svg>
            <h1 class="text-3xl font-bold">도서 정보 수정</h1>
        </div>
        <p class="text-white/80">ISBN: <%= book.getIsbn() %> 도서의 정보를 수정합니다</p>
      </div>

      <form
        class="p-8 space-y-6"
        action="adminUpdateBook"
        method="POST">
        <input type="hidden" name="isbn" value="<%= book.getIsbn() %>" />
        
        <div>
          <label for="isbn" class="block text-sm font-medium text-gray-700 mb-2">
            ISBN
          </label>
          <input
            id="isbn"
            type="text"
            value="<%= book.getIsbn() %>"
            disabled
            class="w-full px-4 py-3 border border-gray-300 rounded-lg bg-gray-50 text-gray-500 cursor-not-allowed"/>
          <p class="mt-1 text-xs text-gray-500">ISBN은 수정할 수 없습니다</p>
        </div>

        <div>
          <label for="title" class="block text-sm font-medium text-gray-700 mb-2">
            도서명
          </label>
          <input
            id="title"
            name="title"
            type="text"
            required
            value="<%= book.getTitle() %>"
            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all" 
            placeholder="도서 제목"/>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label for="publisher" class="block text-sm font-medium text-gray-700 mb-2">
                출판사
              </label>
              <input
                id="publisher"
                name="publisher"
                type="text"
                required
                value="<%= book.getPublisher() %>"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all" 
                placeholder="출판사명"/>
            </div>
            
             <div class="flex items-center pt-8">
                <label class="flex items-center cursor-pointer">
                    <input type="checkbox" name="isEbook" class="w-5 h-5 text-primary border-gray-300 rounded focus:ring-primary" <%= book.isEbook() ? "checked" : "" %>>
                    <span class="ml-2 text-gray-700 font-medium">E-Book 포함</span>
                </label>
            </div>
        </div>

        <div>
          <label for="coverImage" class="block text-sm font-medium text-gray-700 mb-2">
            표지 이미지 URL
          </label>
          <input
            id="coverImage"
            name="coverImage"
            type="text"
            value="<%= book.getCoverImage() %>"
            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all" 
            placeholder="이미지 URL"
            onchange="document.getElementById('imgPreview').src = this.value"/>
           <div class="mt-3">
                <p class="text-xs text-gray-500 mb-1">미리보기:</p>
                <img id="imgPreview" src="<%= book.getCoverImage() %>" alt="Cover Preview" class="h-40 object-cover rounded-lg shadow-sm border border-gray-200">
           </div>
        </div>

        <div>
          <label for="synopsis" class="block text-sm font-medium text-gray-700 mb-2">
            책 소개
          </label>
          <textarea
            id="synopsis"
            name="synopsis"
            rows="6"
            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all" 
            placeholder="책 줄거리 및 소개"><%= book.getSynopsis() %></textarea>
        </div>

        <div class="flex gap-3 pt-4">
          <button
            type="submit"
            class="flex-1 bg-primary text-white py-3 px-6 rounded-lg font-bold hover:bg-opacity-90 transition-all shadow-lg shadow-primary/30">
            변경사항 저장
          </button>
          <a
            href="admin.jsp?tab=books"
            class="px-6 py-3 border-2 border-gray-300 text-gray-700 rounded-lg font-medium hover:bg-gray-50 transition-colors">
            취소
          </a>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
