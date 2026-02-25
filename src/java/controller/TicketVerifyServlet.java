package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.TicketService;
import service.impl.TicketServiceImpl;

import java.io.IOException;
import java.io.PrintWriter;

/*
  Xử lý phản hồi của khách hàng thông qua token bảo mật được gửi qua email.
*/
@WebServlet(name = "TicketVerifyServlet", urlPatterns = { "/ticket-verify" })
public class TicketVerifyServlet extends HttpServlet {

    private final TicketService ticketService;

    public TicketVerifyServlet() {
        this.ticketService = new TicketServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        String decision = request.getParameter("decision");

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Validate params tối thiểu
        if (token == null || token.trim().isEmpty()
                || decision == null || decision.trim().isEmpty()) {
            renderPage(out, "Lỗi", "#e53935",
                    "Liên kết không hợp lệ.",
                    "Vui lòng kiểm tra lại đường dẫn từ email hoặc liên hệ bộ phận hỗ trợ.");
            return;
        }

        if (!"accept".equalsIgnoreCase(decision) && !"reject".equalsIgnoreCase(decision)) {
            renderPage(out, "Lỗi", "#e53935",
                    "Hành động không hợp lệ.",
                    "Vui lòng sử dụng đúng đường dẫn từ email.");
            return;
        }

        String result = ticketService.processCustomerFeedbackByToken(token.trim(), decision.trim());

        switch (result) {
            case "accepted":
                renderPage(out, "Cảm ơn bạn! ✅", "#43a047",
                        "Ticket đã được đóng thành công.",
                        "Chúng tôi rất vui vì vấn đề của bạn đã được giải quyết. Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!");
                break;
            case "rejected":
                renderPage(out, "Đã ghi nhận phản hồi 🔄", "#fb8c00",
                        "Yêu cầu xem xét lại đã được ghi nhận.",
                        "Chúng tôi đã thông báo cho bộ phận phụ trách và sẽ xử lý lại sự cố của bạn trong thời gian sớm nhất.");
                break;
            case "already_used":
                renderPage(out, "Liên kết đã được sử dụng", "#757575",
                        "Liên kết này đã được dùng trước đó.",
                        "Phản hồi của bạn đã được ghi nhận. Nếu có thắc mắc, vui lòng liên hệ trực tiếp với bộ phận hỗ trợ.");
                break;
            case "expired":
                renderPage(out, "Liên kết đã hết hạn ⏰", "#757575",
                        "Liên kết xác nhận đã hết hạn (sau 72 giờ).",
                        "Vui lòng liên hệ bộ phận hỗ trợ để được xử lý thủ công.");
                break;
            default:
                renderPage(out, "Lỗi", "#e53935",
                        "Liên kết không hợp lệ hoặc đã xảy ra lỗi hệ thống.",
                        "Vui lòng liên hệ bộ phận hỗ trợ để được trợ giúp.");
                break;
        }
    }

    /**
     * Render trang kết quả đẹp, thân thiện với khách hàng
     */
    private void renderPage(PrintWriter out, String title, String color, String heading, String message) {
        out.println("<!DOCTYPE html>");
        out.println("<html lang='vi'>");
        out.println("<head>");
        out.println("  <meta charset='UTF-8'>");
        out.println("  <meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("  <title>Phản hồi Ticket - CRM Support</title>");
        out.println("  <style>");
        out.println("    * { box-sizing: border-box; margin: 0; padding: 0; }");
        out.println(
                "    body { font-family: 'Segoe UI', Arial, sans-serif; background: #f5f5f5; display: flex; align-items: center; justify-content: center; min-height: 100vh; }");
        out.println(
                "    .card { background: #fff; border-radius: 12px; box-shadow: 0 4px 24px rgba(0,0,0,0.10); padding: 48px 40px; max-width: 480px; width: 100%; text-align: center; }");
        out.println("    .icon { font-size: 56px; margin-bottom: 16px; }");
        out.println("    .title { font-size: 24px; font-weight: 700; color: " + color + "; margin-bottom: 12px; }");
        out.println("    .heading { font-size: 16px; font-weight: 600; color: #333; margin-bottom: 10px; }");
        out.println("    .message { font-size: 15px; color: #666; line-height: 1.6; }");
        out.println("    .divider { border: none; border-top: 1px solid #eee; margin: 28px 0; }");
        out.println("    .footer { font-size: 13px; color: #aaa; }");
        out.println("  </style>");
        out.println("</head>");
        out.println("<body>");
        out.println("  <div class='card'>");
        out.println("    <div class='title'>" + escapeHtml(title) + "</div>");
        out.println("    <div class='heading'>" + escapeHtml(heading) + "</div>");
        out.println("    <p class='message'>" + escapeHtml(message) + "</p>");
        out.println("    <hr class='divider'>");
        out.println("    <p class='footer'>CRM Support System &mdash; Hệ thống hỗ trợ khách hàng nội bộ</p>");
        out.println("  </div>");
        out.println("</body>");
        out.println("</html>");
    }

    private String escapeHtml(String s) {
        if (s == null)
            return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }
}
