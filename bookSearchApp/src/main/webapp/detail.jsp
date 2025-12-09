<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.book.dao.BookDAO" %>
<%@ page import="com.book.dto.BookDTO" %>
<%@ page import="com.book.dao.ReviewDAO" %>
<%@ page import="com.book.dto.ReviewDTO" %>
<%@ page import="com.book.dto.UserDTO" %>
<%@ page import="java.util.List" %>
<jsp:include page="header.jsp" />

<%-- 필터링 추가  --%>
<c:if test="${not empty sessionScope.alertMessage}">
    <script>
        alert("${sessionScope.alertMessage}"); 
    </script>
    <c:remove var="alertMessage" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.successMessage}">
    <script>
        alert("${sessionScope.successMessage}"); 
    </script>
    <c:remove var="successMessage" scope="session"/>
</c:if>

<%
    String idStr = request.getParameter("id");
    BookDTO book = null;
    if(idStr != null) {
        BookDAO dao = new BookDAO();
        book = dao.getBook(idStr);
    }
    
    if(book == null) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }
    request.setAttribute("book", book);
    
    // Check if user has written a review
    ReviewDTO myReview = null;
    UserDTO user = (UserDTO) session.getAttribute("user");
    if(user != null) {
        ReviewDAO reviewDao = new ReviewDAO();
        myReview = reviewDao.getReview(user.getUserId(), book.getIsbn());
    }
    request.setAttribute("myReview", myReview);
%>

<style>
    /* Interactive Star Rating CSS */
    .star-rating {
        display: flex;
        flex-direction: row-reverse;
        justify-content: flex-end;
    }
    .star-rating input {
        display: none;
    }
    .star-rating label {
        cursor: pointer;
        width: 30px;
        height: 30px;
        background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%23d1d5db'%3e%3cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z'/%3e%3c/svg%3e");
        background-repeat: no-repeat;
        background-position: center;
        background-size: contain;
        transition: all 0.2s;
    }
    .star-rating input:checked ~ label,
    .star-rating label:hover,
    .star-rating label:hover ~ label {
        background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' fill='%23fbbf24' viewBox='0 0 24 24' stroke='%23fbbf24'%3e%3cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z'/%3e%3c/svg%3e");
        transform: scale(1.1);
    }
</style>

<div class="bg-gray-50 min-h-screen py-10">
    <!-- Hero Background Blur -->
    <div class="fixed top-0 left-0 w-full h-[50vh] bg-gradient-to-b from-gray-200 to-gray-50 -z-10 opacity-50 pointer-events-none"></div>
    
    <div class="container mx-auto px-4 max-w-6xl">
        <a href="index.jsp" class="inline-flex items-center text-sm font-medium text-gray-500 hover:text-gray-900 mb-8 transition-colors group">
            <svg class="w-4 h-4 mr-1 group-hover:-translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
            돌아가기
        </a>

        <!-- Main Book Card -->
        <div class="bg-white rounded-[2rem] shadow-xl border border-gray-100 overflow-hidden mb-12">
            <div class="flex flex-col md:flex-row">
                <!-- Cover Section -->
                <div class="md:w-[400px] bg-gray-50 p-10 flex items-center justify-center relative overflow-hidden group">
                    <div class="absolute inset-0 bg-primary/5 group-hover:bg-primary/10 transition-colors duration-500"></div>
                    <img src="${book.coverImage}" class="w-64 md:w-72 shadow-2xl rounded-xl z-10 transform group-hover:scale-105 transition-transform duration-500" alt="${book.title}">
                </div>
                
                <!-- Info Section -->
                <div class="flex-1 p-8 md:p-12 flex flex-col justify-center">
                    <div class="mb-6">
                        <div class="flex flex-wrap items-center gap-3 mb-4">
                            <span class="px-3 py-1 bg-primary/10 text-primary text-xs font-bold rounded-lg tracking-wide uppercase">${book.categoryNames}</span>
                            <c:if test="${book.ebook}">
                                <span class="px-3 py-1 bg-gray-900 text-white text-xs font-bold rounded-lg tracking-wide uppercase">E-Book</span>
                            </c:if>
                        </div>
                        
                        <h1 class="text-4xl md:text-5xl font-black text-gray-900 mb-4 leading-tight tracking-tight">${book.title}</h1>
                        <p class="text-xl text-gray-500 font-medium mb-8">${book.authorNames}</p>
                        
                        <div class="flex items-center gap-6 mb-8 py-6 border-y border-gray-100">
                             <div class="flex flex-col">
                                <span class="text-xs text-gray-400 font-bold uppercase tracking-wider mb-1">RATING</span>
                                <div class="flex items-center text-yellow-400 text-xl font-bold">
                                    <svg class="w-6 h-6 mr-1" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                    ${book.rating}
                                </div>
                            </div>
                            <div class="w-px h-10 bg-gray-200"></div>
                            <div class="flex flex-col">
                                <span class="text-xs text-gray-400 font-bold uppercase tracking-wider mb-1">REVIEWS</span>
                                <span class="text-xl font-bold text-gray-900">${book.reviewCount}</span>
                            </div>
                            <div class="w-px h-10 bg-gray-200"></div>
                            <div class="flex flex-col">
                                <span class="text-xs text-gray-400 font-bold uppercase tracking-wider mb-1">PUBLISHER</span>
                                <span class="text-lg font-bold text-gray-900">${book.publisher}</span>
                            </div>
                        </div>

                        <div class="prose prose-lg text-gray-600 mb-8 max-w-none">
                            <p class="leading-relaxed">${book.synopsis}</p>
                        </div>
                    </div>

                    <div class="flex gap-4 mt-auto">
                        <form action="addToLibrary" method="post" class="flex-1">
                            <input type="hidden" name="isbn" value="${book.isbn}">
                            <button type="submit" class="w-full bg-gray-900 text-white py-4 rounded-xl font-bold hover:bg-black transition-all shadow-lg hover:shadow-xl flex items-center justify-center gap-2 group">
                                <svg class="w-5 h-5 text-gray-400 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                                내 서재에 담기
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="grid lg:grid-cols-[1fr_400px] gap-8">
            <!-- Reviews List -->
            <div class="space-y-6">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-2xl font-bold text-gray-900">독자 리뷰</h3>
                    <span class="text-sm font-bold text-gray-500">총 ${book.reviews.size()}개</span>
                </div>
                
                <c:if test="${empty book.reviews}">
                    <div class="bg-white rounded-2xl p-12 text-center border border-gray-100">
                        <div class="text-gray-300 mb-4">
                            <svg class="w-16 h-16 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path></svg>
                        </div>
                        <p class="text-gray-500">아직 작성된 리뷰가 없습니다.<br>첫 번째 리뷰어가 되어보세요!</p>
                    </div>
                </c:if>

                <div class="grid gap-4">
                    <c:forEach var="r" items="${book.reviews}">
                        <div class="bg-white rounded-2xl p-6 border border-gray-100 shadow-sm hover:shadow-md transition-shadow">
                            <div class="flex justify-between items-start mb-4">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center text-gray-700 font-bold text-sm">
                                        ${r.userName.substring(0,1)}
                                    </div>
                                    <div>
                                        <div class="font-bold text-gray-900 text-sm">${r.userName}</div>
                                        <div class="text-xs text-gray-400">${r.regDate}</div>
                                    </div>
                                </div>
                                <div class="flex bg-yellow-50 px-2 py-1 rounded-lg">
                                    <c:forEach begin="1" end="5" var="i">
                                        <svg class="w-4 h-4 ${i <= r.rating ? 'text-yellow-400' : 'text-gray-200'}" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                    </c:forEach>
                                </div>
                            </div>
                            <p class="text-gray-600 leading-relaxed text-sm">${r.content}</p>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Write Review Form (Sticky) -->
            <c:if test="${not empty sessionScope.user}">
                <div class="lg:sticky lg:top-24 h-fit">
                    <div class="bg-gray-900 text-white rounded-3xl p-8 shadow-xl relative overflow-hidden">
                        <div class="absolute top-0 right-0 w-32 h-32 bg-primary/20 rounded-full blur-3xl"></div>
                        
                        <h3 class="text-xl font-bold mb-6 relative z-10">
                            ${not empty myReview ? '나의 리뷰 수정' : '리뷰 남기기'}
                        </h3>
                        
                        <form action="${not empty myReview ? 'updateReview' : 'addReview'}" method="post" class="space-y-4 relative z-10">
                            <input type="hidden" name="isbn" value="${book.isbn}">
                             <c:if test="${not empty myReview}">
                                <input type="hidden" name="reviewId" value="${myReview.reviewId}">
                            </c:if>

                            <div>
                                <label class="block text-xs font-bold text-gray-400 mb-2 uppercase tracking-wide">Rating</label>
                                <div class="star-rating bg-white/10 p-3 rounded-xl inline-flex">
                                    <input type="radio" id="star5" name="rating" value="5" ${not empty myReview && myReview.rating == 5 ? 'checked' : ''} required /><label for="star5" title="5점"></label>
                                    <input type="radio" id="star4" name="rating" value="4" ${not empty myReview && myReview.rating == 4 ? 'checked' : ''} /><label for="star4" title="4점"></label>
                                    <input type="radio" id="star3" name="rating" value="3" ${not empty myReview && myReview.rating == 3 ? 'checked' : ''} /><label for="star3" title="3점"></label>
                                    <input type="radio" id="star2" name="rating" value="2" ${not empty myReview && myReview.rating == 2 ? 'checked' : ''} /><label for="star2" title="2점"></label>
                                    <input type="radio" id="star1" name="rating" value="1" ${not empty myReview && myReview.rating == 1 ? 'checked' : ''} /><label for="star1" title="1점"></label>
                                </div>
                            </div>
                            
                            <div>
                                <label class="block text-xs font-bold text-gray-400 mb-2 uppercase tracking-wide">Comment</label>
                                <textarea name="content" rows="4" required class="w-full bg-white/10 border border-white/10 rounded-xl p-4 text-white placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent resize-none text-sm" placeholder="이 책은 어떠셨나요? 감상을 공유해주세요.">${not empty myReview ? myReview.content : ''}</textarea>
                            </div>
                            
                            <button type="submit" class="w-full bg-white text-gray-900 py-3.5 rounded-xl font-bold hover:bg-gray-100 transition-colors shadow-lg mt-2">
                                ${not empty myReview ? '수정 완료' : '등록하기'}
                            </button>
                        </form>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</div>
<jsp:include page="footer.jsp" />