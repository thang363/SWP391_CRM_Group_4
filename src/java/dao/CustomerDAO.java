package dao;

import model.entity.Customer;
import java.util.List;

public interface CustomerDAO {
    List<Customer> searchCustomers(String keyword);

    Customer getCustomerById(int id);
    
    Customer findCustomerByEmail(String email);

    void createFromOpportunity(int opportunityId) throws Exception;

    boolean updateLastCareDate(int id, java.sql.Timestamp date);

    List<Customer> getAllCustomers();

    List<Customer> getCustomers(int offset, int limit, String searchQuery, String tierFilter, String statusFilter);

    int getTotalCustomersCount(String searchQuery, String tierFilter, String statusFilter);

    List<Customer> getCustomersBySalesId(int salesId, int offset, int limit, String searchQuery, String tierFilter, String statusFilter);

    int getTotalCustomersCountBySalesId(int salesId, String searchQuery, String tierFilter, String statusFilter);

    boolean createCustomer(Customer customer);

    boolean updateCustomer(Customer customer);

    boolean deleteCustomer(int id);

    boolean setCustomerTier(int id, String tier);

    boolean mergeCustomers(int primaryId, int duplicateId);
}
