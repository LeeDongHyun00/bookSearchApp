package com.book.dto;

public class AuthorDTO {
    private int authorId;
    private String authorName;

    public AuthorDTO() {}

    public AuthorDTO(int authorId, String authorName) {
        this.authorId = authorId;
        this.authorName = authorName;
    }

    public int getAuthorId() { return authorId; }
    public void setAuthorId(int authorId) { this.authorId = authorId; }
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
}
