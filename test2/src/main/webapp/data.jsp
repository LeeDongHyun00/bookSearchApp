<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%!
    public static class Book {
        public int id;
        public String title;
        public String author;
        public String coverImage;
        public String description;
        public String synopsis;
        public double rating;
        public int reviewCount;
        public String category;
        public String publishDate;
        public List<Review> reviews;

        public Book(int id, String title, String author, String coverImage, String description, String synopsis, 
                   double rating, int reviewCount, String category, String publishDate) {
            this.id = id;
            this.title = title;
            this.author = author;
            this.coverImage = coverImage;
            this.description = description;
            this.synopsis = synopsis;
            this.rating = rating;
            this.reviewCount = reviewCount;
            this.category = category;
            this.publishDate = publishDate;
            this.reviews = new ArrayList<>();
        }
    }

    public static class Review {
        public int id;
        public int bookId;
        public int userId;
        public String userName;
        public double rating;
        public String content;
        public String date;
        public int likes;

        public Review(int id, int bookId, int userId, String userName, double rating, String content, String date, int likes) {
            this.id = id;
            this.bookId = bookId;
            this.userId = userId;
            this.userName = userName;
            this.rating = rating;
            this.content = content;
            this.date = date;
            this.likes = likes;
        }
    }

    public static List<Book> getMockBooks() {
        List<Book> books = new ArrayList<>();
        
        Book b1 = new Book(1, "채식주의자", "한강", "https://image.yes24.com/goods/109705390/XL", 
            "2024 노벨문학상 수상 작가 한강의 대표작.", 
            "폭력에 대항해 스스로 나무가 되어간 여자의 이야기. 어느 날 갑자기 육식을 거부하며 시작된 영혜의 기이한 변화와 이를 바라보는 가족들의 시선을 그립니다.", 
            4.8, 1250, "소설", "2022-03-28");
        b1.reviews.add(new Review(1, 1, 101, "책벌레", 5.0, "정말 강렬한 소설입니다.", "2024-01-15", 12));
        b1.reviews.add(new Review(2, 1, 102, "독서왕", 4.5, "생각할 거리를 많이 던져주네요.", "2024-02-01", 8));
        books.add(b1);

        Book b2 = new Book(2, "소년이 온다", "한강", "https://image.yes24.com/goods/12651660/XL", 
            "1980년 5월, 광주. 그곳에 있었던 소년들의 이야기.", 
            "1980년 광주 민주화 운동 당시의 상황과 그 이후 남겨진 사람들의 이야기를 담은 장편소설. 고통스러운 역사를 마주하는 저자의 섬세한 문체가 돋보입니다.", 
            4.9, 980, "소설", "2014-05-19");
        books.add(b2);

        Book b3 = new Book(3, "도둑맞은 집중력", "요한 하리", "https://image.yes24.com/goods/118579613/XL", 
            "집중력 위기의 시대, 우리는 어떻게 다시 몰입할 수 있는가.", 
            "현대인의 집중력이 왜 무너지고 있는지, 그리고 그것을 되찾기 위해 우리는 무엇을 해야 하는지를 과학적 연구와 인터뷰를 통해 파헤칩니다.", 
            4.7, 850, "인문", "2023-04-28");
        books.add(b3);
        
        Book b4 = new Book(4, "세이노의 가르침", "세이노(SayNo)", "https://image.yes24.com/goods/117014613/XL", 
            "재야의 명저, 정식 출간. 삶과 태도에 대한 통찰.", 
            "수십 년간 사업가로서 쌓아온 경험과 부에 대한 철학을 가감 없이 담아낸 책. 삶을 대하는 태도에 대해 날카로운 조언을 던집니다.", 
            4.6, 3200, "자기계발", "2023-03-02");
        books.add(b4);

        Book b5 = new Book(5, "모순", "양귀자", "https://image.yes24.com/goods/8759796/XL", 
            "인생은 탐구하는 것이 아니라 받아들이는 것.", 
            "결혼 적령기의 주인공 안진진이 겪는 삶의 고민과 선택을 통해, 인생의 모순적인 면들을 깊이 있게 탐구하는 소설입니다.", 
            4.9, 1500, "소설", "2013-04-01");
        books.add(b5);

        return books;
    }
%>