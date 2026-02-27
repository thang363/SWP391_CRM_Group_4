package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Role;
import model.entity.Task;
import service.TaskService;
import service.impl.TaskServiceImpl;
import util.Constants;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MyTasksServlet", urlPatterns = { "/my-tasks" })
public class MyTasksServlet extends HttpServlet {

    private final TaskService taskService;

    public MyTasksServlet() {
        this.taskService = new TaskServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!hasAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        HttpSession session = request.getSession(false);
        int userId = ((Number) session.getAttribute(Constants.SESSION_USER_ID)).intValue();
        Role role = (Role) session.getAttribute(Constants.SESSION_ROLE);

        List<Task> tasks = taskService.getTasksByUser(userId);

        // Đếm thống kê
        long openCount = tasks.stream().filter(t -> "Pending".equals(t.getStatus())).count();
        long inProgressCount = tasks.stream().filter(t -> "Overdue".equals(t.getStatus())).count();
        long doneCount = tasks.stream().filter(t -> "Completed".equals(t.getStatus())).count();

        request.setAttribute("tasks", tasks);
        request.setAttribute("openCount", openCount);
        request.setAttribute("inProgressCount", inProgressCount);
        request.setAttribute("doneCount", doneCount);
        request.setAttribute("currentPage", "my-tasks");
        request.setAttribute("pageTitle", "My Tasks");
        request.getRequestDispatcher("/views/tasks/my-tasks.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!hasAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String action = request.getParameter("action");
        String taskIdStr = request.getParameter("taskId");

        if (taskIdStr != null && !taskIdStr.isEmpty()) {
            int taskId = Integer.parseInt(taskIdStr);

            switch (action != null ? action : "") {
                case "start":
                    taskService.updateTaskStatus(taskId, "Overdue");
                    break;
                case "done":
                    taskService.updateTaskStatus(taskId, "Completed");
                    break;
                case "reopen":
                    taskService.updateTaskStatus(taskId, "Pending");
                    break;
            }
        }

        response.sendRedirect(request.getContextPath() + "/my-tasks");
    }

    private boolean hasAccess(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null)
            return false;
        Role role = (Role) session.getAttribute(Constants.SESSION_ROLE);
        return Role.SUPPORT.equals(role);
    }
}
