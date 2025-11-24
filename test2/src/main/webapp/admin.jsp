<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.book.dao.UserDAO" %>
<%@ page import="com.book.dto.UserDTO" %>
<%@ include file="data.jsp" %>
<jsp:include page="header.jsp" />

<%
    // Security Check
    String currentUserId = (String) session.getAttribute("username");
    if (!"admin".equals(currentUserId)) {
        response.sendRedirect("login.jsp");
        return;
    }

    String tab = request.getParameter("tab");
    if (tab == null) tab = "dashboard";
    
    List<Book> books = getMockBooks();
    UserDAO userDAO = new UserDAO();
    List<UserDTO> users = userDAO.getAllUsers();
    int totalUsers = users.size();
    int totalBooks = books.size();
    int totalReviews = 0;
    for(Book b : books) totalReviews += b.reviewCount;
%>

<script>
function banUser(userId) {
    if(confirm('정말 ' + userId + ' 회원을 추방하시겠습니까?\n이 작업은 되돌릴 수 없습니다.')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'adminBanUser';
        
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'userId';
        input.value = userId;
        
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }
}
</script>

<%
    // Display success message if present
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
%>
<script>
    alert('<%= successMessage %>');
</script>
<%
    }
%>


<div class="container mx-auto px-4 py-8 max-w-7xl">
    <!-- Page Header -->
    <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">관리자 대시보드</h1>
    </div>

    <div class="flex flex-col lg:flex-row gap-6">
        <!-- Sidebar Navigation -->
        <aside class="lg:w-64 flex-shrink-0">
            <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden sticky top-24">
                <div class="p-6 bg-gradient-to-br from-primary to-blue-900 text-white">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 bg-white/20 backdrop-blur rounded-xl flex items-center justify-center">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                        </div>
                        <div>
                            <h3 class="font-bold text-lg">Admin Panel</h3>
                            <p class="text-xs text-white/80">시스템 관리</p>
                        </div>
                    </div>
                </div>
                <nav class="p-3">
                    <a href="admin.jsp?tab=dashboard" class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all mb-1 <%= "dashboard".equals(tab) ? "bg-primary text-white shadow-lg shadow-primary/30" : "text-gray-600 hover:bg-gray-50" %>">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/></svg>
                        <span class="font-medium">대시보드</span>
                    </a>
                    <a href="admin.jsp?tab=users" class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all mb-1 <%= "users".equals(tab) ? "bg-primary text-white shadow-lg shadow-primary/30" : "text-gray-600 hover:bg-gray-50" %>">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        <span class="font-medium">회원 관리</span>
                    </a>
                    <a href="admin.jsp?tab=books" class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all <%= "books".equals(tab) ? "bg-primary text-white shadow-lg shadow-primary/30" : "text-gray-600 hover:bg-gray-50" %>">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                        <span class="font-medium">도서 관리</span>
                    </a>
                </nav>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="flex-1 min-w-0">
            <% if ("dashboard".equals(tab)) { %>
                <!-- Dashboard Stats -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl p-6 text-white shadow-lg shadow-blue-500/30 transform hover:scale-105 transition-transform">
                        <div class="flex justify-between items-start mb-4">
                            <div>
                                <p class="text-blue-100 text-sm font-medium mb-1">총 사용자</p>
                                <h3 class="text-4xl font-bold"><%= totalUsers %></h3>
                            </div>
                            <div class="w-12 h-12 bg-white/20 backdrop-blur rounded-xl flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                            </div>
                        </div>
                        <div class="flex items-center text-sm text-blue-100">
                            <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M12 7a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0V8.414l-4.293 4.293a1 1 0 01-1.414 0L8 10.414l-4.293 4.293a1 1 0 01-1.414-1.414l5-5a1 1 0 011.414 0L11 10.586 14.586 7H12z" clip-rule="evenodd"/></svg>
                            활성 회원
                        </div>
                    </div>

                    <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-2xl p-6 text-white shadow-lg shadow-green-500/30 transform hover:scale-105 transition-transform">
                        <div class="flex justify-between items-start mb-4">
                            <div>
                                <p class="text-green-100 text-sm font-medium mb-1">총 도서</p>
                                <h3 class="text-4xl font-bold"><%= totalBooks %></h3>
                            </div>
                            <div class="w-12 h-12 bg-white/20 backdrop-blur rounded-xl flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                            </div>
                        </div>
                        <div class="flex items-center text-sm text-green-100">
                            <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v2H7a1 1 0 100 2h2v2a1 1 0 102 0v-2h2a1 1 0 100-2h-2V7z" clip-rule="evenodd"/></svg>
                            등록된 도서
                        </div>
                    </div>

                    <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-2xl p-6 text-white shadow-lg shadow-purple-500/30 transform hover:scale-105 transition-transform">
                        <div class="flex justify-between items-start mb-4">
                            <div>
                                <p class="text-purple-100 text-sm font-medium mb-1">총 리뷰</p>
                                <h3 class="text-4xl font-bold"><%= totalReviews %></h3>
                            </div>
                            <div class="w-12 h-12 bg-white/20 backdrop-blur rounded-xl flex items-center justify-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                            </div>
                        </div>
                        <div class="flex items-center text-sm text-purple-100">
                            <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                            사용자 리뷰
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 mb-6">
                    <h2 class="text-xl font-bold text-gray-900 mb-4">빠른 작업</h2>
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                        <button onclick="location.href='adminAddUser.jsp'" class="flex flex-col items-center justify-center p-4 rounded-xl border-2 border-gray-200 hover:border-primary hover:bg-primary/5 transition-all group">
                            <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center mb-2 group-hover:bg-primary/20 transition-colors">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="text-blue-600"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" x2="19" y1="8" y2="14"/><line x1="22" x2="16" y1="11" y2="11"/></svg>
                            </div>
                            <span class="text-sm font-medium text-gray-700">회원 추가</span>
                        </button>
                        <button class="flex flex-col items-center justify-center p-4 rounded-xl border-2 border-gray-200 hover:border-primary hover:bg-primary/5 transition-all group">
                            <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center mb-2 group-hover:bg-primary/20 transition-colors">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="text-green-600"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/><line x1="12" x2="12" y1="7" y2="13"/><line x1="9" x2="15" y1="10" y2="10"/></svg>
                            </div>
                            <span class="text-sm font-medium text-gray-700">도서 등록</span>
                        </button>
                        <button class="flex flex-col items-center justify-center p-4 rounded-xl border-2 border-gray-200 hover:border-primary hover:bg-primary/5 transition-all group">
                            <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center mb-2 group-hover:bg-primary/20 transition-colors">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="text-purple-600"><path d="M3 3v18h18"/><path d="m19 9-5 5-4-4-3 3"/></svg>
                            </div>
                            <span class="text-sm font-medium text-gray-700">통계 보기</span>
                        </button>
                        <button class="flex flex-col items-center justify-center p-4 rounded-xl border-2 border-gray-200 hover:border-primary hover:bg-primary/5 transition-all group">
                            <div class="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center mb-2 group-hover:bg-primary/20 transition-colors">
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="text-orange-600"><path d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"/><circle cx="12" cy="12" r="3"/></svg>
                            </div>
                            <span class="text-sm font-medium text-gray-700">설정</span>
                        </button>
                    </div>
                </div>

            <% } else if ("users".equals(tab)) { %>
                <!-- Users Management -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
                    <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                        <div>
                            <h2 class="text-2xl font-bold text-gray-900">회원 관리</h2>
                            <p class="text-sm text-gray-500 mt-1">전체 <%= totalUsers %>명의 회원</p>
                        </div>
                        <button onclick="location.href='adminAddUser.jsp'" class="bg-primary text-white px-4 py-2 rounded-xl hover:bg-opacity-90 transition-all flex items-center gap-2 shadow-lg shadow-primary/30">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                            회원 추가
                        </button>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">사용자</th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">이메일</th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">역할</th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">가입일</th>
                                    <th class="px-6 py-4 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider">작업</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-100">
                                <% for(UserDTO u : users) { %>
                                <tr class="hover:bg-gray-50 transition-colors">
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                            <div class="w-10 h-10 bg-gradient-to-br from-primary to-blue-600 rounded-full flex items-center justify-center text-white font-bold mr-3">
                                                <%= u.getNickname().substring(0,1) %>
                                            </div>
                                            <div>
                                                <div class="text-sm font-semibold text-gray-900"><%= u.getNickname() %></div>
                                                <div class="text-xs text-gray-500">@<%= u.getUserId() %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= u.getEmail() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <% if("admin".equals(u.getUserId())) { %>
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-purple-100 text-purple-800">관리자</span>
                                        <% } else { %>
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">일반</span>
                                        <% } %>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">-</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                        <button onclick="location.href='adminEditUser.jsp?userId=<%= u.getUserId() %>'" class="text-primary hover:text-blue-900 mr-3 font-medium">수정</button>
                                        <% if(!"admin".equals(u.getUserId())) { %>
                                            <button onclick="banUser('<%= u.getUserId() %>')" class="text-red-600 hover:text-red-900 font-medium">추방</button>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

            <% } else if ("books".equals(tab)) { %>
                <!-- Books Management -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
                    <div class="p-6 border-b border-gray-100 flex justify-between items-center">
                        <div>
                            <h2 class="text-2xl font-bold text-gray-900">도서 관리</h2>
                            <p class="text-sm text-gray-500 mt-1">전체 <%= books.size() %>권의 도서</p>
                        </div>
                        <button onclick="alert('도서 추가 기능은 준비 중입니다.')" class="bg-primary text-white px-4 py-2 rounded-xl hover:bg-opacity-90 transition-all flex items-center gap-2 shadow-lg shadow-primary/30">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                            도서 추가
                        </button>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">도서</th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">저자</th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">카테고리</th>
                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">평점</th>
                                    <th class="px-6 py-4 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider">작업</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-100">
                                <% for (Book b : books) { %>
                                <tr class="hover:bg-gray-50 transition-colors">
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                            <img src="<%= b.coverImage %>" alt="" class="w-12 h-16 object-cover rounded-lg shadow-sm mr-3">
                                            <div>
                                                <div class="text-sm font-semibold text-gray-900"><%= b.title %></div>
                                                <div class="text-xs text-gray-500"><%= b.publishDate %></div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600"><%= b.author %></td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800"><%= b.category %></span>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center">
                                            <svg class="w-4 h-4 text-yellow-400 mr-1" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                                            <span class="text-sm font-medium text-gray-900"><%= b.rating %></span>
                                            <span class="text-xs text-gray-500 ml-1">(<%= b.reviewCount %>)</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                        <button class="text-primary hover:text-blue-900 mr-3 font-medium">수정</button>
                                        <button class="text-red-600 hover:text-red-900 font-medium">삭제</button>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            <% } %>
        </main>
    </div>
</div>

<jsp:include page="footer.jsp" />
