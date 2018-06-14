@isTest
private class LeadProcessHighestTotal_Test {
    @testSetup 
    static void setup() {
        Integer max_leads = 4;
        Integer max_companys = 10;
        List<Lead> leads = new List<Lead>();
        
        for (Integer c = 0; c < max_companys; c++) {
            for(Integer l = 0 ; l < max_leads; l++){
                Lead new_lead = new Lead();
                new_lead.LastName = 'TestName-' + c + '-' + l;
                new_lead.Company = 'Company ' + c;
                new_lead.Priority_Allowed_Amount__c = (Math.random() * c) + (Math.random() * l) * 100;
                leads.add(new_lead);
            }
        }
        insert leads;
    }
    static testmethod void test() {        
        Test.startTest();
        LeadProcessHighestTotal process_leads = new LeadProcessHighestTotal();
        Id batchId = Database.executeBatch(process_leads);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(40, [select count() from Lead where Processed_for_Total__c = true]);
        System.assertEquals(10, [select count() from Lead where Status = 'Qualified']);
    }

}