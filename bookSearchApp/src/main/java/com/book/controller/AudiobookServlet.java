package com.book.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

import nl.siegmann.epublib.domain.Book;
import nl.siegmann.epublib.domain.Resource;
import nl.siegmann.epublib.epub.EpubReader;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

@WebServlet("/convertAudiobook")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 50,      // 50 MB
    maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class AudiobookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            Part filePart = request.getPart("file");
            if (filePart == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("No file uploaded");
                return;
            }

            String fileName = filePart.getSubmittedFileName().toLowerCase();
            InputStream fileContent = filePart.getInputStream();
            String extractedText = "";

            if (fileName.endsWith(".pdf")) {
                extractedText = extractTextFromPDF(fileContent);
            } else if (fileName.endsWith(".epub")) {
                extractedText = extractTextFromEPUB(fileContent);
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("Unsupported file format. Please upload PDF or EPUB.");
                return;
            }

            // Format text (simple line break handling)
            extractedText = formatText(extractedText);
            
            out.write(extractedText);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("Error processing file: " + e.getMessage());
        }
    }

    private String extractTextFromPDF(InputStream inputStream) throws IOException {
        try (PDDocument document = PDDocument.load(inputStream)) {
            PDFTextStripper stripper = new PDFTextStripper();
            return stripper.getText(document);
        }
    }

    private String extractTextFromEPUB(InputStream inputStream) throws IOException {
        EpubReader epubReader = new EpubReader();
        Book book = epubReader.readEpub(inputStream);
        StringBuilder textBuilder = new StringBuilder();
        
        List<Resource> contents = book.getContents();
        for (Resource resource : contents) {
            // Use Jsoup to parse HTML content and extract text
            Document doc = Jsoup.parse(resource.getInputStream(), "UTF-8", "");
            textBuilder.append(doc.text()).append("\n\n");
        }
        
        return textBuilder.toString();
    }
    
    private String formatText(String text) {
        if (text == null) return "";
        // Replace sentence endings with double newlines for better readability
        return text.replaceAll("([.!?])\\s+", "$1\n\n");
    }
}
