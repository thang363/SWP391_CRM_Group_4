package service.impl;

import dao.AutomationRuleDAO;
import dao.impl.AutomationRuleDAOImpl;
import model.entity.AutomationRule;
import service.AutomationRuleService;

import java.util.List;

public class AutomationRuleServiceImpl implements AutomationRuleService {

    private final AutomationRuleDAO ruleDAO;

    public AutomationRuleServiceImpl() {
        this.ruleDAO = new AutomationRuleDAOImpl();
    }

    @Override
    public List<AutomationRule> findAll() {
        return ruleDAO.findAll();
    }

    @Override
    public AutomationRule findById(int id) {
        return ruleDAO.findById(id);
    }

    @Override
    public boolean create(AutomationRule rule) {
        return ruleDAO.create(rule);
    }

    @Override
    public boolean update(AutomationRule rule) {
        return ruleDAO.update(rule);
    }

    @Override
    public boolean delete(int id) {
        return ruleDAO.delete(id);
    }

    @Override
    public boolean toggleStatus(int id, String status) {
        return ruleDAO.toggleStatus(id, status);
    }
}
