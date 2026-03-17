package controller.customer;

import dao.AttachmentDAO;
import dao.impl.AttachmentDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.entity.Attachment;
import model.entity.TicketVerificationToken;
import service.TicketService;
import service.impl.TicketServiceImpl;
import util.Constants;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.Collection;

/*
  Xử lý phản hồi của khách hàng thông qua token bảo mật được gửi qua email.
  - GET: accept → xử lý ngay; reject → hiển thị form nhập lý do + upload file
  - POST: nhận form reject kèm file đính kèm
*/
@WebServlet(name = "TicketVerifyServlet", urlPatterns = { "/ticket-verify" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 10 * 1024 * 1024, // 10 MB
        maxRequestSize = 50 * 1024 * 1024 // 50 MB
)
public class TicketVerifyServlet extends HttpServlet {

    private final TicketService ticketService;
    private final AttachmentDAO attachmentDAO;

    public TicketVerifyServlet() {
        this.ticketService = new TicketServiceImpl();
        this.attachmentDAO = new AttachmentDAOImpl();
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

        // Nếu accept → xử lý ngay
        if ("accept".equalsIgnoreCase(decision)) {
            String result = ticketService.processCustomerFeedbackByToken(token.trim(), "accept", null);
            renderResultPage(out, result);
            return;
        }

        // Nếu reject → kiểm tra token hợp lệ trước, sau đó hiển thị form
        // (Không đánh dấu token đã dùng tại bước này)
        dao.TicketVerificationTokenDAO tokenDAO = new dao.impl.TicketVerificationTokenDAOImpl();
        TicketVerificationToken tvt = tokenDAO.findByToken(token.trim());

        if (tvt == null) {
            renderPage(out, "Lỗi", "#e53935",
                    "Liên kết không hợp lệ hoặc đã xảy ra lỗi hệ thống.",
                    "Vui lòng liên hệ bộ phận hỗ trợ để được trợ giúp.");
            return;
        }
        if (tvt.isUsed()) {
            renderPage(out, "Liên kết đã được sử dụng", "#757575",
                    "Liên kết này đã được dùng trước đó.",
                    "Phản hồi của bạn đã được ghi nhận. Nếu có thắc mắc, vui lòng liên hệ trực tiếp với bộ phận hỗ trợ.");
            return;
        }
        if (!tvt.isValid()) {
            renderPage(out, "Liên kết đã hết hạn ⏰", "#757575",
                    "Liên kết xác nhận đã hết hạn (sau 72 giờ).",
                    "Vui lòng liên hệ bộ phận hỗ trợ để được xử lý thủ công.");
            return;
        }

        // Token hợp lệ → hiển thị form từ chối
        renderRejectionForm(out, token.trim());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String token = request.getParameter("token");
        String rejectionReason = request.getParameter("rejectionReason");

        // Validate
        if (token == null || token.trim().isEmpty()) {
            renderPage(out, "Lỗi", "#e53935",
                    "Liên kết không hợp lệ.",
                    "Vui lòng kiểm tra lại đường dẫn từ email hoặc liên hệ bộ phận hỗ trợ.");
            return;
        }

        if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
            renderPage(out, "Lỗi", "#e53935",
                    "Vui lòng nhập lý do từ chối.",
                    "Bạn cần cho chúng tôi biết vấn đề còn tồn tại để chúng tôi hỗ trợ tốt hơn.");
            return;
        }

        // Xử lý rejection qua service (validate token, update DB)
        String result = ticketService.processCustomerFeedbackByToken(token.trim(), "reject", rejectionReason.trim());

        if ("rejected".equals(result)) {
            // Lấy ticketId từ token để lưu attachment
            dao.TicketVerificationTokenDAO tokenDAO = new dao.impl.TicketVerificationTokenDAOImpl();
            TicketVerificationToken tvt = tokenDAO.findByToken(token.trim());
            int ticketId = (tvt != null) ? tvt.getTicketId() : 0;

            // Xử lý file upload
            if (ticketId > 0) {
                try {
                    Collection<Part> parts = request.getParts();
                    for (Part part : parts) {
                        if ("attachments".equals(part.getName()) && part.getSize() > 0) {
                            String fileName = getSubmittedFileName(part);
                            if (fileName != null && !fileName.isEmpty()) {
                                // Tạo thư mục upload
                                String uploadDir = getServletContext().getRealPath("")
                                        + File.separator + Constants.UPLOAD_DIRECTORY
                                        + File.separator + "ticket_rejections";
                                File dir = new File(uploadDir);
                                if (!dir.exists()) {
                                    dir.mkdirs();
                                }

                                // Tạo tên file unique
                                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                                String filePath = uploadDir + File.separator + uniqueFileName;
                                part.write(filePath);

                                // Lưu vào DB
                                Attachment attachment = new Attachment();
                                attachment.setFileName(fileName);
                                attachment.setFilePath(
                                        Constants.UPLOAD_DIRECTORY + "/ticket_rejections/" + uniqueFileName);
                                attachment.setFileSize(part.getSize());
                                attachment.setUploadedBy(null); // Khách hàng không có account
                                attachment.setRelatedToEntity("TicketRejection");
                                attachment.setRelatedRecordId(ticketId);
                                attachmentDAO.saveAttachment(attachment);
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    // Không fail cả request vì lý do đã được lưu
                    System.err.println("Warning: Could not save rejection attachments for ticket #" + ticketId);
                }
            }
        }

        renderResultPage(out, result);
    }

    /**
     * Render trang kết quả dựa trên result code
     */
    private void renderResultPage(PrintWriter out, String result) {
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
     * Render form từ chối - cho khách nhập lý do và upload file
     */
    private void renderRejectionForm(PrintWriter out, String token) {
        out.println("<!DOCTYPE html>");
        out.println("<html lang='vi'>");
        out.println("<head>");
        out.println("  <meta charset='UTF-8'>");
        out.println("  <meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("  <title>Phản hồi từ chối - CRM Support</title>");
        out.println("  <style>");
        out.println("    * { box-sizing: border-box; margin: 0; padding: 0; }");
        out.println(
                "    body { font-family: 'Segoe UI', Arial, sans-serif; background: #f5f5f5; display: flex; align-items: center; justify-content: center; min-height: 100vh; padding: 20px; }");
        out.println(
                "    .card { background: #fff; border-radius: 12px; box-shadow: 0 4px 24px rgba(0,0,0,0.10); padding: 40px; max-width: 560px; width: 100%; }");
        out.println(
                "    .title { font-size: 24px; font-weight: 700; color: #fb8c00; margin-bottom: 8px; text-align: center; }");
        out.println(
                "    .subtitle { font-size: 15px; color: #666; margin-bottom: 24px; text-align: center; line-height: 1.5; }");
        out.println("    .form-group { margin-bottom: 20px; }");
        out.println(
                "    .form-group label { display: block; font-weight: 600; color: #333; margin-bottom: 6px; font-size: 14px; }");
        out.println("    .form-group label .required { color: #e53935; }");
        out.println(
                "    textarea { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; font-family: inherit; resize: vertical; min-height: 120px; transition: border-color 0.2s; }");
        out.println(
                "    textarea:focus { outline: none; border-color: #fb8c00; box-shadow: 0 0 0 3px rgba(251,140,0,0.15); }");
        out.println("    .file-input-wrapper { position: relative; }");
        out.println(
                "    input[type='file'] { width: 100%; padding: 10px; border: 2px dashed #ddd; border-radius: 8px; font-size: 14px; cursor: pointer; background: #fafafa; }");
        out.println("    input[type='file']:hover { border-color: #fb8c00; background: #fff8f0; }");
        out.println("    .file-hint { font-size: 12px; color: #999; margin-top: 4px; }");
        out.println(
                "    .btn-submit { width: 100%; padding: 14px; background: #fb8c00; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background 0.2s; }");
        out.println("    .btn-submit:hover { background: #f57c00; }");
        out.println("    .btn-submit:disabled { background: #ccc; cursor: not-allowed; }");
        out.println("    .divider { border: none; border-top: 1px solid #eee; margin: 24px 0; }");
        out.println("    .footer { font-size: 13px; color: #aaa; text-align: center; }");
        out.println("    .error-msg { color: #e53935; font-size: 13px; margin-top: 4px; display: none; }");
        out.println("  </style>");
        out.println("</head>");
        out.println("<body>");
        out.println("  <div class='card'>");
        out.println("    <div class='title'>Phản hồi từ chối 🔄</div>");
        out.println(
                "    <div class='subtitle'>Vui lòng cho chúng tôi biết vấn đề còn tồn tại để chúng tôi hỗ trợ bạn tốt hơn.</div>");
        out.println(
                "    <form method='POST' action='ticket-verify' enctype='multipart/form-data' onsubmit='return validateForm()'>");
        out.println("      <input type='hidden' name='token' value='" + escapeHtml(token) + "'>");
        out.println("      <div class='form-group'>");
        out.println("        <label>Lý do từ chối <span class='required'>*</span></label>");
        out.println(
                "        <textarea name='rejectionReason' id='rejectionReason' placeholder='Mô tả chi tiết vấn đề bạn gặp phải, ví dụ: lỗi vẫn còn xuất hiện, giải pháp không đúng...'></textarea>");
        out.println("        <div class='error-msg' id='reasonError'>Vui lòng nhập lý do từ chối.</div>");
        out.println("      </div>");
        out.println("      <div class='form-group'>");
        out.println("        <label>File đính kèm (tùy chọn)</label>");
        out.println("        <div class='file-input-wrapper'>");
        out.println(
                "          <input type='file' name='attachments' multiple accept='image/*,.pdf,.doc,.docx,.zip,.rar,.txt,.xlsx,.xls'>");
        out.println("        </div>");
        out.println("        <div class='file-hint'>Hỗ trợ: ảnh, PDF, Word, Excel, ZIP. Tối đa 10MB/file.</div>");
        out.println("      </div>");
        out.println("      <button type='submit' class='btn-submit' id='submitBtn'>📨 Gửi phản hồi</button>");
        out.println("    </form>");
        out.println("    <hr class='divider'>");
        out.println("    <p class='footer'>CRM Support System &mdash; Hệ thống hỗ trợ khách hàng nội bộ</p>");
        out.println("  </div>");
        out.println("  <script>");
        out.println("    function validateForm() {");
        out.println("      var reason = document.getElementById('rejectionReason').value.trim();");
        out.println("      var errorEl = document.getElementById('reasonError');");
        out.println("      if (!reason) {");
        out.println("        errorEl.style.display = 'block';");
        out.println("        document.getElementById('rejectionReason').focus();");
        out.println("        return false;");
        out.println("      }");
        out.println("      errorEl.style.display = 'none';");
        out.println("      document.getElementById('submitBtn').disabled = true;");
        out.println("      document.getElementById('submitBtn').textContent = 'Đang gửi...';");
        out.println("      return true;");
        out.println("    }");
        out.println("  </script>");
        out.println("</body>");
        out.println("</html>");
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

    private String getSubmittedFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null)
            return null;
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                // Handle IE full path
                return Paths.get(name).getFileName().toString();
            }
        }
        return null;
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
