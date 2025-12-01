<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <% String username = (String)
session.getAttribute("username"); boolean isAdmin = "admin".equals(username);
boolean isLoggedIn = username != null; %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>BookSearch - 도서 검색</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#030213",
            },
          },
        },
      };
    </script>
    <style>
      @import url("https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap");
      body {
        font-family: "Noto Sans KR", sans-serif;
      }
    </style>
  </head>
  <body class="bg-gray-50">
    <nav class="bg-white shadow-sm sticky top-0 z-50">
      <div class="container mx-auto px-4">
        <div class="flex justify-between items-center h-16">
          <a href="index.jsp" class="flex items-center gap-3 group">
            <div
              class="w-10 h-10 bg-primary text-white rounded-xl flex items-center justify-center transition-transform group-hover:scale-110">
              <span class="text-xl font-bold">B</span>
            </div>
            <span class="text-xl font-bold text-gray-900">BookSearch</span>
          </a>
          <% if(!isAdmin) { %>
          <div class="flex-1 max-w-xl mx-8 hidden md:block">
            <form action="index.jsp" method="get" class="relative">
              <input
                type="text"
                name="q"
                placeholder="도서명, 저자, 출판사 검색..."
                value="${param.q}"
                class="w-full px-4 py-2 rounded-full border border-gray-200 focus:border-primary focus:ring-2 focus:ring-blue-50 transition-all outline-none text-sm" />
              <button
                type="submit"
                class="absolute right-3 top-2.5 text-gray-400 hover:text-primary">
                <svg
                  class="w-5 h-5"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                </svg>
              </button>
            </form>
          </div>
          <% } else { %>
          <div class="flex-1"></div>
          <% } %>
          <div class="flex items-center gap-4">
            <% if(isLoggedIn) { %>
            <span class="text-gray-700"
              >안녕하세요,
              <strong
                ><%= session.getAttribute("nickname") != null ?
                session.getAttribute("nickname") : username %></strong
              >님</span
            >
            <!-- admin header nav -->
            <% if(isAdmin) { %>
            <a
              href="admin.jsp"
              class="px-4 py-2 text-sm font-medium text-white bg-purple-600 rounded-lg hover:bg-purple-700"
              >대시보드</a
            >
            <% } %>
            <!-- user header nav -->
            <% if(!isAdmin) { %>
            <a
              href="mypage.jsp"
              class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-primary"
              >마이페이지</a
            >
            <% } %>

            <a
              href="logout.jsp"
              class="px-4 py-2 text-sm font-medium text-white bg-gray-600 rounded-lg hover:bg-gray-700"
              >로그아웃</a
            >
            <% } else { %>
            <a
              href="login.jsp"
              class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-primary"
              >로그인</a
            >
            <a
              href="signup.jsp"
              class="px-4 py-2 text-sm font-medium text-white bg-primary rounded-lg hover:bg-opacity-90"
              >회원가입</a
            >
            <% } %>
          </div>
        </div>
      </div>
    </nav>
  </body>
</html>
