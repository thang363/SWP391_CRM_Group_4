package controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.CampaignTransfer;
import model.entity.Role;
import model.entity.User;
import service.CampaignTransferService;
import service.UserService;
import service.impl.CampaignTransferServiceImpl;
import service.impl.UserServiceImpl;
import util.Constants;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CampaignTransferServlet", urlPatterns = {"/transfers"})
public class CampaignTransferServlet extends HttpServlet {

    private final CampaignTransferService transferService;
    private final UserService userService;
    private final Gson gson;

    public CampaignTransferServlet() {
        this.transferService = new CampaignTransferServiceImpl();
        this.userService = new UserServiceImpl();
        this.gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + Constants.SERVLET_LOGIN);
            return;
        }

        Role userRole = (Role) session.getAttribute(Constants.SESSION_ROLE);
        if (!Role.MANAGER.equals(userRole)) {
            request.setAttribute(Constants.ATTR_ERROR_MESSAGE, Constants.ERROR_UNAUTHORIZED);
            request.getRequestDispatcher(Constants.PAGE_403).forward(request, response);
            return;
        }

        Long userId = (Long) session.getAttribute(Constants.SESSION_USER_ID);

        // Fetch pending incoming transfers
        List<CampaignTransfer> pendingIncoming = transferService.getPendingTransfersForRecipient(userId);
        
        // Fetch pending outgoing transfers (now includes Rejected to show rejection reasons)
        List<CampaignTransfer> pendingOutgoing = transferService.getRecentTransfersForSender(userId);

        request.setAttribute("pendingIncoming", pendingIncoming);
        request.setAttribute("pendingOutgoing", pendingOutgoing);
        request.setAttribute("pageTitle", "Yêu cầu Chuyển giao");
        request.setAttribute("currentPage", "transfers");

        request.getRequestDispatcher(Constants.PAGE_TRANSFER_INBOX).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(Constants.SESSION_USER_ID) == null) {
            sendJsonResponse(response, false, "Unauthorized", null);
            return;
        }

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Simple routing based on 'action' parameter or path info could be used
        // Here we'll read 'action' from JSON body or parameter
        // But strict REST would use path info. Let's support parameter for simplicity with existing pattern
        
        // However, the design used JSON body. Let's try to parse body first if content type is json
        
        String action = request.getParameter("action");
        if (action == null) {
             // Try reading from JSON body
             // This handling is a bit complex for mixed usage, let's stick to parameter for action routing
             // and JSON for data payload if needed, or just standard parameters.
             // The JS in design used fetch with JSON body.
             // Let's assume the action is passed in the URL or query string for routing, 
             // and data in body.
        }
        
        // Design JS: fetch('/api/campaigns/transfer/request', { body: JSON })
        // Since we are using a Servlet mapped to /transfers, we can use /transfers?action=request
        
        
        // Let's implement reading JSON body ONLY if Content-Type is JSON
        JsonObject jsonBody = null;
        String contentType = request.getContentType();
        if (contentType != null && contentType.contains("application/json")) {
            try {
                BufferedReader reader = request.getReader();
                jsonBody = gson.fromJson(reader, JsonObject.class);
            } catch (Exception e) {
                // Ignore if no body or invalid json
            }
        }
        
        // If action not in param, check json
        if (action == null && jsonBody != null && jsonBody.has("action")) {
            action = jsonBody.get("action").getAsString();
        }

        if (action == null) {
             sendJsonResponse(response, false, "Action missing", null);
             return;
        }

        Long userId = (Long) session.getAttribute(Constants.SESSION_USER_ID);

        try {
            switch (action) {
                case "request":
                    handleRequestTransfer(request, response, userId, jsonBody);
                    break;
                case "accept":
                    handleAcceptTransfer(request, response, userId, jsonBody);
                    break;
                case "reject":
                    handleRejectTransfer(request, response, userId, jsonBody);
                    break;
                case "cancel":
                    handleCancelTransfer(request, response, userId, jsonBody);
                    break;
                default:
                    sendJsonResponse(response, false, "Invalid action", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Error: " + e.getMessage(), null);
        }
    }

    private void handleRequestTransfer(HttpServletRequest request, HttpServletResponse response, Long userId, JsonObject json) throws IOException {
        // Support both form-urlencoded and JSON
        Long campaignId;
        Long toManagerId;
        String reason;
        
        // Try parameters first (form-urlencoded from frontend)
        String campaignIdParam = request.getParameter("campaignId");
        String toManagerIdParam = request.getParameter("toManagerId");
        String reasonParam = request.getParameter("reason");
        
        if (campaignIdParam != null && toManagerIdParam != null && reasonParam != null) {
            campaignId = Long.parseLong(campaignIdParam);
            toManagerId = Long.parseLong(toManagerIdParam);
            reason = reasonParam;
        } else if (json != null) {
            // Fallback to JSON
            campaignId = json.get("campaignId").getAsLong();
            toManagerId = json.get("toManagerId").getAsLong();
            reason = json.get("reason").getAsString();
        } else {
            sendJsonResponse(response, false, "Missing required data", null);
            return;
        }
        
        CampaignTransfer transfer = transferService.requestTransfer(campaignId, userId, toManagerId, reason);
        sendJsonResponse(response, true, "Transfer requested successfully", transfer);
    }

    private void handleAcceptTransfer(HttpServletRequest request, HttpServletResponse response, Long userId, JsonObject json) throws IOException {
        Long transferId = json != null && json.has("transferId") ? json.get("transferId").getAsLong() : Long.parseLong(request.getParameter("transferId"));
        String notes = json != null && json.has("notes") ? json.get("notes").getAsString() : request.getParameter("notes");
        
        boolean result = transferService.acceptTransfer(transferId, userId, notes);
        if (result) {
            sendJsonResponse(response, true, "Transfer accepted", null);
        } else {
            sendJsonResponse(response, false, "Failed to accept transfer", null);
        }
    }

    private void handleRejectTransfer(HttpServletRequest request, HttpServletResponse response, Long userId, JsonObject json) throws IOException {
        Long transferId = json != null && json.has("transferId") ? json.get("transferId").getAsLong() : Long.parseLong(request.getParameter("transferId"));
        String notes = json != null && json.has("notes") ? json.get("notes").getAsString() : request.getParameter("notes");
        
        boolean result = transferService.rejectTransfer(transferId, userId, notes);
        if (result) {
            sendJsonResponse(response, true, "Transfer rejected", null);
        } else {
            sendJsonResponse(response, false, "Failed to reject transfer", null);
        }
    }
    
    private void handleCancelTransfer(HttpServletRequest request, HttpServletResponse response, Long userId, JsonObject json) throws IOException {
        Long transferId = json != null && json.has("transferId") ? json.get("transferId").getAsLong() : Long.parseLong(request.getParameter("transferId"));
        
        boolean result = transferService.cancelTransfer(transferId, userId);
        if (result) {
            sendJsonResponse(response, true, "Transfer cancelled", null);
        } else {
            sendJsonResponse(response, false, "Failed to cancel transfer", null);
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data) throws IOException {
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);
        jsonResponse.put("data", data);

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}
