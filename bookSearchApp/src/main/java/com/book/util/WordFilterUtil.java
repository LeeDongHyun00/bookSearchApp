package com.book.util;

import com.book.dao.WordDAO; 
import com.book.dto.WordDTO;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class WordFilterUtil {
    
    private static Set<String> FORBIDDEN_WORDS_CACHE = Collections.synchronizedSet(new HashSet<>());
    private static final WordDAO dao = new WordDAO();

    static {
        loadCache(); 
    }

    public static void loadCache() {
        try {
            List<WordDTO> wordList = dao.getAllWords(); 
            FORBIDDEN_WORDS_CACHE.clear();
            for (WordDTO word : wordList) {
                FORBIDDEN_WORDS_CACHE.add(word.getWord().toLowerCase().replaceAll("[^\\w가-힣]", ""));
            }
            System.out.println("금지어 캐시 로드 완료. 총 " + FORBIDDEN_WORDS_CACHE.size() + "개");
        } catch (Exception e) {
            System.err.println("금지어 캐시 로드 중 오류 발생: " + e.getMessage());
        }
    }

    public static String filter(String reviewContent) {
        if (reviewContent == null || reviewContent.trim().isEmpty()) {
            return null;
        }
        String normalizedContent = reviewContent.toLowerCase().replaceAll("[^\\w가-힣]", "");
        
        for (String forbiddenWord : FORBIDDEN_WORDS_CACHE) {
            if (normalizedContent.contains(forbiddenWord)) {
                return forbiddenWord; 
            }
        }
        return null; 
    }
}