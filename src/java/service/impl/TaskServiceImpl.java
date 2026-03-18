package service.impl;

import dao.CustomerDAO;
import dao.OpportunityDAO;
import dao.TaskDAO;
import dao.impl.CustomerDAOImpl;
import dao.impl.OpportunitiesDaoImpl;
import dao.impl.TaskDAOImpl;
import model.entity.Customer;
import model.entity.Task;
import service.TaskService;

import java.util.List;

public class TaskServiceImpl implements TaskService {

    private final TaskDAO taskDAO;
    private final CustomerDAO customerDAO;
    private final OpportunityDAO opportunityDAO;

    public TaskServiceImpl() {
        this.taskDAO = new TaskDAOImpl();
        this.customerDAO = new CustomerDAOImpl();
        this.opportunityDAO = new OpportunitiesDaoImpl();
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

    @Override
    public boolean completeRenewal(int taskId) {
        boolean updated = taskDAO.updateStatus(taskId, "Completed");
        if (updated) {
            Task task = taskDAO.findById(taskId);
            if (task != null && "Customer".equals(task.getRelatedToEntity()) && task.getRelatedRecordId() != null) {
                customerDAO.updateLastCareDate(task.getRelatedRecordId(),
                        new java.sql.Timestamp(System.currentTimeMillis()));
            }
        }
        return updated;
    }

    @Override
    public boolean cancelService(int taskId) {
        boolean updated = taskDAO.updateStatus(taskId, "Completed");
        if (updated) {
            Task task = taskDAO.findById(taskId);
            if (task != null && "Customer".equals(task.getRelatedToEntity()) && task.getRelatedRecordId() != null) {
                customerDAO.updateCustomerStatus(task.getRelatedRecordId(), "Inactive");
            }
        }
        return updated;
    }

    @Override
    public boolean markCalled(int taskId) {
        boolean updated = taskDAO.updateStatus(taskId, "Completed");
        if (updated) {
            Task task = taskDAO.findById(taskId);
            if (task != null && "Customer".equals(task.getRelatedToEntity()) && task.getRelatedRecordId() != null) {
                customerDAO.updateLastCareDate(task.getRelatedRecordId(),
                        new java.sql.Timestamp(System.currentTimeMillis()));
            }
        }
        return updated;
    }

    @Override
    public boolean transferToSales(int taskId) {
        Task task = taskDAO.findById(taskId);
        if (task == null || !"Customer".equals(task.getRelatedToEntity()) || task.getRelatedRecordId() == null) {
            return false;
        }

        Customer customer = customerDAO.getCustomerById(task.getRelatedRecordId());
        if (customer == null || customer.getAssignedTo() == null) {
            return false;
        }

        // Tạo Opportunity gán cho Sales đã assigned_to trong Customers
        opportunityDAO.createFromCustomer(
                customer.getId(),
                customer.getCompanyName(),
                customer.getAssignedTo()
        );

        // Hoàn thành task
        taskDAO.updateStatus(taskId, "Completed");

        // Cập nhật last_care_date
        customerDAO.updateLastCareDate(customer.getId(),
                new java.sql.Timestamp(System.currentTimeMillis()));

        return true;
    }
}

