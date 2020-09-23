/**
 * Created by JJ93 on 23.09.2020.
 */

public with sharing class LeadTriggerHandlerHelper {

//creating new connection task according to new leads
    public void createTaskToCallNewLead(List<Lead> newLeads) {
        List <Task> tasks = new List<Task>();
        for (Lead lead : newLeads) {
            Task task = new Task();
            task.Description = 'Plz call ' + lead.FirstName + ' ' + lead.LastName;
            task.Subject = 'NEW LEAD: ' + lead.FirstName + ' ' + lead.LastName;
            tasks.add(task);
        }
        insert(tasks);
    }
//checks that firstname,lastname,email and phone are provided
    public void checkRequiredFields(List<Lead> newLeads) {

        for (Lead lead : newLeads) {
            if (lead.Email == null) {
                lead.addError('Enter email');
            }
            if (lead.Phone == null) {
                lead.addError('Enter phone');
            }
        }
    }

// Restricts access for updating firstname and lastname fields
    public void restrictNameUpdate(Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {
        for (Id id : oldMap.keySet()) {
            if (!(oldMap.get(id).FirstName.equals(newMap.get(id).FirstName))) {
                newMap.get(id).addError('U R not allowed to update FirstName');
            }
            if (!(oldMap.get(id).LastName.equals(newMap.get(id).LastName))) {
                newMap.get(id).addError('U R not allowed to update LastName');
            }

        }
    }
//!!!RECURSION DETECTED!!! this method makes updates on Descriptions that calling other updates
    public void updateDescriptions(Map<Id, Lead> oldMap, Map<Id, Lead> newMap) {
        Integer i = 1;
        List<Lead> leads = [SELECT FirstName FROM Lead WHERE Id IN :newMap.keySet()];
        for (Lead lead : leads) {
            lead.Description = 'It was updated ' + i + ' times';
            i++;
        }
        update leads;
    }
//checks that status is one of the 'negotiations-end' types
    public void checkStatusClosedOrConverted(List<Lead> oldLeads, Map<Id, Lead> oldLeadsMap) {
        for (Lead lead : oldLeads) {
            if (!(lead.Status.equals('Closed - Not Converted') || lead.Status.equals('Closed - Converted'))) {
                lead.addError('U did not process the negotiations with that lead to complete stage');
            }
        }
    }
//creating task to include deleted Lead in common report
    public void newTaskDueToRemovalOfLead(List<Lead> oldLeads, Map<Id, Lead> oldLeadsMap) {
        List <Task> tasks = new List<Task>();
        for (Lead lead : oldLeads) {
            Task task = new Task();
            task.Description = 'Plz make a note about this lead: ***' + lead.FirstName + ' '
                    + lead.LastName + '*** in report to your manager ' ;
            task.Subject = 'LEAD ***' + lead.FirstName + '' + lead.LastName + '*** REMOVAL';
            tasks.add(task);
        }
        insert(tasks);
    }


}