package dao;

import model.entity.AutomationRule;
import java.util.List;

public interface AutomationRuleDAO {
    List<AutomationRule> findAll();

    AutomationRule findById(int id);

    boolean create(AutomationRule rule);

    boolean update(AutomationRule rule);

    boolean delete(int id);

    boolean toggleStatus(int id, String status);
}
