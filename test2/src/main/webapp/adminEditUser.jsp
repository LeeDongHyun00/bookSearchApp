<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.book.dao.UserDAO" %>
<%@ page import="com.book.dto.UserDTO" %>
<jsp:include page="header.jsp" />

<%
    // Security Check - Admin Only
    String currentUserId = (String) session.getAttribute("username");
    if (!"admin".equals(currentUserId)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get user ID to edit
    String editUserId = request.getParameter("userId");
    if (editUserId == null || editUserId.trim().isEmpty()) {
        response.sendRedirect("admin.jsp?tab=users");
        return;
    }
    
    // Fetch user data
    UserDAO userDAO = new UserDAO();
    UserDTO user = userDAO.getUser(editUserId);
    
    if (user == null) {
        response.sendRedirect("admin.jsp?tab=users");
        return;
    }
    
    String[] emailParts = user.getEmail() != null ? user.getEmail().split("@") : new String[]{"", ""};
    String emailId = emailParts.length > 0 ? emailParts[0] : "";
    String emailDomain = emailParts.length > 1 ? emailParts[1] : "";
%>

<script>
  function updateEmailDomain(select) {
    const domainInput = document.getElementById("email_domain");
    if (select.value === "direct") {
      domainInput.readOnly = false;
      domainInput.value = "";
      domainInput.focus();
    } else {
      domainInput.readOnly = true;
      domainInput.value = select.value;
    }
  }

  function validateForm(e) {
    const password = document.getElementById("password").value;
    const confirm = document.getElementById("password_confirm").value;
    const emailId = document.getElementById("email_id").value;
    const emailDomain = document.getElementById("email_domain").value;

    if (password) {
      if (password.length > 16 || password.length < 6) {
        alert("비밀번호는 6~16자 이내여야 합니다.");
        e.preventDefault();
        return false;
      }
      if (password !== confirm) {
        alert("비밀번호가 일치하지 않습니다.");
        e.preventDefault();
        return false;
      }
    }

    // Combine email parts
    const fullEmail = emailId + "@" + emailDomain;
    const emailInput = document.createElement("input");
    emailInput.type = "hidden";
    emailInput.name = "email";
    emailInput.value = fullEmail;
    e.target.appendChild(emailInput);

    return true;
  }
</script>

<div class="container mx-auto px-4 py-12">
  <div class="max-w-2xl mx-auto">
    <a
      href="admin.jsp?tab=users"
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
            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
          </svg>
          <h1 class="text-3xl font-bold">회원 정보 수정</h1>
        </div>
        <p class="text-white/80">@<%= user.getUserId() %> 사용자의 정보를 수정합니다</p>
      </div>

      <form
        class="p-8 space-y-6"
        action="adminUpdateUser"
        method="POST"
        onsubmit="validateForm(event)">
        <input type="hidden" name="targetUserId" value="<%= user.getUserId() %>" />
        
        <div>
          <label for="userId" class="block text-sm font-medium text-gray-700 mb-2">
            아이디
          </label>
          <input
            id="userId"
            type="text"
            value="<%= user.getUserId() %>"
            disabled
            class="w-full px-4 py-3 border border-gray-300 rounded-lg bg-gray-50 text-gray-500 cursor-not-allowed"/>
          <p class="mt-1 text-xs text-gray-500">아이디는 수정할 수 없습니다</p>
        </div>

        <div>
          <label for="nickname" class="block text-sm font-medium text-gray-700 mb-2">
            닉네임
          </label>
          <input
            id="nickname"
            name="nickname"
            type="text"
            required
            value="<%= user.getNickname() %>"
            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all" 
            placeholder="사용자 닉네임"/>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">이메일</label>
          <div class="flex items-center gap-2">
            <input
              type="text"
              id="email_id"
              value="<%= emailId %>"
              required
              class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all" 
              placeholder="이메일 아이디"/>
            <span class="text-gray-500 font-medium">@</span>
            <input
              type="text"
              id="email_domain"
              value="<%= emailDomain %>"
              required
              class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all" 
              placeholder="도메인"/>
            <select
              onchange="updateEmailDomain(this)"
              class="px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all">
              <option value="direct">직접입력</option>
              <option value="naver.com" <%= "naver.com".equals(emailDomain) ? "selected" : "" %>>naver.com</option>
              <option value="gmail.com" <%= "gmail.com".equals(emailDomain) ? "selected" : "" %>>gmail.com</option>
              <option value="daum.net" <%= "daum.net".equals(emailDomain) ? "selected" : "" %>>daum.net</option>
            </select>
          </div>
        </div>

        <div class="border-t border-gray-200 pt-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-4">비밀번호 변경</h3>
          <p class="text-sm text-gray-500 mb-4">비밀번호를 변경하려면 아래 필드를 입력하세요. 변경하지 않으려면 비워두세요.</p>
          
          <div class="space-y-4">
            <div>
              <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
                새 비밀번호
                <span class="text-xs text-gray-500 ml-2">(6~16자 이내, 선택사항)</span>
              </label>
              <input
                id="password"
                name="password"
                type="password"
                maxlength="16"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all" 
                placeholder="변경할 비밀번호 (공백 시 변경 안 함)"/>
            </div>

            <div>
              <label
                for="password_confirm"
                class="block text-sm font-medium text-gray-700 mb-2">
                새 비밀번호 확인
              </label>
              <input
                id="password_confirm"
                name="password_confirm"
                type="password"
                maxlength="16"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all" 
                placeholder="비밀번호 확인"/>
            </div>
          </div>
        </div>

        <div class="flex gap-3 pt-4">
          <button
            type="submit"
            class="flex-1 bg-primary text-white py-3 px-6 rounded-lg font-bold hover:bg-opacity-90 transition-all shadow-lg shadow-primary/30">
            변경사항 저장
          </button>
          <a
            href="admin.jsp?tab=users"
            class="px-6 py-3 border-2 border-gray-300 text-gray-700 rounded-lg font-medium hover:bg-gray-50 transition-colors">
            취소
          </a>
        </div>
      </form>
    </div>
  </div>
</div>

<jsp:include page="footer.jsp" />
