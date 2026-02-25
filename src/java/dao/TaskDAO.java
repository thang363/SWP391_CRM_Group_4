package dao;

import model.entity.Task;
import java.util.List;

public interface TaskDAO {
    List<Task> findByUser(int userId);

    List<Task> findAll();

    Task findById(int id);

    int create(Task task);

    boolean updateStatus(int taskId, String status);
}
