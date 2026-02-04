package dao;

import model.entity.TicketActivity;
import java.util.List;

public interface TicketActivityDAO {
    List<TicketActivity> getActivitiesByTicketId(int ticketId);

    boolean addActivity(TicketActivity activity);
}
