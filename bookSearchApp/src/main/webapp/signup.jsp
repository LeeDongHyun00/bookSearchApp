<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<jsp:include page="header.jsp" />
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

<div class="flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
  <div class="max-w-md w-full space-y-8 bg-white p-8 rounded-lg shadow-lg">
    <a
      href="index.jsp"
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
      목록으로 돌아가기
    </a>
    <div class="text-center">
      <h2 class="mt-6 text-3xl font-extrabold text-gray-900">회원가입</h2>
      <p class="mt-2 text-sm text-gray-600">
        이미 계정이 있으신가요?
        <a href="login.jsp" class="font-medium text-primary hover:text-blue-500"
          >로그인하기</a
        >
      </p>
    </div>

    <form
      class="mt-8 space-y-6"
      action="signup"
      method="POST"
      onsubmit="validateForm(event)">
      <input type="hidden" id="idChecked" value="false" />
      <div class="rounded-md shadow-sm space-y-4">
        <div>
          <label for="nickname" class="block text-sm font-medium text-gray-700"
            >닉네임</label
          >
          <input
            id="nickname"
            name="nickname"
            type="text"
            required
            class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-primary focus:border-primary sm:text-sm" />
        </div>
        <div>
          <label for="username" class="block text-sm font-medium text-gray-700"
            >아이디
            <span class="text-xs text-gray-500">(영문+숫자 6~16자)</span></label
          >
          <div class="flex gap-2">
            <input
              id="username"
              name="userId"
              type="text"
              required
              class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-primary focus:border-primary sm:text-sm" />
            <button
              type="button"
              onclick="checkId()"
              class="mt-1 px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-gray-600 hover:bg-gray-700 focus:outline-none whitespace-nowrap">
              중복확인
            </button>
          </div>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700">이메일</label>
          <div class="flex items-center gap-2 mt-1">
            <input
              type="text"
              id="email_id"
              required
              class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary sm:text-sm" />
            <span class="text-gray-500">@</span>
            <input
              type="text"
              id="email_domain"
              required
              class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary sm:text-sm" />
            <select
              onchange="updateEmailDomain(this)"
              class="block w-32 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary sm:text-sm">
              <option value="direct">직접입력</option>
              <option value="naver.com">naver.com</option>
              <option value="gmail.com">gmail.com</option>
              <option value="daum.net">daum.net</option>
            </select>
          </div>
        </div>
        <div>
          <label for="password" class="block text-sm font-medium text-gray-700"
            >비밀번호
            <span class="text-xs text-gray-500">(6~16자 이내)</span></label
          >
          <input
            id="password"
            name="password"
            type="password"
            required
            maxlength="16"
            class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-primary focus:border-primary sm:text-sm" />
        </div>
        <div>
          <label
            for="password_confirm"
            class="block text-sm font-medium text-gray-700"
            >비밀번호 확인</label
          >
          <input
            id="password_confirm"
            name="password_confirm"
            type="password"
            required
            maxlength="16"
            class="mt-1 appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-primary focus:border-primary sm:text-sm" />
        </div>
      </div>

      <div>
        <button
          type="submit"
          class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-primary hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary">
          가입하기
        </button>
      </div>
    </form>
  </div>
</div>

<jsp:include page="footer.jsp" />
