package controller;

import com.google.gson.Gson;
import dao.ImportHistoryDAO;
import dao.LeadSourceDAO;
import dao.LeadSubmissionDAO;
import dao.impl.ImportHistoryDAOImpl;
import dao.impl.LeadSourceDAOImpl;
import dao.impl.LeadSubmissionDAOImpl;
import model.entity.ImportHistory;
import model.entity.LeadSource;
import model.entity.LeadSubmission;
import util.Constants;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ImportLeadServlet", urlPatterns = {"/marketing/import-leads"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class ImportLeadServlet extends HttpServlet {

    private ImportHistoryDAO importHistoryDAO;
    private LeadSubmissionDAO submissionDAO;
    private LeadSourceDAO leadSourceDAO;
    private dao.CampaignDAO campaignDAO;

    @Override
    public void init() {
        importHistoryDAO = new ImportHistoryDAOImpl();
        submissionDAO = new LeadSubmissionDAOImpl();
        leadSourceDAO = new LeadSourceDAOImpl();
        campaignDAO = new dao.impl.CampaignDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<LeadSource> sources = leadSourceDAO.findAll();
        request.setAttribute("sources", sources);
        
        // Load Campaigns for dropdown
        // Using findAll for now. Ideally should filter by Active status.
        List<model.entity.Campaign> campaigns = campaignDAO.findAll();
        request.setAttribute("campaigns", campaigns);
        
        request.getRequestDispatcher("/views/marketing/import-leads.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Check Session & User (AuthFilter handles login, RoleFilter handles role)
        Object userIdObj = request.getSession().getAttribute(Constants.SESSION_USER_ID);
        if (userIdObj == null) {
            response.sendRedirect(request.getContextPath() + Constants.SERVLET_LOGIN);
            return;
        }
        Integer userId = ((Number) userIdObj).intValue();

        String message = "";
        String messageType = "danger";

        try {
            // 2. Rate Limit Check (Spam Protection)
            int countToday = importHistoryDAO.countImportToday(userId);
            if (countToday >= 5) { // Limit 5 imports per day
                throw new Exception("Bạn đã vượt quá giới hạn import trong ngày (5 lần). Vui lòng quay lại vào ngày mai.");
            }

            // 3. Get Part & Parameters
            Part filePart = request.getPart("file");
            String sourceInput = request.getParameter("source");
            String campaignIdStr = request.getParameter("campaignId");
            
            if (filePart == null || filePart.getSize() == 0) {
                throw new Exception("Vui lòng chọn file CSV.");
            }
            
            if (campaignIdStr == null || campaignIdStr.trim().isEmpty()) {
                throw new Exception("Vui lòng chọn Chiến dịch (Campaign).");
            }
            Integer campaignId = Integer.parseInt(campaignIdStr);

            String fileName = filePart.getSubmittedFileName();
            if (sourceInput == null || sourceInput.trim().isEmpty()) {
                sourceInput = "File: " + fileName; // Default source name
            }

            // Read file content into memory
            byte[] fileContent = filePart.getInputStream().readAllBytes();

            // 4. Checksum (Optional: Just log or use for history)
            String checksum = calculateChecksum(fileContent);
            // User requested to remove file-level blocking:
            // if (importHistoryDAO.existsChecksum(checksum)) { ... }
            
            // 5. Parse CSV & Create Submissions
            List<LeadSubmission> submissions = parseCSV(fileContent, sourceInput, campaignId);
            
            if (submissions.isEmpty()) {
                 throw new Exception("File rỗng hoặc không có dữ liệu hợp lệ (Yêu cầu: FullName, Email, Phone).");
            }
            
            if (submissions.size() > 1000) {
                 throw new Exception("File quá lớn (> 1000 dòng). Vui lòng chia nhỏ file.");
            }

            // 6. Insert to DB with Duplicate Check
            int successCount = 0;
            int skipCount = 0;
            int errorCount = 0;
            
            for (LeadSubmission sub : submissions) {
                // Validate Data
                if (sub.getFullName() == null || sub.getFullName().isEmpty()) {
                    errorCount++;
                    continue;
                }
                if (!isValidEmail(sub.getEmail())) {
                    errorCount++;
                    continue;
                }
                if (sub.getPhone() != null && !sub.getPhone().isEmpty() && !isValidPhone(sub.getPhone())) {
                    errorCount++;
                    continue;
                }

                // Check duplicate before insert
                if (submissionDAO.exists(sub.getEmail(), sub.getPhone())) {
                    skipCount++;
                    continue;
                }
                
                LeadSubmission created = submissionDAO.create(sub);
                if (created != null) {
                    successCount++;
                } else {
                    errorCount++;
                }
            }

            // 7. Log History
            ImportHistory history = new ImportHistory();
            history.setUserId(userId);
            history.setFileName(fileName);
            history.setChecksum(checksum);
            history.setTotalRows(submissions.size());
            history.setSuccessRows(successCount);
            history.setErrorRows(errorCount);
            
            importHistoryDAO.insert(history);

            message = "Import hoàn tất! Thêm mới: " + successCount + ", Bỏ qua (trùng): " + skipCount + ", Lỗi: " + errorCount;
            messageType = "success";

        } catch (Exception e) {
            message = "Lỗi: " + e.getMessage();
            e.printStackTrace();
        }

        request.setAttribute("message", message);
        request.setAttribute("messageType", messageType);
        
        // Reload sources and campaigns
        List<LeadSource> sources = leadSourceDAO.findAll();
        request.setAttribute("sources", sources);
        List<model.entity.Campaign> campaigns = campaignDAO.findAll();
        request.setAttribute("campaigns", campaigns);
        
        request.getRequestDispatcher("/views/marketing/import-leads.jsp").forward(request, response);
    }

    private String calculateChecksum(byte[] content) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("MD5");
        byte[] hash = digest.digest(content);
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }
    
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");
    }

    private boolean isValidPhone(String phone) {
        // Allow digits, spaces, plus, dashes. Min 7 chars.
        return phone.matches("^[0-9\\+\\-\\s]{7,15}$");
    }

    private List<LeadSubmission> parseCSV(byte[] content, String source, Integer campaignId) throws IOException {
        List<LeadSubmission> list = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(new ByteArrayInputStream(content), StandardCharsets.UTF_8))) {
            String line;
            int lineNum = 0;
            while ((line = br.readLine()) != null) {
                lineNum++;
                line = line.trim();
                if (line.isEmpty()) continue;
                
                // Keep it simple: Split by comma
                // Expected format: Name, Email, Phone
                // Skip header logic: If first line contains "email" or "phone", skip it.
                if (lineNum == 1 && (line.toLowerCase().contains("email") || line.toLowerCase().contains("phone"))) {
                    continue;
                }

                String[] parts = line.split(",");
                if (parts.length < 2) continue; // At least Name and Email
                
                String fullName = parts[0].trim();
                String email = parts[1].trim();
                String phone = parts.length > 2 ? parts[2].trim() : "";
                
                LeadSubmission sub = new LeadSubmission();
                sub.setFullName(fullName);
                sub.setEmail(email);
                sub.setPhone(phone);
                sub.setSource(source);
                sub.setCampaignId(campaignId); // Set Campaign ID
                sub.setIsProcessed(false);
                // LandingPageId is null for imports
                
                list.add(sub);
            }
        }
        return list;
    }
}
