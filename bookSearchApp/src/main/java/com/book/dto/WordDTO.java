package com.book.dto;

public class WordDTO {
    private int wordId;
    private String word;
    private String category;
    private String regDate;

    public int getWordId() { return wordId; }
    public void setWordId(int wordId) { this.wordId = wordId; }
    public String getWord() { return word; }
    public void setWord(String word) { this.word = word; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }
}