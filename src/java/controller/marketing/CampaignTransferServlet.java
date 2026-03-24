package controller.marketing;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
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

        Integer userId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);

        // Pagination setup
        int pageSize = 5;
        
        // 1. Handle Incoming Pagination
        int pageIn = 1;
        try {
            String pIn = request.getParameter("pageIn");
            if (pIn != null && !pIn.isEmpty()) pageIn = Integer.parseInt(pIn);
        } catch (NumberFormatException e) { pageIn = 1; }
        if (pageIn < 1) pageIn = 1;
        
        int totalIncoming = transferService.countPendingTransfersByRecipient(userId);
        int totalPagesIn = (int) Math.ceil((double) totalIncoming / pageSize);
        if (totalPagesIn < 1) totalPagesIn = 1;
        if (pageIn > totalPagesIn) pageIn = totalPagesIn;
        
        List<CampaignTransfer> pendingIncoming = transferService.getPendingTransfersForRecipient(userId, (pageIn - 1) * pageSize, pageSize);

        // 2. Handle Outgoing Pagination
        int pageOut = 1;
        try {
            String pOut = request.getParameter("pageOut");
            if (pOut != null && !pOut.isEmpty()) pageOut = Integer.parseInt(pOut);
        } catch (NumberFormatException e) { pageOut = 1; }
        if (pageOut < 1) pageOut = 1;
        
        int totalOutgoing = transferService.countRecentTransfersBySender(userId);
        int totalPagesOut = (int) Math.ceil((double) totalOutgoing / pageSize);
        if (totalPagesOut < 1) totalPagesOut = 1;
        if (pageOut > totalPagesOut) pageOut = totalPagesOut;
        
        List<CampaignTransfer> pendingOutgoing = transferService.getRecentTransfersForSender(userId, (pageOut - 1) * pageSize, pageSize);

        request.setAttribute("pendingIncoming", pendingIncoming);
        request.setAttribute("pendingOutgoing", pendingOutgoing);
        request.setAttribute("pageIn", pageIn);
        request.setAttribute("totalPagesIn", totalPagesIn);
        request.setAttribute("totalIn", totalIncoming);
        request.setAttribute("pageOut", pageOut);
        request.setAttribute("totalPagesOut", totalPagesOut);
        request.setAttribute("totalOut", totalOutgoing);
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
        String action = request.getParameter("action");     
        if (action == null) {
            sendJsonResponse(response, false, "Action missing", null);
            return;
        }

        // 3. Process action
        Integer userId = (Integer) session.getAttribute(Constants.SESSION_USER_ID);
        try {
            switch (action) {
                case "request":
                    handleRequestTransfer(request, response, userId);
                    break;
                case "accept":
                    handleAcceptTransfer(request, response, userId);
                    break;
                case "reject":
                    handleRejectTransfer(request, response, userId);
                    break;
                case "cancel":
                    handleCancelTransfer(request, response, userId);
                    break;
                default:
                    sendJsonResponse(response, false, "Invalid action: " + action, null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Error processing action: " + e.getMessage(), null);
        }
    }

    private void handleRequestTransfer(HttpServletRequest request, HttpServletResponse response, Integer userId) throws IOException {
        Integer campaignId;
        Integer toManagerId;
        String reason;

        String campaignIdParam = request.getParameter("campaignId");
        String toManagerIdParam = request.getParameter("toManagerId");
        String reasonParam = request.getParameter("reason");

        if (campaignIdParam != null && toManagerIdParam != null && reasonParam != null) {
            campaignId = Integer.valueOf(campaignIdParam);
            toManagerId = Integer.valueOf(toManagerIdParam);
            reason = reasonParam;
        } else {
            sendJsonResponse(response, false, "Missing required data", null);
            return;
        }

        CampaignTransfer transfer = transferService.requestTransfer(campaignId, userId, toManagerId, reason);
        sendJsonResponse(response, true, "Transfer requested successfully", transfer);
    }

    private void handleAcceptTransfer(HttpServletRequest request, HttpServletResponse response, Integer userId) throws IOException {
        String transferIdParam = request.getParameter("transferId");
        String notes = request.getParameter("notes");
        
        if (transferIdParam == null) {
            sendJsonResponse(response, false, "Missing transferId", null);
            return;
        }
        Integer transferId = Integer.valueOf(transferIdParam);

        boolean result = transferService.acceptTransfer(transferId, userId, notes);
        if (result) {
            sendJsonResponse(response, true, "Transfer accepted", null);
        } else {
            sendJsonResponse(response, false, "Failed to accept transfer", null);
        }
    }

    private void handleRejectTransfer(HttpServletRequest request, HttpServletResponse response, Integer userId) throws IOException {
        String transferIdParam = request.getParameter("transferId");
        String notes = request.getParameter("notes");

        if (transferIdParam == null) {
            sendJsonResponse(response, false, "Missing transferId", null);
            return;
        }
        Integer transferId = Integer.valueOf(transferIdParam);

        boolean result = transferService.rejectTransfer(transferId, userId, notes);
        if (result) {
            sendJsonResponse(response, true, "Transfer rejected", null);
        } else {
            sendJsonResponse(response, false, "Failed to reject transfer", null);
        }
    }

    private void handleCancelTransfer(HttpServletRequest request, HttpServletResponse response, Integer userId) throws IOException {
        String transferIdParam = request.getParameter("transferId");

        if (transferIdParam == null) {
            sendJsonResponse(response, false, "Missing transferId", null);
            return;
        }
        Integer transferId = Integer.valueOf(transferIdParam);

        boolean result = transferService.cancelTransfer(transferId, userId);
        if (result) {
            sendJsonResponse(response, true, "Transfer cancelled", null);
        } else {
            sendJsonResponse(response, false, "Failed to cancel transfer", null);
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);
        jsonResponse.put("data", data);

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
}
