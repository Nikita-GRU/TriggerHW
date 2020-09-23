/**
 * Created by JJ93 on 23.09.2020.
 */

//Ask for test setup(insert Lead)
@IsTest
private class LeadTriggerTest {
    @IsTest
    static void beforeInsertWithoutEmailTest() {
        Lead lead = LeadTriggerTestHelper.createTestLeadWithoutEmail();
        Test.startTest();
        Database.SaveResult result = Database.insert(lead, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Enter email',
                result.getErrors()[0].getMessage());
    }
    @IsTest
    static void beforeInsertWithoutPhoneTest() {
        Lead lead = LeadTriggerTestHelper.createTestLeadWithoutPhone();
        Test.startTest();
        Database.SaveResult result = Database.insert(lead, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Enter phone',
                result.getErrors()[0].getMessage());
    }
    @IsTest
    static void beforeInsertPositiveTest() {
        Lead lead = LeadTriggerTestHelper.createTestLead();
        Test.startTest();
        Database.SaveResult result = Database.insert(lead, false);
        Test.stopTest();
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() == 0);
    }
    @IsTest
    static void afterInsertTest() {
        Lead lead = LeadTriggerTestHelper.createTestLead();
        Test.startTest();
        insert(lead);

        List<Task> tasks = [
                SELECT Subject
                FROM Task
                WHERE Subject = :'NEW LEAD: ' + lead.FirstName + ' ' + lead.LastName
        ];
        Test.stopTest();
        System.assert(tasks.size() > 0);
    }
    @IsTest
    static void beforeUpdateFirstNameTriggerErrorTest() {
        Lead lead = LeadTriggerTestHelper.createTestLead();
        Test.startTest();
        insert lead;
        String beforeUpdateFirstName = lead.FirstName;
        lead.FirstName = lead.FirstName + 'TEST';
        Database.SaveResult result = Database.update(lead, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('U R not allowed to update FirstName',
                result.getErrors()[0].getMessage());
    }
    @IsTest
    static void beforeUpdateLastNameTriggerErrorTest() {
        Lead lead = LeadTriggerTestHelper.createTestLead();
        Test.startTest();
        insert lead;
        String beforeUpdateLastName = lead.LastName;
        lead.LastName = lead.LastName + 'TEST';
        Database.SaveResult result = Database.update(lead, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('U R not allowed to update LastName',
                result.getErrors()[0].getMessage());
    }
//(QUESTION)!!!!!!!!!!!!
    @IsTest
    static void afterUpdateTest() {
        Lead lead = LeadTriggerTestHelper.createTestLead();
        Test.startTest();
        insert lead;
        lead.AnnualRevenue = 100;
        // lead.Description = 'It was updated 1 times';
        update lead;
        List<Lead> updatedLeads = [
                SELECT Description
                FROM Lead
                WHERE FirstName = :lead.FirstName
                AND LastName = :lead.LastName
                AND Email = :lead.Email
        ];
        Test.stopTest();
        System.assert(!updatedLeads.isEmpty());
        System.assertEquals('It was updated 1 times', updatedLeads[0].Description);


    }
    @IsTest
    static void beforeDeleteTest() {
        Lead lead = LeadTriggerTestHelper.createTestLead();
        lead.Status = 'Working - Contacted';
        Test.startTest();
        insert lead;
        Database.DeleteResult result = Database.delete(lead, false);
        Test.stopTest();
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('U did not process the negotiations with that lead to complete stage',
                result.getErrors()[0].getMessage());
    }
    @IsTest
    static void afterDeleteTest() {
        Lead lead = LeadTriggerTestHelper.createTestLead();
        lead.Status = 'Closed - Not Converted';
        Test.startTest();
        insert lead;
        delete lead;
        List<Task> tasks = [
                SELECT Subject
                FROM Task
                WHERE Subject = :'LEAD ***' + lead.FirstName + '' + lead.LastName + '*** REMOVAL'
        ];
        Test.stopTest();
        System.assert(tasks.size() > 0);
    }
    @IsTest
    static void afterUndeleteTest() {
        Lead lead = LeadTriggerTestHelper.createTestLead();
        lead.Status = 'Closed - Not Converted';
        Test.startTest();
        insert lead;
        delete lead;
        undelete lead;
        List<Task> tasks = [
                SELECT Subject
                FROM Task
                WHERE Subject = :'NEW LEAD: ' + lead.FirstName + ' ' + lead.LastName
        ];
        Test.stopTest();
        System.assert(tasks.size() > 0);
    }
    }

