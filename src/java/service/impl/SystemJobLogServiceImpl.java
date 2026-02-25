package service.impl;

import dao.SystemJobLogDAO;
import dao.impl.SystemJobLogDAOImpl;
import model.entity.SystemJobLog;
import service.SystemJobLogService;

import java.util.List;

public class SystemJobLogServiceImpl implements SystemJobLogService {

    private final SystemJobLogDAO dao;

    public SystemJobLogServiceImpl() {
        this.dao = new SystemJobLogDAOImpl();
    }

    @Override
    public List<SystemJobLog> findAll() {
        return dao.findAll();
    }

    @Override
    public SystemJobLog findById(int id) {
        return dao.findById(id);
    }

    @Override
    public boolean create(SystemJobLog log) {
        return dao.create(log);
    }
}
