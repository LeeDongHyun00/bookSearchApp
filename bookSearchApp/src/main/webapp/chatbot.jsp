<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    /* Chat bubble animation */
    @keyframes popIn {
        0% { transform: scale(0.9); opacity: 0; }
        100% { transform: scale(1); opacity: 1; }
    }
    .chat-bubble {
        animation: popIn 0.3s cubic-bezier(0.18, 0.89, 0.32, 1.28) forwards;
    }
    /* Scrollbar styling for chat */
    .chat-scroll::-webkit-scrollbar {
        width: 6px;
    }
    .chat-scroll::-webkit-scrollbar-track {
        background: #f1f1f1;
    }
    .chat-scroll::-webkit-scrollbar-thumb {
        background: #d1d5db;
        border-radius: 3px;
    }
    .chat-scroll::-webkit-scrollbar-thumb:hover {
        background: #9ca3af;
    }
</style>

<!-- Chat Interface -->
<!-- Desktop: Uses translate-y-48. Mobile: Part of the flow. -->
<div id="chatInterface" class="hidden absolute w-full left-0 transition-all duration-500 transform translate-y-full opacity-0 md:translate-y-0 md:shadow-2xl md:rounded-2xl z-50">
    <div class="bg-white border border-gray-200 rounded-2xl shadow-xl overflow-hidden flex flex-col h-[500px]">
        <!-- Chat Header -->
        <div class="bg-gradient-to-r from-indigo-600 to-purple-600 p-4 flex justify-between items-center text-white shrink-0">
            <div class="flex items-center gap-2">
                <div class="w-8 h-8 bg-white/20 rounded-full flex items-center justify-center backdrop-blur-sm">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"></path></svg>
                </div>
                <div>
                    <h3 class="font-bold text-sm">AI 도서 추천 봇</h3>
                    <p class="text-xs text-indigo-100">취향을 말해주시면 책을 추천해드려요!</p>
                </div>
            </div>
            <div class="flex items-center gap-2">
                <button onclick="clearChatHistory()" class="p-1 hover:bg-white/20 rounded-full transition-colors" title="대화 내용 지우기">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                </button>
                <button onclick="closeChatMode()" class="p-1 hover:bg-white/20 rounded-full transition-colors">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
        </div>
        
        <!-- Chat Messages Area -->
        <div id="chatMessages" class="flex-1 p-4 overflow-y-auto chat-scroll bg-gray-50 space-y-4">
            <!-- Welcome Message -->
            <div class="flex gap-3 chat-bubble">
                <div class="w-8 h-8 rounded-full bg-gradient-to-br from-indigo-500 to-purple-500 flex items-center justify-center text-white shrink-0 shadow-sm text-xs">AI</div>
                <div class="bg-white p-3 rounded-2xl rounded-tl-none shadow-sm text-sm text-gray-700 max-w-[85%] border border-gray-100">
                    안녕하세요! 어떤 책을 찾으시나요? <br>
                    "슬픈 로맨스 소설 추천해줘" 처럼 말씀해주세요! 📚
                </div>
            </div>
        </div>

        <!-- Input Area -->
        <div class="p-4 bg-white border-t border-gray-100 shrink-0">
            <form onsubmit="handleChatSubmit(event)" class="relative">
                <input 
                    type="text" 
                    id="chatInput"
                    placeholder="예: 힐링되는 에세이 추천해줘..." 
                    class="w-full pl-4 pr-12 py-3 bg-gray-50 border-0 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:bg-white transition-all text-sm"
                    autocomplete="off"
                >
                <button type="submit" class="absolute right-2 top-2 p-1.5 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors shadow-sm">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"></path></svg>
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    const FLASK_SERVER_URL = "http://localhost:5000/recommend"; 

    function toggleChatMode() {
        const container = document.getElementById('searchContainer');
        const defaultSearch = document.getElementById('defaultSearchMode');
        const chatInterface = document.getElementById('chatInterface');
        const isMobile = window.innerWidth < 768;

        // Expand container height ONLY on mobile
        if (isMobile) {
            container.style.height = '520px'; 
        } else {
            container.style.height = '42px'; // Keep original height
        }
        container.style.overflow = 'visible'; // Always allow overflow for desktop dropdown
        
        // Slide up default search
        defaultSearch.classList.remove('translate-y-0', 'opacity-100');
        defaultSearch.classList.add('-translate-y-full', 'opacity-0');
        
        // Slide down chat interface
        chatInterface.classList.remove('hidden'); // Remove hidden first
        // Need a small delay to allow display:block to apply before transition
        requestAnimationFrame(() => {
            chatInterface.classList.remove('translate-y-full', 'opacity-0');
            chatInterface.classList.add('translate-y-0', 'opacity-100');
        });
        
        // Focus input after transition
        setTimeout(() => {
            document.getElementById('chatInput').focus();
        }, 500);
    }

    function closeChatMode() {
        const container = document.getElementById('searchContainer');
        const defaultSearch = document.getElementById('defaultSearchMode');
        const chatInterface = document.getElementById('chatInterface');
        
        // Restore container height
        container.style.height = '42px';
        container.style.overflow = 'visible'; // Or hidden if preferred, but visible is safe
        
        // Restore default search
        defaultSearch.classList.remove('-translate-y-full', 'opacity-0');
        defaultSearch.classList.add('translate-y-0', 'opacity-100');
        
        // Hide chat interface
        chatInterface.classList.remove('translate-y-0', 'opacity-100');
        chatInterface.classList.add('translate-y-full', 'opacity-0');
        
        // Add hidden after transition
        setTimeout(() => {
            chatInterface.classList.add('hidden');
        }, 500);
    }

    function clearChatHistory() {
        const chatMessages = document.getElementById('chatMessages');
        chatMessages.innerHTML = ''; // Removes all child elements
        
        // Optional: Add default welcome message back if desired, or keep it empty as requested "resetting the view" usually implies empty or default state.
        // Let's add the default welcome message back for better UX
        const div = document.createElement('div');
        div.className = 'flex gap-3 chat-bubble';
        div.innerHTML = `
            <div class="w-8 h-8 rounded-full bg-gradient-to-br from-indigo-500 to-purple-500 flex items-center justify-center text-white shrink-0 shadow-sm text-xs">AI</div>
            <div class="bg-white p-3 rounded-2xl rounded-tl-none shadow-sm text-sm text-gray-700 max-w-[85%] border border-gray-100">
                대화 내용이 초기화되었습니다. 다시 말씀해주세요! 🧹
            </div>
        `;
        chatMessages.appendChild(div);
    }

    async function handleChatSubmit(e) {
        e.preventDefault();
        const input = document.getElementById('chatInput');
        if (!input) {
            return;
        }
        
        const message = input.value.trim();
        
        if (!message) return;

        // Add User Message INLINE (bypass function call issue)
        const chatMessages = document.getElementById('chatMessages');
        if (!chatMessages) {
            return;
        }
        
        // Create user message element directly
        const userDiv = document.createElement('div');
        userDiv.className = 'flex gap-3 chat-bubble flex-row-reverse';
        userDiv.style.opacity = '1';
        userDiv.innerHTML = 
            '<div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center text-gray-500 shrink-0 text-xs">나</div>' +
            '<div class="bg-indigo-600 text-white p-3 rounded-2xl rounded-tr-none shadow-sm text-sm max-w-[85%] break-words">' +
                message +
            '</div>';
        chatMessages.appendChild(userDiv);
        scrollToBottom();
        
        input.value = '';
        
        // Show Loading Bubble
        const loadingId = addLoadingMessage();

        try {
            const response = await fetch(FLASK_SERVER_URL, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ query: message }),
            });

            const data = await response.json();
            removeMessage(loadingId);
            
            if (data.length > 0) {
                addBotResponse(data);
            } else {
                appendChatMessage("죄송합니다, 추천할 만한 책을 찾지 못했어요. 😢 다른 키워드로 다시 물어봐주세요!", 'bot');
            }

        } catch (error) {
            removeMessage(loadingId);
            appendChatMessage("서버 연결에 실패했습니다. 관리자에게 문의해주세요. ⚠️", 'bot');
        }
    }

    function appendChatMessage(text, sender) {
        const chatMessages = document.getElementById('chatMessages');
        if (!chatMessages) {
            return;
        }
        
        const div = document.createElement('div');
        // Ensure flex-row-reverse is correct for user
        const directionClass = (sender === 'user') ? 'flex-row-reverse' : '';
        div.className = 'flex gap-3 chat-bubble ' + directionClass;
        
        // Remove opacity-0 if popIn animation fails or isn't desired for instant feedback
        div.style.opacity = '1'; 
        
        const avatar = sender === 'bot' 
            ? '<div class="w-8 h-8 rounded-full bg-gradient-to-br from-indigo-500 to-purple-500 flex items-center justify-center text-white shrink-0 shadow-sm text-xs">AI</div>'
            : '<div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center text-gray-500 shrink-0 text-xs">나</div>';
            
        const bubbleColor = sender === 'bot' ? 'bg-white text-gray-700 border border-gray-100' : 'bg-indigo-600 text-white';
        const rounded = sender === 'bot' ? 'rounded-tl-none' : 'rounded-tr-none';
        
        div.innerHTML = `
            ${avatar}
            <div class="${bubbleColor} p-3 rounded-2xl ${rounded} shadow-sm text-sm max-w-[85%] break-words">
                ${text}
            </div>
        `;
        
        chatMessages.appendChild(div);
        scrollToBottom();
    }

    function addBotResponse(books) {
        const chatMessages = document.getElementById('chatMessages');
        const div = document.createElement('div');
        div.className = 'flex gap-3 chat-bubble';
        
        // Build book HTML
        let booksHtml = '';
        books.forEach(book => {

            booksHtml += '<div class="flex gap-3 p-2 hover:bg-gray-50 rounded-lg transition-colors cursor-pointer group border-b border-gray-100 last:border-0 relative overflow-hidden">';
            booksHtml += '  <div class="relative w-12 h-16 bg-gray-200 rounded shrink-0 overflow-hidden shadow-sm group-hover:shadow-md transition-all">';
            // Image
            booksHtml += '    <img src="' + book.cover_image + '" alt="' + book.title + '" class="w-full h-full object-cover transition-transform duration-500" onerror="this.src=\'https://via.placeholder.com/60x80?text=No+Img\'">';
            booksHtml += '  </div>';
            booksHtml += '  <div class="flex-1 min-w-0">';
            booksHtml += '    <h4 class="font-bold text-gray-900 group-hover:text-indigo-600 truncate text-sm transition-colors">' + book.title + '</h4>';
            booksHtml += '    <p class="text-xs text-gray-500 mt-1 line-clamp-2 leading-relaxed">' + book.synopsis + '</p>';
            booksHtml += '  </div>';
            
            // Overlay Button
            booksHtml += '  <div class="absolute inset-0 bg-white/90 opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-center justify-center backdrop-blur-[1px]">';
            booksHtml += '      <a href="detail.jsp?id=' + book.isbn + '" class="px-3 py-1.5 bg-indigo-600 text-white text-xs font-bold rounded-full shadow-lg transform scale-90 group-hover:scale-100 transition-all hover:bg-indigo-700 flex items-center gap-1">';
            booksHtml += '          <span>상세보기</span>';
            booksHtml += '          <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>';
            booksHtml += '      </a>';
            booksHtml += '  </div>';
            booksHtml += '</div>';
        });

        div.innerHTML = `
            <div class="w-8 h-8 rounded-full bg-gradient-to-br from-indigo-500 to-purple-500 flex items-center justify-center text-white shrink-0 shadow-sm text-xs">AI</div>
            <div class="bg-white p-2 rounded-2xl rounded-tl-none shadow-sm text-sm text-gray-700 max-w-[90%] border border-gray-100 w-full">
                <p class="mb-2 px-2 pt-1 font-medium text-indigo-900">이런 책들은 어떠세요? 📚</p>
                <div class="space-y-1">
                    ` + booksHtml + `
                </div>
            </div>
        `;
        
        chatMessages.appendChild(div);
        scrollToBottom();
    }

    function addLoadingMessage() {
        const chatMessages = document.getElementById('chatMessages');
        const id = 'loading-' + Date.now();
        const div = document.createElement('div');
        div.id = id;
        div.className = 'flex gap-3 chat-bubble';
        div.innerHTML = `
            <div class="w-8 h-8 rounded-full bg-gradient-to-br from-indigo-500 to-purple-500 flex items-center justify-center text-white shrink-0 shadow-sm text-xs">AI</div>
                <div class="bg-white p-3 rounded-2xl rounded-tl-none shadow-sm text-sm text-gray-500 border border-gray-100 flex gap-1 items-center">
                <span class="w-2 h-2 bg-indigo-400 rounded-full animate-bounce"></span>
                <span class="w-2 h-2 bg-indigo-400 rounded-full animate-bounce" style="animation-delay: 0.1s"></span>
                <span class="w-2 h-2 bg-indigo-400 rounded-full animate-bounce" style="animation-delay: 0.2s"></span>
            </div>
        `;
        chatMessages.appendChild(div);
        scrollToBottom();
        return id;
    }

    function removeMessage(id) {
        const el = document.getElementById(id);
        if (el) el.remove();
    }

    function scrollToBottom() {
        const chatMessages = document.getElementById('chatMessages');
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }
</script>
