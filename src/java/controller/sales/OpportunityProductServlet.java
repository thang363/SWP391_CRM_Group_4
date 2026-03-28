package controller.sales;

import dao.OpportunityProductDAO;
import dao.impl.OpportunityProductDAOImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.OpportunityProduct;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "OpportunityProductServlet", urlPatterns = {"/sales/opportunity-product"})
public class OpportunityProductServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String oppIdParam = request.getParameter("opportunityId");

        if (oppIdParam == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/sales/opportunities");
            return;
        }

        try {
            int oppId = Integer.parseInt(oppIdParam);
            OpportunityProductDAO opDAO = new OpportunityProductDAOImpl();

            if ("add".equals(action)) {
                String productIdParam = request.getParameter("productId");
                String quantityParam = request.getParameter("quantity");
                String priceParam = request.getParameter("salesPrice");

                if (productIdParam != null && quantityParam != null && priceParam != null) {
                    OpportunityProduct op = new OpportunityProduct();
                    op.setOpportunityId(oppId);
                    op.setProductId(Integer.parseInt(productIdParam));
                    int qty = Integer.parseInt(quantityParam);
                    op.setQuantity(qty);
                    BigDecimal price = new BigDecimal(priceParam.replace(",", ""));
                    op.setSalesPrice(price);
                    op.setTotalAmount(price.multiply(new BigDecimal(qty)));

                    opDAO.create(op);
                    updateOpportunityValue(oppId);
                }
            } else if ("delete".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null) {
                    opDAO.delete(Integer.parseInt(idParam));
                    updateOpportunityValue(oppId);
                }
            }

            response.sendRedirect(request.getContextPath() + "/sales/opportunity-detail?id=" + oppId + "&tab=products");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/sales/opportunities");
        }
    }

    private void updateOpportunityValue(int oppId) {
        try {
            dao.OpportunityDAO oppDAO = new dao.impl.OpportunitiesDaoImpl();
            dao.OpportunityProductDAO opDAO = new dao.impl.OpportunityProductDAOImpl();
            java.util.List<OpportunityProduct> products = opDAO.getByOpportunityId(oppId);
            BigDecimal total = BigDecimal.ZERO;
            for (OpportunityProduct p : products) {
                total = total.add(p.getTotalAmount());
            }
            oppDAO.updateExpectedValue(oppId, total);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
