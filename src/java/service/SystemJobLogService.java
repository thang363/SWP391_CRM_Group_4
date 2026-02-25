package service;

import model.entity.SystemJobLog;
import java.util.List;

public interface SystemJobLogService {
    List<SystemJobLog> findAll();

    SystemJobLog findById(int id);

    boolean create(SystemJobLog log);
}
