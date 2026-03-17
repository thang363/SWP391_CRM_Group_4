package controller.lead;

import dao.LeadDAO;
import dao.OpportunityDAO;
import dao.impl.LeadDAOImpl;
import dao.impl.OpportunitiesDaoImpl;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "EditLeadbySaleServlet", urlPatterns = {"/EditLeadbySaleServlet"})
public class EditLeadbySaleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to lead list if accessed via GET
         request.setCharacterEncoding("UTF-8");
        try {
            int id = Integer.parseInt(request.getParameter("leadId"));
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");

            LeadDAO leadDAO = new LeadDAOImpl();
            leadDAO.updateLeadInfo(id, name, phone);

            // Quay lại danh sách lead sau khi cập nhật thành công
            response.sendRedirect(request.getContextPath() + "/sales/leads");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/sales/leads?error=1");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       try{
           int id = Integer.parseInt(request.getParameter("opportunityId"));
           String name = request.getParameter("name");
           OpportunityDAO oop = new OpportunitiesDaoImpl();
           oop.updateOpportunityInfo(id, name);
           response.sendRedirect(request.getContextPath() + "/sales/opportunities");
       }catch(Exception e){
           e.printStackTrace();
       }
    }
}
