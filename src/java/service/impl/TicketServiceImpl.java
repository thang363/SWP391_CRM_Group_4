package service.impl;

import dao.TicketDAO;
import dao.TicketActivityDAO;
import dao.impl.TicketDAOImpl;
import dao.impl.TicketActivityDAOImpl;
import dao.CustomerDAO;
import dao.impl.CustomerDAOImpl;
import model.entity.Customer;
import model.entity.Ticket;
import service.TicketService;
import java.util.List;

public class TicketServiceImpl implements TicketService {

    private final TicketDAO ticketDAO;
    private final TicketActivityDAO ticketActivityDAO;
    private final CustomerDAO customerDAO;

    public TicketServiceImpl() {
        this.ticketDAO = new TicketDAOImpl();
        this.ticketActivityDAO = new dao.impl.TicketActivityDAOImpl();
        this.customerDAO = new CustomerDAOImpl();
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
        // 1. Update status and note
        boolean success = ticketDAO.updateStatusAndNote(ticketId, "Resolved", note);
        if (success) {
            // Fetch ticket to get customer info
            Ticket ticket = ticketDAO.getTicketById(ticketId);

            // Get Customer Email
            Customer customer = customerDAO.getCustomerById(ticket.getCustomerId());
            String customerEmail = (customer != null && customer.getEmail() != null) ? customer.getEmail() : "";

            if (!customerEmail.isEmpty()) {
                new service.EmailService().sendResolutionEmail(customerEmail, ticket.getCustomerName(), ticketId, note);
            } else {
                // Log warning or handle no-email case properly (e.g. use logger)
            }
        }
        return success;
    }

    @Override
    public boolean processCustomerFeedback(int ticketId, String action) {
        if ("accept".equalsIgnoreCase(action)) {
            return ticketDAO.updateStatus(ticketId, "Closed");
        } else if ("reject".equalsIgnoreCase(action)) {
            boolean success = ticketDAO.updatePriority(ticketId, "High"); // Escalate priority
            if (success) {
                success = ticketDAO.updateStatus(ticketId, "In Progress"); // Re-open
                if (success) {
                    new service.EmailService().sendEscalationEmail("manager@crm.com", ticketId);
                }
            }
            return success;
        }
        return false;
    }
}
