package controller.sales;

import dao.OpportunityDAO;
import dao.QuoteDAO;
import dao.impl.OpportunitiesDaoImpl;
import dao.impl.QuoteDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Opportunity;
import model.entity.Quote;
import model.entity.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet(name = "QuoteServlet", urlPatterns = {"/sales/quote"})
public class QuoteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String oppIdParam = request.getParameter("opportunityId");
        String quoteIdParam = request.getParameter("quoteId");

        if (action == null || oppIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/sales/opportunities");
            return;
        }

        try {
            int oppId = Integer.parseInt(oppIdParam);
            QuoteDAO quoteDAO = new QuoteDAOImpl();
            OpportunityDAO oppDAO = new OpportunitiesDaoImpl();

            switch (action) {
                case "create" -> {
                    // Kiểm tra opportunity không phải Won/Lost
                    Opportunity opp = oppDAO.getById(oppId);
                    if (opp != null && !isLocked(opp.getStage())) {
                        HttpSession session = request.getSession();
                        User user = (User) session.getAttribute("currentUser");
                        int userId = user != null ? user.getId() : 0;

                        String subject = request.getParameter("subject");
                        String grandTotalStr = request.getParameter("grandTotal");
                        String validUntilStr = request.getParameter("validUntil");

                        BigDecimal grandTotal = BigDecimal.ZERO;
                        if (grandTotalStr != null && !grandTotalStr.isEmpty()) {
                            grandTotal = new BigDecimal(grandTotalStr.replace(",", ""));
                        }

                        LocalDate validUntil = null;
                        if (validUntilStr != null && !validUntilStr.isEmpty()) {
                            validUntil = LocalDate.parse(validUntilStr);
                        }

                        int newQuoteId = quoteDAO.create(oppId, subject, grandTotal, validUntil, userId);
                        if (newQuoteId > 0) {
                            String[] productIds = request.getParameterValues("productId");
                            String[] quantities = request.getParameterValues("quantity");
                            String[] unitPrices = request.getParameterValues("unitPrice");
                            
                            if (productIds != null && quantities != null && unitPrices != null) {
                                dao.QuoteDetailDAO qdDAO = new dao.impl.QuoteDetailDAOImpl();
                                for (int i = 0; i < productIds.length; i++) {
                                    if (!productIds[i].trim().isEmpty()) {
                                        model.entity.QuoteDetail qd = new model.entity.QuoteDetail();
                                        qd.setQuoteId(newQuoteId);
                                        qd.setProductId(Integer.parseInt(productIds[i]));
                                        qd.setQuantity(Integer.parseInt(quantities[i]));
                                        qd.setUnitPrice(new BigDecimal(unitPrices[i].replace(",", "")));
                                        qd.setDiscount(BigDecimal.ZERO);
                                        qdDAO.create(qd);
                                    }
                                }
                            }
                        }
                    }
                }
                case "send" -> {
                    if (quoteIdParam != null) {
                        int quoteId = Integer.parseInt(quoteIdParam);
                        // Kiểm tra rule: chỉ 1 Quote Sent tại 1 thời điểm
                        if (!quoteDAO.hasActiveSent(oppId)) {
                            quoteDAO.send(quoteId);
                            request.getSession().setAttribute("successMessage", "Đã gửi báo giá cho Manager duyệt thành công!");
                        } else {
                            // Set error message vào session
                            request.getSession().setAttribute("quoteError",
                                "Đã có báo giá đang được gửi. Không thể gửi báo giá khác.");
                        }
                    }
                }
                case "approve" -> {
                    if (quoteIdParam != null) {
                        int quoteId = Integer.parseInt(quoteIdParam);
                        Quote quote = quoteDAO.getById(quoteId);
                        if (quote != null && "Pending Approval".equals(quote.getStatus())) {
                            quoteDAO.approve(quoteId);
                            request.getSession().setAttribute("successMessage", "Đã duyệt báo giá! Trạng thái chuyển thành Approved.");
                            
                            // Nếu duyệt từ màn hình list chung của Manager -> redirect về List
                            String source = request.getParameter("source");
                            if ("manager-list".equals(source)) {
                                response.sendRedirect(request.getContextPath() + "/manager/quotes");
                                return;
                            }
                        }
                    }
                }
                case "mark_sent" -> {
                    if (quoteIdParam != null) {
                        int quoteId = Integer.parseInt(quoteIdParam);
                        Quote quote = quoteDAO.getById(quoteId);
                        if (quote != null && "Approved".equals(quote.getStatus())) {
                            quoteDAO.markAsSent(quoteId);
                            request.getSession().setAttribute("successMessage", "Đã đánh dấu gửi báo giá cho khách hàng!");
                        }
                    }
                }
                case "accept" -> {
                    if (quoteIdParam != null) {
                        int quoteId = Integer.parseInt(quoteIdParam);
                        Quote quote = quoteDAO.getById(quoteId);
                        if (quote != null && "Sent".equals(quote.getStatus())) {
                            quoteDAO.accept(quoteId, oppId);
                            request.getSession().setAttribute("successMessage", "Khách hàng đã chấp nhận báo giá! Cơ hội thành công.");
                            
                            // Tự động tạo khách hàng khi thắng cơ hội
                            try {
                                dao.CustomerDAO customerDAO = new dao.impl.CustomerDAOImpl();
                                customerDAO.createFromOpportunity(oppId);
                            } catch (Exception ex) {
                                ex.printStackTrace();
                                request.getSession().setAttribute("quoteError", "Đã chấp nhận báo giá nhưng gặp lỗi khi tạo khách hàng: " + ex.getMessage());
                            }
                        }
                    }
                }
                case "reject" -> {
                    if (quoteIdParam != null) {
                        int quoteId = Integer.parseInt(quoteIdParam);
                        String reason = request.getParameter("reason");
                        quoteDAO.reject(quoteId, reason);
                        request.getSession().setAttribute("successMessage", "Đã từ chối báo giá.");

                        // Nếu duyệt từ màn hình list chung của Manager -> redirect về List
                        String source = request.getParameter("source");
                        if ("manager-list".equals(source)) {
                            response.sendRedirect(request.getContextPath() + "/manager/quotes");
                            return;
                        }
                    }
                }
                case "delete" -> {
                    if (quoteIdParam != null) {
                        int quoteId = Integer.parseInt(quoteIdParam);
                        quoteDAO.delete(quoteId);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Luôn redirect về trang detail, tab Quotes
        response.sendRedirect(request.getContextPath()
                + "/sales/opportunity-detail?id=" + oppIdParam + "&tab=quotes");
    }

    private boolean isLocked(String stage) {
        return "Won".equals(stage) || "Lost".equals(stage);
    }
}
