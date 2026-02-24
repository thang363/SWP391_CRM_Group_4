/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package dao;

import model.entity.Lead;

/**
 *
 * @author ADMIN
 */
public interface OpportunityDAO {
    void createFromLead(int leadID,String leadName,long saleID);
}
