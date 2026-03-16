package controller.system;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;

import util.Constants;
import model.entity.Role;
import service.TaskService;
import service.impl.TaskServiceImpl;
import service.TicketService;
import service.impl.TicketServiceImpl;
import service.MarketingDashboardService;
import service.impl.MarketingDashboardServiceImpl;
import model.viewmodel.MarketingDashboardVM;
import model.entity.Task;
import model.entity.Ticket;
import java.util.List;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DashboardServlet", urlPatterns = { "/dashboard" })
public class DashboardServlet extends HttpServlet {

    private final TaskService taskService = new TaskServiceImpl();
    private final TicketService ticketService = new TicketServiceImpl();
    private final MarketingDashboardService marketingDashboardService = new MarketingDashboardServiceImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            Role role = (Role) session.getAttribute(Constants.SESSION_ROLE);

            if (Role.SUPPORT.equals(role)) {
                int userId = ((Number) session.getAttribute(Constants.SESSION_USER_ID)).intValue();

                // Tasks stats
                List<Task> tasks = taskService.getTasksByUser(userId);
                long pendingTasks = tasks.stream().filter(t -> "Pending".equals(t.getStatus())).count();
                long overdueTasks = tasks.stream().filter(t -> "Overdue".equals(t.getStatus())).count();

                // Tickets stats
                List<Ticket> tickets = ticketService.getAllTickets(); // Cần bộ lọc tốt hơn nhưng hiện tại lọc thủ công
                long openTickets = tickets.stream()
                        .filter(t -> t.getAssignedTo() != null && t.getAssignedTo().equals(userId) &&
                                ("Open".equals(t.getStatus()) || "In Progress".equals(t.getStatus())))
                        .count();
                long resolvedTickets = tickets.stream()
                        .filter(t -> t.getAssignedTo() != null && t.getAssignedTo().equals(userId) &&
                                ("Resolved".equals(t.getStatus()) || "Closed".equals(t.getStatus())))
                        .count();

                request.setAttribute("supportPendingTasks", pendingTasks);
                request.setAttribute("supportOverdueTasks", overdueTasks);
                request.setAttribute("supportOpenTickets", openTickets);
                request.setAttribute("supportResolvedTickets", resolvedTickets);
            } else if (Role.MANAGER.equals(role) || Role.MARKETING.equals(role)) {
                int userId = ((Number) session.getAttribute(Constants.SESSION_USER_ID)).intValue();
                MarketingDashboardVM stats = marketingDashboardService.getDashboardData(userId);
                request.setAttribute("stats", stats);
            }
        }

        request.setAttribute("pageTitle", "Dashboard");

        RequestDispatcher dispatcher = request.getRequestDispatcher(Constants.PAGE_DASHBOARD);
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
