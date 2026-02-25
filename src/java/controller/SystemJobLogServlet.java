package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Role;
import model.entity.SystemJobLog;
import service.SystemJobLogService;
import service.impl.SystemJobLogServiceImpl;
import util.Constants;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SystemJobLogServlet", urlPatterns = { "/system-job-logs" })
public class SystemJobLogServlet extends HttpServlet {

    private final SystemJobLogService logService;

    public SystemJobLogServlet() {
        this.logService = new SystemJobLogServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isManager(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        List<SystemJobLog> logs = logService.findAll();
        request.setAttribute("logs", logs);
        request.setAttribute("currentPage", "system-job-logs");
        request.setAttribute("pageTitle", "System Job Logs");
        request.getRequestDispatcher("/views/automation/system-job-logs.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isManager(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String action = request.getParameter("action");
        if ("runNow".equals(action)) {
            // Chạy automation rules ngay lập tức
            scheduler.AutomationJobRunner runner = new scheduler.AutomationJobRunner();
            runner.run();
        }

        response.sendRedirect(request.getContextPath() + "/system-job-logs");
    }

    private boolean isManager(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null)
            return false;
        Role role = (Role) session.getAttribute(Constants.SESSION_ROLE);
        return Role.MANAGER.equals(role);
    }
}
