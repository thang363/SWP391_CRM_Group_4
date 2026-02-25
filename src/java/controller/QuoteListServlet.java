package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "QuoteListServlet", urlPatterns = {"/sales/quotes"})
public class QuoteListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Mock data for frontend demonstration
        request.setAttribute("currentPage", "quotes");
        request.setAttribute("pageTitle", "Quote List");
        
        // Initializing empty list for JSP
        request.setAttribute("quoteList", new ArrayList<>());

        request.getRequestDispatcher("/views/sales/quote-list.jsp").forward(request, response);
    }
}
