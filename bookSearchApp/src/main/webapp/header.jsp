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
      #searchContainer {
        transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
      }
    </style>
  </head>
  <body class="bg-gray-50">
    <nav class="bg-white shadow-sm sticky top-0 z-50">
      <div class="container mx-auto px-4">
        <div class="flex flex-wrap md:flex-nowrap justify-between items-center py-3 md:h-16 relative">
          <!-- Logo Section -->
          <a
            href="index.jsp"
            id="headerLogo"
            class="flex items-center gap-3 group shrink-0"
          >
            <div
              class="w-10 h-10 bg-primary text-white rounded-xl flex items-center justify-center transition-transform group-hover:scale-110"
            >
              <span class="text-xl font-bold">B</span>
            </div>
            <span class="text-xl font-bold text-gray-900">BookSearch</span>
          </a>
          
          <!-- User Nav Section (Mobile: Top Right, Desktop: Right) -->
          <div class="flex items-center gap-2 md:gap-4 shrink-0 md:order-last ml-auto md:ml-0">
            <% if(isLoggedIn) { %>
            <span class="text-gray-700 hidden lg:inline text-sm"
              >안녕하세요,
              <strong
                ><%= session.getAttribute("nickname") != null ?
                session.getAttribute("nickname") : username %></strong
              >님</span
            >
            <% if(isAdmin) { %>
            <a href="admin.jsp" class="px-3 py-1.5 md:px-4 md:py-2 text-xs md:text-sm font-medium text-white bg-purple-600 rounded-lg hover:bg-purple-700">대시보드</a>
            <% } %>
            <% if(!isAdmin) { %>
            <a href="mypage.jsp" class="px-3 py-1.5 md:px-4 md:py-2 text-xs md:text-sm font-medium text-gray-700 hover:text-primary whitespace-nowrap">마이페이지</a>
            <% } %>
            <a href="logout.jsp" class="px-3 py-1.5 md:px-4 md:py-2 text-xs md:text-sm font-medium text-white bg-gray-600 rounded-lg hover:bg-gray-700 whitespace-nowrap">로그아웃</a>
            <% } else { %>
            <a href="login.jsp" class="px-3 py-1.5 md:px-4 md:py-2 text-xs md:text-sm font-medium text-gray-700 hover:text-primary whitespace-nowrap">로그인</a>
            <a href="signup.jsp" class="px-3 py-1.5 md:px-4 md:py-2 text-xs md:text-sm font-medium text-white bg-primary rounded-lg hover:bg-opacity-90 whitespace-nowrap">회원가입</a>
            <% } %>
          </div>

          <% if(!isAdmin) { %>
          <!-- Search & Chat Container (Mobile: Full Width Next Line, Desktop: Center) -->
          <div class="w-full md:flex-1 md:w-auto flex justify-center mt-3 md:mt-0 md:mx-4 order-last md:order-none">
             <div id="searchContainer" class="w-full max-w-xl relative overflow-visible transition-all duration-500 ease-in-out z-40" style="height: 42px;">
                
                <!-- 1. Standard Search Bar -->
                <div id="defaultSearchMode" class="absolute w-full top-0 left-0 transition-all duration-500 transform translate-y-0 opacity-100">
                    <div class="flex gap-2">
                        <form action="index.jsp" method="get" class="relative flex-1">
                        <input
                            type="text"
                            name="q"
                            placeholder="도서명, 저자, 출판사 검색..."
                            value="${param.q}"
                            class="w-full pl-4 pr-10 py-2 rounded-full border border-gray-200 focus:border-primary focus:ring-2 focus:ring-blue-50 transition-all outline-none text-sm"
                        />
                        <button
                            type="submit"
                            class="absolute right-3 top-2.5 text-gray-400 hover:text-primary"
                        >
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                            </svg>
                        </button>
                        </form>
                        <!-- Recommendation Trigger Button -->
                        <button 
                            onclick="toggleChatMode()"
                            class="px-3 md:px-4 py-2 bg-gradient-to-r from-indigo-500 to-purple-600 text-white rounded-full text-sm font-medium hover:shadow-lg transition-all duration-300 flex items-center gap-2 whitespace-nowrap shrink-0"
                            title="AI 도서 추천"
                        >
                            <svg class="w-5 h-5 md:w-4 md:h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                            <span class="hidden md:inline">AI 추천</span>
                        </button>
                    </div>
                </div>

                <!-- 2. Chat Interface -->
                <jsp:include page="chatbot.jsp" />
             </div>
          </div>
          <% } else { %>
          <div class="flex-1"></div>
          <% } %>
        </div>
      </div>
    </nav>
  </body>
</html>
