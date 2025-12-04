# BookSearchApp v3

도서 검색 및 관리 시스템 - JSP 기반 웹 애플리케이션

## 📚 프로젝트 개요

- **BookSearchApp v1** : 메인페이지 하드 코딩
- **BookSearchApp v2** : 도서 검색, 회원 관리, 관리자 기능 (MVC 패턴 적용)
- **BookSearchApp v3** : **책DB 연동, 리뷰 시스템 구현**

사용자는 도서를 검색하고 리뷰를 작성할 수 있으며, 관리자는 회원과 도서를 관리할 수 있습니다.

### v3 주요 변경 사항

- 🛡️ **책 DB 연동 **: `detail.jsp`로 접근했던 리뷰와 책 정보를 BookDAO와 ReviewDAO로 연동
- 📝 **리뷰 시스템**: 도서 리뷰 작성 및 조회 기능 구현 (`ReviewDAO`, `ReviewDTO`)

---

## 🏗️ 프로젝트 구조

```
bookSearchApp/
├── db.properties              # [NEW] DB 설정 파일 (gitignore 적용)
├── src/main/
│   ├── java/com/book/
│   │   ├── controller/        # 서블릿 (비즈니스 로직)
│   │   ├── dao/               # 데이터베이스 액세스 (UserDAO, ReviewDAO)
│   │   ├── dto/               # 데이터 전송 객체 (UserDTO, ReviewDTO)
│   │   ├── filter/            # [NEW] 보안 필터 (AuthFilter)
│   │   └── util/              # 유틸리티 (DB 연결 - 설정 파일 로드)
│   └── webapp/                # JSP 페이지 (뷰)
│       ├── index.jsp          # 메인 페이지
│       ├── login.jsp          # 로그인
│       ├── signup.jsp         # 회원가입
│       ├── mypage.jsp         # 마이페이지
│       ├── admin.jsp          # 관리자 대시보드
│       ├── header.jsp         # 공통 헤더
│       └── ...
└── build/                     # 컴파일된 클래스
```

---

## ⚙️ 설정 및 실행 (Configuration)

### 1. 데이터베이스 설정 (필수)

아래 내용을 복사하여 본인의 DB 설정에 맞게 수정합니다.

````
HOST=localhost
PORT=3306
DB_NAME=book_db
USER=root
PASS=your_password


### 2. 데이터베이스 테이블 추가

리뷰 기능을 위해 `리뷰` 테이블이 필요합니다.

```sql
CREATE TABLE 리뷰 (
    리뷰id INT PRIMARY KEY AUTO_INCREMENT,
    책id VARCHAR(20) NOT NULL,
    사용자id VARCHAR(16) NOT NULL,
    리뷰내용 TEXT,
    리뷰점수 INT,
    작성일 TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (사용자id) REFERENCES 사용자(사용자id)
);
````

---

## 📄 주요 기능 설명

### 1. 보안 시스템 (Security)

- **AuthFilter**: `/mypage.jsp`, `/admin.jsp` 등 로그인이 필요한 페이지 접근 시 필터가 세션을 확인하고, 비로그인 시 로그인 페이지로 리다이렉트합니다.

### 2. 리뷰 시스템 (Review)

- **리뷰 작성**: 사용자는 도서 상세 페이지에서 평점과 내용을 입력하여 리뷰를 등록할 수 있습니다.
- **리뷰 조회**: 도서별 리뷰 목록과 내 리뷰 목록(마이페이지)을 조회할 수 있습니다.

### 3. 기존 기능 (v2 계승)

- **회원 관리**: 회원가입, 로그인, 정보 수정, 탈퇴, 관리자 기능 (회원 추방 등)
- **도서 검색**: 카테고리별, 평점별 필터링 및 정렬

---

## 📚 추가 개선 사항

### 향후 계획

**index.jsp**

- 카테고리 보여주기
- 책 표지 비어있는거 채우기  
  지구 끝의 온실, 불편한 편의점, 구의 증명,  
  아몬드, 시대 예보, 난생 처음 한번...,  
  윤리학과 철학의 한계, 그림의 힘, 지적 대화  
  역사란 무엇인가 , 징비록, 총 11권

**detail.jsp**

- 리뷰 작성 = ture 책이면 작성한 리뷰 내용(점수, 리뷰글)을 가져오고 리뷰 작성버튼을 리뷰 수정 버튼으로 변경
- 별을 drop down 선택에서 rate로 변경
- ebook 여부 알려주는 요소 추가
- 해당 책의 pdf나 ehub가 있으면(drm 없는 ehub 한정) 업로드하여 오디오북으로 만들어주는 기능
- 리뷰점수가 데이터베이스에 반영되도록 수정 

**mypage.jsp**

- removeFromLibrary 아직 추가 안한거 작성하기
- 리뷰관리에서 수정, 삭제 기능 추가하기

**admin**

- 통계 보기, 설정에 추가하거나 삭제하기
- admin은 도서 상세 정보에 들어가면 리뷰 목록에서 사용자 리뷰 삭제 가능

**아이디어**

- admin이 사용자에게 메시지 보내기 (광고, 리뷰 경고 및 삭제 알림 )

---

## 👥 개발자 정보

- **프로젝트명**: BookSearchApp v3
- **기술 스택**: JSP, Servlet, JDBC, MySQL, Tailwind CSS
- **패턴**: MVC (Model-View-Controller) + Filter

---

**마지막 업데이트**: 2025-12-02
