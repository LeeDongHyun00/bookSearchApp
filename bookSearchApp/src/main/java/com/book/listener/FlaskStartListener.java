package com.book.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.io.File;
import java.io.IOException;
import com.book.util.DBUtil;

@WebListener
public class FlaskStartListener implements ServletContextListener {

    private Process flaskProcess;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== Flask Auto-Start Initializing ===");

        String pythonCmd = DBUtil.getProperty("PYTHON_CMD");
        String flaskDir = DBUtil.getProperty("FLASK_DIR");

        // Default Python command
        if (pythonCmd == null || pythonCmd.trim().isEmpty()) {
            pythonCmd = "python3";
        }

        // Auto-detect Flask directory if not specified
        if (flaskDir == null || flaskDir.trim().isEmpty()) {
            flaskDir = findFlaskDirectory(sce);
            if (flaskDir == null) {
                System.err.println("Could not find recommendation_service directory. Skipping Flask auto-start.");
                System.err.println("Set FLASK_DIR in db.properties to specify the location manually.");
                return;
            }
        }

        System.out.println("Using Python: " + pythonCmd);
        System.out.println("Flask Directory: " + flaskDir);

        ProcessBuilder pb = new ProcessBuilder(pythonCmd, "app.py");
        pb.directory(new File(flaskDir));
        
        // Redirect output to Tomcat logs
        pb.redirectOutput(ProcessBuilder.Redirect.INHERIT);
        pb.redirectError(ProcessBuilder.Redirect.INHERIT);

        try {
            flaskProcess = pb.start();
            System.out.println("✓ Flask Server started successfully (PID: " + flaskProcess.pid() + ")");
        } catch (IOException e) {
            System.err.println("✗ Failed to start Flask Server: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Auto-detect the Flask recommendation_service directory
     * Searches parent directories from the deployed web app location
     */
    private String findFlaskDirectory(ServletContextEvent sce) {
        try {
            // Get the deployed web app path
            String webAppPath = sce.getServletContext().getRealPath("/");
            if (webAppPath == null) {
                return null;
            }

            File webAppDir = new File(webAppPath);
            
            // Try multiple strategies to find recommendation_service
            
            // Strategy 1: Check if we're in development (Eclipse deployment)
            // Path pattern: .../bookSearchApp/build/web/ or .../bookSearchApp/target/...
            File currentDir = webAppDir;
            for (int i = 0; i < 5; i++) {  // Search up to 5 levels
                File parentDir = currentDir.getParentFile();
                if (parentDir == null) break;
                
                // Look for recommendation_service at this level
                File flaskDir = new File(parentDir, "recommendation_service");
                if (flaskDir.exists() && flaskDir.isDirectory()) {
                    File appPy = new File(flaskDir, "app.py");
                    if (appPy.exists()) {
                        System.out.println("Found recommendation_service at: " + flaskDir.getAbsolutePath());
                        return flaskDir.getAbsolutePath();
                    }
                }
                
                currentDir = parentDir;
            }

            // Strategy 2: Check sibling directory of bookSearchApp
            // If deployed in tomcat/webapps/bookSearchApp, source might be nearby
            File grandParent = webAppDir.getParentFile();
            if (grandParent != null) {
                File sourceRoot = new File(grandParent.getParentFile(), "bookSearchApp");
                if (sourceRoot.exists()) {
                    File flaskDir = new File(sourceRoot, "recommendation_service");
                    if (flaskDir.exists() && new File(flaskDir, "app.py").exists()) {
                        System.out.println("Found recommendation_service at: " + flaskDir.getAbsolutePath());
                        return flaskDir.getAbsolutePath();
                    }
                }
            }

            return null;
        } catch (Exception e) {
            System.err.println("Error while searching for Flask directory: " + e.getMessage());
            return null;
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (flaskProcess != null && flaskProcess.isAlive()) {
            System.out.println("Stopping Flask Server...");
            flaskProcess.destroy();
            try {
                flaskProcess.waitFor(5, java.util.concurrent.TimeUnit.SECONDS);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            if (flaskProcess.isAlive()) {
                System.out.println("Force killing Flask Server...");
                flaskProcess.destroyForcibly();
            }
            System.out.println("✓ Flask Server stopped.");
        }
    }
}
