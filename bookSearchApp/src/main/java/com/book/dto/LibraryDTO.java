package com.book.dto;

import java.sql.Timestamp;

public class LibraryDTO {
    private int libraryId;
    private String userId;
    private String bookId;
    private Timestamp regDate;
    
    // 조인을 위한 추가 필드
    private String bookTitle;
    private String bookCover;

    public LibraryDTO() {}

    public LibraryDTO(int libraryId, String userId, String bookId, Timestamp regDate) {
        this.libraryId = libraryId;
        this.userId = userId;
        this.bookId = bookId;
        this.regDate = regDate;
    }

    public int getLibraryId() { return libraryId; }
    public void setLibraryId(int libraryId) { this.libraryId = libraryId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getBookId() { return bookId; }
    public void setBookId(String bookId) { this.bookId = bookId; }
    public Timestamp getRegDate() { return regDate; }
    public void setRegDate(Timestamp regDate) { this.regDate = regDate; }
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    public String getBookCover() { return bookCover; }
    public void setBookCover(String bookCover) { this.bookCover = bookCover; }
}
