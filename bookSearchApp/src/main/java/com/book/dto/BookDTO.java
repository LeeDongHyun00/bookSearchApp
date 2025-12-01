package com.book.dto;

import java.util.List;
import java.util.ArrayList;

public class BookDTO {
    private String isbn;
    private String title;
    private String publisher;
    private String synopsis;
    private String coverImage;
    private boolean isEbook;
    private double rating;
    private int reviewCount;
    private List<AuthorDTO> authors = new ArrayList<>();
    private List<CategoryDTO> categories = new ArrayList<>();
    private List<ReviewDTO> reviews = new ArrayList<>();

    public BookDTO() {}

    public BookDTO(String isbn, String title, String publisher, String synopsis, String coverImage, boolean isEbook, double rating, int reviewCount) {
        this.isbn = isbn;
        this.title = title;
        this.publisher = publisher;
        this.synopsis = synopsis;
        this.coverImage = coverImage;
        this.isEbook = isEbook;
        this.rating = rating;
        this.reviewCount = reviewCount;
    }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }
    public String getSynopsis() { return synopsis; }
    public void setSynopsis(String synopsis) { this.synopsis = synopsis; }
    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
    public boolean isEbook() { return isEbook; }
    public void setEbook(boolean ebook) { isEbook = ebook; }
    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
    public List<AuthorDTO> getAuthors() { return authors; }
    public void setAuthors(List<AuthorDTO> authors) { this.authors = authors; }
    public List<CategoryDTO> getCategories() { return categories; }
    public void setCategories(List<CategoryDTO> categories) { this.categories = categories; }
    public List<ReviewDTO> getReviews() { return reviews; }
    public void setReviews(List<ReviewDTO> reviews) { this.reviews = reviews; }
    
    // 편의 메서드: 저자 이름들을 콤마로 구분된 문자열로 반환
    public String getAuthorNames() {
        if (authors == null || authors.isEmpty()) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < authors.size(); i++) {
            sb.append(authors.get(i).getAuthorName());
            if (i < authors.size() - 1) sb.append(", ");
        }
        return sb.toString();
    }
    
    // 편의 메서드: 카테고리 이름들을 콤마로 구분된 문자열로 반환
    public String getCategoryNames() {
        if (categories == null || categories.isEmpty()) return "";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < categories.size(); i++) {
            sb.append(categories.get(i).getCategoryName());
            if (i < categories.size() - 1) sb.append(", ");
        }
        return sb.toString();
    }
}
