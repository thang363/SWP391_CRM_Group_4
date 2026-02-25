package dao;

import model.entity.SystemJobLog;
import java.util.List;

public interface SystemJobLogDAO {
    List<SystemJobLog> findAll();

    SystemJobLog findById(int id);

    boolean create(SystemJobLog log);
}
