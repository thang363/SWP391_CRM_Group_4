package service;

import model.entity.Task;
import java.util.List;

public interface TaskService {
    List<Task> getTasksByUser(int userId);

    List<Task> getAllTasks();

    Task getTaskById(int id);

    int createTask(Task task);

    boolean updateTaskStatus(int taskId, String status);

    boolean completeRenewal(int taskId);

    boolean cancelService(int taskId);

    boolean markCalled(int taskId);

    boolean transferToSales(int taskId);
}
