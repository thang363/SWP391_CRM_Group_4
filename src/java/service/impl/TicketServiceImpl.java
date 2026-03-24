package service.impl;

import dao.TicketDAO;
import dao.TicketActivityDAO;
import dao.TicketVerificationTokenDAO;
import dao.impl.TicketDAOImpl;
import dao.impl.TicketActivityDAOImpl;
import dao.impl.TicketVerificationTokenDAOImpl;
import dao.CustomerDAO;
import dao.impl.CustomerDAOImpl;
import model.entity.Customer;
import model.entity.Ticket;
import model.entity.TicketVerificationToken;
import service.TicketService;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public class TicketServiceImpl implements TicketService {

    private final TicketDAO ticketDAO;
    private final TicketActivityDAO ticketActivityDAO;
    private final CustomerDAO customerDAO;
    private final TicketVerificationTokenDAO tokenDAO;

    public TicketServiceImpl() {
        this.ticketDAO = new TicketDAOImpl();
        this.ticketActivityDAO = new TicketActivityDAOImpl();
        this.customerDAO = new CustomerDAOImpl();
        this.tokenDAO = new TicketVerificationTokenDAOImpl();
    }

    @Override
    public List<Ticket> getAllTickets() {
        return ticketDAO.getAllTickets();
    }

    @Override
    public List<Ticket> searchTickets(String keyword, String status, String priority, Integer assignedTo,
            boolean isUnassigned) {
        return ticketDAO.searchTickets(keyword, status, priority, assignedTo, isUnassigned);
    }

    @Override
    public Ticket getTicketById(int id) {
        return ticketDAO.getTicketById(id);
    }

    @Override
    public int createTicket(Ticket ticket) {
        return ticketDAO.createTicket(ticket);
    }

    @Override
    public boolean updateStatus(int ticketId, String status) {
        return ticketDAO.updateStatus(ticketId, status);
    }

    @Override
    public boolean updatePriority(int ticketId, String priority) {
        return ticketDAO.updatePriority(ticketId, priority);
    }

    @Override
    public boolean assignTicket(int ticketId, Integer userId) {
        return ticketDAO.assignTicket(ticketId, userId);
    }

    @Override
    public List<model.entity.TicketActivity> getActivitiesByTicketId(int ticketId) {
        return ticketActivityDAO.getActivitiesByTicketId(ticketId);
    }

    @Override
    public boolean addActivity(model.entity.TicketActivity activity) {
        return ticketActivityDAO.addActivity(activity);
    }

    @Override
    public boolean resolveTicket(int ticketId, String note) {
        // 1. Cập nhật trạng thái và ghi chú giải pháp
        boolean success = ticketDAO.updateStatusAndNote(ticketId, "Resolved", note);
        if (success) {
            Ticket ticket = ticketDAO.getTicketById(ticketId);
            Customer customer = customerDAO.getCustomerById(ticket.getCustomerId());
            String customerEmail = (customer != null && customer.getEmail() != null) ? customer.getEmail() : "";

            if (!customerEmail.isEmpty()) {
                // 2. Sinh token xác nhận mới, hết hạn sau 72 giờ
                String token = generateVerificationToken(ticketId);
                if (token != null) {
                    service.EmailService.sendResolutionEmailAsync(
                            customerEmail, ticket.getCustomerName(), ticketId, note, token);
                } else {
                    System.err.println("Warning: Could not generate verification token for ticket #" + ticketId);
                }
            }
        }
        return success;
    }

    @Override
    public String generateVerificationToken(int ticketId) {
        try {
            String token = UUID.randomUUID().toString();
            // Token hết hạn sau 72 giờ
            long expiryMillis = System.currentTimeMillis() + (72L * 60 * 60 * 1000);
            Date expiresAt = new Date(expiryMillis);
            boolean saved = tokenDAO.saveToken(ticketId, token, expiresAt);
            return saved ? token : null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public String processCustomerFeedbackByToken(String token, String decision, String rejectionReason) {
        if (token == null || token.trim().isEmpty()) {
            return "invalid";
        }

        TicketVerificationToken tvt = tokenDAO.findByToken(token);

        if (tvt == null) {
            return "invalid";
        }
        if (tvt.isUsed()) {
            return "already_used";
        }
        if (!tvt.isValid()) {
            return "expired";
        }

        int ticketId = tvt.getTicketId();

        // Đánh dấu token đã dùng trước để tránh race condition
        boolean marked = tokenDAO.markAsUsed(token);
        if (!marked) {
            return "invalid";
        }

        if ("accept".equalsIgnoreCase(decision)) {
            ticketDAO.updateStatus(ticketId, "Closed");
            return "accepted";
        } else if ("reject".equalsIgnoreCase(decision)) {
            // Lưu lý do từ chối
            if (rejectionReason != null && !rejectionReason.trim().isEmpty()) {
                ticketDAO.updateRejectionReason(ticketId, rejectionReason.trim());
            }
            ticketDAO.updatePriority(ticketId, "High");
            ticketDAO.updateStatus(ticketId, "In Progress");
            service.EmailService.sendEscalationEmailAsync("manager@crm.com", ticketId);
            return "rejected";
        }

        return "invalid";
    }
}
