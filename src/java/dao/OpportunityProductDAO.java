package dao;

import java.util.List;
import model.entity.OpportunityProduct;

public interface OpportunityProductDAO {
    void create(OpportunityProduct op);
    List<OpportunityProduct> getByOpportunityId(int oppId);
    void delete(int id);
}
