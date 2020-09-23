/**
 * Created by JJ93 on 23.09.2020.
 */

public with sharing class LeadTriggerHandler {
    public static Boolean IS_FIRST_TRIGGER_RUN = true;
    LeadTriggerHandlerHelper helper = new LeadTriggerHandlerHelper();
    //checks that firstname, lastname, email and phone are provided
    public void beforeInsert(List<Lead> newLeads) {
        helper.checkRequiredFields(newLeads);

    }
//creating new connection task according to new leads
    public void afterInsert(List<Lead> newLeads) {
        helper.createTaskToCallNewLead(newLeads);
    }

    // Restricts access for updating firstname and lastname fields
    public void beforeUpdate(Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {
        helper.restrictNameUpdate(oldMap, newMap);
    }
//!!!RECURSION DETECTED!!! this method makes updates on Descriptions that calling other updates
    public void afterUpdate(Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {
        helper.updateDescriptions(oldMap, newMap);

    }

//checks that status is one of the 'negotiations-end' types
    public void beforeDelete(List<Lead> oldLeads, Map<Id, Lead> oldLeadsMap) {
        helper.checkStatusClosedOrConverted(oldLeads, oldLeadsMap);

    }
//creating task to include deleted Lead in common report
    public void afterDelete(List<Lead> oldLeads, Map<Id, Lead> oldLeadsMap) {
        helper.newTaskDueToRemovalOfLead(oldLeads, oldLeadsMap);
    }
//creating new connection task according to undeleted leads
    public void afterUndelete(List<Lead> newLeads) {
        helper.createTaskToCallNewLead(newLeads);
    }


}