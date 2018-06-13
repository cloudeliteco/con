@isTest
private class Account_TriggerHandler_Test {
    static testmethod void test_simple_lead_conversion(){
        Integer numOfLeads = 3;
        String nameOfCompany = 'Test Co';
        List<Lead> test_leads = TestDataFactory.createLeadsWCompanyName(numOfLeads, nameOfCompany);
        
        test.StartTest();
		List<Lead> leadList = [SELECT Id, Company FROM Lead];
        System.assertEquals(numOfLeads, leadList.size());
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(test_leads[0].Id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        List<Lead> convertedLeadList = [SELECT Id, Company, Status FROM Lead WHERE Status = 'Disqualified'];
        System.assertEquals(numOfLeads - 1, convertedLeadList.size());
        
        test.stopTest();
        
    }
}