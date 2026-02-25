package scheduler;

import dao.AutomationRuleDAO;
import dao.SystemJobLogDAO;
import dao.impl.AutomationRuleDAOImpl;
import dao.impl.SystemJobLogDAOImpl;
import model.entity.AutomationRule;
import model.entity.SystemJobLog;
import model.entity.Ticket;
import service.TicketService;
import service.impl.TicketServiceImpl;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Logic chạy automation rules hàng đêm:
 * 1) Lấy tất cả rules Active
 * 2) Với mỗi rule → query customers phù hợp điều kiện
 * 3) Tạo Ticket (task) cho nhân viên Support
 * 4) Ghi log vào SystemJobLogs
 */
public class AutomationJobRunner implements Runnable {

    private static final Logger LOG = Logger.getLogger(AutomationJobRunner.class.getName());

    private final AutomationRuleDAO ruleDAO;
    private final SystemJobLogDAO jobLogDAO;
    private final TicketService ticketService;
    private final DatabaseUtil dbUtil;

    public AutomationJobRunner() {
        this.ruleDAO = new AutomationRuleDAOImpl();
        this.jobLogDAO = new SystemJobLogDAOImpl();
        this.ticketService = new TicketServiceImpl();
        this.dbUtil = DatabaseUtil.getInstance();
    }

    @Override
    public void run() {
        LOG.info("[AutomationJobRunner] ====== BẮT ĐẦU CHẠY AUTOMATION RULES ======");

        List<AutomationRule> rules = ruleDAO.findAll();
        int activeCount = 0;

        for (AutomationRule rule : rules) {
            if (!"Active".equals(rule.getStatus())) {
                continue;
            }
            activeCount++;
            executeRule(rule);
        }

        LOG.info("[AutomationJobRunner] ====== HOÀN THÀNH. Đã chạy " + activeCount + " rules ======");
    }

    private void executeRule(AutomationRule rule) {
        Timestamp executionTime = new Timestamp(System.currentTimeMillis());
        SystemJobLog jobLog = new SystemJobLog();
        jobLog.setRuleId(rule.getId());
        jobLog.setExecutionTime(executionTime);

        try {
            // 1) Tìm customers thoả mãn điều kiện
            List<Integer> matchedCustomerIds = findMatchingCustomers(rule);

            if (matchedCustomerIds.isEmpty()) {
                jobLog.setStatus("Success");
                jobLog.setRecordsCreated(0);
                jobLogDAO.create(jobLog);
                LOG.info("[Rule: " + rule.getRuleName() + "] Không có khách hàng phù hợp.");
                return;
            }

            // 2) Tạo ticket cho mỗi customer
            int created = 0;
            for (int customerId : matchedCustomerIds) {
                boolean ok = createTicketForCustomer(rule, customerId);
                if (ok)
                    created++;
            }

            // 3) Ghi log thành công
            jobLog.setStatus("Success");
            jobLog.setRecordsCreated(created);
            jobLogDAO.create(jobLog);

            LOG.info("[Rule: " + rule.getRuleName() + "] Tạo thành công " + created + " tickets.");

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "[Rule: " + rule.getRuleName() + "] LỖI: " + e.getMessage(), e);

            jobLog.setStatus("Failed");
            jobLog.setRecordsCreated(0);
            jobLog.setErrorMessage(e.getMessage() != null ? e.getMessage() : e.toString());
            jobLogDAO.create(jobLog);
        }
    }

    /**
     * Query customers theo conditions_json của rule.
     * Hỗ trợ:
     * - targetType "Expiring": lastCareDate >= N ngày
     * - targetType "HighPotential": totalRevenue >= X
     * - conditions_json chứa các điều kiện bổ sung (tier, lastCareDate days,
     * totalRevenue)
     */
    private List<Integer> findMatchingCustomers(AutomationRule rule) throws SQLException {
        // Build dynamic SQL dựa trên targetType và conditions
        StringBuilder sql = new StringBuilder("SELECT id FROM Customers WHERE status = 'Active'");
        List<Object> params = new ArrayList<>();

        String condJson = rule.getConditionsJson();
        if (condJson != null && !condJson.isEmpty() && !"[]".equals(condJson)) {
            // Parse đơn giản — conditionsJson format:
            // [{"field":"lastCareDate","operator":">=","value":"30"}]
            // Dùng string parsing nhẹ thay vì import thêm Gson
            parseAndApplyConditions(sql, params, condJson);
        } else {
            // Fallback: dùng targetType mặc định
            switch (rule.getTargetType()) {
                case "Expiring":
                    sql.append(" AND (last_care_date IS NULL OR DATEDIFF(DAY, last_care_date, GETDATE()) >= 30)");
                    break;
                case "HighPotential":
                    sql.append(" AND total_revenue >= 100000000"); // 100 triệu
                    break;
                default:
                    break;
            }
        }

        List<Integer> ids = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = dbUtil.getConnection();
            stmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            rs = stmt.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("id"));
            }
        } finally {
            try {
                if (rs != null)
                    rs.close();
            } catch (SQLException e) {
            }
            try {
                if (stmt != null)
                    stmt.close();
            } catch (SQLException e) {
            }
            if (conn != null)
                dbUtil.closeConnection(conn);
        }
        return ids;
    }

    /**
     * Parse conditions_json đơn giản:
     * [{"field":"lastCareDate","operator":">=","value":"30"},{"field":"tier","operator":"=","value":"VIP"}]
     */
    private void parseAndApplyConditions(StringBuilder sql, List<Object> params, String condJson) {
        // Tách từng condition object
        // Format: [{ ... }, { ... }]
        String inner = condJson.trim();
        if (inner.startsWith("["))
            inner = inner.substring(1);
        if (inner.endsWith("]"))
            inner = inner.substring(0, inner.length() - 1);

        // Split by "},{"
        String[] parts = inner.split("\\},\\s*\\{");

        for (String part : parts) {
            part = part.replace("{", "").replace("}", "").trim();
            if (part.isEmpty())
                continue;

            String field = extractJsonValue(part, "field");
            String operator = extractJsonValue(part, "operator");
            String value = extractJsonValue(part, "value");

            if (field == null || operator == null || value == null)
                continue;

            switch (field) {
                case "lastCareDate":
                    // value = số ngày, VD: "30"
                    sql.append(" AND (last_care_date IS NULL OR DATEDIFF(DAY, last_care_date, GETDATE()) ");
                    sql.append(sanitizeOperator(operator));
                    sql.append(" ?)");
                    params.add(Integer.parseInt(value));
                    break;
                case "tier":
                    sql.append(" AND tier ");
                    sql.append(sanitizeOperator(operator));
                    sql.append(" ?");
                    params.add(value);
                    break;
                case "totalRevenue":
                    sql.append(" AND total_revenue ");
                    sql.append(sanitizeOperator(operator));
                    sql.append(" ?");
                    params.add(Double.parseDouble(value));
                    break;
                case "industry":
                    sql.append(" AND industry ");
                    sql.append(sanitizeOperator(operator));
                    sql.append(" ?");
                    params.add(value);
                    break;
                default:
                    LOG.warning("Unknown condition field: " + field);
            }
        }
    }

    /**
     * Trích giá trị JSON đơn giản: "key":"value"
     */
    private String extractJsonValue(String json, String key) {
        String search = "\"" + key + "\":\"";
        int idx = json.indexOf(search);
        if (idx == -1) {
            // Thử number format: "key":30
            search = "\"" + key + "\":";
            idx = json.indexOf(search);
            if (idx == -1)
                return null;
            int start = idx + search.length();
            int end = json.indexOf(",", start);
            if (end == -1)
                end = json.indexOf("}", start);
            if (end == -1)
                end = json.length();
            return json.substring(start, end).trim().replace("\"", "");
        }
        int start = idx + search.length();
        int end = json.indexOf("\"", start);
        if (end == -1)
            return null;
        return json.substring(start, end);
    }

    private String sanitizeOperator(String op) {
        switch (op) {
            case ">=":
                return ">=";
            case "<=":
                return "<=";
            case ">":
                return ">";
            case "<":
                return "<";
            case "=":
                return "=";
            case "!=":
                return "!=";
            default:
                return "=";
        }
    }

    /**
     * Tạo một Ticket nhắc việc cho NV Support.
     */
    private boolean createTicketForCustomer(AutomationRule rule, int customerId) {
        try {
            Ticket ticket = new Ticket();
            ticket.setCustomerId(customerId);
            ticket.setTitle("[Auto] " + rule.getRuleName());
            ticket.setDescription("Ticket tự động từ kịch bản: " + rule.getRuleName()
                    + ". Loại: " + rule.getTargetType()
                    + ". Hành động: " + rule.getActionType());
            ticket.setStatus("Open");
            ticket.setPriority("Medium");

            // Gán cho NV Support đã chọn trong rule
            if (rule.getAssignToUser() != null) {
                ticket.setAssignedTo(rule.getAssignToUser());
            }

            int ticketId = ticketService.createTicket(ticket);
            return ticketId > 0;

        } catch (Exception e) {
            LOG.log(Level.WARNING, "Lỗi tạo ticket cho customer " + customerId, e);
            return false;
        }
    }
}
