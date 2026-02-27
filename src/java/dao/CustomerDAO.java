package dao;

import model.entity.Customer;
import java.util.List;

public interface CustomerDAO {
    List<Customer> searchCustomers(String keyword);

    Customer getCustomerById(int id);

    void createFromOpportunity(long opportunityId) throws Exception;

    boolean updateLastCareDate(int id, java.sql.Timestamp date);

    List<Customer> getAllCustomers();

    List<Customer> getCustomers(int offset, int limit, String searchQuery, String tierFilter, String statusFilter);

    int getTotalCustomersCount(String searchQuery, String tierFilter, String statusFilter);

    boolean createCustomer(Customer customer);

    boolean updateCustomer(Customer customer);

    boolean deleteCustomer(int id);

    boolean setCustomerTier(int id, String tier);

    boolean mergeCustomers(int primaryId, int duplicateId);
}
