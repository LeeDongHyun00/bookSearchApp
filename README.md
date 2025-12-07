# BookSearchApp v3.1 (Feature: Chatbot & Audiobook)

도서 검색 및 관리 시스템 - JSP 기반 웹 애플리케이션 (AI Chatbot & TTS Integrated)

## 📚 프로젝트 개요

- **BookSearchApp v1** : 메인페이지 하드 코딩
- **BookSearchApp v2** : 도서 검색, 회원 관리, 관리자 기능 (MVC 패턴 적용)
- **BookSearchApp v3** : 책 DB 연동, 리뷰 시스템 구현
- **BookSearchApp v3.1 (Current)** : **AI 도서 추천 챗봇, 오디오북(TTS) 변환 기능 추가, DB 설정 분리**

사용자는 도서를 검색하고 리뷰를 작성할 수 있으며, AI 챗봇에게 책을 추천받거나 소장한 텍스트 파일을 오디오북으로 즐길 수 있습니다.

### v3.1 주요 변경 사항 (feature_chatbot)

- 🤖 **AI 도서 추천 챗봇**: `chatbot.jsp` 모듈화. Python Flask 기반 추천 서비스와 연동하여 사용자의 질문에 맞는 도서를 추천합니다.
- 🎧 **오디오북 변환기**: `audiobook.jsp` 모듈화. EPUB/PDF 텍스트를 추출하여 웹 브라우저 TTS(Text-to-Speech)로 읽어주는 오버레이 인터페이스를 제공합니다.
- ⚙️ **DB 설정 분리**: 보안 강화를 위해 데이터베이스 연결 정보를 코드에서 분리하여 `db.properties` 파일로 관리합니다.

---

## 🏗️ 프로젝트 구조

```
bookSearchApp/
├── src/main/
│   ├── java/com/book/
│   │   ├── controller/        # 서블릿 (비즈니스 로직)
│   │   ├── dao/               # 데이터베이스 액세스 (BookDAO, ReviewDAO 등)
│   │   ├── dto/               # 데이터 전송 객체
│   │   ├── filter/            # 보안 필터 (AuthFilter)
│   │   └── util/              # 유틸리티 (DBUtil - Properties 로드)
│   └── resources/
│       └── db.properties      # [NEW] DB 설정 파일
│   └── webapp/                # JSP 페이지 (뷰)
│       ├── index.jsp          # 메인 페이지 (Audiobook 포함)
│       ├── header.jsp         # 헤더 (Chatbot 포함)
│       ├── chatbot.jsp        # [NEW] 챗봇 UI 모듈
│       ├── audiobook.jsp      # [NEW] 오디오북 UI 모듈
│       └── ...
└── recommendation_service/    # [NEW] Python Flask 추천 서버
    ├── app.py                 # 추천 알고리즘 및 API
    └── requirements.txt       # Python 의존성
```

---

## ⚙️ 설정 및 실행 (Configuration)

### 1. 데이터베이스 설정 (필수)

소스 코드 내에 DB 정보가 포함되지 않으므로, `src/main/resources/db.properties` 파일을 생성하여 아래와 같이 설정해야 합니다.

**`src/main/resources/db.properties`**

```properties
HOST=YOUR_HOST
PORT=YOUR_PORT
DB_NAME=YOUR_DB_NAME
USER=YOUR_ID
PASS=YOUR_PASSWORD
```

**참고 (Java Code Variable Mapping)**

```java
private static final String HOST = "YOUR_LOCAH_HOST";
private static final String PORT = "YOUR_PORT";
private static final String DB_NAME = "YOUT_DB_NAME";
private static final String USER = "YOUR_ID";
private static final String PASS = "YOUR_PASSWORD";
```

### 2. Python 추천 서버 실행

챗봇 기능을 사용하기 위해서는 Flask 서버가 실행되어야 합니다.

```bash
cd bookSearchApp/recommendation_service
pip install -r requirements.txt
python app.py
```

---

## 📄 주요 기능 설명

### 1. AI 챗봇 (Chatbot)

- 헤더의 **"AI 추천"** 버튼을 통해 접근 가능합니다.
- 사용자가 "슬픈 때 읽기 좋은 책 추천해줘"와 같이 입력하면, TF-IDF 및 코사인 유사도(또는 Nearest Neighbors) 알고리즘을 통해 DB 내 가장 적절한 책을 추천합니다.

### 2. 오디오북 (Audiobook)

- 메인 페이지의 **"오디오북으로 변환하기"** 버튼으로 실행합니다 (다크 모드 전환).
- PDF/EPUB 파일을 업로드하면 텍스트를 추출하여 읽어줍니다.
- 배속 조절, 문단 클릭 이동, 예시 파일 로드 기능 제공.

### 3. 기존 기능

- **회원 관리 & 보안**: AuthFilter를 통한 접근 제어
- **도서 검색 & 리뷰**: 카테고리/평점에 따른 필터링, 상세 리뷰 작성

---

## 👥 개발자 정보

- **프로젝트명**: BookSearchApp v3.1
- **Branch**: `feature_chatbot`
- **기술 스택**: JSP, Servlet, MySQL, Python(Flask), Tailwind CSS

---

**마지막 업데이트**: 2025-12-07
