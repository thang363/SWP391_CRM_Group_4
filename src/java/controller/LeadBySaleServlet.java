/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import model.entity.Lead;
import dao.LeadDAO;
import dao.impl.LeadDAOImpl;
import jakarta.servlet.http.HttpSession;
import model.entity.User;
import util.DatabaseUtil;
import util.Constants;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "LeadBySaleServlet", urlPatterns = {"/sales/leads"})
public class LeadBySaleServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("pageTitle", "Sales Pipeline");
            List<Lead> lead_list = new ArrayList<>();
            LeadDAO ld = new LeadDAOImpl();
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("currentUser");
            if (user != null) {
                String searchQuery = request.getParameter("search");
                String statusFilter = request.getParameter("status");

                // Keep parameters in request for UI state retention
                request.setAttribute("searchQuery", searchQuery != null ? searchQuery : "");
                request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "");

                lead_list = ld.searchLeads(user.getId(), searchQuery, statusFilter);
            } else {
                System.out.println("No user found in session for LeadBySaleServlet");
            }
            
            request.setAttribute("leadList", lead_list != null ? lead_list : new ArrayList<>());

            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/sales/leadbysale.jsp");
            dispatcher.forward(request, response);
            
        } catch (Throwable t) {
            String msg = t.getMessage() != null ? t.getMessage() : t.toString();
            System.err.println("CRITICAL ERROR in LeadBySaleServlet: " + msg);
            t.printStackTrace();
            throw new ServletException("LeadBySaleServlet error: " + msg, t);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int leadID = Integer.parseInt(request.getParameter("leadId"));
            String status = request.getParameter("status");
            LeadDAO ld = new LeadDAOImpl();
            ld.updateLeadStatus(leadID, status);
        } catch (Exception e) {
            System.err.println("Error in LeadBySaleServlet doPost: " + e.getMessage());
            e.printStackTrace();
        }
        response.sendRedirect("leads"); // relative redirect still works within /sales/
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
