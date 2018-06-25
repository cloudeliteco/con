@isTest
private class Account_TriggerHandler_Test {
    static testmethod void test_simple_lead_conversion(){
        
        Integer numOfLeads = 3;
        String nameOfCompany = 'Test Co';
        List<Lead> test_leads = TestDataFactory.createLeadsWCompanyName(numOfLeads, nameOfCompany);
        for(Lead l : test_leads){
            l.Type__c = 'Competitor';
        }
        insert test_leads;
        
        test.StartTest();
		List<Lead> leadList = [SELECT Id, Company FROM Lead];
        
        System.assertEquals(numOfLeads, leadList.size());
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(test_leads[0].Id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        List<Opportunity> new_opps = [SELECT Id, Name, Bankrupcy__c , Debtor__c  FROM Opportunity];
        System.debug('new_opps');
        System.debug(new_opps);
        
        List<account> accounts = [SELECT Id, Name, RecordType.Name, Type, LeadType__c  FROM Account];
        System.debug('accounts');
        System.debug(accounts);
        
        List<Lead> leads_now = [SELECT Id, Name, Status FROM Lead];
        System.debug('leads_now');
        System.debug(leads_now);
        
        
        List<Lead> convertedLeadList = [SELECT Id, Company, Status, Account_matched__c FROM Lead WHERE Status = 'Unqualified'];
        System.assertEquals(numOfLeads - 1, convertedLeadList.size());
        
        test.stopTest();
        
    }
    

}