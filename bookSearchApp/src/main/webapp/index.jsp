<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.book.dao.BookDAO" %>
<%@ page import="com.book.dao.CategoryDAO" %>
<%@ page import="com.book.dto.BookDTO" %>
<%@ page import="com.book.dto.AuthorDTO" %>
<%@ page import="com.book.dto.CategoryDTO" %>
<%@ page import="java.util.List" %>
<jsp:include page="header.jsp" />

<%
    // 카테고리 목록 가져오기
    CategoryDAO categoryDAO = new CategoryDAO();
    List<CategoryDTO> categories = categoryDAO.getAllCategories();
    request.setAttribute("categories", categories);
    
    // 파라미터 처리
    String query = request.getParameter("q");
    String[] categoryIds = request.getParameterValues("category");
    String sort = request.getParameter("sort");
    
    // 책 목록 가져오기
    BookDAO bookDAO = new BookDAO();
    List<BookDTO> books = bookDAO.getBooks(query, categoryIds, sort);
    request.setAttribute("books", books);
    
    // 랭킹 데이터 가져오기
    List<BookDTO> topBooks = bookDAO.getTopBooks(10);
    request.setAttribute("topBooks", topBooks);
    
    List<AuthorDTO> topAuthors = bookDAO.getTopAuthors(10);
    request.setAttribute("topAuthors", topAuthors);
    
    // 현재 선택된 카테고리
    java.util.Set<Integer> selectedCategories = new java.util.HashSet<>();
    if(categoryIds != null) {
        for(String id : categoryIds) {
            try {
                selectedCategories.add(Integer.parseInt(id));
            } catch(NumberFormatException e) {}
        }
    }
    request.setAttribute("selectedCategories", selectedCategories);
%>

<style>
    /* Custom Scrollbar for Ticker */
    .ticker-container::-webkit-scrollbar {
        width: 4px;
    }
    .ticker-container::-webkit-scrollbar-track {
        background: transparent;
    }
    .ticker-container::-webkit-scrollbar-thumb {
        background: #e5e7eb; 
        border-radius: 4px;
    }
    .ticker-container:hover::-webkit-scrollbar-thumb {
        background: #d1d5db; 
    }

    /* Vertical Ticker Animation */
    @keyframes ticker-scroll {
        0% { transform: translateY(0); }
        100% { transform: translateY(-50%); }
    }
    
    .ticker-wrapper {
        overflow: hidden;
        height: 400px; /* Adjust height based on item count */
        position: relative;
    }
    
    .ticker-content {
        animation: ticker-scroll 30s linear infinite;
    }
    
    .ticker-wrapper:hover .ticker-content {
        animation-play-state: paused;
    }
</style>

<div class="bg-gray-50 min-h-screen">
    <!-- Main Content -->
    <div class="container mx-auto px-4 py-8 max-w-[1400px]">
        <div class="flex flex-col lg:flex-row gap-8">
            
            <!-- Sidebar (Left): Rankings & Categories -->
            <aside class="w-full lg:w-80 flex-shrink-0 space-y-8">
                
                <!-- Filters Section -->
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="font-bold text-gray-900 flex items-center text-lg">
                            <svg class="w-5 h-5 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"></path></svg>
                            검색 필터
                        </h3>
                    </div>
                    
                    <form action="index.jsp" method="get" id="filterForm">
                        <c:if test="${not empty param.q}">
                            <input type="hidden" name="q" value="${param.q}">
                        </c:if>
                        <c:if test="${not empty param.sort}">
                            <input type="hidden" name="sort" value="${param.sort}">
                        </c:if>
                        
                        <div class="flex flex-wrap gap-2 mb-6">
                            <c:forEach var="c" items="${categories}">
                                <label class="cursor-pointer group">
                                    <input type="checkbox" name="category" value="${c.categoryId}" 
                                           class="hidden peer"
                                           ${selectedCategories.contains(c.categoryId) ? 'checked' : ''}
                                           onchange="document.getElementById('filterForm').submit();">
                                    <span class="inline-block px-3 py-1.5 rounded-lg text-sm font-medium border transition-all duration-200 
                                                 peer-checked:bg-primary peer-checked:text-white peer-checked:border-primary peer-checked:shadow-md
                                                 bg-gray-50 text-gray-600 border-transparent hover:bg-gray-100 dark:hover:bg-gray-800">
                                        ${c.categoryName}
                                    </span>
                                </label>
                            </c:forEach>
                        </div>
                        
                        <div class="grid grid-cols-2 gap-3">
                            <a href="index.jsp" class="flex items-center justify-center py-2.5 text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-xl font-medium transition-colors text-sm">
                                <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path></svg>
                                초기화
                            </a>
                             <!-- Audiobook Button -->
                            <button type="button" onclick="openAudiobookMode()" class="flex items-center justify-center py-2.5 text-white bg-gray-900 hover:bg-black rounded-xl font-medium transition-all shadow-lg hover:shadow-xl text-sm group">
                                <svg class="w-4 h-4 mr-1.5 text-purple-400 group-hover:text-purple-300 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11a7 7 0 01-7 7m0 0a7 7 0 01-7-7m7 7v4m0 0H8m4 0h4m-4-8a3 3 0 01-3-3V5a3 3 0 116 0v6a3 3 0 01-3 3z"></path></svg>
                                오디오북
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Ranking Ticker: Top Books -->
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <h3 class="font-bold text-gray-900 flex items-center mb-4 text-lg">
                        <svg class="w-5 h-5 mr-2 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 18.657A8 8 0 016.343 7.343S7 9 9 10c0-2 .5-5 2.986-7C14 5 16.09 5.777 17.656 7.343A7.975 7.975 0 0120 13a7.975 7.975 0 01-2.343 5.657z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.879 16.121A3 3 0 1012.015 11L11 14H9c0 .768.293 1.536.879 2.121z"></path></svg>
                        인기 도서 Top 10
                    </h3>
                    <div class="ticker-wrapper relative">
                        <!-- Gradient Masks for smooth fade -->
                        <div class="absolute top-0 left-0 right-0 h-8 bg-gradient-to-b from-white to-transparent z-10 pointer-events-none"></div>
                        <div class="absolute bottom-0 left-0 right-0 h-8 bg-gradient-to-t from-white to-transparent z-10 pointer-events-none"></div>
                        
                        <div class="ticker-content space-y-4">
                            <%-- Duplicate content for seamless loop --%>
                            <c:forEach begin="0" end="1">
                                <c:forEach var="book" items="${topBooks}" varStatus="status">
                                    <div class="flex items-start p-2 rounded-xl hover:bg-gray-50 transition-colors group relative">
                                        <div class="flex-shrink-0 w-8 text-center font-bold text-gray-300 italic text-xl mr-3 group-hover:text-primary transition-colors">
                                            ${status.count}
                                        </div>
                                        <div class="flex-shrink-0 w-12 h-16 mr-3 relative overflow-hidden rounded shadow-sm">
                                            <img src="${book.coverImage}" class="w-full h-full object-cover">
                                            <div class="absolute inset-0 bg-black/50 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                                                <a href="detail.jsp?id=${book.isbn}" class="text-white">
                                                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                                                </a>
                                            </div>
                                        </div>
                                        <div class="min-w-0 flex-1">
                                            <h4 class="text-sm font-bold text-gray-900 truncate leading-tight mb-1 group-hover:text-primary transition-colors">${book.title}</h4>
                                            <p class="text-xs text-gray-500 truncate">${book.authorNames}</p>
                                            <div class="flex items-center mt-1">
                                                <svg class="w-3 h-3 text-yellow-400 mr-1" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                                <span class="text-xs font-bold text-gray-700">${book.rating}</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                 <!-- Ranking Ticker: Top Authors -->
                 <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100">
                    <h3 class="font-bold text-gray-900 flex items-center mb-4 text-lg">
                        <svg class="w-5 h-5 mr-2 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"></path></svg>
                        인기 작가 Top 10
                    </h3>
                    <div class="space-y-3">
                         <c:forEach var="author" items="${topAuthors}" varStatus="status">
                            <div class="flex items-center justify-between p-2 rounded-lg hover:bg-gray-50 transition-colors cursor-default">
                                <div class="flex items-center">
                                    <div class="w-6 text-center text-sm font-bold text-gray-400 mr-3">${status.count}</div>
                                    <span class="text-sm font-medium text-gray-800">${author.authorName}</span>
                                </div>
                                <!-- Mock Trend Icon -->
                                <c:choose>
                                    <c:when test="${status.count <= 3}">
                                        <span class="text-xs text-red-500 font-bold">HOT</span>
                                    </c:when>
                                    <c:otherwise>
                                        <svg class="w-3 h-3 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14"></path></svg>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                         </c:forEach>
                    </div>
                </div>

            </aside>

            <!-- Main Book Grid -->
            <main class="flex-1 min-w-0">
                
                <!-- Header & Sort -->
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-4">
                    <div>
                        <h2 class="text-2xl font-bold text-gray-900 tracking-tight">
                            <c:choose>
                                <c:when test="${not empty param.q}">
                                    '<span class="text-primary">${param.q}</span>' 검색 결과
                                </c:when>
                                <c:when test="${not empty selectedCategories}">
                                    선택하신 카테고리 도서
                                </c:when>
                                <c:otherwise>전체 도서 목록</c:otherwise>
                            </c:choose>
                        </h2>
                        <p class="text-sm text-gray-500 mt-1">총 ${books.size()}권의 도서를 발견했습니다</p>
                    </div>
                    
                    <div class="flex bg-white p-1 rounded-xl shadow-sm border border-gray-100">
                        <c:set var="currentSort" value="${empty param.sort ? 'newest' : param.sort}" />
                        <%-- URL 생성 헬퍼 --%>
                        <c:set var="baseUrl" value="index.jsp?" />
                        <c:if test="${not empty param.q}"> <c:set var="baseUrl" value="${baseUrl}q=${param.q}&" /> </c:if>
                        <c:forEach var="cat" items="${paramValues.category}"> <c:set var="baseUrl" value="${baseUrl}category=${cat}&" /> </c:forEach>
                        <a href="${baseUrl}sort=newest" class="px-4 py-2 rounded-lg text-sm font-medium transition-all ${currentSort == 'newest' ? 'bg-gray-900 text-white shadow-md' : 'text-gray-500 hover:text-gray-900 hover:bg-gray-50'}">최신순</a>
                        <a href="${baseUrl}sort=popular" class="px-4 py-2 rounded-lg text-sm font-medium transition-all ${currentSort == 'popular' ? 'bg-gray-900 text-white shadow-md' : 'text-gray-500 hover:text-gray-900 hover:bg-gray-50'}">인기순</a>
                        <a href="${baseUrl}sort=rating" class="px-4 py-2 rounded-lg text-sm font-medium transition-all ${currentSort == 'rating' ? 'bg-gray-900 text-white shadow-md' : 'text-gray-500 hover:text-gray-900 hover:bg-gray-50'}">평점순</a>
                    </div>
                </div>

                <!-- Modern Card Grid -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                    <c:forEach var="b" items="${books}">
                        <div class="group bg-white rounded-2xl overflow-hidden hover:shadow-[0_8px_30px_rgb(0,0,0,0.06)] transition-all duration-300 border border-gray-100 hover:border-gray-200 flex flex-col h-full transform hover:-translate-y-1">
                            <!-- Image Area -->
                            <div class="relative aspect-[2/3] overflow-hidden bg-gray-100">
                                <img src="${b.coverImage}" alt="${b.title}" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105">
                                
                                <!-- Hover Overlay -->
                                <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex flex-col items-center justify-center p-4 backdrop-blur-[2px]">
                                    <a href="detail.jsp?id=${b.isbn}" class="transform translate-y-4 group-hover:translate-y-0 transition-transform duration-300 bg-white text-gray-900 px-6 py-3 rounded-xl font-bold hover:bg-primary hover:text-white shadow-lg text-sm mb-3 w-full text-center">
                                        상세보기
                                    </a>
                                    <div class="transform translate-y-4 group-hover:translate-y-0 transition-transform duration-300 delay-75 flex gap-2 w-full">
                                         <!-- Optional: Quick Add to Cart button or similar placeholder -->
                                    </div>
                                </div>
                                
                                <!-- E-Book Badge -->
                                <c:if test="${b.isEbook()}">
                                    <div class="absolute top-3 left-3 bg-white/90 backdrop-blur text-gray-900 text-[10px] font-bold px-2 py-1 rounded-md shadow-sm border border-gray-100">
                                        E-BOOK
                                    </div>
                                </c:if>
                            </div>

                            <!-- Content Area -->
                            <div class="p-5 flex flex-col flex-1">
                                <div class="flex items-center justify-between mb-3">
                                    <span class="text-[10px] uppercase font-bold tracking-wider text-primary bg-primary/5 px-2 py-1 rounded-md max-w-[60%] truncate">
                                        ${b.categoryNames}
                                    </span>
                                    <div class="flex items-center bg-yellow-50 px-2 py-1 rounded-md">
                                        <svg class="w-3.5 h-3.5 text-yellow-400 mr-1" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                        <span class="text-xs font-bold text-gray-700">${b.rating}</span>
                                    </div>
                                </div>
                                
                                <h3 class="font-bold text-gray-900 text-lg mb-1 leading-snug line-clamp-2 group-hover:text-primary transition-colors">
                                    <a href="detail.jsp?id=${b.isbn}">
                                        ${b.title}
                                    </a>
                                </h3>
                                <p class="text-sm text-gray-500 mb-4 line-clamp-1">${b.authorNames}</p>
                                
                                <div class="mt-auto pt-4 border-t border-gray-50 flex justify-between items-center text-xs">
                                     <span class="text-gray-400 font-medium">${b.publisher}</span>
                                     <span class="text-gray-300">리뷰 ${b.reviewCount}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Search Results Empty State -->
                     <c:if test="${empty books}">
                        <div class="col-span-full py-20 text-center bg-white rounded-3xl border border-gray-100 shadow-sm">
                            <div class="inline-flex items-center justify-center w-20 h-20 bg-gray-50 rounded-full mb-6 text-gray-300">
                                <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            </div>
                            <h3 class="text-xl font-bold text-gray-900 mb-2">검색 결과가 없습니다</h3>
                            <p class="text-gray-500 mb-8 max-w-md mx-auto">요청하신 조건에 맞는 도서를 찾을 수 없습니다. <br>다른 키워드나 카테고리로 다시 시도해보세요.</p>
                            <a href="index.jsp" class="inline-flex items-center px-6 py-3 bg-gray-900 text-white rounded-xl font-bold hover:bg-black transition-colors shadow-lg shadow-gray-200">
                                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path></svg>
                                필터 초기화
                            </a>
                        </div>
                    </c:if>
                </div>

            </main>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
<jsp:include page="audiobook.jsp" />