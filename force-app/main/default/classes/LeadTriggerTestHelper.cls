/**
 * Created by JJ93 on 23.09.2020.
 */

public with sharing class LeadTriggerTestHelper {
    public static Lead createTestLeadWithoutEmail() {
        Lead lead = new Lead();
        lead.FirstName = 'TestName';
        lead.LastName = 'TestLastName';
        lead.Company = 'Test Company';
        lead.Phone = '123123';
        lead.Title = 'Test Title';
        return lead;
    }
    public static Lead createTestLead() {
        Lead lead = new Lead();
        lead.FirstName = 'TestName';
        lead.LastName = 'TestLastName';
        lead.Company = 'Test Company';
        lead.Phone = '123123';
        lead.Email = 'test@example.com';
        lead.Title = 'Test Title';
        return lead;
    }

    public static Lead createTestLeadWithoutPhone() {
        Lead lead = new Lead();
        lead.FirstName = 'TestName';
        lead.LastName = 'TestLastName';
        lead.Company = 'Test Company';
        lead.Email = 'ttt@tt.tt';
        lead.Title = 'Test Title';
        return lead;
    }
}