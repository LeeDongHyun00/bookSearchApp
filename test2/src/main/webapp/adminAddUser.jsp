<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />

<% // Security Check - Admin Only 
String currentUserId = (String) session.getAttribute("username"); 
if (!"admin".equals(currentUserId)) {response.sendRedirect("login.jsp"); return; } // Check for error message 
String errorMessage = (String) session.getAttribute("errorMessage"); 
if (errorMessage!= null) { session.removeAttribute("errorMessage"); } %>

<script>
  function checkId() {
    const userId = document.getElementById("username").value;
    const idRegex = /^[a-zA-Z0-9]{6,16}$/;

    if (!idRegex.test(userId)) {
      alert("아이디는 영문과 숫자로 6~16자 이내여야 합니다.");
      return;
    }

    fetch("userIdCheck", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: "userId=" + userId,
    })
      .then((response) => response.text())
      .then((data) => {
        if (data.trim() === "available") {
          alert("사용 가능한 아이디입니다.");
          document.getElementById("idChecked").value = "true";
        } else {
          alert("이미 사용중인 아이디입니다.");
          document.getElementById("idChecked").value = "false";
        }
      });
  }

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
    const idChecked = document.getElementById("idChecked").value;
    const emailId = document.getElementById("email_id").value;
    const emailDomain = document.getElementById("email_domain").value;

    if (idChecked !== "true") {
      alert("아이디 중복 확인을 해주세요.");
      e.preventDefault();
      return false;
    }

    if (password.length > 16) {
      alert("비밀번호는 16자 이내여야 합니다.");
      e.preventDefault();
      return false;
    }

    if (password !== confirm) {
      alert("비밀번호가 일치하지 않습니다.");
      e.preventDefault();
      return false;
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

    <% if (errorMessage != null) { %>
    <div class="bg-red-50 border border-red-200 rounded-lg p-4 mb-4">
      <p class="text-red-800 font-medium"><%= errorMessage %></p>
    </div>
    <% } %>

    <div
      class="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
      <div class="bg-gradient-to-r from-primary to-gray-900 p-8 text-white">
        <div class="flex items-center gap-3 mb-2">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="32"
            height="32"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2">
            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
            <circle cx="9" cy="7" r="4" />
            <line x1="19" x2="19" y1="8" y2="14" />
            <line x1="22" x2="16" y1="11" y2="11" />
          </svg>
          <h1 class="text-3xl font-bold">회원 추가</h1>
        </div>
        <p class="text-white/80">새로운 회원을 시스템에 등록합니다</p>
      </div>

      <form
        class="p-8 space-y-6"
        action="adminAddUser"
        method="POST"
        onsubmit="validateForm(event)">
        <input type="hidden" id="idChecked" value="false" />

        <div>
          <label
            for="nickname"
            class="block text-sm font-medium text-gray-700 mb-2">
            닉네임
          </label>
          <input
            id="nickname"
            name="nickname"
            type="text"
            required
            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all"
            placeholder="사용자 닉네임을 입력하세요" />
        </div>

        <div>
          <label
            for="username"
            class="block text-sm font-medium text-gray-700 mb-2">
            아이디
            <span class="text-xs text-gray-500 ml-2">(영문+숫자 6~16자)</span>
          </label>
          <div class="flex gap-2">
            <input
              id="username"
              name="userId"
              type="text"
              required
              class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all"
              placeholder="영문과 숫자 조합" />
            <button
              type="button"
              onclick="checkId()"
              class="px-6 py-3 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors font-medium whitespace-nowrap">
              중복확인
            </button>
          </div>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2"
            >이메일</label
          >
          <div class="flex items-center gap-2">
            <input
              type="text"
              id="email_id"
              required
              class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all"
              placeholder="이메일 아이디" />
            <span class="text-gray-500 font-medium">@</span>
            <input
              type="text"
              id="email_domain"
              required
              class="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all"
              placeholder="도메인" />
            <select
              onchange="updateEmailDomain(this)"
              class="px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all">
              <option value="direct">직접입력</option>
              <option value="naver.com">naver.com</option>
              <option value="gmail.com">gmail.com</option>
              <option value="daum.net">daum.net</option>
            </select>
          </div>
        </div>

        <div>
          <label
            for="password"
            class="block text-sm font-medium text-gray-700 mb-2">
            비밀번호
            <span class="text-xs text-gray-500 ml-2">(16자 이내)</span>
          </label>
          <input
            id="password"
            name="password"
            type="password"
            required
            maxlength="16"
            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all"
            placeholder="비밀번호를 입력하세요" />
        </div>

        <div>
          <label
            for="password_confirm"
            class="block text-sm font-medium text-gray-700 mb-2">
            비밀번호 확인
          </label>
          <input
            id="password_confirm"
            name="password_confirm"
            type="password"
            required
            maxlength="16"
            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all"
            placeholder="비밀번호를 다시 입력하세요" />
        </div>

        <div class="flex gap-3 pt-4">
          <button
            type="submit"
            class="flex-1 bg-primary text-white py-3 px-6 rounded-lg font-bold hover:bg-opacity-90 transition-all shadow-lg shadow-primary/30">
            회원 추가
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
