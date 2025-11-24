<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="data.jsp" %>
<jsp:include page="header.jsp" />

<%
    String idStr = request.getParameter("id");
    Book book = null;
    if(idStr != null) {
        for(Book b : getMockBooks()) {
            if(b.id == Integer.parseInt(idStr)) { book = b; break; }
        }
    }
    if(book == null) { response.sendRedirect("index.jsp"); return; }
%>

<div class="bg-gray-50 min-h-screen py-8">
    <div class="container mx-auto px-4 max-w-5xl">
        <a href="index.jsp" class="inline-flex items-center text-sm text-gray-500 hover:text-primary mb-6 transition-colors">
            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
            목록으로 돌아가기
        </a>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-8 animate-fade-in">
            <div class="grid md:grid-cols-[350px_1fr]">
                <div class="bg-gray-100 p-8 flex items-center justify-center">
                    <img src="<%= book.coverImage %>" class="w-48 shadow-2xl rounded-lg transform hover:scale-105 transition-transform duration-500" alt="<%= book.title %>">
                </div>
                <div class="p-8 md:p-10 flex flex-col">
                    <div class="mb-auto">
                        <div class="flex items-center gap-2 mb-4">
                            <span class="px-3 py-1 bg-blue-50 text-primary text-xs font-bold rounded-full"><%= book.category %></span>
                            <div class="flex items-center text-yellow-400 text-sm font-bold">
                                <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                <%= book.rating %> (<%= book.reviewCount %>개의 리뷰)
                            </div>
                        </div>
                        <h1 class="text-4xl font-bold text-gray-900 mb-2"><%= book.title %></h1>
                        <p class="text-xl text-gray-600 mb-6"><%= book.author %></p>
                        
                        <div class="prose text-gray-600 mb-8">
                            <h3 class="text-lg font-bold text-gray-900 mb-2">책 소개</h3>
                            <p class="leading-relaxed"><%= book.synopsis %></p>
                        </div>
                    </div>

                    <div class="flex gap-4 mt-6 pt-6 border-t border-gray-100">
                        <button class="flex-1 bg-primary text-white py-3.5 rounded-xl font-bold hover:bg-blue-700 transition-all shadow-lg shadow-blue-200">
                            내 서재에 담기
                        </button>
                        <button class="px-6 border border-gray-200 rounded-xl hover:bg-gray-50 transition-colors">
                            <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/></path></svg>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
            <h3 class="text-xl font-bold text-gray-900 mb-6">리뷰 <span class="text-primary"><%= book.reviews.size() %></span></h3>
            <div class="space-y-6">
                <% for(Review r : book.reviews) { %>
                <div class="flex gap-4 pb-6 border-b border-gray-50 last:border-0">
                    <div class="w-10 h-10 bg-gradient-to-br from-blue-100 to-purple-100 rounded-full flex items-center justify-center text-primary font-bold flex-shrink-0">
                        <%= r.userName.substring(0,1) %>
                    </div>
                    <div class="flex-1">
                        <div class="flex justify-between items-center mb-2">
                            <h4 class="font-bold text-gray-900"><%= r.userName %></h4>
                            <span class="text-xs text-gray-400"><%= r.date %></span>
                        </div>
                        <div class="flex text-yellow-400 text-sm mb-2">
                            <% for(int i=0; i<5; i++) { %><%= i < r.rating ? "★" : "☆" %><% } %>
                        </div>
                        <p class="text-gray-600 text-sm leading-relaxed"><%= r.content %></p>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
<jsp:include page="footer.jsp" />