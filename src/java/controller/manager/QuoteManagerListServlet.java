package controller.manager;

import dao.QuoteDAO;
import dao.impl.QuoteDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Quote;
import model.entity.QuoteDetail;
import dao.QuoteDetailDAO;
import dao.impl.QuoteDetailDAOImpl;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "QuoteManagerListServlet", urlPatterns = {"/manager/quotes"})
public class QuoteManagerListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        QuoteDAO quoteDAO = new QuoteDAOImpl();
        QuoteDetailDAO quoteDetailDAO = new QuoteDetailDAOImpl();
        List<Quote> quoteList = quoteDAO.getAll();
        
        // Nạp thêm chi tiết sản phẩm vào mỗi quote để show modal
        for (Quote q : quoteList) {
            List<QuoteDetail> details = quoteDetailDAO.getByQuoteId(q.getId());
            q.setDetails(details);
        }
        
        // Mặc định Manager xem màn hình Báo Giá chỉ thấy những quote đang Pending Approval để duyệt
        // Có thể filter hoặc để tab
        String statusFilter = request.getParameter("status");
        if (statusFilter == null) {
            statusFilter = "Pending Approval"; // Default
        }

        if (!"All".equals(statusFilter)) {
            final String filter = statusFilter;
            quoteList = quoteList.stream()
                .filter(q -> filter.equals(q.getStatus()))
                .collect(Collectors.toList());
        }

        request.setAttribute("quoteList", quoteList);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("currentPage", "manager-quotes"); // Để active menu đúng
        
        request.getRequestDispatcher("/views/manager/manager-quote-list.jsp").forward(request, response);
    }
}
