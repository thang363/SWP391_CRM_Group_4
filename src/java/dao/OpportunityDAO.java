/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dao;

import java.util.List;
import model.entity.Lead;
import model.entity.Opportunity;

/**
 *
 * @author ADMIN
 */
public interface OpportunityDAO {
    void createFromLead(int leadID,String leadName,int saleID);

    void createFromCustomer(int customerID, String companyName, int saleID);

    List<Opportunity> getOpportunitiesBySalesId(int salesId);

    /** Lấy cả quoteCount theo JOIN */
    List<Opportunity> getOpportunitiesWithQuoteCount(int salesId);

    /** Lấy 1 opportunity theo id */
    Opportunity getById(int id);

    void updateStage(int id, String stage, int probability);

    void updateOpportunityInfo(int id, String name);

    /** Search and filter opportunities */
    List<Opportunity> searchOpportunities(int salesId, String search, String stage);

    void updateExpectedValue(int id, java.math.BigDecimal value);
}

