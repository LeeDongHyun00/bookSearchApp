<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.book.dao.BookDAO" %>
<%@ page import="com.book.dao.CategoryDAO" %>
<%@ page import="com.book.dto.BookDTO" %>
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

<div class="bg-gray-50 min-h-screen">
    <!-- Main Content -->
    <div class="container mx-auto px-4 py-12 max-w-7xl">
        <div class="flex flex-col md:flex-row gap-8">
            <!-- Sidebar Filters -->
            <div class="w-full md:w-64 flex-shrink-0">
                <div class="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 sticky top-24">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="font-bold text-gray-900 flex items-center">
                            <svg class="w-5 h-5 mr-2 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7"></path></svg>
                            카테고리
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
                                <label class="cursor-pointer">
                                    <input type="checkbox" name="category" value="${c.categoryId}" 
                                           class="hidden peer"
                                           ${selectedCategories.contains(c.categoryId) ? 'checked' : ''}
                                           onchange="document.getElementById('filterForm').submit();">
                                    <span class="inline-block px-4 py-2 rounded-full text-sm font-medium border transition-all duration-200 
                                                 peer-checked:bg-primary peer-checked:text-white peer-checked:border-primary peer-checked:shadow-md
                                                 bg-white text-gray-600 border-gray-200 hover:border-primary hover:text-primary">
                                        ${c.categoryName}
                                    </span>
                                </label>
                            </c:forEach>
                        </div>
                        
                        <a href="index.jsp" class="block w-full py-3 text-center text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-xl font-bold transition-colors text-sm">
                            필터 초기화
                        </a>
                        <!-- Audiobook Button -->
                        <button type="button" onclick="openAudiobookMode()" class="mt-4 block w-full py-3 text-center text-white bg-black rounded-xl font-bold transition-all duration-300 shadow-lg hover:shadow-[0_0_100px_rgba(0,0,0,0.5)] text-sm flex items-center justify-center gap-2 group">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11a7 7 0 01-7 7m0 0a7 7 0 01-7-7m7 7v4m0 0H8m4 0h4m-4-8a3 3 0 01-3-3V5a3 3 0 116 0v6a3 3 0 01-3 3z"></path></svg>
                            오디오북으로 변환하기
                        </button>
                    </form>
                </div>
            </div>

            <!-- Book Grid -->
            <div class="flex-1">
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-4">
                    <h2 class="text-xl font-bold text-gray-900">
                        <c:choose>
                            <c:when test="${not empty param.q}">
                                '<span class="text-primary">${param.q}</span>' 검색 결과
                            </c:when>
                            <c:when test="${not empty selectedCategories}">
                                선택된 카테고리
                            </c:when>
                            <c:otherwise>전체 도서</c:otherwise>
                        </c:choose>
                        <span class="text-gray-400 text-sm font-normal ml-2">총 ${books.size()}권</span>
                    </h2>
                    
                    <!-- Horizontal Sort Nav -->
                    <div class="flex bg-gray-100 p-1 rounded-lg">
                        <c:set var="currentSort" value="${empty param.sort ? 'popular' : param.sort}" />
                        
                        <%-- URL 생성 헬퍼 로직 --%>
                        <c:set var="baseUrl" value="index.jsp?" />
                        <c:if test="${not empty param.q}">
                            <c:set var="baseUrl" value="${baseUrl}q=${param.q}&" />
                        </c:if>
                        <c:forEach var="cat" items="${paramValues.category}">
                            <c:set var="baseUrl" value="${baseUrl}category=${cat}&" />
                        </c:forEach>
                        
                        <a href="${baseUrl}sort=popular" 
                           class="px-4 py-1.5 rounded-md text-sm font-medium transition-all ${currentSort == 'popular' ? 'bg-white text-primary shadow-sm' : 'text-gray-500 hover:text-gray-900'}">
                            인기순
                        </a>
                        <a href="${baseUrl}sort=rating" 
                           class="px-4 py-1.5 rounded-md text-sm font-medium transition-all ${currentSort == 'rating' ? 'bg-white text-primary shadow-sm' : 'text-gray-500 hover:text-gray-900'}">
                            평점순
                        </a>
                    </div>
                </div>

                <!-- 4 Columns Grid -->
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <c:forEach var="b" items="${books}">
                        <div class="group bg-white rounded-2xl border border-gray-100 overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1 flex flex-col h-full">
                            <div class="relative aspect-[3/4] overflow-hidden bg-gray-100">
                                <img src="${b.coverImage}" alt="${b.title}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                                <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-end p-4">
                                    <a href="detail.jsp?id=${b.isbn}" class="w-full bg-white text-gray-900 py-2.5 rounded-lg font-bold text-center hover:bg-primary hover:text-white transition-colors shadow-lg text-sm">
                                        상세보기
                                    </a>
                                </div>
                            </div>
                            <div class="p-4 flex flex-col flex-1">
                                <div class="flex items-center justify-between mb-2">
                                    <span class="text-[10px] font-bold text-primary bg-blue-50 px-2 py-0.5 rounded-full truncate max-w-[60%]">${b.categoryNames}</span>
                                    <div class="flex items-center text-yellow-400 text-xs font-bold">
                                        <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                        ${b.rating}
                                    </div>
                                </div>
                                <h3 class="font-bold text-gray-900 text-base mb-1 line-clamp-2 leading-tight group-hover:text-primary transition-colors">${b.title}</h3>
                                <p class="text-gray-500 text-xs mb-3">${b.authorNames}</p>
                                <div class="mt-auto pt-3 border-t border-gray-50 flex justify-between items-center text-xs text-gray-400">
                                    <span>${b.publisher}</span>
                                    <!-- Review count hidden as requested -->
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <c:if test="${empty books}">
                    <div class="text-center py-20">
                        <div class="text-gray-300 mb-4">
                            <svg class="w-16 h-16 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                        </div>
                        <h3 class="text-lg font-medium text-gray-900">검색 결과가 없습니다</h3>
                        <p class="text-gray-500 mt-2">다른 검색어나 카테고리를 선택해보세요.</p>
                        <a href="index.jsp" class="inline-block mt-6 px-6 py-2 bg-primary text-white rounded-lg hover:bg-opacity-90 transition-colors">
                            전체 도서 보기
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />

<!-- Audiobook Overlay -->
<jsp:include page="audiobook.jsp" />