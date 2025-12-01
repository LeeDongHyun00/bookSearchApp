package com.book.dto;

import java.sql.Timestamp;

public class ReviewDTO {
    private int reviewId;
    private String bookId;
    private String userId;
    private String content;
    private int rating;
    private Timestamp regDate;
    
    // 조인을 위한 추가 필드
    private String userName; 
    private String bookTitle; 

    public ReviewDTO() {}

    public ReviewDTO(int reviewId, String bookId, String userId, String content, int rating, Timestamp regDate) {
        this.reviewId = reviewId;
        this.bookId = bookId;
        this.userId = userId;
        this.content = content;
        this.rating = rating;
        this.regDate = regDate;
    }

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }
    public String getBookId() { return bookId; }
    public void setBookId(String bookId) { this.bookId = bookId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public Timestamp getRegDate() { return regDate; }
    public void setRegDate(Timestamp regDate) { this.regDate = regDate; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
}
