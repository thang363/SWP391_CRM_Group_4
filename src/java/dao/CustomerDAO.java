package dao;

import model.entity.Customer;
import java.util.List;

public interface CustomerDAO {
    List<Customer> searchCustomers(String keyword);

    Customer getCustomerById(int id);

    boolean updateLastCareDate(int id, java.sql.Timestamp date);
}
