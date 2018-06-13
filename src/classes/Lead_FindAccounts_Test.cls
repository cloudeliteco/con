@isTest
private class Lead_FindAccounts_Test {
	static testmethod void test_simple_lead_run(){
        
        String nameOfCompany = 'Test Co';
        // need to add account first to not disqualify the leads
        Account dupe_account = TestDataFactory.createAccountWCompanyName(nameOfCompany);
        
        test.startTest();
        
        Integer numOfLeads = 10;
        List<Lead> test_leads = TestDataFactory.createLeadsWCompanyName(numOfLeads, nameOfCompany);

        
        //Lead_FindAccounts process_leads = new Lead_FindAccounts();
        //Id batchId = Database.executeBatch(process_leads);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(numOfLeads, [select count() from Lead where Status = 'Unqualified']);
    }
    
    static testmethod void test_simple_lead_run_from_batch(){
        
        String nameOfCompany = 'Test Co';
        // need to add account first to not disqualify the leads
        Account dupe_account = TestDataFactory.createAccountWCompanyName(nameOfCompany);
        
        Integer numOfLeads = 10;
        List<Lead> test_leads = TestDataFactory.createLeadsWCompanyName(numOfLeads, nameOfCompany);

        test.startTest();
        Lead_FindAccounts process_leads = new Lead_FindAccounts();
        Id batchId = Database.executeBatch(process_leads);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(numOfLeads, [select count() from Lead where Status = 'Unqualified']);
    }
}