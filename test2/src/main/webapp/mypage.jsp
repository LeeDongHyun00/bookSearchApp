<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.book.dao.UserDAO" %>
<%@ page import="com.book.dto.UserDTO" %>
<%@ page import="java.util.List" %>
<%@ include file="data.jsp" %>
<jsp:include page="header.jsp" />

<%
    if(session.getAttribute("username") == null) { response.sendRedirect("login.jsp"); return; }
    String tab = request.getParameter("tab");
    if(tab == null) tab = "library";
    String user = (String)session.getAttribute("username");
%>

<div class="container mx-auto px-4 py-10 max-w-6xl">
    <h1 class="text-3xl font-bold text-gray-900 mb-8">마이페이지</h1>
    
    <div class="flex flex-col md:flex-row gap-8">
        <aside class="w-full md:w-64 flex-shrink-0">
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                <div class="p-6 bg-gray-50 border-b border-gray-100">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 bg-primary text-white rounded-full flex items-center justify-center text-xl font-bold">
                            <%= user.substring(0,1) %>
                        </div>
                        <div>
                            <h3 class="font-bold text-gray-900"><%= user %></h3>
                            <span class="text-xs text-gray-500">일반 회원</span>
                        </div>
                    </div>
                </div>
                <nav class="p-2 space-y-1">
                    <a href="?tab=library" class="flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-colors <%= "library".equals(tab) ? "bg-blue-50 text-primary" : "text-gray-600 hover:bg-gray-50" %>">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                        내 서재
                    </a>
                    <a href="?tab=info" class="flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-colors <%= "info".equals(tab) ? "bg-blue-50 text-primary" : "text-gray-600 hover:bg-gray-50" %>">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                        회원 정보 수정
                    </a>
                    <a href="?tab=reviews" class="flex items-center gap-3 px-4 py-3 rounded-lg text-sm font-medium transition-colors <%= "reviews".equals(tab) ? "bg-blue-50 text-primary" : "text-gray-600 hover:bg-gray-50" %>">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
                        내 리뷰 관리
                    </a>
                </nav>
            </div>
        </aside>

        <main class="flex-1 bg-white rounded-xl shadow-sm border border-gray-100 p-8 min-h-[500px]">
            <% if("library".equals(tab)) { %>
                <h2 class="text-2xl font-bold mb-6">나의 서재 (관심 목록)</h2>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                    <% List<Book> books = getMockBooks(); 
                       for(int i=0; i<3; i++) { Book b = books.get(i); %>
                    <div class="border border-gray-100 rounded-lg overflow-hidden group hover:shadow-md transition-all">
                        <div class="relative aspect-[2/3] bg-gray-100">
                            <img src="<%= b.coverImage %>" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                            <div class="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                                <button class="bg-white text-primary px-4 py-2 rounded-full text-sm font-bold hover:bg-gray-100">상세보기</button>
                            </div>
                        </div>
                        <div class="p-4">
                            <h3 class="font-bold text-gray-900 truncate"><%= b.title %></h3>
                            <p class="text-xs text-gray-500 truncate mb-3"><%= b.author %></p>
                            <button class="w-full py-2 border border-gray-200 rounded-lg text-sm font-medium hover:bg-gray-50 text-gray-600">삭제</button>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } else if("info".equals(tab)) { 
                // Optimization: Use session data if available to avoid slow DB call
                String nickname = (String)session.getAttribute("nickname");
                String email = (String)session.getAttribute("email");
                
                // Fallback to DB if session data is missing (e.g. direct access after session expiry/renewal)
                if(nickname == null || email == null) {
                    UserDAO userDAO = new UserDAO();
                    UserDTO userInfo = userDAO.getUser(user);
                    if(userInfo != null) {
                        nickname = userInfo.getNickname();
                        email = userInfo.getEmail();
                        // Update session for next time
                        session.setAttribute("nickname", nickname);
                        session.setAttribute("email", email);
                    }
                }
                
                String[] emailParts = email != null ? email.split("@") : new String[]{"", ""};
                String emailId = emailParts.length > 0 ? emailParts[0] : "";
                String emailDomain = emailParts.length > 1 ? emailParts[1] : "";
            %>
                <h2 class="text-2xl font-bold mb-6">회원 정보 수정</h2>
                
                <script>
                    function updateEmailDomain(select) {
                        const domainInput = document.getElementById('email_domain');
                        if(select.value === 'direct') {
                            domainInput.readOnly = false;
                            domainInput.value = '';
                            domainInput.focus();
                        } else {
                            domainInput.readOnly = true;
                            domainInput.value = select.value;
                        }
                    }

                    function validateUpdateForm(e) {
                        const password = document.getElementById('password').value;
                        const confirm = document.getElementById('password_confirm').value;
                        const emailId = document.getElementById('email_id').value;
                        const emailDomain = document.getElementById('email_domain').value;
                        
                        if(password) {
                            if(password.length > 16 || password.length < 6) {
                                alert('비밀번호는 6~16자 이내여야 합니다.');
                                e.preventDefault();
                                return false;
                            }
                            if(password !== confirm) {
                                alert('비밀번호가 일치하지 않습니다.');
                                e.preventDefault();
                                return false;
                            }
                        }
                        
                        // Combine email parts
                        const fullEmail = emailId + '@' + emailDomain;
                        const emailInput = document.createElement('input');
                        emailInput.type = 'hidden';
                        emailInput.name = 'email';
                        emailInput.value = fullEmail;
                        e.target.appendChild(emailInput);
                        
                        return true;
                    }
                </script>
                
                <form class="max-w-md space-y-4" action="userUpdateInfo" method="post" onsubmit="validateUpdateForm(event)">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">아이디</label>
                        <input type="text" value="<%= user %>" disabled class="w-full px-4 py-2 border rounded-lg bg-gray-50 text-gray-500">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">닉네임</label>
                        <input type="text" name="nickname" value="<%= nickname != null ? nickname : "" %>" class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-primary outline-none">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">이메일</label>
                        <div class="flex items-center gap-2">
                            <input type="text" id="email_id" value="<%= emailId %>" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-primary outline-none">
                            <span class="text-gray-500">@</span>
                            <input type="text" id="email_domain" value="<%= emailDomain %>" required class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-primary outline-none">
                            <select onchange="updateEmailDomain(this)" class="w-32 px-4 py-2 border rounded-lg focus:ring-2 focus:ring-primary outline-none">
                                <option value="direct">직접입력</option>
                                <option value="naver.com" <%= "naver.com".equals(emailDomain) ? "selected" : "" %>>naver.com</option>
                                <option value="gmail.com" <%= "gmail.com".equals(emailDomain) ? "selected" : "" %>>gmail.com</option>
                                <option value="daum.net" <%= "daum.net".equals(emailDomain) ? "selected" : "" %>>daum.net</option>
                            </select>
                        </div>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">새 비밀번호 <span class="text-xs text-gray-500">(6~16자 이내)</span></label>
                        <input type="password" id="password" name="password" maxlength="16" placeholder="변경할 비밀번호를 입력하세요" class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-primary outline-none">
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">새 비밀번호 확인</label>
                        <input type="password" id="password_confirm" name="passwordConfirm" maxlength="16" placeholder="비밀번호를 다시 입력하세요" class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-primary outline-none">
                    </div>
                    <div class="pt-4 flex gap-3">
                        <button type="submit" class="flex-1 bg-primary text-white px-6 py-2 rounded-lg hover:bg-opacity-90">저장하기</button>
                        <button type="button" onclick="deleteAccount()" class="px-6 py-2 border border-red-200 text-red-600 rounded-lg hover:bg-red-50">회원 탈퇴</button>
                    </div>
                    
                    <script>
                        function deleteAccount() {
                            if(confirm('정말 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
                                const form = document.createElement('form');
                                form.method = 'POST';
                                form.action = 'userWithdrawal';
                                document.body.appendChild(form);
                                form.submit();
                            }
                        }
                    </script>
                </form>
            <% } else if("reviews".equals(tab)) { %>
                <h2 class="text-2xl font-bold mb-6">내 리뷰 관리</h2>
                <div class="space-y-4">
                    <%-- Mock Reviews for the user --%>
                    <div class="border border-gray-100 rounded-lg p-6 hover:shadow-sm transition-shadow">
                        <div class="flex justify-between items-start mb-2">
                            <h3 class="font-bold text-gray-900">채식주의자</h3>
                            <span class="text-xs text-gray-400">2024-01-15</span>
                        </div>
                        <div class="flex text-yellow-400 text-sm mb-3">★★★★★</div>
                        <p class="text-gray-600 text-sm mb-4">정말 강렬한 소설입니다. 한강 작가님의 문체에 압도되었습니다.</p>
                        <div class="flex gap-2 justify-end">
                            <button class="text-sm text-gray-500 hover:text-primary">수정</button>
                            <button class="text-sm text-red-500 hover:text-red-700">삭제</button>
                        </div>
                    </div>
                    <div class="border border-gray-100 rounded-lg p-6 hover:shadow-sm transition-shadow">
                        <div class="flex justify-between items-start mb-2">
                            <h3 class="font-bold text-gray-900">소년이 온다</h3>
                            <span class="text-xs text-gray-400">2024-02-01</span>
                        </div>
                        <div class="flex text-yellow-400 text-sm mb-3">★★★★☆</div>
                        <p class="text-gray-600 text-sm mb-4">마음이 아프지만 꼭 읽어야 할 책입니다.</p>
                        <div class="flex gap-2 justify-end">
                            <button class="text-sm text-gray-500 hover:text-primary">수정</button>
                            <button class="text-sm text-red-500 hover:text-red-700">삭제</button>
                        </div>
                    </div>
                </div>
            <% } %>
        </main>
    </div>
</div>
<jsp:include page="footer.jsp" />
