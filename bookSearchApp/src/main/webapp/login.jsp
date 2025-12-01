<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>로그인 - BookSearch</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: { extend: { colors: { primary: "#030213" } } },
      };
    </script>
  </head>
  <body class="bg-gray-50 min-h-screen flex items-center justify-center p-4">
    <div
      class="bg-white w-full max-w-md rounded-2xl shadow-xl p-8 animate-fade-in">
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
      <div class="text-center mb-8">
        <div
          class="w-12 h-12 bg-primary text-white rounded-xl flex items-center justify-center mx-auto mb-4">
          <span class="text-2xl font-bold">B</span>
        </div>
        <h1 class="text-2xl font-bold text-gray-900">
          계정에 로그인하여 <br />
          서재를 관리하세요.
        </h1>
      </div>

      <!-- Test Credentials Info -->
      <div
        class="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6 text-sm">
        <p class="font-bold text-blue-900 mb-2">🔑 테스트 계정 정보:</p>
        <div class="space-y-1 text-blue-800">
          <p><strong>일반 사용자:</strong> testuser / testuser</p>
          <p><strong>관리자:</strong> admin / admin</p>
        </div>
      </div>

      <form action="login" method="post" class="space-y-5">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1"
            >아이디</label
          >
          <input
            type="text"
            name="username"
            class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all"
            placeholder="testuser" 
            autofocus/>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1"
            >비밀번호</label
          >
          <input
            type="password"
            name="password"
            class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all"
            placeholder="••••••••" />
        </div>
        <button
          type="submit"
          class="w-full bg-primary text-white py-3 rounded-lg font-bold hover:bg-opacity-90 transition-all shadow-lg shadow-gray-200">
          로그인
        </button>
      </form>

      <div class="mt-6 text-center text-sm text-gray-500">
        계정이 없으신가요?
        <a href="signup.jsp" class="text-primary font-bold hover:underline"
          >회원가입</a
        >
      </div>
    </div>
  </body>
</html>
