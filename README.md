# BookSearchApp v2

도서 검색 및 관리 시스템 - JSP 기반 웹 애플리케이션

## 📚 프로젝트 개요

BookSearchApp v1 : 메인페이지 하드 코딩  
BookSearchApp v2 : 도서 검색, 회원 관리, 관리자 기능을 제공하는 웹 애플리케이션입니다.
사용자는 도서를 검색하고 리뷰를 작성할 수 있으며, 관리자는 회원과 도서를 관리할 수 있습니다.

### 주요 기능

- 🔍 도서 검색 및 필터링 (카테고리, 평점, 정렬)
- 👤 회원가입 및 로그인
- 📖 마이페이지 (내 서재, 회원정보 수정, 리뷰 관리)
- 🔐 관리자 대시보드 (회원 관리, 도서 관리, 통계)
- 🎨 반응형 디자인 (Tailwind CSS)

---

## 🏗️ 프로젝트 구조

```
test2/
├── src/main/
│   ├── java/com/book/
│   │   ├── controller/        # 서블릿 (비즈니스 로직)
│   │   ├── dao/               # 데이터베이스 액세스
│   │   ├── dto/               # 데이터 전송 객체
│   │   └── util/              # 유틸리티 (DB 연결)
│   └── webapp/                # JSP 페이지 (뷰)
│       ├── index.jsp          # 메인 페이지
│       ├── login.jsp          # 로그인
│       ├── signup.jsp         # 회원가입
│       ├── mypage.jsp         # 마이페이지
│       ├── admin.jsp          # 관리자 대시보드
│       ├── adminAddUser.jsp   # 회원 추가
│       ├── adminEditUser.jsp  # 회원 수정
│       ├── header.jsp         # 공통 헤더
│       ├── footer.jsp         # 공통 푸터
│       └── data.jsp           # 모크 데이터
└── build/                     # 컴파일된 클래스
```

---

## 📄 JSP 페이지 설명

### 사용자 페이지

#### `index.jsp` - 메인 페이지

- **기능**: 도서 목록 표시, 검색, 필터링, 정렬
- **주요 기능**:
  - 도서 카드 그리드 레이아웃
  - 카테고리 필터 (소설, 인문, 자기계발)
  - 평점 필터 (3.0+, 4.0+, 4.5+)
  - 정렬 옵션 (기본순, 최신순, 평점순, 리뷰순)
  - 반응형 디자인
- **데이터**: `getMockBooks()` 함수 사용

#### `login.jsp` - 로그인 페이지

- **기능**: 사용자 인증
- **주요 요소**:
  - 아이디/비밀번호 입력
  - 테스트 계정 정보 표시
  - 회원가입 링크
  - 로그인 시 admin → `admin.jsp`, 일반 사용자 → `index.jsp`
- **서블릿**: `/login` (LoginServlet)

#### `signup.jsp` - 회원가입 페이지

- **기능**: 신규 회원 등록
- **주요 요소**:
  - 아이디 중복 확인 (AJAX)
  - 이메일 도메인 선택
  - 비밀번호 유효성 검사
  - 닉네임 입력
- **서블릿**: `/signup` (SignUpServlet)
- **유효성 검사**:
  - 아이디: 영문+숫자 6~16자
  - 비밀번호: 16자 이내

#### `mypage.jsp` - 마이페이지

- **기능**: 사용자 개인 정보 및 활동 관리
- **탭 구조**:
  1. **내 서재** (`tab=library`): 관심 도서 목록
  2. **회원 정보 수정** (`tab=info`): 닉네임, 이메일, 비밀번호 변경
  3. **내 리뷰 관리** (`tab=reviews`): 작성한 리뷰 목록
- **주요 기능**:
  - 회원 탈퇴 (DB에서 삭제)
  - 정보 수정 시 세션 업데이트
- **서블릿**:
  - `/userUpdateInfo` (정보 수정)
  - `/userWithdrawal` (회원 탈퇴)

#### `detail.jsp` - 도서 상세 페이지

- **기능**: 개별 도서의 상세 정보 표시
- **주요 요소**:
  - 도서 커버, 제목, 저자, 출판사
  - 평점 및 리뷰 수
  - 도서 설명
  - 리뷰 목록

### 관리자 페이지

#### `admin.jsp` - 관리자 대시보드

- **접근 권한**: admin 계정만
- **탭 구조**:
  1. **대시보드** (`tab=dashboard`):
     - 통계 카드 (총 사용자, 총 도서, 총 리뷰)
     - 빠른 작업 버튼
  2. **회원 관리** (`tab=users`):
     - 회원 목록 테이블
     - 회원 추가/수정/추방 기능
  3. **도서 관리** (`tab=books`):
     - 도서 목록 테이블
     - 도서 추가/수정/삭제 기능
- **주요 기능**:
  - 회원 추가 → `adminAddUser.jsp`
  - 회원 수정 → `adminEditUser.jsp`
  - 회원 추방 → `banUser()` JS 함수 → `/adminBanUser`
- **보안**: 세션에서 username이 "admin"인지 확인

#### `adminAddUser.jsp` - 회원 추가 페이지

- **접근 권한**: admin 계정만
- **기능**: 관리자가 새 회원 추가
- **주요 요소**:
  - 아이디 중복 확인
  - 이메일 도메인 선택
  - 유효성 검사
- **서블릿**: `/adminAddUser` (AdminAddUserServlet)
- **특징**: 절대 login.jsp로 리다이렉트하지 않음

#### `adminEditUser.jsp` - 회원 수정 페이지

- **접근 권한**: admin 계정만
- **기능**: 기존 회원 정보 수정
- **URL 파라미터**: `?userId=xxx`
- **주요 요소**:
  - 아이디는 수정 불가 (disabled)
  - 닉네임, 이메일 수정
  - 비밀번호 변경 (선택적)
- **서블릿**: `/adminUpdateUser` (AdminUpdateUserServlet)

### 공통 페이지

#### `header.jsp` - 공통 헤더

- **기능**: 모든 페이지에서 사용하는 네비게이션
- **주요 요소**:
  - 로고 (B 아이콘 + BookSearch)
  - 로그인 상태 표시
  - 로그인/로그아웃 버튼
  - 관리자 버튼 (admin인 경우)
- **세션 사용**: username, nickname 표시

#### `footer.jsp` - 공통 푸터

- **기능**: 페이지 하단 정보

#### `data.jsp` - 모크 데이터

- **기능**: 테스트용 도서 데이터 제공
- **함수**: `getMockBooks()` - 도서 목록 반환
- **Book 클래스**: id, title, author, category, rating, reviewCount, publishDate, coverImage

#### `logout.jsp` - 로그아웃

- **기능**: 세션 무효화 및 메인 페이지로 리다이렉트

---

## 🔌 서블릿 설명

### 인증 관련 서블릿

#### `LoginServlet.java` (`/login`)

- **기능**: 사용자 로그인 처리
- **메서드**: POST
- **파라미터**: username, password
- **동작**:
  1. UserDAO.login() 호출
  2. 성공 시 세션에 username, nickname, email 저장
  3. admin → `admin.jsp`, 일반 사용자 → `index.jsp`
  4. 실패 시 에러 메시지 표시

#### `SignUpServlet.java` (`/signup`)

- **기능**: 일반 회원가입 처리
- **메서드**: POST
- **파라미터**: userId, password, email, nickname
- **동작**:
  1. UserDAO.insertUser() 호출
  2. 성공 시 `login.jsp`로 리다이렉트
  3. 실패 시 에러 메시지 표시

### 관리자 전용 서블릿

#### `AdminAddUserServlet.java` (`/adminAddUser`)

- **기능**: 관리자가 새 회원 추가
- **메서드**: POST
- **보안**: admin 권한 체크
- **파라미터**: userId, password, email, nickname
- **동작**:
  1. 세션에서 admin 확인
  2. UserDAO.insertUser() 호출
  3. 성공 시: 세션에 successMessage 저장 → `admin.jsp`
  4. 실패 시: 세션에 errorMessage 저장 → `adminAddUser.jsp`
- **특징**: 절대 login.jsp로 리다이렉트하지 않음

#### `AdminUpdateUserServlet.java` (`/adminUpdateUser`)

- **기능**: 관리자가 회원 정보 수정
- **메서드**: POST
- **보안**: admin 권한 체크
- **파라미터**: targetUserId, nickname, email, password (선택)
- **동작**:
  1. UserDAO.getUser()로 기존 정보 조회
  2. 새 정보로 업데이트
  3. 비밀번호는 입력된 경우만 변경
  4. 성공 시 `admin.jsp`로 리다이렉트

#### `AdminBanUserServlet.java` (`/adminBanUser`)

- **기능**: 관리자가 회원 추방 (삭제)
- **메서드**: POST
- **보안**: admin 권한 체크, admin 본인 추방 방지
- **파라미터**: userId
- **동작**:
  1. admin인지 확인
  2. targetUserId가 admin이 아닌지 확인
  3. UserDAO.deleteUser() 호출
  4. 성공 시 `admin.jsp`로 리다이렉트

### 사용자 정보 관리 서블릿

#### `UserUpdateInfoServlet.java` (`/userUpdateInfo`)

- **기능**: 사용자가 자신의 정보 수정
- **메서드**: POST
- **파라미터**: nickname, email, password (선택)
- **동작**:
  1. 세션에서 username 확인
  2. UserDAO.getUser()로 기존 정보 조회
  3. 새 정보로 업데이트
  4. 세션 정보도 업데이트
  5. 성공 시 `mypage.jsp?tab=info`로 리다이렉트

#### `UserWithdrawalServlet.java` (`/userWithdrawal`)

- **기능**: 회원 탈퇴
- **메서드**: POST
- **동작**:
  1. 세션에서 userId 확인
  2. UserDAO.deleteUser() 호출
  3. 세션 무효화
  4. 성공 시 `index.jsp`로 리다이렉트

### 유효성 검사 서블릿 (AJAX)

#### `UserIdCheckServlet.java` (`/userIdCheck`)

- **기능**: 아이디 중복 확인
- **메서드**: POST
- **파라미터**: userId
- **응답**: "available" 또는 "unavailable"
- **사용 페이지**: signup.jsp, adminAddUser.jsp

#### `NicknameCheckServlet.java` (`/nicknameCheck`)

- **기능**: 닉네임 중복 확인
- **메서드**: POST
- **파라미터**: nickname
- **응답**: "available" 또는 "unavailable"

#### `EmailCheckServlet.java` (`/emailCheck`)

- **기능**: 이메일 중복 확인
- **메서드**: POST
- **파라미터**: email
- **응답**: "available" 또는 "unavailable"

### 기타 서블릿

#### `HealthCheckServlet.java` (`/health`)

- **기능**: 서버 상태 확인
- **메서드**: GET
- **응답**: "OK"

---

## 🗄️ 데이터베이스 구조

### UserDAO (com.book.dao.UserDAO)

- **메서드**:
  - `login(userId, password)`: 로그인
  - `insertUser(UserDTO)`: 회원 추가
  - `getUser(userId)`: 회원 정보 조회
  - `updateUser(UserDTO)`: 회원 정보 수정
  - `deleteUser(userId)`: 회원 삭제
  - `checkId(userId)`: 아이디 중복 확인
  - `checkNickname(nickname)`: 닉네임 중복 확인
  - `checkEmail(email)`: 이메일 중복 확인
  - `getAllUsers()`: 모든 회원 조회 (관리자용)

### UserDTO (com.book.dto.UserDTO)

- **필드**:
  - `userId`: 사용자 ID (Primary Key)
  - `password`: 비밀번호
  - `email`: 이메일
  - `nickname`: 닉네임

### 데이터베이스 테이블: `사용자`

```sql
CREATE TABLE 사용자 (
    사용자id VARCHAR(16) PRIMARY KEY,
    비밀번호 VARCHAR(16) NOT NULL,
    이메일 VARCHAR(100) NOT NULL,
    닉네임 VARCHAR(50) NOT NULL
);
```

---

## 🎨 디자인 시스템

### 색상 테마

- **Primary Color**: `#030213` (검은색 - login 페이지 기준)
- **이전 Primary**: `#3B82F6` (파란색 - 일부 페이지에 남아있을 수 있음)

### 프레임워크

- **Tailwind CSS**: 유틸리티 기반 CSS 프레임워크
- **Google Fonts**: Noto Sans KR

### 주요 디자인 요소

- **로고**: 검은색 박스 + 흰색 "B" 텍스트
- **카드**: 둥근 모서리, 그림자 효과
- **버튼**: 호버 효과, 트랜지션
- **반응형**: 모바일, 태블릿, 데스크톱 지원

---

## 🔐 보안 기능

### 세션 관리

- **로그인 상태 확인**: 모든 보호된 페이지에서 세션 체크
- **세션 속성**:
  - `username`: 사용자 ID
  - `nickname`: 닉네임
  - `email`: 이메일

### 권한 관리

- **Admin 권한**: username이 "admin"인 경우
- **페이지 레벨 보안**: JSP에서 권한 체크
- **서블릿 레벨 보안**: 서블릿에서 권한 체크

### 유효성 검사

- **클라이언트 측 (JavaScript)**:
  - 입력 형식 검증
  - 비밀번호 일치 확인
  - 아이디 중복 확인
- **서버 측 (서블릿)**:
  - 파라미터 검증
  - SQL Injection 방지 (PreparedStatement 사용)

---

## 🚀 실행 방법

### 요구사항

- **JDK**: 11 이상
- **서버**: Apache Tomcat 10.x
- **데이터베이스**: MySQL 또는 MariaDB

### 데이터베이스 설정

> [!IMPORTANT] > **데이터베이스 설정 필수!**
>
> 애플리케이션을 실행하기 전에 반드시 데이터베이스 연결 정보를 설정해야 합니다.

#### 1. 데이터베이스 생성

MySQL 또는 MariaDB에서 새로운 데이터베이스를 생성합니다:

```sql
CREATE DATABASE your_database_name CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

#### 2. 테이블 생성

`사용자` 테이블을 생성합니다:

```sql
CREATE TABLE 사용자 (
    사용자id VARCHAR(16) PRIMARY KEY,
    비밀번호 VARCHAR(16) NOT NULL,
    이메일 VARCHAR(100) NOT NULL,
    닉네임 VARCHAR(50) NOT NULL
);
```

#### 3. DBUtil.java 설정

**중요**: [DBUtil.java](file:///Users/donghyunlee/Desktop/bookSearchApp/test2/src/main/java/com/book/util/DBUtil.java) 파일에서 데이터베이스 연결 정보를 수정해야 합니다.

파일 위치: `test2/src/main/java/com/book/util/DBUtil.java`

아래 상수 값들을 실제 데이터베이스 정보로 변경하세요:

```java
// 변경 전 (기본값)
private static final String HOST = "YOUR_LOCAH_HOST";      // 예: "localhost"
private static final String PORT = "YOUR_PORT";            // 예: "3306" 또는 "3307"
private static final String DB_NAME = "YOUT_DB_NAME";      // 예: "book_db"
private static final String USER = "YOUR_ID";              // 예: "root"
private static final String PASS = "YOUR_PASSWORD";        // 예: "your_password" 또는 ""

// 변경 예시
private static final String HOST = "localhost";
private static final String PORT = "3307";
private static final String DB_NAME = "book_db";
private static final String USER = "root";
private static final String PASS = "";  // 비밀번호가 없는 경우 빈 문자열
```

> [!WARNING] > **보안 주의사항**
>
> - `DBUtil.java` 파일에는 데이터베이스 접속 정보가 포함되어 있습니다
> - 이 파일을 공개 저장소에 업로드할 때는 실제 비밀번호가 포함되지 않도록 주의하세요
> - `.gitignore`에 `db.properties` 파일이 추가되어 있으므로, 향후 별도의 설정 파일 사용을 권장합니다

### 실행

1. 프로젝트를 Tomcat에 배포
2. 서버 시작
3. 브라우저에서 `http://localhost:8080/test2` 접속

### 테스트 계정

- **관리자**: admin / (비밀번호 무관)
- **일반 사용자**: testuser / (비밀번호 무관)

---

## 📝 주요 워크플로우

### 회원가입 → 로그인

```
signup.jsp → SignUpServlet → login.jsp → LoginServlet → index.jsp
```

### 관리자 회원 추가

```
admin.jsp → adminAddUser.jsp → AdminAddUserServlet → admin.jsp
```

### 관리자 회원 수정

```
admin.jsp → adminEditUser.jsp → AdminUpdateUserServlet → admin.jsp
```

### 관리자 회원 추방

```
admin.jsp → banUser() JS → AdminBanUserServlet → admin.jsp
```

### 사용자 정보 수정

```
mypage.jsp → UserUpdateInfoServlet → mypage.jsp
```

### 회원 탈퇴

```
mypage.jsp → UserWithdrawalServlet → index.jsp
```

---

## 🐛 알려진 이슈 및 해결

### 1. 회원 탈퇴 시 DB 미삭제 ✅ 해결

- **문제**: 버튼만 있고 실제 삭제 안 됨
- **해결**: UserWithdrawalServlet 호출로 수정

### 2. Admin 회원 추가 시 로그아웃 ✅ 해결

- **문제**: 세션이 손실됨
- **해결**: JavaScript redirect → HTTP redirect 변경

### 3. Admin 추방 기능 미작동 ✅ 해결

- **문제**: alert만 표시
- **해결**: AdminBanUserServlet 생성 및 연동

---

## 📚 추가 개선 사항

### 향후 계획

- [ ] 실제 도서 API 연동 (현재는 모크 데이터)
- [ ] 리뷰 작성 기능 구현
- [ ] 도서 관심 목록 DB 연동
- [ ] Header에 도서 검색 기능 추가
- [ ] 페이지네이션 추가
- [ ] 파일 업로드 (프로필 사진)
- [ ] 책 오디오북으로 변환
- [ ] jstl, el 문법으로 변경

---

## 👥 개발자 정보

- **프로젝트명**: BookSearchApp v2 (현재 v2)
- **기술 스택**: JSP, Servlet, JDBC, MySQL, Tailwind CSS
- **패턴**: MVC (Model-View-Controller)

---

**마지막 업데이트**: 2025-11-24

