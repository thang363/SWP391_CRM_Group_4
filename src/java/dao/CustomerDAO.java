package dao;

import model.entity.Customer;
import java.util.List;

public interface CustomerDAO {
    List<Customer> searchCustomers(String keyword);

    Customer getCustomerById(int id);

    void createFromOpportunity(long opportunityId) throws Exception;
}
