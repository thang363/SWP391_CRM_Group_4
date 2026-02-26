package service.impl;

import dao.TaskDAO;
import dao.impl.TaskDAOImpl;
import model.entity.Task;
import service.TaskService;

import java.util.List;

public class TaskServiceImpl implements TaskService {

    private final TaskDAO taskDAO;
    private final dao.CustomerDAO customerDAO;

    public TaskServiceImpl() {
        this.taskDAO = new TaskDAOImpl();
        this.customerDAO = new dao.impl.CustomerDAOImpl();
    }

    @Override
    public List<Task> getTasksByUser(int userId) {
        return taskDAO.findByUser(userId);
    }

    @Override
    public List<Task> getAllTasks() {
        return taskDAO.findAll();
    }

    @Override
    public Task getTaskById(int id) {
        return taskDAO.findById(id);
    }

    @Override
    public int createTask(Task task) {
        return taskDAO.create(task);
    }

    @Override
    public boolean updateTaskStatus(int taskId, String status) {
        boolean updated = taskDAO.updateStatus(taskId, status);

        // Nếu task được hoàn thành, tự động update last_care_date cho khách hàng liên
        // quan
        if (updated && "Completed".equals(status)) {
            Task task = taskDAO.findById(taskId);
            if (task != null && "Customer".equals(task.getRelatedToEntity()) && task.getRelatedRecordId() != null) {
                customerDAO.updateLastCareDate(task.getRelatedRecordId(),
                        new java.sql.Timestamp(System.currentTimeMillis()));
            }
        }

        return updated;
    }
}
