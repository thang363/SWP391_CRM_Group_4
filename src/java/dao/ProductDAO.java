package dao;

import java.util.List;
import model.entity.Product;

public interface ProductDAO {
    List<Product> getAllActiveProducts();
    Product getById(int id);
}
