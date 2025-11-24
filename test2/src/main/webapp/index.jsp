<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="data.jsp" %>
<jsp:include page="header.jsp" />

<%
    // Get filter parameters
    String query = request.getParameter("q");
    String category = request.getParameter("category");
    String minRating = request.getParameter("rating");
    String sortBy = request.getParameter("sort");
    
    // Get all books
    List<Book> books = getMockBooks();
    List<Book> filteredBooks = new ArrayList<>();
    
    // Apply filters
    for (Book b : books) {
        boolean matches = true;
        
        // Search query filter
        if (query != null && !query.trim().isEmpty()) {
            if (!b.title.contains(query) && !b.author.contains(query)) {
                matches = false;
            }
        }
        
        // Category filter
        if (category != null && !category.isEmpty() && !"all".equals(category)) {
            if (!b.category.equals(category)) {
                matches = false;
            }
        }
        
        // Rating filter
        if (minRating != null && !minRating.isEmpty()) {
            double minRatingValue = Double.parseDouble(minRating);
            if (b.rating < minRatingValue) {
                matches = false;
            }
        }
        
        if (matches) {
            filteredBooks.add(b);
        }
    }
    
    // Apply sorting
    if ("latest".equals(sortBy)) {
        // Sort by publish date (newest first)
        filteredBooks.sort((a, b) -> b.publishDate.compareTo(a.publishDate));
    } else if ("reviews".equals(sortBy)) {
        // Sort by review count (most reviews first)
        filteredBooks.sort((a, b) -> Integer.compare(b.reviewCount, a.reviewCount));
    } else if ("rating".equals(sortBy)) {
        // Sort by rating (highest first)
        filteredBooks.sort((a, b) -> Double.compare(b.rating, a.rating));
    }
%>

<style>
    /* Prevent layout shift from scrollbar */
    html {
        overflow-y: scroll;
        scrollbar-gutter: stable;
    }
</style>

<div class="container mx-auto px-4 py-8 max-w-7xl">
    <div class="flex flex-col lg:flex-row gap-6">
        <!-- Left Sidebar - Filters -->
        <aside class="lg:w-64 flex-shrink-0">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 sticky top-24">
                <h2 class="text-lg font-bold text-gray-900 mb-4 flex items-center gap-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>
                    필터
                </h2>
                
                <form method="get" action="index.jsp" id="filterForm">
                    <!-- Preserve search query -->
                    <% if (query != null && !query.isEmpty()) { %>
                        <input type="hidden" name="q" value="<%= query %>">
                    <% } %>
                    
                    <!-- Category Filter -->
                    <div class="mb-6">
                        <h3 class="text-sm font-semibold text-gray-700 mb-3">카테고리</h3>
                        <div class="space-y-2">
                            <label class="flex items-center cursor-pointer group">
                                <input type="radio" name="category" value="all" <%= category == null || "all".equals(category) ? "checked" : "" %> onchange="this.form.submit()" class="w-4 h-4 text-primary focus:ring-primary">
                                <span class="ml-2 text-sm text-gray-700 group-hover:text-primary">전체</span>
                            </label>
                            <label class="flex items-center cursor-pointer group">
                                <input type="radio" name="category" value="소설" <%= "소설".equals(category) ? "checked" : "" %> onchange="this.form.submit()" class="w-4 h-4 text-primary focus:ring-primary">
                                <span class="ml-2 text-sm text-gray-700 group-hover:text-primary">소설</span>
                            </label>
                            <label class="flex items-center cursor-pointer group">
                                <input type="radio" name="category" value="인문" <%= "인문".equals(category) ? "checked" : "" %> onchange="this.form.submit()" class="w-4 h-4 text-primary focus:ring-primary">
                                <span class="ml-2 text-sm text-gray-700 group-hover:text-primary">인문</span>
                            </label>
                            <label class="flex items-center cursor-pointer group">
                                <input type="radio" name="category" value="자기계발" <%= "자기계발".equals(category) ? "checked" : "" %> onchange="this.form.submit()" class="w-4 h-4 text-primary focus:ring-primary">
                                <span class="ml-2 text-sm text-gray-700 group-hover:text-primary">자기계발</span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Rating Filter -->
                    <div class="mb-6 pb-6 border-b border-gray-200">
                        <h3 class="text-sm font-semibold text-gray-700 mb-3">평점</h3>
                        <div class="space-y-2">
                            <label class="flex items-center cursor-pointer group">
                                <input type="radio" name="rating" value="" <%= minRating == null || minRating.isEmpty() ? "checked" : "" %> onchange="this.form.submit()" class="w-4 h-4 text-primary focus:ring-primary">
                                <span class="ml-2 text-sm text-gray-700 group-hover:text-primary">전체</span>
                            </label>
                            <label class="flex items-center cursor-pointer group">
                                <input type="radio" name="rating" value="4.5" <%= "4.5".equals(minRating) ? "checked" : "" %> onchange="this.form.submit()" class="w-4 h-4 text-primary focus:ring-primary">
                                <span class="ml-2 text-sm text-gray-700 group-hover:text-primary flex items-center">
                                    <span class="text-yellow-400 mr-1">★★★★★</span> 4.5 이상
                                </span>
                            </label>
                            <label class="flex items-center cursor-pointer group">
                                <input type="radio" name="rating" value="4.0" <%= "4.0".equals(minRating) ? "checked" : "" %> onchange="this.form.submit()" class="w-4 h-4 text-primary focus:ring-primary">
                                <span class="ml-2 text-sm text-gray-700 group-hover:text-primary flex items-center">
                                    <span class="text-yellow-400 mr-1">★★★★</span> 4.0 이상
                                </span>
                            </label>
                            <label class="flex items-center cursor-pointer group">
                                <input type="radio" name="rating" value="3.0" <%= "3.0".equals(minRating) ? "checked" : "" %> onchange="this.form.submit()" class="w-4 h-4 text-primary focus:ring-primary">
                                <span class="ml-2 text-sm text-gray-700 group-hover:text-primary flex items-center">
                                    <span class="text-yellow-400 mr-1">★★★</span> 3.0 이상
                                </span>
                            </label>
                        </div>
                    </div>
                    
                    <!-- Reset Button -->
                    <a href="index.jsp" class="block w-full text-center py-2 px-4 bg-primary text-white rounded-lg text-sm font-medium hover:bg-opacity-90 transition-colors">
                        필터 초기화
                    </a>
                </form>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 min-w-0">
            <!-- Header with Sort Options -->
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-4">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900">
                        <% if (query != null && !query.isEmpty()) { %>
                            '<%= query %>' 검색 결과
                        <% } else if (category != null && !"all".equals(category)) { %>
                            <%= category %> 도서
                        <% } else { %>
                            전체 도서
                        <% } %>
                    </h1>
                    <p class="text-sm text-gray-500 mt-1"><%= filteredBooks.size() %>권의 도서</p>
                </div>
                
                <!-- Modern Sort Buttons -->
                <div class="flex items-center gap-2 bg-gray-100 p-1 rounded-xl">
                    <% 
                    String currentSort = (sortBy == null || sortBy.isEmpty()) ? "" : sortBy;
                    String baseUrl = "index.jsp?";
                    if (query != null && !query.isEmpty()) baseUrl += "q=" + query + "&";
                    if (category != null && !category.isEmpty()) baseUrl += "category=" + category + "&";
                    if (minRating != null && !minRating.isEmpty()) baseUrl += "rating=" + minRating + "&";
                    %>
                    
                    <a href="<%= baseUrl %>sort=" class="px-4 py-2 rounded-lg text-sm font-medium transition-all <%= currentSort.isEmpty() ? "bg-white text-primary shadow-sm" : "text-gray-600 hover:text-gray-900" %>">
                        기본순
                    </a>
                    <a href="<%= baseUrl %>sort=latest" class="px-4 py-2 rounded-lg text-sm font-medium transition-all <%= "latest".equals(currentSort) ? "bg-white text-primary shadow-sm" : "text-gray-600 hover:text-gray-900" %>">
                        <span class="flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v20M5 12l7-7 7 7"/></svg>
                            최신순
                        </span>
                    </a>
                    <a href="<%= baseUrl %>sort=rating" class="px-4 py-2 rounded-lg text-sm font-medium transition-all <%= "rating".equals(currentSort) ? "bg-white text-primary shadow-sm" : "text-gray-600 hover:text-gray-900" %>">
                        <span class="flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                            평점순
                        </span>
                    </a>
                    <a href="<%= baseUrl %>sort=reviews" class="px-4 py-2 rounded-lg text-sm font-medium transition-all <%= "reviews".equals(currentSort) ? "bg-white text-primary shadow-sm" : "text-gray-600 hover:text-gray-900" %>">
                        <span class="flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                            리뷰순
                        </span>
                    </a>
                </div>
            </div>

            <!-- Books Grid -->
            <% if (filteredBooks.isEmpty()) { %>
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-12 text-center">
                    <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">검색 결과가 없습니다</h3>
                    <p class="text-gray-500 mb-4">다른 검색어나 필터를 시도해보세요</p>
                    <a href="index.jsp" class="inline-block bg-primary text-white px-6 py-2 rounded-lg hover:bg-opacity-90 transition-all">
                        전체 도서 보기
                    </a>
                </div>
            <% } else { %>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                    <% for(Book book : filteredBooks) { %>
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-xl transition-all duration-300 group">
                            <div class="relative aspect-[2/3] bg-gray-100 overflow-hidden">
                                <img src="<%= book.coverImage %>" alt="<%= book.title %>" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500">
                                <div class="absolute top-3 right-3">
                                    <div class="bg-white/95 backdrop-blur px-2 py-1 rounded-lg flex items-center gap-1 shadow-lg">
                                        <svg class="w-4 h-4 text-yellow-400" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                        <span class="text-sm font-bold text-gray-900"><%= book.rating %></span>
                                    </div>
                                </div>
                                <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                                    <div class="absolute bottom-4 left-4 right-4">
                                        <a href="detail.jsp?id=<%= book.id %>" class="block w-full bg-white text-primary text-center py-2 rounded-lg font-semibold hover:bg-primary hover:text-white transition-all">
                                            상세보기
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="p-4">
                                <div class="mb-2">
                                    <span class="inline-block px-2 py-1 bg-primary/10 text-primary text-xs font-semibold rounded-full"><%= book.category %></span>
                                </div>
                                <h3 class="font-bold text-gray-900 mb-1 line-clamp-2 group-hover:text-primary transition-colors"><%= book.title %></h3>
                                <p class="text-sm text-gray-500 mb-3"><%= book.author %></p>
                                <div class="flex items-center justify-between text-xs text-gray-500">
                                    <span class="flex items-center gap-1">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"/></svg>
                                        <%= book.reviewCount %>
                                    </span>
                                    <span><%= book.publishDate %></span>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </main>
    </div>
</div>

<jsp:include page="footer.jsp" />