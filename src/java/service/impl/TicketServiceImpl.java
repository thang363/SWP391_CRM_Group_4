package service.impl;

import dao.TicketDAO;
import dao.TicketActivityDAO;
import dao.impl.TicketDAOImpl;
import dao.impl.TicketActivityDAOImpl;
import model.entity.Ticket;
import service.TicketService;
import java.util.List;

public class TicketServiceImpl implements TicketService {

    private final TicketDAO ticketDAO;
    private final TicketActivityDAO ticketActivityDAO;

    public TicketServiceImpl() {
        this.ticketDAO = new TicketDAOImpl();
        this.ticketActivityDAO = new dao.impl.TicketActivityDAOImpl();
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
}
