package dao;

import model.entity.Customer;
import java.util.List;

/**
 * Giao diện Data Access Object phụ trách các thao tác về Khách Hàng.
 */
public interface CustomerDAO {
    
    /**
     * Tìm kiếm khách hàng bằng cách khớp từ khóa với tên công ty, email hoặc số điện thoại.
     * @param keyword Chuỗi tìm kiếm
     * @return Danh sách khách hàng phù hợp (Tối đa hiển thị top 20)
     */
    List<Customer> searchCustomers(String keyword);

    /**
     * Lấy thông tin một khách hàng cụ thể theo ID.
     * @param id ID khách hàng
     * @return Đối tượng Khách Hàng nếu tìm thấy, ngược lại là null
     */
    Customer getCustomerById(int id);
    
    /**
     * Tìm khách hàng dựa trên địa chỉ email chính xác.
     * @param email Địa chỉ email
     * @return Đối tượng Khách Hàng nếu tìm thấy, ngược lại là null
     */
    Customer findCustomerByEmail(String email);

    /**
     * Tạo một hồ sơ Khách Hàng mới từ một Cơ Hội (Opportunity) có sẵn và Khách Hàng Tiềm Năng (Lead) của nó.
     * Cập nhật 'customer_id' của Cơ Hội đó để liên kết với Khách Hàng mới tạo.
     * @param opportunityId ID của Cơ Hội cần chuyển đổi
     * @throws Exception Lỗi nếu Cơ Hội không tồn tại hoặc không đính kèm Lead
     */
    void createFromOpportunity(int opportunityId) throws Exception;

    /**
     * Cập nhật trường 'last_care_date' (Ngày chăm sóc gần nhất) cho một khách hàng.
     * @param id ID khách hàng
     * @param date Cột mốc thời gian chăm sóc mới
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    boolean updateLastCareDate(int id, java.sql.Timestamp date);

    /**
     * Lấy danh sách toàn bộ khách hàng trong cơ sở dữ liệu (Sắp xếp theo ID giảm dần).
     * @return Danh sách tất cả khách hàng
     */
    List<Customer> getAllCustomers();

    /**
     * Lấy danh sách khách hàng có phân trang và áp dụng bộ lọc.
     * @param offset Bỏ qua số lượng hàng đầu tiên
     * @param limit Số lượng hiển thị tối đa trên 1 trang
     * @param searchQuery Tìm kiếm theo tên công ty, email hoặc SĐT
     * @param tierFilter Lọc theo Cấp Bậc (VD: VIP, Standard), hoặc "All" để bỏ bộ lọc
     * @param statusFilter Lọc theo Trạng Thái (VD: Active, Inactive), hoặc "All" để bỏ bộ lọc
     * @return Danh sách đối tượng Khách Hàng phù hợp
     */
    List<Customer> getCustomers(int offset, int limit, String searchQuery, String tierFilter, String statusFilter);

    /**
     * Đếm tổng số lượng khách hàng trùng khớp với bộ lọc (Dùng để tính số trang pagination).
     */
    int getTotalCustomersCount(String searchQuery, String tierFilter, String statusFilter);

    /**
     * Lấy danh sách phân trang các khách hàng được chỉ định duy nhất cho một Nhân viên kinh doanh (Sales ID).
     */
    List<Customer> getCustomersBySalesId(int salesId, int offset, int limit, String searchQuery, String tierFilter, String statusFilter);

    /**
     * Đếm tổng số lượng khách hàng được phân công cho một Sales ID trùng khớp với bộ lọc.
     */
    int getTotalCustomersCountBySalesId(int salesId, String searchQuery, String tierFilter, String statusFilter);

    /**
     * Chèn một hồ sơ Khách Hàng mới vào cơ sở dữ liệu.
     * @param customer Đối tượng Khách Hàng chứa chi tiết khung dữ liệu
     * @return true nếu thêm thành công, ngược lại là false
     */
    boolean createCustomer(Customer customer);

    /**
     * Cập nhật thông tin chi tiết của một Khách Hàng tồn tại sẵn.
     * @param customer Đối tượng Khách Hàng chứa thông tin đã sửa đổi
     * @return true nếu cập nhật thành công, ngược lại là false
     */
    boolean updateCustomer(Customer customer);

    /**
     * Xóa một Khách Hàng khỏi cơ sở dữ liệu.
     * @param id ID của khách hàng cần xóa
     * @return true nếu xóa thành công, false nếu xuất hiện lỗi (VD: Bị vướng khóa ngoại do chưa xóa dữ liệu rác)
     */
    boolean deleteCustomer(int id);

    /**
     * Thay đổi nhanh cấp độ (Tier) của một Khách Hàng.
     * @param id ID khách hàng
     * @param tier Cấp bậc mới
     * @return true nếu thao tác thành công
     */
    boolean setCustomerTier(int id, String tier);

    /**
     * Gộp một hồ sơ khách hàng trùng lặp vào một hồ sơ chính thức (Gộp hồ sơ).
     * Dịch chuyển mọi dữ liệu liên kết (Cơ Hội, Liên Hệ, Vé hỗ trợ, Đánh giá) cực kỳ cẩn trọng
     * từ hồ sơ Trùng Lặp sang Hồ sơ Chính, sau đó tự động xóa Hồ sơ trùng lặp đó.
     * @param primaryId ID của khách hàng (Bản chuẩn) được giữ lại
     * @param duplicateId ID của khách hàng trùng lặp sẽ bị gộp và xóa đi
     * @return true nếu toàn bộ quá trình Transaction cục bộ thành công, false nếu gặp lỗi giữa đường thao tác
     */
    boolean mergeCustomers(int primaryId, int duplicateId);

    boolean updateCustomerStatus(int id, String status);

    /**
     * Checks if a tax code already exists in the database, excluding a specific customer ID.
     */
    boolean checkTaxCodeExist(String taxCode, Integer excludeId);

    /**
     * Checks if an email already exists in the database, excluding a specific customer ID.
     */
    boolean checkEmailExist(String email, Integer excludeId);

    /**
     * Checks if a company name already exists in the database, excluding a specific customer ID.
     */
    boolean checkCompanyNameExist(String companyName, Integer excludeId);
}
