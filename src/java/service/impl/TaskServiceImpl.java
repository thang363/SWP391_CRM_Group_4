package service.impl;

import dao.TaskDAO;
import dao.impl.TaskDAOImpl;
import model.entity.Task;
import service.TaskService;

import java.util.List;

public class TaskServiceImpl implements TaskService {

    private final TaskDAO taskDAO;

    public TaskServiceImpl() {
        this.taskDAO = new TaskDAOImpl();
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
        return taskDAO.updateStatus(taskId, status);
    }
}
