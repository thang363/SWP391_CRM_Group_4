package dao;

import model.entity.Ticket;
import java.util.List;

public interface TicketDAO {
    List<Ticket> getAllTickets();

    List<Ticket> searchTickets(String keyword, String status, String priority, Integer assignedTo,
            boolean isUnassigned);

    Ticket getTicketById(int id);

    int createTicket(Ticket ticket);

    boolean updateStatus(int ticketId, String status);

    boolean updatePriority(int ticketId, String priority);

    boolean assignTicket(int ticketId, Integer userId);
}
