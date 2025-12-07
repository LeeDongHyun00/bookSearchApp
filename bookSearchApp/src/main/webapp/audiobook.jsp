<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Audiobook Overlay -->
<div id="audiobookOverlay" class="fixed inset-0 bg-black z-40 h-0 transition-[height] duration-1000 ease-in-out overflow-hidden">
    <div class="container mx-auto px-4 h-full flex items-center justify-center relative">
        <!-- Content Box -->
        <div id="uploadBox" class="bg-gray-900 border border-gray-700 rounded-3xl p-8 w-full max-w-4xl opacity-0 transition-opacity duration-500 delay-500 flex flex-col h-[80vh]">
            <!-- Header -->
            <div class="flex flex-wrap justify-between items-center mb-6 md:flex-nowrap">
                <h2 class="text-2xl font-bold text-white my-2">오디오북 변환</h2>
                <div class="flex flex-wrap md:flex-nowrap gap-3">
                    <button id="exampleFileBtn" onclick="loadExampleFile()" class="px-4 py-2 bg-gray-700 text-white rounded-full font-medium hover:bg-gray-600 transition-colors text-sm">
                        예시 파일 - 메밀꽃 필 무렵
                    </button>
                    <button id="actionButton" class="px-6 py-2 bg-white text-black rounded-full font-bold hover:bg-gray-200 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                        변환하기
                    </button>
                </div>
            </div>

            <!-- Progress Bar -->
            <div id="progressContainer" class="mb-4 hidden">
                <div class="text-xs text-gray-400 mb-1 font-mono">
                    <span id="progressCurrent">0</span> /
                    <span id="progressTotal">0</span>
                </div>
                <progress id="readingProgress" value="0" max="100" class="w-full h-2 rounded-lg overflow-hidden cursor-pointer"></progress>
            </div>

            <!-- Upload Area -->
            <div id="dropZone" class="flex-1 border-2 border-dashed border-gray-700 rounded-2xl flex flex-col items-center justify-center text-gray-400 hover:border-gray-500 hover:bg-gray-800/50 transition-all cursor-pointer relative overflow-hidden min-h-0">
                <input type="file" id="fileInput" accept=".pdf,.epub" class="absolute inset-0 w-full h-full opacity-0 cursor-pointer">
                
                <!-- Initial State -->
                <div id="uploadPlaceholder" class="text-center p-8 w-full flex flex-col items-center justify-center h-full">
                    <div id="uploadContent">
                        <svg class="w-16 h-16 mx-auto mb-4 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path>
                        </svg>
                        <p class="text-xl font-medium text-gray-300 mb-2">PDF or EPUB 파일을 여기로 드래그하세요</p>
                        <p class="text-sm text-gray-500">혹은 클릭해서 업로드하세요</p>
                    </div>
                    <p id="fileNameDisplay" class="mt-6 text-xl text-white font-bold hidden bg-gray-800 px-6 py-3 rounded-xl shadow-lg border border-gray-700"></p>
                </div>

                <!-- Loading State -->
                <div id="loadingState" class="hidden text-center">
                    <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-white mx-auto mb-4"></div>
                    <p class="text-white">Processing file...</p>
                </div>

                <!-- Result State (Text Display) -->
                <div id="resultDisplay" class="hidden w-full h-full p-8 overflow-y-auto bg-gray-800 text-gray-300 font-serif leading-relaxed text-lg whitespace-pre-wrap text-left rounded-xl shadow-inner custom-scrollbar relative z-10"></div>
            </div>

            <!-- Audio Controls -->
            <div id="audioControls" class="mt-6 flex flex-col items-center hidden gap-4">
                <div class="flex items-center gap-6">
                    <!-- Speed Control -->
                    <div class="flex items-center gap-2">
                        <span class="text-gray-400 text-xs font-bold">SPEED</span>
                        <select id="speedSelect" class="bg-gray-800 text-white border border-gray-600 rounded-lg px-2 py-1 focus:outline-none focus:border-primary text-sm cursor-pointer hover:bg-gray-700 transition-colors">
                            <option value="0.5">0.5x</option>
                            <option value="0.75">0.75x</option>
                            <option value="1.0" selected>1.0x</option>
                            <option value="1.25">1.25x</option>
                            <option value="1.5">1.5x</option>
                        </select>
                    </div>

                    <button id="ttsPlayButton" class="w-16 h-16 bg-white rounded-full flex items-center justify-center hover:bg-gray-200 transition-all shadow-lg hover:scale-105 active:scale-95 group">
                        <!-- Play Icon -->
                        <svg id="iconPlay" class="w-8 h-8 text-black ml-1" fill="currentColor" viewBox="0 0 24 24"><path d="M8 5v14l11-7z"/></svg>
                        <!-- Stop/Pause Icon -->
                        <svg id="iconStop" class="w-8 h-8 text-black hidden" fill="currentColor" viewBox="0 0 24 24"><path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/></svg>
                    </button>
                    
                    <!-- Placeholder for symmetry or future controls -->
                    <div class="w-[86px]"></div> 
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    /* Custom Scrollbar for Result Display */
    .custom-scrollbar::-webkit-scrollbar {
        width: 10px;
    }
    .custom-scrollbar::-webkit-scrollbar-track {
        background: #1f2937; /* gray-800 */
        border-radius: 0 0 12px 0;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb {
        background: #4b5563; /* gray-600 */
        border-radius: 5px;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb:hover {
        background: #6b7280; /* gray-500 */
    }
    
    /* Reading Highlight - Improved Visibility */
    .reading-active {
        background-color: rgba(251, 191, 36, 0.15); /* Yellow tint */
        border-left: 4px solid #fbbf24; /* Yellow accent border */
        color: #ffffff;
        padding: 12px 16px;
        margin: 0 -8px; /* Negative margin to expand slightly */
        border-radius: 4px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.2);
        transform: scale(1.01);
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }
    
    /* Paragraph Hover Effect */
    #resultDisplay p:hover {
        background-color: rgba(255, 255, 255, 0.05);
        cursor: pointer;
        border-radius: 4px;
    }
    
    /* Progress Bar Styling */
    progress {
        -webkit-appearance: none;
        appearance: none;
    }
    progress::-webkit-progress-bar {
        background-color: #374151; /* gray-700 */
        border-radius: 8px;
    }
    progress::-webkit-progress-value {
        background-color: #3b82f6; /* primary blue */
        border-radius: 8px;
        transition: width 0.3s ease;
    }
    progress::-moz-progress-bar {
        background-color: #3b82f6;
        border-radius: 8px;
    }
</style>

<!-- Scripts for Audiobook processing -->
<script>
    const overlay = document.getElementById('audiobookOverlay');
    const uploadBox = document.getElementById('uploadBox');
    const searchContainer = document.getElementById('searchContainer'); // Correct ID from header.jsp
    const headerLogo = document.getElementById('headerLogo');
    const fileInput = document.getElementById('fileInput');
    const actionButton = document.getElementById('actionButton');
    const fileNameDisplay = document.getElementById('fileNameDisplay');
    const uploadPlaceholder = document.getElementById('uploadPlaceholder');
    const uploadContent = document.getElementById('uploadContent');
    const loadingState = document.getElementById('loadingState');
    const resultDisplay = document.getElementById('resultDisplay');
    const dropZone = document.getElementById('dropZone');
    
    // TTS Elements
    const progressContainer = document.getElementById('progressContainer');
    const readingProgress = document.getElementById('readingProgress');
    const progressCurrent = document.getElementById('progressCurrent');
    const progressTotal = document.getElementById('progressTotal');
    const audioControls = document.getElementById('audioControls');
    const ttsPlayButton = document.getElementById('ttsPlayButton');
    const iconPlay = document.getElementById('iconPlay');
    const iconStop = document.getElementById('iconStop');
    const speedSelect = document.getElementById('speedSelect');

    let currentFile = null;
    let isConverted = false;
    
    // TTS State
    let ttsUtterance = null;
    let currentParagraphIndex = 0;
    let isReading = false;
    let isPaused = false;
    let isChangingSettings = false;
    let playbackRate = 1.0;
    let paragraphs = [];

    // Header Elements for Dark Mode
    const nav = document.querySelector('nav');
    const logoText = document.querySelector('#headerLogo span.text-gray-900');
    const userGreeting = document.querySelector('.flex.items-center.gap-4 > span.text-gray-700');
    const navLinks = document.querySelectorAll('.flex.items-center.gap-4 > a.text-gray-700');
    
    // Initialize transition
    if(nav) {
        nav.classList.add('transition-opacity', 'duration-300');
    }

    // Logo click handler - close AudioBook mode if active
    if(headerLogo) {
        headerLogo.addEventListener('click', (e) => {
            // Check if overlay is open (height is 100%)
            if(overlay && overlay.style.height === '100%') {
                e.preventDefault();
                closeAudiobookMode(e);
            }
            // Otherwise let normal navigation happen
        });
    }

    // Open Audiobook Mode
    function openAudiobookMode() {
        overlay.style.height = '100%';
        uploadBox.classList.remove('opacity-0');
        
        // Hide Search/Chat Container
        if(searchContainer) {
            searchContainer.classList.add('opacity-0', 'pointer-events-none', 'hidden');
            // Also ensure standard search is hidden if transitioning
        }
        
        document.body.style.overflow = 'hidden'; // Prevent scrolling
        
        // Header Transition
        if(nav) {
            nav.style.opacity = '0';
            
            setTimeout(() => {
                // Apply Dark Mode Classes
                nav.classList.remove('bg-white', 'shadow-sm');
                nav.classList.add('bg-black', 'border-b', 'border-gray-800');
                
                if(logoText) {
                    logoText.classList.remove('text-gray-900');
                    logoText.classList.add('text-white');
                }
                if(userGreeting) {
                    userGreeting.classList.remove('text-gray-700');
                    userGreeting.classList.add('text-gray-300');
                }
                navLinks.forEach(link => {
                    link.classList.remove('text-gray-700');
                    link.classList.add('text-gray-300', 'hover:text-white');
                });
                
                // Fade In
                nav.style.opacity = '1';
            }, 300);
        }
    }

    // Close Audiobook Mode
    function closeAudiobookMode(e) {
        if (e) e.preventDefault();
        stopTTS(); // Stop audio when closing
        overlay.style.height = '0';
        uploadBox.classList.add('opacity-0');
        
        // Restore Search/Chat Container
        if(searchContainer) {
            searchContainer.classList.remove('opacity-0', 'pointer-events-none','hidden');
        }
        
        document.body.style.overflow = ''; // Restore scrolling
        
        // Header Transition
        if(nav) {
            nav.style.opacity = '0';
            
            setTimeout(() => {
                // Revert to Light Mode
                nav.classList.add('bg-white', 'shadow-sm');
                nav.classList.remove('bg-black', 'border-b', 'border-gray-800');
                
                if(logoText) {
                    logoText.classList.add('text-gray-900');
                    logoText.classList.remove('text-white');
                }
                if(userGreeting) {
                    userGreeting.classList.add('text-gray-700');
                    userGreeting.classList.remove('text-gray-300');
                }
                navLinks.forEach(link => {
                    link.classList.add('text-gray-700');
                    link.classList.remove('text-gray-300', 'hover:text-white');
                });
                
                // Fade In
                nav.style.opacity = '1';
            }, 300);
        }
        
        // Reset state after transition
        setTimeout(() => {
            resetInterface();
        }, 1000);
    }

    // Reset Interface
    function resetInterface() {
        currentFile = null;
        isConverted = false;
        stopTTS();
        
        fileInput.value = '';
        fileInput.disabled = false; // Re-enable input
        dropZone.classList.remove('pointer-events-none'); // Re-enable clicks
        
        fileNameDisplay.textContent = '';
        fileNameDisplay.classList.add('hidden');
        uploadContent.classList.remove('hidden');
        uploadPlaceholder.classList.remove('hidden');
        loadingState.classList.add('hidden');
        resultDisplay.classList.add('hidden');
        resultDisplay.innerHTML = ''; // Clear HTML
        
        progressContainer.classList.add('hidden');
        progressCurrent.textContent = '0';
        progressTotal.textContent = '0';
        readingProgress.value = 0;
        audioControls.classList.add('hidden');
        
        actionButton.textContent = '변환하기';
        actionButton.classList.remove('bg-red-500', 'text-white', 'hover:bg-red-600');
        actionButton.classList.add('bg-white', 'text-black', 'hover:bg-gray-200');
        
        // Reset example button if it exists
        const exampleBtn = document.getElementById('exampleFileBtn');
        if(exampleBtn) exampleBtn.classList.remove('hidden');
    }
    
    // Load Example File
    async function loadExampleFile() {
        try {
            const response = await fetch('When_Buckwheat_Flowers_Bloom.pdf');
            if (!response.ok) throw new Error('File not found');
            
            const blob = await response.blob();
            currentFile = new File([blob], "When_Buckwheat_Flowers_Bloom.pdf", { type: "application/pdf" });
            
            // Update UI
            fileNameDisplay.textContent = currentFile.name;
            fileNameDisplay.classList.remove('hidden');
            fileNameDisplay.classList.remove('text-primary');
            fileNameDisplay.classList.add('text-white');
            uploadContent.classList.add('hidden');
            
        } catch (e) {
            console.error(e);
            alert('예시 파일을 불러오는데 실패했습니다.');
        }
    }

    // File Selection
    fileInput.addEventListener('change', (e) => {
        if (e.target.files.length > 0) {
            currentFile = e.target.files[0];
            fileNameDisplay.textContent = currentFile.name;
            fileNameDisplay.classList.remove('hidden');
            // Change file name color to white as requested
            fileNameDisplay.classList.remove('text-primary');
            fileNameDisplay.classList.add('text-white');
            
            uploadContent.classList.add('hidden'); // Hide icon and text
        }
    });

    // Action Button Click
    actionButton.addEventListener('click', async () => {
        if (isConverted) {
            // Remove File Mode
            resetInterface();
        } else {
            // Convert Mode
            if (!currentFile) {
                alert('Please select a file first.');
                return;
            }
            
            await convertFile();
        }
    });

    // Convert Logic
    async function convertFile() {
        // Check file size (50MB limit)
        const maxSize = 50 * 1024 * 1024; // 50MB in bytes
        if (currentFile.size > maxSize) {
            alert('File size exceeds 50MB. Please upload a smaller file.');
            return;
        }

        uploadPlaceholder.classList.add('hidden');
        loadingState.classList.remove('hidden');
        actionButton.disabled = true;
        
        // Hide example button
        const exampleBtn = document.getElementById('exampleFileBtn');
        if(exampleBtn) exampleBtn.classList.add('hidden');
        
        // Disable file input interaction
        fileInput.disabled = true;
        dropZone.classList.add('pointer-events-none');

        const formData = new FormData();
        formData.append('file', currentFile);

        try {
            const response = await fetch('convertAudiobook', {
                method: 'POST',
                body: formData
            });

            if (!response.ok) {
                throw new Error(await response.text());
            }

            const text = await response.text();

            // Success
            loadingState.classList.add('hidden');
            resultDisplay.classList.remove('hidden');
            
            // Parse text into paragraphs
            renderText(text);
            
            // Show TTS Controls
            progressContainer.classList.remove('hidden');
            audioControls.classList.remove('hidden');
            
            // Re-enable pointer events for scrolling
            dropZone.classList.remove('pointer-events-none');
            
            // Switch button state
            isConverted = true;
            actionButton.textContent = 'Remove File';
            actionButton.classList.remove('bg-white', 'text-black', 'hover:bg-gray-200');
            actionButton.classList.add('bg-red-500', 'text-white', 'hover:bg-red-600');

        } catch (error) {
            console.error(error);
            alert('Error converting file: ' + error.message);
            resetInterface();
        } finally {
            actionButton.disabled = false;
        }
    }
    
    // Render Text as Paragraphs
    function renderText(text) {
        resultDisplay.innerHTML = '';
        // Split by double newlines or single newlines depending on format
        const lines = text.split(/\n\n+/);
        
        lines.forEach((line, index) => {
            if (line.trim().length > 0) {
                const p = document.createElement('p');
                p.textContent = line;
                p.className = 'mb-4 leading-relaxed transition-all duration-300 p-1';
                p.id = 'p-' + index;
                
                // Click to play
                p.addEventListener('click', () => {
                    // If we click the same paragraph, do nothing or maybe pause? 
                    // Let's just play from there.
                    isChangingSettings = true;
                    window.speechSynthesis.cancel();
                    setTimeout(() => {
                        isChangingSettings = false;
                        speakParagraph(index);
                        isReading = true;
                        isPaused = false;
                        updatePlayButton(true);
                    }, 50);
                });
                
                resultDisplay.appendChild(p);
            }
        });
        
        // Update paragraphs list
        paragraphs = resultDisplay.querySelectorAll('p');
        currentParagraphIndex = 0;
        
        // Set progress max
        readingProgress.max = paragraphs.length > 0 ? paragraphs.length - 1 : 0;
        updateProgress(0);
    }

    // TTS Logic
    ttsPlayButton.addEventListener('click', toggleTTS);
    
    // Speed Control Logic
    speedSelect.addEventListener('change', (e) => {
        playbackRate = parseFloat(e.target.value);
        
        // If currently reading, pause TTS (user can resume with new speed)
        if (isReading && !isPaused) {
            window.speechSynthesis.cancel();
            isReading = false;

            isPaused = false; 
            updatePlayButton(false);
        }
    });
    
    // Progress Bar Click Logic (Seek)
    readingProgress.addEventListener('click', (e) => {
        const rect = readingProgress.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const width = rect.width;
        const max = readingProgress.max;
        
        // Calculate new index
        const newIndex = Math.round((x / width) * max);
        
        // If reading, jump to that paragraph
        isChangingSettings = true;
        window.speechSynthesis.cancel();
        
        setTimeout(() => {
            isChangingSettings = false;
            currentParagraphIndex = newIndex;
            
            if (isReading && !isPaused) {
                speakParagraph(newIndex);
            } else {
                // Just highlight if paused/stopped
                removeHighlight();
                const p = paragraphs[newIndex];
                if(p) {
                    p.classList.add('reading-active');
                    p.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
                updateProgress(newIndex);
            }
        }, 100);
    });

    function toggleTTS() {
        if (isReading) {
            // Pause
            window.speechSynthesis.pause();
            isReading = false;
            isPaused = true;
            updatePlayButton(false);
        } else {
            // Play
            if (isPaused) {
                window.speechSynthesis.resume();
            } else {
                speakParagraph(currentParagraphIndex);
            }
            isReading = true;
            isPaused = false;
            updatePlayButton(true);
        }
    }
    
    function stopTTS() {
        window.speechSynthesis.cancel();
        isReading = false;
        isPaused = false;
        isChangingSettings = false;
        currentParagraphIndex = 0;
        updatePlayButton(false);
        updateProgress(0);
        removeHighlight();
    }

    function speakParagraph(index) {
        if (index >= paragraphs.length) {
            // Finished reading
            stopTTS();
            return;
        }

        currentParagraphIndex = index;
        updateProgress(index);
        
        // Highlight current paragraph
        removeHighlight();
        const p = paragraphs[index];
        p.classList.add('reading-active');
        
        // Auto-scroll to current paragraph
        p.scrollIntoView({ behavior: 'smooth', block: 'center' });

        const text = p.textContent;
        ttsUtterance = new SpeechSynthesisUtterance(text);
        ttsUtterance.rate = playbackRate;
        
        // Optional: Detect language or default to Korean/English
        // ttsUtterance.lang = 'ko-KR'; 

        ttsUtterance.onend = () => {
            // Only proceed if we weren't cancelled/paused manually or changing settings
            if (isChangingSettings) return;
            
            if (isReading && !isPaused) {
                speakParagraph(index + 1);
            }
        };
        
        ttsUtterance.onerror = (e) => {
            // Ignore 'interrupted' errors (caused by speed changes or manual stops)
            if (e.error === 'interrupted') {
                return; // Silently ignore
            }
            
            console.error('TTS Error:', e);
            stopTTS();
        };

        window.speechSynthesis.speak(ttsUtterance);
    }
    
    function updatePlayButton(isPlaying) {
        if (isPlaying) {
            iconPlay.classList.add('hidden');
            iconStop.classList.remove('hidden');
        } else {
            iconPlay.classList.remove('hidden');
            iconStop.classList.add('hidden');
        }
    }
    
    function updateProgress(index) {
        if (paragraphs.length === 0) {
            progressCurrent.textContent = '0';
            progressTotal.textContent = '0';
            readingProgress.value = 0;
            return;
        }
        progressCurrent.textContent = index + 1;
        progressTotal.textContent = paragraphs.length;
        readingProgress.value = index;
    }
    
    function removeHighlight() {
        const active = resultDisplay.querySelector('.reading-active');
        if (active) {
            active.classList.remove('reading-active');
        }
    }
</script>
