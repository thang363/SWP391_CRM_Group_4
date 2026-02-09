package service.impl;

import dao.LandingPageDAO;
import dao.impl.LandingPageDAOImpl;
import model.entity.LandingPage;
import service.LandingPageService;
import java.sql.Timestamp;

public class LandingPageServiceImpl implements LandingPageService {

    private final LandingPageDAO lpDAO;
    
    // Default Template (Hardcoded for prototype phase)
    // In real app, this should be loaded from a file or DB template table
    // Default Template Path
    private static final String TEMPLATE_PATH = "g:/CRM/web/templates/standout/index.html";
    private static final String DEFAULT_HTML_TEMPLATE = "<h1>Error loading template</h1>";

    private static final String DEFAULT_DATA_CONFIG = 
            "{ \"HERO_TITLE\": \"Standout App\", \"HERO_DESC\": \"An Amazing App That Does It All.\", \"HERO_ALIGN\": \"text-left\" }";

    public LandingPageServiceImpl() {
        this.lpDAO = new LandingPageDAOImpl();
    }
    
    // Expose DAO for Servlet access (list/delete operations)
    public LandingPageDAO getLandingPageDAO() {
        return this.lpDAO;
    }

    @Override
    public LandingPage getLandingPageById(Integer id) {
        return lpDAO.findById(id);
    }

    @Override
    public LandingPage getLandingPageByCampaignId(Integer campaignId) {
        return lpDAO.findByCampaignId(campaignId);
    }

    /**
     * Create a new Landing Page for a campaign.
     * Always creates a new record (supports multiple LPs per campaign).
     */
    public LandingPage createLandingPage(Integer campaignId, Integer createdBy, String brief) {
        LandingPage lp = new LandingPage();
        lp.setCampaignId(campaignId);
        lp.setCreatedBy(createdBy);
        lp.setBrief(brief);
        
        // Load Template from File
        String htmlContent = DEFAULT_HTML_TEMPLATE;
        try {
            java.nio.file.Path path = java.nio.file.Paths.get(TEMPLATE_PATH);
            if (java.nio.file.Files.exists(path)) {
                htmlContent = java.nio.file.Files.readString(path);
            }
        } catch (java.io.IOException e) {
            e.printStackTrace();
            System.err.println("Failed to load template: " + e.getMessage());
        }
        
        lp.setHtmlTemplate(htmlContent);
        lp.setDataConfig(DEFAULT_DATA_CONFIG);
        lp.setStatus("Draft");
        lp.setName("LP #" + System.currentTimeMillis() % 10000 + " - Campaign " + campaignId);
        lp.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        
        return lpDAO.create(lp);
    }

    @Override
    public LandingPage createDraft(Integer campaignId, Integer createdBy) {
        // Deprecated: Use createLandingPage instead
        return createLandingPage(campaignId, createdBy, null);
    }

    @Override
    public boolean assignMarketing(Integer campaignId, Integer marketingId, String brief) {
        // Always create a new Landing Page assignment
        LandingPage lp = createLandingPage(campaignId, marketingId, brief);
        return lp != null;
    }

    @Override
    public boolean saveContent(Integer lpId, String dataConfig) {
        return lpDAO.updateContent(lpId, dataConfig);
    }

    @Override
    public boolean submitForApproval(Integer lpId) {
        return lpDAO.updateStatus(lpId, "Pending");
    }

    @Override
    public boolean approveLandingPage(Integer lpId, Integer managerId, String comment) {
        LandingPage lp = lpDAO.findById(lpId);
        if (lp == null) return false;
        
        lp.setStatus("Approved");
        lp.setApprovedBy(managerId);
        lp.setManagerComment(comment);
        
        return lpDAO.update(lp);
    }

    @Override
    public boolean rejectLandingPage(Integer lpId, String managerId, String reason) {
        LandingPage lp = lpDAO.findById(lpId);
        if (lp == null) return false;
        
        lp.setStatus("Rejected");
        lp.setManagerComment(reason); // Store rejection reason
        
        return lpDAO.update(lp);
    }

    @Override
    public String getRenderedHtml(Integer lpId) {
        LandingPage lp = lpDAO.findById(lpId);
        if (lp == null) return "Page Not Found";
        
        String html = lp.getHtmlTemplate();
        String data = lp.getDataConfig(); // JSON String
        
        // Simple manual parsing/replacement for prototype
        // In production, use Gson/Jackson
        if (data != null) {
            String title = "Standout App";
            String desc = "An Amazing App That Does It All.";
            
            // Very basic json parsing (vulnerable, just for demo)
            if (data.contains("\"HERO_TITLE\":")) {
                int start = data.indexOf("\"HERO_TITLE\":") + 14;
                int end = data.indexOf("\"", start + 1);
                if (start > 0 && end > start) title = data.substring(start + 1, end);
            }
            if (data.contains("\"HERO_DESC\":")) {
                int start = data.indexOf("\"HERO_DESC\":") + 13;
                int end = data.indexOf("\"", start + 1);
                if (start > 0 && end > start) desc = data.substring(start + 1, end);
            }
            
            html = html.replace("{{HERO_TITLE}}", title);
            html = html.replace("{{HERO_DESC}}", desc);
        }
        
        return html;
    }
}
