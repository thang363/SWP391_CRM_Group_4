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
    void createFromLead(int leadID,String leadName,long saleID);
    
    List<Opportunity> getOpportunitiesBySalesId(long salesId);
    
    void updateStage(long id, String stage, int probability);
    
    void updateOpportunityInfo(int id, String name);
}
